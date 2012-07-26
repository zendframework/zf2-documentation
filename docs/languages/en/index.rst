.. Zend Framework 2 documentation master file, created by
   sphinx-quickstart on Fri Jul  6 18:55:07 2012.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Programmer's Reference Guide of Zend Framework 2
================================================

.. toctree:: 
   :hidden:

   ref/overview
   ref/installation
   tutorials/quickstart.di
   modules/zend.authentication.intro
   modules/zend.authentication.adapter.dbtable
   modules/zend.authentication.adapter.digest
   modules/zend.authentication.adapter.http
   modules/zend.authentication.adapter.ldap
   modules/zend.barcode.intro
   modules/zend.barcode.creation
   modules/zend.barcode.objects
   modules/zend.barcode.renderers
   modules/zend.cache.theory 
   modules/zend.cache.introduction 
   modules/zend.cache.frontends
   modules/zend.cache.storage.adapter
   modules/zend.cache.storage.capabilities
   modules/zend.cache.storage.plugin
   modules/zend.cache.pattern
   modules/zend.captcha.intro 
   modules/zend.captcha.operation
   modules/zend.captcha.adapters 
   modules/zend.config.introduction 
   modules/zend.config.theory-of-operation
   modules/zend.config.reader
   modules/zend.config.writer
   modules/zend.config.processor
   modules/zend.crypt.introduction 
   modules/zend.crypt.block-cipher
   modules/zend.crypt.key.derivation
   modules/zend.crypt.password
   modules/zend.db.adapter
   modules/zend.db.result-set
   modules/zend.db.sql
   modules/zend.db.table-gateway
   modules/zend.db.row-gateway
   modules/zend.db.metadata
   modules/zend.di.introduction
   modules/zend.di.quick-start
   modules/zend.di.definitions
   modules/zend.di.instance-manager
   modules/zend.di.configuration
   modules/zend.di.debugging-and-complex-use-cases
   modules/zend.dom.intro
   modules/zend.dom.query
   modules/zend.event-manager.event-manager
   modules/zend.form.intro
   modules/zend.form.quick-start
   modules/zend.form.element
   modules/zend.form.element.captcha
   modules/zend.form.element.color
   modules/zend.form.element.csrf
   modules/zend.form.element.date
   modules/zend.form.element.date.time.local
   modules/zend.form.element.date.time
   modules/zend.form.element.email
   modules/zend.form.element.month
   modules/zend.form.element.number
   modules/zend.form.element.range
   modules/zend.form.element.time
   modules/zend.form.element.url
   modules/zend.form.element.week
   modules/zend.http
   modules/zend.http.request
   modules/zend.http.response
   modules/zend.http.headers
   modules/zend.http.cookie.handling
   modules/zend.http.client
   modules/zend.http.client.adapters
   modules/zend.http.client.advanced
   modules/zend.i18n.translating
   modules/zend.i18n.view.helpers
   modules/zend.i18n.filters
   modules/zend.input-filter.intro
   modules/zend.ldap.introduction
   modules/zend.ldap.api
   modules/zend.ldap.usage
   modules/zend.ldap.tools
   modules/zend.ldap.node
   modules/zend.ldap.server
   modules/zend.ldap.ldif
   modules/zend.loader.autoloader-factory
   modules/zend.loader.plugin-class-loader
   modules/zend.loader.short-name-locator
   modules/zend.loader.plugin-class-locator
   modules/zend.loader.spl-autoloader
   modules/zend.loader.class-map-autoloader
   modules/zend.loader.standard-autoloader
   modules/zend.loader.classmap-generator
   modules/zend.loader.prefix-path-loader
   modules/zend.loader.prefix-path-mapper
   modules/zend.mail.message
   modules/zend.mail.transport
   modules/zend.mail.smtp.options
   modules/zend.mail.file.options
   modules/zend.module-manager.intro
   modules/zend.module-manager.module-manager
   modules/zend.module-manager.module-class
   modules/zend.module-manager.module-autoloader
   modules/zend.module-manager.best-practices
   modules/zend.mvc.intro
   modules/zend.mvc.quick-start
   modules/zend.mvc.services
   modules/zend.mvc.routing
   modules/zend.mvc.mvc-event
   modules/zend.mvc.controllers
   modules/zend.mvc.plugins
   modules/zend.mvc.examples
   modules/zend.permissions.acl.intro
   modules/zend.permissions.acl.refining
   modules/zend.permissions.acl.advanced
   modules/zend.service-manager.intro
   modules/zend.service-manager.quick-start
   modules/zend.stdlib.hydrator
   modules/zend.uri
   modules/zend.validator
   modules/zend.validator.set
   modules/zend.validator.validator-chains
   modules/zend.validator.writing-validators
   modules/zend.validator.messages
   modules/zend.view.quick-start
   modules/zend.view.renderer.php-renderer
   modules/zend.view.php-renderer.scripts
   modules/zend.view.helpers
   modules/zend.xmlrpc.intro
   modules/zend.xmlrpc.client
   modules/zend.xmlrpc.server
   ref/copyrights

