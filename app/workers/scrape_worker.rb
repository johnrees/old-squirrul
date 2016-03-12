class ScrapeWorker
  include Sidekiq::Worker

  def perform(id)
    EbayItem.find(id).lite_scrape!
  end

end
