# frozen_string_literal: true

class Upload < ApplicationRecord
  belongs_to :user
  has_many :images, -> { order(created_at: :desc) }, dependent: :destroy
end
