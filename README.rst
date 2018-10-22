===========
selinux-formula
===========

Salt Stack Formula to set up and configure SELinux, Security-Enhanced Linux

NOTICE BEFORE YOU USE
=====================

* This formula aims to follow the conventions and recommendations described at http://docs.saltstack.com/topics/conventions/formulas.html

TODO
====

* Break out setroubleshoot into its own formula

Instructions
============

1. Fork this repository and then add your fork as a `GitFS <http://docs.saltstack.com/topics/tutorials/gitfs.html>`_ backend in your Salt master config.

2. Configure your Pillar top file (``/srv/pillar/top.sls``), see pillar.example

3. Include this Formula within another Formula or simply define your needed states within the Salt top file (``/srv/salt/top.sls``).

Available states
================

.. contents::
    :local:

``selinux``
-------
Manage SELinux - includes all of the states listed below

``selinux.pkg``
-------
Install SELinux packages

``selinux.config``
-------
Manage SELinux config

``selinux.booleans``
-------
Manage SELinux booleans

``selinux.ports``
-------
Manage SELinux ports

``selinux.fcontext``
-------
Manage SELinux file contexts

``selinux.modules``
-------
Manage SELinux modules

``selinux.setroubleshoot``
-------
Manage setroubleshoot (install, configure email alerts)

Additional resources
====================

None

Formula Dependencies
====================

None

Contributions
=============

Contributions are always welcome. All development guidelines you have to know are

* write clean code (proper YAML+Jinja syntax, no trailing whitespaces, no empty lines with whitespaces, LF only)
* set sane default settings
* test your code (see Testing below)
* update README.rst doc

Salt Compatibility
==================

Tested with:

* 2018.3.x

OS Compatibility
================

Tested with:

* CentOS 6
* CentOS 7

Testing
=======

Testing is done with `Test Kitchen <http://kitchen.ci/>`_
for machine setup and `testinfra <https://testinfra.readthedocs.io/en/latest/>`_
for integration tests.

Requirements
------------

* Python & modules in requirements.txt
* Ruby
* Vagrant - required since SELinux doesn't work inside Docker containers, open to suggestions

::

    gem install bundler
    bundle install
    pip install -r requirements.txt
    kitchen test