#!/bin/bash

LOGS_PATH=/data/logs
YESTERDAY=$(date -d "yesterday" +%Y%m%d)

# 分割日志
for domain in `cat ${LOGS_PATH}/.split_list`; do
	# 限定 .log结尾 避免误删其他非日志文件
	mv ${LOGS_PATH}/${domain}.log ${LOGS_PATH}/${domain}.${YESTERDAY}.log
done

# 向 Nginx 主进程发送 USR1 信号。USR1 信号是重新打开日志文件
kill -USR1 $(cat /var/run/nginx.pid)

# 清理 60天以上日志文件
find ${LOGS_PATH} -name "*.log*" -type f -mtime +60 | xargs rm;

