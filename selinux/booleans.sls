{% set selinux  = pillar.get('selinux', {}) -%}

{% for bool in salt['pillar.get']('selinux:booleans_enabled', {}) %}
selinux_boolean_{{ bool }}_enabled:
  selinux.boolean:
    - name: {{ bool }}
    - value: 'on'
    - persist: True
{% endfor %}

{% for bool in salt['pillar.get']('selinux:booleans_disabled', {}) %}
selinux_boolean_{{ bool }}_disabled:
  selinux.boolean:
    - name: {{ bool }}
    - value: 'off'
    - persist: True
{% endfor %}