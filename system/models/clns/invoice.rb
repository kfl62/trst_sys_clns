# encoding: utf-8
module Clns
  class Invoice
    include Mongoid::Document
    include Mongoid::Timestamps
    include Trst::ViewHelpers
    include Trst::DateHelpers

    field :name,        type: String
    field :id_date,     type: Date,     default: -> {Date.today}
    field :id_intern,   type: Boolean,  default: false
    field :doc_name,    type: String
    field :sum_100,     type: Float,    default: 0.00
    field :sum_tva,     type: Float,    default: 0.00
    field :sum_out,     type: Float,    default: 0.00
    field :deadl,       type: Date,     default: -> {Date.today}
    field :payed,       type: Boolean,  default: false

    alias :file_name :name

    embeds_many :freights,     class_name: "Clns::InvoiceFreight",      inverse_of: :doc_inv, cascade_callbacks: true
    has_many    :dlns,         class_name: "Clns::DeliveryNote",        inverse_of: :doc_inv
    has_many    :grns,         class_name: "Clns::Grn",                 inverse_of: :doc_inv
    has_many    :pyms,         class_name: "Clns::Payment",             inverse_of: :doc_inv, dependent: :delete
    belongs_to  :client,       class_name: "Clns::PartnerFirm",         inverse_of: :invs_client
    belongs_to  :client_d,     class_name: "Clns::PartnerFirm::Person", inverse_of: :invs_client
    belongs_to  :signed_by,    class_name: "Clns::User",                inverse_of: :invs

    after_save    :'handle_dlns(true)'
    after_destroy :'handle_dlns(false)'

    accepts_nested_attributes_for :dlns, :grns
    accepts_nested_attributes_for :freights,
      reject_if: ->(attrs){ attrs[:qu].to_f == 0 }
    accepts_nested_attributes_for :pyms,
      reject_if: ->(attrs){ attrs[:val].empty? }

    class << self
      # @todo
      def nonin(nin = true)
        where(id_intern: !nin)
      end
      # @todo
      def auto_search(params)
        day = params[:day].split('-').map(&:to_i)
        where(id_date: Date.new(*day))
        .or(doc_name: /#{params[:q]}/i)
        .or(:client_id.in => Clns::PartnerFirm.only(:id).where(name: /#{params[:q]}/i).map(&:id))
        .each_with_object([]) do |i,a|
          a << {id: i.id,
                text: {
                        name:  i.name,
                        title: i.freights_list.join("\n"),
                        doc_name: i.doc_name,
                        client:   i.client.name[1]}}
        end
      end
    end # Class methods
    # @todo
    def client_d
      Clns::PartnerFirm.person_by_person_id(client_d_id) rescue nil
    end
    # @todo
    def increment_name
      firm = Clns::PartnerFirm.find_by(:firm => true)
      invs = Clns::Invoice.yearly(Date.today.year).nonin
      if invs.count > 0
        name = invs.asc(:name).last.name.next
      else
        prfx = Date.today.year.to_s[-2..-1]
        name = "#{firm.name[0][0..2].upcase}_INV-#{prfx}00001"
      end
      name
    end
    # @todo
    def freights_list
      freights.asc(:id_stats).each_with_object([]) do |f,r|
        r << "#{f.name}: #{"%.2f" % f.qu} #{f.um} ( #{"%.2f" % f.pu} )"
      end
    end
    # @todo
    def pyms_list
      pyms.asc(:id_date).each_with_object([]) do |p,r|
        val = p.val || 0.0
        if
          deadl > p.id_date
          txt = 'La termen'
          txt+= ": #{"%.2f" % val}" if val > 0
          r << txt
        else
          r << "#{p.id_date.to_s}: #{p.text}, #{"%.2f" % val}"
        end
      end.unshift("Termen: #{deadl.to_s}")
    end
    protected
    # @todo
    def handle_dlns(add_delete)
      dlns.each{|dln| dln.set(:charged,add_delete)}
      grns.each{|grn| grn.set(:charged,add_delete)}
      freights.each do |f|
        dlns.each do |dn|
          dn.freights.each do |dnf|
            if add_delete
              dnf.set(:pu_invoice,f.pu) if (dnf.id_stats == f.id_stats && dnf.pu_invoice == 0.0)
            else
              dnf.set(:pu_invoice, 0.0)
            end
            dnf.set(:val_invoice,(dnf.qu * dnf.pu_invoice).round(2))
            dnf.set(:tva_invoice,(dnf.val_invoice * dnf.freight.tva).round(2))
            dnf.set(:out_invoice,(dnf.val_invoice + dnf.tva_invoice).round(2))
          end
        end
      end
    end
  end # Invoice

  class InvoiceFreight < Trst::Freight
    field :qu,          type: Float,     default: 0.00
    field :val,         type: Float,     default: 0.00
    field :tva,         type: Float,     default: 0.00
    field :tot,         type: Float,     default: 0.00


    embedded_in :doc_inv, class_name: "Clns::Invoice",  inverse_of: :freights
  end # InvoiceFreight
end # Clns

