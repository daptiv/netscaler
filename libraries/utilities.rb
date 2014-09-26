#
# Cookbook Name:: netscaler
# Library:: utilities
#
# Copyright 2014, Daptiv
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'rest-client'
require 'json'

module Netscaler
  class Utilities

    attr_accessor :hostname, :username, :password

    def initialize(options)
      @hostname = options[:hostname]
      @username = options[:username]
      @password = options[:password]
    end

    def check_if_resource_exists(resource_type, resource, value=nil)
      begin
        request = build_request('get', resource_type, resource,
          options = {})
        response = request.execute()
      rescue RestClient::ResourceNotFound
        puts "Resource #{ resource } not found in Netscaler"
        return false
      rescue RestClient::Unauthorized
        puts 'Netscaler refused credentials'
      rescue SocketError
        puts "Couldn't connect to Netscaler at #{@hostname}"
      end

      if value.nil?
        return true if response.include?(resource)
        Chef::Log.info "Resource #{ resource } not found in Netscaler"
        false
      else
        value = "\"#{value}\"" if value.is_a?(String)
        return true if response.include?("\"#{resource}\": #{value}")
        false
      end
    end

    def build_request(method, resource_type, resource=nil, options = {})
      headers = {}
      payload = {}
      primary_hostname = find_primary
      url = "http://#{primary_hostname}/nitro/v1/config/#{resource_type}"
      url += "/#{resource}/" if method == 'put' || method == 'delete'
      options_edited = options.reject { |k, v| v.nil? }
      unless method == 'get'
        payload[:"#{resource_type}"] = options_edited
        headers = {
          :content_type => "application/vnd.com.citrix.netscaler.#{resource_type}+json",
          :accept => :json }
      end
      request = RestClient::Request.new(
        :method => method,
        :url => url,
        :user => @username,
        :password => @password,
        :headers => headers,
        :payload => payload.to_json
      )
      request
    end

    def find_primary
      resp = nil
      if @hostname.kind_of? Array
        @hostname.each do |name|
          puts "Attempting to connect to #{name}..."
          begin
            resp = RestClient.get("http://#{@username}:#{@password}@#{name}/nitro/v1/config/hanode",
              { :accept => :json })
            next
          rescue
            puts "Unable to connect to #{name}..."
          end
          break unless resp.nil?
        end
      else
        resp =
          RestClient.get("http://#{@username}:#{@password}@#{@hostname}/nitro/v1/config/hanode",
            { :accept => :json })
      end
      foo = JSON.parse(resp)
      foo['hanode'].each do |i|
        return i['ipaddress'] if i['state'] == 'Primary'
      end
      Chef::Application.fatal!('Unable to find a Primary Netscaler for HA...Exiting!')
    end

  end
end
