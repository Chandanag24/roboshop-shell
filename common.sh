nodejs() {
  log=/tmp/roboshop.log

  echo -e "\e[35m<<<<<<<<<<Create User Service>>>>>>>>>\e[0m"
  cp ${component}.service /etc/systemd/system/${component}.service &>>log

  echo -e "\e[35m<<<<<<<<<<Create Mongo Repo>>>>>>>>>\e[0m"
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>log

  echo -e "\e[35m<<<<<<<<<<Create Nodejs Repos>>>>>>>>>\e[0m"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>log

  echo -e "\e[35m<<<<<<<<<<Install NodeJs>>>>>>>>>\e[0m"
  yum install nodejs -y &>>log

  echo -e "\e[35m<<<<<<<<<<Create Application User>>>>>>>>>\e[0m"
  useradd roboshop &>>log

  echo -e "\e[36m<<<<<<<<<<Create App Dir>>>>>>>>>\e[0m"
  mkdir /app &>>log

  echo -e "\e[36m<<<<<<<<<<Download App Content>>>>>>>>>\e[0m"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip  &>>log

  echo -e "\e[34m<<<<<<<<<<Extract App Content>>>>>>>>>\e[0m"
  cd /app &>>log
  unzip /tmp/${component}.zip &>>log
  cd /app &>>log

  echo -e "\e[33m<<<<<<<<<<Install Dependencies>>>>>>>>>\e[0m"
  npm install &>>log

  echo -e "\e[34m<<<<<<<<<<Install mongodb client>>>>>>>>>\e[0m"
  yum install mongodb-org-shell -y &>>log

  echo -e "\e[32m<<<<<<<<<<Load Schema>>>>>>>>>\e[0m"
  mongo --host mongodb.chandana24.online </app/schema/${component}.js &>>log

  echo -e "\e[36m<<<<<<<<<<Start User Service>>>>>>>>>\e[0m"
  systemctl daemon-reload &>>log
  systemctl enable ${component} &>>log
  systemctl restart ${component} &>>log
}