Introduction to Zend Framework
------------------------------

    * :doc:`ref/overview` 
    * :doc:`ref/installation`

Learning Zend Framework
-----------------------

    * :doc:`tutorials/quickstart.di`

Zend Framework Reference
------------------------

.. _zend.authentication:

Zend\\Authentication
^^^^^^^^^^^^^^^^^^^^

        * :doc:`modules/zend.authentication.intro`
        * :doc:`modules/zend.authentication.adapter.dbtable`
        * :doc:`modules/zend.authentication.adapter.digest`
        * :doc:`modules/zend.authentication.adapter.http`
        * :doc:`modules/zend.authentication.adapter.ldap`

.. _zend.barcode:

Zend\\Barcode
^^^^^^^^^^^^^

        * :doc:`modules/zend.barcode.intro`
        * :doc:`modules/zend.barcode.creation`
        * :doc:`modules/zend.barcode.objects`
        * :doc:`modules/zend.barcode.renderers`

.. _zend.cache:

Zend\\Cache
^^^^^^^^^^^

        * :doc:`modules/zend.cache.theory` 
        * :doc:`modules/zend.cache.introduction` 
        * :doc:`modules/zend.cache.frontends`
        * :doc:`modules/zend.cache.storage.adapter`
        * :doc:`modules/zend.cache.storage.capabilities`
        * :doc:`modules/zend.cache.storage.plugin`
        * :doc:`modules/zend.cache.pattern`

.. _zend.captcha:

Zend\\Captcha
^^^^^^^^^^^^^

        * :doc:`modules/zend.captcha.intro` 
        * :doc:`modules/zend.captcha.operation`
        * :doc:`modules/zend.captcha.adapters`

.. _zend.console:

Zend\\Console
^^^^^^^^^^^^^

        * :doc:`modules/zend.console.introduction`

..
        * :doc:`modules/zend.console.routes`
        * :doc:`modules/zend.console.controllers`
        * :doc:`modules/zend.console.modules`

.. _zend.config:

Zend\\Config
^^^^^^^^^^^^

        * :doc:`modules/zend.config.introduction` 
        * :doc:`modules/zend.config.theory-of-operation`
        * :doc:`modules/zend.config.reader`
        * :doc:`modules/zend.config.writer`
        * :doc:`modules/zend.config.processor`

.. _zend.crypt:

Zend\\Crypt
^^^^^^^^^^^

        * :doc:`modules/zend.crypt.introduction` 
        * :doc:`modules/zend.crypt.block-cipher`
        * :doc:`modules/zend.crypt.key.derivation`
        * :doc:`modules/zend.crypt.password`

.. _zend.db:

Zend\\Db
^^^^^^^^

        * :doc:`modules/zend.db.adapter`
        * :doc:`modules/zend.db.result-set`
        * :doc:`modules/zend.db.sql`
        * :doc:`modules/zend.db.table-gateway`
        * :doc:`modules/zend.db.row-gateway`
        * :doc:`modules/zend.db.metadata`

.. _zend.di:

Zend\\Di
^^^^^^^^

        * :doc:`modules/zend.di.introduction`
        * :doc:`modules/zend.di.quick-start`
        * :doc:`modules/zend.di.definitions`
        * :doc:`modules/zend.di.instance-manager`
        * :doc:`modules/zend.di.configuration`
        * :doc:`modules/zend.di.debugging-and-complex-use-cases`

.. _zend.dom:

Zend\\Dom
^^^^^^^^^

        * :doc:`modules/zend.dom.intro`
        * :doc:`modules/zend.dom.query`

.. _zend.event-manager:

Zend\\EventManager
^^^^^^^^^^^^^^^^^^

        * :doc:`modules/zend.event-manager.event-manager`

.. _zend.form:

Zend\\Form
^^^^^^^^^^

        * :doc:`modules/zend.form.intro`
        * :doc:`modules/zend.form.quick-start`
        * :doc:`modules/zend.form.element`
        * :doc:`modules/zend.form.element.captcha`
        * :doc:`modules/zend.form.element.color`
        * :doc:`modules/zend.form.element.csrf`
        * :doc:`modules/zend.form.element.date`
        * :doc:`modules/zend.form.element.date.time.local`
        * :doc:`modules/zend.form.element.date.time`
        * :doc:`modules/zend.form.element.email`
        * :doc:`modules/zend.form.element.month`
        * :doc:`modules/zend.form.element.number`
        * :doc:`modules/zend.form.element.range`
        * :doc:`modules/zend.form.element.time`
        * :doc:`modules/zend.form.element.url`
        * :doc:`modules/zend.form.element.week`

.. _zend.http:

