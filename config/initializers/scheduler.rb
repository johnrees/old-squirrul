# if $scheduler_thread

#   require 'rufus-scheduler'

#   Rails.logger.info "Created rufus scheduler"
#   scheduler = Rufus::Scheduler.new

#   lite_scrape_times = [
#     [0, 2.seconds],
#     [15.seconds, 5.seconds],
#     [1.minute, 30.seconds],
#     [5.minutes, 1.minute],
#     [15.minutes, 5.minutes],
#     [1.hour, 20.minutes]
#   ].reverse!

#   ebay_items = EbayItem.upcoming.pluck("id,ends_at")

#   scheduler.every '2s' do
#     now = Time.now.to_i
#     Rails.logger.info now
#     ebay_items.each do |id,ends_at|
#       time_left = (ends_at - now).to_i
#       lite_scrape_times.each do |limit, frequency|
#         if time_left >= limit
#           if time_left % frequency <= 1
#             str = "#{id} - #{time_left.to_s}"
#             str += " #{Time.at(frequency).utc.strftime("%H:%M:%S")}"
#             Rails.logger.info str
#             ScrapeWorker.perform_async(id)
#           end
#           break
#         end
#       end
#     end
#   end

#   # scheduler.join

# end
