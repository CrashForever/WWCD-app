# frozen_string_literal: true

# Represents essential Collaborator information for API output
# USAGE:
#   collab = # Get from gateway
#   CollaboratorRepresenter.new(OpenStruct.new).from_json collab
module VideosPraise
  class RecipesRepresenter < Roar::Decorator
    include Roar::JSON

    property :query_name
    collection :label
    collection :url
    collection :image
  end
end
