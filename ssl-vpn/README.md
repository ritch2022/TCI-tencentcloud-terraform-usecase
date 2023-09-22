### Usecase
To use SSL VPN to access resources on Tencent Cloud.

<img src="./assets/image.svg" width="400">



### Managed resources
- CCN instance
- SSL VPN Gateway instance
- SSL Server
- SSL Client

### Usage
You should be careful to config `cloud_available_cidrs` and `vpn_client_cidr`. 

- `cloud_available_cidrs`: The network range that the client need to access. It must be the address of the associated CCN instance or within the network range of the VPC where it's added to.
- `vpn_client_cidr`: The network segment assigned to the client for communication. It cannot overlap with the local segment, and the address pool mask must be less than or equal to 24.

Once succeed to run `terraform apply`, you can add resources to the CCN instance, they can be accessed after users login VPN client.

[How to download SSL VPN server configuration](https://www.tencentcloud.com/zh/document/product/1037/47175)

### References
[CCN](https://www.tencentcloud.com/zh/document/product/1003)

[VPN](https://www.tencentcloud.com/document/product/1037)