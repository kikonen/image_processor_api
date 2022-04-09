class CreateExifValues < ActiveRecord::Migration[7.0]
  include ::UpdatedAtTrigger

  def change
    create_table :exif_values, id: :uuid do |t|
      t.string :key, null: false
      t.string :value

      t.timestamps default: -> { 'now()' }, null: false
    end

    add_updated_at_trigger(:exif_values)

    add_reference(
      :exif_values,
      :image,
      null: false,
      foreign_key: true,
      type: :uuid,
      index: { name: 'idx_exif_value_image' })
  end
end
