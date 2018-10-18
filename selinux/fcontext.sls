{% set selinux  = salt['pillar.get']('selinux', {}) -%}

{% for file, config in selinux.get('fcontext', {}).items() %}
{% set config = config|default([], true) %}
selinux_fcontext_{{ file }}:
  selinux.fcontext_policy_present:
    - name: {{ file }}
    - sel_type: {{ config['sel_type'] }}
    {% if 'filetype' in config -%}
    - filetype: {{ config['filetype'] }}
    {%- endif %}
    {% if 'sel_user' in config -%}
    - sel_user: {{ config['sel_user'] }}
    {%- endif %}
    {% if 'sel_level' in config -%}
    - sel_level: {{ config['sel_level'] }}
    {%- endif %}
{% endfor %}


{% for file, config in selinux.get('fcontext_applied', {}).items() %}
{% set config = config|default([], true) %}
selinux_fcontext_applied_{{ file }}:
  selinux.fcontext_policy_applied:
    - name: {{ file }}
    {% if 'recursive' in config -%}
    - recursive: {{ config['recursive'] }}
    {%- endif %}
{% endfor %}


{% for file, config in selinux.get('fcontext_absent', {}).items() %}
{% set config = config|default([], true) %}
selinux_fcontext_{{ file }}_absent:
  selinux.fcontext_policy_absent:
    - name: {{ file }}
    {% if 'filetype' in config -%}
    - filetype: {{ config['filetype'] }}
    {%- endif %}
    {% if 'sel_type' in config -%}
    - sel_type: {{ config['sel_type'] }}
    {%- endif %}
    {% if 'sel_user' in config -%}
    - sel_user: {{ config['sel_user'] }}
    {%- endif %}
    {% if 'sel_level' in config -%}
    - sel_level: {{ config['sel_level'] }}
    {%- endif %}
{% endfor %}
