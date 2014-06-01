# encoding: utf-8
module Clns
  class FreightStock
    include Mongoid::Document
    include Mongoid::Timestamps
    include Trst::ViewHelpers
    include Trst::DateHelpers

    field :id_date,     type: Date
    field :id_stats,    type: String
    field :id_intern,   type: Boolean,   default: false
    field :pu,          type: Float,     default: 0.00
    field :qu,          type: Float,     default: 0.00
    field :val,         type: Float,     default: 0.00

    belongs_to  :freight,  class_name: 'Clns::Freight',           inverse_of: :stks, index: true
    belongs_to  :unit,     class_name: 'Clns::PartnerFirm::Unit', inverse_of: :fsts, index: true
    belongs_to  :doc_stk,  class_name: 'Clns::Stock',             inverse_of: :freights, index: true

    index({ freight_id: 1, id_date: 1, unit_id: 1 })

    scope :stock_now, where(id_date: Date.new(2000,1,31))
    scope :by_unit_id, ->(unit_id) {where(unit_id: unit_id)}

    before_save   :handle_freights_unit_id
    after_update  :handle_value

    class << self
      # @todo
      def by_id_stats(ids,lst = false)
        c = ids.scan(/\d{2}/).each{|g| g.gsub!("00","\\d{2}")}.join
        result = where(id_stats: /#{c}/).asc(:name)
        if lst
          c = ids.gsub(/\d{2}$/,"\\d{2}")
          result = where(id_stats: /#{c}/).asc(:id_stats)
          result = ids == "00000000" ? ids : result.last.nil? ? ids.next : result.last.id_stats.next
        end
        result
      end
      # @todo
      def keys(p = 2)
        p  = 0 unless p # keys(false) compatibility
        ks = all.each_with_object([]){|f,k| k << "#{f.id_stats}_#{"%.#{p}f" % f.pu}"}.uniq.sort!
        ks = all.each_with_object([]){|f,k| k << "#{f.id_stats}"}.uniq.sort! if p.zero?
        ks
      end
      # @todo
      def by_key(key)
        id_stats, pu = key.split('_')
        pu.nil? ? where(id_stats: id_stats) : where(id_stats: id_stats, pu: pu.to_f)
      end
      # @todo
      def nonin(nin = true)
        where(id_intern: !nin)
      end
      # @todo
      def pos(s)
        uid = Clns::PartnerFirm.pos(s).id
        by_unit_id(uid)
      end
    end # Class methods

    # @todo
    def view_filter
      [id, freight.name]
    end
    # @todo
    def unit
      Clns::PartnerFirm.unit_by_unit_id(unit_id) rescue nil
    end
    # @todo
    def name
      freight.name
    end
    # @todo
    def um
      freight.um rescue 'kg'
    end
    # @todo
    def tva
      freight.tva
    end
    # @todo
    def doc
      doc_stk
    end
    # @todo
    def key
      "#{id_stats}_#{"%.4f" % pu}"
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
