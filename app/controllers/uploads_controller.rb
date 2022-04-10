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
                    .permit(:images)

    upload = Upload.new(upload_data.merge(user: current_user))
    upload.save!

    render json: upload.to_json
  end

  def update
    upload_data = params.require(:upload).permit(:images)

    upload = fetch_request_upload

    upload.update!(upload_data)

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
    Upload.where(user: current_user)
  end
end
