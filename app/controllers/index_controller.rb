class IndexController < ApplicationController
  def index
    @map = nil
    slug = params[:id]
    unless slug.nil?
      if slug.to_i > 0
        @map = Map.published.where(id: slug).last
      else
        @map = Map.published.where(url: slug).last
      end
    end
  end
end
