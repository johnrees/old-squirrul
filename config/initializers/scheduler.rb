require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

times = [
  [0, 2.seconds],
  [15.seconds, 5.seconds],
  [1.minute, 30.seconds],
  [5.minutes, 1.minute],
  [15.minutes, 5.minutes],
  [1.hour, 20.minutes]
].reverse!

scheduler.every '2s' do
  now = Time.now.to_i
  ebay_items = EbayItem.upcoming.pluck("id,ends_at")
  ebay_items.each do |id,ends_at|
    time_left = (ends_at - now).to_i
    str = "#{id} - #{time_left.to_s}"
    times.each do |limit, frequency|
      if time_left >= limit
        if time_left % frequency <= 1
          str += " #{Time.at(frequency).utc.strftime("%H:%M:%S")}"
          EbayItem.find(id).scrape!
        end
        break
      end
    end
    puts str
  end
end

# scheduler.join