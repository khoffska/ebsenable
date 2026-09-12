# AGENTS.md — ebsenable

Context for AI coding agents (Claude Code, Codex, opencode, Cursor, …) working in this repo.
Read this first; keep it current.

## What this is
A parked set of one-off AWS ops scripts from 2022 for account-wide hardening: enable EBS default
encryption in every region, set a KMS key on SNS topics, and bulk-tag EC2 instances. These are
ad-hoc CLI helpers, not a maintained tool. No CI, no tests, no build.

## Layout
- `ebsenable.py` — boto3: list all regions, enable EBS default encryption where it's off.
- `ebsenable.sh` — shell twin; loops over `regions.txt` (not committed). Buggy — see Gotchas.
- `snsenable.py` — SNS/KMS variant; copy-paste broken, cannot run (see Gotchas).
- `snsenable.sh` — sets `KmsMasterKeyId` on every SNS topic from `topics.txt` (generated, not committed).
- `tag.sh` — prompts for a tag Key/Value and applies it to every instance ID in `instances.txt` (not committed).

## Commands
Run directly with AWS credentials in the environment, e.g. `python3 ebsenable.py`, `bash tag.sh`.
No install/build/test/lint tooling in-repo.

## Conventions
- Branch → PR if you change anything; don't push to `main`.
- Never commit credentials, `.env`, or the `regions.txt` / `instances.txt` / `topics.txt` inputs.

## Gotchas
- `snsenable.py` is not runnable: it references undefined `client` / `ssm` and calls EBS APIs
  (`get_ebs_encryption_by_default`, `enable_ebs_encryption_by_default`) on SNS topics.
- `ebsenable.sh` exports `AWS_REGION` *after* the `aws ec2 enable-ebs-encryption-by-default` call
  and never passes `--region`, so it re-targets the wrong region; prefer the Python version.
- `ebsenable.py`'s module-level `AWS_REGION = 'eu-west-1'` is only used to build the region list;
  the loop re-creates a client per region.
- The scripts mutate every region of the live account immediately — no dry-run, no confirmation.
