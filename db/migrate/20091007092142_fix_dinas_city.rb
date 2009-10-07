class FixDinasCity < ActiveRecord::Migration
  def self.up
    Distributor.find_by_name('Dina Sciarra').tap do |dina|
      dina.donation_methods.find_by_name('check').tap do |check|
        check.update_attributes(:description => "Make your check payable to \"Friends of Amani US\" and send it to:\n\nDina Sciarra\n32 Teak Loop\nOcala, FL\n34472")
      end
    end
  end

  def self.down
  end
end
