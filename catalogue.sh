echo -e "\e[36m<<<<<<<<<<Create catalogue service>>>>>>>>>\e[0m"
cp catalogue.service \etc/systemd/system/catalogue.service &>/tmp/roboshop.log

echo -e "\e[36m<<<<<<<<<<Create Mongo repo>>>>>>>>>>>>>>\e[0m"
cp mongo.repo \etc/yum.repos.d/mongo.repo &>/tmp/roboshop.log

echo -e "\e[36m<<<<<<<<<Create nodejs repos>>>>>>>>\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>/tmp/roboshop.log

echo -e "\e[36m<<<<<<<<<Install nodejs>>>>>>>>>>>>\e[0m"
yum install nodejs -y &>/tmp/roboshop.log

echo -e "\e[36m<<<<<<<<Create user application>>>>>>>\e[0m"
useradd roboshop &>/tmp/roboshop.log

echo -e "\e[36m<<<<<<Create application directory>>>>>>>\e[0m"
rm -rf /app &>/tmp/roboshop.log

echo -e "\e[36m<<<<<<Create application directory>>>>>>>\e[0m"
mkdir /app &>/tmp/roboshop.log

echo -e "\e[36m<<<<<<<<Download application content>>>>>>>>>\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>/tmp/roboshop.log

echo -e "\e[36m<<<<<<<<<<<Extract application content>>>>>>>>>>>>\e[0m"
cd /app &>/tmp/roboshop.log
unzip /tmp/catalogue.zip &>/tmp/roboshop.log
cd /app &>/tmp/roboshop.log

echo -e "\e[36m<<<<<<<<<<Download nodejs dependencies>>>>>\e[0m"
npm install &>/tmp/roboshop.log

echo -e "\e[36m<<<<<<<<Install mongodb client>>>>>>>>>>\e[0m"
yum install mongodb-org-shell -y &>/tmp/roboshop.log

echo -e "\e[36m<<<<<<Load catalogue schemaa>>>>>>\e[0m"
mongo --host mongodb.chandana24.online </app/schema/catalogue.js &>/tmp/roboshop.log

echo -e "\e[36m<<<<<<<Start Catalogue service>>>>>>\e[0m"
systemctl daemon-reload &>/tmp/roboshop.log
systemctl enable catalogue &>/tmp/roboshop.log
systemctl restart catalogue &>/tmp/roboshop.log
