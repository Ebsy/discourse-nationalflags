# frozen_string_literal: true
require 'geocoder/lookups/base'
require 'geocoder/results/maxmind_geoip2'

module Geocoder::Lookup
  class MaxmindGeoip2 < Base

    def name
      "MaxMind GeoIP2"
    end

    # Maxmind's GeoIP2 Precision Services only supports HTTPS,
    # otherwise a `404 Not Found` HTTP response will be returned
    def supported_protocols
      [:https]
    end

    def query_url(query)
      "#{protocol}://geoip.maxmind.com/geoip/v2.1/#{configured_service!}/#{query.sanitized_text.strip}"
    end

    private # ---------------------------------------------------------------

    def cache_key(query)
      query_url(query)
    end

    ##
    # Return the name of the configured service, or raise an exception.
    #
    def configured_service!
      if (s = configuration[:service]) && services.include?(s) && configuration[:basic_auth][:user] && configuration[:basic_auth][:password]
        s
      else
        raise(
          Geocoder::ConfigurationError, "When using MaxMind GeoIP2 you must specify a service and credentials: Geocoder.configure(maxmind_geoip2: {service: ..., basic_auth: {user: ..., password: ...}}), where service is one of: #{services.inspect}"
        )
      end
    end

    def data_contains_error?(doc)
      (["code", "error"] - doc.keys).empty?
    end

    ##
    # Service names used in URL.
    #
    def services
      [
        :country,
        :city,
        :insights,
      ]
    end

    def results(query)
      # don't look up a loopback or private address, just return the stored result
      return [] if query.internal_ip_address?

      doc = fetch_data(query)
      if doc
        if !data_contains_error?(doc)
          return [doc]
        else
          Geocoder.log(:warn, "MaxMind GeoIP2 Geocoding API error: #{doc['code']} (#{doc['error']}).")
        end
      end
      []
    end
  end
end
