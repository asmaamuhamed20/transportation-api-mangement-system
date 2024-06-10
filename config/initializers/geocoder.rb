# config/initializers/geocoder.rb

Geocoder.configure(
    # Specify the geocoding provider
    lookup: :nominatim,
  
    # Optionally, set timeout and other options specific to the provider
    # timeout: 5, # Timeout in seconds for geocoding requests
    # api_key: 'YOUR_API_KEY', # If the provider requires an API key
)
  