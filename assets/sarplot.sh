#!/usr/bin/env bash
set -Eeuo pipefail

sar_report="${1:-prof.bin}"
primary_device="${2:-eth0}"

tmpdir="$(mktemp -d)"
cp "$sar_report" "$tmpdir"
cd "$tmpdir"

export S_TIME_FORMAT=ISO
sar -f "$sar_report" -r | sed '1,2d;$d' >mem.dat
sar -f "$sar_report" -u | sed '1,2d;$d' >cpu.dat
sar -f "$sar_report" -n DEV --iface="$primary_device" | sed '1,2d;$d' >dev.dat
sar -f "$sar_report" -n SOCK | sed '1,2d;$d' >sock.dat

cat <<EOF | gnuplot >"stats.png"
set terminal png size 1600,900
set key autotitle columnhead
set xdata time
set timefmt "%H:%M:%S"
set format x "%H:%M:%S"
set yrange [0:*]

set grid
set style data lines
set autoscale

set multiplot layout 4,1 title "System Statistics"

set title "CPU"
plot "cpu.dat" using 1:(100 - column(8)) smooth freq title "%busy"

set title "Memory"
plot "mem.dat" using 1:5 smooth freq

set title "Net I/O"
plot "dev.dat" using 1:5 smooth freq, \
     "dev.dat" using 1:6 smooth freq

set title "Sockets"
plot "sock.dat" using 1:2 smooth freq
EOF

cd -
mv "$tmpdir/stats.png" .
rm -rf "${tmpdir:?}"
