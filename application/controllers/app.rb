# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'

module VideosPraise
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'presentation/views'
    plugin :assets,
           css: ['grayscale.css', 'style.css', 'nprogress.css'],
           js: ['jquery.js', 'jquery.easing.js', 'grayscale.js', 'updateView.js', 'nprogress.js', 'camera.js'],
           path: 'presentation/assets'

    opts[:root] = 'presentation/assets'
    plugin :public, root: 'static'
    plugin :flash
    plugin :multi_route

    require_relative 'search_recipe'
    require_relative 'take_snapshot'
    require_relative 'upload_photo'

    use Rack::Session::Cookie, secret: config.SESSION_SECRET

    route do |routing|
      routing.assets
      routing.public
      routing.root do
        view 'root'
      end

      routing.multi_route
    end
  end
end
