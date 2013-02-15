define () ->
  $.extend true,Clns,
    desk:
      partner_firm:
        init: ()->
          $('input.select2')?.each ()->
            $select = $(@)
            $sd = $select.data()
            $ph = Trst.i18n.select[Trst.desk.hdo.js_ext][$sd.ph]
            $select.select2
              placeholder: $ph
              minimumInputLength: $sd.minlength
              allowClear: true
              ajax:
                url: "/utils/search/#{$sd.search}"
                dataType: 'json'
                quietMillis: 100
                data: (term)->
                  q: term
                results: (data)->
                  results: data
            $select.unbind()
            $select.on 'change', ()->
              Trst.desk.hdo.oid = if $select.select2('val') is '' then null else $select.select2('val')
              return
            return
          $log 'Clns.desk.partner_firm.init() OK...'
  Clns.desk.partner_firm
