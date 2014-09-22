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

  it 'tries to create an existing resource' do
    response = 'StarLord'
    RestClient::Request.any_instance.stub(:execute).and_return(response)
    resource = chef_run.netscaler_server('Create StarLord')

    expect(resource.updated_by_last_action?).to be_false
  end

  it 'tries to create a missing resource' do
    response = 'Ronan'
    RestClient::Request.any_instance.stub(:execute).and_return(response)
    resource = chef_run.netscaler_server('Create StarLord')

    expect(resource.updated_by_last_action?).to be_true
  end

  it 'tries to delete an existing resource' do
    response = 'Ronan'
    RestClient::Request.any_instance.stub(:execute).and_return(response)
    resource = chef_run.netscaler_server('Delete Ronan')

    expect(resource.updated_by_last_action?).to be_true
  end

  it 'tries to delete a missing resource' do
    response = 'StarLord'
    RestClient::Request.any_instance.stub(:execute).and_return(response)
    resource = chef_run.netscaler_server('Delete Ronan')

    expect(resource.updated_by_last_action?).to be_false
  end

  it 'tries to update an existing resource' do
    response = 'Rocket'
    RestClient::Request.any_instance.stub(:execute).and_return(response)
    resource = chef_run.netscaler_server('Update Rocket')

    expect(resource.updated_by_last_action?).to be_true
  end

  it 'tries to update a missing resource' do
    response = 'Rocket'
    RestClient::Request.any_instance.stub(:execute).and_return(response)
    resource = chef_run.netscaler_server('Update Rocket')

    expect(resource.updated_by_last_action?).to be_true
  end

end
