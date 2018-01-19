# frozen_string_literal: true

module VideosPraise
  # Web API
  class App < Roda
    route('search') do |routing|
      routing.post do
        begin
          # Youtube
          search_name = routing.params['search_name'].to_s + ' recipe'
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
