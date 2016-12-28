#!/bin/bash

get_fingerprints()
{
	local hosts=$(host $1 | rev | cut -f 1 -d " " | rev)

	for ip in $hosts; do
		openssl x509 -in <(openssl s_client -connect $ip:9999 2>/dev/null) -text -noout -fingerprint
	done 2>/dev/null | \
		grep -F 'SHA1 Fingerprint=' | \
		cut -d "=" -f 2 | \
		tr -d ':' | \
		paste -sd ","
}

weechat -d "$HOME/.config/weechat" -r "$(cat <<EOF
/set irc.look.smart_filter on
/filter add irc_smart * irc_smart_filter *

/server add freenode chat.freenode.net/6697 -ssl
/set irc.server.freenode.nicks bertptrs
/set irc.server.freenode.sasl_username bertptrs

/server add hackint irc.hackint.org/9999 -ssl
/set irc.server.hackint.ssl_fingerprint "$(get_fingerprints irc.hackint.org)"
/set irc.server.hackint.nicks bertptrs
/set irc.server.hackint.sasl_username bertptrs

/quit
EOF
)"
