# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rubymine with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

    {%- if rubymine.pkg.use_upstream_macapp %}
        {%- set sls_package_install = tplroot ~ '.macapp.install' %}
    {%- else %}
        {%- set sls_package_install = tplroot ~ '.archive.install' %}
    {%- endif %}

include:
  - {{ sls_package_install }}

rubymine-config-file-file-managed-environ_file:
  file.managed:
    - name: {{ rubymine.environ_file }}
    - source: {{ files_switch(['environ.sh.jinja'],
                              lookup='rubymine-config-file-file-managed-environ_file'
                 )
              }}
    - mode: 644
    - user: {{ rubymine.identity.rootuser }}
    - group: {{ rubymine.identity.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
      environ: {{ rubymine.environ|json }}
                      {%- if rubymine.pkg.use_upstream_macapp %}
      edition:  {{ '' if not rubymine.edition else ' %sE'|format(rubymine.edition) }}.app/Contents/MacOS
      appname: {{ rubymine.dir.path }}/{{ rubymine.pkg.name }}
                      {%- else %}
      edition: ''
      appname: {{ rubymine.dir.path }}/bin
                      {%- endif %}
    - require:
      - sls: {{ sls_package_install }}
