#!/bin/bash

# 実行script作成
sed s/%date%/$(date +%y%m%d)/g script/plot_template.gp  > script/tmp.gp
# 実行
docker-compose run --rm gnuplot /root/script/tmp.gp



