# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rubymine with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{%- if rubymine.shortcut.install and grains.kernel|lower == 'linux' %}
    {%- set sls_package_install = tplroot ~ '.archive.install' %}

include:
  - {{ sls_package_install }}

rubymine-config-file-file-managed-desktop-shortcut_file:
  file.managed:
    - name: {{ rubymine.shortcut.file }}
    - source: {{ files_switch(['shortcut.desktop.jinja'],
                              lookup='rubymine-config-file-file-managed-desktop-shortcut_file'
                 )
              }}
    - mode: 644
    - user: {{ rubymine.identity.user }}
    - makedirs: True
    - template: jinja
    - context:
      command: {{ rubymine.command|json }}
                        {%- if grains.os == 'MacOS' %}
      edition: {{ '' if 'edition' not in rubymine else rubymine.edition|json }}
      appname: {{ rubymine.dir.path }}/{{ rubymine.pkg.name }}
                        {%- else %}
      edition: ''
      appname: {{ rubymine.dir.path }}
    - onlyif: test -f "{{ rubymine.dir.path }}/{{ rubymine.command }}"
                        {%- endif %}
    - require:
      - sls: {{ sls_package_install }}

{%- endif %}
