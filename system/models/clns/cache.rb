# encoding: utf-8
# Clns::Cache.stats_all(2012,10,{mny_all: true})[0..-2].each_with_object({}){|e,h| h[e[0]]=e[-1]}[unit_id]
module Clns
  class Cache < Trst::Cache

    field :name,        type: String,     default: -> {"DP_NR-#{Date.today.to_s}"}
    field :expl,        type: String,     default: 'Vasy Ildiko'
    field :id_intern,   type: Boolean,    default: false

    belongs_to  :unit,     class_name: 'Clns::PartnerFirm::Unit', inverse_of: :dps

    index({ unit_id: 1, id_date: 1 })

    scope :by_unit_id, ->(unit_id) {where(unit_id: unit_id)}

    class << self
      # @todo
      def pos(s)
        uid = Clns::PartnerFirm.pos(s).id
        by_unit_id(uid)
      end
      # @todo
      def nonin(nin = true)
        where(id_intern: !nin)
      end
    end # Class methods

    #todo
    def unit
      Clns::PartnerFirm.unit_by_unit_id(unit_id) rescue nil
    end
  end # Cache
end # Clns
