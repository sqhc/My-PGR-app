#!/usr/bin/env python3
"""Turn dropped catalogue images into valid Xcode imagesets.

Usage:
    python3 Scripts/build_imagesets.py            # generate from _incoming_images/
    python3 Scripts/build_imagesets.py --check     # report status, change nothing

The naming contract is the whole point of this script:

    GameData.json "image" value  ==  imageset name  ==  source file name

so a new character needs one file in one place, and nothing else can drift.

Source files are looked up in _incoming_images/ by stem, in any of the
supported extensions. Each one becomes:
    OnboradingExperience/Assets.xcassets/<Key>.imageset/<Key>.<ext>
    OnboradingExperience/Assets.xcassets/<Key>.imageset/Contents.json
"""

from __future__ import annotations

import argparse
import json
import shutil
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CATALOG = ROOT / "OnboradingExperience" / "Assets.xcassets"
GAME_DATA = ROOT / "OnboradingExperience" / "Resources" / "GameData.json"
INCOMING = ROOT / "_incoming_images"

# Only formats iOS reads back out of an asset catalog.
SUPPORTED = (".png", ".jpg", ".jpeg", ".heic", ".webp")

# Referenced by code or by the system, not by the catalogue.
CODE_REFERENCED = {
    "welcome_1", "welcome_2", "welcome_3", "welcome_4", "welcome_5",
    "AppIcon", "AccentColor",
}

CONTENTS = {
    "images": [{"idiom": "universal", "filename": None}],  # filename filled in per imageset
    "info": {"author": "xcode", "version": 1},
}


def catalogue_keys() -> list[str]:
    """Every `image` value in the catalogue, in file order."""
    data = json.loads(GAME_DATA.read_text(encoding="utf-8"))
    keys = [item["image"] for item in data.get("characters", [])]
    keys += [item["image"] for item in data.get("organizations", [])]
    return keys


def find_source(key: str) -> Path | None:
    """The dropped file for `key`, whatever extension it arrived in."""
    for extension in SUPPORTED:
        candidate = INCOMING / f"{key}{extension}"
        if candidate.is_file():
            return candidate
        # Tolerate upper-case extensions such as .PNG or .JPG.
        for found in INCOMING.glob(f"{key}.*"):
            if found.is_file() and found.suffix.lower() == extension:
                return found
    return None


def installed_keys() -> dict[str, Path]:
    """Catalogue keys that already have a complete imageset on disk."""
    installed: dict[str, Path] = {}
    if not CATALOG.is_dir():
        return installed
    for entry in CATALOG.iterdir():
        if entry.suffix != ".imageset":
            continue
        contents = entry / "Contents.json"
        payload = list(entry.glob(f"{entry.stem}.*"))
        if contents.is_file() and payload:
            installed[entry.stem] = entry
    return installed


def write_imageset(key: str, source: Path) -> bool:
    """Create or refresh `<Key>.imageset` for `source`. Returns True if written."""
    target = CATALOG / f"{key}.imageset"
    desired = target / f"{key}{source.suffix.lower()}"
    wanted = {desired.resolve()}

    # Drop any previous payload (a different extension, say).
    if target.is_dir():
        for existing in target.iterdir():
            if existing.is_file() and existing.resolve() not in wanted:
                existing.unlink()

    target.mkdir(parents=True, exist_ok=True)
    if source.resolve() != desired.resolve():
        shutil.copy2(source, desired)

    manifest = json.loads(json.dumps(CONTENTS))
    manifest["images"][0]["filename"] = desired.name
    (target / "Contents.json").write_text(
        json.dumps(manifest, indent=2) + "\n", encoding="utf-8"
    )
    return True


def report(keys: list[str]) -> tuple[list[str], list[str]]:
    """Print status and return (installed, missing) key lists."""
    installed = installed_keys()
    ok, missing = [], []
    for key in dict.fromkeys(keys):
        (ok if key in installed else missing).append(key)

    orphans = sorted(set(installed) - set(keys) - CODE_REFERENCED)

    print(f"catalogue keys      : {len(set(keys))}")
    print(f"imagesets installed : {len(ok)}")
    print(f"imagesets missing   : {len(missing)}")
    print(f"unreferenced imagesets: {len(orphans)}")
    if missing:
        print("\nmissing (drop a file named <key>.<png|jpg|...> into _incoming_images/):")
        for key in missing:
            print(f"  - {key}")
    if orphans:
        print("\nunreferenced (delete or reference these):")
        for key in orphans:
            print(f"  - {key}")
    return ok, missing


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="report only, write nothing")
    args = parser.parse_args()

    if not GAME_DATA.is_file():
        print(f"error: {GAME_DATA} not found", file=sys.stderr)
        return 2

    keys = catalogue_keys()

    if not args.check:
        installed = installed_keys()
        generated = 0
        for key in dict.fromkeys(keys):
            if key in installed:
                continue
            source = find_source(key)
            if source is None:
                continue
            write_imageset(key, source)
            generated += 1
            print(f"generated {key}.imageset from {source.name}")
        if generated:
            print()

    in_tree = installed_keys()
    ok, missing = report(keys)
    return 0 if not missing else 1


if __name__ == "__main__":
    raise SystemExit(main())
