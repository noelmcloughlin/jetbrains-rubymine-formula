# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rubymine with context %}

   {%- if rubymine.pkg.use_upstream_macapp %}
       {%- set sls_package_clean = tplroot ~ '.macapp.clean' %}
   {%- else %}
       {%- set sls_package_clean = tplroot ~ '.archive.clean' %}
   {%- endif %}

include:
  - {{ sls_package_clean }}

rubymine-config-clean-file-absent:
  file.absent:
    - names:
      - /tmp/dummy_list_item
               {%- if rubymine.config_file and rubymine.config %}
      - {{ rubymine.config_file }}
               {%- endif %}
               {%- if rubymine.environ_file %}
      - {{ rubymine.environ_file }}
               {%- endif %}
               {%- if grains.kernel|lower == 'linux' %}
      - {{ rubymine.linux.desktop_file }}
               {%- elif grains.os == 'MacOS' %}
      - {{ rubymine.dir.homes }}/{{ rubymine.identity.user }}/Desktop/{{ rubymine.pkg.name }}{{ '' if 'edition' not in rubymine else '\ %sE'|format(rubymine.edition) }}  # noqa 204
               {%- endif %}
    - require:
      - sls: {{ sls_package_clean }}
