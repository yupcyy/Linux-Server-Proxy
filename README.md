# Linux Server Proxy

Mihomo configuration for a Linux server.

## Usage

Run from this repository directory:

```bash
mihomo -f config.yaml
```

Check the configuration before starting:

```bash
mihomo -t -f config.yaml
```

## Files

- `config.yaml`: runtime Mihomo configuration.
- `cache.db`, `geoip.metadb`, logs, and other generated runtime files are intentionally excluded.

## Update

After pulling changes:

```bash
git pull
mihomo -t -f config.yaml
mihomo -f config.yaml
```

## Security

This repository contains proxy node credentials in `config.yaml`. Keep the GitHub repository private unless the credentials have been removed or rotated.

