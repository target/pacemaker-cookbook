if defined?(ChefSpec)
  ChefSpec.define_matcher :pacemaker_group
  ChefSpec.define_matcher :pacemaker_orderset
  ChefSpec.define_matcher :pacemaker_primitive
  ChefSpec.define_matcher :pacemaker_stonith

  def create_pacemaker_group(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pacemaker_group, :create, resource_name)
  end

  def delete_pacemaker_group(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pacemaker_group, :delete, resource_name)
  end

  def start_pacemaker_group(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pacemaker_group, :start, resource_name)
  end

  def stop_pacemaker_group(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pacemaker_group, :stop, resource_name)
  end

  def create_pacemaker_orderset(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pacemaker_orderset, :create, resource_name)
  end

  def delete_pacemaker_orderset(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pacemaker_orderset, :delete, resource_name)
  end

  def create_pacemaker_primitive(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pacemaker_primitive, :create, resource_name)
  end

  def delete_pacemaker_primitive(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pacemaker_primitive, :delete, resource_name)
  end

  def start_pacemaker_primitive(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pacemaker_primitive, :start, resource_name)
  end

  def stop_pacemaker_primitive(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pacemaker_primitive, :stop, resource_name)
  end

  def create_pacemaker_stonith(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pacemaker_stonith, :create, resource_name)
  end

  def delete_pacemaker_stonith(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pacemaker_stonith, :delete, resource_name)
  end

  def start_pacemaker_stonith(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pacemaker_stonith, :start, resource_name)
  end

  def stop_pacemaker_stonith(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:pacemaker_stonith, :stop, resource_name)
  end
end
