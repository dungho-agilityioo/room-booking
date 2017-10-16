FactoryGirl.define do
	factory :booking, class: Booking do
		title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    start_date { Date.today.next_week + 9.hours }
    end_date { Date.today.next_week + 11.hours }
	end

  factory :booking_with_user, class: Booking, parent: :booking do
    room { create(:room) }
  end

  factory :booking_with_room, class: Booking, parent: :booking do
    user { create(:user) }
  end

  factory :booking_all, class: Booking, parent: :booking do
    room { create(:room) }
    user { create(:user) }
  end
end
