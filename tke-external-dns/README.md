### Usecase
On TKE, we use [ExternalDNS](https://github.com/kubernetes-sigs/external-dns) to synchronize exposed Kubernetes Services and Ingresses with DNS providers.

In this usecase, we use [Cloudflare](https://www.cloudflare.com/) as DNS provider.

<img src="./assets/image.svg" height="500">

### Managed resources

- TKE
- deployment - ExternalDNS
- deployment - nginx

### Usage
You can obtain your API key from the bottom of the "My Account" page, found here: [Go to My account](https://dash.cloudflare.com/profile).



### References
[Setting up ExternalDNS for Services on Cloudflare](https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/cloudflare.md)
