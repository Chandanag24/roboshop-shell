source common.sh

echo -e "\e[35m<<<<<<<<<<Install Nginx>>>>>>>>>\e[0m"
yum install nginx -y &>>${log}
func_exit_status

echo -e "\e[36m<<<<<<<<<<Copy Roboshop configuration>>>>>>>>>\e[0m"
cp nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log}
func_exit_status

echo -e "\e[34m<<<<<<<<<<Remove Old Content>>>>>>>>>\e[0m"
rm -rf /usr/share/nginx/html/* &>>${log}
func_exit_status

echo -e "\e[34m<<<<<<<<<<Download App Content>>>>>>>>>\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log}
func_exit_status

cd /usr/share/nginx/html &>>${log}

echo -e "\e[36m<<<<<<<<<<Extract App Content>>>>>>>>>\e[0m"
unzip /tmp/frontend.zip &>>${log}
func_exit_status

echo -e "\e[35m<<<<<<<<<<Start Frontend Service>>>>>>>>>\e[0m"
systemctl enable nginx &>>${log}
systemctl restart nginx &>>${log}
func_exit_status