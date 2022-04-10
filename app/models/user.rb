# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tokens, dependent: :destroy
  has_many :uploads, dependent: :destroy
end
