# encoding: utf-8
module Clns
  class Invoice < Trst::Invoice

    embeds_many :freights,     class_name: "Clns::InvoiceFreight",      inverse_of: :doc_inv, cascade_callbacks: true
    has_many    :dlns,         class_name: "Clns::DeliveryNote",        inverse_of: :doc_inv
    has_many    :grns,         class_name: "Clns::Grn",                 inverse_of: :doc_inv
    has_many    :pyms,         class_name: "Clns::Payment",             inverse_of: :doc_inv, dependent: :delete
    belongs_to  :client,       class_name: "Clns::PartnerFirm",         inverse_of: :invs_client
    belongs_to  :client_d,     class_name: "Clns::PartnerFirm::Person", inverse_of: :invs_client
    belongs_to  :signed_by,    class_name: "Clns::User",                inverse_of: :invs

    alias :file_name :name

    after_save    :'handle_dlns(true)'
    after_destroy :'handle_dlns(false)'

    accepts_nested_attributes_for :dlns, :grns
    accepts_nested_attributes_for :freights,
      reject_if: ->(attrs){ attrs[:qu].to_f == 0 }
    accepts_nested_attributes_for :pyms,
      reject_if: ->(attrs){ attrs[:val].empty? }

    class << self
    end # Class methods

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
          r << "#{p.id_date.to_s}: #{p.expl}, #{"%.2f" % val}"
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
    field :qu,                type: Float,                              default: 0.00
    field :val,               type: Float,                              default: 0.00
    field :tva,               type: Float,                              default: 0.00
    field :tot,               type: Float,                              default: 0.00
    # temproray solutioin, @todo  convert to Hash
    field :pu,                type: Float,                              default: 0.0

    embedded_in :doc_inv,     class_name: "Clns::Invoice",              inverse_of: :freights
  end # InvoiceFreight
end # Clns

