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

module Netscaler
  module Helper

    def create_resource(resource_type, resource_id, hostname, username, password, payload = {})
      created = false
      ns = Netscaler::Utilities.new(:hostname => hostname, :username => username,
        :password => password)
      resource_exists = ns.resource_exists?(resource_type, payload[resource_id.to_sym])

      if !resource_exists
        Chef::Log.info "Creating new #{resource_type}: #{payload[resource_id.to_sym]}"
        request = ns.build_request(
          method: 'post',
          resource_type: resource_type,
          binding: false,
          payload: payload
        )
        response = request.execute()
        created = true
      else
        Chef::Log.info "Resource #{payload[resource_id.to_sym]} already exists on the netscaler."
      end
      return created
    end

    def update_resource(resource_type, resource_id, hostname, username, password, payload = {})
      updated = false
      ns = Netscaler::Utilities.new(:hostname => hostname, :username => username,
        :password => password)
      resource_exists = ns.resource_exists?(resource_type, payload[resource_id.to_sym])
      payload_edited = payload.reject { |k, v| v.nil? }

      unless !resource_exists
        update_required = false
        payload_edited.any? do |k, v|
          key_value_exists = ns.resource_exists?(resource_type, nil, k.to_s, v)
          update_required = true unless key_value_exists
        end
      end
      if update_required
        request = ns.build_request(
          method: 'put',
          resource_type: resource_type,
          resource: payload[resource_id.to_sym],
          payload: payload_edited
        )
        response = request.execute()
        updated = true
      end
      return updated
    end

    def delete_resource(resource_type, resource_id, hostname, username, password, payload = {})
      deleted = false
      ns = Netscaler::Utilities.new(:hostname => hostname, :username => username,
        :password => password)
      resource_exists = ns.resource_exists?(resource_type, payload[resource_id.to_sym])

      unless !resource_exists
        request = ns.build_request(
          method: 'delete',
          resource_type: resource_type,
          resource: payload[resource_id.to_sym],
          payload: payload
        )
        response = request.execute()
        deleted = true
      end
      return deleted
    end

    def bind_resource(resource_type, resource_id, bind_type, bind_type_id, bindto_key, bindto_id,
      hostname, username, password, payload = {})
      bound = false
      ns = Netscaler::Utilities.new(:hostname => hostname, :username => username,
        :password => password)

      Chef::Log.debug "Ensuring existence of #{resource_type}: #{payload[resource_id.to_sym]}"
      primary_resource_exists = ns.resource_exists?(resource_type, payload[resource_id.to_sym])

      Chef::Log.debug "Ensuring existence of #{bindto_id}: #{payload[bind_type_id.to_sym]}"
      secondary_resource_exists = ns.resource_exists?(bindto_id, payload[bind_type_id.to_sym])

      Chef::Log.debug "Checking existence of binding: #{resource_type}->\
        #{payload[resource_id.to_sym]} AND #{bindto_id}->\
      #{payload[bind_type_id.to_sym]}".split.join(" ")
      binding_exists = ns.binding_exists?(
        bind_type: bind_type,
        resource_id: payload[resource_id.to_sym],
        bind_type_id: payload[bind_type_id.to_sym]
      )

      unless !primary_resource_exists || !secondary_resource_exists || binding_exists
        Chef::Log.info "Setting binding for: #{resource_type}->\
          #{payload[resource_id.to_sym]} AND #{bindto_id}->\
        #{payload[bind_type_id.to_sym]}".split.join(" ")
        request = ns.build_request(
          method: 'put',
          resource_type: bind_type,
          resource: payload[bind_type_id.to_sym],
          binding: true,
          payload: payload
        )
        response = request.execute()
        bound = true
      end
      return bound
    end

  end
end
