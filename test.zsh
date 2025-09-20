#!/bin/zsh
run() {
	local file=$1
	# Strip two filename extensions off $file
	local name=${file:r:r}
	echo -n "→ $name\r"
	if zsh $file; then
		echo "\033[0;32m✔\033[0;m $name"
	else
		echo "\033[0;31m✘\033[0;m $name"
	fi
}
pushd tests/
for f in *.test.zsh; do
	run $f;
done
