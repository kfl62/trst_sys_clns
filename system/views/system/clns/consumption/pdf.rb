# encoding: utf-8
# Template for Clns::Consumption#pdf
require 'prawn/measurement_extensions'

def firm
  Clns::PartnerFirm.find_by(:firm => true)
end
def unit
  firm.units.find(@object.unit_id)
end
def table_data(o)
  data = {}
  o.freights.sort_by{|f| f.key}.each do |f|
    k = f.key
    if data[k].nil?
      data[k] = [f.freight.name,f.um,f.pu,f.qu,f.val]
    else
      data[k][3] += f.qu
      data[k][4] += f.val
    end
  end
  data = data.values.sort.each_with_index{|r,i| r.unshift("#{i + 1}.")}
  data.map!{|r| [r[0],r[1],r[2],"%.4f" % r[3],"%.2f" % r[4],"%.2f" % r[5],""]}
end
pdf = Prawn::Document.new(
  :page_size => 'A4',
  :page_layout => :landscape,
  :background => "public/images/clns/pdf/consumption.jpg",
  :skip_page_creation => true,
  :margin => [10.mm],
  :info => {
    :Title => "Bon de consum",
    :Author => "kfl62",
    :Subject => "Formular \"Bon de consum\"",
    :Keywords => "#{firm.name[1]} Bon de consum ",
    :Creator => "http://#{firm.name[0].downcase}.trst.ro (using Sinatra, Prawn)",
    :CreationDate => Time.now
  }
)
pdf.font_families.update(
  'Verdana' => {:bold => 'public/stylesheets/fonts/verdanab.ttf',
                :italic => 'public/stylesheets/fonts/verdanai.ttf',
                :bold_italic => 'public/stylesheets/fonts/verdanaz.ttf',
                :normal => 'public/stylesheets/fonts/verdana.ttf'})
pdf.start_new_page
pdf.font 'Verdana'
pdf.text_box firm.name[2],
             :at => [5.mm, pdf.bounds.top - 6.mm], :style => :bold
pdf.text_box "Nr.intern #{@object.name}",
             :at => [193.mm, pdf.bounds.top - 11.mm], :size => 8
pdf.text_box @object.id_date.to_s,
             :at => [245.mm, pdf.bounds.top - 6.mm], :size => 10, :style => :bold
pdf.text_box "#{unit.slug} - #{unit.name[1]}",
             :at => [25.mm, pdf.bounds.top - 22.5.mm],:width => 115.mm, :size => 10, :align => :center
pdf.text_box "#{unit.chief}",
             :at => [170.mm, pdf.bounds.top - 22.5.mm],:width => 114.mm, :size => 10, :align => :center
pdf.text_box @object.text,
             :at => [25.mm, pdf.bounds.top - 32.5.mm],:width => 250.mm, :size => 10
pdf.text_box "#{unit.chief}",
             :at => [200.mm, pdf.bounds.top - 183.mm], :size => 10
pdf.bounding_box([5.mm, pdf.bounds.top - 52.5.mm], :width  => pdf.bounds.width) do
  data = table_data(@object)
  pdf.table(data, :cell_style => {:borders => []}, :column_widths => [10.mm,100.mm,10.mm,25.mm,25.mm,45.mm,40.mm]) do
    pdf.font_size = 9
    column(0).style(:align => :right, :padding => [5,10,5,0], :height => 10.mm)
    column(2).style(:align => :center)
    column(3..5).style(:align => :right)
  end
end
pdf.render()
