# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rubymine with context %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}

    {% if grains.kernel|lower == 'linux' %}

rubymine-linuxenv-home-file-symlink:
  file.symlink:
    - name: /opt/rubymine
    - target: {{ rubymine.pkg.archive.path }}
    - onlyif: test -d '{{ rubymine.pkg.archive.path }}'
    - force: True

        {% if rubymine.linux.altpriority|int > 0 and grains.os_family not in ('Arch',) %}

rubymine-linuxenv-home-alternatives-install:
  alternatives.install:
    - name: rubyminehome
    - link: /opt/rubymine
    - path: {{ rubymine.pkg.archive.path }}
    - priority: {{ rubymine.linux.altpriority }}
    - retry: {{ rubymine.retry_option|json }}

rubymine-linuxenv-home-alternatives-set:
  alternatives.set:
    - name: rubyminehome
    - path: {{ rubymine.pkg.archive.path }}
    - onchanges:
      - alternatives: rubymine-linuxenv-home-alternatives-install
    - retry: {{ rubymine.retry_option|json }}

rubymine-linuxenv-executable-alternatives-install:
  alternatives.install:
    - name: rubymine
    - link: {{ rubymine.linux.symlink }}
    - path: {{ rubymine.pkg.archive.path }}/{{ rubymine.command }}
    - priority: {{ rubymine.linux.altpriority }}
    - require:
      - alternatives: rubymine-linuxenv-home-alternatives-install
      - alternatives: rubymine-linuxenv-home-alternatives-set
    - retry: {{ rubymine.retry_option|json }}

rubymine-linuxenv-executable-alternatives-set:
  alternatives.set:
    - name: rubymine
    - path: {{ rubymine.pkg.archive.path }}/{{ rubymine.command }}
    - onchanges:
      - alternatives: rubymine-linuxenv-executable-alternatives-install
    - retry: {{ rubymine.retry_option|json }}

        {%- else %}

rubymine-linuxenv-alternatives-install-unapplicable:
  test.show_notification:
    - text: |
        Linux alternatives are turned off (rubymine.linux.altpriority=0),
        or not applicable on {{ grains.os or grains.os_family }} OS.
        {% endif %}
    {% endif %}
