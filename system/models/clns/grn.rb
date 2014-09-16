# encoding: utf-8
module Clns
  class Grn < Trst::Grn

    has_many   :freights,     class_name: "Clns::FreightIn",          inverse_of: :doc_grn, dependent: :destroy
    has_many   :dlns,         class_name: "Clns::DeliveryNote",       inverse_of: :doc_grn
    belongs_to :supplr,       class_name: "Clns::PartnerFirm",        inverse_of: :grns_supplr
    belongs_to :supplr_d,     class_name: "Clns::PartnerFirm::Person",inverse_of: :grns_supplr
    belongs_to :doc_inv,      class_name: "Clns::Invoice",            inverse_of: :grns
    belongs_to :unit,         class_name: "Clns::PartnerFirm::Unit",  inverse_of: :grns
    belongs_to :signed_by,    class_name: "Clns::User",               inverse_of: :grns

    alias :file_name :name; alias :unit :unit_belongs_to

    index({ unit_id: 1, id_date: 1 })

    after_save    :'handle_dlns(true)'
    after_save    :'handle_invs(true)'
    after_destroy :'handle_dlns(false)'
    after_destroy :'handle_invs(false)'

    accepts_nested_attributes_for :dlns
    accepts_nested_attributes_for :freights,
      reject_if: ->(attrs){ attrs[:qu].to_f == 0 }

    class << self
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
