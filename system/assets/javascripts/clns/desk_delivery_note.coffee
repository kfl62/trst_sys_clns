define () ->
  $.extend true,Clns,
    desk:
      delivery_note:
        dlnCalculate: ()->
          vf = $('tr.dln-freight')
          vt = $('tr.dln-freight-total')
          i = 0; vtval = 0
          vf.each ()->
            $row = $(@)
            $row.find('input').each ()->
              $input = $(@)
              $input.attr('name', $input.attr('name').replace(/\d/,i) )
            $row.find('span').each ()->
              $span = $(@)
              vtval += parseFloat($span.text()) if $span.hasClass('val')
            i += 1
          vt.find('span.val').text vtval.toFixed(2)
          return
        freightInsert: ()->
          r = Clns.desk.delivery_note.freightCalculate().result;
          v = Clns.desk.delivery_note.template.clone().removeClass('template')
          i = $('tr.dln-freight').length; id_date = $('input#date_send').val()
          v.find('span.name').text(r.name)
          v.find('input.freight_id').val(r.freight_id)
          v.find('input.id_stats').val(r.id_stats)
          v.find('input.id_date').val($('input#date_send').val())
          v.find('input.id_intern').val($('input#id_intern').val())
          v.find('input.um').val(r.um)
          v.find('span.um').text(r.um)
          v.find('input.pu').val(r.pu)
          v.find('span.pu').text r.pu.toFixed(4)
          v.find('span.stk.qu').text r.qus.toFixed(2)
          v.find('input.qu').val(r.qu)
          v.find('span.out.qu').text r.qu.toFixed(2)
          v.find('input.val').val(r.sval)
          v.find('span.val').text r.sval.toFixed(2)
          v.find('input.pu_invoice').val(r.pu_invoice)
          v.find('input.val_invoice').val(r.val_invoice)
          $('tr.dln-freight-header, tr.dln-freight-total').removeClass('hidden')
          $('tr.dln-freight-total').before(v)
          Clns.desk.delivery_note.buttons($('span.button i'))
          Clns.desk.delivery_note.dlnCalculate()
          return
        freightCalculate: ()->
          v  = $('.add-freight')
          name = v.filter('.name').data('name')
          ids  = v.filter('.name').data('id_stats')
          idd  = v.filter('.name').data('id_date')
          fid  = v.filter('.name').data('freight_id')
          qus  = parseFloat v.filter('.name').data('qu')
          um   = v.filter('.um').text()
          pu   = parseFloat v.filter('.pu').decFixed(4).text()
          qu   = parseFloat v.filter('input.qu').decFixed(2).val()
          if qus - qu >= 0
            $val = (pu * qu).round(2)
            $qus = (qus - qu).round(2)
            v.filter('.val').text $val.toFixed(2)
            v.filter('span.qu').text((qus - qu).toFixed(2))
            $pu_invoice  = if v.filter('.pu_inv').prop('checked') then 1.0 else 0.0
            $val_invoice = if v.filter('.pu_inv').prop('checked') then 1.0 else 0.0
            result:
              freight_id: fid; name: name; id_stats: ids; um: um; pu: pu; qu: qu; qus: $qus; sval: $val; pu_invoice: $pu_invoice; val_invoice: $val_invoice
          else
            alert(Trst.i18n.msg.delivery_note_negative_stock
              .replace(/%\{um\}/g,um)
              .replace('%{stck}',qus.toFixed(2))
              .replace('%{res}',(qu - qus).toFixed(2)))
            $('.focus').focus().select()
        validate:
          filter: ()->
            if $('#client_id').val() isnt '' and $('#client_d_id').val() isnt 'new'
              $url = Trst.desk.hdf.attr('action')
              $url += "?client_id=#{$('#client_id').val()}"
              $url += "&client_d_id=#{$('#client_d_id').val()}" if $('#client_d_id').val() isnt '' and $('#client_d_id').val() isnt 'new'
              $('button[data-action="create"]').data('url', $url)
              $('button[data-action="create"]').button 'option', 'disabled', false
            else
              $('button[data-action="create"]').button 'option', 'disabled', true
            return
          create: ()->
            if $('input[name*="doc_name"]').val() isnt '' and $('input[name*="doc_plat"]').val() isnt ''
              if $('tr.dln-freight').length is 0
                $('button[data-action="save"]').button 'option', 'disabled', true
              else
                $('button[data-action="save"]').button 'option', 'disabled', false
              $('span.fa-plus-circle').show()
              return true
            else if $('input[name*="doc_name"]').val() is '' and $('input[name*="doc_plat"]').val() isnt ''
              $('input[name*="doc_name"]').val("#{$('input.id_intern').val().split('_')[1]}-#{$('input.id_intern').val().split('-')[1]}")
              Clns.desk.delivery_note.validate.create()
        selects: (slcts)->
          slcts.each ()->
            $select = $(@)
            $sd = $select.data()
            $id = $select.attr('id')
            if $select.hasClass 'clns freight'
              $id_stats = $('select.clns.freight.oid option:selected').data('id_stats') || '00000000'
              $select.on 'change', ()->
                if Clns.desk.delivery_note.validate.create()
                  if $select.hasClass('c0')
                    c0 = $select.val()
                    c1 = "00"; c2 = "00";
                    $('select.clns.freight.c1').val(c1)
                    $('select.clns.freight.c2').val(c2)
                  if $select.hasClass('c1')
                    c0 = $('select.clns.freight.c0').val()
                    c1 = $select.val()
                    c2 = "00";
                    $('select.clns.freight.c2').val(c2)
                  if $select.hasClass('c2')
                    c0 = $('select.clns.freight.c0').val()
                    c1 = $('select.clns.freight.c1').val()
                    c2 = $select.val()
                  if $select.hasClass('oid')
                    $id_stats = $('select.clns.freight.oid option:selected').data('id_stats') || '00000000'
                    if $('select.clns.freight.oid option:selected').val() isnt 'null'
                      $oid = $('select.clns.freight.oid option:selected').val()
                  else
                    $id_stats = c0 + c1 + c2 + "00"
                  $pu_inv = if $('input.add-freight.pu_inv').length then $('input.add-freight.pu_inv').prop('checked') else false
                  $url = "/sys/partial/clns/shared/_doc_add_freight_stock?id_stats=#{$id_stats}"
                  $url += "&oid=#{$oid}" if $oid
                  $url += "&pu_inv=#{$pu_inv}"
                  $('td.add-freight-container').load $url, ()->
                    Clns.desk.delivery_note.selects($('select.clns.freight'))
                    if $id_stats.slice(-2) isnt '00'
                      $('span.button.fl-ri').removeClass('hidden')
                      Clns.desk.delivery_note.buttons($('span.button i'))
                      $('.focus').focus().select()
                else
                  alert Trst.i18n.msg.delivery_note_not_complete
                  $('button[data-action="save"]').button 'option', 'disabled', true
                  $url = "/sys/partial/clns/shared/_doc_add_freight_stock?id_stats=00000000"
                  $('td.add-freight-container').load $url, ()->
                    Clns.desk.delivery_note.selects($('select.clns.freight'))
            else if $select.hasClass 'select2'
              if $id in ['client_id','transp_id']
                $ph = Trst.i18n.select[Trst.desk.hdo.js_ext][$sd.ph]
                $select.select2
                  placeholder: $ph
                  minimumInputLength: $sd.minlength
                  allowClear: true
                  ajax:
                    url: "/utils/search/#{$sd.search}"
                    dataType: 'json'
                    quietMillis: 100
                    data: (term)->
                      w: $id.split('_')[0]
                      q: term
                    results: (data)->
                      results: data
                $select.unbind()
                $select.on 'change', ()->
                  if $select.select2('data')
                    $select.next().select2('data',null)
                    $select.next().select2('destroy')
                    $dlg   = $select.next()
                    $dlgsd = $dlg.data()
                    $dlgph = Trst.i18n.select[Trst.desk.hdo.js_ext][$dlgsd.ph]
                    $dlg.select2
                      placeholder: $dlgph
                      minimumInputLength: $dlgsd.minlength
                      allowClear: true
                      ajax:
                        url: "/utils/search/#{$sd.search}"
                        dataType: 'json'
                        data: (term)->
                          id: $select.select2('val')
                        results: (data)->
                          results: data
                    $dlg.unbind()
                    $dlg.on 'change', ()->
                      if $dlg.select2('data')
                        if $dlg.select2('data').id is 'new'
                          $dlgadd = $dlg.next()
                          $dlgadd.data('url','/sys/clns/partner_firm/person')
                          $dlgadd.data('r_id',$select.select2('val'))
                          $dlgadd.data('r_mdl','firm')
                          $dlgadd.show()
                        else
                          $dlg.next().hide()
                      else
                        $dlg.next().hide()
                      Clns.desk.delivery_note.validate.filter()
                  else
                    $select.next().select2('data',null)
                    $select.next().select2('destroy')
                    $select.next().next().hide()
                  Clns.desk.delivery_note.validate.filter()
            else if $select.hasClass 'repair'
              $ph = Trst.i18n.select[Trst.desk.hdo.js_ext][$sd.ph]
              $select.select2
                placeholder: $ph
                allowClear: true
                quietMillis: 1000
                ajax:
                  url: "/utils/search/#{$sd.search}"
                  dataType: 'json'
                  data: (term)->
                    uid: $sd.uid
                    day: $('#date_send').val()
                    q:   term
                  results: (data)->
                    results: data
                formatResult: (d)->
                  $markup  = "<div title='#{d.text.title}'>"
                  $markup += "<span class='repair'>Doc: </span>"
                  $markup += "<span class='truncate-70'>#{d.text.doc_name}</span>"
                  $markup += "<span class='repair'> - Firma: </span>"
                  $markup += "<span class='truncate-200'>#{d.text.client}</span>"
                  $markup += "</div>"
                  $markup
                formatSelection: (d)->
                  d.text.name
                formatSearching: ()->
                  Trst.i18n.msg.searching
                formatNoMatches: (t)->
                  Trst.i18n.msg.no_matches
              $select.off()
              $select.on 'change', ()->
                if $select.select2('val') isnt ''
                  $url  = Trst.desk.hdf.attr('action')
                  $url += "/#{$select.select2('val')}"
                  Trst.desk.closeDesk(false)
                  Trst.desk.init($url)
            else
              $log 'Select not handled!'
            return
          return
        buttons: (btns)->
          btns.each ()->
            $button = $(@)
            $bd = $button.data()
            $id = $button.attr('id')
            if Trst.desk.hdo.dialog is 'filter'
              if $id in ['client_d','transp_d']
                $button.hide()
              if $bd.action is 'create'
                $button.button 'option', 'disabled', true unless $id
            else if Trst.desk.hdo.dialog is 'create'
              unless Clns.desk.delivery_note.validate.create()
                if $bd.action is 'save'
                  $button.button 'option', 'disabled', true
              if $button.hasClass 'fa-bars'
                $button.off 'click'
                $button.on 'click', ()->
                  $('td.add-freight-container').toggle()
              if $button.hasClass 'fa-refresh'
                $button.off 'click'
                $button.on 'click', ()->
                  Clns.desk.delivery_note.freightCalculate()
              if $button.hasClass 'fa-plus-circle'
                $button.off 'click'
                $button.on 'click', ()->
                  Clns.desk.delivery_note.freightInsert()
                  $url = "/sys/partial/clns/shared/_doc_add_freight_stock?id_stats=00000000"
                  $('td.add-freight-container').load $url, ()->
                    Clns.desk.delivery_note.selects($('select.clns.freight'))
              if $button.hasClass 'fa-minus-circle'
                $button.off 'click'
                $button.on 'click', ()->
                  $button.parentsUntil('tbody').last().remove()
                  Clns.desk.delivery_note.dlnCalculate()
                  if $('tr.dln-freight').length is 0
                    $('tr.dln-freight-header, tr.dln-freight-total').addClass('hidden')
                    $('button[data-action="save"]').button 'option', 'disabled', true
            else if Trst.desk.hdo.dialog is 'show'
              if $bd.action is 'print'
                $button.on 'click', ()->
                  Trst.msgShow Trst.i18n.msg.report.start
                  $.fileDownload "/sys/clns/delivery_note/print?id=#{Trst.desk.hdo.oid}",
                    successCallback: ()->
                      Trst.msgHide()
                    failCallback: ()->
                      Trst.msgHide()
                      Trst.desk.downloadError Trst.desk.hdo.model_name
                  return
                return
            else
              ###
              Buttons default handler Trst.desk.buttons
              ###
            return
          return
        init: ()->
          Clns.desk.tmp.clear()
          if $('#date_show').length
            now = new Date()
            min = if Trst.lst.admin is 'true' then new Date(now.getFullYear(),now.getMonth() - 1,1) else new Date(now.getFullYear(),now.getMonth(),1)
            $('#date_show').datepicker 'option', 'maxDate', '+0'
            $('#date_show').datepicker 'option', 'minDate', min
          $('.focus').focus()
          Clns.desk.delivery_note.buttons($('button, span.button i'))
          Clns.desk.delivery_note.selects($('select.clns,input.select2,input.repair'))
          Clns.desk.delivery_note.template = $('tr.template')?.remove()
          $log 'Clns.desk.delivery_note.init() OK...'
  Clns.desk.delivery_note
