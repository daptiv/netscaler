if defined?(ChefSpec)
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

  def create_netscaler_monitor(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:netscaler_monitor, :create, resource_name)
  end

  def update_netscaler_monitor(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:netscaler_monitor, :update, resource_name)
  end

  def bind_netscaler_monitor(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:netscaler_monitor, :bind, resource_name)
  end
end
