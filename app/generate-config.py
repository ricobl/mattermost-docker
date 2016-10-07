# -*- coding: utf-8 -*-

import os
import sys
import json
import urlparse


def _load_file(filename):
    with open(filename) as fp:
        return json.load(fp)


def _write_file(filename, data):
    with open(filename, 'w') as fp:
        json.dump(data, fp, indent=4, sort_keys=True)


def _env_name(group, key):
    return '{0}_{1}'.format(group, key)


def _get_value(env_name):
    value = os.environ[env_name]

    try:
        return json.loads(value)
    except:
        pass

    return value


def _override_key(data, group, key):
    env_name = _env_name(group, key)
    if env_name in os.environ:
        data[group][key] = _get_value(env_name)


def _apply_overrides(data):
    for group, items in data.items():
        for key in items:
            _override_key(data, group, key)


def _fix_data_source(data):
    if 'DBAAS_MYSQL_ENDPOINT' not in os.environ:
        return
    url_parts = list(urlparse.urlsplit(os.environ['DBAAS_MYSQL_ENDPOINT']))
    # Remove scheme
    url_parts.pop(0)
    # Split credentials and netloc and wrap netloc in tcp()
    credentials, netloc = url_parts[0].split('@')
    url_parts[0] = '{0}@tcp({1})'.format(credentials, netloc)

    fixed_url = ''.join(url_parts)
    data['SqlSettings']['DataSource'] = fixed_url


def _fix_listen_address(data):
    if 'PORT' not in os.environ:
        return
    data['ServiceSettings']['ListenAddress'] = ':{0}'.format(
        os.environ['PORT'])


def generate_config(infile, outfile):
    data = _load_file('config.template.json')
    _apply_overrides(data)
    _fix_data_source(data)
    _fix_listen_address(data)
    _write_file(outfile, data)


if __name__ == '__main__':
    # Config template:
    # https://raw.githubusercontent.com/mattermost/platform/master/config/config.json

    args = sys.argv[1:]
    infile = args[0]
    outfile = args[1]

    generate_config(infile, outfile)
