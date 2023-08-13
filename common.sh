log=/tmp/roboshop.log

func_apppre() {
  echo -e "\e[35m<<<<<<<<<<Create User Service>>>>>>>>>\e[0m"
  cp ${component}.service /etc/systemd/system/${component}.service &>>log

  echo -e "\e[35m<<<<<<<<<<Create Application User>>>>>>>>>\e[0m"
  useradd roboshop &>>log

  echo -e "\e[36m<<<<<<<<<<Create App Dir>>>>>>>>>\e[0m"
  mkdir /app &>>log

  echo -e "\e[36m<<<<<<<<<<Download App Content>>>>>>>>>\e[0m"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip  &>>log

  echo -e "\e[34m<<<<<<<<<<Extract App Content>>>>>>>>>\e[0m"
  cd /app
  unzip /tmp/${component}.zip &>>log
  cd /app
}
func_systemd() {
  echo -e "\e[36m<<<<<<<<<<Start ${component} Service>>>>>>>>>\e[0m"
  systemctl daemon-reload &>>log
  systemctl enable ${component} &>>log
  systemctl restart ${component} &>>log
}
func_nodejs() {
  echo -e "\e[35m<<<<<<<<<<Create Mongo Repo>>>>>>>>>\e[0m"
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>log

  echo -e "\e[35m<<<<<<<<<<Create Nodejs Repos>>>>>>>>>\e[0m"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>log

  echo -e "\e[35m<<<<<<<<<<Install NodeJs>>>>>>>>>\e[0m"
  yum install nodejs -y &>>log

  func_apppre

  echo -e "\e[33m<<<<<<<<<<Install Dependencies>>>>>>>>>\e[0m"
  npm install &>>log

  echo -e "\e[34m<<<<<<<<<<Install mongodb client>>>>>>>>>\e[0m"
  yum install mongodb-org-shell -y &>>log

  echo -e "\e[32m<<<<<<<<<<Load Schema>>>>>>>>>\e[0m"
  mongo --host mongodb.chandana24.online </app/schema/${component}.js &>>log

  func_systemd
}

func_java() {
  echo -e "\e[36m<<<<<<<<<<Install Maven>>>>>>>>>\e[0m"
  yum install maven -y &>>log

  func_apppre

  echo -e "\e[36m<<<<<<<<<<Bulid ${component} Service>>>>>>>>>\e[0m"
  mvn clean package &>>log
  mv target/${component}-1.0.jar ${component}.jar &>>log

  echo -e "\e[36m<<<<<<<<<<Install MySql Client>>>>>>>>>\e[0m"
  yum install mysql -y &>>log
  # shellcheck disable=SC2261
  # shellcheck disable=SC2261

  echo -e "\e[36m<<<<<<<<Load Schema >>>>>>>>>\e[0m"
  mysql -h mysql.chandana24.online -uroot -pRoboShop@1 < /app/schema/ ${component}.sql &>>log

  func_systemd
}
func_python() {
  echo -e "\e[36m<<<<<<<<Install Python >>>>>>>>>\e[0m"
  yum install python36 gcc python3-devel -y  &>>log

  func_apppre

  echo -e "\e[36m<<<<<<<<Bulid ${component} Service>>>>>>>>>\e[0m"
  pip3.6 install -r requirements.txt  &>>log

  func_systemd
}