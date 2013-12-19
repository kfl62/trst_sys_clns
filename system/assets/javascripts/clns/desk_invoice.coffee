define () ->
  $.extend true,Clns,
    desk:
      invoice:
        calculate: ()->
          $rows  = $('tr.freight')
          $total = $('tr.total')
          tot_vi = 0; tot_ti = 0; tot_oi = 0
          $rows.each ()->
            $tr = $(@)
            pu  = $tr.find('input[name*="pu"]').decFixed(4)
            qu  = $tr.find('input[name*="qu"]').decFixed(2)
            tva = parseFloat $tr.find('input[name*="pu"]').data('tva')
            val = (parseFloat(pu.val()) * parseFloat(qu.val())).round(2)
            tva = (val * tva).round(2)
            out = (val + tva).round(2)
            tot_vi += val
            tot_ti += tva
            tot_oi += out
            $tr.find('span.val_invoice').text(val.toFixed(2))
            $tr.find('input.val').val(val.toFixed(2))
            $tr.find('span.tva_invoice').text(tva.toFixed(2))
            $tr.find('input.tva').val(tva.toFixed(2))
            $tr.find('span.out_invoice').text(out.toFixed(2))
            $tr.find('input.tot').val(out.toFixed(2))
          $total.find('span.sum_100').text(tot_vi.toFixed(2))
          $total.find('input[name*="sum_100"]').val(tot_vi.toFixed(2))
          $total.find('span.sum_tva').text(tot_ti.toFixed(2))
          $total.find('input[name*="sum_tva"]').val(tot_ti.toFixed(2))
          $total.find('span.sum_out').text(tot_oi.toFixed(2))
          $total.find('input[name*="sum_out"]').val(tot_oi.toFixed(2))
          if tot_vi > 0
            $('button[data-action="save"]').button 'option', 'disabled', false
          else
            $('button[data-action="save"]').button 'option', 'disabled', true
          return
        selectedGrns: ()->
          @grn_ary = []
          $('input:checked').each ()->
            Clns.desk.invoice.grn_ary.push(@id)
            return
          $url = Trst.desk.hdf.attr('action')
          $url += "/filter?y=#{$('select.y').val()}"
          $url += "&m=#{$('select.m').val()}"
          if Clns.desk.invoice.grn_ary.length
            $url += "&supplr_id=#{$('#supplr_id').val()}"
            $url += "&grn_ary=#{Clns.desk.invoice.grn_ary}"
            Clns.desk.tmp.clear()
            Clns.desk.tmp.set('supplr',$('#supplr_id').select2('data'))
            Clns.desk.tmp.set('supplr_d',$('#supplr_d_id').select2('data'))
          else
            $url += "&grn_ary=true"
            Clns.desk.tmp.clear()
            delete @grn_ary
          Trst.desk.init($url)
          return
        selectedDeliveryNotes: ()->
          @dln_ary = []
          $('input:checked').each ()->
            Clns.desk.invoice.dln_ary.push(@id)
            return
          $url = Trst.desk.hdf.attr('action')
          $url += "/filter?y=#{$('select.y').val()}"
          $url += "&m=#{$('select.m').val()}"
          if Clns.desk.invoice.dln_ary.length
            $url += "&client_id=#{$('#client_id').val()}"
            $url += "&dln_ary=#{Clns.desk.invoice.dln_ary}"
            Clns.desk.tmp.clear()
            Clns.desk.tmp.set('client',$('#client_id').select2('data'))
            Clns.desk.tmp.set('client_d',$('#client_d_id').select2('data'))
          else
            $url += "&dln_ary=true"
            Clns.desk.tmp.clear()
            delete @dln_ary
          Trst.desk.init($url)
          return
        validate:
          filter: ()->
            if Trst.desk.hdo.title_data?
              if $('#supplr_id').val() isnt '' and $('#supplr_d_id').val() isnt '' and $('#supplr_d_id').val() isnt 'new'
                $url = Trst.desk.hdf.attr('action')
                $url += "/filter?grn_ary=true&y=#{$('select.y').val()}"
                $url += "&m=#{$('select.m').val()}"
                $url += "&supplr_id=#{$('#supplr_id').val()}"
                Clns.desk.tmp.clear('supplr').set('supplr',$('#supplr_id').select2('data'))
                Clns.desk.tmp.clear('supplr_d').set('supplr_d',$('#supplr_d_id').select2('data'))
                Trst.desk.init($url)
              else
                $('.grns').hide()
            else
              if $('#client_id').val() isnt '' and $('#client_d_id').val() isnt '' and $('#client_d_id').val() isnt 'new'
                $url = Trst.desk.hdf.attr('action')
                $url += "/filter?dln_ary=true&y=#{$('select.y').val()}"
                $url += "&m=#{$('select.m').val()}"
                $url += "&client_id=#{$('#client_id').val()}"
                Clns.desk.tmp.clear('client').set('client',$('#client_id').select2('data'))
                Clns.desk.tmp.clear('client_d').set('client_d',$('#client_d_id').select2('data'))
                Trst.desk.init($url)
              else
                $('.dlns').hide()
            return
        inputs:  (inpts)->
          inpts.each ()->
            $input = $(@)
            $id = $input.attr('id')
            if $input.hasClass 'dln_ary'
              $input.on 'change', ()->
                Clns.desk.invoice.selectedDeliveryNotes()
                return
            if $input.hasClass 'grn_ary'
              $input.on 'change', ()->
                Clns.desk.invoice.selectedGrns()
                return
            if $input.attr('name')?.match(/([^\[^\]]+)/g).pop() is 'doc_name'
              if Trst.desk.hdo.title_data?
                $input.on 'change', ()->
                    inpts.filter('[name*="\[name\]"]:not([type="hidden"])').val($(@).val())
                    $('button[data-action="save"]').button 'option', 'disabled', false
                  return
              else
                $input.on 'change', ()->
                  if inpts.filter('[name*="pu\]"]:not([type="hidden"])').length
                    inpts.filter('[name*="pu\]"]:not([type="hidden"])').first().focus()
                  else
                    $('button[data-action="save"]').button 'option', 'disabled', false
                  return
            if $input.attr('name')?.match(/([^\[^\]]+)/g).pop() is 'pu'
              $input.on 'change', ()->
                Clns.desk.invoice.calculate()
                return
          return
        selects: (slcts)->
          slcts.each ()->
            $select = $(@)
            $sd = $select.data()
            $id = $select.attr('id')
            if $select.hasClass 'select2'
              if $id is 'client_id'
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
                if Clns.desk.tmp.client
                  $select.select2('data',Clns.desk.tmp.client)
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
                  $dlg.select2('data',Clns.desk.tmp.client_d)
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
                    Clns.desk.invoice.validate.filter()
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
                      Clns.desk.invoice.validate.filter()
                  else
                    $select.next().select2('data',null)
                    $select.next().select2('destroy')
                    $select.next().next().hide()
                  Clns.desk.invoice.validate.filter()
              if $id is 'supplr_id'
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
                if Clns.desk.tmp.supplr
                  $select.select2('data',Clns.desk.tmp.supplr)
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
                  $dlg.select2('data',Clns.desk.tmp.supplr_d)
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
                    Clns.desk.invoice.validate.filter()
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
                      Clns.desk.invoice.validate.filter()
                  else
                    $select.next().select2('data',null)
                    $select.next().select2('destroy')
                    $select.next().next().hide()
                  Clns.desk.invoice.validate.filter()
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
                return
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
              if $id in ['client_d','supplr_d']
                $button.hide()
              if $bd.action is 'create'
                if $('input:checked').length is 0
                  $button.button 'option', 'disabled', true if $button.hasClass 'inv'
                else
                  $bd   = $button.data()
                  $url = Trst.desk.hdf.attr('action')
                  $url += "/create?y=#{$('select.y').val()}"
                  $url += "&m=#{$('select.m').val()}"
                  if Clns.desk.invoice.dln_ary?.length
                    $url += "&client_id=#{Clns.desk.tmp.client.id}"
                    $url += "&client_d_id=#{Clns.desk.tmp.client_d.id}"
                    $url += "&dln_ary=#{Clns.desk.invoice.dln_ary}"
                  if Clns.desk.invoice.grn_ary?.length
                    $url += "&supplr_id=#{Clns.desk.tmp.supplr.id}"
                    $url += "&supplr_d_id=#{Clns.desk.tmp.supplr_d.id}"
                    $url += "&grn_ary=#{Clns.desk.invoice.grn_ary}"
                  $bd.url = $url
                  $button.button 'option', 'disabled', false
                  $button.on 'click', ()->
                    Clns.desk.tmp.clear()
              if $bd.action is 'cancel'
                $button.on 'click', ()->
                  Clns.desk.tmp.clear()
            else if Trst.desk.hdo.dialog is 'show'
              if $bd.action is 'print'
                $button.on 'click', ()->
                  Trst.msgShow Trst.i18n.msg.report.start
                  $.fileDownload "/sys/clns/invoice/print?id=#{Trst.desk.hdo.oid}",
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
        init: ()->
          if $('#date_show').length
            now = new Date()
            min = if Trst.lst.admin is 'true' then new Date(now.getFullYear(),now.getMonth() - 1,1) else min = new Date(now.getFullYear(),now.getMonth(),1)
            $('#date_show').datepicker 'option', 'maxDate', '+0'
            $('#date_show').datepicker 'option', 'minDate', min
          $('.focus').focus()
          Clns.desk.invoice.buttons($('button'))
          Clns.desk.invoice.selects($('select.clns,input.select2,input.repair'))
          Clns.desk.invoice.inputs($('input'))
          $log 'Clns.desk.invoice.init() OK...'
  Clns.desk.invoice
