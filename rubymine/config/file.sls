# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rubymine with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{%- if 'config' in rubymine and rubymine.config and rubymine.config_file %}
    {%- if rubymine.pkg.use_upstream_macapp %}
        {%- set sls_package_install = tplroot ~ '.macapp.install' %}
    {%- else %}
        {%- set sls_package_install = tplroot ~ '.archive.install' %}
    {%- endif %}

include:
  - {{ sls_package_install }}

rubymine-config-file-managed-config_file:
  file.managed:
    - name: {{ rubymine.config_file }}
    - source: {{ files_switch(['file.default.jinja'],
                              lookup='rubymine-config-file-file-managed-config_file'
                 )
              }}
    - mode: 640
    - user: {{ rubymine.identity.rootuser }}
    - group: {{ rubymine.identity.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
      config: {{ rubymine.config|json }}
    - require:
      - sls: {{ sls_package_install }}

{%- endif %}
