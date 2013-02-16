# encoding: utf-8
# Clns::Cache.stats_all(2012,10,{mny_all: true})[0..-2].each_with_object({}){|e,h| h[e[0]]=e[-1]}[unit_id]
module Clns
  class Cache < Trst::Cache

    field :name,        type: String,     default: -> {"DP_NR-#{Date.today.to_s}"}
    field :expl,        type: String,     default: 'Vasy Ildiko'
    field :id_intern,   type: Boolean,    default: false

    belongs_to  :unit,     class_name: 'Clns::PartnerFirmUnit', inverse_of: :dps

    index({ unit_id: 1, id_date: 1 })
    scope :by_unit_id, ->(unit_id) {where(unit_id: unit_id)}

    class << self
      # @todo
      def pos(s)
        s = s.upcase
        where(unit_id: Clns::PartnerFirm.pos(s).id)
      end
      # @todo
      def nonin(nin = true)
        where(id_intern: !nin)
      end
      # # @todo
      # def stats_pos(*args)
      #   opts = args.last.is_a?(Hash) ? {}.merge!(args.pop) : {mny_all: true,exp_all: true}
      #   i,y,m,d = *args; today = Date.today; retval, sum_tot = [], []
      #   y ||= today.year; m ||= today.month
      #   app = Clns::Expenditure.by_unit_id(i)
      #   mny = by_unit_id(i)
      #   days_in_month = (Date.new(y, 12, 31) << (12 - m)).day
      #   sld_i = mny.sum_mny(y,m,mny: [:money_stock]).first
      #   if d
      #     sum_m = mny.sum_mny(y,m,d,opts); sum_m[0] = sld_i
      #     sum_e = app.sum_mny(y,m,d,opts)
      #     sum_o = opts[:mny_all] ? sum_m[-1] + sum_e[-2] : sum_e[-2]
      #     sld_f = sum_m[0] + sum_m[1] - sum_o
      #     retval= [sum_m,sum_e,sum_o,sld_f].flatten
      #   else
      #     (1..days_in_month).each do |i|
      #       sum_m = mny.sum_mny(y,m,i,opts).drop(1)
      #       sum_e = app.sum_mny(y,m,i,opts)
      #       sum_o = opts[:mny_all] ? sum_m[-1] + sum_e[-2] : sum_e[-2]
      #       sld_i = sld_i + sum_m[0] - sum_o
      #       sum_t = [sum_m,sum_e].flatten
      #       sum_t.length.times{sum_tot << 0} unless sum_tot.length > 0
      #       sum_tot = sum_tot.zip(sum_t).map{|x| x.inject(:+)}
      #       retval << [Date.new(y,m,i).to_s,sum_t,sld_i].flatten unless (sum_m[0] == 0 && sum_o == 0)
      #     end
      #     retval << ['Total',sum_tot,sld_i].flatten
      #   end
      #   retval
      # end
      # # @todo
      # def stats_all(*args)
      #   opts = args.last.is_a?(Hash) ? {}.merge!(args.pop) : {mny_all: true,exp_all: true}
      #   y,m,d = *args; today = Date.today; retval, sum_tot = [], []
      #   y ||= today.year; m ||= today.month
      #   Clns::PartnerFirm.unit_ids.each do |u|
      #     app = Clns::Expenditure.by_unit_id(u)
      #     mny = by_unit_id(u)
      #     sum_m = mny.sum_mny(y,m,opts)
      #     sum_e = app.sum_mny(y,m,opts)
      #     sum_o = opts[:mny_all] ? sum_m[-1] + sum_e[-2] : sum_e[-2]
      #     sld_f = sum_m[0] + sum_m[1] - sum_o
      #     sum_t = [sum_m,sum_e,sld_f.round(2)].flatten
      #     sum_t.length.times{sum_tot << 0} unless sum_tot.length > 0
      #     sum_tot = sum_tot.zip(sum_t).map{|x| (x.inject(:+)).round(2)}
      #     retval << [u,Clns::PartnerFirm.unit_by_unit_id(u).name[1],sum_t].flatten
      #   end
      #   retval << ['Id','Total',sum_tot].flatten
      # end
      # # @todo
      # def sum_mny(*args)
      #   opts = args.last.is_a?(Hash) ? {mny_all: true}.merge!(args.pop) : {mny_all: true}
      #   y,m,d = *args; today = Date.today
      #   y,m,d = today.year, today.month, today.day unless ( y || m || d)
      #   ary = opts[:mny_all] ? [:money_stock,:money_in,:money_out] : [:money_stock,:money_in]
      #   ary = opts[:mny] if opts[:mny]
      #   if d
      #     ary.each_with_object([]){|v,a| a << (daily(y,m,d).sum(v) || 0.0).round(2)}
      #   elsif m
      #     ary.each_with_object([]){|v,a| a << (monthly(y,m).sum(v) || 0.0).round(2)}
      #   else
      #     ary.each_with_object([]){|v,a| a << (yearly(y).sum(v)    || 0.0).round(2)}
      #   end
      # end
    end # Class methods

    #todo
    def unit
      Clns::PartnerFirm.unit_by_unit_id(unit_id) rescue nil
    end
  end # Cache
end # Clns
