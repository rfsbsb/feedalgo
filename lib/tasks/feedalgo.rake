namespace :feedalgo do
  desc "Fetch new entries"
  task :fetchnew => :environment do
    crawler = Crawler.new
    crawler.update_all
  end
end