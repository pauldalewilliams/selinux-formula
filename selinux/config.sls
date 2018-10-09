{% set selinux  = pillar.get('selinux', {}) -%}

selinux-config:
  file.managed:
    - name: /etc/selinux/config
    - user: root
    - group: root
    - mode: 600
    - source: salt://selinux/files/config
    - template: jinja

selinux-state:
    cmd.run:
        - name: setenforce {{ selinux.state|default('enforcing') }}
        - unless: if [ "$(sestatus | awk '/Current mode/ { print $3 }')" = {{ selinux.state|default('enforcing') }} ]; then /bin/true; else /bin/false; fi
