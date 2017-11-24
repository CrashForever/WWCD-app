# frozen_string_literal: true

module VideosPraise
  module Views
    # View object for a single repo's Github project
    class ResultsVideo
      def initialize(results)
        @results = results
      end

      def query_name
        @results.query_name
      end

      def results_video
        @results.video_id
      end
    end
  end
end
