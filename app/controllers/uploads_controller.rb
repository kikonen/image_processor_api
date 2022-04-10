# frozen_string_literal: true

class UploadsController < ApplicationController
  def index
    uploads = fetch_request_uploads
                .order(:created_at)

    render json: uploads.to_json
  end

  def show
    upload = fetch_request_upload

    render json: upload.to_json
  end

  def create
    upload_data = params
                    .require(:upload)
                    .permit(images: [:url])

    upload_data[:images] = upload_data[:images]&.map do |img_data|
      Image.new({status: :new}.merge!(img_data))
    end

    upload = Upload.new({ user: current_user }.merge!(upload_data))
    upload.save!

    upload = Upload.where(id: upload.id).includes(:images).first

    render json: upload.to_json(include: :images)
  end

  def update
    upload_data = params.require(:upload).permit(:images)

    upload = fetch_request_upload

    upload.update!(upload_data)
    upload.reload

    render json: upload.to_json
  end

  def destroy
    upload = fetch_request_upload

    upload.destroy!

    head :no_content
  end

  def fetch_request_upload
    fetch_request_uploads
      .where(id: params[:id])
      .first
  end

  def fetch_request_uploads
    if current_user.normal_user?
      Upload.where(user: current_user)
    else
      Upload
    end
  end
end
