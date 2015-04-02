require 'spec_helper'

describe Invitation do 
  it { should validate_presence_of(:invitee_name) }
  it { should validate_presence_of(:invitee_email) }
  it { should validate_presence_of(:message) }

  it_behaves_like "tokenable" do
    let(:object) { Fabricate(:invitation) }
    let(:token_column) { :token }  
  end    
end