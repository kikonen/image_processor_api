# frozen_string_literal: true

class User < ApplicationRecord
  SYSTEM_ID = '00000000-0000-0000-0000-000000000000'

  has_many :tokens, dependent: :destroy
  has_many :uploads, -> { order(created_at: :desc) }, dependent: :destroy

  def system_user?
    self.id == SYSTEM_ID
  end

  def normal_user?
    !system_user?
  end

  def self.system_user
    @system_user ||= begin
      User.new(
        id: User::SYSTEM_ID,
        email: 'system@local')
    end
  end
end
