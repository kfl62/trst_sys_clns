# encoding: utf-8

module Clns
  class Sorting
    include Mongoid::Document
    include Mongoid::Timestamps
    include Trst::ViewHelpers
    include Trst::DateHelpers

    field :name,        type: String
    field :id_date,     type: Date,     default: -> {Date.today}
    field :id_intern,   type: Boolean,  default: true
    field :text,        type: String

    alias :file_name :name

    has_many   :from_freights,  class_name: "Clns::FreightOut",      inverse_of: :doc_sor, dependent: :destroy
    has_many   :resl_freights,  class_name: "Clns::FreightIn",       inverse_of: :doc_sor, dependent: :destroy
    belongs_to :unit,           class_name: "Clns::PartnerFirm::Unit", inverse_of: :srts
    belongs_to :signed_by,      class_name: "Clns::User",            inverse_of: :srts

    index({ unit_id: 1, id_date: 1 })
    scope :by_unit_id, ->(unit_id) {where(unit_id: unit_id)}

    accepts_nested_attributes_for :from_freights,
      reject_if: ->(attrs){ attrs[:qu].to_f == 0 }
    accepts_nested_attributes_for :resl_freights,
      reject_if: ->(attrs){ attrs[:qu].to_f == 0 }

    after_save :handle_freights

    class << self
      # @todo
      def nonin(nin = true)
        where(id_intern: !nin)
      end
    end # Class methods

    # @todo
    def unit
      Clns::PartnerFirm.unit_by_unit_id(unit_id) rescue nil
    end
    # @todo
    def increment_name(unit_id)
      sorts = Clns::Sorting.by_unit_id(unit_id).yearly(Date.today.year)
      if sorts.count > 0
        name = sorts.asc(:name).last.name.next
      else
        unit = Clns::PartnerFirm.unit_by_unit_id(unit_id)
        prfx = Date.today.year.to_s[-2..-1]
        name = "#{unit.firm.name[0][0..2].upcase}_#{unit.slug}_PVST-#{prfx}00001"
      end
      name
    end

    protected

    def handle_freights
      self.from_freights.each{|f| f.set(:id_intern,true); f.set(:val,(f.pu * f.qu).round(2))}
      self.resl_freights.each{|f| f.set(:id_intern,true); f.set(:val,(f.pu * f.qu).round(2))}
    end
  end # Sorting
end # Clns
