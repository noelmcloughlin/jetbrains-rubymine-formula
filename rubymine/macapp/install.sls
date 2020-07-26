# -*- coding: utf-8 -*-
# vim: ft=sls

  {%- if grains.os_family == 'MacOS' %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rubymine with context %}

rubymine-macos-app-install-curl:
  file.directory:
    - name: {{ rubymine.dir.tmp }}
    - makedirs: True
    - clean: True
  pkg.installed:
    - name: curl
  cmd.run:
    - name: curl -Lo {{ rubymine.dir.tmp }}/rubymine-{{ rubymine.version }} "{{ rubymine.pkg.macapp.source }}"
    - unless: test -f {{ rubymine.dir.tmp }}/rubymine-{{ rubymine.version }}
    - require:
      - file: rubymine-macos-app-install-curl
      - pkg: rubymine-macos-app-install-curl
    - retry: {{ rubymine.retry_option|json }}

      # Check the hash sum. If check fails remove
      # the file to trigger fresh download on rerun
rubymine-macos-app-install-checksum:
  module.run:
    - onlyif: {{ rubymine.pkg.macapp.source_hash }}
    - name: file.check_hash
    - path: {{ rubymine.dir.tmp }}/rubymine-{{ rubymine.version }}
    - file_hash: {{ rubymine.pkg.macapp.source_hash }}
    - require:
      - cmd: rubymine-macos-app-install-curl
    - require_in:
      - macpackage: rubymine-macos-app-install-macpackage
  file.absent:
    - name: {{ rubymine.dir.tmp }}/rubymine-{{ rubymine.version }}
    - onfail:
      - module: rubymine-macos-app-install-checksum

rubymine-macos-app-install-macpackage:
  macpackage.installed:
    - name: {{ rubymine.dir.tmp }}/rubymine-{{ rubymine.version }}
    - store: True
    - dmg: True
    - app: True
    - force: True
    - allow_untrusted: True
    - onchanges:
      - cmd: rubymine-macos-app-install-curl
  file.managed:
    - name: /tmp/mac_shortcut.sh
    - source: salt://rubymine/files/mac_shortcut.sh
    - mode: 755
    - template: jinja
    - context:
      appname: {{ rubymine.pkg.name }}
      edition: {{ '' if 'edition' not in rubymine else rubymine.edition }}
      user: {{ rubymine.identity.user }}
      homes: {{ rubymine.dir.homes }}
  cmd.run:
    - name: /tmp/mac_shortcut.sh
    - runas: {{ rubymine.identity.user }}
    - require:
      - file: rubymine-macos-app-install-macpackage

    {%- else %}

rubymine-macos-app-install-unavailable:
  test.show_notification:
    - text: |
        The rubymine macpackage is only available on MacOS

    {%- endif %}
