class CreatePartyGuests < ActiveRecord::Migration[7.0]
  def change
    create_table :party_guests do |t|
      t.references :user, null: false, foreign_key: true
      t.references :viewing_party, null: false, foreign_key: true
      t.boolean :host

      t.timestamps
    end
  end
end
