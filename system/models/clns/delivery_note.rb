# encoding: utf-8
module Clns
  class DeliveryNote < Trst::DeliveryNote

    has_many   :freights,     class_name: "Clns::FreightOut",           inverse_of: :doc_dln, dependent: :destroy
    belongs_to :doc_grn,      class_name: "Clns::Grn",                  inverse_of: :docs
    belongs_to :doc_inv,      class_name: "Clns::Invoice",              inverse_of: :docs
    belongs_to :client,       class_name: "Clns::PartnerFirm",          inverse_of: :docs_client
    belongs_to :client_d,     class_name: "Clns::PartnerFirm::Person",  inverse_of: :docs_client
    belongs_to :unit,         class_name: "Clns::PartnerFirm::Unit",    inverse_of: :docs
    belongs_to :signed_by,    class_name: "Clns::User",                 inverse_of: :docs

    alias :file_name :name; alias :unit :unit_belongs_to

    index({ unit_id: 1, id_date: 1 })

    accepts_nested_attributes_for :freights,
      reject_if: ->(attrs){ attrs[:qu].to_f == 0 }

    class << self
      # @todo
      def sum_freights_grn
        all.each_with_object({}) do |dn,s|
          dn.freights.asc(:id_stats).each_with_object(s) do |f,s|
            if s[f.key].nil?
              s[f.key] = [f.freight.name,f.freight.id_stats,f.um,f.pu,f.qu,f.val,f.tva]
            else
              s[f.key][4] += f.qu
              s[f.key][5] += f.val
            end
          end
        end
      end
      # @todo
      def sum_freights_inv(for_partner = false)
        all.each_with_object({}) do |dn,s|
          dn.freights.asc(:id_stats).each_with_object(s) do |f,s|
            key  = "#{f.id_stats}_#{"%07.4f" % f.pu_invoice}"
            name = f.freight.name
            name = (f.freight.csn.nil? ? f.freight.name : f.freight.csn[dn.client_id.to_s] || f.freight.csn['dflt']) if for_partner
            if s[key].nil?
              s[key] = [name,f.freight.id_stats,f.um,f.pu,f.qu,f.val,f.pu_invoice,f.val_invoice,f.tva_invoice,f.out_invoice,f.freight.tva]
            else
              s[key][4] += f.qu
              s[key][5] += f.val
              s[key][7] += f.val_invoice
              s[key][8] += f.tva_invoice
              s[key][9] += f.out_invoice
            end
          end
        end
      end
    end # Class methods

  end # DeliveryNote
end # Clns
