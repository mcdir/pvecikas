import os
from jinja2 import Template
import yaml
import subprocess


with open('.env.yml', 'r') as file:
    default_vars = yaml.safe_load(file)

for key in default_vars['pv_list']:
    print(f'{key["os"]}-{key["family"]} {key["path"]}')
    try:
        os.mkdir(f'../{key["os"]}/{key["path"]}/')
        print(f'Directory ../{key["os"]}/{key["path"]}/.templates/ created')
    except:
        print(f'Directory ../{key["os"]}/{key["path"]}/.templates/ exist')
    try:
        os.mkdir(f'../{key["os"]}/{key["path"]}/.envs/')
        print(f'Directory ../{key["os"]}/{key["path"]}/.envs/ created')
    except:
        print(f'Directory ../{key["os"]}/{key["path"]}/.envs/ exist')

    link="""
        cd ../{os}/{path}/
        ln -s ../../.global/init.sh . || true && ./init.sh
        """.format(os=key["os"], path=key["path"])
    print(link)
    subprocess.run(
        link,
        shell=True, check=True,
        executable='/bin/bash')
