# Linux Server Proxy

Mihomo configuration for a Linux server.

## Usage

Install or update Mihomo first:

```bash
./install_mihomo.sh
```

Check the configuration before starting:

```bash
./check.sh
```

Run from this repository directory:

```bash
mihomo -f config.yaml
```

## Change Proxy Node

After Mihomo is running, use the REST API on `127.0.0.1:9090` to switch the selected node in the `lakke` proxy group. For example, switch to `日本004`:

```bash
curl -sS -X PUT 'http://127.0.0.1:9090/proxies/lakke' \
  -H 'Content-Type: application/json' \
  -d '{"name":"日本004"}'
```

List available proxy groups and nodes:

```bash
curl -sS 'http://127.0.0.1:9090/proxies'
```

The current `config.yaml` enables `profile.store-selected: true`, so Mihomo stores the selected node after it is changed. If Mihomo is restarted with this same config directory, the previous node selection is kept.


## Files

- `config.yaml`: runtime Mihomo configuration.
- `install_mihomo.sh`: downloads and installs the latest Mihomo binary to `/usr/local/bin/mihomo`.
- `check.sh`: validates `config.yaml` with Mihomo.
- `cache.db`, `geoip.metadb`, logs, and other generated runtime files are intentionally excluded.

## Update

After pulling changes:

```bash
git pull
./install_mihomo.sh
./check.sh
mihomo -f config.yaml
```

## Security

This repository contains proxy node credentials in `config.yaml`. Keep the GitHub repository private unless the credentials have been removed or rotated.
