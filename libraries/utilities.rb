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

    def resource_exists?(resource_type, resource, key=nil, value=nil)
      begin
        request = build_request(
          method: 'get',
          resource_type: resource_type,
          resource: resource
        )
        response = request.execute()
      rescue RestClient::ResourceNotFound
        Chef::Log.error "Resource #{ resource } not found in Netscaler"
        return false
      rescue RestClient::Unauthorized
        puts 'Netscaler refused credentials'
      rescue SocketError
        puts "Couldn't connect to Netscaler at #{@hostname}"
      end

      if value.nil?
        return true if response.include?(resource)
        Chef::Log.info "Resource #{ resource } not found in Netscaler"
        return false
      else
        keyval_search = JSON.parse(response)
        keyval_search["#{resource_type}"].each do |it|
          if it.has_value?("#{resource}")
            return true if it["#{key}"].include?("#{value}")
          end
        end
        return false
      end

    end

    def binding_exists?(options = {})
      bind_type = options[:bind_type]
      resource_id = options[:resource_id]
      bind_type_id = options[:bind_type_id]
      begin
        request = build_request(
          method: 'get',
          resource_type: bind_type,
          resource: resource_id,
          resource_id: bind_type_id,
          binding: true
        )
        response = request.execute()
      rescue RestClient::ResourceNotFound
        msg = "Something's missing: resource_type=#{resource_type}, "
        msg += " resource_id=#{resource_id}, or resource=#{resource}"
        puts msg
        return false
      end

      return true if response.include?(resource_id)
      Chef::Log.debug "Binding #{resource_id} -> #{bind_type_id} not found in Netscaler"
      return false

    end

    def build_request(options = {})
      method = options[:method]
      resource_type = options[:resource_type]
      resource = options[:resource]
      resource_id = options[:resource_id]
      binding = options[:binding]
      payload = options[:payload]
      headers = {}
      newpayload = {}
      primary_hostname = find_primary
      url = build_url(method, primary_hostname, resource_type, resource, resource_id, binding)
      unless method == 'get'
        payload_edited = payload.reject { |k, v| v.nil? }
        newpayload[:"#{resource_type}"] = payload_edited
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
        :payload => newpayload.to_json
      )
      request
    end

    def build_url(method, primary_hostname, resource_type, resource, resource_id,
      binding)
      url = "http://#{primary_hostname}/nitro/v1/config/#{resource_type}/#{resource}"
      if binding == true
        url += "/#{resource_id}" if method == 'get'
        url += "?action=bind" if method == 'put'
      end
      return url
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
      Chef::Application.fatal!('Unable to find a Primary Netscaler for HA!')
    end

  end
end
