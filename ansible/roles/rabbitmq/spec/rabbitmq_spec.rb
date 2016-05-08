require 'spec_helper'

context "Test state of RabbitMQ Server" do
  
  describe service('rabbitmq-server') do
    it { should be_enabled }
    it { should be_running }
  end


  # Test the following ports are opened and accepted by iptables:
  #   - EPMD(Erlang Port Mapper Daemon)
  #   - RabbitMQ Node
  property['rabbitmq_iptables']['dest_ports'].each do |port_num|
    describe "Port \"#{port_num}\"" do
      it { port(port_num).should  be_listening } if port_num != 15672
      
      accept_rule  = [
        "-i #{property['rabbitmq_iptables']['in']}",
        "-p tcp",
        "-m state --state NEW",
        "-m tcp --dport #{port_num}",
        "-j ACCEPT"
      ].join(' ')
      
      it { iptables.should have_rule(accept_rule).with_table('filter').with_chain('INPUT') }
    end
  end

end
