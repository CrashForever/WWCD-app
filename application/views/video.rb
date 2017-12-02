# frozen_string_literal: true

module VideosPraise
  module Views
    # View object for a single repo's Github project
    class Video
      def initialize(video)
        @video = video
      end

      def id
        @video['video_id']
      end
      #
      # def link_to_repo
      #   "/repo/#{owner}/#{name}"
      # end
      #
      # def github_href
      #   @github_ref ||= ['https://github.com/', owner, name].join '/'
      # end
      #
      # def contributors
      #   @repo.contributors.map(&:username).join(', ')
      # end
    end
  end
end
