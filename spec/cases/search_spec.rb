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
        results.companies.company.size.should == 10
        results.companies.company.first.name.should == 'Apple'
        results.companies.company.first.id.should == '162479'
      end
    end

    describe "by single keywords option" do
      use_vcr_cassette :record => :new_episodes

      let(:results) do
        options = {:keywords => 'apple'}
        client.search(options, :company)
      end

      it "should perform a company search" do
        results.companies.company.size.should == 10
        results.companies.company.first.name.should == 'Apple'
        results.companies.company.first.id.should == '162479'
      end
    end

    describe "by single keywords option with facets to return" do
      use_vcr_cassette :record => :new_episodes

      let(:results) do
        options = {:keywords => 'apple', :facets => [:industry]}
        client.search(options, :company)
      end

      it "should return a facet" do
        results.facets.facet.buckets.bucket.first.name.should == 'Information Technology and Services'
      end
    end

    describe "by single keywords option with pagination" do
      use_vcr_cassette :record => :new_episodes

      let(:results) do
        options = {:keywords => 'apple', :start => 5, :count => 5}
        client.search(options, :company)
      end

      it "should perform a search" do
        results.companies.company.size.should == 5
        results.companies.company.first.name.should == 'iSquare - Apple Authorized Distributor in Greece & Cyprus'
        results.companies.company.first.id.should == '2135525'
        results.companies.company.last.name.should == 'iHouse - Apple Authorized Reseller'
        results.companies.company.last.id.should == '3179177'
      end
    end

    describe "by keywords options with fields" do
      use_vcr_cassette :record => :new_episodes

      let(:results) do
        fields = [{:companies => [:id, :name, :industries, :description, :specialties]}, :num_results]
        client.search({:keywords => 'apple', :fields => fields}, 'company')
      end

      it "should perform a search" do
        results.companies.company.first.name.should == 'Apple'
        results.companies.company.first.description.should == 'Apple designs Macs, the best personal computers in the world, along with OS X, iLife, iWork and professional software. Apple leads the digital music revolution with its iPods and iTunes online store. Apple has reinvented the mobile phone with its revolutionary iPhone and App Store, and is defining the future of mobile media and computing devices with iPad.'
        results.companies.company.first.id.should == '162479'
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
        results.people.person.size.should == 10
        results.people.person.first.first_name.should == 'Nicolas'
        results.people.person.first.last_name.should == 'Sanguinetti'
        results.people.person.first.id.should == 'RC79yvzbvs'
      end
    end

    describe "by single keywords option" do
      use_vcr_cassette :record => :new_episodes

      let(:results) do
        client.search(:keywords => 'github')
      end

      it "should perform a search" do
        results.people.person.size.should == 10
        results.people.person.first.first_name.should == 'Nicolas'
        results.people.person.first.last_name.should == 'Sanguinetti'
        results.people.person.first.id.should == 'RC79yvzbvs'
      end
    end

    describe "by single keywords option with pagination" do
      use_vcr_cassette :record => :new_episodes

      let(:results) do
        client.search(:keywords => 'github', :start => 5, :count => 5)
      end

      it "should perform a search" do
        results.people.person.size.should == 5
        results.people.person.last.first_name.should == 'Brian'
        results.people.person.last.last_name.should == 'Lopez'
        results.people.person.last.id.should == 'tl_5DxHenJ'
      end
    end

    describe "by first_name and last_name options" do
      use_vcr_cassette :record => :new_episodes

      let(:results) do
        client.search(:first_name => 'Charles', :last_name => 'Garcia')
      end

      it "should perform a search" do
        results.people.person.size.should == 10
        results.people.person.first.first_name.should == 'Charles P.'
        results.people.person.first.last_name.should == 'Garcia'
        results.people.person.first.id.should == 'Ttk0mNl2g0'
      end
    end

    describe "by first_name and last_name options with fields" do
      use_vcr_cassette :record => :new_episodes

      let(:results) do
        fields = [{:people => [:id, :first_name, :last_name, :public_profile_url, :picture_url]}, :num_results]
        client.search(:first_name => 'Charles', :last_name => 'Garcia', :fields => fields)
      end

      it "should perform a search" do
        first_person = results.people.person.first
        results.people.person.size.should == 10
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
        results.people.person.size.should == 10
        results.people.person.first.first_name.should == 'Rodrigo'
        results.people.person.first.last_name.should == 'Baraibar'
        results.people.person.first.id.should == 'mRo8xS331Z'
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