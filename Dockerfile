FROM jenkins/jenkins:lts
LABEL maintainer="TinyWu <514965273@qq.com>"

ENV NEXUS_URL=http://172.19.226.8:8081

USER root

RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak && \
    echo 'deb http://mirrors.aliyun.com/debian/ stretch main non-free contrib' > /etc/apt/sources.list && \
    echo 'deb-src http://mirrors.aliyun.com/debian/ stretch main non-free contrib' >> /etc/apt/sources.list && \
    echo 'deb http://mirrors.aliyun.com/debian-security stretch/updates main' >> /etc/apt/sources.list && \
    echo 'deb-src http://mirrors.aliyun.com/debian-security stretch/updates main' >> /etc/apt/sources.list && \
    echo 'deb http://mirrors.aliyun.com/debian/ stretch-updates main non-free contrib' >> /etc/apt/sources.list && \
    echo 'deb-src http://mirrors.aliyun.com/debian/ stretch-updates main non-free contrib' >> /etc/apt/sources.list && \
    echo 'deb http://mirrors.aliyun.com/debian/ stretch-backports main non-free contrib' >> /etc/apt/sources.list && \
    echo 'deb-src http://mirrors.aliyun.com/debian/ stretch-backports main non-free contrib' >> /etc/apt/sources.list && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo 'Asia/Shanghai' >/etc/timezone && \
    apt-get update && apt-get install -y ansible git && rm -rf /var/lib/apt/lists/*

ADD sshpass_1.06-1_amd64.deb apache-maven-3.6.0-bin.tar.gz node-v8.9.4-linux-x64.tar /root/
ADD settings.xml /root/apache-maven-3.6.0/conf/

RUN dpkg -i /root/sshpass_1.06-1_amd64.deb && \
    sed -i 's/#host_key_checking = False/host_key_checking = False/g' /etc/ansible/ansible.cfg && \
    mv /root/apache-maven-3.6.0 /usr/local/apache-maven && \
    sed -i "s#http://192.168.1.206:8081#${NEXUS_URL}#g" /usr/local/apache-maven/conf/settings.xml && \
    mv /root/node-v8.9.4-linux-x64 /usr/local/node-v8.9.4

ENV MAVEN_HOME /usr/local/apache-maven
ENV NODE_HOME /usr/local/node-v8.9.4
ENV PATH $PATH:$MAVEN_HOME/bin:$NODE_HOME/bin:$NODE_HOME/lib/node_modules

RUN npm config set registry https://registry.npm.taobao.org && \
    npm install -g cnpm --registry=https://registry.npm.taobao.org
