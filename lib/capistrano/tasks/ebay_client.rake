namespace :ebay_client do      
  desc "Transfer ebay_client.rb"
  task :upload do
    on roles(:all) do
      upload! "lib/ebay_client.rb", "#{release_path}/lib/ebay_client.rb"
    end
  end
end
before "deploy:symlink:shared", "ebay_client:upload"
