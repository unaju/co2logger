#!/bin/bash

cd $(dirname $0)

# 結合
cat ../data/co2-*.csv > ../data/co2tmp-all.csv
cat ../data/temp-*.csv > ../data/temptmp-all.csv

# plot
sed s/-%date%/tmp-all/g script/plot_template.gp  > script/tmp.gp
docker-compose run --rm gnuplot /root/script/tmp.gp



