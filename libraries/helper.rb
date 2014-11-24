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
      resource_exists = ns.resource_exists?(resource_type, payload[resource_id])

      if !resource_exists
        Chef::Log.info "Creating new #{resource_type}: #{payload[resource_id]}"
        request = ns.build_request(
          method: 'post',
          resource_type: resource_type,
          binding: false,
          payload: payload
        )
        response = request.execute()
        created = true
      else
        Chef::Log.info "Resource #{payload[resource_id]} already exists on the netscaler."
      end
      return created
    end

    def update_resource(resource_type, resource_id, hostname, username, password, payload = {})
      updated = false
      ns = Netscaler::Utilities.new(:hostname => hostname, :username => username,
        :password => password)
      resource_exists = ns.resource_exists?(resource_type, payload[resource_id])
      payload_edited = payload.reject { |k, v| v.nil? }

      if resource_exists
        update_required = false
        payload_edited.any? do |k, v|
          key_value_exists = ns.key_value_exists?(resource_type, payload[resource_id], k, v)
          update_required = true unless key_value_exists
        end
      end
      if update_required
        request = ns.build_request(
          method: 'put',
          resource_type: resource_type,
          resource: payload[resource_id],
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
      resource_exists = ns.resource_exists?(resource_type, payload[resource_id])

      unless !resource_exists
        request = ns.build_request(
          method: 'delete',
          resource_type: resource_type,
          resource: payload[resource_id],
          payload: payload
        )
        response = request.execute()
        deleted = true
      end
      return deleted
    end

    def bind_resource(resource_type, resource_id, bind_type, bind_type_id, bindto_key, bindto_id,
      hostname, username, password, payload = {})
      ns = Netscaler::Utilities.new(:hostname => hostname, :username => username,
        :password => password)

      unless ns.resource_exists?(resource_type, payload[resource_id])
        Chef::Log.error "#{resource_type}: #{payload[resource_id]} doesn't exists on"\
          " the netscaler!  Unable to bind it to #{bindto_id}: #{payload[bind_type_id]}!"
        return false
      end

      unless ns.resource_exists?(bindto_id, payload[bind_type_id])
        Chef::Log.error "#{bindto_id}: #{payload[bind_type_id]} doesn't exists on"\
          " the netscaler!  Unable to bind it to #{resource_type}: #{payload[resource_id]}!"
        return false
      end

      binding_exists = ns.binding_exists?(
        bind_type: bind_type,
        resource_id: payload[resource_id],
        bind_type_id: payload[bind_type_id]
      )

      unless binding_exists
        Chef::Log.info "Setting binding for: #{resource_type}->"\
          "#{payload[resource_id]} AND #{bindto_id}->#{payload[bind_type_id]}".split.join(' ')
        request = ns.build_request(
          method: 'put',
          resource_type: bind_type,
          resource: payload[bind_type_id],
          binding: true,
          payload: payload
        ).execute
        return true
      end
      return false
    end

    def save_changes(hostname, username, password, payload = {})
      saved = false
      ns = Netscaler::Utilities.new(:hostname => hostname, :username => username,
        :password => password)

        Chef::Log.info "Committing configuration changes"
        request = ns.build_request(
          method: 'post',
          resource_type: resource_type,
          binding: false,
          payload: payload
        )
        response = request.execute()
        if response == "200 OK"
          saved = true
        end
      else
        Chef::Log.info "Saving configuration failed on #{hostname}."
      end
      return saved
    end

    def logout(hostname, username, password, payload = {})
      logged_out = false
      ns = Netscaler::Utilities.new(:hostname => hostname, :username => username,
        :password => password)

      Chef::Log.info "Logging out of #{hostname}"
      request = ns.build_request(
        method: 'post',
        resource_type: resource_type,
        binding: false,
        payload: payload
      )
      response = request.execute()
      if response == "201 Created"
        logged_out = true
      else
        Chef::Log.info "Failed to log out of the netscaler #{hostname}."
      end
      return logged_out
    end

  end
end
