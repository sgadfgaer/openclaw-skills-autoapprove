#!/bin/bash
# Quick utility: add a single path to openclaw allowlist
# Usage: add-path.sh /path/to/binary

APPROVALS="$HOME/.openclaw/exec-approvals.json"

if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/binary"
    exit 1
fi

TARGET="$1"

python3 - "$TARGET" <<'PYEOF'
import json, uuid, time, os, sys

APPROVALS = os.path.expanduser("~/.openclaw/exec-approvals.json")
path = sys.argv[1]

with open(APPROVALS) as f:
    data = json.load(f)

now = int(time.time() * 1000)
added = False

for agent in data.get("agents", {}).values():
    al = agent.setdefault("allowlist", [])
    existing = {e.get("pattern") for e in al}
    if path not in existing:
        al.insert(0, {
            "id": str(uuid.uuid4()),
            "pattern": path,
            "lastResolvedPath": path,
            "lastUsedAt": now,
        })
        added = True

if added:
    with open(APPROVALS, "w") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
    print(f"Added: {path}")
    os.system("openclaw gateway restart")
else:
    print(f"Already exists: {path}")
PYEOF
