# frozen_string_literal: true

class ExifValuesController < ApplicationController
  def index
    exif_values = fetch_request_exif_values
                    .order(created_at: :desc)

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

    exif_value = ExifValue.new({ image: image }.merge!(exif_value_data))
    exif_value.save!

    render json: exif_value.to_json
  end

  def update
    exif_value = fetch_request_exif_value

    exif_value_data = params
                        .require(:exif_value)
                        .permit(:key, :value)

    exif_value.update!(exif_value_data)
    exif_value.reload

    render json: exif_value.to_json
  end

  def destroy
    exif_value = fetch_request_exif_value

    exif_value.destroy!

    head :no_content
  end

  private

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
    rel = Image.where(id: params[:image_id])

    if current_user.normal_user?
      rel = rel
              .joins(:upload)
              .where(upload: { user: current_user })
    end

    rel.first
  end
end
