#!/usr/bin/python
# -*- coding: utf-8 -*-

import commands

from ansible.module_utils.basic import *


DOCUMENTATION = """
---
module:             yumdownload
author:             Yusuke TAKEI
description:
  - Download only specified package and dependencies which has not been installed yet.
options:
  name:
    description:    package name in local
    required:       true
  downloaddir:
    description:    directory to store packages
"""


EXAMPLES = """
- action: yumdownload name=package1 downloaddir=./rpms
"""


RETURN = """
rc:
    description:    status of yum command
    type:           int

results:
    description:    stdout of yum command
    type:           string
"""


def main():
    module = AnsibleModule(
        argument_spec = dict(
            name        = dict(required=True),
            downloaddir = dict()
        )
    )

    args = module.params

    name        = args.get('name')
    downloaddir = args.get('downloaddir')
    
    result = commands.getstatusoutput(
        ("yum install {name} -y         "
         "--downloadonly                "
         "--downloaddir={downloaddir}   "
        ).format(name=name, downloaddir=downloaddir))
    
    if result[0] != 0:
        module.fail_json(msg=result[1])
    
    response = dict(
        name        = name,
        downloaddir = downloaddir,
        rc          = result[0],
        results     = result[1],
    )
    
    module.exit_json(**response)


if __name__ == '__main__':
    main()

