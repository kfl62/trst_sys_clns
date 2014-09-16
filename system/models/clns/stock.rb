# encoding: utf-8
module Clns
  class Stock < Trst::Stock

    has_many   :freights,     class_name: "Clns::FreightStock",         :inverse_of => :doc_stk, dependent: :destroy
    belongs_to :unit,         class_name: "Clns::PartnerFirm::Unit",    :inverse_of => :stks

    alias :file_name :name; alias :unit :unit_belongs_to

    accepts_nested_attributes_for :freights,
      reject_if: ->(attrs){ attrs[:qu].to_f == 0 && attrs[:pu].to_f == 0 },
      allow_destroy: true

    class << self
    end # Class methods

   end # Stock
end #Clns
