# frozen_string_literal: true

class ImagesController < ApplicationController
  def index
    images = fetch_request_images
               .order(:created_at)

    render json: images.to_json
  end

  def show
    image = fetch_request_image

    render json: image.to_json
  end

  def create
    upload = Upload.find(params[:upload_id])
    image_data = params
                    .require(:image)
                    .permit(:url)

    image = Image.new(image_data.merge(upload: upload, status: :new))
    image.save!

    render json: image.to_json
  end

  def update
    image = fetch_request_image

    image_data = params
                   .require(:image)
                   .permit(:url)

    image.update!(image_data)

    render json: image.to_json
  end

  def destroy
    image = fetch_request_image

    image.destroy!

    head :no_content
  end

  def fetch_request_image
    fetch_request_images
      .where(id: params[:id])
      .first
  end

  def fetch_request_images
    Image
      .joins(:upload)
      .where(upload: { user: current_user })
  end
end
