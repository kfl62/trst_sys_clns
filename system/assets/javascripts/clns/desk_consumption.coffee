define () ->
  $.extend true,Clns,
    desk:
      consumption:
        consumptionCalculate: ()->
          vf = $('tr.consumption-freight')
          vt = $('tr.consumption-freight-total')
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
          r = Clns.desk.consumption.freightCalculate().result;
          v = Clns.desk.consumption.template.clone().removeClass('template')
          i = $('tr.consumption-freight').length; id_date = $('input#date_send').val()
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
          $('tr.consumption-freight-header, tr.consumption-freight-total').removeClass('hidden')
          $('tr.consumption-freight-total').before(v)
          Clns.desk.consumption.buttons($('span.button'))
          Clns.desk.consumption.consumptionCalculate()
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
            result:
              freight_id: fid; name: name; id_stats: ids; um: um; pu: pu; qu: qu; qus: $qus; sval: $val
          else
            alert Trst.i18n.msg.consumption_negative_stock
              .replace(/%\{um\}/g,um)
              .replace('%{stck}',qus.toFixed(2))
              .replace('%{res}',(qu - qus).toFixed(2))
            $('.focus').focus().select()
        validate:
          create: ()->
            if $('input[name*="text"]').val() isnt ''
              if $('tr.consumption-freight').length is 0
                $('button[data-action="save"]').button 'option', 'disabled', true
              else
                $('button[data-action="save"]').button 'option', 'disabled', false
              return true
        selects: (slcts)->
          slcts.each ()->
            $select = $(@)
            $sd = $select.data()
            $id = $select.attr('id')
            if $select.hasClass 'clns freight'
              $id_stats = $('select.clns.freight.oid option:selected').data('id_stats') || '00000000'
              $select.on 'change', ()->
                if Clns.desk.consumption.validate.create()
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
                  $url = "/sys/partial/clns/shared/_doc_add_freight_stock?id_stats=#{$id_stats}"
                  $url += "&oid=#{$oid}" if $oid
                  $('td.add-freight-container').load $url, ()->
                    Clns.desk.consumption.selects($('select.clns.freight'))
                    if $id_stats.slice(-2) isnt '00'
                      $('span.button.flri').removeClass('hidden')
                      Clns.desk.consumption.buttons($('span.button'))
                      $('.focus').focus().select()
                else
                  alert Trst.i18n.msg.consumption_not_complete
                  $('button[data-action="save"]').button 'option', 'disabled', true
                  $url = "/sys/partial/clns/shared/_doc_add_freight_stock?id_stats=00000000"
                  $('td.add-freight-container').load $url, ()->
                    Clns.desk.consumption.selects($('select.clns.freight'))
        buttons: (btns)->
          btns.each ()->
            $button = $(@)
            $bd = $button.data()
            $id = $button.attr('id')
            if Trst.desk.hdo.dialog is 'create'
              unless Clns.desk.consumption.validate.create()
                if $bd.action is 'save'
                  $button.button 'option', 'disabled', true
              if $button.hasClass 'icon-refresh'
                $button.off 'click'
                $button.on 'click', ()->
                  Clns.desk.consumption.freightCalculate()
              if $button.hasClass 'icon-plus-sign'
                $button.off 'click'
                $button.on 'click', ()->
                  Clns.desk.consumption.freightInsert()
                  $url = "/sys/partial/clns/shared/_doc_add_freight_stock?id_stats=00000000"
                  $('td.add-freight-container').load $url, ()->
                    Clns.desk.consumption.selects($('select.clns.freight'))
              if $button.hasClass 'icon-minus-sign'
                $button.off 'click'
                $button.on 'click', ()->
                  $button.parentsUntil('tbody').last().remove()
                  Clns.desk.consumption.consumptionCalculate()
                  if $('tr.consumption-freight').length is 0
                    $('tr.consumption-freight-header, tr.consumption-freight-total').addClass('hidden')
                    $('button[data-action="save"]').button 'option', 'disabled', true
            else
              ###
              Buttons default handler Trst.desk.buttons
              ###
            return
          return
        init: ()->
          if $('#date_show').length
            now = new Date()
            min = if Trst.lst.admin is 'true' then new Date(now.getFullYear(),now.getMonth() - 1,1) else min = new Date(now.getFullYear(),now.getMonth(),1)
            $('#date_show').datepicker 'option', 'maxDate', '+0'
            $('#date_show').datepicker 'option', 'minDate', min
          Clns.desk.consumption.buttons($('button'))
          Clns.desk.consumption.selects($('select.clns,input.select2,input.repair'))
          # Clns.desk.consumption.inputs($('input'))
          Clns.desk.consumption.template = $('tr.template')?.remove()
          $log 'Clns.desk.consumption.init() OK...'
  Clns.desk.consumption
