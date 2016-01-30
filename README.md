# google_places_fetcher
Simple Ruby script that queries Google Places API in provided locations from CSV file and stores results in another CSV file. It allows you to provide new Google API key if the former has exceeded quota.

Please note that exchanging Google API key may be incompatible with Google API Terms of Use - this software is provided as is and may be helpful in building small datasets (e.g. as test datasets for university projects).

### Usage
Run `ruby places_fetcher.rb locations_file query_term`. Script will ask you for your API key on initial execution and everytime the API key gets invalidated by exceeding QueryLimit.
