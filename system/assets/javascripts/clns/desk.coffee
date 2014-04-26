define () ->
  $.extend true,Clns,
    desk:
      tmp:
        set: (key,value)->
          if @[key] or @[key] is 0 then @[key] else @[key] = value
        clear: (what...)->
          $.each @, (k)=>
            if what.length
              delete @[k] if k in [what...]
            else
              delete @[k] unless k in ['set','clear']
      scrollHeader: (tbl,h=450)->
        $table = $(tbl)
        if h isnt 0
          tblHdr   = $("<table style='width:auto'><tbody class='inner'><tr></tr><tr></tr></tbody></table>")
          tblCntnr = $("<div id='scroll-container' style='height:#{h}px;overflow-x:hidden;overflow-y:scroll'></div>")
          tblClmnW = []
          $table.find('tr.scroll td').each (i)->
            tblClmnW[i] = $(this).width()
            return
          tblscrll = $table.find('tr.scroll').html()
          $table.find('tr.scroll').html('')
          $table.css('width','auto')
          tblHdr.find('tr:first').html(tblscrll)
          tblHdr.find('tr:first td').each (i)->
            $(this).css('width', tblClmnW[i])
            return
          $table.find('tr.scroll').next().find('td').each (i)->
            $(this).css('width', tblClmnW[i])
            return
          $table.before(tblHdr)
          $table.wrap(tblCntnr)
        else
          tblscrll = $('div#scroll-container').prev().find('tr:first').html()
          $('div#scroll-container').prev().remove()
          $table.find('tr.scroll').html(tblscrll)
          $table.unwrap()
        return
      idPnHandle: ()->
        $input = $('input[name*="id_pn"]')
        if Clns.desk.idPnValidate($input.val())
          $input.attr('class','ui-state-default')
          $input.parents('tr').next().find('input').focus()
        else
          $input.attr('class','ui-state-error').focus()
        return
      idPnValidate: (id)->
        $chk = "279146358279"
        $sum = 0
        for i in [0..12]
          do (i)->
            $sum += id.charAt(i) * $chk.charAt(i)
        $mod = $sum % 11
        if ($mod < 10 and $mod.toString() is id.charAt(12)) or ($mod is 10 and id.charAt(12) is "1")
          true
        else
          false
      init: () ->
        if $('#date_show').length
          $dsh = $('#date_show')
          $dsh.datepicker
            altField: '#date_send'
            altFormat: 'yy-mm-dd'
            $.datepicker.regional['ro']
          $dsh.addClass('ce').attr 'size', $dsh.val().length + 2
          $dsh.on 'change', ()->
            $dsh.attr 'size', $dsh.val().length + 2
            return
        if $('input.id_intern').length
          $id_intern = $('input[name*="\[name\]"]')
          $id_intern.attr 'size', $id_intern.val().length + 4
          $id_intern.on 'change', ()->
            $id_intern.attr 'size', $id_intern.val().length + 4
            return
        if Trst.desk.hdo.dialog is 'create' or Trst.desk.hdo.dialog is 'edit'
          if $('input[name*="id_pn"]').length
            Clns.desk.idPnHandle()
            $('input[name*="id_pn"]').on 'keyup', ()->
              Clns.desk.idPnHandle()
          $('input.focus').focus()
          $('select.focus').focus()
        if $('table.scroll').height() > 450
          Clns.desk.scrollHeader($('table.scroll'))
        $log 'Clns.desk.init() Ok...'
        if $('select.clns, input.select2').length
          require (['clns/desk_select']), (select)->
            select.init()
        if $ext = Trst.desk.hdo.js_ext
          require (["clns/#{$ext}"]), (ext)->
            ext.init()
        return
  Clns.desk
