namespace :db do
  desc "seeds test data"
  task seed_test_data: :environment do
    Rake::Task['db:seed'].invoke if Whitecard.all.empty? || Blackcard.all.empty? 
    require_relative '../../db/test_data_importer'
  end

end
