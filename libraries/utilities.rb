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

# Chef 12 doesn't ship with rest-client
# Make the gem available that we've vendored into this cookbook
$:.unshift *Dir[File.expand_path('../../files/default/vendor/gems/**/lib', __FILE__)]

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

    def resource_exists?(resource_type, resource)
      begin
        request = build_request(
          method: 'get',
          resource_type: resource_type,
          resource: resource
        )
        response = request.execute()
      rescue RestClient::ResourceNotFound
        Chef::Log.info "Resource #{ resource } not found in Netscaler"
        return false
      rescue RestClient::Unauthorized
        Chef::Log.error 'Netscaler refused credentials'
      rescue SocketError
        Chef::Application.fatal! "Couldn't connect to Netscaler at #{@hostname}"
      end

      return true if response.include?(resource)
      Chef::Log.info "Resource #{ resource } not found in Netscaler"
      return false
    end

    def key_value_exists?(resource_type, resource, key=nil, value=nil)
      begin
        request = build_request(
          method: 'get',
          resource_type: resource_type,
          resource: resource
        )
        response = request.execute()
      rescue RestClient::ResourceNotFound
        Chef::Log.info "Resource #{ resource } not found in Netscaler"
        return false
      rescue RestClient::Unauthorized
        Chef::Log.error 'Netscaler refused credentials'
      rescue SocketError
        Chef::Application.fatal! "Couldn't connect to Netscaler at #{@hostname}"
      end
      JSON.parse(response)[resource_type].each do |it|
        if it.has_value?(resource)
          it.each do |k, v|
            if k == key
              return true if v.is_a?(Integer) && v == value
              return true if v.is_a?(String) && v.include?(value)
            end
          end
        end
      end
      return false
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
        Chef::Log.info msg
        return false
      end

      return true if response.include?(bind_type_id)
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
        newpayload[resource_type.to_sym] = payload_edited
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

    def build_url(method, primary_hostname, resource_type, resource, resource_id, binding)
      url = "http://#{primary_hostname}/nitro/v1/config/#{resource_type}"
      if binding
        url += "/#{resource}/#{resource_id}" if method == 'get'
        url += "/#{resource}?action=bind" if method == 'put'
      end
      url += '?action=save' if resource_type == 'nsconfig'
      return url
    end

    def find_primary
      resp = nil
      hostname = if @hostname.kind_of? Array
        @hostname
      else
        @hostname.split(',')
      end
      hostname.each do |name|
        Chef::Log.info "Attempting to connect to #{name}..."
        begin
          resp = RestClient::Request.new(
            :method => 'get',
            :url => "http://#{name}/nitro/v1/config/hanode",
            :user => @username,
            :password => @password
          ).execute()
          next
        rescue Exception => e
          Chef::Log.info "Unable to connect to #{name}..."
          Chef::Log.info 'Error info:'
          Chef::Log.info "#{e.inspect}"
        end
        break unless resp.nil?
      end
      foo = JSON.parse(resp)
      foo['hanode'].each do |i|
        return i['ipaddress'] if i['state'] == 'Primary'
      end
      Chef::Application.fatal!('Unable to find a Primary Netscaler for HA!')
    end

    def save_config
      build_request(
        method: 'post',
        resource_type: 'nsconfig',
        payload: {}
      ).execute()
    end

    def logout
      build_request(
        method: 'post',
        resource_type: 'logout',
        payload: {}
      ).execute()
    end

  end
end
