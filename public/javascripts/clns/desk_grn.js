(function() {
  define(function() {
    $.extend(true, Clns, {
      desk: {
        grn: {
          selectedDeliveryNotes: function() {
            var $url;
            this.dln_ary = [];
            $('input:checked').each(function() {
              Clns.desk.grn.dln_ary.push(this.id);
            });
            $url = Trst.desk.hdf.attr('action');
            $url += "&p03=" + ($('select.p03').val());
            if (Clns.desk.grn.dln_ary.length) {
              $url += "&dln_ary=" + Clns.desk.grn.dln_ary;
            }
            Trst.desk.init($url);
          },
          grnCalculate: function() {
            var i, vf, vt, vtout, vttva, vtval;
            vf = $('tr.grn-freight');
            vt = $('tr.grn-freight-total');
            i = 0;
            vtval = 0;
            vttva = 0;
            vtout = 0;
            vf.each(function() {
              var $row;
              $row = $(this);
              $row.find('input').each(function() {
                var $input;
                $input = $(this);
                $input.attr('name', $input.attr('name').replace(/\d/, i));
                if ($input.hasClass('val')) {
                  vtval += parseFloat($input.val());
                }
                if ($input.hasClass('tva')) {
                  vttva += parseFloat($input.val());
                }
                if ($input.hasClass('out')) {
                  return vtout += parseFloat($input.val());
                }
              });
              return i += 1;
            });
            vt.find('span.val').text(vtval.toFixed(2));
            vt.find('input.val').val(vtval.round(2));
            vt.find('span.tva').text(vttva.toFixed(2));
            vt.find('input.tva').val(vttva.round(2));
            vt.find('span.out').text(vtout.toFixed(2));
            vt.find('input.out').val(vtout.round(2));
          },
          freightInsert: function() {
            var i, id_date, r, v;
            r = Clns.desk.grn.freightCalculate().result;
            v = Clns.desk.grn.template.clone().removeClass('template');
            i = $('tr.grn-freight').length;
            id_date = $('input#date_send').val();
            v.find('span.name').text(r.name);
            v.find('input.freight_id').val(r.freight_id);
            v.find('input.id_stats').val(r.id_stats);
            v.find('input.id_date').val($('input#date_send').val());
            v.find('input.id_intern').val($('input#id_intern').val());
            v.find('input.um').val(r.um);
            v.find('span.um').text(r.um);
            v.find('input.pu').val(r.pu);
            v.find('span.pu').text(r.pu.toFixed(4));
            v.find('input.qu').val(r.qu);
            v.find('span.qu').text(r.qu.toFixed(2));
            v.find('input.val').val(r.sval);
            v.find('span.val').text(r.sval.toFixed(2));
            v.find('input.tva').val(r.stva);
            v.find('span.tva').text(r.stva.toFixed(2));
            v.find('input.out').val(r.sout);
            v.find('span.out').text(r.sout.toFixed(2));
            $('tr.grn-freight-header, tr.grn-freight-total').removeClass('hidden');
            $('tr.grn-freight-total').before(v);
            Clns.desk.grn.buttons($('span.button'));
            return Clns.desk.grn.grnCalculate();
          },
          freightCalculate: function() {
            var $out, $tva, $val, fid, idd, ids, name, pu, qu, tva, um, v;
            v = $('.add-freight');
            name = v.filter('.name').data('name');
            ids = v.filter('.name').data('id_stats');
            idd = v.filter('.name').data('id_date');
            fid = v.filter('.name').data('freight_id');
            um = v.filter('.um').val();
            tva = parseFloat(v.filter('.name').data('tva'));
            pu = parseFloat(v.filter('.pu').decFixed(4).val());
            qu = parseFloat(v.filter('.qu').decFixed(2).val());
            $val = (pu * qu).round(2);
            $tva = ($val * tva).round(2);
            $out = ($val + $tva).round(2);
            v.filter('.val').text($val.toFixed(2));
            v.filter('.tva').text($tva.toFixed(2));
            v.filter('.out').text($out.toFixed(2));
            return {
              result: {
                freight_id: fid,
                name: name,
                id_stats: ids,
                um: um,
                tva: tva,
                pu: pu,
                qu: qu,
                sval: $val,
                stva: $tva,
                sout: $out
              }
            };
          },
          validate: {
            filter: function() {
              var $url;
              if ($('#supplr_id').val() !== '' && $('#suppr_d_id').val() !== 'new') {
                $url = Trst.desk.hdf.attr('action');
                $url += "?supplr_id=" + ($('#supplr_id').val());
                if ($('#supplr_d_id').val() !== '' && $('#supplr_d_id').val() !== 'new') {
                  $url += "&supplr_d_id=" + ($('#supplr_d_id').val());
                }
                $('button.grn').data('url', $url);
                $('button.grn').button('option', 'disabled', false);
              } else {
                $('button.grn').button('option', 'disabled', true);
              }
            },
            create: function() {
              if ($('select.doc_type').length) {
                if ($('select.doc_type').val() !== 'null' && $('input[name*="doc_name"]').val() !== '' && $('input[name*="doc_plat"]').val() !== '') {
                  if ($('tr.grn-freight').length === 0) {
                    $('button[data-action="save"]').button('option', 'disabled', true);
                  } else {
                    $('button[data-action="save"]').button('option', 'disabled', false);
                  }
                  $('span.icon-plus-sign').show();
                  return true;
                }
              }
            }
          },
          inputs: function(inpts) {
            inpts.each(function() {
              var $id, $input;
              $input = $(this);
              $id = $input.attr('id');
              if ($input.hasClass('dln_ary')) {
                $input.on('change', function() {
                  Clns.desk.grn.selectedDeliveryNotes();
                });
              }
              if ($input.attr('id') === 'date_show') {
                $input.on('change', function() {
                  if (Trst.desk.hdo.dialog === 'create') {
                    $('input[name*="doc_date"]').val($('#date_send').val());
                    $('input[name*="id_date"]').each(function() {
                      if ($(this).val() !== '') {
                        $(this).val($('#date_send').val());
                      }
                    });
                    $('select.doc_type').focus();
                  }
                  if (Trst.desk.hdo.dialog === 'repair') {
                    return Clns.desk.grn.selects($('input.repair'));
                  }
                });
                return;
              }
            });
          },
          selects: function(slcts) {
            slcts.each(function() {
              var $id, $id_stats, $ph, $sd, $select;
              $select = $(this);
              $sd = $select.data();
              $id = $select.attr('id');
              if ($select.hasClass('clns doc_type')) {
                $('tr.inv').hide();
                $select.on('change', function() {
                  $('input[name*="doc_date"]').val($('#date_send').val());
                  if ($select.val() === 'INV') {
                    $('tr.dn').hide();
                    $('tr.inv').show();
                    $('input[name*="deadl"]').val($('#date_send').val());
                    $('input[name*="\[pyms\]\[id_date\]"]').val($('#date_send').val());
                  } else {
                    $('tr.dn').show();
                    $('tr.inv').hide();
                  }
                  return $select.next().focus();
                });
              } else if ($select.hasClass('clns freight')) {
                $id_stats = $('select.clns.freight.oid option:selected').data('id_stats') || '00000000';
                $select.on('change', function() {
                  var $url, c0, c1, c2;
                  if (Clns.desk.grn.validate.create()) {
                    if ($select.hasClass('c0')) {
                      c0 = $select.val();
                      c1 = "00";
                      c2 = "00";
                      $('select.clns.freight.c1').val(c1);
                      $('select.clns.freight.c2').val(c2);
                    }
                    if ($select.hasClass('c1')) {
                      c0 = $('select.clns.freight.c0').val();
                      c1 = $select.val();
                      c2 = "00";
                      $('select.clns.freight.c2').val(c2);
                    }
                    if ($select.hasClass('c2')) {
                      c0 = $('select.clns.freight.c0').val();
                      c1 = $('select.clns.freight.c1').val();
                      c2 = $select.val();
                    }
                    if ($select.hasClass('oid')) {
                      $id_stats = $('select.clns.freight.oid option:selected').data('id_stats') || '00000000';
                    } else {
                      $id_stats = c0 + c1 + c2 + "00";
                    }
                    $url = "/sys/partial/clns/shared/_doc_add_freight?id_stats=" + $id_stats;
                    return $('td.add-freight-container').load($url, function() {
                      Clns.desk.grn.selects($('select.clns.freight'));
                      if ($id_stats.slice(-2) !== '00') {
                        $('span.button.flri').removeClass('hidden');
                        Clns.desk.grn.buttons($('span.button'));
                        return $('.focus').focus().select();
                      }
                    });
                  } else {
                    alert(Trst.i18n.msg.grn_not_complete);
                    $('button[data-action="save"]').button('option', 'disabled', true);
                    $url = "/sys/partial/clns/shared/_doc_add_freight?id_stats=00000000";
                    return $('td.add-freight-container').load($url, function() {
                      return Clns.desk.grn.selects($('select.clns.freight'));
                    });
                  }
                });
                return;
              } else if ($select.hasClass('select2')) {
                if ($id === 'supplr_id' || $id === 'transp_id') {
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
                  $select.unbind();
                  $select.on('change', function() {
                    var $dlg, $dlgph, $dlgsd;
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
                            $dlgadd.data('r_path', '/sys/clns/grn/filter');
                            $dlgadd.data('r_id', $select.select2('val'));
                            $dlgadd.data('r_mdl', 'firm');
                            $dlgadd.show();
                          } else {
                            $dlg.next().hide();
                          }
                        } else {
                          $dlg.next().hide();
                        }
                        return Clns.desk.grn.validate.filter();
                      });
                    } else {
                      $select.next().select2('data', null);
                      $select.next().select2('destroy');
                      $select.next().next().hide();
                    }
                    return Clns.desk.grn.validate.filter();
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
                        uid: $sd.uid,
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
                    $markup += "<span class='truncate-200'>" + d.text.supplier + "</span>";
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
                    return Trst.desk.init($url);
                  }
                });
              } else {
                $log('Select not handled!');
              }
            });
          },
          buttons: function(btns) {
            return btns.each(function() {
              var $bd, $button, $id, $url, _ref;
              $button = $(this);
              $bd = $button.data();
              $id = $button.attr('id');
              if (Trst.desk.hdo.dialog === 'filter') {
                if ($id === 'supplr_d' || $id === 'transp_d') {
                  $button.hide();
                }
                if ($bd.action === 'create') {
                  if ($('input:checked').length === 0) {
                    if ($button.hasClass('grn')) {
                      return $button.button('option', 'disabled', true);
                    }
                  } else {
                    $bd = $button.data();
                    $url = '/sys/clns/grn/create?id_intern=true';
                    $url += "&unit_id=" + Trst.desk.hdo.unit_id;
                    $url += "&dln_ary=" + Clns.desk.grn.dln_ary;
                    $bd.url = $url;
                    return $button.button('option', 'disabled', false);
                  }
                }
              } else if (Trst.desk.hdo.dialog === 'create') {
                if (!Clns.desk.grn.validate.create()) {
                  if ($bd.action === 'save') {
                    if (!(((_ref = Clns.desk.grn.dln_ary) != null ? _ref.length : void 0) > 0)) {
                      $button.button('option', 'disabled', true);
                    }
                  }
                }
                if ($button.hasClass('icon-refresh')) {
                  $button.off('click');
                  $button.on('click', function() {
                    return Clns.desk.grn.freightCalculate();
                  });
                }
                if ($button.hasClass('icon-plus-sign')) {
                  $button.off('click');
                  $button.on('click', function() {
                    Clns.desk.grn.freightInsert();
                    $url = "/sys/partial/clns/shared/_doc_add_freight?id_stats=00000000";
                    return $('td.add-freight-container').load($url, function() {
                      return Clns.desk.grn.selects($('select.clns.freight'));
                    });
                  });
                }
                if ($button.hasClass('icon-minus-sign')) {
                  $button.off('click');
                  return $button.on('click', function() {
                    $button.parentsUntil('tbody').last().remove();
                    Clns.desk.grn.grnCalculate();
                    if ($('tr.grn-freight').length === 0) {
                      $('tr.grn-freight-header, tr.grn-freight-total').addClass('hidden');
                      return $('button[data-action="save"]').button('option', 'disabled', true);
                    }
                  });
                }
              } else if (Trst.desk.hdo.dialog === 'show') {
                if ($bd.action === 'print') {
                  $button.on('click', function() {
                    Trst.msgShow(Trst.i18n.msg.report.start);
                    $.fileDownload("/sys/clns/grn/print?id=" + Trst.desk.hdo.oid, {
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
            var min, now, _ref;
            if ($('#date_show').length) {
              now = new Date();
              min = Trst.lst.admin === 'true' ? new Date(now.getFullYear(), now.getMonth() - 1, 1) : min = new Date(now.getFullYear(), now.getMonth(), 1);
              $('#date_show').datepicker('option', 'maxDate', '+0');
              $('#date_show').datepicker('option', 'minDate', min);
            }
            Clns.desk.grn.buttons($('button'));
            Clns.desk.grn.selects($('select.clns,input.select2,input.repair'));
            Clns.desk.grn.inputs($('input'));
            Clns.desk.grn.template = (_ref = $('tr.template')) != null ? _ref.remove() : void 0;
            return $log('Clns.desk.grn.init() OK...');
          }
        }
      }
    });
    return Clns.desk.grn;
  });

}).call(this);
