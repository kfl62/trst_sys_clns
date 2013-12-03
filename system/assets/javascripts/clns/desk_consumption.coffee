define () ->
  $.extend true,Clns,
    desk:
      consumption:
        init: ()->
          if $('#date_show').length
            now = new Date()
            min = if Trst.lst.admin is 'true' then new Date(now.getFullYear(),now.getMonth() - 1,1) else min = new Date(now.getFullYear(),now.getMonth(),1)
            $('#date_show').datepicker 'option', 'maxDate', '+0'
            $('#date_show').datepicker 'option', 'minDate', min
          # Clns.desk.consumption.buttons($('button'))
          # Clns.desk.consumption.selects($('select.clns,input.select2,input.repair'))
          # Clns.desk.consumption.inputs($('input'))
          # Clns.desk.consumption.template = $('tr.template')?.remove()
          $log 'Clns.desk.consumption.init() OK...'
  Clns.desk.consumption
