.. Zend Framework 2 documentation master file, created by
   sphinx-quickstart on Fri Jul  6 18:55:07 2012.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Programmer's Reference Guide of Zend Framework 2
================================================

.. toctree:: 
   :glob:
   :hidden:

   ref/*
   tutorials/*
   modules/*

Introduction to Zend Framework
------------------------------

    * :doc:`ref/overview` 
    * :doc:`ref/installation`

Learning Zend Framework
-----------------------

    * :doc:`tutorials/quickstart.di`

Zend Framework Reference
------------------------

    * Zend\\Acl
        * :doc:`modules/zend.acl.intro`
        * :doc:`modules/zend.acl.refining`
        * :doc:`modules/zend.acl.advanced`

    * Zend\\Authentication
        * :doc:`modules/zend.authentication.intro`
        * :doc:`modules/zend.authentication.adapter.dbtable`
        * :doc:`modules/zend.authentication.adapter.digest`
        * :doc:`modules/zend.authentication.adapter.http`
        * :doc:`modules/zend.authentication.adapter.ldap`

    * Zend\\Barcode
        * :doc:`modules/zend.barcode.intro`
        * :doc:`modules/zend.barcode.creation`
        * :doc:`modules/zend.barcode.objects`
        * :doc:`modules/zend.barcode.renderers`

    * Zend\\Cache
        * :doc:`modules/zend.cache.theory` 
        * :doc:`modules/zend.cache.introduction` 
        * :doc:`modules/zend.cache.frontends`
        * :doc:`modules/zend.cache.storage.adapter`
        * :doc:`modules/zend.cache.storage.capabilities`
        * :doc:`modules/zend.cache.storage.plugin`
        * :doc:`modules/zend.cache.pattern`

    * Zend\\Captcha
        * :doc:`modules/zend.captcha.intro` 
        * :doc:`modules/zend.captcha.operation`
        * :doc:`modules/zend.captcha.adapters`

    * Zend\\Config
        * :doc:`modules/zend.config.introduction` 
        * :doc:`modules/zend.config.theory-of-operation`
        * :doc:`modules/zend.config.reader`
        * :doc:`modules/zend.config.writer`
        * :doc:`modules/zend.config.processor`

    * Zend\\Crypt
        * :doc:`modules/zend.crypt.introduction` 
        * :doc:`modules/zend.crypt.block-cipher`
        * :doc:`modules/zend.crypt.key.derivation`
        * :doc:`modules/zend.crypt.password`

    * Zend\\Db
        * :doc:`modules/zend.db.adapter`
        * :doc:`modules/zend.db.result.set`
        * :doc:`modules/zend.db.sql`
        * :doc:`modules/zend.db.table.gateway`
        * :doc:`modules/zend.db.row.gateway`
        * :doc:`modules/zend.db.metadata`

    * Zend\\Di
        * :doc:`modules/zend.di.introduction`
        * :doc:`modules/zend.di.quickstart`
        * :doc:`modules/zend.di.definitions`
        * :doc:`modules/zend.di.instance-manager`
        * :doc:`modules/zend.di.configuration`
        * :doc:`modules/zend.di.debugging.and.complex.use`

    * Zend\\Dom
        * :doc:`modules/zend.dom.intro`
        * :doc:`modules/zend.dom.query`

    * Zend\\EventManager
        * :doc:`modules/zend.event-manager.event-manager`

    * Zend\\Form
        * :doc:`modules/zend.form.intro`
        * :doc:`modules/zend.form.quick.start`
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

    * Zend\\Http
        * :doc:`modules/zend.http`
        * :doc:`modules/zend.http.request`
        * :doc:`modules/zend.http.response`
        * :doc:`modules/zend.http.headers`
        * :doc:`modules/zend.http.cookie.handling`
        * :doc:`modules/zend.http.client`
        * :doc:`modules/zend.http.client.adapters`
        * :doc:`modules/zend.http.client.advanced`

    * Zend\\I18n
        * :doc:`modules/zend.i18n.translating`
        * :doc:`modules/zend.i18n.view.helpers`
        * :doc:`modules/zend.i18n.filters`

    * Zend\\InputFilter
        * :doc:`modules/zend.input.filter.intro`

    * Zend\\Ldap
        * :doc:`modules/zend.ldap.introduction`
        * :doc:`modules/zend.ldap.api`
        * :doc:`modules/zend.ldap.usage`
        * :doc:`modules/zend.ldap.tools`
        * :doc:`modules/zend.ldap.node`
        * :doc:`modules/zend.ldap.server`
        * :doc:`modules/zend.ldap.ldif`

    * Zend\\Loader
        * :doc:`modules/zend.loader.autoloader-factory`
        * :doc:`modules/zend.loader.plugin-class-loader`
        * :doc:`modules/zend.loader.short-name-locator`
        * :doc:`modules/zend.loader.plugin-class-locator`
        * :doc:`modules/zend.loader.spl-autoloader`
        * :doc:`modules/zend.loader.class-map-autoloader`
        * :doc:`modules/zend.loader.standard-autoloader`
        * :doc:`modules/zend.loader.classmap.generator`
        * :doc:`modules/zend.loader.prefix-path-loader`
        * :doc:`modules/zend.loader.prefix-path-mapper`

    * Zend\\Mail
        * :doc:`modules/zend.mail.message`
        * :doc:`modules/zend.mail.transport`
        * :doc:`modules/zend.mail.smtp.options`
        * :doc:`modules/zend.mail.file.options`

    * Zend\\ModuleManager
        * :doc:`modules/zend.module.manager.intro`
        * :doc:`modules/zend.module.manager.module.manager`
        * :doc:`modules/zend.module.manager.module.class`
        * :doc:`modules/zend.module.manager.module.autoloader`
        * :doc:`modules/zend.module.manager.best.practices`

    * Zend\\Mvc
        * :doc:`modules/zend.mvc.intro`
        * :doc:`modules/zend.mvc.quick-start`
        * :doc:`modules/zend.mvc.services`
        * :doc:`modules/zend.mvc.routing`
        * :doc:`modules/zend.mvc.mvc-event`
        * :doc:`modules/zend.mvc.controllers`
        * :doc:`modules/zend.mvc.plugins`
        * :doc:`modules/zend.mvc.examples`

    * Zend\\ServiceManager
        * :doc:`modules/zend.service.manager.intro`
        * :doc:`modules/zend.service.manager.quick.start`

    * Zend\\Stdlib
        * :doc:`modules/zend.stdlib.hydrator`

    * Zend\\Uri
        * :doc:`modules/zend.uri`

    * Zend\\Validator
        * :doc:`modules/zend.validator`
        * :doc:`modules/zend.validator.set`
        * :doc:`modules/zend.validator.validator-chains`
        * :doc:`modules/zend.validator.writing-validators`
        * :doc:`modules/zend.validator.messages`

    * Zend\\View
        * :doc:`modules/zend.view.quick.start`
        * :doc:`modules/zend.view.renderer.php.renderer`
        * :doc:`modules/zend.view.php.renderer.scripts`
        * :doc:`modules/zend.view.helpers`

    * Zend\\XmlRpc
        * :doc:`modules/zend.xmlrpc`
        * :doc:`modules/zend.xmlrpc.client`
        * :doc:`modules/zend.xmlrpc.server`

Copyright
---------

    * :doc:`ref/copyrights`

Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`

