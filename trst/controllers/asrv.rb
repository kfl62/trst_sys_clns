# encoding: utf-8
module Trst
  # Use this instead of public if you need
  class Demo  < Sinatra::Base
    register Sinatra::Flash
    register Trst::Helpers
    set :views, File.join(Trst.views, 'public')

    if Trst.env == 'development'
      use Assets::Stylesheets
      use Assets::Javascripts
    end
    # ....
    # some routes
  end
end
