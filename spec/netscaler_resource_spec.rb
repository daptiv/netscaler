include Netscaler::Helper

describe 'netscaler_resource' do

  let(:cookbook_paths) do
    [
      File.expand_path("#{File.dirname(__FILE__)}/../../"),
      File.expand_path("#{File.dirname(__FILE__)}/")
    ]
  end

  let(:runner) do
    ChefSpec::ServerRunner.new(
      :cookbook_path => cookbook_paths,
      :step_into => ['netscaler_server']
    )
  end

  let(:node) { runner.node }

  let(:chef_run) { runner.converge('fixtures::netscaler_resource') }

  before :all do
    @ns = Netscaler::Utilities.new(
      :username=>'user',
      :password=>'pass',
      :hostname=>'host')
    @primary_hostname = '123.45.67.890'
  end

  describe '#new' do
    it 'takes a hash and returns a Netscaler::Utilities object' do
      expect(@ns).to be_an_instance_of Netscaler::Utilities
    end
  end

  describe '#hostname' do
    it 'returns the correct hostname' do
      expect(@ns.hostname).to eql 'host'
    end
  end

  describe '#username' do
    it 'returns the correct username' do
      expect(@ns.username).to eql 'user'
    end
  end

  describe '#password' do
    it 'returns the correct password' do
      expect(@ns.password).to eql 'pass'
    end
  end

  describe '#find_primary' do
    it 'responds to the find_primary method' do
      expect(@ns).to respond_to(:find_primary)
    end
    xit 'returns the primary hostname' do
    end
    xit 'errors if no primary found' do
    end
  end

  describe '#resource_exists?' do
    it 'responds to resource_exists?' do
      expect(@ns).to respond_to(:resource_exists?)
    end
    xit 'confirms a resource exists' do
    end
    xit 'determines a resource does not exist' do
    end
  end

  describe '#build_url' do
    before do
      @method = 'post'
      payload = {}
      @base_url = 'http://123.45.67.890/nitro/v1/config'
    end

    context 'when the method is called' do
      it 'responds to build_url' do
        expect(@ns).to respond_to(:build_url)
      end
      it 'returns a string' do
        expect(@ns.build_url(1,2,3,4,5,6)).to be_a(String)
      end
    end

    context 'when save_config calls it' do
      it 'returns the correct url' do
        expect(@ns.build_url(
          @method,
          @primary_hostname,
          'nsconfig',
          'server',
          'StarLord',
          'false'
        )).to include(
          "#{@base_url}/nsconfig?action=save"
        )
      end
    end

    context 'when binding is true' do
      it 'returns the correct url with get method' do
        expect(@ns.build_url(
          'get',
          @primary_hostname,
          'servicegroup_servicegroupmember_binding',
          'StarLord',
          'Guardians',
          'true'
        )).to include(
          "#{@base_url}/servicegroup_servicegroupmember_binding/StarLord/Guardians"
        )
      end
      it 'retruns the correct url with put method' do
        expect(@ns.build_url(
          'put',
          @primary_hostname,
          'servicegroup_servicegroupmember_binding',
          'StarLord',
          'Guardians',
          'true'
        )).to include(
          "#{@base_url}/servicegroup_servicegroupmember_binding/StarLord?action=bind"
        )
      end
    end
  end

  describe '#build_request' do
    it 'responds to build_request' do
      expect(@ns).to respond_to(:build_request)
    end
    xit 'returns a string' do
    end
  end

  describe '#create_resource' do
    it 'responds to create_resource' do
      expect(Netscaler::Helper).to respond_to(:create_resource)
    end
    xit 'creates a resource' do
    end
  end

  describe '#update_resource' do
    it 'responds to update_resource' do
      expect(Netscaler::Helper).to respond_to(:update_resource)
    end
    xit 'updates a resource' do
    end
  end

  describe '#delete_resource' do
    xit 'responds to delete_resource' do
      expect(Netscaler::Helper).to respond_to(:delete_resource)
    end
    xit 'deletes a resource' do
    end
  end

  describe '#bind_resource' do
    it 'responds to bind_resource' do
      expect(Netscaler::Helper).to respond_to(:bind_resource)
    end
    xit 'binds a resource' do
    end
  end

end
