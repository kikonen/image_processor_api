# frozen_string_literal: true

class ExifValuesController < ApplicationController
  def index
    exif_values = fetch_request_exif_values
                    .order(:created_at)

    render json: exif_values.to_json
  end

  def show
    exif_value = fetch_request_exif_value

    render json: exif_value.to_json
  end

  def create
    image = fetch_request_image
    exif_value_data = params
                        .require(:exif_value)
                        .permit(:key, :value)

    exif_value = ExifValue.new(exif_value_data.merge(image: image))
    exif_value.save!

    render json: exif_value.to_json
  end

  def update
    exif_value = fetch_request_exif_value

    exif_value_data = params
                        .require(:exif_value)
                        .permit(:key, :value)

    exif_value.update!(exif_value_data)

    render json: exif_value.to_json
  end

  def destroy
    exif_value = fetch_request_exif_value

    exif_value.destroy!

    head :no_content
  end

  def fetch_request_exif_value
    fetch_request_exif_values
      .where(id: params[:id])
      .first
  end

  def fetch_request_exif_values
    ExifValue
      .where(image: fetch_request_image)
  end

  def fetch_request_image
    if current_user.normal_user?
      Image
        .joins(:upload)
        .where(upload: { user: current_user })
        .where(id: params[:image_id])
        .first
    else
      Image
        .where(id: params[:image_id])
        .first
    end
  end
end
