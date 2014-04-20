require "spec_helper"

describe UploadController do

  it "uploads text data and saves it to a relational database" do
    @file = fixture_file_upload('files/example.tab')
    @user = User.create(email: "test@test.com", password:"123456789")
    sign_in @user
    post :create, :database => @file
    expect(response).to be_success
    expect(Purchase.count).to eq(4)
    expect(Merchant.count).to eq(3)
    expect(Customer.count).to eq(3)
    expect(LineItem.count).to eq(3)
  end

end
