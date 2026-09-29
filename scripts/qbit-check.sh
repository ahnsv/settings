#!/usr/bin/env bash
# qBittorrent + Surfshark connection check. Usage: qbit-check.sh [profile_dir]
# Bottom-up: stops at the first failing layer and says what to do.
PROFILE="${1:-$HOME/qbt-profiles/surfshark}"
INI="$PROFILE/qBittorrent/config/qBittorrent.ini"
LOG="$PROFILE/qBittorrent/data/logs/qbittorrent.log"
TRACKER_HOST=tracker.opentrackr.org
ok()   { printf 'OK   %s\n' "$*"; }
fail() { printf 'FAIL %s\n' "$*"; exit 1; }

# 1. tunnel up (Surfshark WireGuard uses 10.14.x.x)
TUN=$(ifconfig | awk '/^utun/{i=$1} /inet 10\.14\./{sub(":","",i); print i; exit}')
[ -n "$TUN" ] && ok "tunnel: $TUN" || fail "Surfshark not connected (no 10.14.x.x interface)"

# 2. DNS
IP=$(dig +short +time=3 +tries=1 "$TRACKER_HOST" | head -1)
[ -n "$IP" ] && ok "dns: $TRACKER_HOST -> $IP" || fail "DNS failed; turn off CleanWeb or check resolver"

# 3. route goes through the tunnel
IF=$(route -n get "$IP" | awk '/interface:/{print $2}')
[ "$IF" = "$TUN" ] && ok "route: via $IF" || fail "route via $IF, not $TUN; turn off Bypasser/split tunneling"

# 4. reachability (UDP result is weak evidence: only means no ICMP unreachable)
nc -zv -w 5 "$IP" 443 >/dev/null 2>&1 && ok "tcp/443 reachable" || fail "tcp/443 blocked; change server or protocol"
nc -zuv -w 5 "$IP" 1337 >/dev/null 2>&1 && ok "udp/1337 no ICMP reject (weak)" || echo "WARN udp/1337 rejected"

# 5. qBittorrent binding matches the live tunnel
SAVED=$(awk -F= '/^Session\\InterfaceName=/{print $2}' "$INI" 2>/dev/null)
if [ -z "$SAVED" ]; then echo "INFO qBittorrent: bound to any interface"
elif [ "$SAVED" = "$TUN" ]; then ok "qBittorrent bound to $SAVED"
else fail "qBittorrent bound to stale '$SAVED', tunnel is '$TUN'; Options > Advanced > Network interface"
fi
grep -E "interface is invalid|Successfully listening" "$LOG" 2>/dev/null | tail -n 3
