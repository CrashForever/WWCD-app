# frozen_string_literal: true

# Represents essential Collaborator information for API output
# USAGE:
#   collab = # Get from gateway
#   CollaboratorRepresenter.new(OpenStruct.new).from_json collab
require_relative 'all_videos_content_representer.rb'

module VideosPraise
  class AllVideosRepresenter < Roar::Decorator
    include Roar::JSON

    collection :all_videos

  end
end
