define () ->
  $.extend true,Clns,
    desk:
      stock:
        init: ()->
          $('.focus').focus()
          # Clns.desk.stock.buttons($('button'))
          # Clns.desk.stock.selects($('select.wstm'))
          # Clns.desk.stock.inputs($('input'))
          $log 'Clns.desk.stock.init() OK...'
  Clns.desk.stock
