# encoding: utf-8
module Clns
  class Payment < Trst::Payment

    belongs_to :doc_inv,      class_name: "Clns::Invoice",              inverse_of: :pyms

    class << self
    end # Class methods

  end # Payment
end # Clns
