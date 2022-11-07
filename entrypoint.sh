#! /bin/bash
[ -f /home/tigergraph/.ssh/sshd_rsa ] || ssh-keygen -b 4096 -t rsa -f /home/tigergraph/.ssh/sshd_rsa -q -N ''
if [ ! -f /home/tigergraph/.ssh/tigergraph_rsa ]; then
  ssh-keygen -b 4096 -t rsa -f /home/tigergraph/.ssh/tigergraph_rsa -q -N ''
  cat /home/tigergraph/.ssh/tigergraph_rsa.pub > /home/tigergraph/.ssh/authorized_keys
fi
sudo /usr/sbin/sshd -h /home/tigergraph/.ssh/sshd_rsa
bash /home/tigergraph/config.sh 
/home/tigergraph/tigergraph/app/cmd/gadmin start all --auto-restart
tail -f /dev/null
