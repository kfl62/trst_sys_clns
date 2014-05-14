# encoding: utf-8
module Clns
  class Cassation
    include Mongoid::Document
    include Mongoid::Timestamps
    include Trst::ViewHelpers
    include Trst::DateHelpers

    field :name,        type: String
    field :id_date,     type: Date,     default: -> {Date.today}
    field :id_intern,   type: Boolean,  default: false
    field :text,        type: String
    field :val,         type: Float,    default: 0.00

    alias :file_name :name

    has_many   :freights,   class_name: "Clns::FreightOut",       inverse_of: :doc_cas, dependent: :destroy
    belongs_to :unit,       class_name: "Clns::PartnerFirm::Unit",inverse_of: :csss
    belongs_to :signed_by,  class_name: "Clns::User",             inverse_of: :csss

    index({ unit_id: 1, id_date: 1 })
    scope :by_unit_id, ->(unit_id) {where(unit_id: unit_id)}

    accepts_nested_attributes_for :freights,
      reject_if: ->(attrs){ attrs[:qu].to_f == 0 }

    # class << self
    #   # @todo
    #   def pos(s)
    #     where(unit_id: Clns::PartnerFirm.pos(s).id)
    #   end
    #   # @todo
    #   def nonin(nin = true)
    #     where(id_intern: !nin)
    #   end
    # end # Class methods

    # @todo
    def unit
      Clns::PartnerFirm.unit_by_unit_id(unit_id) rescue nil
    end
    # @todo
    def increment_name(unit_id)
      cass = Clns::Cassation.by_unit_id(unit_id).yearly(Date.today.year)
      if cass.count > 0
        name = cass.asc(:name).last.name.next
      else
        unit = Clns::PartnerFirm.unit_by_unit_id(unit_id)
        prfx = Date.today.year.to_s[-2..-1]
        name = "#{unit.firm.name[0][0..2].upcase}_#{unit.slug.upcase}_PVCS-#{prfx}00001"
      end
      name
    end
  end # Cassation
end # Clns
