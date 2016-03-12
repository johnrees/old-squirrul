namespace :ebay do

  desc "SCP transfer ebay_client"
  task :upload_libs do
    on roles(:app) do
      upload! "lib/ebay_client.rb", "#{release_path}/lib/ebay_client.rb", via: :scp
      upload! "lib/tasks/ebay.rake", "#{release_path}/lib/tasks/ebay.rake", via: :scp
    end
  end

  namespace :scraper do
    desc "SCP transfer auction_scraper to the shared folder"
    task :replace do
      on roles(:app) do
        upload! "auction_scraper.rb", "#{shared_path}/auction_scraper.rb", via: :scp
        sudo "restart scraper"
      end
    end

    desc "Symlink auction_scraper.rb to the release path"
    task :symlink do
      on roles(:app) do
        execute "ln -sf #{shared_path}/auction_scraper.rb #{current_path}/auction_scraper.rb"
      end
    end

    %w(start stop restart status).each do |task_name|
      desc "#{task_name} Scraper"
      task task_name do
        on roles(:app) do
          sudo "#{task_name} scraper"
        end
      end
    end

  end

end

after "deploy:started", "ebay:upload_libs"
#after "deploy:started", "ebay_client:scraper:replace"
after "deploy:symlink:release", "ebay:scraper:symlink"
