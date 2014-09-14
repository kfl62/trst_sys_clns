define () ->
  $.extend true,Clns,
    desk:
      sorting:
        calculate: ()->
          rfqu = 0
          ffi = $('tr.from-freight').find('input')
          rfi = $('tr.resl-freight').find('input')
          rfi.filter('.qu').each ()->
            v = parseFloat $(@).val()
            if v isnt 0.0
              rfqu += v
              $(@).parentsUntil('tbody').last().find('input.pu').val(ffi.filter('.pu').val())
            return
          rfstk = parseFloat $('select.from-freight option:selected').data('qu')
          $('tr.from-freight').find('span.qus').text(rfqu.toFixed(2))
          ffi.filter('.qu').val(rfqu.toFixed(2))
          $('tr.total').find('span.res').text(rfqu.toFixed(2))
          $('tr.from-freight').find('span.stk').text((rfstk - rfqu).toFixed(2))
          if rfqu is 0.0 then $('button[data-action="save"]').button   'option', 'disabled', true else $('button[data-action="save"]').button   'option', 'disabled', false
          return
        selects: (slcts)->
          slcts.each ()->
            $select = $(@)
            $sd = $select.data()
            if $select.hasClass 'from-freight'
              $select.on 'change', ()->
                $sod = $select.find('option:selected').data()
                f = $('tr.from-freight')
                f.find('span.um').text($sod.um)
                f.find('span.pu').text(parseFloat($sod.pu).toFixed(4))
                f.find('span.qus').text('0.00')
                f.find('span.stk').text(parseFloat($sod.qu).toFixed(2))
                f.find('input').each ()->
                  $(@).val($sod[$(@).attr('class')])
                  $(@).val($('#date_send').val()) if $(@).hasClass('id_date')
                  return
                $('select.resl-freight').val('null')
                $('tr.resl-freight').find('input').val('')
                $('tr.resl-freight').find('input.qu').val('0.00')
                $('button[data-action="save"]').button   'option', 'disabled', true
                if $select.val() is 'null' then $('tbody').addClass('hidden') else $('tbody').removeClass('hidden')
                return
            if $select.hasClass 'resl-freight'
              $select.on 'change', ()->
                $sod = $select.find('option:selected').data()
                $select.parent().find('input').each ()->
                  $(@).val($sod[$(@).attr('class')])
                  $(@).val($('#date_send').val()) if $(@).hasClass('id_date')
                  return
                $select.parentsUntil('tbody').last().find('input.qu').val('0.00').focus().select()
                Clns.desk.sorting.calculate()
                return
            return
          return
        inputs: (inpts)->
          inpts.each ()->
            $input = $(@)
            if $input.attr('id') is 'date_show'
              $input.on 'change', ()->
                if Trst.desk.hdo.dialog is 'create'
                  $('input[name*="id_date"]').each ()->
                    $(@).val($('#date_send').val()) unless $(@).val() is ''
                    return
              return
            if $input.attr('name').search(/resl_freight.+qu\]/) isnt -1
              $input.on 'change', ()->
                if $input.parentsUntil('tbody').last().find('option:selected').val() isnt 'null'
                  $input.decFixed(2)
                  Clns.desk.sorting.calculate()
                else
                  $input.val('0.00')
                  alert 'Select error!'
                return
          return
        buttons: (btns)->
          btns.each ()->
            $button = $(@)
            $bd = $button.data()
            $id = $button.attr('id')
            if Trst.desk.hdo.dialog is 'filter'
              if $bd.action in ['create','show','edit','delete']
                $bd.r_path = 'sys/clns/sorting/filter'
            if Trst.desk.hdo.dialog is 'create'
              if $bd.action is 'save'
                $button.button 'option', 'disabled', true
                $button.data('remove',false)
                $button.off 'click', Trst.desk.buttons.action.save
                $button.on  'click', Clns.desk.sorting.calculate
                $button.on  'click', Trst.desk.buttons.action.save
            else if Trst.desk.hdo.dialog is 'show'
              if $bd.action is 'print'
                $button.on 'click', ()->
                  Trst.msgShow Trst.i18n.msg.report.start
                  $.fileDownload "/sys/clns/sorting/print?id=#{Trst.desk.hdo.oid}",
                    successCallback: ()->
                      Trst.msgHide()
                    failCallback: ()->
                      Trst.msgHide()
                      Trst.desk.downloadError Trst.desk.hdo.model_name
                  false
            else
              ###
              Buttons default handler Trst.desk.buttons
              ###
          $('span i.fa-minus-circle').each ()->
            $button = $(@)
            $button.on 'click', ()->
              $button.parentsUntil('tbody').last().remove()
              Clns.desk.sorting.calculate()
              return
            return
          return
        init: ()->
          if $('#date_show').length
            now = new Date()
            min = if Trst.lst.admin is 'true' then new Date(now.getFullYear(),now.getMonth() - 1,1) else new Date(now.getFullYear(),now.getMonth(),1)
            $('#date_show').datepicker 'option', 'maxDate', '+0'
            $('#date_show').datepicker 'option', 'minDate', min
          Clns.desk.sorting.buttons($('button'))
          Clns.desk.sorting.selects($('select'))
          Clns.desk.sorting.inputs($('input'))
          $log 'Clns.desk.sorting.init() OK...'
  Clns.desk.sorting
