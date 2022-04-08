## Built singularity images
```
sudo singularity build --sandbox ood.dex.local.sif ood.def
sudo singularity build --sandbox ood.httpd.local.sif ood.def

```

## Start singularity container
```
sudo singularity exec --add-caps all --allow-setuid --writable ood.httpd.local.sif bash
sudo singularity exec --writable ood.dex.local.sif bash
```

### HTTPD container
```
cat /etc/ood/dex/ondemand.secret
/usr/sbin/httpd -DFOREGROUND
```

### DEX container
```
vim /etc/ood/dex/ondemand.secret #insert secret from HTTPD
vim /etc/ood/dex/config.yaml #insert secret from HTTPD
runuser -u ondemand-dex /usr/sbin/ondemand-dex serve /etc/ood/dex/config.yaml
```