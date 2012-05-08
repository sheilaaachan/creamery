require 'test_helper'

class StoreTest < ActiveSupport::TestCase
  # Test relationships
  should have_many(:assignments)
  should have_many(:employees).through(:assignments)
  should have_many(:shifts).through(:assignments)
  
  # Test basic validations
  should validate_presence_of(:name)
  should validate_presence_of(:street)
  should validate_presence_of(:city)
  # tests for zip
  should allow_value("15213").for(:zip)
  should_not allow_value("bad").for(:zip)
  should_not allow_value("1512").for(:zip)
  should_not allow_value("152134").for(:zip)
  should_not allow_value("15213-0983").for(:zip)
  # tests for state
  should allow_value("OH").for(:state)
  should allow_value("PA").for(:state)
  should allow_value("WV").for(:state)
  should_not allow_value("bad").for(:state)
  should_not allow_value("NY").for(:state)
  should_not allow_value(10).for(:state)
  should_not allow_value("CA").for(:state)
  # tests for phone
  should allow_value("4122683259").for(:phone)
  should allow_value("412-268-3259").for(:phone)
  should allow_value("412.268.3259").for(:phone)
  should allow_value("(412) 268-3259").for(:phone)
  should_not allow_value("2683259").for(:phone)
  should_not allow_value("14122683259").for(:phone)
  should_not allow_value("4122683259x224").for(:phone)
  should_not allow_value("800-EAT-FOOD").for(:phone)
  should_not allow_value("412/268/3259").for(:phone)
  should_not allow_value("412-2683-259").for(:phone)
  
  
  # Establish context
  # Testing other methods with a context
  context "Creating three stores" do
    # create the objects I want with factories
    setup do 
      @cmu = FactoryGirl.create(:store)
      @hazelwood = FactoryGirl.create(:store, :name => "Hazelwood", :active => false)
      @oakland = FactoryGirl.create(:store, :name => "Oakland", :phone => "412-268-8211")
      @cindy = FactoryGirl.create(:employee, :first_name => "Cindy", :last_name => "Crawford", :ssn => "084-35-9822", :date_of_birth => 17.years.ago.to_date)
      @assign_cindy = FactoryGirl.create(:assignment, :employee => @cindy, :store => @cmu, :end_date => nil)
      @job = FactoryGirl.create(:job)
      @shift_cindy = FactoryGirl.create(:shift, :assignment => @assign_cindy, :date => 2.days.ago)
      @shift_job = FactoryGirl.create(:shift_job, :job => @job, :shift => @shift_cindy) 
    end
    
    # and provide a teardown method as well
    teardown do
      @cmu.destroy
      @hazelwood.destroy
      @oakland.destroy
      @cindy.destroy
      @assign_cindy.destroy
      @job.destroy
      @shift_cindy.destroy
      @shift_job.destroy
    end
  
    # now run the tests:
    # test one of each factory (not really required, but not a bad idea)
    should "show that all factories are properly created" do
      assert_equal "CMU", @cmu.name
      assert @oakland.active
      deny @hazelwood.active
    end
    
    # test stores must have unique names
    should "force stores to have unique names" do
      repeat_store = Factory.build(:store, :name => "CMU")
      deny repeat_store.valid?
    end
    
    # test the callback is working 'reformat_phone'
    should "shows that Oakland's phone is stripped of non-digits" do
      assert_equal "4122688211", @oakland.phone
    end
    
    # test the scope 'alphabetical'
    should "shows that there are three stores in in alphabetical order" do
      assert_equal ["CMU", "Hazelwood", "Oakland"], Store.alphabetical.map{|s| s.name}
    end
    
    # test the scope 'active'
    should "shows that there are two active stores" do
      assert_equal 2, Store.active.size
      assert_equal ["CMU", "Oakland"], Store.active.alphabetical.map{|s| s.name}
    end
    
    # test the scope 'inactive'
    should "shows that there is one inactive store" do
      assert_equal 1, Store.inactive.size
      assert_equal ["Hazelwood"], Store.inactive.alphabetical.map{|s| s.name}
    end

    # test the method 'create_map_link_all'
    should 'show the map link of all stores on one map' do
      assert_equal "http://maps.google.com/maps/api/staticmap?zoom=11&size=500x500&maptype=roadmap&markers=color:red%7Ccolor:red%7Clabel:1%7C40.4435037,-79.9415706&markers=color:red%7Ccolor:red%7Clabel:2%7C40.4435037,-79.9415706&sensor=false", Store.create_map_link_all
    end

    # test the method 'create_map_link'
    should 'show the map link of a store map' do
      assert_equal "http://maps.google.com/maps/api/staticmap?center=\n      40.4435037,-79.9415706&zoom=13&size=500x500&maptype=roadmap&markers=color:red%7Ccolor:red%7Clabel:1%7C40.4435037,-79.9415706&sensor=false", @cmu.create_map_link
    end

    # test the method 'store_shift_hours' do
    should 'return the total number of shift hours worked at a store' do
      assert_equal 3, @cmu.store_shift_hours
    end
    
    # test the callback that gets store coordinates
    # should "get the the right coordinates for a store" do
    #   assert_equal 40.4435037, @cmu.lat
    #   assert_equal -79.9415706, @cmu.lon
    # end
  end
end
