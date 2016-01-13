$dwolla = DwollaV2::Client.new(id: ENV["DWOLLA_ID"], secret: ENV["DWOLLA_SECRET"]) do |config|
  config.environment = :sandbox
  config.on_grant {|t| TokenData.create! t }
  config.faraday do |f|
    f.use :instrumentation
    f.adapter Faraday.default_adapter
  end
end

ActiveSupport::Notifications.subscribe('request.faraday') do |name, start_time, end_time, _, env|
  url = env[:url]
  http_method = env[:method].to_s.upcase
  duration = end_time - start_time
  Rails.logger.debug '[%s] %s %s (%.3f s)' % [url.host, http_method, url.request_uri, duration]
end
