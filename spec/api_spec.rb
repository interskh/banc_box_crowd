require 'spec_helper'

describe BancBoxCrowd do

  before do
    BancBoxCrowd.configure do |config|
      config.base_url = 'https://sandbox-api.bancboxcrowd.com/crowd/v0/cfp/'
      config.api_key = 'eb74249d-e503-405d-9618-21cf2d220f73'
      config.api_secret = '10f5ff9090'
    end
  end

  it 'should create an investor and return its id' do
    WebMock.stub_request(
      :post,
      "https://sandbox-api.bancboxcrowd.com/crowd/v0/cfp/"
    ).to_return(
      :status => 200,
      :body => {"clientId"=>{"bancBoxId"=>123}, "clientStatus"=>"ACTIVE", "requestId"=>123, "status"=>1}
    )
    begin
      data = BancBoxCrowd.create_investor({
        :first_name => 'Aubrey',
        :last_name => 'Holland',
        :ssn => '555-55-5555',
        :dob => Date.today - 10000,
        :phone => '1234567890',
        :email => 'aubreyholland@gmail.com',
        :created_by => 'Roger',
        :address_1 => '123 Main Street',
        :city => 'Chapel Hill',
        :state => 'NC',
        :zip => '27514'
      })
    rescue Exception => e
      puts e
    end 
    data.should be_an_instance_of(BancBoxCrowd::Id)
    data.to_hash.should == {
      :bancBoxId => 123,
      :subscriberReferenceId => nil
    }
  end

end