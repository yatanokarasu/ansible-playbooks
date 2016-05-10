require 'spec_helper'

context "Test state of MySQL Cluster management node" do

  describe user(property['mysqlc_user']) do
    it { should exist }
  end

end
