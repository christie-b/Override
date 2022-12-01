#!/bin/sh

startvm()
{
	VBoxManage startvm override --type headless 2> /dev/null
	for i in $(ls */* | grep flag | sort -V)
	do
		printf "%s: %s\n" $i $(cat $i)
	done
	printf "Key in user: "
	read reply
	ssh ${reply}@192.168.56.103 -p 4242
}

# start32()
# {
# 	DOCKERFILE=$(cat << EOF
# FROM i386/ubuntu:trusty
# RUN apt-get update && apt-get install -y gcc python gdb g++ ltrace
# EOF
# 	)
# 	echo "$DOCKERFILE" | docker build -t ubuntu-i386 -
# 	docker run -ti -v $(pwd):/override -w /override ubuntu-i386 bash
# }

startclone()
{
	DOCKERFILE=$(cat << EOF
FROM ubuntu:trusty
RUN apt-get update && apt-get install -y gcc-4.6 python gdb g++ ltrace libc6-dev-i386
RUN echo "alias gcc=gcc-4.6" >> /root/.bashrc
EOF
	)
	echo "$DOCKERFILE" | docker build -t ubuntu-trusty -
	docker run -ti -v $(pwd):/override -w /override ubuntu-trusty bash
}

if [ $# -eq 0 ]
then
	echo "usage: ./do.sh override|clone"
	exit 1
fi

case $1 in
	# 32)			start32
	# 			;;
	clone)		startclone
				;;
	override)	startvm;
				;;
	*)			echo "Bad argument.";
				exit
				;;
esac

