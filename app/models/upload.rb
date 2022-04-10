# frozen_string_literal: true

class Upload < ApplicationRecord
  belongs_to :user
  has_many :images, dependent: :destroy
end
