require 'spec_helper'


describe service('rabbitmq-server') do
  it { should be_enabled }
  it { should be_running }
end


describe port(4369) do
  it { should be_listening }
end


describe port(5672) do
  it { should be_listening }
end
