class LocationController < ApplicationController
	include LocationHelper
  def new
    @location = Location.new
  end
  def create
    @location = Location.new(location_params)
    if @location.save
      redirect_to '/locations/show'
		else
      render 'new'
    end
  end
	def show
	  @location = Location.order("created_at").last
		if @location.nil? || @location.content.empty?
			redirect_to '/locations/error'
		end
	end
	def playlist
		@location = Location.order("created_at").last
		@playlist_info = weather_lookup(Location.order("created_at").last)
	end
  private
  def location_params
    params.require(:location).permit(:content)
  end
end
