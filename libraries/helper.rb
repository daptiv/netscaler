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

    def create_resource(resource_type, resource_id, hostname, username, password, options = {})
      created = false
      ns = Netscaler::Utilities.new(:hostname => hostname, :username => username,
        :password => password)
      resource_exists = ns.check_if_resource_exists(resource_type, options[:"#{resource_id}"])

      if resource_exists == false
        Chef::Log.info "Creating new #{resource_type}: #{options[:"#{resource_id}"]}"
        request = ns.build_request('post', resource_type, nil, options)
        response = request.execute()
        created = true
      else
        Chef::Log.info "Resource #{options[:"#{resource_id}"]} already exists on the netscaler."
      end
      return created
    end

    def update_resource(resource_type, resource_id, hostname, username, password, options = {})
      updated = false
      ns = Netscaler::Utilities.new(:hostname => hostname, :username => username,
        :password => password)
      resource_exists = ns.check_if_resource_exists(resource_type, options[:"#{resource_id}"])
      options_edited = options.reject { |k, v| v.nil? }

      unless resource_exists == false
        update_required = false
        options_edited.each do |r|
          key_value_exists = ns.check_if_resource_exists(resource_type, r[0].to_s, r[1])
          update_required = true unless key_value_exists == true
        end
      end
      if update_required == true
        request = ns.build_request('put', resource_type, options[:"#{resource_id}"], options_edited)
        response = request.execute()
        updated = true
      end
      return updated
    end

    def delete_resource(resource_type, resource_id, hostname, username, password, options = {})
      deleted = false
      ns = Netscaler::Utilities.new(:hostname => hostname, :username => username,
        :password => password)
      resource_exists = ns.check_if_resource_exists(resource_type, options[:"#{resource_id}"])

      unless resource_exists == false
        request = ns.build_request('delete', resource_type, options[:"#{resource_id}"], options)
        response = request.execute()
        deleted = true
      end
      return deleted
    end

  end
end
