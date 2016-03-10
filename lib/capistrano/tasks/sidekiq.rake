namespace :sidekiq do
  task :quiet do
    on roles(:app) do
      puts capture("pgrep -f 'sidekiq' | xargs kill -USR1") 
    end
  end
  task :restart do
    on roles(:app) do
      sudo "sudo restart sidekiq index=0"
    end
  end
end

# if any scheduling things have changed...
#   after 'deploy:starting', 'sidekiq:quiet'
#   after 'deploy:reverted', 'sidekiq:restart'
#   after 'deploy:published', 'sidekiq:restart'
