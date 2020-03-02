class IndexController < ApplicationController
  def index
    @map = nil
    slug = params[:map_id]

    @map = if !slug.nil? && !slug.empty? && slug.to_i.positive?
             Map.published.where(id: slug).last
           elsif !slug.nil? && !slug.empty?
             Map.published.where(url: slug).last
           end
  end
end
