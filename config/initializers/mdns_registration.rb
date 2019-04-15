# require 'dnssd'
# require 'securerandom'
Rails.logger.info 'Forking MDNS Daemon'
Spawnling.new(method: :fork, kill: true, argv: 'phobrary_mdns_daemon') do
  Rails.logger.info 'Forked'
  hostname = Socket.gethostname
  name = "Phobrary Server - #{hostname}"
  type = '_phobrary._tcp'
  domain = nil
  port = Rails::Server::Options.new.parse!(ARGV)[:Port]
  register = DNSSD::Service.register(name, type, domain, port)
  Rails.logger.info 'Registration done, entering loop'

  # Loop required to keep DNSSD::Service running and responding to queries
  loop { sleep 200 }
end
