# opkustomize Example

This example demonstrates how to utilize opkustomize (Kustomize build with 1Password integration) to inject secrets in
Kubernetes manifests files.

### Pre-requisites

- [Install opkustomize](https://github.com/alexbaeza/opkustomize/tree/main?tab=readme-ov-file#installation)
- Ensure you have the 1Password CLI (op) installed and configured.
- Create an example vault in 1 password named "example-vault"
- Create a new item in that vault of:
    - type: "API Credential"
    - name: "grafana-admin-password"
    - credential: "my-super-secret"
- Create a service account using the 1Password CLI:

```bash
op service-account create example-ci-cd-read-only --vault example-vault:read_items
```

### Example

1. Set up the environment variable with your 1Password service-account token:

```bash
export OP_SERVICE_ACCOUNT_TOKEN=<1Password token>
```

2. Run opkustomize with the appropriate environment file and target folder:

```bash
opkustomize cluster-credentials.example.env grafana --enable-helm
```

This inflates the Helm chart and injects secrets from 1Password using Kustomize. It outputs the manifest files
with applied configurations.

On the output look for the admin-password secret, which should be populated with the base64 encoded secret retrieved
from 1Password.

3. Success 🎉

A realistic run to deploy the manifest files to your Kubernetes cluster would look something like this:

```bash
opkustomize cluster-credentials.example.env grafana --enable-helm | kubectl apply -f -
```

This generates and populates the secrets from 1password and applies the manifest files to your Kubernetes cluster,
deploying the configured resources.
