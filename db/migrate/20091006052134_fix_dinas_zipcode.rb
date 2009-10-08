class FixDinasZipcode < ActiveRecord::Migration
  def self.up
    Distributor.find_all_by_name('Dina Sciarra').each do |dina|
      dina.donation_methods.find_all_by_name('check').each do |check|
        check.update_attributes(:description => "Make your check payable to \"Friends of Amani US\" and send it to:\n\nDina Sciarra\n32 Teak Loop\nOscala, FL\n34472")
      end
    end
  end

  def self.down
  end
end
