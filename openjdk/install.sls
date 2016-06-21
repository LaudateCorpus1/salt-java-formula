# -*- coding: utf-8 -*-
# vim: ft=sls

{% from 'openjdk/map.jinja' import openjdk with context %}

#decide which pkg if this is JDK/JRE and headless
{% if openjdk['version'] is defined %}
  {% if openjdk['jre_only'] == 'true' %}
    {% if openjdk['headless'] == 'true' %}
      {% set packagename = "openjdk-" + openjdk['version'] + "-jre-headless" %}
    {% else %}
      {% set packagename = "openjdk-" + openjdk['version'] + "-jre" %}
    {% endif %}
  {% elif openjdk['jre_only'] == 'false' or openjdk['jre_only'] is not defined %}
    {% if openjdk['headless'] == 'true' %}
      {% set packagename = "openjdk-" + openjdk['version'] + "-jdk-headless" %}
    {% else %}
      {% set packagename = "openjdk-" + openjdk['version'] + "-jdk" %}
    {% endif %}
  {% endif %}
{% endif %}

python-software-properties:
  pkg.installed

openjdk-{{ openjdk.version }}-repo:
  pkgrepo.managed:
    - humanname: OpenJDK Uploads Restricted Repository
    - name: "deb http://ppa.launchpad.net/openjdk-r/ppa/ubuntu trusty main"
    - dist: trusty
    - file: /etc/apt/sources.list.d/openjdk-r.list
    - keyid: 86F44E2A
    - keyserver: keyserver.ubuntu.com
    - require:
      - pkg: python-software-properties


openjdk-{{ openjdk.version }}-package:
  pkg.installed:
    - name: {{ packagename }}