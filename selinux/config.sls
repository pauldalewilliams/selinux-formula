{% set selinux  = salt['pillar.get']('selinux', {}) -%}

selinux-config:
  file.managed:
    - name: /etc/selinux/config
    - user: root
    - group: root
    - mode: 600
    - source: salt://selinux/files/config
    - template: jinja

{{ selinux.mode|default('enforcing') }}:
    selinux.mode
