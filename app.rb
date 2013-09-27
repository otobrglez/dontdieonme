#!/usr/bin/env ruby

$stdout.sync = true

require 'bundler/setup'
require 'net/http'
require 'logger'
require 'eventmachine'
require 'dotenv'
require 'rollbar/rails'

Dotenv.load unless ENV["ENV"] == "production"
Rollbar.configuration.access_token = ENV["ROLLBAR_ACCESS_TOKEN"]
Rollbar.configuration.endpoint = ENV["ROLLBAR_ENDPOINT"]

Rollbar.configuration.environment = ENV["ENV"] ||= "production"
Rollbar.configuration.framework = "Ruby: 2.0.0"

class Watch
	def initialize url
		@url = url
		@log = Logger.new(STDOUT)
		@log.info "Tracking: #{url}"
		@log.info "App is up."
		is_alive?
	end

	def is_alive?
		begin
			uri = URI(@url)
			request = Net::HTTP.get_response(uri)
			unless request.is_a?(Net::HTTPSuccess)
				@log.warn "Error executing request"
				raise "Error executing request"
			else
				@log.info "Is alive."
			end
		rescue Exception => e
			@log.warn "Big error."
			Rollbar.report_exception(e)
		end
	end
end

w = Watch.new(ENV["URL_TO_GET"])

EM.run do
	EM.add_periodic_timer(60*2) do
		w.is_alive?
	end
end

