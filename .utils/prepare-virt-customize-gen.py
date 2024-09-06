import os
from jinja2 import Template
import yaml

CURRENT_VERSION="0.0.5"
FILE_PATH = os.path.realpath(__file__)


with open('.env.yml', 'r') as file:
    default_vars = yaml.safe_load(file)

for key in default_vars['pv_list']:
    try:
        with open(f'./.tpl/sh/prepare-virt-customize-{key["os"]}.sh.jinja2') as file:
            template = Template(file.read())
        print(f'Open custome template: ./.tpl/sh/prepare-virt-customize-{key["os"]}.sh.jinja2')
    except:
        print(f'Open default <prepare-virt-customize.sh.jinja2> template')
        with open(f'./.tpl/sh/prepare-virt-customize.sh.jinja2') as file:
            template = Template(file.read())

    print(f'{key["os"]}-{key["family"]} {key["path"]}')
    file_name=f'../{key["os"]}/{key["path"]}/prepare-virt-customize.sh'
    with open(file_name, 'w') as out:
        print(f'   ../{key["os"]}/{key["path"]}/prepare-virt-customize.sh')
        try:
            users = key["users"]
        except:
            users = False
        try:
            ssl = key["ssl"][0]
        except:
            ssl = False

        out.write(template.render(
            current_version=CURRENT_VERSION + "-" + key["os"],
            os=key["os"],
            default_os_user=key["default_os_user"],
            os_distr_name=key["family"],
            image_name=key["img"],
            image_url=key["dwn"],
            vm_id=key["vm_id"],
            vm_clone_id=key["vm_clone_id"],
            vm_ci_tpl_name=key["vm_ci_tpl_name"],
            users=users,
            root_passwd=key["root_passwd"],
            ssl=ssl,
            ssh_authorized_keys=default_vars["global_ssh_pub"],
        )+"\n")
    os.chmod(file_name, 0o0777)
