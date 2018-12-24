set terminal png size 800,600
set out "/dev/null"

set xdata time
set timefmt "%s"
set format x "%m/%d\n%H:%M"

set ylabel "co2 [ppm]"
set yrange [300:1800]
set y2tics
set y2label "temp [C]"
set y2range [0:35]

set datafile separator ","
plot "/var/co2log/co2-%date%.csv" using ($1+(9*3600)):2 axis x1y1 with lp lt 1 title "co2"
replot "/var/co2log/temp-%date%.csv" using ($1+(9*3600)):2 axis x1y2 with lp lt 2 title "temp"

set out "/var/co2log/plot-%date%.png"
replot

