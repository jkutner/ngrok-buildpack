# ngrok Buildpack

![Version](https://img.shields.io/badge/dynamic/json?url=https://cnb-registry-api.herokuapp.com/api/v1/buildpacks/jkutner/ngrok&label=Version&query=$.latest.version)

This is a [Cloud Native Buildpack](https://buildpacks.io) for [ngrok](https://ngrok.com). It can be used to creare secure tunnels into your container that are available on the public internet.

## Usage

Combine the ngrok buildpack with other buildpacks to have it install and run ngrok alongside your app:

```
$ pack build -b jkutner/ngrok,heroku/nodejs myapp
```

Run the container with an `NGROK_TOKEN` environment variable:

```
$ docker run -e NGROK_TOKEN=xxx -it mypp
```

## Customizing

The buildpack will load `.ngrok2/ngrok.yml` file from your app if it is present. For more information, see the [ngrok documentation on configuration files](https://ngrok.com/docs#config-location).

You can also set the `NGROK_OPTIONS` environment variable at runtime to apply custom options to the ngrok command.

**WARNING:** Do not put your ngrok token in this file unless you are loading it from a Kubernetes secret in a volume mount or similar.

## Example: ssh

You can you use the ngrok buildpack with the [sshd buildpack](https://github.com/jkutner/sshd-buildpack) to expose an SSH server to the internet. Put the following in your `.ngrok2/ngrok.yml`

```yaml
tunnels:
  ssh:
    proto: tcp
    addr: 2222
```

Then build your app

```
$ pack build -b jkutner/sshd,jkutner/ngrok,heroku/nodejs myapp
```

Run the resulting image and you'll be able to SSH into your container using the ngrok URL.
