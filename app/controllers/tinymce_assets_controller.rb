class TinymceAssetsController < ApplicationController
  skip_forgery_protection

  def create
    # Take upload from params[:file] and store it somehow...
    # Optionally also accept params[:hint] and consume if needed
    image = TinyImage.create params.permit(:file, :alt, :hint)

    render json: { location: image.file.url }, content_type: "text / html"
  end
end
