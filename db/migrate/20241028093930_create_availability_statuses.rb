class CreateAvailabilityStatuses < ActiveRecord::Migration[7.2]
  def change
    create_table :availability_statuses do |t|
      t.string :availabilityStatus, null: false
      t.string :time
      t.string :location
      t.date :date, default: -> { "CURRENT_DATE" }
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_check_constraint :availability_statuses, "availabilityStatus IN ('available', 'leave')", name: "availability_status_check"
    add_check_constraint :availability_statuses, "location IN ('home', 'office')", name: "location_check"
  end
end
