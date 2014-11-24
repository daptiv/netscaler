if defined?(ChefSpec)
  ChefSpec::Runner.define_runner_method :netscaler_server
  ChefSpec::Runner.define_runner_method :netscaler_servicegroup
  ChefSpec::Runner.define_runner_method :netscaler_nsconfig
  ChefSpec::Runner.define_runner_method :netscaler_logout

  def create_netscaler_server(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:netscaler_server, :create, resource_name)
  end

  def update_netscaler_server(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:netscaler_server, :update, resource_name)
  end

  def delete_netscaler_server(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:netscaler_server, :delete, resource_name)
  end

  def create_netscaler_servicegroup(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:netscaler_servicegroup, :create, resource_name)
  end

  def update_netscaler_servicegroup(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:netscaler_servicegroup, :update, resource_name)
  end

  def delete_netscaler_servicegroup(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:netscaler_servicegroup, :delete, resource_name)
  end

  def bind_netscaler_servicegroup(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:netscaler_servicegroup, :bind, resource_name)
  end

  def bind_netscaler_servicegroup(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:netscaler_nsconfig, :save, resource_name)
  end

  def bind_netscaler_servicegroup(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:netscaler_logout, :logout, resource_name)
  end
end
