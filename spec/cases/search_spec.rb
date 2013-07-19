require 'helper'

describe LinkedIn::Search do

  # if you remove the related cassettes you will need to inform valid
  # tokens and secrets to regenerate them
  #
  let(:client) do
    consumer_token  = ENV['LINKED_IN_CONSUMER_KEY'] || 'key'
    consumer_secret = ENV['LINKED_IN_CONSUMER_SECRET'] || 'secret'
    client = LinkedIn::Client.new(consumer_token, consumer_secret)

    auth_token      = ENV['LINKED_IN_AUTH_KEY'] || '1234'
    client.authorize_from_access(auth_token)
    client
  end

  describe "#search_company" do

    describe "by keywords string parameter" do
      use_vcr_cassette :record => :new_episodes

      let(:results) do
        client.search('apple', :company)
      end

      it "should perform a company search" do
        results.companies.data.size.should == 10
        results.companies.data.first.name.should == 'Apple'
        results.companies.data.first.id.should == '162479'
      end
    end

    describe "by single keywords option" do
      use_vcr_cassette :record => :new_episodes

      let(:results) do
        options = {:keywords => 'apple'}
        client.search(options, :company)
      end

      it "should perform a company search" do
        results.companies.data.size.should == 10
        results.companies.data.first.name.should == 'Apple'
        results.companies.data.first.id.should == '162479'
      end
    end

    describe "by single keywords option with facets to return" do
      use_vcr_cassette :record => :new_episodes

      let(:results) do
        options = {:keywords => 'apple', :facets => [:industry]}
        client.search(options, :company)
      end

      it "should return a facet" do
        results.facets.data.first.buckets.data.first.name.should == 'Information Technology and Services'
      end
    end

    describe "by single keywords option with pagination" do
      use_vcr_cassette :record => :new_episodes

      let(:results) do
        options = {:keywords => 'apple', :start => 5, :count => 5}
        client.search(options, :company)
      end

      it "should perform a search" do
        results.companies.data.size.should == 5
        results.companies.data.first.name.should == 'iSquare - Apple Authorized Distributor in Greece & Cyprus'
        results.companies.data.first.id.should == '2135525'
        results.companies.data.last.name.should == 'iHouse - Apple Authorized Reseller'
        results.companies.data.last.id.should == '3179177'
      end
    end

    describe "by keywords options with fields" do
      use_vcr_cassette :record => :new_episodes

      let(:results) do
        fields = [{:companies => [:id, :name, :industries, :description, :specialties]}, :num_results]
        client.search({:keywords => 'apple', :fields => fields}, 'company')
      end

      it "should perform a search" do
        results.companies.data.first.name.should == 'Apple'
        results.companies.data.first.description.should == 'Apple designs Macs, the best personal computers in the world, along with OS X, iLife, iWork and professional software. Apple leads the digital music revolution with its iPods and iTunes online store. Apple has reinvented the mobile phone with its revolutionary iPhone and App Store, and is defining the future of mobile media and computing devices with iPad.'
        results.companies.data.first.id.should == '162479'
      end
    end

  end

  describe "#search" do

    describe "by keywords string parameter" do
      use_vcr_cassette :record => :new_episodes

      let(:results) do
        client.search('github')
      end

      it "should perform a search" do
        results.people.data.size.should == 10
        results.people.data.first.first_name.should == 'Nicolas'
        results.people.data.first.last_name.should == 'Sanguinetti'
        results.people.data.first.id.should == 'RC79yvzbvs'
      end
    end

    describe "by single keywords option" do
      use_vcr_cassette :record => :new_episodes

      let(:results) do
        client.search(:keywords => 'github')
      end

      it "should perform a search" do
        results.people.data.size.should == 10
        results.people.data.first.first_name.should == 'Nicolas'
        results.people.data.first.last_name.should == 'Sanguinetti'
        results.people.data.first.id.should == 'RC79yvzbvs'
      end
    end

    describe "by single keywords option with pagination" do
      use_vcr_cassette :record => :new_episodes

      let(:results) do
        client.search(:keywords => 'github', :start => 5, :count => 5)
      end

      it "should perform a search" do
        results.people.data.size.should == 5
        results.people.data.last.first_name.should == 'Brian'
        results.people.data.last.last_name.should == 'Lopez'
        results.people.data.last.id.should == 'tl_5DxHenJ'
      end
    end

    describe "by first_name and last_name options" do
      use_vcr_cassette :record => :new_episodes

      let(:results) do
        client.search(:first_name => 'Charles', :last_name => 'Garcia')
      end

      it "should perform a search" do
        results.people.data.size.should == 10
        results.people.data.first.first_name.should == 'Charles P.'
        results.people.data.first.last_name.should == 'Garcia'
        results.people.data.first.id.should == 'Ttk0mNl2g0'
      end
    end

    describe "by first_name and last_name options with fields" do
      use_vcr_cassette :record => :new_episodes

      let(:results) do
        fields = [{:people => [:id, :first_name, :last_name, :public_profile_url, :picture_url]}, :num_results]
        client.search(:first_name => 'Charles', :last_name => 'Garcia', :fields => fields)
      end

      it "should perform a search" do
        first_person = results.people.data.first
        results.people.data.size.should == 10
        first_person.first_name.should == 'Charles P.'
        first_person.last_name.should == 'Garcia'
        first_person.id.should == 'Ttk0mNl2g0'
        first_person.picture_url.should == 'http://m.c.lnkd.licdn.com/mpr/mprx/0_u_fFG4ExLxBon7rsGXp4GseYLJGE9WTsmFRZGse7Vx9sdDnVh50IuVpTIqCvvm8nS8DJDj9JZqhM'
        first_person.public_profile_url.should == 'http://www.linkedin.com/in/charlespgarcia'
      end
    end

    describe "by company_name option" do
      use_vcr_cassette :record => :new_episodes

      let(:results) do
        client.search(:company_name => 'IBM')
      end

      it "should perform a search" do
        results.people.data.size.should == 10
        results.people.data.first.first_name.should == 'Rodrigo'
        results.people.data.first.last_name.should == 'Baraibar'
        results.people.data.first.id.should == 'mRo8xS331Z'
      end
    end

    describe "#field_selector" do
      it "should not modify the parameter object" do
        fields = [{:people => [:id, :first_name]}]
        fields_dup = fields.dup
        client.send(:field_selector, fields)
        fields.should eq fields_dup
      end
    end

  end

end