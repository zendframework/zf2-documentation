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
   user-guide/modules
   user-guide/routing-and-controllers
   user-guide/database-and-models
   user-guide/styling-and-translations
   user-guide/forms-and-actions
   user-guide/conclusion
   in-depth-guide/first-module
   in-depth-guide/services-and-servicemanager
   in-depth-guide/preparing-db-backend
   in-depth-guide/zend-db-sql-zend-stdlib-hydrator
   in-depth-guide/understanding-routing
   in-depth-guide/zend-form-zend-form-fieldset
   in-depth-guide/data-binding
   in-depth-guide/review
   getting-started-with-zend-studio/overview
   getting-started-with-zend-studio/skeleton-application
   getting-started-with-zend-studio/the-application
   getting-started-with-zend-studio/tasks
   getting-started-with-zend-studio/diagnostics
   getting-started-with-zend-studio/conclusion
   modules/zendtool.introduction
   tutorials/quickstart.di
   tutorials/unittesting
   tutorials/tutorial.eventmanager
   tutorials/config.advanced
   tutorials/tutorial.navigation
   tutorials/tutorial.pagination
   tutorials/tutorial.dbadapter
   migration/overview
   migration/namespacing-old-classes
   migration/zf1_zf2_parallel
   modules/zend.authentication.intro
   modules/zend.authentication.adapter.dbtable
   modules/zend.authentication.adapter.digest
   modules/zend.authentication.adapter.http
   modules/zend.authentication.adapter.ldap
   modules/zend.authentication.validator.authentication
   modules/zend.barcode.intro
   modules/zend.barcode.creation
   modules/zend.barcode.objects
   modules/zend.barcode.renderers
   modules/zend.cache.storage.adapter
   modules/zend.cache.storage.capabilities
   modules/zend.cache.storage.plugin
   modules/zend.cache.pattern
   modules/zend.cache.pattern.callback-cache
   modules/zend.cache.pattern.class-cache
   modules/zend.cache.pattern.object-cache
   modules/zend.cache.pattern.output-cache
   modules/zend.cache.pattern.capture-cache
   modules/zend.captcha.intro
   modules/zend.captcha.operation
   modules/zend.captcha.adapters
   modules/zend.code.generator.introduction
   modules/zend.code.generator.reference
   modules/zend.code.generator.examples
   modules/zend.config.introduction
   modules/zend.config.theory-of-operation
   modules/zend.config.reader
   modules/zend.config.writer
   modules/zend.config.processor
   modules/zend.config.factory
   modules/zend.console.introduction
   modules/zend.console.routes
   modules/zend.console.modules
   modules/zend.console.controllers
   modules/zend.console.adapter
   modules/zend.console.prompts
   modules/zend.console.getopt.introduction
   modules/zend.console.getopt.rules
   modules/zend.console.getopt.fetching
   modules/zend.console.getopt.configuration
   modules/zend.crypt.introduction
   modules/zend.crypt.block-cipher
   modules/zend.crypt.key.derivation
   modules/zend.crypt.password
   modules/zend.crypt.public-key
   modules/zend.db.adapter
   modules/zend.db.result-set
   modules/zend.db.sql
   modules/zend.db.sql.ddl
   modules/zend.db.table-gateway
   modules/zend.db.row-gateway
   modules/zend.db.metadata
   modules/zend.debug
   modules/zend.di.introduction
   modules/zend.di.quick-start
   modules/zend.di.definitions
   modules/zend.di.instance-manager
   modules/zend.di.configuration
   modules/zend.di.debugging-and-complex-use-cases
   modules/zend.dom.intro
   modules/zend.dom.query
   modules/zend.escaper.introduction
   modules/zend.escaper.theory-of-operation
   modules/zend.escaper.configuration
   modules/zend.escaper.escaping-html
   modules/zend.escaper.escaping-html-attributes
   modules/zend.escaper.escaping-javascript
   modules/zend.escaper.escaping-css
   modules/zend.escaper.escaping-url
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
   modules/zend.file.class-file-locator
   modules/zend.filter
   modules/zend.filter.set
   modules/zend.filter.word
   modules/zend.filter.file
   modules/zend.filter.filter-chains
   modules/zend.filter.inflector
   modules/zend.filter.static-filter
   modules/zend.filter.writing-filters
   modules/zend.form.intro
   modules/zend.form.quick-start
   modules/zend.form.collections
   modules/zend.form.file-upload
   modules/zend.form.advanced-use-of-forms
   modules/zend.form.elements
   modules/zend.form.view.helpers
   modules/zend.http
   modules/zend.http.request
   modules/zend.http.response
   modules/zend.http.headers
   modules/zend.http.client
   modules/zend.http.client.adapters
   modules/zend.http.client.advanced
   modules/zend.http.client-static
   modules/zend.i18n.translating
   modules/zend.i18n.view.helpers
   modules/zend.i18n.filters
   modules/zend.i18n.validators
   modules/zend.input-filter.intro
   modules/zend.input-filter.file-input
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
   modules/zend.loader.standard-autoloader
   modules/zend.loader.class-map-autoloader
   modules/zend.loader.module-autoloader
   modules/zend.loader.spl-autoloader
   modules/zend.loader.plugin-class-loader
   modules/zend.loader.short-name-locator
   modules/zend.loader.plugin-class-locator
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
   modules/zend.memory.overview
   modules/zend.memory.memory-manager
   modules/zend.memory.memory-objects
   modules/zend.mime
   modules/zend.mime.message
   modules/zend.mime.part
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
   modules/zend.mvc.send-response-event
   modules/zend.mvc.controllers
   modules/zend.mvc.plugins
   modules/zend.mvc.examples
   modules/zend.navigation.intro
   modules/zend.navigation.quick-start
   modules/zend.navigation.pages
   modules/zend.navigation.containers
   modules/zend.navigation.view.helpers
   modules/zend.navigation.view.helper.breadcrumbs
   modules/zend.navigation.view.helper.links
   modules/zend.navigation.view.helper.menu
   modules/zend.navigation.view.helper.sitemap
   modules/zend.navigation.view.helper.navigation
   modules/zend.paginator.introduction
   modules/zend.paginator.usage
   modules/zend.paginator.configuration
   modules/zend.paginator.advanced
   modules/zend.permissions.acl.intro
   modules/zend.permissions.acl.refining
   modules/zend.permissions.acl.advanced
   modules/zend.permissions.rbac.intro
   modules/zend.permissions.rbac.methods
   modules/zend.permissions.rbac.examples
   modules/zend.progress-bar
   modules/zend.progress-bar.upload
   modules/zend.serializer
   modules/zend.serializer.adapters
   modules/zend.server
   modules/zend.server.reflection
   modules/zend.service-manager.intro
   modules/zend.service-manager.quick-start
   modules/zend.service-manager.delegator-factories
   modules/zend.service-manager.lazy-services
   modules/zend.session.config
   modules/zend.session.container
   modules/zend.session.manager
   modules/zend.session.save-handler
   modules/zend.session.storage
   modules/zend.session.validator
   modules/zend.soap.server
   modules/zend.soap.client
   modules/zend.soap.wsdl
   modules/zend.soap.auto-discovery
   modules/zend.stdlib.hydrator
   modules/zend.stdlib.hydrator.filter
   modules/zend.stdlib.hydrator.strategy
   modules/zend.stdlib.hydrator.aggregate
   modules/zend.tag.introduction
   modules/zend.tag.cloud
   modules/zend.test.introduction
   modules/zend.test.phpunit
   modules/zend.text.figlet
   modules/zend.text.table
   modules/zend.uri
   modules/zend.validator
   modules/zend.validator.set
   modules/zend.validator.alnum
   modules/zend.validator.alpha
   modules/zend.validator.barcode
   modules/zend.validator.between
   modules/zend.validator.callback
   modules/zend.validator.creditcard
   modules/zend.validator.date
   modules/zend.validator.db
   modules/zend.validator.digits
   modules/zend.validator.email_address
   modules/zend.validator.file 
   modules/zend.validator.greaterthan
   modules/zend.validator.hex
   modules/zend.validator.hostname
   modules/zend.validator.iban
   modules/zend.validator.identical
   modules/zend.validator.in_array
   modules/zend.validator.ip
   modules/zend.validator.isbn
   modules/zend.validator.lessthan
   modules/zend.validator.notempty
   modules/zend.validator.post_code
   modules/zend.validator.regex
   modules/zend.validator.sitemap
   modules/zend.validator.step
   modules/zend.validator.stringlength
   modules/zend.validator.validator-chains
   modules/zend.validator.writing-validators
   modules/zend.validator.messages
   modules/zend.version
   modules/zend.view.quick-start
   modules/zend.view.renderer.php-renderer
   modules/zend.view.php-renderer.scripts
   modules/zend.view.view-event
   modules/zend.view.helpers
   modules/zend.view.helpers.base-path
   modules/zend.view.helpers.cycle
   modules/zend.view.helpers.doctype
   modules/zend.view.helpers.flash-messenger
   modules/zend.view.helpers.gravatar
   modules/zend.view.helpers.head-link
   modules/zend.view.helpers.head-meta
   modules/zend.view.helpers.head-script
   modules/zend.view.helpers.head-style
   modules/zend.view.helpers.head-title
   modules/zend.view.helpers.html-list
   modules/zend.view.helpers.html-object
   modules/zend.view.helpers.identity
   modules/zend.view.helpers.inline-script
   modules/zend.view.helpers.json
   modules/zend.view.helpers.partial
   modules/zend.view.helpers.placeholder
   modules/zend.view.helpers.url
   modules/zend.view.helpers.advanced-usage
   modules/zend.xmlrpc.intro
   modules/zend.xmlrpc.client
   modules/zend.xmlrpc.server
   modules/zendservice.akismet
   modules/zendservice.amazon
   modules/zendservice.amazon.s3
   modules/zendservice.amazon.sqs
   modules/zendservice.amazon.ec2
   modules/zendservice.amazon.ec2.cloud-watch
   modules/zendservice.amazon.ec2.ebs
   modules/zendservice.amazon.ec2.elasticip
   modules/zendservice.amazon.ec2.instance
   modules/zendservice.amazon.ec2.keypair
   modules/zendservice.amazon.ec2.regions-and-avalibility-zones
   modules/zendservice.amazon.ec2.reserved-instance
   modules/zendservice.amazon.ec2.securitygroups
   modules/zendservice.amazon.ec2.windows-instance
   modules/zendservice.apple.apns
   modules/zendservice.audioscrobbler
   modules/zendservice.delicious
   modules/zendservice.developer-garden
   modules/zendservice.flickr
   modules/zendservice.google.gcm
   modules/zendservice.livedocx
   modules/zendservice.rackspace
   modules/zendservice.rackspace.servers
   modules/zendservice.rackspace.files
   modules/zendservice.re-captcha
   modules/zendservice.slide-share
   modules/zendservice.strike-iron.overview
   modules/zendservice.strike-iron.bundled-services
   modules/zendservice.strike-iron.advanced-uses
   modules/zendservice.technorati
   modules/zendservice.twitter
   modules/zendservice.windows-azure
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
    * :doc:`user-guide/modules`
    * :doc:`user-guide/routing-and-controllers`
    * :doc:`user-guide/database-and-models`
    * :doc:`user-guide/styling-and-translations`
    * :doc:`user-guide/forms-and-actions`
    * :doc:`user-guide/conclusion`

