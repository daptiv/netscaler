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

| Name | Vars | Description |
|------|------|-------------|
| create_resource | resource_type, resource_id, hostname, username, password, payload = {} | Make a post call to the netscaler |
| update_resource | resource_type, resource_id, hostname, username, password, payload = {} | Make a put call to the netscaler |
| delete_resource | resource_type, resource_id, hostname, username, password, payload = {} | Make a delete call to the netscaler |

Library Classes
===============

Netscaler::Utilites
-----------------
A utility class used by Netscaler::Helper

### Methods

| Name | Vars | Description |
|------|------|-------------|
| resource_exists? | resource_type, resource | Check if a resource exists |
| key_value_exists? | resource_type, resource, key, value | Check if a key/value exists |
| build_request | method, resource_type, resource, options | Create the rest call |
| build_url | method, primary_hostname, resource_type, resource, resource_id, binding | Create the url used for the rest call |
| find_primary | method, resource_type, resource, resource_id, binding, payload | Given an array of options, find the primary Netscaler |
| save_config | | Save the netscaler configuration |
| logout | | Log out of the netscaler |

Netscaler::PayloadFilter
-----------------
Filters out key/value params not allowed in the payload for updates.

### Methods

| Name | Vars | Description |
|------|------|-------------|
| filter_uneditable_attributes | resource_type, payload | remove attributes that can not be updated. |

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

Author:: Changepoint Engineering (cpc_sea_teamengineering@changepoint.com) 
