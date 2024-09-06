import os
from jinja2 import Template
import yaml

CURRENT_VERSION="0.0.2"


with open('.env.yml', 'r') as file:
    default_vars = yaml.safe_load(file)

with open('./.tpl/sh/env_custom.sh.jinja2') as file:
    template = Template(file.read())

for key in default_vars['pv_list']:
    print(f'{key["os"]}-{key["family"]} {key["path"]}')
    with open(f'../{key["os"]}/{key["path"]}/.envs/.env_custom.sh', 'w') as out:
        print(f'   ../{key["os"]}/{key["path"]}/.envs/.env_custom.sh')
        out.write(template.render(
            current_version=CURRENT_VERSION,
            os=key["os"],
            default_os_user=key["default_os_user"],
            os_distr_name=key["family"],
            image_name=key["img"],
            image_url=key["dwn"],
            vm_id=key["vm_id"],
            vm_clone_id=key["vm_clone_id"],
            vm_ci_tpl_name=key["vm_ci_tpl_name"],
            ssh_authorized_keys=default_vars["global_ssh_pub"],
        )+"\n")
