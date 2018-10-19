{% set setroubleshoot = salt['pillar.get']('selinux:setroubleshoot', {}) -%}

{% if setroubleshoot.get('installed', False) %}
setroubleshoot_pkg_installed:
  pkg.installed:
    - pkgs:
      - setroubleshoot-server
      - setroubleshoot-plugins

setroubleshoot_email_alert_recipients_exists:
  file.managed:
    - name: /var/lib/setroubleshoot/email_alert_recipients
{% endif %}

{% for email in setroubleshoot.get('email_alerts_enabled', []) %}
setroubleshoot_email_enabled_{{ email }}:
  file.append:
    - name: /var/lib/setroubleshoot/email_alert_recipients
    - text: {{ email }}
{% endfor %}

{% for email in setroubleshoot.get('email_alerts_disabled', []) %}
setroubleshoot_email_disabled_{{ email }}:
  file.line:
    - name: /var/lib/setroubleshoot/email_alert_recipients
    - mode: delete
    - content: {{ email }}
{% endfor %}
