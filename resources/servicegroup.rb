#
# Cookbook Name:: netscaler
# Resource:: servicegroup
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

actions :create, :update, :delete, :bind
default_action :create

attribute :servicegroupname, :kind_of => String, :required => true
attribute :username, :kind_of => String, :required => true
attribute :password, :kind_of => String, :required => true
attribute :hostname, :kind_of => [String, Array], :required => true
attribute :servicetype, :kind_of => String, :required => false, :default => nil
attribute :cacheable, :kind_of => String, :required => false, :default => nil
attribute :state, :kind_of => String, :required => false, :default => nil
attribute :td, :kind_of => String, :required => false, :default => nil
attribute :cachetype, :kind_of => String, :required => false, :default => nil
attribute :autoscale, :kind_of => String, :required => false, :default => nil
attribute :monstate, :kind_of => String, :required => false, :default => nil
attribute :healthmonitor, :kind_of => String, :required => false, :default => nil
attribute :appflowlog, :kind_of => String, :required => false, :default => nil
attribute :comment, :kind_of => String, :required => false, :default => nil
attribute :servername, :kind_of => String, :required => false, :default => nil
attribute :port, :kind_of => Integer, :required => false, :default => nil
attribute :weight, :kind_of => String, :required => false, :default => nil
attribute :customserverid, :kind_of => String, :required => false, :default => nil
attribute :hashid, :kind_of => String, :required => false, :default => nil
attribute :cip, :kind_of => String, :required => false, :default => nil
attribute :cipheader, :kind_of => String, :required => false, :default => nil
attribute :monthreshold, :kind_of => String, :required => false, :default => nil
