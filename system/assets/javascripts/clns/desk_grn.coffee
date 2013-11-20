define () ->
  $.extend true,Clns,
    desk:
      grn:
        grnCalculate: ()->
          vf = $('tr.grn-freight')
          vt = $('tr.grn-freight-total')
          i = 0; vtval = 0; vttva = 0; vtout = 0
          vf.each ()->
            $row = $(@)
            $row.find('input').each ()->
              $input = $(@)
              $input.attr('name', $input.attr('name').replace(/\d/,i) )
              vtval += parseFloat($input.val()) if $input.hasClass('val')
              vttva += parseFloat($input.val()) if $input.hasClass('tva')
              vtout += parseFloat($input.val()) if $input.hasClass('out')
            i += 1
          vt.find('span.val').text vtval.toFixed(2)
          vt.find('input.val').val vtval.round(2)
          vt.find('span.tva').text vttva.toFixed(2)
          vt.find('input.tva').val vttva.round(2)
          vt.find('span.out').text vtout.toFixed(2)
          vt.find('input.out').val vtout.round(2)
          return
        freightInsert: ()->
          r = Clns.desk.grn.freightCalculate().result;
          v = Clns.desk.grn.template.clone().removeClass('template')
          i = $('tr.grn-freight').length; id_date = $('input#date_send').val()
          # v.find('input').each ()->
          #   $(@).attr('name', $(@).attr('name').replace(/\d/,i) )
          v.find('span.name').text(r.name)
          v.find('input.freight_id').val(r.freight_id)
          v.find('input.id_stats').val(r.id_stats)
          v.find('input.id_date').val($('input#date_send').val())
          v.find('input.id_intern').val($('input#id_intern').val())
          v.find('input.um').val(r.um)
          v.find('span.um').text(r.um)
          v.find('input.pu').val(r.pu)
          v.find('span.pu').text r.pu.toFixed(2)
          v.find('input.qu').val(r.qu)
          v.find('span.qu').text r.qu.toFixed(2)
          v.find('input.val').val(r.sval)
          v.find('span.val').text r.sval.toFixed(2)
          v.find('input.tva').val(r.stva)
          v.find('span.tva').text r.stva.toFixed(2)
          v.find('input.out').val(r.sout)
          v.find('span.out').text r.sout.toFixed(2)
          $('tr.grn-freight-header, tr.grn-freight-total').removeClass('hidden')
          $('tr.grn-freight-total').before(v)
          Clns.desk.grn.buttons($('span.button'))
          Clns.desk.grn.grnCalculate()
        freightCalculate: ()->
          v  = $('.add-freight')
          name = v.filter('.name').data('name')
          ids  = v.filter('.name').data('id_stats')
          idd  = v.filter('.name').data('id_date')
          fid  = v.filter('.name').data('freight_id')
          um   = v.filter('.um').val()
          tva  = parseFloat v.filter('.name').data('tva')
          pu   = parseFloat v.filter('.pu').decFixed(2).val()
          qu   = parseFloat v.filter('.qu').decFixed(2).val()
          $val = (pu * qu).round(2)
          $tva = ($val * tva).round(2)
          $out = ($val + $tva).round(2)
          v.filter('.val').text $val.toFixed(2)
          v.filter('.tva').text $tva.toFixed(2)
          v.filter('.out').text $out.toFixed(2)
          result:
            freight_id: fid; name: name; id_stats: ids; um: um; tva: tva; pu: pu; qu: qu
            sval: $val; stva: $tva; sout: $out
        validate:
          filter: ()->
            if $('#supplr_id').val() isnt '' and $('#suppr_d_id').val() isnt 'new'
              $url = Trst.desk.hdf.attr('action')
              $url += "?supplr_id=#{$('#supplr_id').val()}"
              $url += "&supplr_d_id=#{$('#supplr_d_id').val()}" if $('#supplr_d_id').val() isnt '' and $('#supplr_d_id').val() isnt 'new'
              $('button.grn').data('url', $url)
              $('button.grn').button 'option', 'disabled', false
            else
              $('button.grn').button 'option', 'disabled', true
            return
          create: ()->
            if $('select.doc_type').length
              if $('select.doc_type').val() isnt 'null' and $('input[name*="doc_name"]').val() isnt '' and $('input[name*="doc_plat"]').val() isnt ''
                $('button[data-action="save"]').button 'option', 'disabled', false
                $('span.icon-plus-sign').show()
                return true
            return
        selects: (slcts)->
          slcts.each ()->
            $select = $(@)
            $sd = $select.data()
            $id = $select.attr('id')
            if $select.hasClass 'clns doc_type'
              $('tr.inv').hide()
              $select.on 'change', ()->
                $('input[name*="doc_date"]').val($('#date_send').val())
                if $select.val() is 'INV'
                  $('tr.dn').hide()
                  $('tr.inv').show()
                  $('input[name*="deadl"]').val($('#date_send').val())
                  $('input[name*="\[pyms\]\[id_date\]"]').val($('#date_send').val())
                else
                  $('tr.dn').show()
                  $('tr.inv').hide()
                $select.next().focus()
            else if $select.hasClass 'clns freight'
              $id_stats = $('select.clns.freight.oid option:selected').data('id_stats') || '00000000'
              $select.on 'change', ()->
                if Clns.desk.grn.validate.create()
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
                  else
                    $id_stats = c0 + c1 + c2 + "00"
                  $url = "/sys/partial/clns/shared/_doc_add_freight?id_stats=#{$id_stats}"
                  $('td.add-freight-container').load $url, ()->
                    Clns.desk.grn.selects($('select.clns.freight'))
                    if $id_stats.slice(-2) isnt '00'
                      $('span.button.flri').removeClass('hidden')
                      Clns.desk.grn.buttons($('span.button'))
                      $('.focus').focus().select()
                else
                  alert Trst.i18n.msg.grn_not_complete
                  $('button[data-action="save"]').button 'option', 'disabled', true
                  $url = "/sys/partial/clns/shared/_doc_add_freight?id_stats=00000000"
                  $('td.add-freight-container').load $url, ()->
                    Clns.desk.grn.selects($('select.clns.freight'))
               return
            else if $select.hasClass 'select2'
              if $id in ['supplr_id','transp_id']
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
                          $dlgadd.data('r_path','/sys/clns/grn/filter')
                          $dlgadd.data('r_id',$select.select2('val'))
                          $dlgadd.data('r_mdl','firm')
                          $dlgadd.show()
                        else
                          $dlg.next().hide()
                      else
                        $dlg.next().hide()
                      Clns.desk.grn.validate.filter()
                  else
                    $select.next().select2('data',null)
                    $select.next().select2('destroy')
                    $select.next().next().hide()
                  Clns.desk.grn.validate.filter()
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
              if $id in ['supplr_d','transp_d']
                $button.hide()
              if $bd.action is 'create'
                if $('input:checked').length is 0
                  $button.button 'option', 'disabled', true if $button.hasClass 'grn'
                else
                  $bd   = $button.data()
                  $url  = '/sys/clns/grn/create?id_intern=true'
                  $url += "&unit_id=#{Trst.desk.hdo.unit_id}"
                  $url += "&dln_ary=#{Wstm.desk.grn.dln_ary}"
                  $bd.url = $url
                  $button.button 'option', 'disabled', false
            else if Trst.desk.hdo.dialog is 'create'
              unless Clns.desk.grn.validate.create()
                if $bd.action is 'save'
                  $button.button 'option', 'disabled', true
              if $button.hasClass 'icon-refresh'
                $button.off 'click'
                $button.on 'click', ()->
                  Clns.desk.grn.freightCalculate()
              if $button.hasClass 'icon-plus-sign'
                $button.off 'click'
                $button.on 'click', ()->
                  Clns.desk.grn.freightInsert()
              if $button.hasClass 'icon-minus-sign'
                $button.off 'click'
                $button.on 'click', ()->
                  $button.parentsUntil('tbody').last().remove()
                  Clns.desk.grn.grnCalculate()
                  if $('tr.grn-freight').length is 0
                    $('tr.grn-freight-header, tr.grn-freight-total').addClass('hidden')
            else if Trst.desk.hdo.dialog is 'show'
              if $bd.action is 'print'
                $button.on 'click', ()->
                  Trst.msgShow Trst.i18n.msg.report.start
                  $.fileDownload "/sys/clns/grn/print?id=#{Trst.desk.hdo.oid}",
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
        init: ()->
          if $('#date_show').length
            now = new Date()
            min = if Trst.lst.admin is 'true' then new Date(now.getFullYear(),now.getMonth() - 1,1) else min = new Date(now.getFullYear(),now.getMonth(),1)
            $('#date_show').datepicker 'option', 'maxDate', '+0'
            $('#date_show').datepicker 'option', 'minDate', min
          Clns.desk.grn.buttons($('button'))
          Clns.desk.grn.selects($('select.clns,input.select2,input.repair'))
          # Clns.desk.grn.inputs($('input'))
          Clns.desk.grn.template = $('tr.template')?.remove()
          $log 'Clns.desk.grn.init() OK...'
  Clns.desk.grn