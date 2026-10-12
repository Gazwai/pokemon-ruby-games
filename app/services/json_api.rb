class JsonApi
  TIMEOUTS = { connect_timeout: 3, request_timeout: 5 }.freeze

  def self.get(url, params: nil)
    HTTPX.with(timeout: TIMEOUTS).get(url, params:).raise_for_status.json
  rescue StandardError => error
    Rails.logger.error "GET #{url} failed: #{error.class}: #{error.message}"
    nil
  end
end
