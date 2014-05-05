# encoding: utf-8
# Template for Clns::DeliveryNote#pdf
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
def doc_name(s = false)
  dn = @object.doc_name
  dn = "#{@object.name.split('_')[1]}-#{@object.name.split('-').last}" if s
  dn
end
def table_goods_data
  data    = []
  data[0] = ["Nr.", "Denumire", "UM", "Cantitate", "Preț unitar", "Valoare", "TVA"]
  @object.freights.each_with_index do |f,i|
    data << ["#{i + 1}.", f.name, f.um, "%.2f" % f.qu, "", "", ""]
  end
  for i in data.length..19 do
    data[i] = [Prawn::Text::NBSP, "","","","","",""]
  end
  data
end
def table_recap_data
  data = []
  data[0] = ["","Nume delagat",": #{@object.client_d.name rescue ''}",{content: "TOTAL",rowspan: 3},{content: "",rowspan: 3},{content: "",rowspan: 3}]
  data[1] = ["Semnătută","B.I./C.I.",": #{@object.client_d.id_doc['sr'].gsub('-','') rescue ''} #{@object.client_d.id_doc['nr'].gsub('-','') rescue ''}"]
  data[2] = ["Ștampilă","Mijloctransport",": #{@object.doc_plat.upcase}"]
  data[3] = ["","Data expedierii",": #{@object.id_date.to_s}",{content: "Semnătura de primire",rowspan: 4},{content: "TOTAL DE PLATĂ",rowspan: 2,colspan: 2}]
  data[4] = ["","Întocmit de",": #{@object.signed_by.name rescue ''}"]
  data[5] = ["","CNP",": #{@object.signed_by.id_pn.gsub(/\d{4}$/,'****') rescue ''}",{content: "",rowspan: 2,colspan: 2}]
  data[6] = ["","Semnătura",":"]
  data
end
def watermark(pdf,name,left,top)
  pdf.create_stamp(name) do
    pdf.fill_color "f9f9f9"
    pdf.text_box "[ CIORNA ]",
      size:          35.mm,
      width:         210.mm,
      height:        148.5.mm,
      align:         :center,
      valign:        :center,
      at:            [left,top],
      rotate:        45,
      rotate_around: :center
  end
end
def box_content(pdf,left,top)
  pdf.bounding_box([10.mm, top - 10.mm], width: 70.mm) do
    pdf.font_size = 8
    pdf.text firm.name[2]
    pdf.text "Nr. înreg. R.C. : #{firm.identities['chambcom']}"
    pdf.text "Cod Fiscal (C.U.I.) : #{firm.identities['fiscal']}"
    pdf.text "Str. #{address_f.street},nr.#{address_f.nr rescue '-'},bl.#{address_f.bl rescue '-'},sc.#{address_f.sc rescue '-'},et.#{address_f.et rescue '-'},ap.#{address_f.ap rescue '-'}"
    pdf.text "#{address_f.city rescue '-'}, județul #{address_f.state rescue '-'}"
  end
  pdf.bounding_box([140.mm, top - 10.mm], width: 70.mm) do
    pdf.font_size = 8
    pdf.text client.name[2]
    pdf.text "Nr. înreg. R.C. : #{client.identities['chambcom']}"
    pdf.text "Cod Fiscal (C.U.I.) : #{client.identities['fiscal']}"
    pdf.text "Str. #{address_c.street},nr.#{address_c.nr rescue '-'},bl.#{address_c.bl rescue '-'},sc.#{address_c.sc rescue '-'},et.#{address_c.et rescue '-'},ap.#{address_c.ap rescue '-'}"
    pdf.text "#{address_c.city rescue '-'}, județul #{address_c.state rescue '-'}"
  end
  pdf.bounding_box([80.mm, top - 20.mm], width: 50.mm) do
    pdf.text "Aviz de expediție", align: :center, size: 12, style: :bold
    pdf.move_down 3.mm
    pdf.text "Număr#{Prawn::Text::NBSP}: <b>#{doc_name(true)}</b>", size: 10, inline_format: true
    pdf.text "Data#{Prawn::Text::NBSP*4}: <b>#{@object.id_date.to_s}</b>", size: 10, inline_format: true
  end
  pdf.bounding_box([10.mm, top - 35.mm], width: 190.mm) do
    pdf.text "Cotă TVA 24%", align: :right, size: 9
    pdf.table table_goods_data, cell_style: {border_width: 1, padding: [1,5], size: 8}, column_widths: [10.mm, 70.mm, 10.mm, 25.mm, 25.mm, 25.mm, 25.mm] do
      row(0).style(align: :center)
      row(1..-1).style(border_width: [0,1,0,1])
      row(-1).style(border_width: [0,1,1,1])
      column(0).rows(1..-1).style(align: :right)
      column(2).style(align: :center)
      column(3..6).rows(1..-1).style(align: :right)
    end
  end
  pdf.bounding_box([10.mm, top - 113.mm], width: 190.mm) do
    pdf.table table_recap_data, cell_style: {padding: [1,5], size: 8}, column_widths: [30.mm, 30.mm, 55.mm, 25.mm, 25.mm, 25.mm] do
      row(0..6).style(border_width: [0,1,0,1])
      column(1..2).rows(0..6).style(border_width: 0)
      #row(0).style(border_top_width: 1)
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
end
pdf = Prawn::Document.new(
  page_size: 'A4',
  page_layout: :portrait,
  skip_page_creation: true,
  margin: [0.mm],
  info: {
    Title: "Aviz de expediție",
    Author: "kfl62",
    Subject: "Formular \"Aviz de expediție\"",
    Keywords: "#{firm.name[1]} Aviz de expediție ",
    Creator: "http://#{firm.name[0].downcase}.trst.ro (using Sinatra, Prawn)",
    CreationDate: Time.now
  }
)
pdf.font_families.update(
  'Verdana' => {bold: 'public/stylesheets/fonts/verdanab.ttf',
                italic: 'public/stylesheets/fonts/verdanai.ttf',
                bold_italic: 'public/stylesheets/fonts/verdanaz.ttf',
                normal: 'public/stylesheets/fonts/verdana.ttf'})
watermark(pdf,"w1",0,297.mm)
watermark(pdf,"w2",0,148.5.mm)
pdf.start_new_page
pdf.font 'Verdana'
pdf.stamp("w1")
box_content(pdf,0,297.mm)
pdf.stamp("w2")
box_content(pdf,0,148.5.mm)
pdf.stroke_line(10.mm,148.5.mm,15.mm,148.5.mm)
pdf.stroke_line(195.mm,148.5.mm,200.mm,148.5.mm)

pdf.render()
