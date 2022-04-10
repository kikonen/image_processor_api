class CreateImages < ActiveRecord::Migration[7.0]
  include ::UpdatedAtTrigger

  def change
    create_table :images, id: :uuid do |t|
      t.string :url, null: false
      t.string :status, null: false
      t.string :mime_type

      t.timestamps default: -> { 'now()' }, null: false
    end

    add_updated_at_trigger(:images)

    add_reference(
      :images,
      :upload,
      null: false,
      foreign_key: true,
      type: :uuid,
      index: { name: 'idx_image_upload' })
  end
end
