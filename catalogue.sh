echo -e "/e[31m<<<<<<<<<<Create catalogue service>>>>>>>>>/e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service

echo -e "/e[31m<<<<<<<<<<Create Mongo repo>>>>>>>>>>>>>>/e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "/e[31m<<<<<<<<<Create nodejs repos>>>>>>>>/e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "/e[31m<<<<<<<<<Install nodejs>>>>>>>>>>>>/e[0m"
yum install nodejs -y

echo -e  "/e[31m<<<<<<<<Create user application>>>>>>>/e[0m"
useradd roboshop

echo -e  "/e[31m<<<<<<Create application directory>>>>>>>/e[0m"
mkdir /app

echo -e "/e[31m<<<<<<<<Download application content>>>>>>>>>/e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

echo -e "/e[31m<<<<<<<<<<<Extract application content>>>>>>>>>>>>/e[0m"
cd /app
unzip /tmp/catalogue.zip
cd /app

echo -e "/e[31m<<<<<<<<<<Download nodejs dependencies>>>>>/e[0m"
npm install

echo -e "/e[31m<<<<<<<<Install mongodb client>>>>>>>>>>/e[0m"
yum install mongodb-org-shell -y

echo -e "/e[31m<<<<<<Load catalogue schemaa>>>>>>/e[0m"
mongo --host mongodb.chandana24.online </app/schema/catalogue.js

echo -e "/e[31m<<<<<<<Start Catalogue service>>>>>>/e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue
