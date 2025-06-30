import os
import yaml

def get_vars(keys=None):
    with open('.env.yml', 'r') as file:
        default_vars = yaml.safe_load(file)
    if keys:
        return default_vars[keys]
    return default_vars
