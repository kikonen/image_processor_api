# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tokens
  has_many :uploads
end
