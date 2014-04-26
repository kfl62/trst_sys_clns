define () ->
  $.extend true,Clns,
    desk:
      cache_book:
        linesNewReset: ()->
          next = $('tr.lines').not('.hidden').length + 1
          if next is 1
            $('tr.lines-header, tr.lines-total').addClass('hidden')
            $('button.cb').button 'option', 'disabled', true
          else
            $('tr.lines-header, tr.lines-total').removeClass('hidden')
            $('button.cb').button 'option', 'disabled', false
          $('span.lines').text(next - 1)
          $('span.add-line').text(next + '.')
          $('input.add-line').val('')
          $('input.add-line.doc').focus()
          return
        linesNewData: ()->
          v   = $('.add-line')
          ord = $('tr.lines').not('.hidden').length + 1
          doc = v.filter('.doc').val()
          exp = v.filter('.exp').val()
          ins = v.filter('.ins').val(); if ins is '' then ins = 0 else ins = parseFloat(ins)
          out = v.filter('.out').val(); if out is '' then out = 0 else out = parseFloat(out)
          result:
            ord: ord; doc: doc; exp: exp; ins: ins; out: out
        linesInsert: ()->
          r = Clns.desk.cache_book.linesNewData().result
          l = Clns.desk.cache_book.template.clone().removeClass('template')
          l.find('span.ord').text(r.ord + '.')
          l.find('input.ord').val(r.ord)
          l.find('span.doc').text(r.doc)
          l.find('input.doc').val(r.doc)
          l.find('span.exp').text(r.exp)
          l.find('input.exp').val(r.exp)
          l.find('span.ins').text(r.ins.toFixed(2))
          l.find('input.ins').val(r.ins)
          l.find('span.out').text(r.out.toFixed(2))
          l.find('input.out').val(r.out)
          $('tr.lines-total').before(l)
          Clns.desk.cache_book.calculate()
          Clns.desk.cache_book.linesNewReset()
          Clns.desk.cache_book.buttons($('span.button'))
          return
        calculate: ()->
          r  = Clns.desk.cache_book.linesNewData().result
          vl = $('tr.lines').not('.hidden')
          vt = $('tr.lines-total')
          ib = parseFloat $('input.ib').val()
          i  = 1; vtins = 0; vtout = 0;
          vl.each ()->
            $row = $(@)
            $row.find('input').each ()->
              $input = $(@)
              $input.attr('name', $input.attr('name').replace(/\d/,i) )
              $input.val(i) if $input.hasClass('ord')
              vtins += parseFloat($input.val()) if $input.hasClass('ins')
              vtout += parseFloat($input.val()) if $input.hasClass('out')
            $row.find('span.ord').text(i + '.')
            i += 1
          vt.find('span.tot-in').text vtins.toFixed(2)
          vt.find('span.tot-out').text vtout.toFixed(2)
          $fb = ib + vtins - vtout
          $('input.fb').val($fb)
          $('span.fb').text($fb.toFixed(2))
          if r.ord > 25 and $('#scroll-container').length is 0 then Clns.desk.scrollHeader('table.scroll',380)
          if r.ord < 26 and $('#scroll-container').length is 1 then Clns.desk.scrollHeader('table.scroll',0)
          return
        inputs: (inpts)->
          inpts.each ()->
            $input = $(@)
            $ind = $input.data()
            if $input.hasClass('add-line')
              $input.on 'keyup', ()->
                $('button.cb').button 'option', 'disabled', true if $input.val() isnt ''
                return
              if $input.hasClass('ins') or $input.hasClass('out')
                $input.on 'keypress', (e)->
                  if e.which is 13
                    Clns.desk.cache_book.linesInsert()
            return
          return
        selects: (slcts)->
          slcts.each ()->
            $select = $(@)
            $sd = $select.data()
            if Trst.desk.hdo.dialog is 'filter'
              $select.on 'change', ()->
                $params = jQuery.param($('.param').serializeArray())
                $url = "sys/clns/cache_book/filter?#{$params}"
                Trst.desk.init($url)
                return
            return
          return
        buttons: (btns)->
          btns.each ()->
            $button = $(@)
            $bd = $button.data()
            if $button.hasClass('link')
              if Trst.desk.hdo.dialog is 'filter'
                $button.on 'click', ()->
                  if $bd.oid is 'nil'
                    $url = "sys/clns/cache_book/create?id_date=#{$bd.id_date}"
                  else
                    $url = "sys/clns/cache_book/#{$bd.oid}"
                  Trst.desk.init($url)
                  return
            else if $button.hasClass('icon-plus-sign')
              $button.off 'click'
              $button.on 'click', ()->
                Clns.desk.cache_book.linesInsert()
                return
            else if $button.hasClass('icon-refresh')
              $button.off 'click'
              $button.on 'click', ()->
                Clns.desk.cache_book.linesNewReset()
                return
            else if $button.hasClass('icon-minus-sign')
              $tr = $button.parentsUntil('tbody').last()
              $button.off 'click'
              $button.on 'click', ()->
                if Trst.desk.hdo.dialog is 'create'
                  $tr.remove()
                  Clns.desk.cache_book.calculate()
                  Clns.desk.cache_book.linesNewReset()
                if Trst.desk.hdo.dialog is 'edit'
                  if $tr.find('input._id').length
                    $tr.addClass('hidden')
                    $nested = $tr.find('input').last().clone()
                    $nested.attr('name', $nested.attr('name').replace('out','_destroy'))
                    $nested.val(1)
                    $tr.find('input').last().after($nested)
                    $tr.find('input').each ()->
                      $input = $(@)
                      $input.attr('name', $input.attr('name').replace(/(\d)/,'_$1') )
                  else
                    $tr.remove()
                  Clns.desk.cache_book.calculate()
                  Clns.desk.cache_book.linesNewReset()
                return
            else if Trst.desk.hdo.dialog is 'show'
              if $bd.action is 'print'
                $button.on 'click', ()->
                  Trst.msgShow Trst.i18n.msg.report.start
                  $.fileDownload "/sys/clns/cache_book/print?id=#{Trst.desk.hdo.oid}",
                    successCallback: ()->
                      Trst.msgHide()
                    failCallback: ()->
                      Trst.msgHide()
                      Trst.desk.downloadError Trst.desk.hdo.model_name
                  return
            return
          return
        init: ()->
          Clns.desk.cache_book.buttons($('button, span.link, span.button'))
          Clns.desk.cache_book.selects($('select.param, input.select2, input.repair'))
          Clns.desk.cache_book.inputs($('input'))
          Clns.desk.cache_book.template = $('tr.template')?.remove()
          Clns.desk.cache_book.linesNewReset()
          $log 'Clns.desk.cache_book.init() OK...'
          return
  Clns.desk.cache_book
