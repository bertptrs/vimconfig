#!/bin/bash

weechat -d "$HOME/.config/weechat" -r "$(cat <<EOF
/set irc.look.smart_filter on
/filter add irc_smart * irc_smart_filter *

/server add freenode chat.freenode.net/6697 -ssl
/set irc.server.freenode.nicks bertptrs
/set irc.server.freenode.sasl_username bertptrs

/server add hackint irc.hackint.org/9999 -ssl
/set irc.server.hackint.ssl_fingerprint "bca257a7103b4517343eef06e99d1eaa8720d178,26e7b3a44952e34be77b31dbb928de891eb14c41,ebce621c05e9e79416598ca6b56184f1864ce961"
/set irc.server.hackint.nicks bertptrs
/set irc.server.hackint.sasl_username bertptrs

/quit
EOF
)"
