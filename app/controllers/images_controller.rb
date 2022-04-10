# frozen_string_literal: true

class ImagesController < ApplicationController
  def index
    images = Image
               .joins(:upload)
               .where(upload: { user: current_user })

    render json: images.to_json
  end

  def show
    image = Image
              .where(id: params[:id])
              .joins(:upload)
              .where(upload: { user: current_user })

    render json: image.to_json
  end

  def create
    image_data = params
                    .require(:image)
                    .permit(:images)

    image = Image.new(image_data.merge(user: current_user))
    image.save!

    render json: image.to_json
  end

  def update
    image_data = params.require(:image).permit(:images)

    image = Image.where(
      id: params[:id],
      user: current_user)

    image.update!(image_data)

    render json: image.to_json
  end

  def destroy
    image = Image.where(
      id: params[:id],
      user: current_user)

    image.destroy!

    head :no_content
  end

end