|InDepthTutorial|
-----------------

|InDepthTutorialIntroduction|

    * :doc:`in-depth-guide/first-module`
    * :doc:`in-depth-guide/services-and-servicemanager`
    * :doc:`in-depth-guide/preparing-db-backend`
    * :doc:`in-depth-guide/zend-db-sql-zend-stdlib-hydrator`
    * :doc:`in-depth-guide/understanding-routing`
    * :doc:`in-depth-guide/zend-form-zend-form-fieldset`
    * :doc:`in-depth-guide/data-binding`
    * :doc:`in-depth-guide/review`

|GettingStartedWithZendStudio|
------------------------------

|GettingStartedWithZendStudioIntroduction|

    * :doc:`getting-started-with-zend-studio/overview`
    * :doc:`getting-started-with-zend-studio/skeleton-application`
    * :doc:`getting-started-with-zend-studio/the-application`
    * :doc:`getting-started-with-zend-studio/tasks`
    * :doc:`getting-started-with-zend-studio/diagnostics`
    * :doc:`getting-started-with-zend-studio/conclusion`

|ZFTool|
--------

    * :doc:`modules/zendtool.introduction`

|LearningZendFramework|
-----------------------

    * :doc:`tutorials/quickstart.di`
    * :doc:`tutorials/unittesting`
    * :doc:`tutorials/config.advanced`
    * :doc:`tutorials/tutorial.eventmanager`
    * :doc:`tutorials/tutorial.navigation`
    * :doc:`tutorials/tutorial.pagination`
    * :doc:`tutorials/tutorial.dbadapter`

