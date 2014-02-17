define () ->
  $.extend true,Clns,
    desk:
      partner_firm:
        updateDocAry: (inpts)->
          inpts.filter(':checked').each ()->
            Clns.desk.partner_firm.doc_ary.push(@id)
          inpts.filter('.param').val(@doc_ary)
          $params = jQuery.param($('.param').serializeArray())
          $url = "/sys/clns/partner_firm/query?#{$params}"
          Trst.desk.init($url)
          return
        inputs: (inpts)->
          inpts.filter(':checkbox').on 'change', ()->
            Clns.desk.partner_firm.updateDocAry(inpts)
        selects: (slcts)->
          slcts.each ()->
            $select = $(@)
            $sd = $select.data()
            $id = $select.attr('id')
            if $select.hasClass 'select2'
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
            else
              $select.on 'change', ()->
                $('.param.doc_ary').val('') if $(@).hasClass('firm')
                $params = jQuery.param($('.param').serializeArray())
                $url = "/sys/clns/partner_firm/query?#{$params}"
                Trst.desk.init($url)
          return
        buttons: (btns)->
          btns.each ()->
            $button = $(@)
            $bd = $button.data()
            $id = $button.attr('id')
            if $bd.action is 'print'
              $button.on 'click', ()->
                Trst.msgShow Trst.i18n.msg.report.start
                $url  = "/sys/clns/report/print?rb=yearly_stats"
                $url += "&fn=#{$bd.fn}" if $bd.fn
                $url += "&uid=#{$bd.uid}" if $bd.uid
                $.fileDownload $url,
                  successCallback: ()->
                    Trst.msgHide()
                  failCallback: ()->
                    Trst.msgHide()
                    Trst.desk.downloadError Trst.desk.hdo.model_name
                false
            else if $bd.action is 'toggle_checkbox'
              $button.on 'click', ()->
                if $('input.param.doc_ary').val().split(',')[0] is "" or $('input.param.doc_ary').val().split(',').length < $('input:checkbox').length
                  $('input:checkbox').each ()->
                    Clns.desk.partner_firm.doc_ary.push(@id)
                else
                  Clns.desk.partner_firm.doc_ary = []
                $('input.param.doc_ary').val(Clns.desk.partner_firm.doc_ary)
                $params = jQuery.param($('.param').serializeArray())
                $url = "/sys/clns/partner_firm/query?#{$params}"
                Trst.desk.init($url)
                return
              return
          return
        init: ()->
          @doc_ary = []
          Clns.desk.partner_firm.buttons($('button'))
          Clns.desk.partner_firm.selects($('select.param,input.select2'))
          Clns.desk.partner_firm.inputs($('input.doc_ary'))
          $log 'Clns.desk.partner_firm.init() OK...'
  Clns.desk.partner_firm
