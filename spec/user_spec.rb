require 'spec_helper'

describe User do

  it 'Making an invalid user' do
    user = User.make_invalid
    expect(user.valid?).to eq(false)
  end

  it 'Making a valid user' do
    user = User.make_valid
    expect(user.valid?).to eq(true)
  end

  it 'Creating a user twice should fail' do
    user1 = User.make_valid
    user2 = User.make_valid
    expect(user1.save).to eq(true)
    expect(user2.save).to eq(false)
  end

end