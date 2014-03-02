define () ->
  $.extend true,Clns,
    desk:
      freight:
        createFreightName: ()->
          Clns.desk.freight.selects($('select.clns.freight'))
          $name = "Material"
          $('select.clns.freight').each ()->
            $select = $(@)
            if $select.val() isnt "00"
              $name = $select.find(":selected").text()
          $('input[name="\[clns\/freight\]\[name\]"]').val($name + ' - ')
        inputs: (inpts)->
          inpts.each ()->
            $input = $(@)
            $sd = $input.data()
            $id = $input.attr('id')
            return
          return
        selects: (slcts)->
          slcts.each ()->
            $select = $(@)
            $sd = $select.data()
            $id = $select.attr('id')
            if $select.hasClass('clns') and $select.hasClass('freight')
              $dialog = Trst.desk.hdo.dialog
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
                if $dialog is 'query'
                  $url = "sys/partial/clns/freight/_select_freight_c?id_stats=#{$id_stats}"
                  $('span.select-freight-c').load $url, ()->
                    Clns.desk.freight.selects($('select.clns.freight'))
                    Clns.desk.freight.buttons($('button'))
                    return
                  return
                else
                  $url = "sys/clns/freight/#{$dialog}?id_stats=#{$id_stats}"
                  Trst.lst.setItem 'url', $url
                  Trst.desk.init($url)
                  return
            if $select.hasClass 'param'
              $select.on 'change', ()->
                Clns.desk.freight.buttons($('button'))
                return
            if $select.hasClass 'day'
              $select.on 'change', ()->
                $params = jQuery.param($('.param, .fid').serializeArray())
                $url = "sys/partial/clns/freight/_data_freight?#{$params}"
                Trst.msgShow()
                $('.data-freight').load $url, ()->
                  Clns.desk.freight.selects($('select.param.day'))
                  Trst.msgHide()
                  return
                return
            if $select.hasClass('uid')
              $select.on 'change', ()->
                $params = jQuery.param($('.param').serializeArray())
                $url = "sys/clns/freight/query?#{$params}"
                Trst.desk.init($url)
                return
            return
          return
        buttons: (btns)->
          btns.each ()->
            $button = $(@)
            $bd = $button.data()
            $id = $button.attr('id')
            if $button.hasClass 'query-firm'
              $params = jQuery.param($('.param').serializeArray())
              $url = "sys/partial/clns/freight/_data_firm?#{$params}"
              $button.unbind()
              $button.on 'click', ()->
                Trst.msgShow()
                $('.data-firm').load $url, ()->
                  Clns.desk.freight.buttons($('span.link'))
                  Trst.msgHide()
                  return
                return
            if $button.hasClass 'query-unit'
              $params = jQuery.param($('.param').serializeArray())
              $url = "sys/partial/clns/freight/_data_unit?#{$params}"
              $button.unbind()
              $button.on 'click', ()->
                Trst.msgShow()
                $('.data-unit').load $url, ()->
                  Clns.desk.freight.buttons($('span.link'))
                  Trst.msgHide()
                  return
                return
            if $button.hasClass 'query-freight'
              $params = jQuery.param($('.param').serializeArray())
              $url = "sys/clns/freight/query?#{$params}"
              $button.unbind()
              $button.on 'click', ()->
                Trst.desk.init($url)
                return
            if $button.hasClass 'uid'
              $params = jQuery.param($('.param').serializeArray())
              $url = "sys/clns/freight/query?#{$params}&uid=#{$id}"
              $button.on 'click', ()->
                Trst.desk.init($url)
                return
            if $button.hasClass 'fid'
              $params = jQuery.param($('.param').serializeArray())
              $url = "sys/clns/freight/query?#{$params}&fid=#{$id}"
              $button.on 'click', ()->
                Trst.desk.init($url)
                return
            if $bd.action is 'create'
              if Trst.desk.hdo.dialog is 'filter'
                $button.data().url = Trst.lst.url?.replace 'filter', 'create'
                Trst.lst.removeItem 'url'
            return
          return
        init: ()->
          if Trst.desk.hdo.dialog is 'create'
            Clns.desk.freight.createFreightName()
          Clns.desk.freight.buttons($('button, span.link'))
          Clns.desk.freight.selects($('select'))
          $log 'Clns.desk.freight.init() OK...'
  Clns.desk.freight
