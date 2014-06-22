namespace :espeak do
  desc "install requirements for espeak-ruby"
  task "install" do
    on roles :web do
      execute "sudo apt-get install espeak lame"
    end
  end
end
