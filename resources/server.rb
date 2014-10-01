#
# Cookbook Name:: netscaler 
# Resource:: server
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

actions :create, :update, :delete
default_action :create

attribute :servername, :kind_of => String, :required => true
attribute :username, :kind_of => String, :required => true
attribute :password, :kind_of => String, :required => true
attribute :hostname, :kind_of => [String, Array], :required => true
attribute :state, :kind_of => String, :required => false, :default => nil
attribute :domain, :kind_of => String, :required => false, :default => nil
attribute :ipaddress, :kind_of => String, :required => false, :default => nil
attribute :domainresolveretry, :kind_of => Integer, :required => false, :default => nil
attribute :translationip, :kind_of => String, :required => false, :default => nil
attribute :translationmask, :kind_of => String, :required => false, :default => nil
attribute :comment, :kind_of => String, :required => false, :default => nil
