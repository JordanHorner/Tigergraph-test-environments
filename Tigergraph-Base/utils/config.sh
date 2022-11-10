#! /bin/bash
gadmin start infra
gadmin start all
gadmin config set RESTPP.Factory.EnableAuth true
gadmin config apply -y
gadmin restart gsql gui nginx restpp -y
