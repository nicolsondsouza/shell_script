home=/home/ubuntu/deploy/
apphome=/home/ubuntu/myapp
meteorhome=/home/ubuntu/myapp/
appname="myapp"
bundlename="myapp.tar.gz"

####################

####################

####################

# METEOR_SETTINGS=$(cat $settings)


ROOT_URL='http://localhost:3000'
MONGO_URL='mongodb://localhost:27017/myapp?autoReconnect=true&connectTimeout=60000'
MONGO_OPLOG_URL='mongodb://localhost:27017/myapp?autoReconnect=true&connectTimeout=60000'
MAIL_URL='smtp://username%40tapmatrix.mailgun.org:password@smtp.mailgun.org:587'
PORT=80
###################

cd $apphome


git fetch --all
git reset --hard origin/master

cd $meteorhome

mkdir -p $appname

meteor build --server $ROOT_URL $home$appname/bundle

cd $home$appname/bundle
tar -xvf $bundlename
cd bundle/programs/server
npm install
cd .. 
cd ..
cd ..
pm2 stop $appname

rm -rf $home$appname/app
mkdir -p $home$appname/app

mv bundle/ ../app/

cd $home$appname/app/bundle

mv ./main.js ./$appname.js

export MONGO_URL=$MONGO_URL
export ROOT_URL=$ROOT_URL
export MAIL_URL=$MAIL_URL
export PORT=$PORT
export METEOR_SETTINGS="$METEOR_SETTINGS"
pm2 flush $appname
pm2 start $appname.js

exit