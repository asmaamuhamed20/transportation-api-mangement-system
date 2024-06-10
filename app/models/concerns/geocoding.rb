module Geocoding
    extend ActiveSupport::Concern
  
    private
  
    def pickup_stop_changed?
      pickup_stop.present? && (pickup_stop_address_changed? || pickup_stop_latitude.nil? || pickup_stop_longitude.nil?)
    end
  
    def drop_off_stop_changed?
      drop_off_stop.present? && (drop_off_stop_address_changed? || drop_off_stop_latitude.nil? || drop_off_stop_longitude.nil?)
    end
  
    def geocode_pickup_stop
      geocode
    end
  
    def geocode_drop_off_stop
      geocode
    end
  
    def calculate_distance
      geocoder_pickup = Geocoder.search(pickup_stop).first
      geocoder_drop_off = Geocoder.search(drop_off_stop).first
  
      if geocoder_pickup && geocoder_drop_off
        self.distance = Geocoder::Calculations.distance_between(
          [geocoder_pickup.latitude, geocoder_pickup.longitude],
          [geocoder_drop_off.latitude, geocoder_drop_off.longitude]
        )
      end
    end
end
  