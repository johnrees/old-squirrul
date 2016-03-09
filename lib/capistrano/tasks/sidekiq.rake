namespace :sidekiq do
  task :quiet do
    on roles(:app) do
      puts capture("pgrep -f 'sidekiq' | xargs kill -USR1") 
    end
  end
  task :restart do
    on roles(:app) do
      sudo "initctl restart sidekiq"
    end
  end
end

after 'deploy:starting', 'sidekiq:quiet'
after 'deploy:reverted', 'sidekiq:restart'
after 'deploy:published', 'sidekiq:restart'
