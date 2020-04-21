# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rubymine with context %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}

rubymine-package-archive-install:
  pkg.installed:
    - names: {{ rubymine.pkg.deps|json }}
    - require_in:
      - file: rubymine-package-archive-install
  file.directory:
    - name: {{ rubymine.pkg.archive.path }}
    - user: {{ rubymine.identity.rootuser }}
    - group: {{ rubymine.identity.rootgroup }}
    - mode: 755
    - makedirs: True
    - clean: True
    - require_in:
      - archive: rubymine-package-archive-install
    - recurse:
        - user
        - group
        - mode
  archive.extracted:
    {{- format_kwargs(rubymine.pkg.archive) }}
    - retry: {{ rubymine.retry_option|json }}
    - user: {{ rubymine.identity.rootuser }}
    - group: {{ rubymine.identity.rootgroup }}
    - recurse:
        - user
        - group
    - require:
      - file: rubymine-package-archive-install

    {%- if rubymine.linux.altpriority|int == 0 %}

rubymine-archive-install-file-symlink-rubymine:
  file.symlink:
    - name: /usr/local/bin/rubymine
    - target: {{ rubymine.pkg.archive.path }}/{{ rubymine.command }}
    - force: True
    - onlyif: {{ grains.kernel|lower != 'windows' }}
    - require:
      - archive: rubymine-package-archive-install

    {%- endif %}
