

FROM ubuntu:16.04
MAINTAINER Kevin Delfour <kevin@delfour.eu>

ENV DEBIAN_FRONTEND noninteractive

# ------------------------------------------------------------------------------
# Install base
#RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
#RUN cat /etc/apt/sources.list
#RUN sed -i 's/archive.ubuntu.com/mirrors.163.com/g' /etc/apt/sources.list
RUN apt-get update && apt-get install -y dialog tzdata locales apt-utils debconf git curl build-essential nodejs python2.7 vim
#RUN apt-get update && apt-get install -y build-essential g++ curl libssl-dev apache2-utils git libxml2-dev sshfs vim python-pip nethogs
RUN locale-gen en_US.UTF-8 && echo "export LC_ALL=en_US.UTF-8" >> ~/.bashrc
#RUN echo 'Asia/Shanghai' > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata
RUN ln -fs /usr/share/zoneinfo/Asia/Chongqing /etc/localtime && dpkg-reconfigure -f noninteractive tzdata
#ADD .vimrc /root/.vimrc


# checkout c9core and install it
# RUN git clone https://gitee.com/l1191871/c9core.git c9sdk
RUN git clone https://github.com/c9/core.git c9sdk
RUN cd /c9sdk && scripts/install-sdk.sh


RUN mkdir /wksp
VOLUME /wksp

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose ports.
EXPOSE 80
EXPOSE 8080

CMD ["nodejs", "/c9sdk/server.js", "--listen","0.0.0.0", "--port", "80", "-w", "/wksp", "--auth", "user:passwd"]

