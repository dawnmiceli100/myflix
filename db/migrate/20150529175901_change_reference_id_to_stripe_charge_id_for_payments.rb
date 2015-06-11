class ChangeReferenceIdToStripeChargeIdForPayments < ActiveRecord::Migration
  def change
    rename_column :payments, :reference_id, :stripe_charge_id
  end
end
