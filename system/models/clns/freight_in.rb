# encoding: utf-8
module Clns
  class FreightIn
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
    field :tva,         type: Float,     default: 0.00
    field :out,         type: Float,     default: 0.00

    belongs_to  :freight,  class_name: 'Clns::Freight',           inverse_of: :ins, index: true
    belongs_to  :unit,     class_name: 'Clns::PartnerFirm::Unit', inverse_of: :ins, index: true
    belongs_to  :doc_grn,  class_name: 'Clns::Grn',               inverse_of: :freights, index: true
    belongs_to  :doc_sor,  class_name: 'Clns::Sorting',           inverse_of: :resl_freights, index: true

    index({ freight_id: 1, id_date: 1, unit_id: 1 })

    scope :by_unit_id, ->(unit_id) {where(unit_id: unit_id)}

    before_save   :handle_freights_unit_id
    after_save    :'handle_stock(true)'
    after_destroy :'handle_stock(false)'

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
    def unit
      Clns::PartnerFirm.unit_by_unit_id(unit_id) rescue doc.unit_id
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
    def doc
      doc_grn || doc_sor
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
    def handle_stock(add_delete)
      today = Date.today; retro = id_date.month == today.month
      stock_to_handle = retro ? [unit.stock_now] : [unit.stock_monthly(id_date.year,id_date.month), unit.stock_now]
      stock_to_handle.each do |stck|
        f = stck.freights.find_or_create_by(id_stats: id_stats, um: um, pu: pu)
        add_delete ? f.qu += qu : f.qu -= qu
        f.freight_id= freight_id
        f.id_date   = stck.id_date
        f.val       = (f.pu * f. qu).round(2)
        f.save
      end
    end
  end # FreightIn
end # Clns
