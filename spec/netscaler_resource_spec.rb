include Netscaler::Helper

describe 'netscaler_resource' do

  let(:cookbook_paths) do
    [
      File.expand_path("#{File.dirname(__FILE__)}/../../"),
      File.expand_path("#{File.dirname(__FILE__)}/")
    ]
  end

  let(:runner) do
    ChefSpec::Runner.new(
      :cookbook_path => cookbook_paths,
      :step_into => ['netscaler_server']
    )
  end

  let(:node) { runner.node }

  let(:chef_run) { runner.converge('fixtures::netscaler_resource') }

  before :all do
    @netscaler = Netscaler::Utilities.new(
      :username=>'user',
      :password=>'pass',
      :hostname=>'host')
  end

  describe '#new' do
    it 'takes a hash and returns a Netscaler::Utilities object' do
      @netscaler.should be_an_instance_of Netscaler::Utilities
    end
  end

  describe '#hostname' do
    it 'returns the correct hostname' do
      @netscaler.hostname.should eql 'host'
    end
  end

  describe '#username' do
    it 'returns the correct username' do
      @netscaler.username.should eql 'user'
    end
  end

  describe '#password' do
    it 'returns the correct password' do
      @netscaler.password.should eql 'pass'
    end
  end

  describe '#find_primary' do
    it 'responds to the find_primary method' do
      @netscaler.should respond_to(:find_primary)
    end
    xit 'returns the primary hostname' do
    end
    xit 'errors if no primary found' do
    end
  end

  describe '#resource_exists?' do
    it 'responds to resource_exists?' do
      @netscaler.should respond_to(:resource_exists?)
    end
    xit 'confirms a resource exists' do
    end
    xit 'determines a resource does not exist' do
    end
  end

  describe '#binding_exists?' do
    it 'responds to binding_exists?' do
      @netscaler.should respond_to(:binding_exists?)
    end
    xit 'confirms a resource exists' do
    end
    xit 'determines a resource does not exist' do
    end
  end

  describe '#build_url' do
    it 'responds to build_url' do
      @netscaler.should respond_to(:build_url)
    end
  end

  describe '#build_request' do
    it 'responds to build_request' do
      @netscaler.should respond_to(:build_request)
    end
    xit 'returns a string' do
    end
  end

  describe '#create_resource' do
    it 'responds to create_resource' do
      Netscaler::Helper.should respond_to(:create_resource)
    end
    xit 'creates a resource' do
    end
  end

  describe '#update_resource' do
    it 'responds to update_resource' do
      Netscaler::Helper.should respond_to(:update_resource)
    end
    xit 'updates a resource' do
    end
  end

  describe '#delete_resource' do
    xit 'responds to delete_resource' do
      Netscaler::Helper.should respond_to(:delete_resource)
    end
    xit 'deletes a resource' do
    end
  end

  describe '#bind_resource' do
    it 'responds to bind_resource' do
      Netscaler::Helper.should respond_to(:bind_resource)
    end
    xit 'binds a resource' do
    end
  end

end
