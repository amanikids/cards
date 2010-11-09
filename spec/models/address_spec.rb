require 'spec_helper'

describe Address do
  it_behaves_like 'a model with translated attributes'

  context 'assignment' do
    it { should allow_mass_assignment_of(:name) }
    it { should allow_mass_assignment_of(:line_1) }
    it { should allow_mass_assignment_of(:line_2) }
    it { should allow_mass_assignment_of(:line_3) }
    it { should allow_mass_assignment_of(:line_4) }
    it { should allow_mass_assignment_of(:country) }
    it { should allow_mass_assignment_of(:email) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:line_1) }
    it { should validate_presence_of(:line_2) }
    it { should validate_presence_of(:country) }
    it { should validate_presence_of(:email) }
  end

  context 'from paypal details' do
    let 'address' do
      Address.from_paypal_details(
        'bob@example.com',
        'name'     => 'Bob Loblaw',
        'address1' => '123 Main St.',
        'address2' => '',
        'city'     => 'Anytown',
        'state'    => 'NY',
        'country'  => 'USA',
        'zip'      => '09876'
      )
    end

    it 'builds a new record' do
      address.should be_a_new_record
    end

    it 'copies the name' do
      address.name.should == 'Bob Loblaw'
    end

    it 'copies the address1' do
      address.line_1.should == '123 Main St.'
    end

    it 'merges the city and state' do
      address.line_2.should == 'Anytown, NY'
    end

    it 'copies the zipcode' do
      address.line_3.should == '09876'
    end

    it 'copies the country' do
      address.country.should == 'USA'
    end

    it 'copies the email address' do
      address.email.should == 'bob@example.com'
    end
  end

  context 'from paypal details, with an address2' do
    let 'address' do
      Address.from_paypal_details(
        'bob@example.com',
        'name'     => 'Bob Loblaw',
        'address1' => '123 Main St.',
        'address2' => 'Apt. 4',
        'city'     => 'Anytown',
        'state'    => 'NY',
        'country'  => 'USA',
        'zip'      => '09876'
      )
    end

    it 'copies the address2' do
      address.line_2.should == 'Apt. 4'
    end

    it 'merges the city and state into line 3' do
      address.line_3.should == 'Anytown, NY'
    end

    it 'copies the zipcode into line 4' do
      address.line_4.should == '09876'
    end
  end
end
