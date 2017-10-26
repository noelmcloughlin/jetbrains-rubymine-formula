{% from "rubymine/map.jinja" import rubymine with context %}

# Cleanup first
rubymine-remove-prev-archive:
  file.absent:
    - name: '{{ rubymine.tmpdir }}/{{ rubymine.dl.archive_name }}'
    - require_in:
      - rubymine-install-dir

rubymine-install-dir:
  file.directory:
    - names:
      - '{{ rubymine.alt.realhome }}'
      - '{{ rubymine.tmpdir }}'
{% if grains.os not in ('MacOS', 'Windows') %}
      - '{{ rubymine.prefix }}'
      - '{{ rubymine.symhome }}'
    - user: root
    - group: root
    - mode: 755
{% endif %}
    - makedirs: True
    - require_in:
      - rubymine-download-archive

rubymine-download-archive:
  cmd.run:
    - name: curl {{ rubymine.dl.opts }} -o '{{ rubymine.tmpdir }}/{{ rubymine.dl.archive_name }}' {{ rubymine.dl.source_url }}
      {% if grains['saltversioninfo'] >= [2017, 7, 0] %}
    - retry:
        attempts: {{ rubymine.dl.retries }}
        interval: {{ rubymine.dl.interval }}
      {% endif %}

{% if grains.os not in ('MacOS') %}
rubymine-unpacked-dir:
  file.directory:
    - name: '{{ rubymine.alt.realhome }}'
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - force: True
    - onchanges:
      - cmd: rubymine-download-archive
{% endif %}

{%- if rubymine.dl.src_hashsum %}
   # Check local archive using hashstring for older Salt / MacOS.
   # (see https://github.com/saltstack/salt/pull/41914).
  {%- if grains['saltversioninfo'] <= [2016, 11, 6] or grains.os in ('MacOS') %}
rubymine-check-archive-hash:
   module.run:
     - name: file.check_hash
     - path: '{{ rubymine.tmpdir }}/{{ rubymine.dl.archive_name }}'
     - file_hash: {{ rubymine.dl.src_hashsum }}
     - onchanges:
       - cmd: rubymine-download-archive
     - require_in:
       - archive: rubymine-package-install
  {%- endif %}
{%- endif %}

rubymine-package-install:
{% if grains.os == 'MacOS' %}
  macpackage.installed:
    - name: '{{ rubymine.tmpdir }}/{{ rubymine.dl.archive_name }}'
    - store: True
    - dmg: True
    - app: True
    - force: True
    - allow_untrusted: True
{% else %}
  archive.extracted:
    - source: 'file://{{ rubymine.tmpdir }}/{{ rubymine.dl.archive_name }}'
    - name: '{{ rubymine.alt.realhome }}'
    - archive_format: {{ rubymine.dl.archive_type }}
       {% if grains['saltversioninfo'] < [2016, 11, 0] %}
    - tar_options: {{ rubymine.dl.unpack_opts }}
    - if_missing: '{{ rubymine.alt.realcmd }}'
       {% else %}
    - options: {{ rubymine.dl.unpack_opts }}
       {% endif %}
       {% if grains['saltversioninfo'] >= [2016, 11, 0] %}
    - enforce_toplevel: False
       {% endif %}
       {%- if rubymine.dl.src_hashurl and grains['saltversioninfo'] > [2016, 11, 6] %}
    - source_hash: {{ rubymine.dl.src_hashurl }}
       {%- endif %}
{% endif %} 
    - onchanges:
      - cmd: rubymine-download-archive
    - require_in:
      - rubymine-remove-archive

rubymine-remove-archive:
  file.absent:
    - names:
      # todo: maybe just delete the tmpdir itself
      - '{{ rubymine.tmpdir }}/{{ rubymine.dl.archive_name }}'
      - '{{ rubymine.tmpdir }}/{{ rubymine.dl.archive_name }}.sha256'
    - onchanges:
{%- if grains.os in ('Windows') %}
      - pkg: rubymine-package-install
{%- elif grains.os in ('MacOS') %}
      - macpackage: rubymine-package-install
{% else %}
      - archive: rubymine-package-install

rubymine-home-symlink:
  file.symlink:
    - name: '{{ rubymine.symhome }}'
    - target: '{{ rubymine.alt.realhome }}'
    - force: True
    - onchanges:
      - archive: rubymine-package-install

# Update system profile with PATH
rubymine-config:
  file.managed:
    - name: /etc/profile.d/rubymine.sh
    - source: salt://rubymine/files/rubymine.sh
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - context:
      rubymine_home: '{{ rubymine.symhome }}'

{% endif %}
