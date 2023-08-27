source common.sh

echo -e "\e[35m<<<<<<<<<<Install Nginx>>>>>>>>>\e[0m"
yum install nginx -y
func_exit_status

echo -e "\e[36m<<<<<<<<<<Copy Roboshop configuration>>>>>>>>>\e[0m"
cp nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf
func_exit_status

echo -e "\e[34m<<<<<<<<<<Remove Old Content>>>>>>>>>\e[0m"
rm -rf /usr/share/nginx/html/*
func_exit_status

echo -e "\e[34m<<<<<<<<<<Download App Content>>>>>>>>>\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
func_exit_status

cd /usr/share/nginx/html

echo -e "\e[36m<<<<<<<<<<Extract App Content>>>>>>>>>\e[0m"
unzip /tmp/frontend.zip
func_exit_status

echo -e "\e[35m<<<<<<<<<<Start Frontend Service>>>>>>>>>\e[0m"
systemctl enable nginx
systemctl restart nginx
func_exit_status