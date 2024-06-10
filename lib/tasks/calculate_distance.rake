namespace :rides do
    desc "Calculate distance for all existing rides"
    task calculate_distance: :environment do
      Ride.all.each do |ride|
        if ride.pickup_stop.present? && ride.drop_off_stop.present?
          distance = Geocoder::Calculations.distance_between(
            ride.pickup_stop,
            ride.drop_off_stop
          )
          ride.update(distance: distance)
          puts "Updated distance for Ride ##{ride.id}: #{distance} miles"
        else
          puts "Skipping Ride ##{ride.id}: Missing pickup or drop-off stop"
        end
      end
    end
end