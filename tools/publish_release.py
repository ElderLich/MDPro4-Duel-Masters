"""Publish only verified, immutable package releases using Git's credential helper."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import urllib.error
import urllib.parse
import urllib.request

REPO = "ElderLich/MDPro4-Duel-Masters"
API = "https://api.github.com/repos/" + REPO


def request(url, token, method="GET", data=None, content_type="application/json"):
    headers = {"User-Agent": "MDPro4-Duel-Masters-release-tools", "Accept": "application/vnd.github+json",
               "Authorization": "Bearer " + token, "X-GitHub-Api-Version": "2022-11-28"}
    if data is not None:
        headers["Content-Type"] = content_type
        if isinstance(data, dict):
            data = json.dumps(data).encode()
    with urllib.request.urlopen(urllib.request.Request(url, headers=headers, method=method, data=data), timeout=120) as response:
        return json.load(response)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--tag", required=True)
    parser.add_argument("--commit", required=True)
    parser.add_argument("--notes", type=Path, required=True)
    parser.add_argument("--assets", nargs="+", type=Path, required=True)
    parser.add_argument("--receipt", type=Path, required=True)
    args = parser.parse_args()
    env = dict(os.environ, GIT_TERMINAL_PROMPT="0", GCM_INTERACTIVE="Never")
    result = subprocess.run(["git", "credential", "fill"], input=b"protocol=https\nhost=github.com\n\n",
                            stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, env=env, check=True)
    credential = dict(line.split("=", 1) for line in result.stdout.decode().splitlines() if "=" in line)
    token = credential["password"]
    tag = request(API + "/git/ref/tags/" + urllib.parse.quote(args.tag, safe=""), token)
    obj = tag["object"]
    if obj["type"] == "tag":
        obj = request(API + "/git/tags/" + obj["sha"], token)["object"]
    if obj["type"] != "commit" or obj["sha"] != args.commit:
        raise RuntimeError("Remote tag does not identify the reviewed commit")
    body = args.notes.read_text(encoding="utf-8")
    releases = request(API + "/releases?per_page=100", token)
    matches = [item for item in releases if item["tag_name"] == args.tag]
    if len(matches) > 1:
        raise RuntimeError("Ambiguous releases for tag")
    if matches:
        release = matches[0]
        if release["body"] != body:
            raise RuntimeError("Existing release notes differ; refusing overwrite")
    else:
        release = request(API + "/releases", token, "POST", {
            "tag_name": args.tag, "target_commitish": args.commit,
            "name": "MDPro4 Duel Masters " + args.tag,
            "body": body, "draft": True, "prerelease": "-" in args.tag,
            "make_latest": "false" if "-" in args.tag else "true"})
    uploaded = []
    for asset in args.assets:
        data = asset.read_bytes()
        expected = "sha256:" + hashlib.sha256(data).hexdigest()
        existing = next((item for item in release["assets"] if item["name"] == asset.name), None)
        if existing:
            if existing.get("digest") != expected or existing["size"] != len(data):
                raise RuntimeError("Existing release asset differs: " + asset.name)
            record = existing
        else:
            upload_url = release["upload_url"].split("{", 1)[0] + "?name=" + urllib.parse.quote(asset.name)
            record = request(upload_url, token, "POST", data, "application/octet-stream")
        if record.get("digest") != expected or record["size"] != len(data):
            raise RuntimeError("Uploaded release checksum mismatch: " + asset.name)
        uploaded.append({"name": asset.name, "size": len(data), "sha256": expected[7:],
                         "url": record["browser_download_url"]})
    if release["draft"]:
        release = request(API + "/releases/" + str(release["id"]), token, "PATCH", {"draft": False})
    verified = request(API + "/releases/tags/" + urllib.parse.quote(args.tag), token)
    if verified["draft"]:
        raise RuntimeError("Release still draft after publication")
    for item in uploaded:
        published = next(asset for asset in verified["assets"] if asset["name"] == item["name"])
        if published.get("digest") != "sha256:" + item["sha256"] or published["size"] != item["size"]:
            raise RuntimeError("Published asset verification failed: " + item["name"])
        item["url"] = published["browser_download_url"]
    receipt = {"tag": args.tag, "commit": args.commit, "url": verified["html_url"],
               "prerelease": verified["prerelease"], "assets": uploaded}
    args.receipt.parent.mkdir(parents=True, exist_ok=True)
    args.receipt.write_text(json.dumps(receipt, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(receipt), flush=True)


if __name__ == "__main__":
    main()
