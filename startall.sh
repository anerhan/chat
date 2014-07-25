#!/bin/sh

# RAILS_ENV=development
APP_ROOT=$HOME/projects/chat

RESQUE_PID=$APP_ROOT/tmp/pids/resque.pid

FAYE_PID=$APP_ROOT/tmp/pids/faye.pid
FAYE_CONFIG=$APP_ROOT/faye.ru

kill -9 $(cat $FAYE_PID)
kill -9 $(cat $RESQUE_PID)

# cd $APP_ROOT; RAILS_ENV=production bundle exec thin -d -p 9295 -R $APP_ROOT/faye.ru -P FAYE_PID start

# cd $APP_ROOT && RAILS_ENV=production bundle exec thin -d -p 9295 -R $FAYE_CONFIG -P $FAYE_PID start
# cd $APP_ROOT && PIDFILE=$RESQUE_PID BACKGROUND=yes QUEUE=* RAILS_ENV=$RAILS_ENV bundle exec rake resque:work
