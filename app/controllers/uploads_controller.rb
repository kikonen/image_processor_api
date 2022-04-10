# frozen_string_literal: true

class UploadsController < ApplicationController
  def index
    uploads = Upload.all

    render json: uploads.to_json
  end

  def show
    upload = Upload.find(params[:id])

    render json: upload.to_json
  end

  def create
    upload_data = params.require(:upload).permit(:email)

    upload = Upload.new(upload_data)
    upload.save!

    render json: upload.to_json
  end

  def update
    upload_data = params.require(:upload).permit(:email)

    upload = Upload.find(params[:id])
    upload.update!(upload_data)

    render json: upload.to_json
  end

  def destroy
    upload = Upload.find(params[:id])
    upload.destroy!

    head :no_content
  end

end
