{% from "rubymine/map.jinja" import rubymine with context %}

{% if rubymine.prefs.user not in (None, 'undfined', 'undefined_user') %}

  {% if grains.os == 'MacOS' %}
rubymine-desktop-shortcut-clean:
  file.absent:
    - name: '{{ rubymine.homes }}/{{ rubymine.prefs.user }}/Desktop/RubyMine'
    - require_in:
      - file: rubymine-desktop-shortcut-add
  {% endif %}

rubymine-desktop-shortcut-add:
  {% if grains.os == 'MacOS' %}
  file.managed:
    - name: /tmp/mac_shortcut.sh
    - source: salt://rubymine/files/mac_shortcut.sh
    - mode: 755
    - template: jinja
    - context:
      user: {{ rubymine.prefs.user }}
      homes: {{ rubymine.homes }}
      edition: {{ rubymine.jetbrains.edition }}
  cmd.run:
    - name: /tmp/mac_shortcut.sh {{ rubymine.jetbrains.edition }}
    - runas: {{ rubymine.prefs.user }}
    - require:
      - file: rubymine-desktop-shortcut-add
   {% else %}
   #Linux
  file.managed:
    - source: salt://rubymine/files/rubymine.desktop
    - name: {{ rubymine.homes }}/{{ rubymine.prefs.user }}/Desktop/rubymine{{ rubymine.jetbrains.edition }}.desktop
    - user: {{ rubymine.prefs.user }}
    - makedirs: True
      {% if salt['grains.get']('os_family') in ('Suse') %} 
    - group: users
      {% else %}
    - group: {{ rubymine.prefs.user }}
      {% endif %}
    - mode: 644
    - force: True
    - template: jinja
    - onlyif: test -f {{ rubymine.jetbrains.realcmd }}
    - context:
      home: {{ rubymine.jetbrains.realhome }}
      command: {{ rubymine.command }}
   {% endif %}


  {% if rubymine.prefs.jarurl or rubymine.prefs.jardir %}

rubymine-prefs-importfile:
   {% if rubymine.prefs.jardir %}
  file.managed:
    - onlyif: test -f {{ rubymine.prefs.jardir }}/{{ rubymine.prefs.jarfile }}
    - name: {{ rubymine.homes }}/{{ rubymine.prefs.user }}/{{ rubymine.prefs.jarfile }}
    - source: {{ rubymine.prefs.jardir }}/{{ rubymine.prefs.jarfile }}
    - user: {{ rubymine.prefs.user }}
    - makedirs: True
        {% if grains.os_family in ('Suse') %}
    - group: users
        {% elif grains.os not in ('MacOS') %}
        #inherit Darwin ownership
    - group: {{ rubymine.prefs.user }}
        {% endif %}
    - if_missing: {{ rubymine.homes }}/{{ rubymine.prefs.user }}/{{ rubymine.prefs.jarfile }}
   {% else %}
  cmd.run:
    - name: curl -o {{rubymine.homes}}/{{rubymine.prefs.user}}/{{rubymine.prefs.jarfile}} {{rubymine.prefs.jarurl}}
    - runas: {{ rubymine.prefs.user }}
    - if_missing: {{ rubymine.homes }}/{{ rubymine.prefs.user }}/{{ rubymine.prefs.jarfile }}
   {% endif %}

  {% endif %}

{% endif %}

