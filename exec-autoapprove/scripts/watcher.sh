#!/bin/bash
# openclaw exec-autoapprove watcher daemon
# Monitors exec-approvals.json and auto-adds any new resolved path

APPROVALS="$HOME/.openclaw/exec-approvals.json"
SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LAST_HASH=""

log() { echo "[$(date '+%H:%M:%S')] $*"; }

# Process the file: find any entries missing lastResolvedPath (newly added by openclaw on popup)
# and promote them to full allowlist entries, then restart gateway
process_new_entries() {
    python3 - <<'PYEOF'
import json, uuid, time, os, subprocess

APPROVALS = os.path.expanduser("~/.openclaw/exec-approvals.json")

try:
    with open(APPROVALS) as f:
        data = json.load(f)
except Exception as e:
    print(f"Error reading config: {e}")
    exit(1)

now = int(time.time() * 1000)
promoted = 0

for agent in data.get("agents", {}).values():
    al = agent.get("allowlist", [])
    existing_patterns = {e.get("pattern") for e in al}

    for e in al:
        # Entries openclaw adds on "Always allow" have lastResolvedPath but may lack id
        # Entries added externally may lack lastResolvedPath
        if "lastResolvedPath" not in e and e.get("pattern") not in (None, "*"):
            e["lastResolvedPath"] = e["pattern"]
            e["lastUsedAt"] = now
            promoted += 1
            print(f"Promoted: {e['pattern']}")

        # If there's a lastResolvedPath different from pattern, also add the resolved path
        resolved = e.get("lastResolvedPath")
        if resolved and resolved not in existing_patterns and resolved != e.get("pattern"):
            new_entry = {
                "id": str(uuid.uuid4()),
                "pattern": resolved,
                "lastResolvedPath": resolved,
                "lastUsedAt": now,
            }
            al.insert(0, new_entry)
            existing_patterns.add(resolved)
            promoted += 1
            print(f"Added resolved path: {resolved}")

if promoted > 0:
    with open(APPROVALS, "w") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
    print(f"Wrote {promoted} updates, restarting gateway...")
    subprocess.run(["openclaw", "gateway", "restart"], capture_output=True)
    print("Gateway restarted.")
else:
    print("No new paths to add.")
PYEOF
}

log "Watcher started. Monitoring $APPROVALS"

# Initial pass
process_new_entries

# Watch for changes
while true; do
    # Wait for file change (timeout 30s so we can loop and check)
    inotifywait -q -t 30 -e close_write "$APPROVALS" 2>/dev/null
    EXIT=$?

    if [ $EXIT -eq 0 ]; then
        # File was modified
        CURRENT_HASH=$(md5sum "$APPROVALS" 2>/dev/null | cut -d' ' -f1)
        if [ "$CURRENT_HASH" != "$LAST_HASH" ]; then
            log "Change detected, processing..."
            process_new_entries
            LAST_HASH="$CURRENT_HASH"
        fi
    fi
    # EXIT=2 means timeout — just loop again
done
