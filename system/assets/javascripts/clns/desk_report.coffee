define () ->
  $.extend true,Clns,
    desk:
      report:
        init: ()->
          $file_name = $('#file_name').val()
          $('#date_show').datepicker 'option', 'maxDate', '+0'
          $('#unit_ids').select2
            placeholder: 'Selectaţi min. un depozit...'
            minimumInputLength: 0
            multiple: true
            data: $('#unit_ids').data('data')
          $('button').each ()->
            $button = $(@)
            $bd = $button.data()
            if $bd.action is 'print'
              $button.on 'click', ()->
                $form  = $('form')
                $file  = "#{$file_name}#{$('#date_send').val()}"
                $file += "##{$('#period').val()}" if $('#period').val() > 1
                $('#file_name').val($file)
                Trst.msgShow Trst.i18n.msg.report.start
                $.fileDownload $form.attr('action'),
                  data: $form.serialize()
                  successCallback: ()->
                    Trst.msgHide()
                  failCallback: ()->
                    Trst.msgHide()
                    Trst.desk.downloadError Trst.desk.hdo.title_data
          $('button').last().focus()
          $log 'Clns.desk.report.init() OK...'
  Clns.desk.report
