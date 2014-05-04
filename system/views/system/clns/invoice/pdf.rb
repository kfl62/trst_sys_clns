# encoding: utf-8
# Template for Clns::Invoice#pdf
require 'prawn/measurement_extensions'
require "prawn/templates"

def firm
  Clns::PartnerFirm.find_by(firm: true)
end
def address_f
  firm.addresses.first
end
def unit
  firm.units.find(@object.unit_id)
end
def client
  Clns::PartnerFirm.find(@object.client_id)
end
def address_c
  client.addresses.first
end
def table_goods_data
  data = [["Nr.", "Denumire produs/serviciu", "UM", "Cantitate", "Preț unitar", "Valoare", "TVA"]]
  @object.freights.each_with_index do |f,i|
    data << ["#{i + 1}.", f.name, f.um, "%.2f" % f.qu, "%.4f" % f.pu, "%.2f" % f.val, "%.2f" % f.tva]
  end
  for i in data.length..35 do
    data[i] = [Prawn::Text::NBSP, "","","","","",""]
  end
  data
end
def table_recap_data
  data = []
  data[0] = ["","Nume delagat",": #{@object.client_d.name rescue ''}",{content: "TOTAL",rowspan: 3},{content: "<b>#{"%.2f" % @object.sum_100}</b>",rowspan: 3},{content: "<b>#{"%.2f" % @object.sum_tva}</b>",rowspan: 3}]
  data[1] = ["Semnătută","B.I./C.I.",":"]
  data[2] = ["Ștampilă","Mijloctransport",":"]
  data[3] = ["","Data expedierii",":",{content: "Semnătura de primire",rowspan: 4},{content: "TOTAL DE PLATĂ",rowspan: 2,colspan: 2}]
  data[4] = ["","Întocmit de",": #{@object.signed_by.name rescue ''}"]
  data[5] = ["","CNP",":",{content: "<b>#{"%.2f" % @object.sum_out} RON</b>",rowspan: 2,colspan: 2}]
  data[6] = ["","Semnătura",":"]
  data
end
pdf = Prawn::Document.new(
  page_size: 'A4',
  page_layout: :portrait,
  skip_page_creation: true,
  margin: [0.mm],
  info: {
    Title: "Factură fiscală",
    Author: "kfl62",
    Subject: "Formular \"Factură fiscală\"",
    Keywords: "#{firm.name[1]} Factură fiscală ",
    Creator: "http://#{firm.name[0].downcase}.trst.ro (using Sinatra, Prawn)",
    CreationDate: Time.now
  }
)
pdf.font_families.update(
  'Verdana' => {bold: 'public/stylesheets/fonts/verdanab.ttf',
                italic: 'public/stylesheets/fonts/verdanai.ttf',
                bold_italic: 'public/stylesheets/fonts/verdanaz.ttf',
                normal: 'public/stylesheets/fonts/verdana.ttf'})
pdf.create_stamp("watermark") do
  pdf.fill_color "f9f9f9"
  pdf.text_box "[ CIORNA ]",
    size:          40.mm,
    width:         pdf.bounds.width,
    height:        pdf.bounds.height,
    align:         :center,
    valign:        :center,
    at:            [0, pdf.bounds.top + 10.mm],
    rotate:        45,
    rotate_around: :center
end
pdf.start_new_page
pdf.font 'Verdana'
pdf.stamp("watermark")
pdf.bounding_box([10.mm, pdf.bounds.top - 10.mm], width: 70.mm) do
  pdf.font_size = 8
  pdf.text firm.name[2]
  pdf.text "Nr. înreg. R.C. : #{firm.identities['chambcom']}"
  pdf.text "Cod Fiscal (C.U.I.) : #{firm.identities['fiscal']}"
  pdf.text "Str. #{address_f.street},nr.#{address_f.nr rescue '-'},bl.#{address_f.bl rescue '-'},sc.#{address_f.sc rescue '-'},et.#{address_f.et rescue '-'},ap.#{address_f.ap rescue '-'}"
  pdf.text "#{address_f.city rescue '-'}, județul #{address_f.state rescue '-'}"
end
pdf.bounding_box([140.mm, pdf.bounds.top - 10.mm], width: 70.mm) do
  pdf.font_size = 8
  pdf.text client.name[2]
  pdf.text "Nr. înreg. R.C. : #{client.identities['chambcom']}"
  pdf.text "Cod Fiscal (C.U.I.) : #{client.identities['fiscal']}"
  pdf.text "Str. #{address_c.street},nr.#{address_c.nr rescue '-'},bl.#{address_c.bl rescue '-'},sc.#{address_c.sc rescue '-'},et.#{address_c.et rescue '-'},ap.#{address_c.ap rescue '-'}"
  pdf.text "#{address_c.city rescue '-'}, județul #{address_c.state rescue '-'}"
end
pdf.bounding_box([75.mm, pdf.bounds.top - 40.mm], width: 60.mm) do
  pdf.text "Factura", align: :center, size: 12, style: :bold
  pdf.move_down 3.mm
  pdf.text "Număr#{Prawn::Text::NBSP}: <b>#{@object.doc_name}</b>", size: 10, inline_format: true
  pdf.text "Data#{Prawn::Text::NBSP*4}: <b>#{@object.id_date.to_s}</b>", size: 10, inline_format: true
end
pdf.bounding_box([10.mm, pdf.bounds.top - 60.mm], width: 190.mm) do
  pdf.text "Cotă TVA 24%", align: :right, size: 9
  pdf.table table_goods_data, cell_style: {border_width: 1, padding: [2,5], size: 9}, column_widths: [10.mm, 70.mm, 10.mm, 25.mm, 25.mm, 25.mm, 25.mm] do
    row(0).style(align: :center)
    row(1..-1).style(border_width: [0,1,0,1])
    row(-1).style(border_width: [0,1,1,1])
    column(0).rows(1..-1).style(align: :right)
    column(2).style(align: :center)
    column(3..6).rows(1..-1).style(align: :right)
  end
end
pdf.bounding_box([10.mm, pdf.bounds.bottom + 59.mm], width: 190.mm) do
  pdf.text "În cazul în care nu este stabilit prin contract, această factură este scadentă în data de: <b>#{@object.deadl.to_s}</b>", size: 9, inline_format: true
end
pdf.bounding_box([10.mm, pdf.bounds.bottom + 55.mm], width: 190.mm) do
  pdf.table table_recap_data, cell_style: {padding: [2,5], size: 9}, column_widths: [30.mm, 30.mm, 55.mm, 25.mm, 25.mm, 25.mm] do
    row(0..6).style(border_width: [0,1,0,1])
    column(1..2).rows(0..6).style(border_width: 0)
    row(0).style(border_top_width: 1)
    row(6).style(border_bottom_width: 1)
    column(0).style(align: :center)
    cells[0,3].style(align: :center,valign: :center,size:11,border_bottom_width: 1)
    cells[0,4].style(align: :right,valign: :center,inline_format: true,background_color: "f9f9f9",border_bottom_width: 1)
    cells[0,5].style(align: :right,valign: :center,inline_format: true,background_color: "f9f9f9",border_bottom_width: 1)
    cells[3,3].style(align: :center,valign: :top,border_bottom_width: 1)
    cells[3,4].style(align: :center,valign: :center,size:11,background_color: "f9f9f9")
    cells[5,4].style(align: :center,valign: :center,size:11,inline_format: true,background_color: "f9f9f9",border_bottom_width: 1)
  end
end
pdf.render()
