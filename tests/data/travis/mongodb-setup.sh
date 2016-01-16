#!/bin/sh -e
#
# install mongodb

if (php --version | grep -i HipHop > /dev/null); then
  # Attempt to use https://github.com/mongodb/mongo-hhvm-driver
  for i in ~/.phpenv/versions/$(phpenv version-name)/etc/php.ini ~/.phpenv/versions/$(phpenv version-name)/etc/hhvm/php.ini; do
    if [ -e "$i" ]; then
      echo "Found HHVM's php.ini: $i"
      echo "hhvm.dynamic_extensions[mongodb]=mongodb.so" >> "$i"
    fi
  done
else
  pecl install mongodb
  # This can be used instead once Travis adds mongodb.so to the PHP 7 environment:
  #echo "extension = mongodb.so" >> ~/.phpenv/versions/$(phpenv version-name)/etc/php.ini
fi

echo "MongoDB Server version:"
mongod --version

if ! (php --version | grep -i HipHop > /dev/null); then
  echo "HHVM version:"
  hhvm --version
else
  echo "MongoDB PHP Extension version:"
  php -i | grep '^mongodb version => '
fi

# enable text search
mongo --eval 'db.adminCommand( { setParameter: true, textSearchEnabled : true})'

cat /etc/mongodb.conf
