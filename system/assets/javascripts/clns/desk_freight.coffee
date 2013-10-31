define () ->
  $.extend true,Clns,
    desk:
      freight:
        handleFreight: ($dialog = 'filter')->
          $('select.clns.freight').each ()->
            $select = $(@)
            $select.on 'change', ()->
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
              $id_stats = c0 + c1 + c2 + "00"
              $url = "sys/clns/freight/#{$dialog}?id_stats=#{$id_stats}"
              Trst.lst.setItem 'url', $url
              Trst.desk.init($url)
        handleIdStats: ()->
          Clns.desk.freight.handleFreight('create')
          $name = "Material"
          $('select.clns.freight').each ()->
            $select = $(@)
            if $select.val() isnt "00"
              $name = $select.find(":selected").text()
          $('input[name="\[clns\/freight\]\[name\]"]').val($name + ' - ')
        init: ()->
          if Trst.desk.hdo.dialog is 'filter'
            $('button[data-action="create"]').data().url = Trst.lst.url?.replace 'filter', 'create'
            Trst.lst.removeItem 'url'
            Clns.desk.freight.handleFreight()
          if Trst.desk.hdo.dialog is 'create'
            Clns.desk.freight.handleIdStats()
          $log 'Clns.desk.freight.init() OK...'
  Clns.desk.freight
