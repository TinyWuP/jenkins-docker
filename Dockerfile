FROM jenkins/jenkins:lts

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

ADD ansible.cfg hosts /etc/ansible/
ADD sshpass_1.06-1_amd64.deb apache-maven-3.6.0-bin.tar.gz node-v8.9.4-linux-x64.tar /root/
ADD settings.xml /usr/local/apache-maven/conf

RUN dpkg -i /root/sshpass_1.06-1_amd64.deb

RUN mv /root/apache-maven-3.6.0 /usr/local/apache-maven && \
    mv /root/node-v8.9.4-linux-x64 /usr/local/node-v8.9.4

ENV MAVEN_HOME /usr/local/apache-maven
ENV NODE_HOME /usr/local/node-v8.9.4
ENV PATH $PATH:$MAVEN_HOME/bin:$NODE_HOME/bin:$NODE_HOME/lib/node_modules

RUN npm config set registry https://registry.npm.taobao.org && \
    npm install -g cnpm --registry=https://registry.npm.taobao.org
