# frozen_string_literal: true

class UploadsController < ApplicationController
  def index
    uploads = fetch_request_uploads
                .order(created_at: :desc)

    render json: uploads.to_json
  end

  def show
    upload = fetch_request_upload

    render json: upload.to_json(include: :images)
  end

  def create
    upload_data = params
                    .require(:upload)
                    .permit(images: [:url])

    # NOTE KI images != image_attributes
    upload_data[:images_attributes] = upload_data[:images] || []
    upload_data.delete :images
    upload_data[:images_attributes]&.each do |data|
      data[:status] = :new
    end

    upload = Upload.new(upload_data)
    upload.user = current_user

    upload.save!
    upload.reload

    upload.images.each do |image|
      ImageFetchJob.perform_later(image_id: image.id)
    end

    render json: upload
  end

  def update
    # NOTE KI override images to refresh them
    upload = fetch_request_upload

    upload_data = params
                    .require(:upload)
                    .permit(images: [:url])

    # NOTE KI images != image_attributes
    upload_data[:images_attributes] = upload_data[:images] || []
    upload_data.delete :images
    upload_data[:images_attributes]&.each do |data|
      data[:status] = :new
    end

    upload.update!(upload_data)
    upload.reload

    upload.images.each do |image|
      ImageFetchJob.perform_later(image_id: image.id)
    end

    render json: upload
  end

  def destroy
    upload = fetch_request_upload

    upload.destroy!

    head :no_content
  end

  private

  def fetch_request_upload
    fetch_request_uploads
      .where(id: params[:id])
      .first
  end

  def fetch_request_uploads
    rel = Upload.all
    if current_user.normal_user?
      rel = rel.where(user: current_user)
    end
    rel
  end
end
