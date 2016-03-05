require 'rails_helper'

RSpec.describe User, :type => :model do
  
  it "can create user" do
    user = User.new(username: 'steve', password: 'something')
    expect(user).to be_valid
  end

end
