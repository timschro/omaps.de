namespace :maps do
  task migrate_to_active_storage: :environment do
    Map.all.each do |map|
      next unless map.images.empty?
      response = HTTParty.get("http://www.omaps.de/maps/#{map.id}.json")
      begin
        json = JSON.parse(response.body)
        json['images_urls'].each do |image_url|
          image_url.gsub! 'medium', 'original'
          puts image_url
          uri = URI.parse(image_url)
          filename = File.basename(uri.path)
         map.images.attach(io: open(image_url), filename: filename)
        end
      rescue
        puts 'error'
      end
    end
  end
end