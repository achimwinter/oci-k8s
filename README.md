# :cloud: Oracle Cloud kubernetes free tier setup

This repo utilizes the [always free tier](https://blogs.oracle.com/cloud-infrastructure/post/oracle-builds-out-their-portfolio-of-oracle-cloud-infrastructure-always-free-services) of the oracle cloud to provision a kubernetes cluster.

At orcale cloud the Kubernetes controlplane (oke) is free to use, you just pay
for the workers, *if* you surpass the always free tier (which we don't).
You get 4 oCpus and 24GB memory which are split into two worker-instances
(`VM.Standard.A1.Flex` -> arm), allowing good resource utilization.
The boot partions are 100Gb each, allowing `longhorn` to use around 60GB as in
cluster storage. For the ingress class we use `nginx` with the oracle Flexible 
LB (10Mbps), because that's free as well.

> :warning: This project uses arm instances, no x86 architecture

I haven't created most of this, i just use it for future development stuff and to understand kubernetes better. 
And with this being said, huge shoutout to [nce/ori-free-cloud-k8s](https://github.com/nce/oci-free-cloud-k8s)

## :wrench: Tooling
- [x] K8s control plane
- [x] Worker Nodes
- [x] Ingress  
  nginx-ingress controller
- [x] Storage  
  with longhorn

## :keyboard: Setup

This setup uses terraform to managed the oci and kubernetes part.

The terraform state is pushed to the oracle object storage (free as well). For that
we have to create a bucket initially:
```
$ oci os bucket create --name terraform-states --versioning Enabled --compartment-id xxx
```

* The infrastructure (everything to a usable k8s-api endpoint) is managed by
terrafom in [infra](infra/)
* The k8s-modules (usually helm) are managed by terraform in [config](config/)

These components are independed from eachother, but obv. the infra should
be created first.

For the config part, we need to add a private `*.tfvars` file:
```
node_pool_id     = "ocid1.nodepool.xxx"
public_subnet_id = "ocid1.subnet.yyy"
compartment_id   = "ocid1.tenancy.zzz"
vault_id         = "ocid1.vault.aaa"
```

* The first & second value are outputs from the infra-terraform.
* The third & fourth value are currently extracted from the webui

### kubeconfig
With the following command we get the kubeconfig for terraform/direct access:
```
# in the infra folder
oci ce cluster create-kubeconfig --cluster-id $(terraform output --raw k8s_cluster_id) --file ~/.kube/configs/oci.kubeconfig --region eu-frankfurt-1 --token-version 2.0.0 --kube-endpoint PUBLIC_ENDPOINT
```

## :telescope: renovate maintenance 
This repo utilizes renovate to update all terraform providers and helm charts.

The helm chart versions need to be stored alongside the repository info, and
not in tf variables. Using variables might be possible, but quite ugly.
* https://github.com/renovatebot/renovate/discussions/16052