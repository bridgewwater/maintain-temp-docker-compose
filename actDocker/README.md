# for docker maintain

first use must do after run maintain

# nginx

## config

in `actDocker/data/nginx`

```sh
├── conf # folder of nignx
│   ├── 10000-local-file.conf # nginx static HTML or file contain
│   ├── ng-80.conf # port 80 for root
│   └── proxy-sinlovlocal.com.conf # proxy host sinlovlocal config
└── home # folder of nginx contain root, you can let static files in this and use like `root /home/dev/sso-fp` or `root /home/net-file`
    ├── dev
    │   └── sso-fp
    │       └── index.html
    └── net-file
        └── index.html
```

### for nginx dev

```sh
cd ${sync_tag}
docker-compose run nginx up
```

# flask

> warning: each use `debug` mode or each restart contain to let script code effective

## config

in `actDocker/data/Dev/flask-17777`

```sh
.
└── app # flask root
    ├── app.py # code
    ├── static # static
    │   └── css
    │       └── bootstrap.min.css
    └── templates # templates
        └── index.html
```

### for nginx dev

```sh
cd ${sync_tag}
docker-compose run nginx up
```



