class MapsController < ApplicationController

  caches_page :index, :search


  def index
    maps = Map.published_and_approved
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

    respond_to do |format|
      format.json { render json: geojson }
    end
  end


  def search
    maps = Map.published_and_approved
    geojson = {
        type: 'FeatureCollection',
        features: []
    }

    maps.each do |m|
      geojson[:features] << {
          type: 'Feature',
          id:  "omaps.#{m.id}",
          text: m.title,
          center: [m.lng, m.lat]
      }


    end
    respond_to do |format|
      format.json { render json: geojson }
    end
  end




  def show
    @map = Map.published_and_approved.where(id: params[:id]).last
    respond_to do |format|
      format.json { render json: @map, :include => [:club, :map_type, :submitter, :last_editor], :methods => [:images_urls] }
    end

  end
end
