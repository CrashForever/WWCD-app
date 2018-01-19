# frozen_string_literal: true

module VideosPraise
  class App < Roda
    def represent_response(result, success_representer)
      http_response = HttpResponseRepresenter.new(result.value)
      response.status = http_response.http_code
      if result.success?
        yield if block_given?
        success_representer.new(result.value.message).to_json
      else
        http_response.to_json
      end
    end

    def folder_name_from(request)
      path = request.remaining_path
      path.empty? ? '' : path[1..-1]
    end
  end
end
