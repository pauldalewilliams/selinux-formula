{% set selinux  = pillar.get('selinux', {}) -%}

{% for file, config in salt['pillar.get']('selinux:fcontext', {}).items() %}
{% set parameters = [] %}
{% if 'type' in config %}
  {% do parameters.append('-t ' + config.type) %}
{% endif %}
{% if 'user' in config %}
  {% do parameters.append('-s ' + config.user) %}
{% endif %}
selinux_fcontext_{{ file }}:
  cmd:
    - run
    - name: semanage fcontext -a {{ ' '.join(parameters) }} "{{ file }}"
    - require:
      - pkg: selinux
{% endfor %}

{% for file in salt['pillar.get']('selinux:fcontext.absent', {}) %}
selinux_fcontext_{{ file }}_absent:
  cmd:
    - run
    - name: semanage fcontext -d "{{ file }}"
    - require:
      - pkg: selinux
    - unless: if (semanage fcontext --list | grep -q "^{{ file }} "); then /bin/false; else /bin/true; fi
{% endfor %}
