(function() {
  define(function() {
    $.extend(true, Clns, {
      desk: {
        cache_book: {
          linesNewReset: function() {
            var next;
            next = $('tr.lines').not('.hidden').length + 1;
            if (next === 1) {
              $('tr.lines-header, tr.lines-total').addClass('hidden');
              $('button[data-action=save]').button('option', 'disabled', true);
            } else {
              $('tr.lines-header, tr.lines-total').removeClass('hidden');
              $('button[data-action=save]').button('option', 'disabled', false);
            }
            $('span.lines').text(next - 1);
            $('span.add-line').text(next + '.');
            $('input.add-line').val('');
            $('input.add-line.doc').focus();
          },
          linesNewData: function() {
            var doc, exp, ins, ord, out, v;
            v = $('.add-line');
            ord = $('tr.lines').not('.hidden').length + 1;
            doc = v.filter('.doc').val();
            exp = v.filter('.exp').val();
            ins = v.filter('.ins').val();
            if (ins === '') {
              ins = 0;
            } else {
              ins = parseFloat(ins);
            }
            out = v.filter('.out').val();
            if (out === '') {
              out = 0;
            } else {
              out = parseFloat(out);
            }
            return {
              result: {
                ord: ord,
                doc: doc,
                exp: exp,
                ins: ins,
                out: out
              }
            };
          },
          linesInsert: function() {
            var l, r;
            r = Clns.desk.cache_book.linesNewData().result;
            l = Clns.desk.cache_book.template.clone().removeClass('template');
            l.find('span.ord').text(r.ord + '.');
            l.find('input.ord').val(r.ord);
            l.find('span.doc').text(r.doc);
            l.find('input.doc').val(r.doc);
            l.find('span.exp').text(r.exp);
            l.find('input.exp').val(r.exp);
            l.find('span.ins').text(r.ins.toFixed(2));
            l.find('input.ins').val(r.ins);
            l.find('span.out').text(r.out.toFixed(2));
            l.find('input.out').val(r.out);
            $('tr.lines-total').before(l);
            Clns.desk.cache_book.calculate();
            Clns.desk.cache_book.linesNewReset();
            Clns.desk.cache_book.buttons($('span.button'));
          },
          calculate: function() {
            var $fb, i, ib, r, vl, vt, vtins, vtout;
            r = Clns.desk.cache_book.linesNewData().result;
            vl = $('tr.lines').not('.hidden');
            vt = $('tr.lines-total');
            ib = parseFloat($('input.ib').val());
            i = 1;
            vtins = 0;
            vtout = 0;
            vl.each(function() {
              var $row;
              $row = $(this);
              $row.find('input').each(function() {
                var $input;
                $input = $(this);
                $input.attr('name', $input.attr('name').replace(/\d/, i));
                if ($input.hasClass('ord')) {
                  $input.val(i);
                }
                if ($input.hasClass('ins')) {
                  vtins += parseFloat($input.val());
                }
                if ($input.hasClass('out')) {
                  return vtout += parseFloat($input.val());
                }
              });
              $row.find('span.ord').text(i + '.');
              return i += 1;
            });
            vt.find('span.tot-in').text(vtins.toFixed(2));
            vt.find('span.tot-out').text(vtout.toFixed(2));
            $fb = ib + vtins - vtout;
            $('input.fb').val($fb);
            $('span.fb').text($fb.toFixed(2));
            if (r.ord > 25 && $('#scroll-container').length === 0) {
              Clns.desk.scrollHeader('table.scroll', 380);
            }
            if (r.ord < 26 && $('#scroll-container').length === 1) {
              Clns.desk.scrollHeader('table.scroll', 0);
            }
          },
          inputs: function(inpts) {
            inpts.each(function() {
              var $ind, $input;
              $input = $(this);
              $ind = $input.data();
              if ($input.hasClass('add-line')) {
                $input.on('keyup', function() {
                  if ($input.val() !== '') {
                    $('button[data-action=save]').button('option', 'disabled', true);
                  }
                });
                if ($input.hasClass('ins') || $input.hasClass('out')) {
                  $input.on('keypress', function(e) {
                    if (e.which === 13) {
                      return Clns.desk.cache_book.linesInsert();
                    }
                  });
                }
              }
            });
          },
          selects: function(slcts) {
            slcts.each(function() {
              var $sd, $select;
              $select = $(this);
              $sd = $select.data();
              if (Trst.desk.hdo.dialog === 'filter') {
                $select.on('change', function() {
                  var $params, $url;
                  $params = jQuery.param($('.param').serializeArray());
                  $url = "sys/clns/cache_book/filter?" + $params;
                  Trst.desk.init($url);
                });
              }
            });
          },
          buttons: function(btns) {
            btns.each(function() {
              var $bd, $button, $tr;
              $button = $(this);
              $bd = $button.data();
              if ($button.hasClass('link')) {
                if (Trst.desk.hdo.dialog === 'filter') {
                  $button.on('click', function() {
                    var $url;
                    if ($bd.oid === 'nil') {
                      $url = "sys/clns/cache_book/create?id_date=" + $bd.id_date;
                    } else {
                      $url = "sys/clns/cache_book/" + $bd.oid;
                    }
                    $.ajax({
                      type: 'POST',
                      url: '/sys/session/r_path/sys!clns!cache_book!filter',
                      async: false
                    });
                    Trst.lst.setItem('r_path', 'sys/clns/cache_book/filter');
                    Trst.desk.init($url);
                  });
                }
              } else if ($button.hasClass('fa-plus-circle')) {
                $button.off('click');
                $button.on('click', function() {
                  Clns.desk.cache_book.linesInsert();
                });
              } else if ($button.hasClass('fa-refresh')) {
                $button.off('click');
                $button.on('click', function() {
                  Clns.desk.cache_book.linesNewReset();
                });
              } else if ($button.hasClass('fa-minus-circle')) {
                $tr = $button.parentsUntil('tbody').last();
                $button.off('click');
                $button.on('click', function() {
                  var $nested;
                  if (Trst.desk.hdo.dialog === 'create') {
                    $tr.remove();
                    Clns.desk.cache_book.calculate();
                    Clns.desk.cache_book.linesNewReset();
                  }
                  if (Trst.desk.hdo.dialog === 'edit') {
                    if ($tr.find('input._id').length) {
                      $tr.addClass('hidden');
                      $nested = $tr.find('input').last().clone();
                      $nested.attr('name', $nested.attr('name').replace('out', '_destroy'));
                      $nested.val(1);
                      $tr.find('input').last().after($nested);
                      $tr.find('input').each(function() {
                        var $input;
                        $input = $(this);
                        return $input.attr('name', $input.attr('name').replace(/(\d)/, '_$1'));
                      });
                    } else {
                      $tr.remove();
                    }
                    Clns.desk.cache_book.calculate();
                    Clns.desk.cache_book.linesNewReset();
                  }
                });
              } else if (Trst.desk.hdo.dialog === 'show') {
                if ($bd.action === 'print') {
                  $button.on('click', function() {
                    Trst.msgShow(Trst.i18n.msg.report.start);
                    $.fileDownload("/sys/clns/cache_book/print?id=" + Trst.desk.hdo.oid, {
                      successCallback: function() {
                        return Trst.msgHide();
                      },
                      failCallback: function() {
                        Trst.msgHide();
                        return Trst.desk.downloadError(Trst.desk.hdo.model_name);
                      }
                    });
                  });
                }
              }
            });
          },
          init: function() {
            var _ref;
            Clns.desk.cache_book.buttons($('button, span.link, span.button'));
            Clns.desk.cache_book.selects($('select.param, input.select2, input.repair'));
            Clns.desk.cache_book.inputs($('input'));
            Clns.desk.cache_book.template = (_ref = $('tr.template')) != null ? _ref.remove() : void 0;
            Clns.desk.cache_book.linesNewReset();
            $log('Clns.desk.cache_book.init() OK...');
          }
        }
      }
    });
    return Clns.desk.cache_book;
  });

}).call(this);
