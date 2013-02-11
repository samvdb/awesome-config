# .zprofile

# Load environment settings from profile.env, which is created by
# env-update from the files in /etc/env.d
if [ -e /etc/profile.env ] ; then
	. /etc/profile.env
fi

# You should override these in your ~/.zprofile (or equivalent) for per-user
# settings.  For system defaults, you can add a new file in /etc/profile.d/.
#export EDITOR=${EDITOR:-/usr/bin/vim}
export EDITOR=/usr/bin/vim
#export PAGER=${PAGER:-/bin/less}
export PAGER=${PAGER:-/usr/bin/vimpager}

# 077 would be more secure, but 022 is generally quite realistic
umask 022

typeset -U path

shopts=$-
setopt nullglob
for sh in /etc/profile.d/*.sh ; do
	[ -r "$sh" ] && . "$sh"
done
unsetopt nullglob
set -$shopts
unset sh shopts
