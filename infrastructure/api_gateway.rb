# frozen_string_literal: true

require 'http'

module VideosPraise
  class ApiGateway
    def initialize(config = VideosPraise::App.config)
      @config = config
    end

    def all_recipe_video
      call_api(:get, 'getAll')
    end

    # def repo(username, reponame)
    #   call_api(:get, ['repo', username, reponame])
    # end

    def create_recipe_video(search_name)
      call_api(:post, 'videosearch/'+search_name)
    end

    def call_api(method, resources)
      url_route = [@config.api_url, resources].flatten.join'/'
      result = HTTP.send(method, url_route)
      raise(result.to_s) if result.code >= 300
      result.to_s
    end
  end
end
