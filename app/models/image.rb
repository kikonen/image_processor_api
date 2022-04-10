# frozen_string_literal: true

class Image < ApplicationRecord
  belongs_to :upload
  has_many :exif_values, dependent: :destroy
end
