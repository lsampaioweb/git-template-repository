# {project_name}
Description XXX.

Run these commands on the computer that is running Packer:

```bash
  cd packer

  packer init config.pkr.hcl
  packer build -only="credencials.null.password" -var-file=project.pkrvars.hcl clone/.
  packer build -only="template.proxmox-clone.ubuntu" -var-file=project.pkrvars.hcl clone/.
  or 
  ./pipeline.sh
```

# Created by: 

1. Luciano Sampaio.
