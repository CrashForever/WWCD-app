# frozen_string_literal: true

module VideosPraise
  module Views
    # View object for a single repo's Github project
    class ResultsRecipe
      def initialize(recipe)
        @recipe = recipe
      end

      def query_name
        @recipe.query_name
      end

      def label
        @recipe.label
      end

      def url
        @recipe.url
      end

      def image
        @recipe.image
      end

      def items
        size = @recipe.label.length
        items = []
        for i in 0..size-1
          item = []
          item << @recipe.label[i]
          item << @recipe.url[i]
          item << @recipe.image[i]
          items << item
        end
        items
      end
    end
  end
end
