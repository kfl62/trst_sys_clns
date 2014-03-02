# encoding: utf-8
# Template for Clns::DeliveryNote#pdf
require 'prawn/measurement_extensions'
require "prawn/templates"

def firm
  Clns::PartnerFirm.find_by(firm: true)
end

def unit
  firm.units.find(@object.unit_id)
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
pdf.start_new_page
pdf.font 'Verdana'
pdf.text_box firm.name[2],
             at: [15.mm, pdf.bounds.top - 16.mm], style: :bold
pdf.text_box "Formula Aviz de expediție, (În lucru)",
             at: [15.mm, pdf.bounds.top - 30.mm], style: :bold

pdf.render()
