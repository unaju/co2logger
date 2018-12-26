#!/bin/bash

cd $(dirname $0)

sed s/%date%/$(date +%y%m%d)/g script/plot_template.gp  > script/tmp.gp
docker-compose run --rm gnuplot /root/script/tmp.gp



