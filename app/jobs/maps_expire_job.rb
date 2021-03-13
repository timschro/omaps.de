class MapsExpireJob < ApplicationJob
  queue_as :default

  def perform(*args)
    paths = [Rails.public_path.join('maps.json'),Rails.public_path.join('search.json')]
    paths.each do |path_to_file|
      File.delete(path_to_file) if File.exist?(path_to_file)
    end
  end
end
