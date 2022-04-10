# frozen_string_literal: true

class ImagesController < ApplicationController
  def index
    images = fetch_request_images
               .order(:created_at)

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

    image = Image.new({ upload: upload, status: :new }.merge!(image_data))
    image.save!

    ImageFetchJob.perform_later(image_id: image)

    render json: image.to_json
  end

  def update
    image = fetch_request_image

    image_data = params
                   .require(:image)
                   .permit(:status, :mime_type, exif_values: [:key, :value])

    if image_data.key?(:exif_values)
      # NOTE KI Override exif values to refresh them
      image_data[:exif_values] = image_data[:exif_values]&.map do |exif_data|
        ExifValue.new(exif_data)
      end
    end

    image.update!(image_data)

    image = Image.where(id: image.id).includes(:exif_values).first

    render json: image.to_json(include: :exif_values)
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
    if current_user.normal_user?
      Image
        .joins(:upload)
        .where(upload: { user: current_user })
    else
      Image.all
    end
  end
end
