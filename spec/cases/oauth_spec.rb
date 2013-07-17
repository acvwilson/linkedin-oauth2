require 'helper'

describe "LinkedIn::Client" do

  let(:linkedin_client) do
    key    = ENV['LINKED_IN_CLIENT_KEY'] || '1234'
    secret = ENV['LINKED_IN_CLIENT_SECRET'] || '1234'
    LinkedIn::Client.new(key, secret)
  end

  describe "#client" do
    describe "default oauth options" do
      let(:client) { linkedin_client.client }

      it "should return a configured OAuth client" do
        client.site.should == 'https://api.linkedin.com'
        client.token_url.should == 'https://api.linkedin.com/uas/oauth2/accessToken'
        client.authorize_url.should == 'https://www.linkedin.com/uas/oauth2/authorization'
      end
    end

    describe "different api and auth hosts options" do
      let(:client) do
        LinkedIn::Client.new('1234', '1234', {
          :api_host => 'https://api.josh.com',
          :auth_host => 'https://www.josh.com'
        }).client
      end

      it "should return a configured OAuth client" do
        client.site.should == 'https://api.josh.com'
        client.token_url.should == 'https://api.josh.com/uas/oauth2/accessToken'
        client.authorize_url.should == 'https://www.josh.com/uas/oauth2/authorization'
      end
    end

    describe "different oauth paths" do
      let(:client) do
        LinkedIn::Client.new('1234', '1234', {
          :access_token_path  => "/secure/oauth2/accessToken",
          :authorize_path     => "/secure/oauth2/authorization",
        }).client
      end

      it "should return a configured OAuth client" do
        client.site.should == 'https://api.linkedin.com'
        client.token_url.should == 'https://api.linkedin.com/secure/oauth2/accessToken'
        client.authorize_url.should == 'https://www.linkedin.com/secure/oauth2/authorization'
      end
    end

    describe "specify oauth urls" do
      let(:client) do
        LinkedIn::Client.new('1234', '1234', {
          :access_token_url  => "https://api.josh.com/secure/oauth2/accessToken",
          :authorize_url     => "https://www.josh.com/secure/oauth2/authorization",
        }).client
      end

      it "should return a configured OAuth client" do
        client.site.should == 'https://api.linkedin.com'
        client.token_url.should == 'https://api.josh.com/secure/oauth2/accessToken'
        client.authorize_url.should == 'https://www.josh.com/secure/oauth2/authorization'
      end
    end

    describe "use the :site option to specify the host of all oauth urls" do
      let(:client) do
        LinkedIn::Client.new('1234', '1234', {
          :site => "https://api.josh.com"
        }).client
      end

      it "should return a configured OAuth client" do
        client.site.should == 'https://api.josh.com'
        client.token_url.should == 'https://api.josh.com/uas/oauth2/accessToken'
        client.authorize_url.should == 'https://api.josh.com/uas/oauth2/authorization'
      end
    end
  end

  describe "#access_token" do
    let(:access_token) do
      linkedin_client.authorize_from_access('dummy-token')
      linkedin_client.access_token
    end

    it "should return a valid auth token" do
      access_token.should be_a_kind_of OAuth2::AccessToken
      access_token.token.should be_a_kind_of String
    end
  end

end
