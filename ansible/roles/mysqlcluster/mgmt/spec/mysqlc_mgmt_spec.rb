require 'spec_helper'

context "Test state of MySQL Cluster management node" do

  describe user(property['mysqlc_user']) do
    it { should exist                             }
    it { should have_uid property['mysqlc_uid']   }
    it { should have_login_shell '/sbin/nologin'  }
  end
  
  describe iptables do
    accept_rule  = [
      "-p tcp",
      "-m state --state NEW",
      "-m tcp --dport #{property['mysqlc_mgmt']['port']}",
      "-j ACCEPT"
    ].join(' ')
    
    it { should have_rule(accept_rule).with_table('filter').with_chain('INPUT') }
  end

end
