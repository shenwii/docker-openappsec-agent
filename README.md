# openappsec Agent Docker Image

This repository builds a Docker image for the openappsec agent. It uses a multi-stage Alpine-based build to compile the agent and packages the generated installers and runtime entrypoint into a runtime image.

## Build

```bash
docker build -t openappsec-agent .
```

## Run

```bash
docker run --rm -it \
  --cap-add=NET_ADMIN \
  --cap-add=NET_RAW \
  --network host \
  --name openappsec-agent \
  openappsec-agent
```

Depending on your deployment environment, you may need to mount configuration, certificates, or other runtime files required by your openappsec setup.

## Included artifacts

The image includes:

- the generated self-managed manifest
- nano-service installers under `/nano-service-installers/`
- the runtime entrypoint script at `/entry.sh`
- the default command `/cp-nano-agent`

## License

This project is distributed under the GNU General Public License v3.0. See the `LICENSE` file for the full text.
