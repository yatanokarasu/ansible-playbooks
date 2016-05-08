require 'spec_helper'


describe service('rabbitmq-server') do
  it { should be_enabled }
  it { should be_running }
end


# This port is EPMD(Erlang Port Mapper Daemon)
describe port(4369) do
  it { should be_listening }
end


# This Port is RabbitMQ Node Port
describe port(5672) do
  it { should be_listening }
end
