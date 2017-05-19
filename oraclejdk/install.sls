# -*- coding: utf-8 -*-
# vim: ft=sls

{% from 'oraclejdk/map.jinja' import oraclejdk with context %}


debconf-utils:
  pkg.installed

python-software-properties:
  pkg.installed

oracle-java{{ oraclejdk.version }}-debconf:
  debconf.set:
    - name: oracle-java{{ oraclejdk.version }}-installer
    - data:
        'shared/accepted-oracle-license-v1-1': {'type': 'boolean', 'value': True}
    - require:
      - pkg: debconf-utils

oracle-java{{ oraclejdk.version }}-repo:
  pkgrepo.managed:
    - humanname: WebUp8Team Java Repository
    - ppa: webupd8team/java
    - file: /etc/apt/sources.list.d/webup8team.list
    - keyid: EEA14886
    - keyserver: keyserver.ubuntu.com
    - require:
      - pkg: python-software-properties

oracle-java{{ oraclejdk.version }}-installer:
  pkg.installed:
    - require:
      - pkgrepo: oracle-java{{ oraclejdk.version }}-repo
      - debconf: oracle-java{{ oraclejdk.version }}-debconf

oracle-java{{ oraclejdk.version }}-set-default:
  pkg.installed:
    - require:
      - pkgrepo: oracle-java{{ oraclejdk.version }}-repo
      - pkg: oracle-java{{ oraclejdk.version }}-installer

{%- if oraclejdk.jce_install == 'true' %}
oracle-java{{ oraclejdk.version }}-unlimited-jce-policy:
   pkg.installed:
    - require:
      - pkgrepo: oracle-java{{ oraclejdk.version }}-repo
      - pkg: oracle-java{{ oraclejdk.version }}-installer
{%- endif %}

