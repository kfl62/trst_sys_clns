# encoding: utf-8
# Template for Clns::CacheBook#pdf
require 'prawn/measurement_extensions'

def firm
  Clns::PartnerFirm.find_by(firm: true)
end
def address
  firm.addresses.first
end
def table_data(o)
  data = []
  data[0] = ["Nr.", "Document", "Explicație", "Încasare", "Plată", "Cont"]
  o.lines.asc(:order).each do |l|
    data << ["#{l.order}.",l.doc,l.expl,"%.2f" % l.in,"%.2f" % l.out,' ']
  end
  data
end
def table_recap(o)
  data = []
  data[0] = ["Total data:", o.id_date.to_s, "Sold precedent:", "%.2f" % o.ib]
  data[1] = [" ", " ", "Încasări:", "%.2f" % o.lines.sum(:in).round(2)]
  data[2] = [" ", " ", "Plăți:", "%.2f" % o.lines.sum(:out).round(2)]
  data[3] = [" ", " ", "Sold final:", "%.2f" % o.fb]
  data
end
pdf = Prawn::Document.new(
  page_size: 'A4',
  page_layout: :portrait,
  skip_page_creation: true,
  margin: [10.mm],
  info: {
    Title: "Registru de casă",
    Author: "kfl62",
    Subject: "Formular \"Registru de casă\"",
    Keywords: "#{firm.name[1]} Registru de casă ",
    Creator: "http://#{firm.name[0].downcase}.trst.ro (using Sinatra, Prawn)",
    CreationDate: Time.now
  }
)
pdf.font_families.update(
  'Verdana' => {bold: 'public/stylesheets/fonts/verdanab.ttf',
                italic: 'public/stylesheets/fonts/verdanai.ttf',
                bold_italic: 'public/stylesheets/fonts/verdanaz.ttf',
                normal: 'public/stylesheets/fonts/verdana.ttf'})
pdf.start_new_page
pdf.font 'Verdana'
pdf.font_size = 8
pdf.text firm.name[2]
pdf.text "Nr. înreg. R.C. : #{firm.identities['chambcom']}"
pdf.text "Cod Fiscal (C.U.I.) : #{firm.identities['fiscal']}"
pdf.text "Str. #{address.street},nr.#{address.nr rescue '-'},bl.#{address.bl rescue '-'},sc.#{address.sc rescue '-'},et.#{address.et rescue '-'},ap.#{address.ap rescue '-'}"
pdf.text "#{address.city rescue '-'}, județul #{address.state rescue '-'}"
pdf.move_down 15
pdf.text "Registru de casă pagina: #{@object.name} din date de #{@object.id_date.to_s}",
  size: 11
pdf.move_down 15
pdf.table table_data(@object), cell_style: {border_width: 0.1, padding: [2,5,2,5], size: 9}, column_widths: [10.mm,30.mm,100.mm,20.mm,20.mm,10.mm] do
  row(0).style(align: :center, background_color: "f9f9f9", padding:[5,0])
  column(0).rows(1..-1).style(align: :right)
  column(3..4).rows(1..-1).style(align: :right)
end
pdf.move_down 15
pdf.table table_recap(@object),cell_style: {border_width: 0, padding: [2,5], size: 9}, column_widths: [30.mm, 30.mm, 40.mm, 30.mm], position: :center do
  column(3).style(align: :right)
end
pdf.move_down 15
pdf.text "Întocmit                        Financiat/Contabil", align: :center,size: 11
pdf.render()
