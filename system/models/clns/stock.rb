# encoding: utf-8
module Clns
  class Stock
    include Mongoid::Document
    include Mongoid::Timestamps
    include Trst::ViewHelpers
    include Trst::DateHelpers

    field :name,        type: String
    field :id_date,     type: Date
    field :expl,        type: String,   default: 'Stock initial'

    has_many   :freights,   class_name: "Clns::FreightStock",     :inverse_of => :doc_stk, dependent: :destroy
    belongs_to :unit,       class_name: "Clns::PartnerFirm::Unit",:inverse_of => :stks

    index({ id_date: 1 })

    scope :by_unit_id, ->(unit_id) {where(unit_id: unit_id)}

    accepts_nested_attributes_for :freights,
      reject_if: ->(attrs){ attrs[:qu].to_f == 0 && attrs[:pu].to_f == 0 },
      allow_destroy: true

    class << self
      # @todo
      def pos(s)
        uid = Clns::PartnerFirm.pos(s).id
        by_unit_id(uid)
      end
    end # Class methods

    # @todo
    def keys(p = 2)
      freights.keys(p)
    end
    # @todo
    def unit
      Clns::PartnerFirm.unit_by_unit_id(unit_id) rescue nil
    end

   end # Stock
end #Clns
