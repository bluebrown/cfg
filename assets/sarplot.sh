#!/usr/bin/env bash
set -Eeuo pipefail

file="$(readlink -f "${1:-prof.bin}")"
iface="${2:-eth0}"

export S_TIME_FORMAT=ISO
sar -f "$file" -r | sed '1,2d;$d' >/tmp/mem.dat
sar -f "$file" -u | sed '1,2d;$d' >/tmp/cpu.dat
sar -f "$file" -n DEV --iface="$iface" | sed '1,2d;$d' >/tmp/dev.dat
sar -f "$file" -n SOCK | sed '1,2d;$d' >/tmp/sock.dat

cat <<EOF | gnuplot >"stats.png"
set terminal pngcairo dashed size 1600,900 background rgb "#0d1117"
set label font "Arial,12" textcolor rgb "#9198a1"
set xtics textcolor rgb "#9198a1"
set ytics textcolor rgb "#9198a1"
set style line 10 linecolor rgb "#6a6e7487" dashtype 3
set style line 1 lt 1 lc rgb "#4493f8"
set style line 2 lt 1 lc rgb "#3fb950"

set grid linestyle 10
set style data lines

set key autotitle columnhead outside textcolor rgb "#9198a1"

set xdata time
set timefmt "%H:%M:%S"
set format x "%H:%M:%S"
set yrange [0:*]
set autoscale

set multiplot layout 4,1 title "System Statistics" textcolor rgb "#9198a1" font "Arial,16"

set title "CPU" textcolor rgb "#9198a1"
plot "/tmp/cpu.dat" using 1:(100 - column(8)) ls 1 smooth freq title "%busy"

set title "Memory" textcolor rgb "#9198a1"
plot "/tmp/mem.dat" using 1:5 ls 1 smooth freq

set title "Net I/O" textcolor rgb "#9198a1"
plot "/tmp/dev.dat" using 1:5 ls 1 smooth freq, \
     "/tmp/dev.dat" using 1:6 ls 2 smooth freq

set title "Sockets" textcolor rgb "#9198a1"
plot "/tmp/sock.dat" using 1:2 ls 1 smooth freq
EOF
