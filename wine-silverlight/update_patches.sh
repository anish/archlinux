#!/bin/bash

rm -rf ./wine-patches.tar.gz
rm -rf ./patches
wget http://fds-team.de/mirror/wine-patches.tar.gz
tar xzf wine-patches.tar.gz
i=0
for patch_file in `ls -1 ./patches`
do
	file_pr=`echo ${patch_file} | cut -d'-' -f1`
	if [ ! -e ${patch_file} ]
	then
		if [ -e ${file_pr}* ]
		then
#			rm ${file_pr}*
			git rm ${file_pr}*
		fi
	fi
	cp ./patches/${patch_file} .
	git add ${patch_file}
	files[$i]=${patch_file}
	i=$[$i+1]
done

cat PKGBUILD | grep prdownloads
for i in `seq 0 $[${#files[*]}-1]`
do
echo "        \"${files[i]}\""
done

cat PKGBUILD | grep aliases | head -n 1
echo

for i in `seq 0 $[${#files[*]}-1]`
do
echo "  patch -p1 <../"${files[i]}
done
