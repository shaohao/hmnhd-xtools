export BINUTILS_VERSION=2.18
export LINUX_VERSION=2.6.31.14
export EGLIBC_VERSION=2.7
export GCC_VERSION=4.3.2
export BUSYBOX_VERSION=1.20.2

export BUILD=x86_64-pc-linux-gnu
export HOST=$BUILD
export TARGET=armel-unknown-linux-gnueabi

export TOP=$PWD
export TOOLS=$TOP/tools
export SRC=$TOP/sources
export BLD=$TOP/build

export ROOTFS=$TOP/rootfs

export SYSROOT=$TOOLS/sysroot

export PS1="\[\e[33;1m\]hmnhd-xtools\[\e[0;0m\] > "
alias ls='ls --color=auto --show-control-chars'
alias ll='ls -l'

set -o emacs
bind '"\e[A": previous-history'
bind '"\e[B": next-history'
bind '"\e[C": forward-char'
bind '"\e[D": backward-char'
bind '"\C-j": history-search-forward'
bind '"\C-k": history-search-backward'
bind '"\e[7~": beginning-of-line'
bind '"\e[8~": end-of-line'
bind '"\e[3~": delete-char'

stage()
{
	local sn
	local s

	time {
		for s in $TOP/scripts/*.stage; do
			sn=$(echo $s | awk -F/ '{ print $NF; }' | cut -d. -f1)
			mkdir -p $BLD $TOOLS

			if [[ ! -f $BLD/${sn}.log ]]; then
				cd $BLD

				echo "   START stage $sn on $(date -R)"

				$TOP/scripts/stage $sn &> ${sn}.log

				if [[ $? -eq 0 ]]; then
					echo "FINISHED stage $sn on $(date -R)"
					echo
					cd $TOP
				else
					break
				fi
			fi
		done
	}
}

# ex: ts=4 sw=4 ft=sh
