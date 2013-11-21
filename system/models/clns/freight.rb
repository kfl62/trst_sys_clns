# encoding: utf-8
module Clns
  class Freight < Trst::Freight

    field       :tva,      type: Float,     default: 0.24

    has_many    :ins,      class_name: "Clns::FreightIn",       inverse_of: :freight
    has_many    :outs,     class_name: "Clns::FreightOut",      inverse_of: :freight
    has_many    :stks,     class_name: "Clns::FreightStock",    inverse_of: :freight

    class << self
      # @todo
      def by_id_stats(ids,lst = false)
        c = lst ? ids.gsub(/\d{2}$/,"\\d{2}") : ids.scan(/\d{2}/).each{|g| g.gsub!("00","\\d{2}")}.join
        result = where(id_stats: /#{c}/).asc(:id_stats)
        if lst
          result = ids == "00000000" ? ids : result.last.nil? ? ids.next : result.last.id_stats.next
        end
        result
      end
      # @todo
      def options_for_grn
        asc(:name).each_with_object([]){|f,a| a << [f.id,f.name,{id_stats: f.id_stats,um: f.um,pu: f.pu}]}
      end
      # @todo
      def options_for_dln
        asc(:name).each_with_object([]){|f,a| a << [f.id,f.name,{key: "#{f.id_stats}-00.00",id_stats: f.id_stats,um: f.um,pu: 0.0,stck: (f.stks_now.sum(:qu) || 0)}]}
      end
      # @todo
      def options_for_dln_with_pu
        asc(:name).each_with_object([]) do |f,a|
          f.stks_now.where(:qu.ne => 0).asc(:pu).each do |fs|
            a << [fs.freight.id,"#{fs.freight.name}-#{"%05.2f" % fs.pu}",{key: "#{f.id_stats}-#{"%05.2f" % fs.pu}",id_stats: fs.id_stats,um: fs.freight.um,pu: fs.pu,stck: fs.qu}]
          end
        end
      end
      # @todo
      def options_for_stk
        asc(:name).each_with_object([]){|f,a| a << [f.id,f.name,{id_stats: f.id_stats,um: f.um,pu: f.pu}]}
      end
      # # @todo
      # def stats_pos(*args)
      #   opts = args.last.is_a?(Hash) ? {}.merge!(args.pop) : {}
      #   asc(:id_stats).each_with_object([]) do |f,a|
      #     a << [f.id,f.name,*f.stats_sum(*args,opts)]
      #   end
      # end
      # # @todo
      # def stats_pos_with_pu(*args)
      #   opts = args.last.is_a?(Hash) ? {}.merge!(args.pop) : {}
      #   y,m,d = *args; today = Date.today
      #   y,m,d = today.year, today.month, today.day unless ( y || m || d)
      #   asc(:id_stats).each_with_object([]) do |f,a|
      #     keys = (f.ins.monthly(y,m).keys + f.outs.monthly(y,m).keys + f.stks.monthly(y,m).where(:qu.ne => 0).keys + f.stks_now.where(:qu.ne => 0).keys).uniq.sort
      #     keys.each do |key|
      #       sum = *f.stats_sum(*args,opts.merge(key: key))
      #       chk = (f.stks_now.by_key(key).sum(:qu) || 0.0).round(2)
      #       m == today.month ? sum.push(chk) : sum.push(sum.last)
      #       a << [f.id,f.name,key,*sum] unless sum.sum == 0
      #     end
      #   end
      # end
      # # @todo
      # def stats_all(*args)
      #   opts = args.last.is_a?(Hash) ? {all: true}.merge!(args.pop) : {all: true}
      #   retval, sum_tot, part, fname = [], [0, 0, 0, 0], [], ''
      #   units = Clns::PartnerFirm.unit_ids
      #   keys(false).each_with_index do |ids,i|
      #     part[i] = []
      #     units.each do |u|
      #       f = find_by(unit_id: u, id_stats: ids)
      #       if f
      #         sum_pos = f.stats_sum(*args,opts)
      #         part[i] << sum_pos.pop
      #         sum_tot = sum_tot.zip(sum_pos).map{|x| x.inject(:+)}
      #         fname = f.name
      #       else
      #         part[i] << 0
      #       end
      #     end
      #     retval << [fname,sum_tot,part[i],(sum_tot.last - part[i].sum).round(2)].flatten
      #     sum_tot, fname = [0, 0, 0, 0], ''
      #   end
      #   retval
      # end
      # # @todo
      # def stats_one(*args)
      #   opts = args.last.is_a?(Hash) ? {}.merge!(args.pop) : {}
      #   i,y,m = *args; today = Date.today; retval, sum_tot = [], [0,0]
      #   f   = find(i)
      #   y ||= today.year; m ||= today.month
      #   days_in_month = (Date.new(y, 12, 31) << (12 - m)).day
      #   final = f.stks.sum_stks(y,m,opts)
      #   (1..days_in_month).each do |i|
      #     f_ins   = f.ins.sum_ins(y,m,i,opts)
      #     f_out   = f.outs.sum_outs(y,m,i,opts)
      #     sum_tot = sum_tot.zip([f_ins,f_out]).map{|x| x.inject(:+)}
      #     final   = (final + f_ins - f_out).round(2)
      #     retval << [Date.new(y,m,i).to_s, f_ins, f_out, final] unless (f_ins == 0 && f_out == 0)
      #   end
      #   retval << ['TOTAL',sum_tot,final].flatten
      # end
    end # Class methods

    # # @todo
    # def stats_sum(*args)
    #   opts = args.last.is_a?(Hash) ? {}.merge!(args.pop) : {}
    #   key = opts[:key] || id_stats
    #   if opts[:all]
    #     s = stks.by_key(key).sum_stks(*args,opts)
    #     i = ins.by_key(key).sum_ins(*args,opts)
    #     o = outs.by_key(key).sum_outs(*args,opts)
    #     i_nin = ins.by_key(key).nonin.sum_ins(*args,opts)
    #     o_nin = outs.by_key(key).nonin.sum_outs(*args,opts)
    #     [s,i_nin,o_nin,(s + i_nin - o_nin).round(2), (s + i - o).round(2)]
    #   else
    #     s = stks.by_key(key).sum_stks(*args,opts)
    #     i = ins.by_key(key).sum_ins(*args,opts)
    #     o = outs.by_key(key).sum_outs(*args,opts)
    #     [s,i,o,(s + i - o).round(2)]
    #   end
    # end
    # # @todo
    # def stats_one(*args)
    #   args = args.unshift(id)
    #   self.class.stats_one(*args)
    # end
    # # @todo
    # def stks_now
    #   stks.where(doc_stk_id: unit.stock_now.id)
    # end
    # # @todo
    # def stock_by_key(key)
    #   stks_now.by_key(key).sum(:qu) || 0
    # end
    # @todo
    def unit
      Clns::PartnerFirm.unit_by_unit_id(unit_id) rescue nil
    end
    # @todo
    def key(p)
      "#{id_stats}_#{"%05.4f" % p}"
    end
    # @todo
    def criteria_name
      result = []
      c0, c1, c2 = id_stats.scan(/\d{2}/)
      I18n.t('clns.freight.c0').each_with_object(result){|a,r| r << a[1] if a[0] == c0}
      I18n.t("clns.freight.c1.#{c0}").each_with_object(result){|a,r| r << a[1] if a[0] == c1} unless c1 == '00'
      I18n.t("clns.freight.c2.#{c0}.#{c1}").each_with_object(result){|a,r| r << a[1] if a[0] == c2} unless c2 == '00'
      result.join(' - ')
    end
  end # Freight
end # Clns
