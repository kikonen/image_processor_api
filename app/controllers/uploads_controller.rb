# frozen_string_literal: true

class UploadsController < ApplicationController
  def index
    uploads = Upload.where(user: current_user)

    render json: uploads.to_json
  end

  def show
    upload = Upload.where(
      id: params[:id],
      user: current_user)

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

    upload = Upload.where(
      id: params[:id],
      user: current_user)

    upload.update!(upload_data)

    render json: upload.to_json
  end

  def destroy
    upload = Upload.where(
      id: params[:id],
      user: current_user)

    upload.destroy!

    head :no_content
  end

end
