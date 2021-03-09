class MapsController < ApplicationController
  def index
    geojson = {
        type: 'FeatureCollection',
        features: []
    }
    
    
    Map.published.each do |m|
      json = REDIS.get("m_#{m.id}")
      geojson[:features] << JSON.parse(json)
    end

    expires_in 15.minutes, public: true
    respond_to do |format|
      format.json {render json: geojson}
    end
  end


  def search
   
    geojson = {
        type: 'FeatureCollection',
        features: []
    }
    Map.published.each do |m|
      json = REDIS.get("s_#{m.id}")
      geojson[:features] << JSON.parse(json)
    end

    expires_in 15.minutes, public: true

    respond_to do |format|
      format.json {render json: geojson}
    end
  end

  def show
    map_id = params[:id]

    if map_id.nil? || Map.find(map_id).nil? || !Map.find(map_id).published?
      redirect_to '/', :status => 404
      return
    end

    json = REDIS.get("map_#{map_id}")
    respond_to do |format|
      format.json {render json: json}
    end
  end

  def gone
    respond_to do |format|
      format.all { render plain: 'URI no longer available', status: 410 }
    end
  end

end
