# encoding: utf-8
module Clns
  class FreightOut < Trst::FreightOut

    field :pu_invoice,        type: Float,                              default: 0.00
    field :val_invoice,       type: Float,                              default: 0.00
    field :tva_invoice,       type: Float,                              default: 0.00
    field :out_invoice,       type: Float,                              default: 0.00

    belongs_to  :freight,     class_name: 'Clns::Freight',              inverse_of: :outs, index: true
    belongs_to  :unit,        class_name: 'Clns::PartnerFirm::Unit',    inverse_of: :outs, index: true
    belongs_to  :doc_dln,     class_name: 'Clns::DeliveryNote',         inverse_of: :freights, index: true
    belongs_to  :doc_cas,     class_name: 'Clns::Cassation',            inverse_of: :freights, index: true
    belongs_to  :doc_con,     class_name: 'Clns::Consumption',          inverse_of: :freights, index: true
    belongs_to  :doc_sor,     class_name: 'Clns::Sorting',              inverse_of: :from_freights, index: true

    alias :unit :unit_belongs_to; alias :name :freight_name; alias :um :freight_um

    index({ freight_id: 1, id_date: 1, unit_id: 1 })

    before_save   :handle_freights_unit_id
    after_save    :'handle_stock(false)'
    after_destroy :'handle_stock(true)'

    class << self
    end # Class methods

    # @todo
    def doc
      doc_dln || doc_cas || doc_con || doc_sor
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
