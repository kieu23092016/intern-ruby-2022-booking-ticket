set :environment, "development"
set :output, "log/cron_log.log"
env :PATH, ENV["PATH"]

#check_expiration of payments every 15 minutes
every 1.minutes do
  rake "delete_namespace:delete_payments_expired", environment: "development"
end
