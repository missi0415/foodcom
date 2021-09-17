# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # 開発環境
    # origins ENV["API_DOMAIN"] || ""
    # 本番環境
    #origins [ENV["API_DOMAIN"], 'https://www.foodcom-api.work']
    # origins [ENV["API_DOMAIN"], 'https://www.foodcom.work']
    origins '*'
    # origins 'localhost:3000','https://www.foodcom.work','https://www.foodcom-api.work'
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
