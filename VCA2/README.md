The Intel(R) Visual Compute Accelerator 2 (Intel VCA 2) features three Intel(R) Xeon(R) processors E3-1500 v5 with Iris(R) Pro P580.    

See the following documents for instructions on how to setup Intel VCA 2: 
- [Intel VCA 2 Product Specification and Hardware Guide](https://www.intel.com/content/dam/support/us/en/documents/server-products/server-accessories/VCA2_HW_User_Guide.pdf)
- [Intel VCA 2 Product Family Software Guide](https://www.intel.com/content/dam/support/us/en/documents/server-products/server-accessories/VCA_SoftwareUserGuide.pdf)

The Dockerfiles presented in this repo are targeted to run on the Intel VCA 2 nodes.
Therefore the host installation steps mentioned in the parent [README.md](../README.md) apply to each Intel VCA 2 node instead.
The build and test scripts additionally require "sudo" to be available on the node:

```sh
Ubuntu: apt-get install -y sudo 
CentOS: yum install -y sudo
```
