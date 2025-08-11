# lib/tasks/maintenance.rake
namespace :maintenance do
  desc "Say hello from a custom task"
  task hello: :environment do
    puts "Hello from Rake!"
  end
end
