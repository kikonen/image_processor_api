#
# https://www.codegrepper.com/code-examples/sql/postgres+trigger+updated_at
#
class UpdatedTrigger < ActiveRecord::Migration[7.0]
  def up
    sql = <<-EOF
CREATE OR REPLACE FUNCTION public.set_current_timestamp_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  RETURN _new;
END;
$function$
    EOF

    execute sql
  end
end
