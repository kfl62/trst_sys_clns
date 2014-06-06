# encoding: utf-8
module Clns
  class FreightStock < Trst::FreightStock

    belongs_to  :freight,     class_name: 'Clns::Freight',              inverse_of: :stks, index: true
    belongs_to  :unit,        class_name: 'Clns::PartnerFirm::Unit',    inverse_of: :fsts, index: true
    belongs_to  :doc_stk,     class_name: 'Clns::Stock',                inverse_of: :freights, index: true

    index({ freight_id: 1, id_date: 1, unit_id: 1 })

    scope :stock_now, where(id_date: Date.new(2000,1,31))

    before_save   :handle_freights_unit_id
    after_update  :handle_value

    class << self
    end # Class methods

    # @todo
    def view_filter
      [id, freight.name]
    end
    # @todo
    def doc
      doc_stk
    end
    protected
    # @todo
    def handle_freights_unit_id
      set(:unit_id,self.doc.unit_id)
    end
    # @todo
    def handle_value
      set :val, (pu * qu).round(2)
    end
  end # FreightStock
end # Clns
