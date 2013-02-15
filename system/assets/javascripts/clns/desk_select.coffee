define () ->
  $.extend true,Clns,
    desk:
      select:
        unit: (node)->
          $select = node
          $select.change ()->
            if $select.val() is 'null' then Clns.unit_info.update() else Clns.unit_info.update($select.find('option:selected').text())
            $model  = Trst.desk.hdo.js_ext.split(/_(.+)/)[1]
            $dialog = Trst.desk.hdo.dialog
            Trst.desk.init("/utils/units/clns/#{$model}/#{$dialog}/#{$select.val()}")
            return
          return
        select2: (node)->
          $select = node
          $sd = $select.data()
          $.extend true, $.fn.select2.defaults,
            formatInputTooShort: (input, min)->
              Clns.desk.select.inputTooShortMsg(input, min)
            formatSearching: ()->
              Trst.i18n.msg.searching
            formatNoMatches: (term)->
             Trst.i18n.msg.no_matches
          return
        inputTooShortMsg: (input, min)->
          $msg = Trst.i18n.msg.input_too_short_strt.replace '%{nr}', (min - input.length) if input.length is 0
          $msg = Trst.i18n.msg.input_too_short_more.replace '%{nr}', (min - input.length) if input.length isnt 0
          $msg = Trst.i18n.msg.input_too_short_last if (min - input.length) is 1
          $msg
        init: () ->
          $('select.clns, input.select2').each ()->
            $select =  $(@)
            if $select.hasClass('select2')
              Clns.desk.select.select2($select)
            else if $select.hasClass('unit')
              Clns.desk.select.unit($select)
            else if $select.hasClass('freight') or $select.hasClass('y') or $select.hasClass('m') or $select.hasClass('p03')
              ###
              Handled by Clns.desk.expenditure|delivery_note...
              ###
            else
              $log 'Unknown class for select...'
            return
          $log 'Clns.select.init() OK...'
  Clns.desk.select
