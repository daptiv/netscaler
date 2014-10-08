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
  * :update - calls `update_resource`
  * :delete - calls `delete_resource`
  * :bind   - calls `bind_resource`
2.  Attributes in the payload should be passed in as a hash
3.  `resource_type` should be the the feature that you're manipulating (ie server, lbvserver, etc)
4.  `resource_id` should be set to the key of the resource (ie name, servicegroupname, etc)
5.  Be carefull of chef reserved words.  If you look at the `netscaler_server` resource/provider
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
    <td>resource_type, resource, value=nil</td>
    <td>Check if a resource exists</td>
  </tr>
  <tr>
    <td><tt>binding_exists?</tt></td>
    <td>bind_type, resource_id, bind_type_id</td>
    <td>Check if a binding exists</td>
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
</table>

### Examples
    # New netscaler instance
    ns = Netscaler::Utilities.new(
      :hostname => ['123.456.12.34','123.456.12.34'],
      :username => 'iamgroot',
      :password => 'iamgroot'
    )

    # Check if a StarLord server exists
    resource_exists = ns.resource_exists?('server','StarLord')

    # Check if StarLord server is UP in Guardians service group
    server_up = ns.resource_exists?(
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

Resources/Providers
===================

The idea here is that every rest call will eventually be represented with a new
resource/provider.  Below are a few examples to get you started.

netscaler_server
----------------

### Actions
- :create: Create a resource
- :update: Update an existing resource
- :delete: Delete an existing resource

### Examples
    # Create a new server called StarLord
    netscaler_server "Create StarLord" do
      servername 'StarLord'
      hostname '123.45.123.1'
      domainresolveretry 6
      username 'iamgroot'
      password 'iamgroot'
      domain 'mydomain.com'
      action :create
    end

    # Update a server called StarLord
    netscaler_server 'Update StarLord' do
      servername 'StarLord'
      hostname '123.45.123.1'
      domainresolveretry 22
      username 'iamgroot'
      password 'iamgroot'
      action :update
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
- :create: Create a resource
- :update: Update an existing resource
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

    # Bind server StarLord to service group FannyUrAunt
    netscaler_servicegroup 'Bind StarLord' do
      hostname '172.16.198.2'
      username 'iamgroot'
      password 'iamgroot'
      servicegroupname 'Guardians'
      servername 'StarLord'
      port 80
      action :bind
    end

## List of created resources/providers
* netscaler_server
* netscaler_servicegroup

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
