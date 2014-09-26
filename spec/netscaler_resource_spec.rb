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

  describe '#check_if_resource_exists' do
    it 'responds to check_if_resource_exists' do
      @netscaler.should respond_to(:check_if_resource_exists)
    end
    xit 'confirms a resource exists' do
    end
    xit 'determines a resource does not exist' do
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
    xit 'deletes a resource' do
    end
  end

  describe '#update_resource' do
    xit 'updates a resource' do
    end
  end

  describe '#delete_resource' do
    xit 'deletes a resource' do
    end
  end

end
