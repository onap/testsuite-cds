#!/bin/sh

mkdir -p /home/cdstest/dev /home/cdstest/bin /home/cdstest/lib /home/cdstest/etc
cd /home/cdstest/dev
mknod -m 666 null c 1 3
mknod -m 666 tty c 5 0
mknod -m 666 zero c 1 5
mknod -m 666 random c 1 8
cp /bin/ash /bin/ls /bin/date /home/cdstest/bin/.
cp /lib/ld-musl-x86_64.so.1 /home/cdstest/lib/.
adduser cdstest <<EOF
testcds
testcds
EOF
chown root:root /home/cdstest
chmod 0755 /home/cdstest
cp /etc/passwd /etc/group /home/cdstest/etc/.