require 'helper'

describe LinkedIn::Mash do

  describe ".from_xml" do
    it "should convert a xml string to a Mash" do
      xml_string = "<person><name>Josh Kalderimis</name></person>"
      mash = LinkedIn::Mash.from_xml(xml_string)

      mash.should have_key('name')
      mash.name.should == 'Josh Kalderimis'
    end
  end

  describe ".clean_search_hash" do
    it "should modify the hash to make naming sane" do
      hash = {'people' => {'person' => [{'name' => "Josh Kalderimis"}]}}
      clean_hash = LinkedIn::Mash.clean_search_hash(hash)

      clean_hash['people'].should_not have_key('person')
      clean_hash['people'].should have_key('data')
    end

    it "should modify the hash to avoid collisions" do
      hash = {'update' => [{'name' => "Josh Kalderimis"}]}
      clean_hash = LinkedIn::Mash.clean_search_hash(hash)

      clean_hash.should_not have_key('update')
      clean_hash.should have_key('data')
    end

    it "should deeply modify the hash to make naming sane" do
      hash = {'people' => {'person' => [{'statuses' => {'status' => [{'body' => 'This is sane!'}]}}]}}
      clean_hash = LinkedIn::Mash.clean_search_hash(hash)

      clean_hash['people']['data'].first['statuses'].should_not have_key('status')
      clean_hash['people']['data'].first['statuses'].should have_key('data')
    end
  end

  describe "#convert_keys" do
    let(:mash) do
      LinkedIn::Mash.new({
        'firstName' => 'Josh',
        'LastName' => 'Kalderimis',
        '_key' => 1234,
        '_total' => 1234,
        'count' => 1234,
        'numResults' => 'total_results'
      })
    end

    it "should convert camal cased hash keys to underscores" do
      mash.should have_key('first_name')
      mash.should have_key('last_name')
    end

    it "should convert the key _key to id" do
      mash.should have_key('id')
    end

    it "should convert the key _total to total" do
      mash.should have_key('total')
    end

    it "should convert the key count to batch_count" do
      mash.should have_key('page_count')
    end

    it "should convert the key numResults to total_results" do
      mash.should have_key('total_results')
    end
  end

  describe '#timestamp' do
    it "should return a valid Time if a key of timestamp exists and the value is an int" do
      time_mash = LinkedIn::Mash.new({ 'timestamp' => 1297083249 })

      time_mash.timestamp.should be_a_kind_of(Time)
      time_mash.timestamp.to_i.should  == 1297083249
    end

    it "should return a valid Time if a key of timestamp exists and the value is an int which is greater than 9999999999" do
      time_mash = LinkedIn::Mash.new({ 'timestamp' => 1297083249 * 1000 })

      time_mash.timestamp.should be_a_kind_of(Time)
      time_mash.timestamp.to_i.should  == 1297083249
    end
  end

  describe "#to_date" do
    let(:date_mash) do
      LinkedIn::Mash.new({
        'year' => 2010,
        'month' => 06,
        'day' => 23
      })
    end

    it "should return a valid Date if the keys year, month, day all exist" do
      date_mash.to_date.should == Date.civil(2010, 06, 23)
    end
  end

end
