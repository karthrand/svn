
#内置变量(不可修改)
#svn配置文件地址
svn_conf="/var/opt/svn/svn/conf/svnserve.conf"
#用户密码配置文件地址
passwd_conf="/var/opt/svn/svn/conf/passwd"
#authz配置文件地址
authz_conf="/var/opt/svn/svn/conf/authz"


#--设置步骤--
flag=`cat /home/flag`

if [[ "${flag}" == "" ]];then
source /home/config
svnadmin create ${svn_name}
sleep 5s

#设置svnserve.conf
#1.设置匿名用户不可读写
anon_access_line=`sed -n '/^# anon-access/=' "${svn_conf}"`
sed -i ''${anon_access_line}'c anon-access = '${anon_access_set}'' ${svn_conf}

#2.设置授权用户可写
auth_access_line=`sed -n '/^# auth-access/=' "${svn_conf}"`
sed -i ''${auth_access_line}'c auth-access = write' ${svn_conf}

#3.设置用密码文件路径，相对于当前目录
password_db_line=`sed -n '/^# password-db/=' "${svn_conf}"`
sed -i ''${password_db_line}'c password-db = passwd' ${svn_conf}

#4.设置访问控制文件
authz_db_line=`sed -n '/^# authz-db/=' "${svn_conf}"`
sed -i ''${authz_db_line}'c authz-db = authz' ${svn_conf}

#5.认证命名空间，会在认证提示界面显示，并作为凭证缓存的关键字，可以写仓库名称比如svn
realm_line=`sed -n '/^# realm/=' "${svn_conf}"`
sed -i ''${realm_line}'c realm = /var/opt/svn/'${svn_name}'' ${svn_conf}


#配置账号与密码
echo "${username} = ${passwd}" >> ${passwd_conf}

#配置authz文件
group_line=`grep -n "^\[groups\]" ${authz_conf} |cut -d ':' -f 1`
sed -i ''${group_line}'a owner = '${username}'' ${authz_conf}

echo "[/]" >> ${authz_conf}
echo "${username} = rw" >> ${authz_conf}
echo "[svn:/]" >> ${authz_conf}
echo "@owner = rw" >> ${authz_conf}
#设置已初始化的标签
echo "created" > /home/flag
mv /home/config /var/opt/svn/
else
    source /var/opt/svn/config
    #更新用户名密码   
    sed -i '$d' ${passwd_conf}
    echo "${username} = ${passwd}" >> ${passwd_conf}

    #更新authz文件
    group_line=`grep -n "^\[groups\]" ${authz_conf} |cut -d ':' -f 1`
    group_line_next=`expr ${group_line} + 1`
    sed -i ''${group_line_next}'c owner = '${username}'' ${authz_conf}

    root_line=`grep -n "^\[/\]" ${authz_conf} |cut -d ':' -f 1`
    root_line_next=`expr ${root_line} + 1`
    sed -i ''${root_line_next}'c '${username}' = rw' ${authz_conf}

    #更新svnserve.conf文件
    anon_access_line=`sed -n '/^anon-access/=' "${svn_conf}"`
    sed -i ''${anon_access_line}'c anon-access = '${anon_access_set}'' ${svn_conf}
fi