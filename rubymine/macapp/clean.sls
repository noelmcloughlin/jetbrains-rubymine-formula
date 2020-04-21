# -*- coding: utf-8 -*-
# vim: ft=sls

    {%- if grains.os_family == 'MacOS' %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rubymine with context %}

rubymine-macos-app-clean-files:
  file.absent:
    - names:
      - {{ rubymine.dir.tmp }}
      - /Applications/{{ rubymine.pkg.name }}{{ ' %sE'|format(rubymine.edition) if rubymine.edition else '' }}.app

    {%- else %}

rubymine-macos-app-clean-unavailable:
  test.show_notification:
    - text: |
        The rubymine macpackage is only available on MacOS

    {%- endif %}
