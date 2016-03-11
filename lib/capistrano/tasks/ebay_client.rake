namespace :ebay_client do
  desc "SCP transfer ebay_client"
  task :upload do
    on roles(:app) do
      upload! "lib/ebay_client.rb", "#{release_path}/lib/ebay_client.rb", via: :scp
      upload! "lib/tasks/ebay.rake", "#{release_path}/lib/tasks/ebay.rake", via: :scp
    end
  end
end

after "deploy:started", "ebay_client:upload"
