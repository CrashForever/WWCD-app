# frozen_string_literal: true

require 'roda'
require 'slim'

module VideosPraise
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'presentation/views'
    plugin :assets, css: 'style.css', path: 'presentation/assets'

    route do |routing|
      routing.assets
      app = App

      # GET / request
      routing.root do
        #http://localhost:3000/api/v0.1/getAll
        video_results_json = ApiGateway.new.all_recipe_video
        all_video = VideosPraise::AllVideosRepresenter.new(OpenStruct.new)
                                                .from_json video_results_json
        videos = Views::AllVideos.new(all_video)
        puts all_video.all_videos
        # tmp = {}
        # all_video.all_videos.each do|x|
        #   tmp.push(VideosPraise::AllVideosContentsRepresenter.new(OpenStruct.new).from_json x.to_json)
        # end
        # puts tmp
        # tmp.each{|x| puts x}
        view 'home', locals: {
                                  videos: videos
                                  # video_id: all_video.all_videos
                              }
      end

      routing.on 'search' do
        routing.post do
          puts "hihi"
          search_name = routing.params['search_name']
          puts search_name
          halt 400 unless search_name!=''
          video_results_json = ApiGateway.new.create_recipe_video(search_name)
          results_video = VideosPraise::VideosRepresenter.new(OpenStruct.new)
                                                  .from_json video_results_json
          results = Views::ResultsVideo.new(results_video)
          view 'search_results', locals: {
                                    results: results
                                }
          # ownername, reponame = gh_url.split('/')[-2..-1]
          # ApiGateway.new.create_repo(ownername, reponame)
        end
      end
    end
  end
end
