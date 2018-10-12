{% set setroubleshoot_config = salt['pillar.get']('selinux:setroubleshoot', {}).items() %}

{% if setroubleshoot_config.get('installed', False) %}
setroubleshoot_pkg_installed:
  pkg.installed:
    - pkgs:
      - setroubleshoot-server
      - setroubleshoot-plugins
{% endif %}

{% for email in setroubleshoot_config.get('email_alerts_enabled', {}) %}
setroubleshoot_email_enabled_{{ email }}:
  file.line:
    - name: /var/lib/setroubleshoot/email_alert_recipients
    - mode: ensure
    - content: {{ email }}
{% endfor %}

{% for bool in setroubleshoot_config.get('email_alerts_disabled', {}) %}
setroubleshoot_email_disabled_{{ email }}:
  file.line:
    - name: /var/lib/setroubleshoot/email_alert_recipients
    - mode: delete
    - content: {{ email }}
{% endfor %}
