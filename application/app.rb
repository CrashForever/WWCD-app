# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'

module VideosPraise
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'presentation/views'
    plugin :assets,
            css: ['grayscale.css','style.css'],
            # css: '',
            js: ['jquery.js','jquery.easing.js','grayscale.js'],
            # js: '',
            # js: '',
            # js: 'bootstrap.bundle.min.js',
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
              # video_id: all_video.all_videos
            }
          rescue
            flash[:error] = 'Search failed!'
            view 'root'

            # ownername, reponame = gh_url.split('/')[-2..-1]
            # ApiGateway.new.create_repo(ownername, reponame)
          end
          #routing.redirect '/'
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
            results_video = VideosPraise::VideosRepresenter.new(OpenStruct.new)
                                                           .from_json video_results_json
            #puts results_video
            results = Views::ResultsVideo.new(results_video)

            # flash[:notice] = 'Search success!'
            view 'search_results', locals: {
              results: results
            }
            # view 'upload_results'
          rescue
            flash[:error] = 'Search failed!'
            view 'root'

            # ownername, reponame = gh_url.split('/')[-2..-1]
            # ApiGateway.new.create_repo(ownername, reponame)
          end
          #routing.redirect '/'
        end
      end
      routing.on 'camera_photo_upload' do
        routing.post do
          begin
            puts routing.params['snapshot'].class
            photo = routing.params['snapshot']
            # tempfile = routing.params['fileToUpload'][:tempfile]
            file_results = ApiGateway.new.photo_from_camera(photo)
            analyzed_result = VideosPraise::GoogleVisionResultsRepresenter.new(OpenStruct.new)
                                                          .from_json file_results
            query_name = analyzed_result.label.to_s+" food recipe"

            video_results_json = ApiGateway.new.create_recipe_video(query_name)
            results_video = VideosPraise::VideosRepresenter.new(OpenStruct.new)
                                                           .from_json video_results_json
            #puts results_video
            results = Views::ResultsVideo.new(results_video)
            results.results_video.each.with_index do |video, index|
              puts index
              puts video
            end
            #
            # # flash[:notice] = 'Search success!'
            view 'search_results', locals: {
              results: results
            }
            #view 'upload_results'
          rescue
            flash[:error] = 'Search failed!'
            view 'root'

            # ownername, reponame = gh_url.split('/')[-2..-1]
            # ApiGateway.new.create_repo(ownername, reponame)
          end
          #routing.redirect '/'
        end
      end
      routing.on 'search' do
        routing.post do
          begin
            search_name = routing.params['search_name'].to_s+" recipe"
            video_results_json = ApiGateway.new.create_recipe_video(search_name)
            results_video = VideosPraise::VideosRepresenter.new(OpenStruct.new)
                                                           .from_json video_results_json
            results = Views::ResultsVideo.new(results_video)
            puts "in search"
            results.results_video.each.with_index do |video, index|
              puts index
              puts video
            end
            # results.results_video.each {|x| puts x}
            # results.results_video.each.with_index do |video, index|
            #   puts video
            #   puts index
            # end
            #flash[:notice] = 'Search success!'
            view 'search_results', locals: {
              results: results
            }
          rescue
            flash[:error] = 'Search failed!'
            view 'root'

            # ownername, reponame = gh_url.split('/')[-2..-1]
            # ApiGateway.new.create_repo(ownername, reponame)
          end
          #routing.redirect '/'
        end
      end
    end
  end
end
