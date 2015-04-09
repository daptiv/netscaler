#
# Cookbook Name:: netscaler 
# Resource:: lbvserver
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

attribute :lbvservername, :kind_of => String, :required => true
attribute :hostname, :kind_of => [String, Array], :required => true
attribute :username, :kind_of => String, :required => true
attribute :password, :kind_of => String, :required => true
attribute :ipaddress, :kind_of => String, :required => false, :default => nil
attribute :port, :kind_of => Integer, :required => false, :default => 80
attribute :servicetype, :kind_of => String, :required => false, :default => 'HTTP'
attribute :servicegroupname, :kind_of => String, :required => false, :default => nil
attribute :type, :kind_of => String, :required => false, :default => nil
attribute :lbmethod, :kind_of => String, :required => false, :default => 'LEASTCONNECTION'
attribute :comment, :kind_of => String, :required => false, :default => nil
