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

require 'mixlib/shellout'

begin
  gem 'rest-client'
rescue LoadError
  gem_exe = Chef::File.join(RbConfig::CONFIG['bindir'], 'gem').sub(/.*\s.*/m, '"\&"')
  Mixlib::ShellOut.new("#{gem_exe} install rest-client -v 1.7 --no-document").run_command
  Gem.clear_paths
end

module Netscaler
  module Helper

    def create_resource(resource_type, resource_id, hostname, username, password, payload = {})
      created = false
      ns = Netscaler::Utilities.new(:hostname => hostname, :username => username,
        :password => password)

      if !ns.resource_exists?(resource_type, payload[resource_id])
        Chef::Log.info "Creating new #{resource_type}: #{payload[resource_id]}"
        request = ns.build_request(
          method: 'post',
          resource_type: resource_type,
          binding: false,
          payload: payload
        )
        begin
          request.execute
          ns.save_config
        rescue Exception => e
          fail e.inspect
        end
        ns.logout
        created = true
      else
        created = update_resource(resource_type, resource_id, hostname, username, password, payload) 
      end

      return created
    end

    def update_resource(resource_type, resource_id, hostname, username, password, payload = {})
      updated = false
      ns = Netscaler::Utilities.new(:hostname => hostname, :username => username,
        :password => password)
      payload_edited = Netscaler::PayloadFilter.filter_uneditable_attributes(resource_type, payload)

      if ns.resource_exists?(resource_type, payload[resource_id])
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
        begin
          request.execute
          ns.save_config
        rescue Exception => e
          fail e.inspect
        end
        ns.logout
        updated = true
      end
      return updated
    end

    def delete_resource(resource_type, resource_id, hostname, username, password, payload = {})
      deleted = false
      ns = Netscaler::Utilities.new(:hostname => hostname, :username => username,
        :password => password)

      unless !ns.resource_exists?(resource_type, payload[resource_id])
        request = ns.build_request(
          method: 'delete',
          resource_type: resource_type,
          resource: payload[resource_id],
          payload: payload
        )
        request.execute
        ns.save_config
        ns.logout
        deleted = true
      end
      return deleted
    end

    def bind_resource(resource_type, resource_id, bind_type, bind_type_id, bindto_key, bindto_id,
      hostname, username, password, payload = {})
      require 'rest-client'
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

      Chef::Log.info "Setting binding for: #{resource_type}->"\
        "#{payload[resource_id]} AND #{bindto_id}->#{payload[bind_type_id]}".split.join(' ')
      request = ns.build_request(
        method: 'put', resource_type: bind_type,
        resource: payload[bind_type_id], binding: true,
        payload: payload
      )
      begin
        request.execute
      rescue ::RestClient::Conflict
        Chef::Log.info "Binding already exists. . . ."
        return false
      end
      ns.save_config
      ns.logout
      return true
    end

  end
end
