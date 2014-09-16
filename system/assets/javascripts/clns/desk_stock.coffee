define () ->
  $.extend true,Clns,
    desk:
      stock:
        calculate: ()->
          return
        inputs: (inpts)->
          inpts.each ()->
            $input = $(@)
            $ind = $input.data()
            return
          return
        selects: (slcts)->
          slcts.each ()->
            $select = $(@)
            $sd = $select.data()
            return
          return
        buttons: (btns)->
          btns.each ()->
            $button = $(@)
            $bd = $button.data()
            if Trst.desk.hdo.dialog is 'filter'
              if $bd.action in ['create','show','edit','delete']
                $bd.r_path = 'sys/clns/stock/filter'
            return
          return
        init: ()->
          Clns.desk.stock.buttons($('button'))
          # Clns.desk.stock.selects($('select.wstm'))
          # Clns.desk.stock.inputs($('input'))
          $log 'Clns.desk.stock.init() OK...'
  Clns.desk.stock
