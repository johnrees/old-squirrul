class ScrapeWorker
  include Sidekiq::Worker

  def perform(id)
    EbayItem.find(id).scrape!
  end

end
