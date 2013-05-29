#!/usr/bin/env ruby

$stdout.sync = true

require 'bundler/setup'
require 'net/http'
require 'logger'
require 'eventmachine'

class Watch
	def initialize url
		@url = url
		@log = Logger.new(STDOUT)
		@log.info "App is up."
	end

	def is_alive?
		begin
			uri = URI(@url)
			request = Net::HTTP.get_response(uri)
			unless request.is_a?(Net::HTTPSuccess)
				@log.warn "Error executing request"
			else
				@log.info "Is alive."
			end
		rescue Exception => e
			@log.warn "Big error."
		end
	end
end

w = Watch.new("http://nomethoderror.herokuapp.com/")

EM.run do
	EM.add_periodic_timer(60*2) do
		w.is_alive?	
	end
end

