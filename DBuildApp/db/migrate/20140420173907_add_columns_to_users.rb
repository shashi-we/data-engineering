class AddColumnsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :position, :integer
  	add_column :users, :uid, :string
		add_column :users, :provider, :string, index: true
	  add_column :users, :token, :string
	  add_column :users, :secret, :string
	  add_column :users, :expires_at, :datetime
	  add_column :users, :image, :string
	  add_column :users, :first_name, :string
	  add_column :users, :last_name, :string
  end
end
