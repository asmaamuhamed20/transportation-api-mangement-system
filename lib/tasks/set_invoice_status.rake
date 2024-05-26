namespace :invoices do
    desc "Set status of all invoices to 'Pending'"
    task set_pending: :environment do
      Ride.find_each do |ride|
        invoice = ride.invoice
        next unless invoice
        invoice.update(status: "Pending")
      end
      puts "Invoice statuses updated successfully!"
    end
end