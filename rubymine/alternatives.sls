{% from "rubymine/map.jinja" import rubymine with context %}

{% if grains.os not in ('MacOS', 'Windows') %}

  {% if grains.os_family not in ('Arch') %}

# Add pyCharmhome to alternatives system
rubymine-home-alt-install:
  alternatives.install:
    - name: rubyminehome
    - link: {{ rubymine.symhome }}
    - path: {{ rubymine.alt.realhome }}
    - priority: {{ rubymine.alt.priority }}

rubymine-home-alt-set:
  alternatives.set:
    - name: rubyminehome
    - path: {{ rubymine.alt.realhome }}
    - onchanges:
      - alternatives: rubymine-home-alt-install

# Add to alternatives system
rubymine-alt-install:
  alternatives.install:
    - name: rubymine
    - link: {{ rubymine.symlink }}
    - path: {{ rubymine.alt.realcmd }}
    - priority: {{ rubymine.alt.priority }}
    - require:
      - alternatives: rubymine-home-alt-install
      - alternatives: rubymine-home-alt-set

rubymine-alt-set:
  alternatives.set:
    - name: rubymine
    - path: {{ rubymine.alt.realcmd }}
    - onchanges:
      - alternatives: rubymine-alt-install

  {% endif %}

{% endif %}
