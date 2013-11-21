define () ->
  $.extend true,Clns,
    desk:
      delivery_note:
        validate:
          filter: ()->
            if $('#client_id').val() isnt '' and $('#client_d_id').val() isnt 'new'
              $url = Trst.desk.hdf.attr('action')
              $url += "?client_id=#{$('#client_id').val()}"
              $url += "&client_d_id=#{$('#client_d_id').val()}" if $('#client_d_id').val() isnt '' and $('#client_d_id').val() isnt 'new'
              $('button.dn').data('url', $url)
              $('button.dn').button 'option', 'disabled', false
            else
              $('button.dn').button 'option', 'disabled', true
            return
        selects: (slcts)->
          slcts.each ()->
            $select = $(@)
            $sd = $select.data()
            $id = $select.attr('id')
            if $select.hasClass 'select2'
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
                          $dlgadd.data('url','/sys/wstm/partner_firm_person')
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
          Clns.desk.delivery_note.buttons($('button'))
          Clns.desk.delivery_note.selects($('select.wstm,input.select2,input.repair'))
          $log 'Clns.desk.delivery_note.init() OK...'
  Clns.desk.delivery_note
