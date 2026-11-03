# Contributing to alt-hosts

Keep guest launchers, Docker recipes and media handling separate. Apple ROMs,
installer ISOs, `.toast` files, UTM bundles and qcow2 disks stay on the
operator's machine; never commit them. Haiku release images may be fetched
from official mirrors, but still live under gitignored `media/`.

Use Bash for new launchers. Do not add Python wrappers. Verify changed
scripts with `scripts/check.sh`.

Original code contributions are accepted under `MIT OR Apache-2.0`; prose uses
`CC-BY-4.0`. No CLA or DCO is required. Preserve your own authorship and
applicable upstream notices. See [LICENSING.md](LICENSING.md).

## Default versioning

Start first-party repositories at `0.1.0`. Read the current version from
`VERSION`. Unless the user explicitly specifies another version or policy,
increment the minor integer once per completed change set in this repository
and reset the patch to zero: `0.N.0` → `0.(N+1).0`. Keep the major at zero.
