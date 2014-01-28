#! /bin/sh
#
#  Options
#
#    -r     Restart server
#    -d     Delete DB and restart server

dbname=exominer
if [ ! -z $1 ] ; then
  dbname=$1
  shift
fi

echo Starting DB $dbname

if [ "$1" = "-r" ]; then
  killall 4s-httpd
  killall 4s-backend
fi

if [ "$1" = "-d" ]; then
  killall 4s-httpd
  killall 4s-backend
  4s-backend-setup $dbname
fi


4s-backend $dbname
4s-httpd -p 8081 $dbname

