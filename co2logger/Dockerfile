FROM debian

# env設定
# ENV   PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# ENV   LANG=ja_JP.UTF-8

# パッケージ導入
RUN \
  apt update && apt -y install \
    ruby ruby-dev \
    libusb-1.0 libusb-dev libhidapi-dev libhidapi-hidraw0 \
    libffi-dev python2.7 python-pip && \
  gem install hidapi && \
  apt clean

# JSTにタイムゾーン設定
RUN ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# # スクリプト追加
# ADD ./*.rb /root/

ENTRYPOINT  ["ruby", "/root/co2logger.rb"]
# ENTRYPOINT  ["/bin/bash"]
