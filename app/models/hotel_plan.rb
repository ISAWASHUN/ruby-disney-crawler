class HotelPlan < ApplicationRecord
  validates :plan_name, presence: true
  validates :room_name, presence: true, uniqueness: { scope: :plan_name }
  validates :price, presence: true, numericality: { only_integer: true, greater_than: 0 }


  def self.fetch_hotel_plan
    url = "https://asp.hotel-story.ne.jp/ver3d/planlist.asp?hcod1=00020&hcod2=001&hidmode=select&mode=seek&hidSELECTARRYMD=2019%2F08%2F12&hidSELECTHAKSU=2&hidSELECTadult=4&room=1&obj_ga=2.146060855.2096339239.1564882699-1444074251.1558508852&_ga=2.208041233.2096339239.1564882699-1444074251.1558508852"

    agent = Mechanize.new
    page = agent.get(url)

    new_plan_names = []
    #旅行プランのタイトルを取得
    page.search('.plan-list h3').each do |el|
      plan_name = el.at('h3').text
      table = el.at('.reserve_available')
      table.search('tr').each_with_index do |row, i|
        next if i == 0
        room_name = row.at('.col01').text.squish
        price =  row.at('.col3').text.squish

        record = self.find_or_initialize_by(plan_name: plan_name, room_name: room_name)

        if record.new_record?
          record.price = price.gsub(/[^\d]/, '').to_i
          record.save!
          new_plan_names << record
        else
          logger.info "既存のレコードが見つかりました。"
        end
      end
      # メール送信
      HotelPlanMailer.notification(new_plan_names).deliver_now
    end
  end
end
