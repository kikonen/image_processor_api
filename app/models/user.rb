# frozen_string_literal: true

class User < ApplicationRecord
  SYSTEM_ID = '00000000-0000-0000-0000-000000000000'

  has_many :tokens, dependent: :destroy
  has_many :uploads, dependent: :destroy

  def system_user?
    self.id == SYSTEM_ID
  end

  def normal_user?
    !system_user?
  end
end
