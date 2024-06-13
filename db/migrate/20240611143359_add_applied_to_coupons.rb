class AddAppliedToCoupons < ActiveRecord::Migration[7.1]
  def change
    add_column :coupons, :applied, :boolean
  end
end
