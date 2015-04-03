#
# Cookbook Name:: netscaler
# Resource:: monitor
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

actions :create, :update, :bind
default_action :create

attribute :monitorname, :kind_of => String, :required => true
attribute :username, :kind_of => String, :required => true
attribute :password, :kind_of => String, :required => true
attribute :hostname, :kind_of => [String, Array], :required => true
attribute :type, :kind_of => String, :required => false, :default => nil
attribute :servicegroupname, :kind_of => String, :required => false, :default => nil
attribute :interval, :kind_of => Integer, :required => false, :default => nil
attribute :units3, :kind_of => String, :required => false, :default => nil
attribute :resptimeout, :kind_of => Integer, :required => false, :default => nil
attribute :resptimeoutthresh, :kind_of => String, :required => false, :default => nil
attribute :units4, :kind_of => String, :required => false, :default => nil
attribute :destport, :kind_of => Integer, :required => false, :default => nil
attribute :downtime, :kind_of => Integer, :required => false, :default => nil
attribute :units2, :kind_of => String, :required => false, :default => nil
attribute :deviation, :kind_of => String, :required => false, :default => nil
attribute :units1, :kind_of => String, :required => false, :default => nil
attribute :retriesx, :kind_of => Integer, :required => false, :default => nil
attribute :failureretries, :kind_of => Integer, :required => false, :default => nil
attribute :alertretries, :kind_of => Integer, :required => false, :default => nil
attribute :successretries, :kind_of => Integer, :required => false, :default => nil
attribute :lrtm, :kind_of => String, :required => false, :default => nil
attribute :sendx, :kind_of => String, :required => false, :default => nil
attribute :recv, :kind_of => String, :required => false, :default => nil
attribute :state, :kind_of => String, :required => false, :default => nil
attribute :reverse, :kind_of => String, :required => false, :default => nil
attribute :transparent, :kind_of => String, :required => false, :default => nil
attribute :iptunnel, :kind_of => String, :required => false, :default => nil
attribute :tos, :kind_of => String, :required => false, :default => nil
attribute :secure, :kind_of => String, :required => false, :default => nil
attribute :validatecred, :kind_of => String, :required => false, :default => nil
attribute :radnasip, :kind_of => String, :required => false, :default => nil
attribute :radaccounttype, :kind_of => String, :required => false, :default => nil
attribute :radframedip, :kind_of => String, :required => false, :default => nil
attribute :lrtmconf, :kind_of => String, :required => false, :default => nil
attribute :lrtmconfstr, :kind_of => String, :required => false, :default => nil
attribute :dynamicresponsetimeout, :kind_of => String, :required => false, :default => nil
attribute :dynamicinterval, :kind_of => String, :required => false, :default => nil
attribute :dispatcherip, :kind_of => String, :required => false, :default => nil
attribute :dispatcherport, :kind_of => String, :required => false, :default => nil
attribute :simpethod, :kind_of => String, :required => false, :default => nil
attribute :maxforwards, :kind_of => String, :required => false, :default => nil
attribute :snmpversion, :kind_of => String, :required => false, :default => nil
attribute :multimetrictable, :kind_of => String, :required => false, :default => nil
attribute :storefrontacctservice, :kind_of => String, :required => false, :default => nil
attribute :vendorid, :kind_of => String, :required => false, :default => nil
attribute :firmwarerevision, :kind_of => String, :required => false, :default => nil
attribute :inbandsecurityid, :kind_of => String, :required => false, :default => nil
attribute :dup_state, :kind_of => String, :required => false, :default => nil
attribute :storeedb, :kind_of => String, :required => false, :default => nil
