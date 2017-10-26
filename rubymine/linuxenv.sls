{% from "rubymine/map.jinja" import rubymine with context %}

{% if grains.os not in ('MacOS', 'Windows') %}

rubymine-home-symlink:
  file.symlink:
    - name: '{{ rubymine.jetbrains.home }}/rubymine'
    - target: '{{ rubymine.jetbrains.realhome }}'
    - onlyif: test -d {{ rubymine.jetbrains.realhome }}
    - force: True

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
      home: '{{ rubymine.jetbrains.home }}/rubymine'

  # Debian alternatives
  {% if grains.os_family not in ('Arch') %}

# Add rubymine-home to alternatives system
rubymine-home-alt-install:
  alternatives.install:
    - name: rubymine-home
    - link: '{{ rubymine.jetbrains.home }}/rubymine'
    - path: '{{ rubymine.jetbrains.realhome }}'
    - priority: {{ rubymine.linux.altpriority }}

rubymine-home-alt-set:
  alternatives.set:
    - name: rubyminehome
    - path: {{ rubymine.jetbrains.realhome }}
    - onchanges:
      - alternatives: rubymine-home-alt-install

# Add intelli to alternatives system
rubymine-alt-install:
  alternatives.install:
    - name: rubymine
    - link: {{ rubymine.linux.symlink }}
    - path: {{ rubymine.jetbrains.realcmd }}
    - priority: {{ rubymine.linux.altpriority }}
    - require:
      - alternatives: rubymine-home-alt-install
      - alternatives: rubymine-home-alt-set

rubymine-alt-set:
  alternatives.set:
    - name: rubymine
    - path: {{ rubymine.jetbrains.realcmd }}
    - onchanges:
      - alternatives: rubymine-alt-install

  {% endif %}

{% endif %}
