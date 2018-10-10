{% set selinux  = pillar.get('selinux', {}) -%}

/etc/selinux/src:
  file.directory:
    - user: root
    - group: root


{% for k, v in salt['pillar.get']('selinux:modules', {}).items() %}
  {% set v_name = v.name|default(k) %}

resetifmissing_{{ k }}:
  cmd.run:
    - name: rm -f /etc/selinux/src/{{ v_name }}.te
    - unless: if [ "$(semodule -l | awk '{ print $1 }' | grep {{ v_name }} )" == "{{ v_name }}" ]; then /bin/true; else /bin/false; fi

policy_{{ k }}:
  file.managed:
    - name: /etc/selinux/src/{{ v_name }}.te
    - user: root
    - group: root
    - mode: 600
    - contents_pillar: selinux:modules:{{ v_name }}:plain

checkmodule_{{ k }}:
  cmd.run:
    - name: checkmodule -M -m -o {{ v_name }}.mod {{ v_name }}.te
    - cwd: /etc/selinux/src
    - onchanges:
      - file: /etc/selinux/src/{{ v_name }}.te

create_package_{{ k }}:
  cmd.run:
    - name: semodule_package -m {{ v_name }}.mod -o {{ v_name }}.pp
    - cwd: /etc/selinux/src
    - onchanges:
      - cmd: checkmodule_{{ k }}

manage_semodule_{{ k }}:
  selinux.module:
    - name: {{ v_name }}
    - module_state: enabled
    - install: True
    - source: /etc/selinux/src/{{ v_name }}.pp
    - require:
      - cmd: resetifmissing_{{ k }}
      - file: /etc/selinux/src/{{ v_name }}.te
      - cmd: checkmodule_{{ k }}
      - cmd: create_package_{{ k }}

{% endfor %}


{% for module_name in salt['pillar.get']('selinux:modules_disabled', {}) %}
selinux_module_{{ module_name }}_disabled:
  selinux.module:
    - name: {{ module_name }}
    - module_state: disabled
{% endfor %}


{% for module_name in salt['pillar.get']('selinux:modules_removed', {}) %}
selinux_module_{{ module_name }}_removed:
  selinux.module:
    - name: {{ module_name }}
    - remove: True
{% endfor %}
