# encoding: utf-8
# Template for Clns::Consumption#pdf
require 'prawn/measurement_extensions'
require "prawn/templates"

def firm
  Clns::PartnerFirm.find_by(firm: true)
end
def unit
  firm.units.find(@object.unit_id)
end
def signed_by(o = nil)
  o ||= @object
  unit.chief.include?(o.signed_by.name) ? o.signed_by.name : unit.chief.split(',').first
end
def table_data(o)
  data = {}
  o.freights.sort_by{|f| f.key}.each do |f|
    k = f.key
    if data[k].nil?
      data[k] = [f.freight.name,f.um,f.qu,f.pu,f.val]
    else
      data[k][2] += f.qu
      data[k][4] += f.val
    end
  end
  data = data.values.sort.each_with_index{|r,i| r.unshift("#{i + 1}.")}
  data.map!{|r| [r[0],r[1],r[2],"%.2f" % r[3],"%.4f" % r[4],"%.2f" % r[5],""]}
end
pdf = Prawn::Document.new(
  page_size: 'A4',
  page_layout: :landscape,
  skip_page_creation: true,
  margin: [0.mm],
  info: {
    Title: "Bon de consum",
    Author: "kfl62",
    Subject: "Formular \"Bon de consum\"",
    Keywords: "#{firm.name[1]} Bon de consum ",
    Creator: "http://#{firm.name[0].downcase}.trst.ro (using Sinatra, Prawn)",
    CreationDate: Time.now
  }
)
pdf.font_families.update(
  'Verdana' => {bold: 'public/stylesheets/fonts/verdanab.ttf',
                italic: 'public/stylesheets/fonts/verdanai.ttf',
                bold_italic: 'public/stylesheets/fonts/verdanaz.ttf',
                normal: 'public/stylesheets/fonts/verdana.ttf'})
data = table_data(@object)
if data.length > 16
  data_ext= data[17..-1]
  data    = data[0..16]
end unless data.length == 17
pdf.start_new_page(template: "public/images/clns/pdf/consumption.pdf")
pdf.font 'Verdana'
pdf.text_box firm.name[2],
             at: [33.mm, pdf.bounds.top - 8.mm], style: :bold
pdf.text_box "Nr.intern #{@object.name}",
             at: [173.mm, pdf.bounds.top - 13.mm], size: 8
pdf.text_box @object.id_date.to_s,
             at: [235.mm, pdf.bounds.top - 8.mm], size: 10, style: :bold
pdf.text_box "#{unit.slug} - #{unit.name[1]}",
             at: [14.mm, pdf.bounds.top - 30.mm],width: 135.mm, size: 10, align: :center
pdf.text_box "#{unit.chief}",
             at: [149.mm, pdf.bounds.top - 30.mm],width: 135.mm, size: 10, align: :center
pdf.text_box @object.expl,
             at: [45.mm, pdf.bounds.top - 41.mm],width: 270.mm, size: 10
pdf.text_box "#{unit.chief}",
             at: [185.mm, 12.mm], size: 10, width: 40.mm, align: :center
pdf.text_box signed_by,
             at: [240.mm, 12.mm], size: 10, width: 40.mm, align: :center
pdf.bounding_box([15.mm, pdf.bounds.top - 70.mm], :width  => pdf.bounds.width) do
  pdf.table(data, cell_style: {borders: []}, column_widths: [12.mm,60.mm,12.mm,25.mm,25.mm,25.mm,120.mm]) do
    pdf.font_size = 9
    column(0).style(align: :right, padding: [5,10,5,0])
    column(2).style(align: :center)
    column(3..5).style(align: :right)
    (0..data.length - 1).each do |i|
      if data[i].last.length > 160
        row(i).columns(6).style(size: 7,height: 14.mm, padding: [2,0,0,5])
      else data[i].last.split('; ').length > 10
        row(i).columns(6).style(size: 7,height: 7.mm, padding: [2,0,0,5])
      end
    end
  end
end
if data_ext
  pdf.start_new_page(template: "public/images/clns/pdf/grn.pdf",template_page: 2)
  pdf.bounding_box([15.mm, pdf.bounds.top - 30.mm], :width  => pdf.bounds.width) do
    pdf.table(data_ext, cell_style: {borders: []}, column_widths: [12.mm,60.mm,12.mm,25.mm,25.mm,25.mm]) do
      pdf.font_size = 9
      column(0).style(align: :right, padding: [5,10,5,0])
      column(2).style(align: :center)
      column(3..5).style(align: :right)
      row(data_ext.length-1).columns(1).style(align: :center)
      (0..data.length - 1).each do |i|
        if data[i].last.length > 160
          row(i).columns(6).style(size: 7,height: 14.mm, padding: [2,0,0,5])
        else data[i].last.split('; ').length > 10
          row(i).columns(6).style(size: 7,height: 7.mm, padding: [2,0,0,5])
        end
      end
    end
  end
end
pdf.render()
