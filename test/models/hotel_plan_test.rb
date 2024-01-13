require "test_helper"

class HotelTest < ActiveSupport::TestCase
  setup do
    ActionMailer::Base.deliveries.clear
  end
end

class HotelPlanTest < ActiveSupport::TestCase
  test ".fetch_hotel_plan" do
    VCR.use_cassette('fetch_hotel_plan') do
      assert_difference ->{ HotelPlan.count } => 8, ->{
        ActionMailer::Base.deliveries.size } => 1 do
        HotelPlan.fetch_hotel_plan
      end
    end
    mail = ActionMailer::Base.deliveries.last
    asset_qual ['isawashundesu@gmail.com'], mail.to
  end
end
