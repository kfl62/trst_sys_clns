define () ->
  $.extend true,Clns,
    desk:
      tmp:
        set: (key,value)->
          if @[key] or @[key] is 0 then @[key] else @[key] = value
        clear: (what...)->
          $.each @, (k)=>
            if what.length
              delete @[k] if k in [what...]
            else
              delete @[k] unless k in ['set','clear']
      init: () ->
        $log 'Clns.desk.init() Ok...'
  Clns.desk
