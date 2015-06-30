#
# Cookbook Name:: netscaler
# Provider:: lbvserver
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

include Netscaler::Helper

action :create do
  c = create_resource(
    resource_type = 'lbvserver',
    resource_id = :name,
    hostname = @new_resource.hostname,
    username = @new_resource.username,
    password = @new_resource.password,
    name: @new_resource.lbvservername,
    ipv46: @new_resource.ipaddress,
    port: @new_resource.port,
    servicetype: @new_resource.servicetype,
    type: @new_resource.type,
    lbmethod: @new_resource.lbmethod,
    comment: @new_resource.comment
  )
  new_resource.updated_by_last_action(c)
end

action :delete do
  d = delete_resource(
    resource_type = 'lbvserver',
    resource_id = :name,
    hostname = @new_resource.hostname,
    username = @new_resource.username,
    password = @new_resource.password,
    name: @new_resource.lbvservername
  )
  new_resource.updated_by_last_action(d)
end

action :bind do
  b = bind_resource(
    resource_type = 'lbvserver',
    resource_id = :name,
    bind_type = 'lbvserver_servicegroup_binding',
    bind_type_id = :servicegroupname,
    bindto_key = 'name',
    bindto_id = 'servicegroup',
    hostname = @new_resource.hostname,
    username = @new_resource.username,
    password = @new_resource.password,
    name: @new_resource.lbvservername,
    servicegroupname: @new_resource.servicegroupname
  )
  new_resource.updated_by_last_action(b)
end