|Migration|
-----------

    * :doc:`migration/overview`
    * :doc:`migration/namespacing-old-classes`
    * :doc:`migration/zf1_zf2_parallel`

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
        * :doc:`modules/zend.authentication.validator.authentication`

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
        * :doc:`modules/zend.cache.pattern.callback-cache`
        * :doc:`modules/zend.cache.pattern.class-cache`
        * :doc:`modules/zend.cache.pattern.object-cache`
        * :doc:`modules/zend.cache.pattern.output-cache`
        * :doc:`modules/zend.cache.pattern.capture-cache`

.. _zend.captcha:

Zend\\Captcha
^^^^^^^^^^^^^

        * :doc:`modules/zend.captcha.intro`
        * :doc:`modules/zend.captcha.operation`
        * :doc:`modules/zend.captcha.adapters`

.. _zend.code.generator:

Zend\\Code\\Generator
^^^^^^^^^^^^^^^^^^^^^

        * :doc:`modules/zend.code.generator.introduction`
        * :doc:`modules/zend.code.generator.reference`
        * :doc:`modules/zend.code.generator.examples`

.. _zend.config:

Zend\\Config
^^^^^^^^^^^^

        * :doc:`modules/zend.config.introduction`
        * :doc:`modules/zend.config.theory-of-operation`
        * :doc:`modules/zend.config.reader`
        * :doc:`modules/zend.config.writer`
        * :doc:`modules/zend.config.processor`
        * :doc:`modules/zend.config.factory`

