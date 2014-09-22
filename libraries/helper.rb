#
# Cookbook Name:: netscaler
# Library:: helper
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
  module Helper

    def check_if_resource_exists(hostname, username, password, resource_type, resource, value=nil)
      begin
        request = build_request(hostname, username, password, 'get', resource_type, resource,
          options = {})
        response = request.execute()
      rescue RestClient::ResourceNotFound
        puts "Resource #{ resource } not found in Netscaler"
        return false
      rescue RestClient::Unauthorized
        puts 'Netscaler refused credentials'
      rescue SocketError
        puts "Couldn't connect to Netscaler at #{hostname}"
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

    def create_resource(resource_type, resource_id, hostname, username, password, options = {})
      created = false
      resource_exists = check_if_resource_exists(hostname, username, password, resource_type,
        options[:"#{resource_id}"])

      if resource_exists == false
        request = build_request(hostname, username, password, 'post', resource_type, nil, options)
        response = request.execute()
        created = true
      else
        Chef::Log.info "Resource #{options[:"#{resource_id}"]} already exists on the netscaler."
      end
      return created
    end

    def update_resource(resource_type, resource_id, hostname, username, password, options = {})
      updated = false
      resource_exists = check_if_resource_exists(hostname, username, password, resource_type,
        options[:"#{resource_id}"])
      options_edited = options.reject { |k, v| v.nil? }

      unless resource_exists == false
        update_required = false
        options_edited.each do |r|
          key_value_exists = check_if_resource_exists(hostname, username, password,
            resource_type, r[0].to_s, r[1])
          update_required = true unless key_value_exists == true
        end
      end
      if update_required == true
        request = build_request(hostname, username, password, 'put', resource_type,
          options[:"#{resource_id}"], options_edited)
        response = request.execute()
        updated = true
      end
      return updated
    end

    def delete_resource(resource_type, resource_id, hostname, username, password, options = {})
      deleted = false
      resource_exists = check_if_resource_exists(hostname, username, password, resource_type,
        options[:"#{resource_id}"])

      unless resource_exists == false
        request = build_request(hostname, username, password, 'delete', resource_type,
          options[:"#{resource_id}"], options)
        response = request.execute()
        deleted = true
      end
      return deleted
    end

    def build_request(hostname, username, password, method, resource_type, resource=nil,
      options = {})
      headers = {}
      payload = {}
      url = "http://#{hostname}/nitro/v1/config/#{resource_type}"
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
        :user => username,
        :password => password,
        :headers => headers,
        :payload => payload.to_json
      )
      request
    end

  end
end
