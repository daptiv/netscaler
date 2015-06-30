[![Build Status](https://secure.travis-ci.org/daptiv/netscaler.png)](http://travis-ci.org/daptiv/netscaler)

# netscaler cookbook

A collection of resources for managing Citrix NetScaler (Nitro API).

This has been written so that adding a missing NetScaler resource *should* be easy.

Creating a new resource

1.  All resources should have required attributes: hostname, username, password, and the resource name
2.  All other attributes (payload for rest call) should default to nil.
  1. Use http://\<netscaler_ip\>/nitro/v1/config/<resource_name> to see available payload options.

Creating a new provider

1.  Actions supported: 
  * :create - calls `create_resource`
  * :delete - calls `delete_resource`
  * :bind   - calls `bind_resource`
2.  Attributes in the payload should be passed in as a hash
3.  Add new row in payload_filter.rb for @@attribute_list_by_resource.  The array should contain keys from the payload that can not be updated via the Nitro Api.
4.  `resource_type` should be the the feature that you're manipulating (ie server, lbvserver, etc)
5.  `resource_id` should be set to the key of the resource (ie name, servicegroupname, etc)
6.  Be carefull of chef reserved words.  If you look at the `netscaler_server` resource/provider
you'll see I use the payload key as my attribute names for everthing except for `servername` which
doesn't exist as a key for the `server` resource type.  The key in the options hash is still 'name'
though.  The options hash key has to match the netscaler payload key.

## Supported Platforms

* Any supported by chef

Library Methods
===============

Netscaler::Helper
-----------------
A collection of methods for CRUD operations on NetScaler

### Methods

<table>
  <tr>
    <th>Name</th>
    <th>Vars</th>
    <th>Description</th>
  </tr>
  <tr>
    <td><tt>create_resource</tt></td>
    <td>resource_type, resource_id, hostname, username, password, payload = {}</td>
    <td>Make a post call to the netscaler</td>
  </tr>
  <tr>
    <td><tt>update_resource</tt></td>
    <td>resource_type, resource_id, hostname, username, password, payload = {}</td>
    <td>Make a put call to the netscaler</td>
  </tr>
  <tr>
    <td><tt>delete_resource</tt></td>
    <td>resource_type, resource_id, hostname, username, password, payload = {}</td>
    <td>Make a delete call to the netscaler</td>
  </tr>
</table>

Library Classes
===============

Netscaler::Utilites
-----------------
A utility class used by Netscaler::Helper

### Methods

<table>
  <tr>
    <th>Name</th>
    <th>Vars</th>
    <th>Description</th>
  </tr>
  <tr>
    <td><tt>resource_exists?</tt></td>
    <td>resource_type, resource</td>
    <td>Check if a resource exists</td>
  </tr>
  <tr>
    <td><tt>key_value_exists?</tt></td>
    <td>resource_type, resource, key, value</td>
    <td>Check if a key/value exists</td>
  </tr>
  <tr>
    <td><tt>build_request</tt></td>
    <td>method, resource_type, resource, options</td>
    <td>Create the rest call</td>
  </tr>
  <tr>
    <td><tt>build_url</tt></td>
    <td>method, primary_hostname, resource_type, resource, resource_id, binding</td>
    <td>Create the url used for the rest call</td>
  </tr>
  <tr>
    <td><tt>find_primary</tt></td>
    <td>method, resource_type, resource, resource_id, binding, payload</tc>
    <td>Given an array of options, find the primary Netscaler</td>
  </tr>
  <tr>
    <td><tt>save_config</tt></td>
    <td></tc>
    <td>Save the netscaler configuration</td>
  </tr>
  <tr>
    <td><tt>logout</tt></td>
    <td></tc>
    <td>Log out of the netscaler</td>
  </tr>
</table>

Netscaler::PayloadFilter
-----------------
Filters out key/value params not allowed in the payload for updates.

### Methods

<table>
  <tr>
    <th>Name</th>
    <th>Vars</th>
    <th>Description</th>
  </tr>
  <tr>
    <td><tt>filter_uneditable_attributes</tt></td>
    <td>resource_type, payload</td>
    <td>remove attributes that can not be updated.</td>
  </tr>
</table>

### Examples
    # New netscaler instance
    netscalers = search(:node, "role:netscaler AND chef_environment:#{node.chef_environment}"
    netscaler_ips = netscalers.map { |n| n['ipaddress'] }
    ns = Netscaler::Utilities.new(
      :hostname => netscaler_ips,
      :username => 'iamgroot',
      :password => 'iamgroot'
    )

    # Check if a StarLord server exists
    resource_exists = ns.resource_exists?('server','StarLord')

    # Check if server StarLord exists
    server_exists = ns.resource_exists?('server','StarLord')

    # Check if StarLord server is UP in Guardians service group
    server_up = ns.key_value_exists?(
      'server_servicegroup_binding',
      'StarLord',
      'svrstate',
      'UP'
    )

    # GET request for server StarLord
    request = ns.build_request('get', 'server', 'StarLord')
    response = request.execute

    # Build the rest request to get StarLord server info
    url = ns.build_url('get', '123.456.12.34', 'server', 'StarLord')

    # Find the primary netscaler given an array
    primary = ns.find_primary

    # Save the configuration file
    ns.save_config

    # Logout of the netscaler
    ns.logout

Resources/Providers
===================

The idea here is that every rest call will eventually be represented with a new
resource/provider.  Below are a few examples to get you started.

netscaler_server
----------------

### Actions
- :create: Create a resource, updates if necessary
- :delete: Delete an existing resource

### Examples
    # Create a new server called StarLord, update if necessary
    netscaler_server "Create StarLord" do
      servername 'StarLord'
      hostname '123.45.123.1'
      domainresolveretry 6
      username 'iamgroot'
      password 'iamgroot'
      domain 'mydomain.com'
      action :create
    end

    # Delete a server called StarLord
    netscaler_server 'Delete StarLord' do
      servername 'StarLord'
      hostname '123.45.123.1'
      username 'iamgroot'
      password 'iamgroot'
      action :delete
    end

netscaler_servicegroup
----------------------

### Actions
- :create: Create a resource, updates if necessary
- :delete: Delete an existing resource
- :bind: Bind one resource to another

### Examples
    # Create a service group called Guardians
    netscaler_servicegroup 'Create Guardians' do
      servicegroupname 'Guardians'
      servicetype 'HTTP'
      comment 'Something good, something bad'
      hostname '123.45.123.1'
      username 'iamgroot'
      password 'iamgroot'
      action :create
    end

    # Bind server StarLord to service group Guardians
    netscaler_servicegroup 'Bind StarLord to Guardians' do
      hostname '172.16.198.2'
      username 'iamgroot'
      password 'iamgroot'
      servicegroupname 'Guardians'
      servername 'StarLord'
      port 80
      action :bind
    end

netscaler_monitor
----------------------

### Actions
- :create: Create a resource, updates if necessary
- :bind: Bind one resource to another

### Examples
    # Create a monitor called Xandar
    netscaler_monitor 'Create Xandar' do
      monitorname 'Xandar'
      type 'PING'
      hostname '123.45.123.1'
      username 'iamgroot'
      password 'iamgroot'
      action :create
    end

    # Bind monitor Xandar to service group Guardians
    netscaler_monitor 'Bind Xandar to Guardians' do
      hostname '172.16.198.2'
      username 'iamgroot'
      password 'iamgroot'
      monitorname 'Xandar'
      servicegroupname 'Guardians'
      action :bind
    end

netscaler_lbvserver
----------------------

### Actions
- :create: Create a resource, updates if necessary
- :delete: Delete an existing resource
- :bind: Bind one resource to another

### Examples
    # Create a lb vserver called Kyln
    netscaler_lbvserver 'Create Kyln' do
      lbvservername 'Kyln'
      ipaddress '123.45.123.100'
      port 80
      servicetype 'HTTP' 
      hostname '123.45.123.1'
      username 'iamgroot'
      password 'iamgroot'
      action :create
    end

    # Bind service group Guardians to lb vserver Kyln
    netscaler_lbvserver 'Bind Guardians to Kyln' do
      lbvservername 'Kyln'
      servicegroupname 'Guardians'
      hostname '123.45.123.1'
      username 'iamgroot'
      password 'iamgroot'
      action :bind
    end

## List of created resources/providers
* netscaler_server
* netscaler_servicegroup
* netscaler_monitor
* netscaler_lbvserver

## TO DO

* More/better testing
* Add more resource/providers

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (i.e. `add-new-recipe`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request

## License and Authors

Author:: Daptiv Engineering (dl_teamengineering@daptiv.com)
