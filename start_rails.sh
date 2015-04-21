#!/bin/bash

echo ------- start_rails.sh ------- start

/bin/bash -l -c 'service postgresql start'
/bin/bash -l -c 'rake db:setup RAILS_ENV=production'
/bin/bash -l -c 'rake assets:precompile RAILS_ENV=production'
/bin/bash -l -c 'passenger start -e production -p 3000'

echo ------- start_rails.sh ------- done
