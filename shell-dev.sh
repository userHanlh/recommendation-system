#!/bin/bash
#这里可替换为你自己的执行程序，其他代码无需更改
APP_NAME=servertest.jar
folderName="server_$(date -d "today" +"%Y%m%d_%H%M%S").jar.bak"
env="$2"
case "$2" in
  "locdev")
    APP_NAME=servertest.jar
    ;;
  "locqa")
    APP_NAME=servertest.jar
    ;;
esac


bak() {
    echo "bak() $APP_NAME"
    cp $APP_NAME bak/$folderName
}
#使用说明，用来提示输入参数
usage() {
    echo "Usage: sh 执行脚本.sh [start|stop|restart|status]"
    exit 1
}

#检查程序是否在运行
is_exist(){
    echo "is_exist()"
  pid=`ps -ef|grep $APP_NAME|grep -v grep|awk '{print $2}' `
  #如果不存在返回1，存在返回0
  if [ -z "${pid}" ]; then
  echo "pid=${pid} status:not running"
   return 1
  else
    echo "pid=${pid} status:running"
    return 0
  fi
}

#启动方法
start(){
  is_exist
  if [ $? -eq "0" ]; then
    echo "${APP_NAME} is already running. pid=${pid} ."
  else
    echo "starting"
    #nohup java -jar $APP_NAME --spring.profiles.active=$env > /dev/null 2>&1 &
	nohup java -jar $APP_NAME  &
    #tail -200f nohup.out
  fi
}

#停止方法
stop(){
    echo "stoping"
  is_exist
  if [ $? -eq "0" ]; then
    kill -9 $pid
    echo "stoped"
  else
    echo "stoped"
  fi
}


#更新最新的代码包
update(){
    echo "update"
    mv -f ready/$APP_NAME $APP_NAME
}

#输出运行状态
status(){
  is_exist
  if [ $? -eq "0" ]; then
    echo "status:${APP_NAME} is running. Pid is ${pid}"
  else
    echo "status:${APP_NAME} is NOT running."
  fi
}

#重启
restart(){
 echo "restart()"
  stop
  start
}

#根据输入参数，选择执行对应方法，不输入则执行使用说明
case "$1" in
  "start")
    start
    ;;
  "bak")
    bak
    ;;
  "stop")
    stop
    ;;
  "status")
    status
    ;;
  "restart")
    restart
    ;;
  "update")
    update
    ;;
  *)
    usage
    ;;
esac
