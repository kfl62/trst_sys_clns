(function() {
  define(['/javascripts/libs/select2.min.js', '/javascripts/libs/jquery.ui.datepicker-ro.js', 'clns/desk'], function() {
    $.extend(Clns, {
      unit_info: {
        node: function() {
          return $("<hr> <li class='em st'>" + Trst.i18n.unit_info_lbl + "</li> <li id='unit_info'>" + Trst.lst.unit_info_txt + "</>");
        },
        update: function(unit_name) {
          if (unit_name == null) {
            unit_name = null;
          }
          if (unit_name === null) {
            Trst.lst.unit_info_txt = Trst.i18n.unit_info_all;
          } else {
            Trst.lst.unit_info_txt = unit_name;
          }
          if ($('body').data('admin')) {
            if ($('#unit_info').length) {
              $('#unit_info').text(Trst.lst.unit_info_txt);
            } else {
              $('#xhr_tasks ul li').last().append(Clns.unit_info.node());
            }
          }
          return Clns.unit_info_text;
        }
      },
      init: function() {
        Trst.lst.setItem('admin', $('body').data('admin'));
        $('#menu.system ul li a').filter('[id^="page"]').unbind();
        $('#menu.system ul li a').filter('[id^="page"]').click(function() {
          var $page_id;
          $('#xhr_content').load("/sys/" + ($(this).attr('id')));
          $page_id = $(this).attr('id').split('_')[1];
          $('#xhr_tasks').load("/sys/tasks/" + $page_id, function() {
            Trst.lst.setItem('page_id', $page_id);
            return Clns.unit_info.update(Trst.lst.unit_info_txt);
          });
          return false;
        });
        if (Trst.lst.page_id) {
          $('#xhr_tasks').load("/sys/tasks/" + Trst.lst.page_id, function() {
            return Clns.unit_info.update(Trst.lst.unit_info_txt);
          });
        }
        return $log("Clns init() OK...");
      }
    });
    return Clns;
  });

}).call(this);
