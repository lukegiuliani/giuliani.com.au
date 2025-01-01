# giuliani.com.au

Two files to set up before you get going: 
* `terraform.tfvars` -> top level vars for the thing, use `terraform.tfvars.example`
* `state.config` -> access for the r2 bucket to actually download the initial statefile. 

When you do the initial init, make sure you use include the statefile. After that you can just run `terraform plan` as per normal. 

```
➜  iac git:(main) ✗ terraform init -backend-config="./state.config"
```