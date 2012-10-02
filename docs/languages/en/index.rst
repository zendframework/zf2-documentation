.. Zend Framework 2 documentation master file, created by
   sphinx-quickstart on Fri Jul  6 18:55:07 2012.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.
   TO TRANSLATORS: You don't need to copy this file to your translation, use
   translated-snippets.rst to translate titles if you want

|ProgrammersReferenceGuideofZendFramework2|
===========================================

.. toctree::
   :hidden:

   ref/overview
   ref/installation
   user-guide/overview
   user-guide/skeleton-application
   user-guide/unit-testing
   user-guide/modules
   user-guide/routing-and-controllers
   user-guide/database-and-models
   user-guide/styling-and-translations
   user-guide/forms-and-actions
   user-guide/conclusion
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
   modules/zend.crypt.public-key
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
   modules/zend.feed.introduction
   modules/zend.feed.importing
   modules/zend.feed.find-feeds
   modules/zend.feed.consuming-rss
   modules/zend.feed.consuming-atom
   modules/zend.feed.consuming-atom-single
   modules/zend.feed.security
   modules/zend.feed.reader
   modules/zend.feed.writer
   modules/zend.feed.pubsubhubbub
   modules/zend.form.intro
   modules/zend.form.quick-start
   modules/zend.form.collections
   modules/zend.form.elements
   modules/zend.form.view.helpers
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
   modules/zend.json.introduction
   modules/zend.json.basics
   modules/zend.json.objects
   modules/zend.json.xml2json
   modules/zend.json.server
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
   modules/zend.log.overview
   modules/zend.log.writers
   modules/zend.log.filters
   modules/zend.log.formatters
   modules/zend.mail.introduction
   modules/zend.mail.message
   modules/zend.mail.transport
   modules/zend.mail.smtp.options
   modules/zend.mail.file.options
   modules/zend.math.introduction
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
   modules/zend.navigation.intro
   modules/zend.navigation.quick-start
   modules/zend.navigation.pages
   modules/zend.navigation.containers
   modules/zend.paginator.introduction
   modules/zend.paginator.usage
   modules/zend.paginator.configuration
   modules/zend.paginator.advanced
   modules/zend.permissions.acl.intro
   modules/zend.permissions.acl.refining
   modules/zend.permissions.acl.advanced
   modules/zend.server
   modules/zend.server.reflection
   modules/zend.service-manager.intro
   modules/zend.service-manager.quick-start
   modules/zend.stdlib.hydrator
   modules/zend.tag.introduction
   modules/zend.tag.cloud
   modules/zend.text.figlet
   modules/zend.text.table
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
   modules/zendservice.livedocx
   ref/copyrights

|IntroductiontoZendFramework|
-----------------------------

    * :doc:`ref/overview`
    * :doc:`ref/installation`

|UserGuide|
-----------

|UserGuideIntroduction|

    * :doc:`user-guide/overview`
    * :doc:`user-guide/skeleton-application`
    * :doc:`user-guide/unit-testing`
    * :doc:`user-guide/modules`
    * :doc:`user-guide/routing-and-controllers`
    * :doc:`user-guide/database-and-models`
    * :doc:`user-guide/styling-and-translations`
    * :doc:`user-guide/forms-and-actions`
    * :doc:`user-guide/conclusion`

|LearningZendFramework|
-----------------------

    * :doc:`tutorials/quickstart.di`

|ZendFrameworkReference|
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
        * :doc:`modules/zend.console.routes`
        * :doc:`modules/zend.console.modules`
        * :doc:`modules/zend.console.controllers`
        * :doc:`modules/zend.console.adapter`
        * :doc:`modules/zend.console.prompts`


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
        * :doc:`modules/zend.crypt.public-key`

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

.. _zend.feed:

