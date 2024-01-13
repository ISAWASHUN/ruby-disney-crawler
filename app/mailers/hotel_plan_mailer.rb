class HotelPlanMailer < ApplicationMailer
  def notification(hotel_plan)
    @hotel_plans = hotel_plans
    subject = "新しいプランが追加されました。"
    to = "isawashundesu@gmail.com"
    mail(to: to, from: from, subject: subject)
  end
end