.. _zend.console:

Zend\\Console
^^^^^^^^^^^^^

        * :doc:`modules/zend.console.introduction`
        * :doc:`modules/zend.console.routes`
        * :doc:`modules/zend.console.modules`
        * :doc:`modules/zend.console.controllers`
        * :doc:`modules/zend.console.adapter`
        * :doc:`modules/zend.console.prompts`

.. _zend.console.getopt:

Zend\\Console\\Getopt
^^^^^^^^^^^^^^^^^^^^^

        * :doc:`modules/zend.console.getopt.introduction`
        * :doc:`modules/zend.console.getopt.rules`
        * :doc:`modules/zend.console.getopt.fetching`
        * :doc:`modules/zend.console.getopt.configuration`

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
        * :doc:`modules/zend.db.sql.ddl`
        * :doc:`modules/zend.db.table-gateway`
        * :doc:`modules/zend.db.row-gateway`
        * :doc:`modules/zend.db.metadata`

.. _zend.debug:

Zend\\Debug
^^^^^^^^^^^

        * :doc:`modules/zend.debug`

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

.. _zend.escaper:

Zend\\Escaper
^^^^^^^^^^^^^

        * :doc:`modules/zend.escaper.introduction`
        * :doc:`modules/zend.escaper.theory-of-operation`
        * :doc:`modules/zend.escaper.configuration`
        * :doc:`modules/zend.escaper.escaping-html`
        * :doc:`modules/zend.escaper.escaping-html-attributes`
        * :doc:`modules/zend.escaper.escaping-javascript`
        * :doc:`modules/zend.escaper.escaping-css`
        * :doc:`modules/zend.escaper.escaping-url`

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

