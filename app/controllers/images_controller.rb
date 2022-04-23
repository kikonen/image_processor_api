# frozen_string_literal: true

class ImagesController < ApplicationController
  def index
    images = fetch_request_images
               .order(created_at: :desc)

    render json: images.to_json
  end

  def show
    image = fetch_request_image

    render json: image.to_json(include: :exif_values)
  end

  def create
    upload = Upload.find(params[:upload_id])
    image_data = params
                   .require(:image)
                   .permit(:url)

    # NOTE KI exif_values != exif_values_attributes
    image_data[:exif_values_attributes] = image_data[:exif_values] || []
    image_data.delete :exif_values

    image = Image.new(image_data)
    image.upload = upload
    image.status = :new

    image.save!
    image.reload

    ImageFetchJob.perform_later(image_id: image.id)

    render json: image.to_json
  end

  def update
    # NOTE KI Override exif values to refresh them
    image = fetch_request_image

    image_data = params
                   .require(:image)
                   .permit(:status, :mime_type, exif_values: [:key, :value])

    # NOTE KI exif_values != exif_values_attributes
    image_data[:exif_values_attributes] = image_data[:exif_values] || []
    image_data.delete :exif_values

    image.update!(image_data)
    image.reload

    render json: image
  end

  def destroy
    image = fetch_request_image

    image.destroy!

    head :no_content
  end

  def fetch
    image = fetch_request_image

    ImageFetchJob.perform_later(image_id: image.id)

    render json: image.to_json
  end

  private

  def fetch_request_image
    fetch_request_images
      .where(id: params[:id])
      .first
  end

  def fetch_request_images
    rel = Image.all
    if current_user.normal_user?
      rel = rel
              .joins(:upload)
              .where(upload: { user: current_user })
    end
    rel
  end
end
