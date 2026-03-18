#!/usr/bin/env python3
"""
Patch openclaw exec-approvals.json with all common system paths.
Safe to run multiple times — skips already-present entries.
"""
import json, uuid, time, os, glob

APPROVALS = os.path.expanduser("~/.openclaw/exec-approvals.json")

# Discover all executables in common bin dirs
def discover_paths():
    patterns = [
        "/usr/bin/*", "/usr/sbin/*", "/bin/*", "/sbin/*",
        "/usr/local/bin/*", "/usr/local/sbin/*",
        os.path.expanduser("~/.npm-global/bin/*"),
        os.path.expanduser("~/.local/bin/*"),
        os.path.expanduser("~/.cargo/bin/*"),
        os.path.expanduser("~/.openclaw/workspace/skills/*/bin/*"),
    ]
    paths = set()
    for pattern in patterns:
        for p in glob.glob(pattern):
            if os.path.isfile(p) and os.access(p, os.X_OK):
                paths.add(p)
    return sorted(paths)

# Also include fixed important paths that might not be discoverable
FIXED_PATHS = [
    "*",
    "/usr/bin/sudo", "/bin/sudo",
    "/usr/bin/bash", "/bin/bash",
    "/usr/bin/sh", "/bin/sh",
    "/usr/bin/zsh", "/bin/zsh",
    "/usr/bin/fish",
    "/usr/bin/python3", "/usr/bin/python",
    "/usr/local/bin/python3", "/usr/local/bin/python",
    "/usr/bin/node", "/usr/local/bin/node",
    "/usr/bin/npm", "/usr/local/bin/npm",
    "/usr/bin/npx", "/usr/local/bin/npx",
    "/usr/bin/docker", "/usr/bin/docker-compose",
    "/usr/local/bin/docker-compose",
]

def make_entry(path, now):
    return {
        "id": str(uuid.uuid4()),
        "pattern": path,
        "lastResolvedPath": path,
        "lastUsedAt": now,
    }

def main():
    with open(APPROVALS) as f:
        data = json.load(f)

    now = int(time.time() * 1000)

    discovered = discover_paths()
    all_paths = list(dict.fromkeys(FIXED_PATHS + discovered))  # dedup, preserve order

    added = 0
    for agent in data.get("agents", {}).values():
        al = agent.setdefault("allowlist", [])
        existing = {e.get("pattern") for e in al}

        # Also patch existing entries that are missing lastResolvedPath
        for e in al:
            if "lastResolvedPath" not in e and e.get("pattern", "") not in ("*",):
                e["lastResolvedPath"] = e["pattern"]
                e["lastUsedAt"] = now

        to_add = [make_entry(p, now) for p in all_paths if p not in existing]
        al[:0] = to_add
        added += len(to_add)

    with open(APPROVALS, "w") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)

    print(f"Added {added} entries ({len(discovered)} discovered + fixed paths)")
    print("Restarting openclaw gateway...")
    os.system("openclaw gateway restart")

if __name__ == "__main__":
    main()
