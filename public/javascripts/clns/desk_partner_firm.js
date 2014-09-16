(function() {
  define(function() {
    $.extend(true, Clns, {
      desk: {
        partner_firm: {
          updateDocAry: function(inpts) {
            var $params, $url;
            inpts.filter(':checked').each(function() {
              return Clns.desk.partner_firm.doc_ary.push(this.id);
            });
            inpts.filter('.param').val(this.doc_ary);
            $params = jQuery.param($('.param').serializeArray());
            $url = "/sys/clns/partner_firm/query?" + $params;
            Trst.desk.init($url);
          },
          inputs: function(inpts) {
            return inpts.filter(':checkbox').on('change', function() {
              return Clns.desk.partner_firm.updateDocAry(inpts);
            });
          },
          selects: function(slcts) {
            slcts.each(function() {
              var $id, $ph, $sd, $select;
              $select = $(this);
              $sd = $select.data();
              $id = $select.attr('id');
              if ($select.hasClass('select2')) {
                $ph = Trst.i18n.select[Trst.desk.hdo.js_ext][$sd.ph];
                $select.select2({
                  placeholder: $ph,
                  minimumInputLength: $sd.minlength,
                  allowClear: true,
                  ajax: {
                    url: "/utils/search/" + $sd.search,
                    dataType: 'json',
                    quietMillis: 100,
                    data: function(term) {
                      return {
                        q: term
                      };
                    },
                    results: function(data) {
                      return {
                        results: data
                      };
                    }
                  }
                });
                $select.unbind();
                return $select.on('change', function() {
                  Trst.desk.hdo.oid = $select.select2('val') === '' ? null : $select.select2('val');
                });
              } else {
                return $select.on('change', function() {
                  var $params, $url;
                  if ($(this).hasClass('firm')) {
                    $('.param.doc_ary').val('');
                  }
                  $params = jQuery.param($('.param').serializeArray());
                  $url = "/sys/clns/partner_firm/query?" + $params;
                  return Trst.desk.init($url);
                });
              }
            });
          },
          buttons: function(btns) {
            btns.each(function() {
              var $bd, $button, $id;
              $button = $(this);
              $bd = $button.data();
              $id = $button.attr('id');
              if ($bd.action === 'print') {
                return $button.on('click', function() {
                  var $url;
                  Trst.msgShow(Trst.i18n.msg.report.start);
                  $url = "/sys/clns/report/print?rb=yearly_stats";
                  if ($bd.fn) {
                    $url += "&fn=" + $bd.fn;
                  }
                  if ($bd.uid) {
                    $url += "&uid=" + $bd.uid;
                  }
                  $.fileDownload($url, {
                    successCallback: function() {
                      return Trst.msgHide();
                    },
                    failCallback: function() {
                      Trst.msgHide();
                      return Trst.desk.downloadError(Trst.desk.hdo.model_name);
                    }
                  });
                  return false;
                });
              } else if ($bd.action === 'toggle_checkbox') {
                $button.on('click', function() {
                  var $params, $url;
                  if ($('input.param.doc_ary').val().split(',')[0] === "" || $('input.param.doc_ary').val().split(',').length < $('input:checkbox').length) {
                    $('input:checkbox').each(function() {
                      return Clns.desk.partner_firm.doc_ary.push(this.id);
                    });
                  } else {
                    Clns.desk.partner_firm.doc_ary = [];
                  }
                  $('input.param.doc_ary').val(Clns.desk.partner_firm.doc_ary);
                  $params = jQuery.param($('.param').serializeArray());
                  $url = "/sys/clns/partner_firm/query?" + $params;
                  Trst.desk.init($url);
                });
              }
            });
          },
          init: function() {
            this.doc_ary = [];
            Clns.desk.partner_firm.buttons($('button'));
            Clns.desk.partner_firm.selects($('select.param,input.select2'));
            Clns.desk.partner_firm.inputs($('input.doc_ary'));
            return $log('Clns.desk.partner_firm.init() OK...');
          }
        }
      }
    });
    return Clns.desk.partner_firm;
  });

}).call(this);
