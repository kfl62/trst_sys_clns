# encoding: utf-8
module Clns
  class Grn
    include Mongoid::Document
    include Mongoid::Timestamps
    include Trst::ViewHelpers
    include Trst::DateHelpers

    field :name,        type: String
    field :id_date,     type: Date,     default: -> {Date.today}
    field :id_intern,   type: Boolean,  default: false
    field :doc_type,    type: String
    field :doc_name,    type: String
    field :doc_date,    type: Date
    field :doc_plat,    type: String
    field :sum_100,     type: Float,    default: 0.00
    field :sum_tva,     type: Float,    default: 0.00
    field :sum_out,     type: Float,    default: 0.00
    field :charged,     type: Boolean,  default: false

    alias :file_name :name

    has_many   :freights,     class_name: "Clns::FreightIn",        inverse_of: :doc_grn, dependent: :destroy
    has_many   :dlns,         class_name: "Clns::DeliveryNote",     inverse_of: :doc_grn
    belongs_to :supplr,       class_name: "Clns::PartnerFirm",      inverse_of: :grns_supplr
    belongs_to :supplr_d,     class_name: "Clns::PartnerFirmPerson",inverse_of: :grns_supplr
    belongs_to :doc_inv,      class_name: "Clns::Invoice",          inverse_of: :grns
    belongs_to :unit,         class_name: "Clns::PartnerFirmUnit",  inverse_of: :grns
    belongs_to :signed_by,    class_name: "Clns::User",             inverse_of: :grns

    index({ unit_id: 1, id_date: 1 })

    after_save    :'handle_dlns(true)'
    after_save    :'handle_invs(true)'
    after_destroy :'handle_dlns(false)'
    after_destroy :'handle_invs(false)'

    scope :by_unit_id, ->(unit_id) {where(unit_id: unit_id)}

    accepts_nested_attributes_for :dlns
    accepts_nested_attributes_for :freights,
      reject_if: ->(attrs){ attrs[:qu].to_f == 0 }

    class << self
      # @todo
      def pos(s)
        where(unit_id: Clns::PartnerFirm.pos(s).id)
      end
      # @todo
      def nonin(nin = true)
        where(id_intern: !nin)
      end
      # @todo
      def charged(b = true)
        where(charged: b)
      end
      # @todo
      def auto_search(params)
        unit_id = params[:uid]
        day     = params[:day].split('-').map(&:to_i)
        where(unit_id: unit_id,id_date: Date.new(*day))
        .or(doc_name: /#{params[:q]}/i)
        .or(:supplr_id.in => Clns::PartnerFirm.only(:id).where(name: /#{params[:q]}/i).map(&:id))
        .each_with_object([]) do |g,a|
          a << {id: g.id,
                text: {
                        name:  g.name,
                        title: g.freights_list.join("\n"),
                        doc_name: g.doc_name,
                        supplier: g.supplr.name[1]}}
        end
      end
      # @todo
      def sum_freights_grn
        all.each_with_object({}) do |grn,s|
          grn.freights.asc(:id_stats).each_with_object(s) do |f,s|
            if s[f.key].nil?
              s[f.key] = [f.freight.name,f.freight.id_stats,f.um,f.pu,f.qu,f.val,f.tva,f.out]
            else
              s[f.key][4] += f.qu
              s[f.key][5] += f.val
              s[f.key][6] += f.tva
              s[f.key][7] += f.out
            end
          end
        end
      end
      # @todo
    end # Class methods

    # @todo
    def unit
      Clns::PartnerFirm.unit_by_unit_id(unit_id) rescue nil
    end
    # @todo
    def supplr_d
      Clns::PartnerFirm.person_by_person_id(supplr_d_id) rescue nil
    end
    # @todo
    def increment_name(unit_id)
      grns = Clns::Grn.by_unit_id(unit_id).yearly(Date.today.year)
      if grns.count > 0
        name = grns.asc(:name).last.name.next
      else
        unit = Clns::PartnerFirm.unit_by_unit_id(unit_id)
        prfx = Date.today.year.to_s[-2..-1]
        name = "#{unit.firm.name[0][0..2].upcase}_#{unit.slug}_NIR-#{prfx}00001"
      end
      name
    end
    # @todo
    def freights_list
      freights.asc(:id_stats).each_with_object([]) do |f,r|
        r << "#{f.freight.name}: #{"%.2f" % f.qu} #{f.um} ( #{"%.4f" % f.pu} )"
      end
    end
    protected
    # @todo
    def handle_dlns(add_remove)
      dlns.each{|dln| dln.set(:charged,add_remove)}
      dlns.each{|dln| dln.set(:doc_grn_id,nil)} if add_remove == false
    end
    # @todo
    def handle_invs(add_remove)
      if add_remove
        inv = Clns::Invoice.create(
          name:         doc_name,
          id_date:      doc_date,
          id_intern:    true,
          doc_name:     doc_name,
          sum_100:      sum_100,
          sum_tva:      sum_tva,
          sum_out:      sum_out,
          deadl:        self[:deadl] || Date.today + 30.days,
          payed:        false,
          client_id:    supplr_id,
          client_d_id:  supplr_d_id || (supplr.people.first.id rescue nil),
          signed_by_id: signed_by.id
        )
        unset(:deadl)
        freights.each do |f|
          inv.freights.create(
            name:     f.freight.name,
            um:       f.freight.um,
            id_stats: f.id_stats,
            qu:       f.qu,
            pu:       f.pu
          )
        end
        if self[:pyms]
          inv.pyms.create(self[:pyms]) if self[:pyms][:val] != 0.0
        end
        unset(:pyms)
        set(:charged,true)
        set(:doc_inv_id,inv.id)
      else
        doc_inv.delete
      end if doc_type == 'INV'
    end
  end # Grn
end # wstm
