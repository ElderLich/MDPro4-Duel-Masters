# Versioned releases

Installable packages are published to [GitHub Releases](https://github.com/ElderLich/MDPro4-Duel-Masters/releases). Source stays in Git; generated YPK payloads stay outside ordinary source commits.

`VERSION` owns the package version. Use annotated SemVer tags: `vMAJOR.MINOR.PATCH`, or `vMAJOR.MINOR.PATCH-preview.N` while the stated acceptance remains incomplete. Increase MINOR for a feature step, PATCH for compatible fixes, and MAJOR for incompatible package contracts. Never move a published tag or replace its assets.

The initial package is `v0.1.0-preview.1` at source commit `2064fc4`. The host-integration pass targets `v0.2.0-preview.1`. Preview releases explicitly describe missing card coverage, native capacity limits and the required MDPro4 host revision.

## Prepare and publish

1. Finish and separately commit each coherent change with a subject and descriptive body. Update VERSION and version-specific notes under `docs/releases/`.
2. Build/test candidates outside Releases, e.g. `python tools/build_package.py --artwork-manifest build/artwork-manifest.json --output build/integration-candidate.ypk`. Run Python/Lua, actual native duel and saved-replay checks, plus affected host visual/lifetime checks.
3. Build the final payload with the same inputs and no output override. It lands in `Releases/v<VERSION>/MDPro4-Duel-Masters-v<VERSION>.ypk` with a `.sha256` sidecar. A different payload at that path is rejected; bump VERSION instead.
4. Create an annotated tag at the reviewed source commit. Push only the intended package branch and tag; this does not authorize pushing MDPro4's game repository.
5. Run `python tools/publish_release.py --tag <tag> --commit <full-commit> --notes docs/releases/<tag>.md --assets <ypk> <sha256> --receipt build/release-<tag>.json`. Authentication uses the existing Git credential helper without printing secrets.

The publisher verifies the remote tag target, uploads to a draft, checks SHA-256/size for every asset, then publishes and verifies the final asset records. Existing tags, notes and assets must match on retry; different content fails rather than overwriting a release. The release page owns downloads, not the repository Packages service.

`Releases/` and transient `build/` outputs are ignored by Git. Retain usable local release payloads independently of remote availability. External artwork inputs remain separately owned and are never deleted by release publication.
