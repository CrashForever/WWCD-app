module VideosPraise
  # Web API
  class Api < Roda
    routing.on 'camera_photo_upload' do
      routing.post do
        begin
          photo = routing.params['snapshot']
          file_results = ApiGateway.new.photo_from_camera(photo)
          analyzed_result = VideosPraise::GoogleVisionResultsRepresenter.new(OpenStruct.new)
                                                                        .from_json file_results
          query_name = analyzed_result.label.to_s + ' food recipe'

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
  end
end