.. _zend.file:

Zend\\File
^^^^^^^^^^

        * :doc:`modules/zend.file.class-file-locator`

.. _zend.filter:

Zend\\Filter
^^^^^^^^^^^^

        * :doc:`modules/zend.filter`
        * :doc:`modules/zend.filter.set`
        * :doc:`modules/zend.filter.word`
        * :doc:`modules/zend.filter.file`
        * :doc:`modules/zend.filter.filter-chains`
        * :doc:`modules/zend.filter.inflector`
        * :doc:`modules/zend.filter.static-filter`
        * :doc:`modules/zend.filter.writing-filters`

.. _zend.form:

Zend\\Form
^^^^^^^^^^

        * :doc:`modules/zend.form.intro`
        * :doc:`modules/zend.form.quick-start`
        * :doc:`modules/zend.form.collections`
        * :doc:`modules/zend.form.file-upload`
        * :doc:`modules/zend.form.advanced-use-of-forms`
        * :doc:`modules/zend.form.elements`
        * :doc:`modules/zend.form.view.helpers`

.. _zend.http:

Zend\\Http
^^^^^^^^^^

        * :doc:`modules/zend.http`
        * :doc:`modules/zend.http.request`
        * :doc:`modules/zend.http.response`
        * :doc:`modules/zend.http.headers`
        * :doc:`modules/zend.http.client`
        * :doc:`modules/zend.http.client.adapters`
        * :doc:`modules/zend.http.client.advanced`
        * :doc:`modules/zend.http.client-static`

.. _zend.i18n:

Zend\\I18n
^^^^^^^^^^

        * :doc:`modules/zend.i18n.translating`
        * :doc:`modules/zend.i18n.view.helpers`
        * :doc:`modules/zend.i18n.filters`
        * :doc:`modules/zend.i18n.validators`

.. _zend.input-filter:

Zend\\InputFilter
^^^^^^^^^^^^^^^^^

        * :doc:`modules/zend.input-filter.intro`
        * :doc:`modules/zend.input-filter.file-input`

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
        * :doc:`modules/zend.loader.standard-autoloader`
        * :doc:`modules/zend.loader.class-map-autoloader`
        * :doc:`modules/zend.loader.module-autoloader`
        * :doc:`modules/zend.loader.spl-autoloader`
        * :doc:`modules/zend.loader.plugin-class-loader`
        * :doc:`modules/zend.loader.short-name-locator`
        * :doc:`modules/zend.loader.plugin-class-locator`
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

.. _zend.memory:

Zend\\Memory
^^^^^^^^^^^^

        * :doc:`modules/zend.memory.overview`
        * :doc:`modules/zend.memory.memory-manager`
        * :doc:`modules/zend.memory.memory-objects`

Zend\\Mime
^^^^^^^^^^

        * :doc:`modules/zend.mime`
        * :doc:`modules/zend.mime.message`
        * :doc:`modules/zend.mime.part`

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
        * :doc:`modules/zend.mvc.send-response-event`
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
        * :doc:`modules/zend.navigation.view.helpers`
        * :doc:`modules/zend.navigation.view.helper.breadcrumbs`
        * :doc:`modules/zend.navigation.view.helper.links`
        * :doc:`modules/zend.navigation.view.helper.menu`
        * :doc:`modules/zend.navigation.view.helper.sitemap`
        * :doc:`modules/zend.navigation.view.helper.navigation`

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

