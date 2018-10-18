{% set selinux  = salt['pillar.get']('selinux', {}) -%}

{% for application, config in selinux.get('ports', {}).items() %}
{% for protocol, ports in config.items() %}
{% for port in ports %}
selinux_{{ application }}_{{ protocol }}_port_{{ port }}:
  cmd.run:
    - name: semanage port -a -t {{ application }}_port_t -p {{ protocol }} {{ port }}
    - unless: FOUND="no"; for i in $(semanage port -l | grep {{ application }}_port_t | tr -s ' ' | cut -d ' ' -f 3- | tr -d ','); do if [ "$i" == "{{ port }}" ]; then FOUND="yes"; fi; done; if [ "$FOUND" == "yes" ]; then /bin/true; else /bin/false; fi
{% endfor %}
{% endfor %}
{% endfor %}

{% for application, config in selinux.get('ports_absent', {}).items() %}
{% for protocol, ports in config.items() %}
{% for port in ports %}
selinux_{{ application }}_{{ protocol }}_port_{{ port }}_absent:
  cmd.run:
    - name: semanage port -d -t {{ application }}_port_t -p {{ protocol }} {{ port }}
    - unless: FOUND="no"; for i in $(semanage port -l | grep {{ application }}_port_t | tr -s ' ' | cut -d ' ' -f 3- | tr -d ','); do if [ "$i" == "{{ port }}" ]; then FOUND="yes"; fi; done; if [ "$FOUND" == "yes" ]; then /bin/false; else /bin/true; fi
{% endfor %}
{% endfor %}
{% endfor %}
