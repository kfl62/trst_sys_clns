# encoding: utf-8
# Template for Clns::Invoice#pdf

def firm
  Clns::PartnerFirm.find_by(firm: true)
end
def address_f
  firm.addresses.first
end
def bank_f
  b = firm.banks.asc(:name).first
  b.nil? ? ["","____ "*6] : [b.name.split('#').reverse.first,b.swift]
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
def bank_c
  b = client.banks.asc(:name).first
  b.nil? ? ["","____ "*6] : [b.name.split('#').reverse.first,b.swift]
end
def dln_ary
  dlns = @object.dlns
  a = dlns.length > 0 ? dlns.map{|d| "AE #{d.doc_name}/#{d.id_date.to_s}"}.join(', ') : nil
end
def recap_data
  h = {}
  h['client_d'] = @object.client_d.name rescue ''
  h['id_date']  = "#{@object.client_d.id_doc['sr'].gsub('-','') rescue ''} #{@object.client_d.id_doc['nr'].gsub('-','') rescue ''}"
  h['doc_plat'] = @object.doc_plat.upcase rescue ''
  h['id_date']  = @object.id_date.to_s
  h
end
def table_goods_data
  data = [["Nr.", "Denumire produs/serviciu", "UM", "Cantitate", "Preț unitar", "Valoare", "TVA"]]
  @object.freights.each_with_index do |f,i|
    ff   = Clns::Freight.find_by(id_stats: f.id_stats)
    name = ff.csn.nil? ? f.name : ff.csn[@object.client_id.to_s] || ff.csn['dflt']
    data << ["#{i + 1}.", name, f.um, "%.2f" % f.qu, "%.4f" % f.pu, "%.2f" % f.val, "%.2f" % f.tva]
  end
  for i in data.length..17 do
    data[i] = [Prawn::Text::NBSP, "","","","","",""]
  end
  unless dln_ary.nil?
    data.push([{content: Prawn::Text::NBSP, colspan: 7}])
  else
    data.push([Prawn::Text::NBSP, "","","","","",""])
  end
  data.push([
    {content: "În cazul în care nu este stabilit prin contract, această factură este scadentă în data de: <b>#{@object.deadl.to_s}</b>",
     colspan: 7}])
  data
end
def table_recap_data
  data = []
  data[0] = ["","Nume delagat",": #{recap_data['client_d']}",{content: "TOTAL",rowspan: 3},{content: "<b>#{"%.2f" % @object.sum_100}</b>",rowspan: 3},{content: "<b>#{"%.2f" % @object.sum_tva}</b>",rowspan: 3}]
  data[1] = ["Semnătută","B.I./C.I.",": #{recap_data['id_doc']}"]
  data[2] = ["Ștampilă","Mijloctransport",": #{recap_data['doc_plat']}"]
  data[3] = ["","Data expedierii",": #{recap_data['id_date']}",{content: "Semnătura de primire",rowspan: 4},{content: "TOTAL DE PLATĂ",rowspan: 2,colspan: 2}]
  data[4] = ["","Întocmit de",": #{@object.signed_by.name rescue ''}"]
  data[5] = ["","CNP",": #{@object.signed_by.id_pn.gsub(/\d{4}$/,'****') rescue ''}",{content: "<b>#{"%.2f" % @object.sum_out} RON</b>",rowspan: 2,colspan: 2}]
  data[6] = ["","Semnătura",":"]
  data
end
def watermark(pdf,name,left,top)
  text = name == "w1" ? "Ex. contabilitate" : "Ex. client"
  pdf.create_stamp(name) do
    pdf.fill_color "e9e9e9"
    pdf.text_box text,
      size:          20.mm,
      width:         190.mm,
      height:        80.mm,
      align:         :center,
      valign:        :center,
      at:            [left,top],
      rotate:        15,
      rotate_around: :center
  end