Zend\\Feed
^^^^^^^^^^

        * :doc:`modules/zend.feed.introduction`
        * :doc:`modules/zend.feed.importing`
        * :doc:`modules/zend.feed.find-feeds`
        * :doc:`modules/zend.feed.consuming-rss`
        * :doc:`modules/zend.feed.consuming-atom`
        * :doc:`modules/zend.feed.consuming-atom-single`
        * :doc:`modules/zend.feed.security`
        * :doc:`modules/zend.feed.reader`
        * :doc:`modules/zend.feed.writer`
        * :doc:`modules/zend.feed.pubsubhubbub`

.. _zend.form:

Zend\\Form
^^^^^^^^^^

        * :doc:`modules/zend.form.intro`
        * :doc:`modules/zend.form.quick-start`
        * :doc:`modules/zend.form.collections`
        * :doc:`modules/zend.form.elements`
        * :doc:`modules/zend.form.view.helpers`

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

.. _zend.json:

Zend\\Json
^^^^^^^^^^

        * :doc:`modules/zend.json.introduction`
        * :doc:`modules/zend.json.basics`
        * :doc:`modules/zend.json.objects`
        * :doc:`modules/zend.json.xml2json`
        * :doc:`modules/zend.json.server`

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

.. _zend.log:

Zend\\Log
^^^^^^^^^

        * :doc:`modules/zend.log.overview`
        * :doc:`modules/zend.log.writers`
        * :doc:`modules/zend.log.filters`
        * :doc:`modules/zend.log.formatters`

.. _zend.mail:

Zend\\Mail
^^^^^^^^^^

        * :doc:`modules/zend.mail.introduction`
        * :doc:`modules/zend.mail.message`
        * :doc:`modules/zend.mail.transport`
        * :doc:`modules/zend.mail.smtp.options`
        * :doc:`modules/zend.mail.file.options`

.. _zend.math:

Zend\\Math
^^^^^^^^^^

        * :doc:`modules/zend.math.introduction`

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

.. _zend.navigation:

Zend\\Navigation
^^^^^^^^^^^^^^^^

        * :doc:`modules/zend.navigation.intro`
        * :doc:`modules/zend.navigation.quick-start`
        * :doc:`modules/zend.navigation.pages`
        * :doc:`modules/zend.navigation.containers`

.. _zend.paginator:

Zend\\Paginator
^^^^^^^^^^^^^^^

        * :doc:`modules/zend.paginator.introduction`
        * :doc:`modules/zend.paginator.usage`
        * :doc:`modules/zend.paginator.configuration`
        * :doc:`modules/zend.paginator.advanced`

.. _zend.permissions.acl:

Zend\\Permissions\\Acl
^^^^^^^^^^^^^^^^^^^^^^

        * :doc:`modules/zend.permissions.acl.intro`
        * :doc:`modules/zend.permissions.acl.refining`
        * :doc:`modules/zend.permissions.acl.advanced`

.. _zend.server:

Zend\\Server
^^^^^^^^^^^^

        * :doc:`modules/zend.server`
        * :doc:`modules/zend.server.reflection`

.. _zend.service-manager:

Zend\\ServiceManager
^^^^^^^^^^^^^^^^^^^^

        * :doc:`modules/zend.service-manager.intro`
        * :doc:`modules/zend.service-manager.quick-start`

.. _zend.stdlib:

Zend\\Stdlib
^^^^^^^^^^^^

        * :doc:`modules/zend.stdlib.hydrator`

.. _zend.tag:

Zend\\Tag
^^^^^^^^^

        * :doc:`modules/zend.tag.introduction`
        * :doc:`modules/zend.tag.cloud`

Zend\\Text
^^^^^^^^^^

        * :doc:`modules/zend.text.figlet`
        * :doc:`modules/zend.text.table`

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

.. _zendservice:

|ZendServiceReference|
----------------------

ZendService\\LiveDocx
^^^^^^^^^^^^^^^^^^^^^

        * :doc:`modules/zendservice.livedocx`

.. _zend.copyright:

Copyright
---------

    * :doc:`ref/copyrights`

|IndicesAndTables|
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`

