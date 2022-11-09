FROM ubuntu:18.04 AS tigergraph_base
ENV DEBIAN_FRONTEND=noninteractive
RUN useradd -ms /bin/bash tigergraph
RUN apt-get -qq update && apt-get -qq upgrade && apt-get install -y --no-install-recommends sudo curl iproute2 net-tools cron ntp locales vim emacs wget git tar unzip jq uuid-runtime openssh-client openssh-server > /dev/null && \
  mkdir /var/run/sshd && \
  echo 'tigergraph:tigergraph' | chpasswd && \
  echo "tigergraph ALL = NOPASSWD: /usr/sbin/sshd " >> /etc/sudoers && \
  sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
  apt-get clean -y

FROM tigergraph_base
RUN curl -s -k -L PKG_NAME \
    -o /home/tigergraph/tigergraph.tar.gz && \
  /usr/sbin/sshd && cd /home/tigergraph/ && \
  tar xfz tigergraph.tar.gz && \
  rm -f tigergraph.tar.gz && \
  cd /home/tigergraph/tigergraph-* && \
  cat utils/VERSION && \
  # INSTALL_COMMAND || : && \
  # mkdir -p /home/tigergraph/tigergraph/logs && \
  # chown -R tigergraph:tigergraph /home/tigergraph && \
  # rm -f /etc/ssh/ssh_host* /home/tigergraph/.ssh/tigergraph_rsa* && \
  # su - tigergraph /bin/bash -c """/home/tigergraph/tigergraph/app/cmd/gadmin license status && /home/tigergraph/tigergraph/app/cmd/gadmin version""" && \
  # # Stop TigerGraph
  # su - tigergraph -c "/home/tigergraph/tigergraph/app/cmd/gadmin stop all -y"
COPY entrypoint.sh /home/tigergraph/entrypoint.sh
EXPOSE 22
USER tigergraph
WORKDIR /home/tigergraph
ENTRYPOINT bash -c /home/tigergraph/entrypoint.sh
