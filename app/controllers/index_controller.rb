class IndexController < ApplicationController
  def index
    @map = nil
    slug = params[:id]
    return if slug.nil?
    @map = if slug.to_i.positive?
             Map.published.where(id: slug).last
           else
             Map.published.where(url: slug).last
           end
  end
end
