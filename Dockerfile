FROM UBUNTU_VERSION AS TigerGraph_Base
ENV DEBIAN_FRONTEND=noninteractive
RUN useradd -ms /bin/bash tigergraph
RUN apt-get -qq update && apt-get -qq upgrade && apt-get install -y --no-install-recommends sudo curl iproute2 net-tools cron ntp locales vim emacs wget git tar unzip jq uuid-runtime openssh-client openssh-server > /dev/null && \\
  mkdir /var/run/sshd && \\
  echo 'tigergraph:tigergraph' | chpasswd && \\
  echo "tigergraph ALL = NOPASSWD: /usr/sbin/sshd " >> /etc/sudoers && \\
  sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \\
  apt-get clean -y
FROM TigerGraph_Base
RUN curl -s -k -L PKG_NAME \\
    -o /home/tigergraph/tigergraph-dev.tar.gz && \\
  /usr/sbin/sshd && cd /home/tigergraph/ && \\
  tar xfz tigergraph-dev.tar.gz && \\
  rm -f tigergraph-dev.tar.gz && \\
  cd /home/tigergraph/tigergraph-* && \\
  cat utils/VERSION && \\
  INSTALL_COMMAND || : && \\
  mkdir -p /home/tigergraph/tigergraph/logs && \\
  rm -fR /home/tigergraph/tigergraph-* && \\
  rm -fR TG_ROOT_DIR/syspre_pkg && \\
  rm -f /home/tigergraph/tigergraph/gium_prod.tar.gz && \\
  rm -f /home/tigergraph/tigergraph/pkg_pool/tigergraph_*.tar.gz && \\
  cd /tmp && rm -rf /tmp/tigergraph-* && curl -s -k -L "https://github.com/tigergraph/ecosys/tarball/master" -o /tmp/ecosys.tgz && \\
  tar xzf ecosys.tgz && mv /tmp/tigergraph-ecosys-*/demos/guru_scripts/docker/tutorial /home/tigergraph/tutorial && \\
  chmod +x /home/tigergraph/tutorial/*/*/*.sh && \\
  curl -s -k -L "https://github.com/tigergraph/gsql-graph-algorithms/tarball/master" -o /tmp/algorithms.tgz && \\
  tar xzf algorithms.tgz && mv /tmp/tigergraph-gsql-graph-algorithms-* /home/tigergraph/gsql-graph-algorithms && \\
  rm -rf /tmp/*  && \\
  echo "export VISIBLE=now" >> /etc/profile && \\
  echo "export USER=tigergraph" >> /home/tigergraph/.bash_tigergraph && \\
  rm -f /home/tigergraph/.gsql_fcgi/RESTPP.socket.1 && \\
  mkdir -p /home/tigergraph/.gsql_fcgi && \\
  touch /home/tigergraph/.gsql_fcgi/RESTPP.socket.1 && \\
  chmod 644 /home/tigergraph/.gsql_fcgi/RESTPP.socket.1 && \\
  chown -R tigergraph:tigergraph /home/tigergraph && \\
  rm -f /etc/ssh/ssh_host* /home/tigergraph/.ssh/tigergraph_rsa* && \\
  su - tigergraph /bin/bash -c """/home/tigergraph/tigergraph/app/cmd/gadmin license status && /home/tigergraph/tigergraph/app/cmd/gadmin version""" && \\
  # Stop TigerGraph
  su - tigergraph -c "/home/tigergraph/tigergraph/app/cmd/gadmin stop all -y"
#COPY run_demo101.sh /home/tigergraph/tutorial/3.x/gsql101/
#COPY run_demo102.sh /home/tigergraph/tutorial/3.x/gsql102/
COPY entrypoint.sh /home/tigergraph/entrypoint.sh
EXPOSE 22
USER tigergraph
WORKDIR /home/tigergraph
ENTRYPOINT bash -c /home/tigergraph/entrypoint.sh
