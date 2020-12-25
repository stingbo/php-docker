#!/usr/bin/env bash

CUR_PATH=$(cd "$(dirname "$0")"; pwd)

# 要定时执行的任务
TASK_COMMAND1="/usr/local/bin/php /var/www/code/project1/artisan schedule:run"
TASK_COMMAND2="/usr/local/bin/php /var/www/code/project1/artisan schedule:run"
# 要添加的crontab任务
CRONTAB_TASK1="* * * * * ${TASK_COMMAND1}"
CRONTAB_TASK2="* * * * * ${TASK_COMMAND2}"
# 备份原始crontab记录文件
CRONTAB_BAK_FILE="${CUR_PATH}/crontab_bak"

# 创建crontab任务函数
create_crontab()
{
    #echo 'Create crontab task...' #docker里不能输出
    crontab -u www-data -l > ${CRONTAB_BAK_FILE} 2>/dev/null
    # 已存在任务时会被sed删除，防止重复添加，使用\?内容?d匹配删除，因为路径里含有斜线/
    sed -i "\?.*${TASK_COMMAND1}?d" ${CRONTAB_BAK_FILE}
    sed -i "\?.*${TASK_COMMAND2}?d" ${CRONTAB_BAK_FILE}
    echo "${CRONTAB_TASK1}" >> ${CRONTAB_BAK_FILE}
    echo "${CRONTAB_TASK2}" >> ${CRONTAB_BAK_FILE}
    crontab -u www-data ${CRONTAB_BAK_FILE}

    #echo 'Complete'
}

# 清除crontab任务函数
clear_crontab()
{
    echo 'Delete crontab task...'
    crontab -u www-data -l > ${CRONTAB_BAK_FILE} 2>/dev/null
    sed -i "/.*/d" ${CRONTAB_BAK_FILE}
    crontab -u www-data ${CRONTAB_BAK_FILE}

    echo 'Complete'
}

if [ $# -lt 1 ]; then
    echo "Usage: $0 [start | stop]"
    exit 1
fi

case $1 in
    'start' )
        create_crontab
        ;;
    'stop' )
        clear_crontab
        ;;
esac
