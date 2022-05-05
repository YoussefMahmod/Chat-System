# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

#Creates a output log for you to view previously run cron jobs
set :output, "log/cron.log" 

#Sets the environment to run during development mode (Set to production by default)
set :environment, "development"

every 30.minutes do
  runner "Chat.update_messages_counter"
  runner "Application.update_chats_counter"
end