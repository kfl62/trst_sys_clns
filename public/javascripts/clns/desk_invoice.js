(function() {
  define(function() {
    $.extend(true, Clns, {
      desk: {
        invoice: {
          calculate: function() {
            var $rows, $total, tot_oi, tot_ti, tot_vi;
            $rows = $('tr.freight');
            $total = $('tr.total');
            tot_vi = 0;
            tot_ti = 0;
            tot_oi = 0;
            $rows.each(function() {
              var $tr, out, pu, qu, tva, val;
              $tr = $(this);
              pu = $tr.find('input[name*="pu"]').decFixed(4);
              qu = $tr.find('input[name*="qu"]').decFixed(2);
              tva = parseFloat($tr.find('input[name*="pu"]').data('tva'));
              val = (parseFloat(pu.val()) * parseFloat(qu.val())).round(2);
              tva = (val * tva).round(2);
              out = (val + tva).round(2);
              tot_vi += val;
              tot_ti += tva;
              tot_oi += out;
              $tr.find('span.val_invoice').text(val.toFixed(2));
              $tr.find('input.val').val(val.toFixed(2));
              $tr.find('span.tva_invoice').text(tva.toFixed(2));
              $tr.find('input.tva').val(tva.toFixed(2));
              $tr.find('span.out_invoice').text(out.toFixed(2));
              return $tr.find('input.tot').val(out.toFixed(2));
            });
            $total.find('span.sum_100').text(tot_vi.toFixed(2));
            $total.find('input[name*="sum_100"]').val(tot_vi.toFixed(2));
            $total.find('span.sum_tva').text(tot_ti.toFixed(2));
            $total.find('input[name*="sum_tva"]').val(tot_ti.toFixed(2));
            $total.find('span.sum_out').text(tot_oi.toFixed(2));
            $total.find('input[name*="sum_out"]').val(tot_oi.toFixed(2));
            if (tot_vi > 0) {
              $('button[data-action="save"]').button('option', 'disabled', false);
            } else {
              $('button[data-action="save"]').button('option', 'disabled', true);
            }
          },
          selectedGrns: function() {
            var $url;
            this.grn_ary = [];
            $('input:checked').each(function() {
              Clns.desk.invoice.grn_ary.push(this.id);
            });
            $url = Trst.desk.hdf.attr('action');
            $url += "/filter?y=" + ($('select.y').val());
            $url += "&m=" + ($('select.m').val());
            if (Clns.desk.invoice.grn_ary.length) {
              $url += "&supplr_id=" + ($('#supplr_id').val());
              $url += "&grn_ary=" + Clns.desk.invoice.grn_ary;
              Clns.desk.tmp.clear();
              Clns.desk.tmp.set('supplr', $('#supplr_id').select2('data'));
              Clns.desk.tmp.set('supplr_d', $('#supplr_d_id').select2('data'));
            } else {
              $url += "&grn_ary=true";
              Clns.desk.tmp.clear();
              delete this.grn_ary;
            }
            Trst.desk.init($url);
          },
          selectedDeliveryNotes: function() {
            var $params, $url;
            this.dln_ary = [];
            $params = jQuery.param($('.param').serializeArray());
            $('input:checked').each(function() {
              Clns.desk.invoice.dln_ary.push(this.id);
            });
            $url = Trst.desk.hdf.attr('action');
            $url += "/filter?" + $params;
            if (Clns.desk.invoice.dln_ary.length) {
              $url += "&client_id=" + ($('#client_id').select2('val'));
              $url += "&dln_ary=" + Clns.desk.invoice.dln_ary;
              Clns.desk.tmp.clear();
              Clns.desk.tmp.set('client', $('#client_id').select2('data'));
              Clns.desk.tmp.set('client_d', $('#client_d_id').select2('data'));
            } else {
              $url += "&dln_ary=true";
              Clns.desk.tmp.clear();
              delete this.dln_ary;
            }
            Trst.desk.init($url);
          },
          validate: {
            filter: function() {
              var $params, $url;
              $params = jQuery.param($('.param').serializeArray());
              if (Trst.desk.hdo.title_data != null) {
                if ($('#supplr_id').val() !== '' && $('#supplr_d_id').val() !== '' && $('#supplr_d_id').val() !== 'new') {
                  $url = Trst.desk.hdf.attr('action');
                  $url += "/filter?grn_ary=true&" + $params;
                  Clns.desk.tmp.clear('supplr').set('supplr', $('#supplr_id').select2('data'));
                  Clns.desk.tmp.clear('supplr_d').set('supplr_d', $('#supplr_d_id').select2('data'));
                  Trst.desk.init($url);
                } else {
                  $('.grns').hide();
                }
              } else {
                if ($('#client_id').val() !== '' && $('#client_d_id').val() !== '' && $('#client_d_id').val() !== 'new') {
                  $url = Trst.desk.hdf.attr('action');
                  $url += "/filter?dln_ary=true&" + $params;
                  $url += "&client_id=" + ($('#client_id').select2('val'));
                  Clns.desk.tmp.clear('client').set('client', $('#client_id').select2('data'));
                  Clns.desk.tmp.clear('client_d').set('client_d', $('#client_d_id').select2('data'));
                  Trst.desk.init($url);
                } else {
                  $('.dlns').hide();
                }
              }
            }
          },
          inputs: function(inpts) {
            inpts.each(function() {
              var $id, $input, _ref, _ref1;
              $input = $(this);
              $id = $input.attr('id');
              if ($input.hasClass('dln_ary')) {
                $input.on('change', function() {
                  Clns.desk.invoice.selectedDeliveryNotes();
                });
              }
              if ($input.hasClass('grn_ary')) {
                $input.on('change', function() {
                  Clns.desk.invoice.selectedGrns();
                });
              }
              if (((_ref = $input.attr('name')) != null ? _ref.match(/([^\[^\]]+)/g).pop() : void 0) === 'doc_name') {
                if (Trst.desk.hdo.title_data != null) {
                  $input.on('change', function() {
                    inpts.filter('[name*="\[name\]"]:not([type="hidden"])').val($(this).val());
                    return $('button[data-action="save"]').button('option', 'disabled', false);
                  });
                  return;
                } else {
                  $input.on('change', function() {
                    if (inpts.filter('[name*="pu\]"]:not([type="hidden"])').length) {
                      inpts.filter('[name*="pu\]"]:not([type="hidden"])').first().focus();
                    } else {
                      $('button[data-action="save"]').button('option', 'disabled', false);
                    }
                  });
                }
              }
              if (((_ref1 = $input.attr('name')) != null ? _ref1.match(/([^\[^\]]+)/g).pop() : void 0) === 'pu') {
                return $input.on('change', function() {
                  Clns.desk.invoice.calculate();
                });
              }
            });
          },
          selects: function(slcts) {
            slcts.each(function() {
              var $dlg, $dlgph, $dlgsd, $id, $ph, $sd, $select;
              $select = $(this);
              $sd = $select.data();
              $id = $select.attr('id');
              if ($select.hasClass('select2')) {
                if ($id === 'client_id') {
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
                          w: $id.split('_')[0],
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
                  if (Clns.desk.tmp.client) {
                    $select.select2('data', Clns.desk.tmp.client);
                    $dlg = $select.next();
                    $dlgsd = $dlg.data();
                    $dlgph = Trst.i18n.select[Trst.desk.hdo.js_ext][$dlgsd.ph];
                    $dlg.select2({
                      placeholder: $dlgph,
                      minimumInputLength: $dlgsd.minlength,
                      allowClear: true,
                      ajax: {
                        url: "/utils/search/" + $sd.search,
                        dataType: 'json',
                        data: function(term) {
                          return {
                            id: $select.select2('val')
                          };
                        },
                        results: function(data) {
                          return {
                            results: data
                          };
                        }
                      }
                    });
                    $dlg.select2('data', Clns.desk.tmp.client_d);
                    $dlg.unbind();
                    $dlg.on('change', function() {
                      var $dlgadd;
                      if ($dlg.select2('data')) {
                        if ($dlg.select2('data').id === 'new') {
                          $dlgadd = $dlg.next();
                          $dlgadd.data('url', '/sys/clns/partner_firm/person');
                          $dlgadd.data('r_id', $select.select2('val'));
                          $dlgadd.data('r_mdl', 'firm');
                          $dlgadd.show();
                        } else {
                          $dlg.next().hide();
                        }
                      } else {
                        $dlg.next().hide();
                      }
                      return Clns.desk.invoice.validate.filter();
                    });
                  }
                  $select.unbind();
                  $select.on('change', function() {
                    if ($select.select2('data')) {
                      $select.next().select2('data', null);
                      $select.next().select2('destroy');
                      $dlg = $select.next();
                      $dlgsd = $dlg.data();
                      $dlgph = Trst.i18n.select[Trst.desk.hdo.js_ext][$dlgsd.ph];
                      $dlg.select2({
                        placeholder: $dlgph,
                        minimumInputLength: $dlgsd.minlength,
                        allowClear: true,
                        ajax: {
                          url: "/utils/search/" + $sd.search,
                          dataType: 'json',
                          data: function(term) {
                            return {
                              id: $select.select2('val')
                            };
                          },
                          results: function(data) {
                            return {
                              results: data
                            };
                          }
                        }
                      });
                      $dlg.unbind();
                      $dlg.on('change', function() {
                        var $dlgadd;
                        if ($dlg.select2('data')) {
                          if ($dlg.select2('data').id === 'new') {
                            $dlgadd = $dlg.next();
                            $dlgadd.data('url', '/sys/clns/partner_firm/person');
                            $dlgadd.data('r_id', $select.select2('val'));
                            $dlgadd.data('r_mdl', 'firm');
                            $dlgadd.show();
                          } else {
                            $dlg.next().hide();
                          }
                        } else {
                          $dlg.next().hide();
                        }
                        return Clns.desk.invoice.validate.filter();
                      });
                    } else {
                      $select.next().select2('data', null);
                      $select.next().select2('destroy');
                      $select.next().next().hide();
                    }
                    return Clns.desk.invoice.validate.filter();
                  });
                }
                if ($id === 'supplr_id') {
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
                          w: $id.split('_')[0],
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
                  if (Clns.desk.tmp.supplr) {
                    $select.select2('data', Clns.desk.tmp.supplr);
                    $dlg = $select.next();
                    $dlgsd = $dlg.data();
                    $dlgph = Trst.i18n.select[Trst.desk.hdo.js_ext][$dlgsd.ph];
                    $dlg.select2({
                      placeholder: $dlgph,
                      minimumInputLength: $dlgsd.minlength,
                      allowClear: true,
                      ajax: {
                        url: "/utils/search/" + $sd.search,
                        dataType: 'json',
                        data: function(term) {
                          return {
                            id: $select.select2('val')
                          };
                        },
                        results: function(data) {
                          return {
                            results: data
                          };
                        }
                      }
                    });
                    $dlg.select2('data', Clns.desk.tmp.supplr_d);
                    $dlg.unbind();
                    $dlg.on('change', function() {
                      var $dlgadd;
                      if ($dlg.select2('data')) {
                        if ($dlg.select2('data').id === 'new') {
                          $dlgadd = $dlg.next();
                          $dlgadd.data('url', '/sys/clns/partner_firm/person');
                          $dlgadd.data('r_id', $select.select2('val'));
                          $dlgadd.data('r_mdl', 'firm');
                          $dlgadd.show();
                        } else {
                          $dlg.next().hide();
                        }
                      } else {
                        $dlg.next().hide();
                      }
                      return Clns.desk.invoice.validate.filter();
                    });
                  }
                  $select.unbind();
                  $select.on('change', function() {
                    if ($select.select2('data')) {
                      $select.next().select2('data', null);
                      $select.next().select2('destroy');
                      $dlg = $select.next();
                      $dlgsd = $dlg.data();
                      $dlgph = Trst.i18n.select[Trst.desk.hdo.js_ext][$dlgsd.ph];
                      $dlg.select2({
                        placeholder: $dlgph,
                        minimumInputLength: $dlgsd.minlength,
                        allowClear: true,
                        ajax: {
                          url: "/utils/search/" + $sd.search,
                          dataType: 'json',
                          data: function(term) {
                            return {
                              id: $select.select2('val')
                            };
                          },
                          results: function(data) {
                            return {
                              results: data
                            };
                          }
                        }
                      });
                      $dlg.unbind();
                      $dlg.on('change', function() {
                        var $dlgadd;
                        if ($dlg.select2('data')) {
                          if ($dlg.select2('data').id === 'new') {
                            $dlgadd = $dlg.next();
                            $dlgadd.data('url', '/sys/clns/partner_firm/person');
                            $dlgadd.data('r_id', $select.select2('val'));
                            $dlgadd.data('r_mdl', 'firm');
                            $dlgadd.show();
                          } else {
                            $dlg.next().hide();
                          }
                        } else {
                          $dlg.next().hide();
                        }
                        return Clns.desk.invoice.validate.filter();
                      });
                    } else {
                      $select.next().select2('data', null);
                      $select.next().select2('destroy');
                      $select.next().next().hide();
                    }
                    return Clns.desk.invoice.validate.filter();
                  });
                }
              } else if ($select.hasClass('repair')) {
                $ph = Trst.i18n.select[Trst.desk.hdo.js_ext][$sd.ph];
                $select.select2({
                  placeholder: $ph,
                  allowClear: true,
                  quietMillis: 1000,
                  ajax: {
                    url: "/utils/search/" + $sd.search,
                    dataType: 'json',
                    data: function(term) {
                      return {
                        day: $('#date_send').val(),
                        q: term
                      };
                    },
                    results: function(data) {
                      return {
                        results: data
                      };
                    }
                  },
                  formatResult: function(d) {
                    var $markup;
                    $markup = "<div title='" + d.text.title + "'>";
                    $markup += "<span class='repair'>Doc: </span>";
                    $markup += "<span class='truncate-70'>" + d.text.doc_name + "</span>";
                    $markup += "<span class='repair'> - Firma: </span>";
                    $markup += "<span class='truncate-200'>" + d.text.client + "</span>";
                    $markup += "</div>";
                    return $markup;
                  },
                  formatSelection: function(d) {
                    return d.text.name;
                  },
                  formatSearching: function() {
                    return Trst.i18n.msg.searching;
                  },
                  formatNoMatches: function(t) {
                    return Trst.i18n.msg.no_matches;
                  }
                });
                $select.off();
                $select.on('change', function() {
                  var $url;
                  if ($select.select2('val') !== '') {
                    $url = Trst.desk.hdf.attr('action');
                    $url += "/" + ($select.select2('val'));
                    Trst.desk.closeDesk(false);
                    Trst.desk.init($url);
                  }
                });
              } else {
                $log('Select not handled!');
              }
            });
          },
          buttons: function(btns) {
            btns.each(function() {
              var $bd, $button, $id, $url, _ref, _ref1;
              $button = $(this);
              $bd = $button.data();
              $id = $button.attr('id');
              if (Trst.desk.hdo.dialog === 'filter') {
                if ($id === 'client_d' || $id === 'supplr_d') {
                  $button.hide();
                }
                if ($bd.action === 'create') {
                  if ($('input:checked').length === 0) {
                    if ($bd.action === 'create') {
                      $button.button('option', 'disabled', true);
                    }
                  } else {
                    $bd = $button.data();
                    $url = Trst.desk.hdf.attr('action');
                    $url += "/create?y=" + ($('select.y').val());
                    $url += "&m=" + ($('select.m').val());
                    if ((_ref = Clns.desk.invoice.dln_ary) != null ? _ref.length : void 0) {
                      $url += "&client_id=" + Clns.desk.tmp.client.id;
                      $url += "&client_d_id=" + Clns.desk.tmp.client_d.id;
                      $url += "&dln_ary=" + Clns.desk.invoice.dln_ary;
                    }
                    if ((_ref1 = Clns.desk.invoice.grn_ary) != null ? _ref1.length : void 0) {
                      $url += "&supplr_id=" + Clns.desk.tmp.supplr.id;
                      $url += "&supplr_d_id=" + Clns.desk.tmp.supplr_d.id;
                      $url += "&grn_ary=" + Clns.desk.invoice.grn_ary;
                    }
                    $bd.url = $url;
                    $button.button('option', 'disabled', false);
                    $button.on('click', function() {
                      return Clns.desk.tmp.clear();
                    });
                  }
                }
                if ($bd.action === 'cancel') {
                  return $button.on('click', function() {
                    return Clns.desk.tmp.clear();
                  });
                }
              } else if (Trst.desk.hdo.dialog === 'show') {
                if ($bd.action === 'print') {
                  $button.on('click', function() {
                    Trst.msgShow(Trst.i18n.msg.report.start);
                    $.fileDownload("/sys/clns/invoice/print?id=" + Trst.desk.hdo.oid, {
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
              } else {

                /*
                Buttons default handler Trst.desk.buttons
                 */
              }
            });
          },
          init: function() {
            var min, now;
            if ($('#date_show').length) {
              now = new Date();
              min = Trst.lst.admin === 'true' ? new Date(now.getFullYear(), now.getMonth() - 1, 1) : min = new Date(now.getFullYear(), now.getMonth(), 1);
              $('#date_show').datepicker('option', 'maxDate', '+0');
              $('#date_show').datepicker('option', 'minDate', min);
            }
            $('.focus').focus();
            Clns.desk.invoice.buttons($('button'));
            Clns.desk.invoice.selects($('select.clns,input.select2,input.repair'));
            Clns.desk.invoice.inputs($('input'));
            return $log('Clns.desk.invoice.init() OK...');
          }
        }
      }
    });
    return Clns.desk.invoice;
  });

}).call(this);
