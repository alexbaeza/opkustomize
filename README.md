# OpKustomize

OpKustomize is a Bash script that facilitates the injection of secrets and environment variable substitution using
1Password CLI (`op`) and `envsubst` respectively. It is a wrapper around `kustomize build` and it is designed to be used
in conjunction with Kustomize for Kubernetes configuration management.

## Requirements

- [1Password CLI (`op`)](https://support.1password.com/command-line/) installed and configured.
- `envsubst` utility (usually available in most Linux distributions).
- `kustomize` tool.
- `OP_SERVICE_ACCOUNT_TOKEN` environment variable set with the token for 1Password service account.
- `.env` file defining the secrets and environment variables to be injected.

## Installation

To install OpKustomize, follow these steps:

```bash
curl -LO "https://github.com/alexbaeza/opkustomize/raw/main/opkustomize.sh"
chmod +x opkustomize.sh
sudo mv opkustomize.sh /usr/local/bin/opkustomize
```

## Usage

To use OpKustomize, follow these steps:

1. Set the `OP_SERVICE_ACCOUNT_TOKEN` environment variable with your 1Password service account token:

```bash
export OP_SERVICE_ACCOUNT_TOKEN=<YOUR_TOKEN>
```

2. Define a `.env` file with the necessary secrets and environment variables:

   Example:

```dotenv
# .env file example
MY_VARIABLE="op://<reference>"
```

Replace `<reference>` with the reference to the 1Password secret, e.g., `my-secret-vault/my-secret-key/credential`.

3. Run the OpKustomize script with the following syntax:

```bash
opkustomize <env_file> <target_folder> [other_flags...]
```

- `<env_file>`: The name of the `.env` file containing secrets and environment variables to be injected.
- `<target_folder>`: The target folder where the Kubernetes configuration files reside.
- `[other_flags...]`: Additional flags/options to be passed to the `kustomize build` command.

## Run Example

```bash
opkustomize cluster-credentials.dev.env ./k8s/apps/overlays/production/
```

Example with helm support:

```bash
opkustomize cluster-credentials.dev.env ./k8s/apps/overlays/production/ --enable-helm
```

## Notes

- OpKustomize uses `op` to inject secrets into the Kubernetes configuration files.
- Environment variables in the configuration files are substituted using `envsubst`.
- The temporary directory used for processing is cleaned up automatically after script execution.

## License

This project is licensed under the MIT License.
See the [LICENSE](https://github.com/alexbaeza/opkustomize/raw/main/LICENSE) file for details.
