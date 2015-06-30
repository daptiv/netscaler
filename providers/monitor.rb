#
# Cookbook Name:: netscaler
# Provider:: monitor
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
    resource_type = 'lbmonitor',
    resource_id = :monitorname,
    hostname = @new_resource.hostname,
    username = @new_resource.username,
    password = @new_resource.password,
    monitorname: @new_resource.monitorname,
    type: @new_resource.type,
    interval: @new_resource.interval,
    units3: @new_resource.units3,
    resptimeout: @new_resource.resptimeout,
    resptimeoutthresh: @new_resource.resptimeoutthresh,
    units4: @new_resource.units4,
    destport: @new_resource.destport,
    downtime: @new_resource.downtime,
    units2: @new_resource.units2,
    deviation: @new_resource.deviation,
    units1: @new_resource.units1,
    retries: @new_resource.retries,
    failureretries: @new_resource.failureretries,
    alertretries: @new_resource.alertretries,
    successretries: @new_resource.successretries,
    lrtm: @new_resource.lrtm,
    send: @new_resource.sendx,
    recv: @new_resource.recv,
    reverse: @new_resource.reverse,
    transparent: @new_resource.transparent,
    iptunnel: @new_resource.iptunnel,
    tos: @new_resource.tos,
    secure: @new_resource.secure,
    validatecred: @new_resource.validatecred,
    radnasip: @new_resource.radnasip,
    radaccounttype: @new_resource.radaccounttype,
    radframedip: @new_resource.radframedip,
    lrtmconf: @new_resource.lrtmconf,
    lrtmconfstr: @new_resource.lrtmconfstr,
    dynamicresponsetimeout: @new_resource.dynamicresponsetimeout,
    dynamicinterval: @new_resource.dynamicinterval,
    dispatcherip: @new_resource.dispatcherip,
    dispatcherport: @new_resource.dispatcherport,
    simpethod: @new_resource.simpethod,
    maxforwards: @new_resource.maxforwards,
    snmpversion: @new_resource.snmpversion,
    multimetrictable: @new_resource.multimetrictable,
    storefrontacctservice: @new_resource.storefrontacctservice,
    vendorid: @new_resource.vendorid,
    firmwarerevision: @new_resource.firmwarerevision,
    inbandsecurityid: @new_resource.inbandsecurityid,
    dup_state: @new_resource.dup_state,
    storeedb: @new_resource.storeedb
  )
  new_resource.updated_by_last_action(c)
end

# Delete action unsupported atm
# Requires url that doesn't fit with delete_resource logic
# ex: http://<netscaler_ip>/nitro/v1/config/lbmonitor?args=monitorname:<name>,type:<type>

#action :delete do
  #d = delete_resource(
    #resource_type = 'lbmonitor',
    #resource_id = :monitorname,
    #hostname = @new_resource.hostname,
    #username = @new_resource.username,
    #password = @new_resource.password,
    #monitorname: @new_resource.monitorname
  #)
  #new_resource.updated_by_last_action(d)
#end

action :bind do
  b = bind_resource(
    resource_type = 'lbmonitor',
    resource_id = :monitorname,
    bind_type = 'lbmonitor_servicegroup_binding',
    bind_type_id = :servicegroupname,
    bindto_key = 'name',
    bindto_id = 'servicegroup',
    hostname = @new_resource.hostname,
    username = @new_resource.username,
    password = @new_resource.password,
    monitorname: @new_resource.monitorname,
    servicegroupname: @new_resource.servicegroupname
  )
  new_resource.updated_by_last_action(b)
end

