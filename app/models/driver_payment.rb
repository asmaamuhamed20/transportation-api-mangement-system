class DriverPayment < ApplicationRecord
  belongs_to :driver
  belongs_to :invoice

  validates :payment_amount, presence: true, numericality: { greater_than: 0 }

  def self.create_payment(invoice)
    driver = invoice.driver
    return { success: false, error: 'Driver not found for the invoice' } unless driver

    payment_amount = calculate_driver_payment(invoice.fare)
    driver_payment = driver.driver_payments.build(payment_amount: payment_amount, invoice: invoice)

    if driver_payment.save
      { success: true, driver_payment: driver_payment }
    else
      { success: false, error: driver_payment.errors.full_messages }
    end
  end

  def self.calculate_driver_payment(fare)
    (fare.to_d * 0.45).round(2)
  end

  def self.payments_for_driver(driver_id)
    driver = Driver.find_by(id: driver_id)
    return { success: false, error: "Driver with ID #{driver_id} not found" } unless driver

    { success: true, payments: driver.driver_payments }
  end
end
