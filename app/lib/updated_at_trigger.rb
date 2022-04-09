module UpdatedAtTrigger
  def add_updated_at_trigger(table)
    execute <<-EOF
CREATE TRIGGER set_updated_at
BEFORE UPDATE ON #{table}
FOR EACH ROW
EXECUTE FUNCTION set_current_timestamp_updated_at();
  EOF

  end
end

class ActiveRecord::Migration
  include ::UpdatedAtTrigger
end
