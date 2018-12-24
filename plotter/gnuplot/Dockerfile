FROM debian

# パッケージ導入
RUN apt update -y && apt install -y gnuplot5

# JSTにタイムゾーン設定
RUN ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

ENTRYPOINT  ["/usr/bin/gnuplot"]
# ENTRYPOINT  ["/bin/bash"]


