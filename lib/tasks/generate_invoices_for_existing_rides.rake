# lib/tasks/generate_invoices_for_existing_rides.rake
namespace :rides do
    desc "Generate invoices for rides without invoices"
    task generate_invoices: :environment do
      rides_without_invoices = Ride.includes(:invoice).where(invoices: { id: nil })
  
      rides_without_invoices.find_each do |ride|
        invoice = Invoice.new(
            ride_id: ride.id,
            user_id: ride.user_id,
            driver_id: ride.driver_id,
            fare: calculate_fare(ride.start_time, ride.end_time)
          ) 
        if invoice.save
          puts "Invoice generated for Ride ID: #{ride.id}"
        else
          puts "Failed to generate invoice for Ride ID: #{ride.id}, Errors: #{invoice.errors.full_messages.join(", ")}"
        end
      end
  
      puts "Invoice generation completed!"
    end
end

def calculate_fare(start_time, end_time)
    duration_in_hours = (end_time.to_time - start_time.to_time) / 3600.0
    fare = duration_in_hours * HOURLY_RATE
end