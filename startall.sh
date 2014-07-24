#!/bin/sh

RAILS_ENV=development
APP_ROOT=$HOME/projects/chat
FAYE_PID=$APP_ROOT/tmp/pids/faye.pid
kill cat `$FAYE_PID`
cd $APP_ROOT; RAILS_ENV=production bundle exec thin -d -p 9295 -R $APP_ROOT/faye.ru -P FAYE_PID start

