class CreateTokens < ActiveRecord::Migration[7.0]
  include ::UpdatedAtTrigger

  def change
    create_table :tokens, id: :uuid do |t|
      t.string :token, null: false

      t.timestamps default: -> { 'now()' }, null: false

      t.index [:token], unique: true
    end

    add_updated_at_trigger(:tokens)

    add_reference(
      :tokens,
      :user,
      null: false,
      foreign_key: true,
      type: :uuid,
      index: { name: 'idx_token_user' })
  end
end
