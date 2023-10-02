I forgot to [disable Klipper](https://rancher.com/docs/k3s/latest/en/networking/#disabling-the-service-lb), the K3s-provided load balancer.

Edit the /etc/systemd/system/k3s.service file. It looks like this:

```bash
ExecStart=/usr/local/bin/k3s \
    server \
```

Yeah, I don’t know what that trailing backslash is doing there.

Edit it so that it looks like this:

```bash
ExecStart=/usr/local/bin/k3s \
    server --disable servicelb \
```

Then restart:

```bash
sudo systemctl daemon-reload && sudo systemctl restart k3s
```