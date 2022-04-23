# frozen_string_literal: true

class Image < ApplicationRecord
  belongs_to :upload
  has_many :exif_values, -> { order(:key) }, dependent: :destroy

  accepts_nested_attributes_for :exif_values
end
