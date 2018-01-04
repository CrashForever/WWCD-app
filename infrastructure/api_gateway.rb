# frozen_string_literal: true

require 'http'
require 'json'
require 'rest_client'

module VideosPraise
  class ApiGateway
    def initialize(config = VideosPraise::App.config)
      @config = config
    end

    def all_recipe_video
      call_api(:get, ['video','getAll'])
    end

    # def repo(username, reponame)
    #   call_api(:get, ['repo', username, reponame])
    # end
    def identify_img(file)
      url_route = [@config.api_url, 'vision', 'upload'].flatten.join'/'
      puts url_route
      results = RestClient.post(url_route,
          :file => File.new(file))
      #puts results.to_s
      results
    end

    def create_recipe_video(search_name)
      call_api(:post, ['video','search',search_name])
    end

    def delete_all_videos
      call_api(:delete, ['video', 'deleteAll'])
    end

    def call_api(method, resources)
      url_route = [@config.api_url, resources].flatten.join'/'
      result = HTTP.send(method, url_route)
      raise(result.to_s) if result.code >= 300
      result.to_s
    end
  end
end
