# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'

module VideosPraise
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'presentation/views'
    plugin :assets,
            css: ['grayscale.css','style.css', 'nprogress.css'],
            js: ['jquery.js','jquery.easing.js','grayscale.js','updateView.js','nprogress.js','camera.js'],
            path: 'presentation/assets'

    opts[:root] = 'presentation/assets'
    plugin :public, root: 'static'
    plugin :flash

    use Rack::Session::Cookie, secret: config.SESSION_SECRET

    route do |routing|
      routing.assets
      routing.public

      routing.root do
        # # http://localhost:3000/api/v0.1/getAll
        view 'root'
      end
      routing.on 'all' do
        routing.get do
          begin
            video_results_json = ApiGateway.new.all_recipe_video
            all_video = VideosPraise::AllVideosRepresenter.new(OpenStruct.new)
                                                          .from_json video_results_json
            videos = Views::AllVideos.new(all_video)

            view 'all', locals: {
              videos: videos
            }
          rescue
            flash[:error] = 'Search failed!'

            view 'root'

          end
        end
      end
      routing.on 'uploadFile' do
        routing.post do
          begin
            #puts routing.params['fileToUpload'][:tempfile]
            tempfile = routing.params['fileToUpload'][:tempfile]
            file_results = ApiGateway.new.identify_img(tempfile)
            analyzed_result = VideosPraise::GoogleVisionResultsRepresenter.new(OpenStruct.new)
                                                          .from_json file_results
            query_name = analyzed_result.label.to_s+" recipe"
            video_results_json = ApiGateway.new.create_recipe_video(query_name)

            # EDAMAM
            ingredients = analyzed_result.label.to_s
            recipe_results_json = ApiGateway.new.create_edamam_recipe(ingredients)

            final_results_json = {
              video_json: video_results_json,
              recipe_json: recipe_results_json
            }
            final_results_json.to_json

          rescue
            flash[:error] = 'Search failed!'

            puts $!
            puts $@

            view 'root'

          end
          #routing.redirect '/'
        end
      end
      routing.on 'camera_photo_upload' do
        routing.post do
          begin
            puts routing.params['snapshot'].class
            photo = routing.params['snapshot']
            file_results = ApiGateway.new.photo_from_camera(photo)
            analyzed_result = VideosPraise::GoogleVisionResultsRepresenter.new(OpenStruct.new)
                                                          .from_json file_results
            query_name = analyzed_result.label.to_s+" food recipe"

            video_results_json = ApiGateway.new.create_recipe_video(query_name)

           # EDAMAM
           ingredients = analyzed_result.label.to_s
           recipe_results_json = ApiGateway.new.create_edamam_recipe(ingredients)

           final_results_json = {
             video_json: video_results_json,
             recipe_json: recipe_results_json
           }
           final_results_json.to_json

           final_results_json = {
             video_json: video_results_json,
             recipe_json: recipe_results_json
           }
           final_results_json.to_json

          rescue
            flash[:error] = 'Search failed!'
            view 'root'

          end
        end
      end
      routing.on 'search' do
        routing.post do
          begin
            # Youtube
            search_name = routing.params['search_name'].to_s+" recipe"
            video_results_json = ApiGateway.new.create_recipe_video(search_name)

            # EDAMAM
            ingredients = routing.params['search_name'].to_s
            recipe_results_json = ApiGateway.new.create_edamam_recipe(ingredients)

            final_results_json = {
              video_json: video_results_json,
              recipe_json: recipe_results_json
            }
            final_results_json.to_json

          rescue
            flash[:error] = 'Search failed!'

            view 'root'

          end
        end
      end
    end
  end
end
