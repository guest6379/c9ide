# ------------------------------------------------------------------------------
# Based on a work at https://github.com/docker/docker.
# ------------------------------------------------------------------------------
# Pull base image.
FROM kdelfour/supervisor-docker
MAINTAINER Kevin Delfour <kevin@delfour.eu>

# ------------------------------------------------------------------------------
# Install base
# archive.ubuntu.com = /etc/apt/sources.list
RUN apt-get update && apt-get install -y build-essential g++ curl libssl-dev apache2-utils git libxml2-dev sshfs vim python-pip
RUN locale-gen en_US.UTF-8 && echo "export LC_ALL=en_US.UTF-8" >> ~/.bashrc
RUN echo 'Asia/Chongqing' >/etc/timezone && dpkg-reconfigure -f noninteractive tzdata


# ------------------------------------------------------------------------------
# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get install -y nodejs
    
# ------------------------------------------------------------------------------
# Install Cloud9
RUN git clone https://github.com/c9/core.git /cloud9
WORKDIR /cloud9
RUN scripts/install-sdk.sh

# Tweak standlone.js conf
ADD standalone.js /cloud9/configs/standalone.js
RUN sed -i -e 's_127.0.0.1_0.0.0.0_g' /cloud9/configs/standalone.js


# Add supervisord conf
ADD conf/cloud9.conf /etc/supervisor/conf.d/

# ------------------------------------------------------------------------------
# Add volumes
RUN mkdir /workspace
VOLUME /workspace

# ------------------------------------------------------------------------------
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ------------------------------------------------------------------------------
# Expose ports.
EXPOSE 80
EXPOSE 3000
EXPOSE 8080

# ------------------------------------------------------------------------------
# Start supervisor, define default command.
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
