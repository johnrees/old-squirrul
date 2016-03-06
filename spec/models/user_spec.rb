require 'rails_helper'

RSpec.describe User, :type => :model do

  it "is valid" do
    expect(build_stubbed(:user)).to be_valid
  end

end
