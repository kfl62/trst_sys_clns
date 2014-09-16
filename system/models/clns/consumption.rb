# encoding: utf-8
module Clns
  class Consumption < Trst::Consumption

    has_many   :freights,   class_name: "Clns::FreightOut",       inverse_of: :doc_con, dependent: :destroy
    belongs_to :unit,       class_name: "Clns::PartnerFirm::Unit",inverse_of: :cnss
    belongs_to :signed_by,  class_name: "Clns::User",             inverse_of: :cnss

    alias :file_name :name; alias :unit :unit_belongs_to

    index({ unit_id: 1, id_date: 1 })

    accepts_nested_attributes_for :freights,
      reject_if: ->(attrs){ attrs[:qu].to_f == 0 }

    class << self
    end # Class methods

  end # Consumption
end # Clns
