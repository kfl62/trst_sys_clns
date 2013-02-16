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

    has_many   :freights,   class_name: "Clns::FreightStock",   :inverse_of => :doc_stk, dependent: :destroy
    belongs_to :unit,       class_name: "Clns::PartnerFirmUnit",:inverse_of => :stks

    scope :by_unit_id, ->(unit_id) {where(unit_id: unit_id)}

    accepts_nested_attributes_for :freights,
      reject_if: ->(attrs){ attrs[:qu].to_f == 0 && attrs[:pu].to_f == 0 },
      allow_destroy: true

    class << self
      # @todo
      def pos(s)
        where(unit_id: Clns::PartnerFirm.pos(s).id)
      end
    end # Class methods

    # @todo
    def keys(pu = true)
      ks = freights.each_with_object([]){|f,k| k << "#{f.id_stats}"}.uniq.sort!
      ks = freights.each_with_object([]){|f,k| k << "#{f.id_stats}_#{"%05.2f" % f.pu}"}.uniq.sort! if pu
      ks
    end
    # @todo
    def unit
      Clns::PartnerFirm.unit_by_unit_id(unit_id) rescue nil
    end

   end # Stock
end #Clns