.. _zend.permissions.rbac:

Zend\\Permissions\\Rbac
^^^^^^^^^^^^^^^^^^^^^^^

        * :doc:`modules/zend.permissions.rbac.intro`
        * :doc:`modules/zend.permissions.rbac.methods`
        * :doc:`modules/zend.permissions.rbac.examples`

.. _zend.progress-bar:

Zend\\ProgressBar
^^^^^^^^^^^^^^^^^

        * :doc:`modules/zend.progress-bar`
        * :doc:`modules/zend.progress-bar.upload`

.. _zend.serializer:

Zend\\Serializer
^^^^^^^^^^^^^^^^

        * :doc:`modules/zend.serializer`
        * :doc:`modules/zend.serializer.adapters`

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
        * :doc:`modules/zend.service-manager.delegator-factories`
        * :doc:`modules/zend.service-manager.lazy-services`

.. _zend.session:

Zend\\Session
^^^^^^^^^^^^^
        * :doc:`modules/zend.session.config`
        * :doc:`modules/zend.session.container`
        * :doc:`modules/zend.session.manager`
        * :doc:`modules/zend.session.save-handler`
        * :doc:`modules/zend.session.storage`
        * :doc:`modules/zend.session.validator`

.. _zend.soap:

Zend\\Soap
^^^^^^^^^^

        * :doc:`modules/zend.soap.server`
        * :doc:`modules/zend.soap.client`
        * :doc:`modules/zend.soap.wsdl`
        * :doc:`modules/zend.soap.auto-discovery`

.. _zend.stdlib:

Zend\\Stdlib
^^^^^^^^^^^^

        * :doc:`modules/zend.stdlib.hydrator`
        * :doc:`modules/zend.stdlib.hydrator.filter`
        * :doc:`modules/zend.stdlib.hydrator.strategy`
        * :doc:`modules/zend.stdlib.hydrator.aggregate`

.. _zend.tag:

Zend\\Tag
^^^^^^^^^

        * :doc:`modules/zend.tag.introduction`
        * :doc:`modules/zend.tag.cloud`

.. _zend.test:

Zend\\Test
^^^^^^^^^^

        * :doc:`modules/zend.test.introduction`
        * :doc:`modules/zend.test.phpunit`

.. _zend.text:

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

.. _zend.version:

Zend\\Version
^^^^^^^^^^^^^

        * :doc:`modules/zend.version`

.. _zend.view:

Zend\\View
^^^^^^^^^^

        * :doc:`modules/zend.view.quick-start`
        * :doc:`modules/zend.view.renderer.php-renderer`
        * :doc:`modules/zend.view.php-renderer.scripts`
        * :doc:`modules/zend.view.view-event`
        * :doc:`modules/zend.view.helpers`
        * :doc:`modules/zend.view.helpers.base-path`
        * :doc:`modules/zend.view.helpers.cycle`
        * :doc:`modules/zend.view.helpers.doctype`
        * :doc:`modules/zend.view.helpers.flash-messenger`
        * :doc:`modules/zend.view.helpers.gravatar`
        * :doc:`modules/zend.view.helpers.head-link`
        * :doc:`modules/zend.view.helpers.head-meta`
        * :doc:`modules/zend.view.helpers.head-script`
        * :doc:`modules/zend.view.helpers.head-style`
        * :doc:`modules/zend.view.helpers.head-title`
        * :doc:`modules/zend.view.helpers.html-list`
        * :doc:`modules/zend.view.helpers.html-object`
        * :doc:`modules/zend.view.helpers.identity`
        * :doc:`modules/zend.view.helpers.inline-script`
        * :doc:`modules/zend.view.helpers.json`
        * :doc:`modules/zend.view.helpers.partial`
        * :doc:`modules/zend.view.helpers.placeholder`
        * :doc:`modules/zend.view.helpers.url`
        * :doc:`modules/zend.view.helpers.advanced-usage`

