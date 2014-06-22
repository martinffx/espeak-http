namespace :nginx do
  desc "Setup application in nginx"
  task "setup" do
    on roles(:web) do
      config_file = fetch(:nginx_config)
      if File.exists?(config_file)
        config = StringIO.new(ERB.new(File.read(config_file))
                                .result(binding))
        upload_tmp = "/tmp/#{fetch(:application)}"
        upload_location = "/etc/nginx/sites-available/#{fetch(:application)}"

        upload! config, upload_tmp
        execute "sudo mv #{upload_tmp} #{upload_location}"
        execute "sudo ln -fs #{upload_location} " +
          "/etc/nginx/sites-enabled/#{fetch(:application)}"
      else
        error "no config file: #{fetch(:nginx_config)}"
      end
    end
  end

  desc "Stop nginx"
  task :stop do
    on roles(:web) do
      execute "sudo service nginx stop"
    end
  end

  desc "Start nginx"
  task :start do
    on roles(:web) do
      execute "sudo service nginx start"
    end
  end

  desc "Reload nginx configuration"
  task :reload do
    on roles(:web) do
      execute "sudo service nginx restart"
    end
  end
end
