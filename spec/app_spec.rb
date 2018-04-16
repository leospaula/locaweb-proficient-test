require File.expand_path '../spec_helper.rb', __FILE__

describe 'Application' do
  it "GET /most_mentions" do
    get '/most_mentions'
    expect(last_response).to be_ok
    expect(last_response.content_type).to eq("application/json")
  end

  it "GET /most_relevants" do
    get '/most_relevants'
    expect(last_response).to be_ok
    expect(last_response.content_type).to eq("application/json")
  end
end