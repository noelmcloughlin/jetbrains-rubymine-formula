# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rubymine with context %}

rubymine-package-archive-clean-file-absent:
  file.absent:
    - names:
      - {{ rubymine.dir.tmp }}
                  {%- if grains.os == 'MacOS' %}
      - {{ rubymine.dir.path }}/{{ rubymine.pkg.name }}*{{ rubymine.edition }}*.app
                  {%- else %}
      - {{ rubymine.dir.path }}
                  {%- endif %}
