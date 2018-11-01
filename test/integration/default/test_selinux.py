import testinfra

def test_pkgs_installed(host):
    pkgs = ['libselinux',
            'libselinux-utils',
            'libselinux-python',
            'selinux-policy',
            'selinux-policy-targeted',
            'policycoreutils',
            'policycoreutils-python',
            'setroubleshoot-server',
            'setroubleshoot-plugins']
    for pkg in pkgs:
        pkgtest = host.package(pkg)
        assert pkgtest.is_installed

def test_setroubleshoot_emails(host):
    with host.sudo():
        email_recipients = host.file("/var/lib/setroubleshoot/email_alert_recipients")
        assert email_recipients.contains("mail@example.com")
        assert not email_recipients.contains("nomail@example.com")

def test_selinux_booleans(host):
    with host.sudo():
        host.run_expect([0], 'semanage boolean -l | grep httpd_can_sendmail | grep "(on   ,   on)"')
        host.run_expect([0], 'semanage boolean -l | grep httpd_enable_cgi | grep "(off  ,  off)"')

def test_selinux_config(host):
    with host.sudo():
        selinux_config = host.file("/etc/selinux/config")
        assert selinux_config.user == 'root'
        assert selinux_config.group == 'root'
        assert selinux_config.mode == 0o600
        assert selinux_config.contains("SELINUX=enforcing")
        assert selinux_config.contains("SELINUXTYPE=targeted")
        assert host.check_output("getenforce") == "Enforcing"

def test_selinux_ports(host):
    with host.sudo():
        host.run_expect([0], 'semanage port -l | grep ^http_port_t | grep 8088')

def test_selinux_modules(host):
    with host.sudo():
        selinux_src_dir = host.file("/etc/selinux/src")
        assert selinux_src_dir.is_directory
        files = ['zabbix_agent', 'zabbix_server', 'zabbix_server_34']
        for file in files:
            se_policy = host.file("/etc/selinux/src/" + file + ".te")
            se_mod = host.file("/etc/selinux/src/" + file + ".mod")
            se_package = host.file("/etc/selinux/src/" + file + ".pp")
            assert se_policy.exists
            assert se_mod.exists
            assert se_package.exists
        host.run_expect([0], 'semodule -l | grep zabbix_agent')
        host.run_expect([0], 'semodule -l | grep zabbix_server | grep Disabled || semodule -lfull | grep zabbix_server | grep disabled')
        host.run_expect([1], 'semodule -l | grep zabbix_server_34')        

def test_selinux_fcontext(host):
    with host.sudo():
        host.run_expect([0], "semanage fcontext -l | grep -F '/var/games(/.*)?' | grep games_data_t")
        host.run_expect([1], "semanage fcontext -l | grep -F '/var/www/html/example(/.*)?'")
        host.run_expect([1], "semanage fcontext -l | grep -F '/var/www/html/test/example'")
