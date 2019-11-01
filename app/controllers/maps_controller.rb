class MapsController < ApplicationController

  def index
    maps = Map.published.includes(:club,:map_type)
      geojson = {
          type: 'FeatureCollection',
          features: []
      }

      maps.each do |m|
        geojson[:features] << {
            type: 'Feature',
            geometry: {
                type: 'Point',
                coordinates: [m.lng, m.lat]
            },
            properties: {
                id: m.id,
                name: m.title,
                club: m.club.name,
                year: m.year,
                type: m.map_type.title
            }
        }
      end

    expires_in 1.hour, public: true
    respond_to do |format|
      format.json { render json: geojson }
    end
  end


  def search
    maps = Map.published.includes(:club, :map_type)
    geojson = {
        type: 'FeatureCollection',
        features: []
    }
    maps.each do |m|
      geojson[:features] << {
          type: 'Feature',
          id:  "omaps.#{m.id}",
          text: "#{m.title} (#{m.club.name})",
          center: [m.lng, m.lat]
      }
    end

    expires_in 1.hour, public: true

    respond_to do |format|
      format.json { render json: geojson }
    end
  end

  def show
    @map = Map.published.where(id: params[:id]).last

    if @map.nil?
      redirect_to '/', :status => 404
      return
    end

    images = []
    @map.images.each { |img| images << { url: url_for(img.variant(resize: "200x200")) } }

    geojson = {}

    geojson = {
      type: 'Feature',
      geometry: {
          type: 'Point',
          coordinates: [@map.lng, @map.lat]
      },
      properties: {
          id: @map.id,
          name: @map.title,
          club: @map.club.name,
          year: @map.year,
          type: @map.map_type.title,
          contours: @map.contours,
          description: @map.description,
          identifier: @map.identifier,
          map_type: @map.map_type.title,
          mapper: @map.mapper,
          region: @map.region,
          scale: @map.scale,
          contact_email: @map.contact_email,
          images: images
      }
    } unless @map.nil?


    respond_to do |format|
      format.json { render json: geojson }
    end

  end

  def gone
    respond_to do |format|
      format.all  { render plain: 'URI no longer available', status: 410 }
    end
  end
end