end
def box_content(pdf,left,top)
  pdf.bounding_box([10.mm, top - 10.mm], width: 60.mm) do
    pdf.font_size = 8
    pdf.text firm.name[2]
    pdf.text "Nr. înreg. R.C. : #{firm.identities['chambcom']}"
    pdf.text "Cod Fiscal (C.U.I.) : #{firm.identities['fiscal']}"
    pdf.text "Str.#{address_f.street}, nr.#{address_f.nr rescue '-'}, bl.#{address_f.bl rescue '-'}, sc.#{address_f.sc rescue '-'}, et.#{address_f.et rescue '-'}, ap.#{address_f.ap rescue '-'}, #{address_f.city rescue '-'}, județul #{address_f.state rescue '-'}"
    pdf.text "Cont: #{bank_f[1]}"
    pdf.text "Banca: #{bank_f[0]}"
  end
  pdf.bounding_box([140.mm, top - 10.mm], width: 60.mm) do
    pdf.font_size = 8
    pdf.text client.name[2]
    pdf.text "Nr. înreg. R.C. : #{client.identities['chambcom']}"
    pdf.text "Cod Fiscal (C.U.I.) : #{client.identities['fiscal']}"
    pdf.text "Str.#{address_c.street}, nr.#{address_c.nr rescue '-'}, bl.#{address_c.bl rescue '-'}, sc.#{address_c.sc rescue '-'}, et.#{address_c.et rescue '-'}, ap.#{address_c.ap rescue '-'}, #{address_c.city rescue '-'}, județul #{address_c.state rescue '-'}"
    pdf.text "Cont: #{bank_c[1]}"
    pdf.text "Banca: #{bank_c[0]}"
  end
  pdf.bounding_box([80.mm, top - 20.mm], width: 50.mm) do
    pdf.text "Factura", align: :center, size: 12, style: :bold
    pdf.move_down 3.mm
    pdf.text "Număr#{Prawn::Text::NBSP}: <b>#{@object.doc_name}</b>", size: 10, inline_format: true
    pdf.text "Data#{Prawn::Text::NBSP*4}: <b>#{@object.id_date.to_s}</b>", size: 10, inline_format: true
  end
  pdf.bounding_box([10.mm, top - 35.mm], width: 190.mm) do
    pdf.text "Cotă TVA 24%", align: :right, size: 9
    pdf.table table_goods_data, cell_style: {border_width: 1, padding: [1,5], size: 8}, column_widths: [10.mm, 70.mm, 10.mm, 25.mm, 25.mm, 25.mm, 25.mm] do |t|
      t.row(0).style(align: :center,background_color: "e9e9e9")
      t.row(1..-1).style(border_width: [0,1,0,1])
      t.row(-1).style(border_width: [0,1,1,1])
      t.column(0).rows(1..-1).style(align: :right)
      t.column(2).style(align: :center)
      t.column(3..6).rows(1..-1).style(align: :right)
      t.cells[18,0].style(align: :left,border_top_width: 1) if dln_ary
      t.cells[19,0].style(align: :left,inline_format: true,background_color: "e9e9e9",border_top_width: 1)
    end
  end
  pdf.bounding_box([10.mm, top - 113.mm], width: 190.mm) do
    pdf.table table_recap_data, cell_style: {padding: [1,5], size: 8}, column_widths: [30.mm, 30.mm, 55.mm, 25.mm, 25.mm, 25.mm] do
      row(0..6).style(border_width: [0,1,0,1],background_color: "e9e9e9",inline_format: true)
      column(1..2).rows(0..6).style(border_width: 0)
      row(6).style(border_bottom_width: 1)
      column(0).style(align: :center)
      cells[0,3].style(align: :center,valign: :center,size:11,border_bottom_width: 1)
      cells[0,4].style(align: :right,valign: :center,inline_format: true,background_color: "e9e9e9",border_bottom_width: 1)
      cells[0,5].style(align: :right,valign: :center,inline_format: true,background_color: "e9e9e9",border_bottom_width: 1)
      cells[3,3].style(align: :center,valign: :top,border_bottom_width: 1)
      cells[3,4].style(align: :center,valign: :center,size:11,background_color: "e9e9e9")
      cells[5,4].style(align: :center,valign: :center,size:11,border_bottom_width: 1)
    end
  end
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
                normal: 'public/stylesheets/fonts/verdana.ttf'
  }
)

if @object.grns.count > 0
  pdf.start_new_page
  pdf.font 'Verdana'
  pdf.text_box "Factură furnizor! Tipăriți NIR-ul pentru detalii...", at: [10.mm,287.mm]
  pdf.text_box "(Reparații intrări căutați în data de: #{@object.id_date.to_s})", at: [10.mm,282.mm],size: 8
else
  watermark(pdf,"w1",10,262.mm)
  watermark(pdf,"w2",0,113.5.mm)

  pdf.start_new_page
  pdf.font 'Verdana'
  pdf.stamp("w1")
  box_content(pdf,0,297.mm)
  pdf.stamp("w2")
  box_content(pdf,0,148.5.mm)
  if dln_ary
    pdf.text_box "Produse livrate conform: #{dln_ary}",at: [10.mm + 5,184.mm + 21],size: 8, height: 10,width: 190.mm, overflow: :shrink_to_fit,valign: :center
    pdf.text_box "Produse livrate conform: #{dln_ary}",at: [10.mm + 5,35.5.mm + 21],size: 8, height: 10,width: 190.mm, overflow: :shrink_to_fit,valign: :center
  end
  pdf.stroke_line(10.mm,148.5.mm,15.mm,148.5.mm)
  pdf.stroke_line(195.mm,148.5.mm,200.mm,148.5.mm)
end

pdf.render()
