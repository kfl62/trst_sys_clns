# encoding: utf-8
# Template for Listă inventar.pdf
require 'prawn/measurement_extensions'

def firm
  Clns::PartnerFirm.find_by(firm: true)
end
def address
  firm.addresses.first
end
def unit_ids
  params[:unit_ids].split(',').map{|id| Moped::BSON::ObjectId(id)}
end
def unit(uid)
  firm.units.find(uid)
end
def stock(uid)
  u = unit(uid)
  y,m = params[:date].split('-').map(&:to_i)
  d = y == 2000 ? 31 : 1
  u.stks.find_by(id_date: Date.new(y,m,d))
end
def title
  if params[:date] == "2000-01"
    title = "Stoc curent #{Date.today.to_s}"
  else
    title = "Stoc inițial #{params[:date]}"
  end
  title
end
def table_data(uid)
  s, data, i = stock(uid), [], 1
  if s
    data[0] = ["Nr.","Denumire","UM","Cantitate","PU (informativ)","Valoare"]
    freights = params['type_0'] == 'all' ? s.freights.asc(:id_statsm, :pu) : s.freights.asc(:id_stats, :pu).where(id_stats: /\A(02|03|05|06)/)
    ary = freights.each_with_object({}) do |f,h|
      key = params['type_1'] == 'id' ? f.id_stats : f.key
      if f.qu.round(2) > 0
        if h[key].nil?
          h[key] = [f.name,f.um,f.qu,f.pu,f.val]
        else
          h[key][2] += f.qu
          h[key][4] += f.val
        end
      end
    end #.sort.to_h.values
    ary = Hash[ary.sort].values # ary.sort.to_h only ruby v2.1
    ary.each_with_index do |a,i|
      a[3] = a[4] / a[2] if params['type_1'] == 'id'
      data << ["#{i + 1}.",a[0],a[1],"%.2f" % a[2],"%.4f" % a[3],"%.2f" % a[4]]
    end
  else
    data = [["","Invalid date","","","",""]]
  end
  data
end
pdf = Prawn::Document.new(
  page_size: 'A4',
  page_layout: :portrait,
  skip_page_creation: true,
  margin: [10.mm],
  info: {
    Title: "Lista inventar",
    Author: "kfl62",
    Subject: "Formular \"Listă inventar\"",
    Keywords: "#{firm.name[1]} Listă inventar ",
    Creator: "http://#{firm.name[0].downcase}.trst.ro (using Sinatra, Prawn)",
    CreationDate: Time.now
  }
)
pdf.font_families.update(
  'Verdana' => {bold: 'public/stylesheets/fonts/verdanab.ttf',
                italic: 'public/stylesheets/fonts/verdanai.ttf',
                bold_italic: 'public/stylesheets/fonts/verdanaz.ttf',
                normal: 'public/stylesheets/fonts/verdana.ttf'})
unit_ids.each do |uid|
  unit = unit(uid)
  pdf.start_new_page
  pdf.font 'Verdana'
  pdf.bounding_box([0, 277.mm], width: 60.mm) do
    pdf.font_size = 8
    pdf.text firm.name[2]
    pdf.text "Nr. înreg. R.C. : #{firm.identities['chambcom']}"
    pdf.text "Cod Fiscal (C.U.I.) : #{firm.identities['fiscal']}"
    pdf.text "Str.#{address.street}, nr.#{address.nr rescue '-'}, bl.#{address.bl rescue '-'}, sc.#{address.sc rescue '-'}, et.#{address.et rescue '-'}, ap.#{address.ap rescue '-'}, #{address.city rescue '-'}, județul #{address.state rescue '-'}"
  end
  pdf.bounding_box([150.mm, 277.mm], width: 60.mm) do
    pdf.font_size = 8
    pdf.text unit.name[1]
    pdf.text unit.chief
  end
  pdf.bounding_box([65.mm, 260.mm], width: 60.mm) do
    pdf.text title, align: :center, size: 12, style: :bold
  end
  pdf.move_down 5.mm
  pdf.table table_data(uid),cell_style: {border_width: 0.1,padding: [1,5],size: 8},column_widths: [10.mm,70.mm,10.mm,25.mm,25.mm,25.mm],position: :center,header: :true do
    row(0).style(align: :center)
    column(0).rows(1..-1).style(align: :right)
    column(2).rows(1..-1).style(align: :center)
    column(3..6).rows(1..-1).style(align: :right)
  end
end
pdf.render()
