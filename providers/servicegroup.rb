#
# Cookbook Name:: netscaler
# Provider:: servicegroup
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
    resource_type = 'servicegroup',
    resource_id = :servicegroupname,
    hostname = @new_resource.hostname,
    username = @new_resource.username,
    password = @new_resource.password,
    servicegroupname: @new_resource.servicegroupname,
    state: @new_resource.state,
    cip: @new_resource.cip,
    cipheader: @new_resource.cipheader,
    servicetype: @new_resource.servicetype,
    cacheable: @new_resource.cacheable,
    td: @new_resource.td,
    cachetype: @new_resource.cachetype,
    autoscale: @new_resource.autoscale,
    monstate: @new_resource.monstate,
    monthreshold: @new_resource.monthreshold,
    healthmonitor: @new_resource.healthmonitor,
    appflowlog: @new_resource.appflowlog,
    comment: @new_resource.comment
  )
  new_resource.updated_by_last_action(c)
end

action :delete do
  d = delete_resource(
    resource_type = 'servicegroup',
    resource_id = :servicegroupname,
    hostname = @new_resource.hostname,
    username = @new_resource.username,
    password = @new_resource.password,
    servicegroupname: @new_resource.servicegroupname
  )
  new_resource.updated_by_last_action(d)
end

action :bind do
  b = bind_resource(
    resource_type = 'servicegroup',
    resource_id = :servicegroupname,
    bind_type = 'servicegroup_servicegroupmember_binding',
    bind_type_id = :servername,
    bindto_key = 'name',
    bindto_id = 'server',
    hostname = @new_resource.hostname,
    username = @new_resource.username,
    password = @new_resource.password,
    servicegroupname: @new_resource.servicegroupname,
    servername: @new_resource.servername,
    port: @new_resource.port,
    weight: @new_resource.weight,
    customserverid: @new_resource.customserverid,
    hashid: @new_resource.hashid
  )
  new_resource.updated_by_last_action(b)
end
