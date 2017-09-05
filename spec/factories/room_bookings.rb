FactoryGirl.define do
	factory :room_booking, class: ActsAsBookable::Booking do
		title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    time_start { Date.today.next_week + 9.hours }
    time_end { Date.today.next_week + 11.hours }
    amount { 1 }
	end
end
