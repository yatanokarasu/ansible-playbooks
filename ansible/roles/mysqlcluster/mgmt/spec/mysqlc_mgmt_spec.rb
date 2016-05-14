require 'spec_helper'

context "Test state of MySQL Cluster management node" do

  describe user(property['mysqlc_user']) do
    it { should exist                             }
    it { should have_uid property['mysqlc_uid']   }
    it { should have_login_shell '/sbin/nologin'  }
  end

end
