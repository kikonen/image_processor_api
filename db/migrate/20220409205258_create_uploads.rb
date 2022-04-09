class CreateUploads < ActiveRecord::Migration[7.0]
  include ::UpdatedAtTrigger

  def change
    create_table :uploads, id: :uuid do |t|
      t.timestamps default: -> { 'now()' }, null: false
    end

    add_updated_at_trigger(:uploads)

    add_reference(
      :uploads,
      :user,
      null: false,
      foreign_key: true,
      type: :uuid,
      index: { name: 'idx_upload_user' })
  end
end
