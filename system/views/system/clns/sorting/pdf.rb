# encoding: utf-8
# Template for Clns::Sorting#pdf

def firm
  Clns::PartnerFirm.find_by(firm: true)
end

pdf = Prawn::Document.new(
  page_size: 'A4',
  page_layout: :landscape,
  margin: [10.mm],
  info: {
    Title: "PV_Sortare_Preparare",
    Author: "kfl62",
    Subject: "Formular \"PV de Sortare/Preparare\"",
    Keywords: "#{firm.name[1].titleize} Proces Verbal Sortare Preparare",
    Creator: "http://#{firm.name[0].downcase}.trst.ro (using Sinatra, Prawn)",
    CreationDate: Time.now
  }
)
pdf.font_families.update(
  'Verdana' => {bold: 'public/stylesheets/fonts/verdanab.ttf',
                italic: 'public/stylesheets/fonts/verdanai.ttf',
                bold_italic: 'public/stylesheets/fonts/verdanaz.ttf',
                normal: 'public/stylesheets/fonts/verdana.ttf'})
pdf.font 'Verdana'
pdf.text 'Încă nu este gata..., Anexaţi formularul completat manual!'
pdf.render()
