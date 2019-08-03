{% from "rubymine/map.jinja" import rubymine with context %}

{% if rubymine.prefs.user %}

rubymine-desktop-shortcut-clean:
  file.absent:
    - name: '{{ rubymine.homes }}/{{ rubymine.prefs.user }}/Desktop/RubyMine'
    - require_in:
      - file: rubymine-desktop-shortcut-add
    - onlyif: test "`uname`" = "Darwin"

rubymine-desktop-shortcut-add:
  file.managed:
    - name: /tmp/mac_shortcut.sh
    - source: salt://rubymine/files/mac_shortcut.sh
    - mode: 755
    - template: jinja
    - context:
      user: {{ rubymine.prefs.user|json }}
      homes: {{ rubymine.homes|json }}
      edition: {{ rubymine.jetbrains.edition|json }}
    - onlyif: test "`uname`" = "Darwin"
  cmd.run:
    - name: /tmp/mac_shortcut.sh {{ rubymine.jetbrains.edition }}
    - runas: {{ rubymine.prefs.user }}
    - require:
      - file: rubymine-desktop-shortcut-add
    - require_in:
      - file: rubymine-desktop-shortcut-install
    - onlyif: test "`uname`" = "Darwin"

rubymine-desktop-shortcut-install
  file.managed:
    - source: salt://rubymine/files/rubymine.desktop
    - name: {{ rubymine.homes }}/{{ rubymine.prefs.user }}/Desktop/rubymine{{ rubymine.jetbrains.edition }}.desktop
    - makedirs: True
    - user: {{ rubymine.prefs.user }}
       {% if rubymine.prefs.group and grains.os not in ('MacOS',) %}
    - group: {{ rubymine.prefs.group }}
       {% endif %}
    - makedirs: True
    - mode: 644
    - force: True
    - template: jinja
    - onlyif: test -f {{ rubymine.jetbrains.realcmd }}
    - context:
      home: {{ rubymine.jetbrains.realhome|json }}
      command: {{ rubymine.command|json }}

  {% if rubymine.prefs.jarurl or rubymine.prefs.jardir %}

rubymine-prefs-importfile:
  file.managed:
    - onlyif: test -f {{ rubymine.prefs.jardir }}/{{ rubymine.prefs.jarfile }}
    - name: {{ rubymine.homes }}/{{ rubymine.prefs.user }}/{{ rubymine.prefs.jarfile }}
    - source: {{ rubymine.prefs.jardir }}/{{ rubymine.prefs.jarfile }}
    - makedirs: True
    - user: {{ rubymine.prefs.user }}
       {% if rubymine.prefs.group and grains.os not in ('MacOS',) %}
    - group: {{ rubymine.prefs.group }}
       {% endif %}
    - if_missing: {{ rubymine.homes }}/{{ rubymine.prefs.user }}/{{ rubymine.prefs.jarfile }}
  cmd.run:
    - unless: test -f {{ rubymine.prefs.jardir }}/{{ rubymine.prefs.jarfile }}
    - name: curl -o {{rubymine.homes}}/{{rubymine.prefs.user}}/{{rubymine.prefs.jarfile}} {{rubymine.prefs.jarurl}}
    - runas: {{ rubymine.prefs.user }}
    - if_missing: {{ rubymine.homes }}/{{ rubymine.prefs.user }}/{{ rubymine.prefs.jarfile }}
  {% endif %}

{% endif %}

