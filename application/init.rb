# frozen_string_literal: false
folders = %w[representers views controllers]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
