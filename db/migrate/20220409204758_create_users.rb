class CreateUsers < ActiveRecord::Migration[7.0]
  include ::UpdatedAtTrigger

  def change
    create_table :users, id: :uuid do |t|
      t.string :email, null: false

      t.timestamps default: -> { 'now()' }, null: false

      t.index [:email], unique: true, name: 'idx_user_email'
    end

    add_updated_at_trigger(:users)
  end
end