Zend\\Http
^^^^^^^^^^

        * :doc:`modules/zend.http`
        * :doc:`modules/zend.http.request`
        * :doc:`modules/zend.http.response`
        * :doc:`modules/zend.http.headers`
        * :doc:`modules/zend.http.cookie.handling`
        * :doc:`modules/zend.http.client`
        * :doc:`modules/zend.http.client.adapters`
        * :doc:`modules/zend.http.client.advanced`

.. _zend.i18n:

Zend\\I18n
^^^^^^^^^^

        * :doc:`modules/zend.i18n.translating`
        * :doc:`modules/zend.i18n.view.helpers`
        * :doc:`modules/zend.i18n.filters`

.. _zend.input-filter:

Zend\\InputFilter
^^^^^^^^^^^^^^^^^

        * :doc:`modules/zend.input-filter.intro`

.. _zend.ldap:

Zend\\Ldap
^^^^^^^^^^

        * :doc:`modules/zend.ldap.introduction`
        * :doc:`modules/zend.ldap.api`
        * :doc:`modules/zend.ldap.usage`
        * :doc:`modules/zend.ldap.tools`
        * :doc:`modules/zend.ldap.node`
        * :doc:`modules/zend.ldap.server`
        * :doc:`modules/zend.ldap.ldif`

.. _zend.loader:

Zend\\Loader
^^^^^^^^^^^^

        * :doc:`modules/zend.loader.autoloader-factory`
        * :doc:`modules/zend.loader.plugin-class-loader`
        * :doc:`modules/zend.loader.short-name-locator`
        * :doc:`modules/zend.loader.plugin-class-locator`
        * :doc:`modules/zend.loader.spl-autoloader`
        * :doc:`modules/zend.loader.class-map-autoloader`
        * :doc:`modules/zend.loader.standard-autoloader`
        * :doc:`modules/zend.loader.classmap-generator`
        * :doc:`modules/zend.loader.prefix-path-loader`
        * :doc:`modules/zend.loader.prefix-path-mapper`

.. _zend.mail:

Zend\\Mail
^^^^^^^^^^

        * :doc:`modules/zend.mail.message`
        * :doc:`modules/zend.mail.transport`
        * :doc:`modules/zend.mail.smtp.options`
        * :doc:`modules/zend.mail.file.options`

.. _zend.module-manager:

Zend\\ModuleManager
^^^^^^^^^^^^^^^^^^^

        * :doc:`modules/zend.module-manager.intro`
        * :doc:`modules/zend.module-manager.module-manager`
        * :doc:`modules/zend.module-manager.module-class`
        * :doc:`modules/zend.module-manager.module-autoloader`
        * :doc:`modules/zend.module-manager.best-practices`

.. _zend.mvc:

Zend\\Mvc
^^^^^^^^^

        * :doc:`modules/zend.mvc.intro`
        * :doc:`modules/zend.mvc.quick-start`
        * :doc:`modules/zend.mvc.services`
        * :doc:`modules/zend.mvc.routing`
        * :doc:`modules/zend.mvc.mvc-event`
        * :doc:`modules/zend.mvc.controllers`
        * :doc:`modules/zend.mvc.plugins`
        * :doc:`modules/zend.mvc.examples`

.. _zend.permissions.acl:

Zend\\Permissions\\Acl
^^^^^^^^^^^^^^^^^^^^^^

        * :doc:`modules/zend.permissions.acl.intro`
        * :doc:`modules/zend.permissions.acl.refining`
        * :doc:`modules/zend.permissions.acl.advanced`

.. _zend.service-manager:

Zend\\ServiceManager
^^^^^^^^^^^^^^^^^^^^

        * :doc:`modules/zend.service-manager.intro`
        * :doc:`modules/zend.service-manager.quick-start`

.. _zend.stdlib:

Zend\\Stdlib
^^^^^^^^^^^^

        * :doc:`modules/zend.stdlib.hydrator`

.. _zend.uri:

Zend\\Uri
^^^^^^^^^

        * :doc:`modules/zend.uri`

.. _zend.validator:

Zend\\Validator
^^^^^^^^^^^^^^^

        * :doc:`modules/zend.validator`
        * :doc:`modules/zend.validator.set`
        * :doc:`modules/zend.validator.validator-chains`
        * :doc:`modules/zend.validator.writing-validators`
        * :doc:`modules/zend.validator.messages`

.. _zend.view:

Zend\\View
^^^^^^^^^^

        * :doc:`modules/zend.view.quick-start`
        * :doc:`modules/zend.view.renderer.php-renderer`
        * :doc:`modules/zend.view.php-renderer.scripts`
        * :doc:`modules/zend.view.helpers`

.. _zend.xmlrpc:

Zend\\XmlRpc
^^^^^^^^^^^^

        * :doc:`modules/zend.xmlrpc.intro`
        * :doc:`modules/zend.xmlrpc.client`
        * :doc:`modules/zend.xmlrpc.server`

.. _zend.copyright:

Copyright
---------

    * :doc:`ref/copyrights`

Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`

