netscaler_server 'Create StarLord' do
  servername 'StarLord'
  hostname 'guardian'
  domainresolveretry 13
  username 'Iam'
  password 'Groot'
  domain 'ofthegalaxy.com'
  action :create
end

netscaler_server 'Delete Ronan' do
  servername 'Ronan'
  hostname 'theaccuser'
  username 'evil'
  password 'badguy'
  action :delete
end

netscaler_server 'Update Rocket' do
  servername 'Rocket'
  hostname 'Groot'
  username 'OhYeah'
  password 'WeAreGroot'
  domainresolveretry 99
  action :update
end
