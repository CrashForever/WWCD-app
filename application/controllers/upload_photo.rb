# frozen_string_literal: true

module VideosPraise
  # Web API
  class App < Roda
    route('uploadFile') do |routing|
      routing.post do
        begin
          tempfile = routing.params['fileToUpload'][:tempfile]
          file_results = ApiGateway.new.identify_img(tempfile)
          analyzed_result = VideosPraise::GoogleVisionResultsRepresenter.new(OpenStruct.new)
                                                                        .from_json file_results
          query_name = analyzed_result.label.to_s + ' recipe'
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
          view 'root'
        end
      end
    end
  end
end
