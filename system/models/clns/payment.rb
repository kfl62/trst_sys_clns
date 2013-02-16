# encoding: utf-8
module Clns
  class Payment
    include Mongoid::Document
    include Mongoid::Timestamps
    include Trst::ViewHelpers
    include Trst::DateHelpers

    field :id_date,     type: Date,       default: -> {Date.today}
    field :id_intern,   type: Boolean,    default: false
    field :text,        type: String,     default: "Doc.nr."
    field :val,         type: Float,      default: 0.00

    belongs_to :doc_inv,      class_name: "Clns::Invoice",          inverse_of: :pyms

    class << self
      # @todo
      def nonin(nin = true)
        where(id_intern: !nin)
      end
    end # Class methods
  end # Payment
end # Clns
