(function() {
  define(function() {
    $.extend(true, Clns, {
      desk: {
        report: {
          init: function() {
            var $file_name;
            $file_name = $('#file_name').val();
            $('#date_show').datepicker('option', 'maxDate', '+0');
            $('#unit_ids').select2({
              placeholder: 'Selectaţi min. un depozit...',
              minimumInputLength: 0,
              multiple: true,
              data: $('#unit_ids').data('data')
            });
            $('button').each(function() {
              var $bd, $button;
              $button = $(this);
              $bd = $button.data();
              if ($bd.action === 'print') {
                return $button.on('click', function() {
                  var $file, $form;
                  $form = $('form');
                  $file = "" + $file_name + ($('#date_send').val());
                  if ($('#period').val() > 1) {
                    $file += "#" + ($('#period').val());
                  }
                  $('#file_name').val($file);
                  Trst.msgShow(Trst.i18n.msg.report.start);
                  return $.fileDownload($form.attr('action'), {
                    data: $form.serialize(),
                    successCallback: function() {
                      return Trst.msgHide();
                    },
                    failCallback: function() {
                      Trst.msgHide();
                      return Trst.desk.downloadError(Trst.desk.hdo.title_data);
                    }
                  });
                });
              }
            });
            $('button').last().focus();
            return $log('Clns.desk.report.init() OK...');
          }
        }
      }
    });
    return Clns.desk.report;
  });

}).call(this);
