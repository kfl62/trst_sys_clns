# encoding: utf-8
# Template for Clns::Grn#pdf
require 'prawn/measurement_extensions'

def firm
  Clns::PartnerFirm.find_by(:firm => true)
end
def supplier(o = nil)
  o ||= @object
  Clns::PartnerFirm.find(o.supplr_id)
end
def unit(o = nil)
  o ||= @object
  firm.units.find(o.unit_id)
end
def signed_by(o = nil)
  o ||= @object
  unit.chief.include?(o.signed_by.name) ? o.signed_by.name : unit.chief.split(',').first
end
def delegate(o = nil)
  o ||= @object
  Clns::PartnerFirm.find(o.supplr_id).people.find(o.supplr_d_id)
end
def payment(o = nil)
  o ||= @object
  if o.id_intern
    r = ['Nu este cazul.','Transfer intern!']
  else
    if o.doc_type == 'MIN'
      r = ['Nu este cazul.','PV fără valoare!']
    elsif o.doc_type == 'DN'
      r = ['Nu este cazul.','Se va completa la facturare!']
    elsif o.doc_type == 'INV'
      r = o.doc_inv.pyms_list
    else
      r = ['-']
    end
  end
  r.join("\n")
end
def table_data(o = nil)
  o ||= @object
  data, sum_100, sum_out, sum_tva = {}, o.sum_100, o.sum_out, o.sum_tva
  if o.id_intern
    o.dlns.each do |dn|
      dn.freights.each do |f|
        k = f.key
        if data[k].nil?
          data[k] = [f.freight.name,f.um,f.qu,f.pu,f.val.f.out,f.tva,["#{dn.doc_name} #{ "%.2f" % f.qu}"]]
        else
          data[k][2] += f.qu
          data[k][4] += f.val
          data[k][5] += f.out
          data[k][6] += f.tva
          data[k][7] << ["#{dn.doc_name} #{ "%.2f" % f.qu}"]
        end
      end
    end
    data = data.values.sort.each_with_index{|r,i| r.unshift("#{i + 1}.")}
    data.map!{|r| [r[0],r[1],r[2],"%.2f" % r[3],"%.4f" % r[4],"%.2f" % r[5],"%.2f" % r[6],"%.2f" % r[7],r[8].join('; ')]}
    data.push(["","TOTAL","","","","%.2f" % sum_100,"%.2f" % sum_out,"%.2f" % sum_tva,""])
  else
    o.freights.each do |f|
      k = f.key
      if data[k].nil?
        data[k] = [f.freight.name,f.um,f.qu,f.pu,f.val,f.out,f.tva]
      else
        data[k][2] += f.qu
        data[k][4] += f.val
        data[k][5] += f.out
        data[k][6] += f.tva
      end
    end
    data = data.values.sort.each_with_index{|r,i| r.unshift("#{i + 1}.")}
    data.map!{|r| [r[0],r[1],r[2],"%.2f" % r[3],"%.4f" % r[4],"%.2f" % r[5],"%.2f" % r[6],"%.2f" % r[7],""]}
    data.push(["","TOTAL","","","","%.2f" % sum_100,"%.2f" % sum_out,"%.2f" % sum_tva,""])
  end
  data
end
pdf = Prawn::Document.new(
  :page_size => 'A4',
  :page_layout => :landscape,
  :background => "public/images/wstm/pdf/nir.jpg",
  :margin => [0.mm],
  :info => {
    :Title => "Notă de recepţie",
    :Author => "kfl62",
    :Subject => "Formular \"Notă de recepţie\"",
    :Keywords => "#{firm.name[1]} Notă de recepţie ",
    :Creator => "http://#{firm.name[0].downcase}.trst.ro (using Sinatra, Prawn)",
    :CreationDate => Time.now
  }
)
pdf.font_families.update(
  'Verdana' => {:bold => 'public/stylesheets/fonts/verdanab.ttf',
                :italic => 'public/stylesheets/fonts/verdanai.ttf',
                :bold_italic => 'public/stylesheets/fonts/verdanaz.ttf',
                :normal => 'public/stylesheets/fonts/verdana.ttf'})
pdf.font 'Verdana'
pdf.text_box firm.name[2],
             :at => [33.mm, pdf.bounds.top - 8.mm], :style => :bold
pdf.text_box "Nr.intern #{@object.name}",
             :at => [175.mm, pdf.bounds.top - 13.mm], :size => 8
pdf.text_box @object.id_date.to_s,
             :at => [230.mm, pdf.bounds.top - 8.mm], :size => 10, :style => :bold
if @object.id_intern
  pdf.text_box mat(@object,"doc_type_#{@object.doc_type}").concat(" #{@object.doc_name}"),
               :at => [16.mm, pdf.bounds.top - 30.mm], :width => 91.mm, :size => 8
else
  pdf.text_box mat(@object,"doc_type_#{@object.doc_type}"),
               :at => [13.mm, pdf.bounds.top - 30.mm], :width => 63.mm, :align => :center, :size => 10
  pdf.text_box @object.doc_name,
               :at => [75.mm, pdf.bounds.top - 30.mm], :width => 28.mm, :align => :center, :size => 10
  pdf.text_box @object.doc_date.to_s,
               :at => [100.mm, pdf.bounds.top - 30.mm], :width => 37.mm, :align => :center, :size => 10
end
pdf.text_box supplier.name[2],
             :at => [140.mm, pdf.bounds.top - 30.mm], :width => 44.mm, :align => :center, :size => 9
pdf.text_box "#{supplier.identities["fiscal"] rescue '-'}",
             :at => [183.mm, pdf.bounds.top - 30.mm], :width => 38.mm, :align => :center, :size => 9
pdf.text_box payment(@object),
             :at => [222.mm, pdf.bounds.top - 29.mm], :width => 63.mm, :align => :left, :size => 8
pdf.text_box "#{delegate.name rescue 'Fără delegat'}",
             :at => [43.mm, pdf.bounds.top - 48.mm], :width => 92.mm, :align => :center, :size => 10
pdf.text_box "#{@object.doc_plat.upcase rescue '-'}",
             :at => [175.mm, pdf.bounds.top - 48.mm], :width => 105.mm, :align => :center, :size => 10
pdf.text_box signed_by,
             :at => [195.mm, 12.mm], :size => 10
pdf.text_box signed_by,
             :at => [250.mm, 12.mm], :size => 10
pdf.bounding_box([15.mm, pdf.bounds.top - 70.mm], :width  => pdf.bounds.width) do
  data = table_data(@object)
  pdf.table(data, :cell_style => {:borders => []}, :column_widths => [12.mm,60.mm,10.mm,20.mm,20.mm,25.mm,25.mm,18.mm,80.mm]) do
    pdf.font_size = 9
    column(0).style(:align => :right, :padding => [5,10,5,0])
    column(3..7).style(:align => :right)
    row(data.length - 1).columns(1).style(:align => :center)
    (0..data.length - 1).each do |i|
      if data[i].last.length > 160
        row(i).columns(8).style(:size => 7,:height => 14.mm, :padding => [2,0,0,5])
      else data[i].last.split('; ').length > 10
        row(i).columns(8).style(:size => 7,:height => 7.mm, :padding => [2,0,0,5])
      end
    end
  end
end
pdf.render()
