echo "<<<<<<<<<<Create catalogue service>>>>>>>>>>"
cp catalogue.service /etc/systemd/system/catalogue.service

echo "<<<<<<<<<<Create Mongo repo>>>>>>>>>>>>>>>"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo "<<<<<<<<<Create nodejs repos>>>>>>>>>"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo "<<<<<<<<<Install nodejs>>>>>>>>>>>>>"
yum install nodejs -y

echo "<<<<<<<<Create user application>>>>>>>>"
useradd roboshop

echo "<<<<<<Create application directory>>>>>>>>"
mkdir /app

echo "<<<<<<<<Download application content>>>>>>>>>>"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

echo "<<<<<<<<<<<extract application content>>>>>>>>>>>>>"
cd /app
unzip /tmp/catalogue.zip
cd /app

echo "<<<<<<<<<<Download nodejs dependencies>>>>>>"
npm install

echo "<<<<<<<<Install mongodb client>>>>>>>>>>>"
yum install mongodb-org-shell -y

echo "<<<<<<<Load catalogue schemaa>>>>>>>"
mongo --host mongodb.chandana24.online </app/schema/catalogue.js

echo "<<<<<<<Start Catalogue service>>>>>>>"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue
