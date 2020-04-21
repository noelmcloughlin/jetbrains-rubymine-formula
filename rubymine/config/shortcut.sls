# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rubymine with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{%- if rubymine.linux.install_desktop_file and grains.os not in ('MacOS',) %}
       {%- if rubymine.pkg.use_upstream_macapp %}
           {%- set sls_package_install = tplroot ~ '.macapp.install' %}
       {%- else %}
           {%- set sls_package_install = tplroot ~ '.archive.install' %}
       {%- endif %}

include:
  - {{ sls_package_install }}

rubymine-config-file-file-managed-desktop-shortcut_file:
  file.managed:
    - name: {{ rubymine.linux.desktop_file }}
    - source: {{ files_switch(['shortcut.desktop.jinja'],
                              lookup='rubymine-config-file-file-managed-desktop-shortcut_file'
                 )
              }}
    - mode: 644
    - user: {{ rubymine.identity.user }}
    - makedirs: True
    - template: jinja
    - context:
        appname: {{ rubymine.pkg.name }}
        edition: {{ rubymine.edition|json }}
        command: {{ rubymine.command|json }}
              {%- if rubymine.pkg.use_upstream_macapp %}
        path: {{ rubymine.pkg.macapp.path }}
    - onlyif: test -f "{{ rubymine.pkg.macapp.path }}/{{ rubymine.command }}"
              {%- else %}
        path: {{ rubymine.pkg.archive.path }}
    - onlyif: test -f {{ rubymine.pkg.archive.path }}/{{ rubymine.command }}
              {%- endif %}
    - require:
      - sls: {{ sls_package_install }}

{%- endif %}
