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
    field :um,          type: String,    default: "kg"
    field :pu,          type: Float,     default: 0.00
    field :qu,          type: Float,     default: 0.00
    field :val,         type: Float,     default: 0.00

    belongs_to  :freight,  class_name: 'Clns::Freight',     inverse_of: :stks
    belongs_to  :doc_stk,  class_name: 'Clns::Stock',       inverse_of: :freights

    index({ freight_id: 1, id_stats: 1, pu: 1, id_date: 1 })
    index({ id_stats: 1, pu: 1, id_date: 1 })
    index({ freight_id: 1, doc_stk_id: 1, qu: 1})
    scope :stock_now, where(id_date: Date.new(2000,1,31))

    class << self
      # @todo
      def keys(pu = true)
        ks = all.each_with_object([]){|f,k| k << "#{f.id_stats}"}.uniq.sort!
        ks = all.each_with_object([]){|f,k| k << "#{f.id_stats}_#{"%05.2f" % f.pu}"}.uniq.sort! if pu
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
        where(:freight_id.in => Clns::PartnerFirm.pos(s).freights.ids)
      end
      # # @todo
      # def sum_stks(*args)
      #   opts = args.last.is_a?(Hash) ? {what: :qu}.merge!(args.pop) : {what: :qu}
      #   y,m,d = *args; today = Date.today
      #   y,m,d = today.year, today.month, today.day unless ( y || m || d)
      #   v = opts[:what]
      #   if d
      #     (monthly(y,m).sum(v) || 0.0).round(2)
      #   elsif m
      #     (monthly(y,m).sum(v) || 0.0).round(2)
      #   else
      #     (monthly(y,1).sum(v) || 0.0).round(2)
      #   end
      # end
    end # Class methods

    # @todo
    def key
      "#{id_stats}_#{"%05.2f" % pu}"
    end
    # @todo
    def unit
      Clns::PartnerFirm.unit_by_unit_id(doc.unit_id)
    end

  end # FreightIn
end # Clns
