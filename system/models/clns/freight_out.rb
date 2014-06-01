# encoding: utf-8
module Clns
  class FreightOut
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
    field :pu_invoice,  type: Float,     default: 0.00
    field :val_invoice, type: Float,     default: 0.00
    field :tva_invoice, type: Float,     default: 0.00
    field :out_invoice, type: Float,     default: 0.00

    belongs_to  :freight,  class_name: 'Clns::Freight',           inverse_of: :outs, index: true
    belongs_to  :unit,     class_name: 'Clns::PartnerFirm::Unit', inverse_of: :outs, index: true
    belongs_to  :doc_dln,  class_name: 'Clns::DeliveryNote',      inverse_of: :freights, index: true
    belongs_to  :doc_cas,  class_name: 'Clns::Cassation',         inverse_of: :freights, index: true
    belongs_to  :doc_con,  class_name: 'Clns::Consumption',       inverse_of: :freights, index: true
    belongs_to  :doc_sor,  class_name: 'Clns::Sorting',           inverse_of: :from_freights, index: true

    index({ freight_id: 1, id_date: 1, unit_id: 1 })

    scope :by_unit_id, ->(unit_id) {where(unit_id: unit_id)}

    before_save   :handle_freights_unit_id
    after_save    :'handle_stock(false)'
    after_destroy :'handle_stock(true)'

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
      Clns::PartnerFirm.unit_by_unit_id(unit_id) rescue nil
    end
    # @todo
    def name
      freight.name
    end
    # @todo
    # @todo
    def um
      freight.um rescue 'kg'
    end
    def tva
      freight.tva
    end
    # @todo
    def doc
      doc_dln || doc_cas || doc_con || doc_sor
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
      if add_delete
        stock_to_handle.each do |stck|
          f = stck.freights.find_or_create_by(id_stats: id_stats, um: um, pu: pu)
          f.qu += qu
          f.freight_id= freight_id
          f.id_date   = stck.id_date
          f.val       = (f.pu * f. qu).round(2)
          f.save
        end
      else
        stock_to_handle.each_with_index do |stck,i|
          if pu > 0 or pu_invoice > 0
            f = stck.freights.find_or_create_by(id_stats: id_stats, um: um, pu: pu)
            f.qu -= qu
            f.freight_id= freight_id
            f.id_date   = stck.id_date
            f.val       = (f.pu * f. qu).round(2)
            f.save
          else
            out = qu
            lpu = freight.ins.last.pu == 0 ? freight.pu : freight.ins.last.pu
            fs  = stck.freights.where(id_stats: id_stats)
            if fs.count == 1
              f     = fs.first
              f.qu -= out
              f.val = (f.pu * f.qu).round(2)
              f.save
              self.set(:pu, f.pu)
              self.set(:val, (pu * qu).round(2))
            else
              fspus = fs.where(:qu.ne => 0).asc(:pu).map(&:pu)
              fspus.delete(lpu).nil? ? fspus : fspus.push(lpu)
              fspus.delete(0).nil?   ? fspus : fspus.push(0)  if unit.main?
              fspus.each do |fspu|
                f = fs.find_by(pu: fspu)
                if out > f.qu
                  if i == 0
                    self.class.new(
                      id_date:    id_date,
                      id_stats:   f.id_stats,
                      id_intern:  id_intern,
                      um:         f.um,
                      pu:         f.pu,
                      qu:         f.qu,
                      val:        (f.pu * f.qu).round(2),
                      freight_id: f.freight.id,
                      doc_dln_id: (doc_dln_id if doc_dln_id),
                      doc_cas_id: (doc_cas_id if doc_cas_id),
                      doc_con_id: (doc_con_id if doc_con_id)
                    ).upsert
                  end # if stock_to_handle.first
                  out -= f.qu
                  f.qu = 0
                  f.val= 0
                  f.save
                else
                  if i == 0
                    self.class.new(
                      id_date:    id_date,
                      id_stats:   f.id_stats,
                      id_intern:  id_intern,
                      um:         f.um,
                      pu:         f.pu,
                      qu:         out,
                      val:        (f.pu * out).round(2),
                      freight_id: f.freight.id,
                      doc_dln_id: (doc_dln_id if doc_dln_id),
                      doc_cas_id: (doc_cas_id if doc_cas_id),
                      doc_con_id: (doc_con_id if doc_con_id)
                    ).upsert unless out == 0
                  end # if stock_to_handle.first
                  f.qu -= out; out = 0
                  f.val = (f.pu * f.qu).round(2)
                  f.save
                end # if out > f.qu
              end # each fspu
              self.delete if i == stock_to_handle.length - 1
            end # if fs.count == 1
          end # if pu > 0
        end # each stck
      end # if add_delete
    end

  end # FreightOut
end # Clns
