selinux_pkgs_installed:
  pkg.installed:
    - pkgs:
      - libselinux
      - libselinux-utils
      - libselinux-python
      - selinux-policy
      - selinux-policy-targeted
      - policycoreutils
      - policycoreutils-python
    - reload_modules: true
