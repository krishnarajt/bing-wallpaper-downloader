# Bing wallpaper downloader

Downloads the daily Bing wallpaper into a persistent folder.

## Controls

Use these two values to control runtime behavior:

1. `HOST_STORAGE_PATH`: absolute path on the server/host where images are stored.
2. `TRIGGER_SCHEDULE`: cron expression for when downloads run.

## Docker Compose

Set environment variables and start:

```powershell
$env:HOST_STORAGE_PATH = "D:/data/bing-wallpaper"
$env:TRIGGER_SCHEDULE = "0 */6 * * *"
docker compose up -d --build
```

Optional:
- `MARKET` (default `en-US`)

## k3s (Kustomize base)

Edit [`k8s/base/settings-configmap.yaml`](k8s/base/settings-configmap.yaml):
- `data.hostStoragePath`
- `data.triggerSchedule`

Apply:

```powershell
kubectl apply -k k8s/base
```

Notes:
- Build/push the image referenced in [`k8s/base/cronjob.yaml`](k8s/base/cronjob.yaml) and set the correct `image` value for your cluster.
- `hostStoragePath` must be an absolute path on the k3s node.
