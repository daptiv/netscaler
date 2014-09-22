[![Build Status](https://secure.travis-ci.org/daptiv/netscaler.png)](http://travis-ci.org/daptiv/netscaler)

# netscaler cookbook

A collection of resources for managing Citrix NetScaler (Nitro API).

The Netscaler::Helper libary has been written in such a way as to allow each method to be
called on it's own.  It's also been written so that adding a missing NetScaler resource
*should* be easy.

Creating a new resource

1.  All resources should have required attributes: hostname, username, password, and the resource name
2.  All other attributes should default to nil.

Creating a new provider

1.  Actions supported: 
  * :create - calls `create_resource`
  * :update - calls `update_resource`
  * :delete - calls `delete_resource`
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
    <td><tt>check_if_resource_exists</tt></td>
    <td>hostname, username, password, resource_type, resource, value=nil</td>
    <td>Make a get call to the netscaler</td>
  </tr>
  <tr>
    <td><tt>create_resource</tt></td>
    <td>resource_type, resource_id, hostname, username, password, options = {}</td>
    <td>Make a post call to the netscaler</td>
  </tr>
  <tr>
    <td><tt>update_resource</tt></td>
    <td>resource_type, resource_id, hostname, username, password, options = {}</td>
    <td>Make a put call to the netscaler</td>
  </tr>
  <tr>
    <td><tt>delete_resource</tt></td>
    <td>resource_type, resource_id, hostname, username, password, options = {}</td>
    <td>Make a delete call to the netscaler</td>
  </tr>
  <tr>
    <td><tt>build_request</tt></td>
    <td>hostname, username, password, method, resource_type, resource=nil, options = {}</td>
    <td>Create the rest call for the netscaler</td>
  </tr>
</table>

Resources/Providers
===================

The idea here is that every rest call will eventually be represented with a new
resource/provider.  There will be far too many to make examples for each so you'll
need to examine each one's resource file to see what is accepted.  Below are a few
examples to get you started though.

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
      username 'nsroot'
      password 'nsroot'
      domain 'mydomain.com'
      action :create
    end

    # Update a server called StarLord
    netscaler_server 'Update StarLord' do
      servername 'StarLord'
      hostname '123.45.123.1'
      domainresolveretry 22
      username 'nsroot'
      password 'nsroot'
      action :update
    end

    # Delete a server called StarLord
    netscaler_server 'Delete StarLord' do
      servername 'StarLord'
      hostname '123.45.123.1'
      username 'nsroot'
      password 'nsroot'
      action :delete
    end

## List of created resources/providers
* netscaler_server
* netscaler_servicegroup

## TO DO

* More/better testing (maybe build_request should be it's own class?)
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
