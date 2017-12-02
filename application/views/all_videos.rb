# frozen_string_literal: true

module VideosPraise
  module Views
    # View object for colelction of Github projects
    class AllVideos
      def initialize(all_videos)
        @all_videos = all_videos
      end

      def none?
        @all_videos.all_videos.none?
      end

      def any?
        @all_videos.all_videos.any?
      end

      def all
        @all_videos.all_videos.map { |video| Video.new(video) }
      end
    end
  end
end