.. _zend.xmlrpc:

Zend\\XmlRpc
^^^^^^^^^^^^

        * :doc:`modules/zend.xmlrpc.intro`
        * :doc:`modules/zend.xmlrpc.client`
        * :doc:`modules/zend.xmlrpc.server`

.. _zendservice:

|ZendServiceReference|
----------------------

ZendService\\Akismet
^^^^^^^^^^^^^^^^^^^^

        * :doc:`modules/zendservice.akismet`

ZendService\\Amazon
^^^^^^^^^^^^^^^^^^^

        * :doc:`modules/zendservice.amazon`
        * :doc:`modules/zendservice.amazon.s3`
        * :doc:`modules/zendservice.amazon.sqs`
        * :doc:`modules/zendservice.amazon.ec2`
        * :doc:`modules/zendservice.amazon.ec2.cloud-watch`
        * :doc:`modules/zendservice.amazon.ec2.ebs`
        * :doc:`modules/zendservice.amazon.ec2.elasticip`
        * :doc:`modules/zendservice.amazon.ec2.instance`
        * :doc:`modules/zendservice.amazon.ec2.keypairs`
        * :doc:`modules/zendservice.amazon.ec2.regions-and-avalibility-zones`
        * :doc:`modules/zendservice.amazon.ec2.reserved-instance`
        * :doc:`modules/zendservice.amazon.ec2.securitygroups`
        * :doc:`modules/zendservice.amazon.ec2.windows-instance`

ZendService\\Apple\Apns
^^^^^^^^^^^^^^^^^^^^^^^

        * :doc:`modules/zendservice.apple.apns`

ZendService\\Audioscrobbler
^^^^^^^^^^^^^^^^^^^^^^^^^^^

        * :doc:`modules/zendservice.audioscrobbler`

ZendService\\Delicious
^^^^^^^^^^^^^^^^^^^^^^

        * :doc:`modules/zendservice.delicious`

ZendService\\DeveloperGarden
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

        * :doc:`modules/zendservice.developer-garden`

ZendService\\Flickr
^^^^^^^^^^^^^^^^^^^

        * :doc:`modules/zendservice.flickr`

ZendService\\Google\\Gcm
^^^^^^^^^^^^^^^^^^^^^^^^

        * :doc:`modules/zendservice.google.gcm`

ZendService\\LiveDocx
^^^^^^^^^^^^^^^^^^^^^

        * :doc:`modules/zendservice.livedocx`

ZendService\\Rackspace
^^^^^^^^^^^^^^^^^^^^^^

        * :doc:`modules/zendservice.rackspace`
        * :doc:`modules/zendservice.rackspace.servers`
        * :doc:`modules/zendservice.rackspace.files`

ZendService\\ReCaptcha
^^^^^^^^^^^^^^^^^^^^^^

        * :doc:`modules/zendservice.re-captcha`

ZendService\\SlideShare
^^^^^^^^^^^^^^^^^^^^^^^

        * :doc:`modules/zendservice.slide-share`

ZendService\\StrikeIron
^^^^^^^^^^^^^^^^^^^^^^^

        * :doc:`modules/zendservice.strike-iron.overview`
        * :doc:`modules/zendservice.strike-iron.bundled-services`
        * :doc:`modules/zendservice.strike-iron.advanced-uses`

ZendService\\Technorati
^^^^^^^^^^^^^^^^^^^^^^^

        * :doc:`modules/zendservice.technorati`

ZendService\\Twitter
^^^^^^^^^^^^^^^^^^^^

        * :doc:`modules/zendservice.twitter`

ZendService\\WindowsAzure
^^^^^^^^^^^^^^^^^^^^^^^^^

        * :doc:`modules/zendservice.windows-azure`

.. _zend.copyright:

Copyright
---------

    * :doc:`ref/copyrights`

|IndicesAndTables|
==================

* :doc:`index`
* :ref:`search`
