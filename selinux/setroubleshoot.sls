{% set setroubleshoot = salt['pillar.get']('selinux:setroubleshoot', {}) -%}

{% if setroubleshoot.get('installed', False) %}
setroubleshoot_pkg_installed:
  pkg.installed:
    - pkgs:
      - setroubleshoot-server
      - setroubleshoot-plugins
{% endif %}

{% for email in setroubleshoot.get('email_alerts_enabled', []) %}
setroubleshoot_email_enabled_{{ email }}:
  file.line:
    - name: /var/lib/setroubleshoot/email_alert_recipients
    - mode: ensure
    - location: end
    - content: {{ email }}
    - create: true
{% endfor %}

{% for email in setroubleshoot.get('email_alerts_disabled', []) %}
setroubleshoot_email_disabled_{{ email }}:
  file.line:
    - name: /var/lib/setroubleshoot/email_alert_recipients
    - mode: delete
    - content: {{ email }}
    - create: true
{% endfor %}
