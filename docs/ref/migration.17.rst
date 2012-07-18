.. _migration.17:

Zend Framework 1.7
==================

When upgrading from a previous release to Zend Framework 1.7 or higher you should note the following migration notes.

.. _migration.17.zend.controller:

Zend_Controller
---------------

.. _migration.17.zend.controller.dispatcher:

Dispatcher Interface Changes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Users brought to our attention the fact that ``Zend_Controller_Action_Helper_ViewRenderer`` were using a method of the dispatcher abstract class that was not in the dispatcher interface. We have now added the following method to ensure that custom dispatchers will continue to work with the shipped implementations:

- ``formatModuleName()``: should be used to take a raw controller name, such as one that would be packaged inside a request object, and reformat it to a proper class name that a class extending ``Zend_Controller_Action`` would use

.. _migration.17.zend.file.transfer:

Zend_File_Transfer
------------------

.. _migration.17.zend.file.transfer.validators:

Changes when using filters and validators
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

As noted by users, the validators from ``Zend_File_Transfer`` do not work in conjunction with ``Zend_Config`` due to the fact that they have not used named arrays.

Therefor, all filters and validators for ``Zend_File_Transfer`` have been reworked. While the old signatures continue to work, they have been marked as deprecated, and will emit a *PHP* notice asking you to fix them.

The following list shows you the changes you will have to do for proper usage of the parameters.

.. _migration.17.zend.file.transfer.validators.rename:

Filter: Rename
^^^^^^^^^^^^^^

- Old method *API*: ``Zend_Filter_File_Rename($oldfile, $newfile, $overwrite)``

- New method *API*: ``Zend_Filter_File_Rename($options)`` where ``$options`` accepts the following array keys: **source** equals to ``$oldfile``, **target** equals to ``$newfile``, **overwrite** equals to ``$overwrite``.

.. _migration.17.zend.file.transfer.validators.rename.example:

.. rubric:: Changes for the rename filter from 1.6 to 1.7

.. code-block:: php
   :linenos:

   // Example for 1.6
   $upload = new Zend_File_Transfer_Adapter_Http();
   $upload->addFilter('Rename',
                      array('/path/to/oldfile', '/path/to/newfile', true));

   // Same example for 1.7
   $upload = new Zend_File_Transfer_Adapter_Http();
   $upload->addFilter('Rename',
                      array('source' => '/path/to/oldfile',
                            'target' => '/path/to/newfile',
                            'overwrite' => true));

.. _migration.17.zend.file.transfer.validators.count:

Validator: Count
^^^^^^^^^^^^^^^^

- Old method *API*: ``Zend_Validate_File_Count($min, $max)``

- New method *API*: ``Zend_Validate_File_Count($options)`` where ``$options`` accepts the following array keys: **min** equals to ``$min``, **max** equals to ``$max``.

.. _migration.17.zend.file.transfer.validators.count.example:

.. rubric:: Changes for the count validator from 1.6 to 1.7

.. code-block:: php
   :linenos:

   // Example for 1.6
   $upload = new Zend_File_Transfer_Adapter_Http();
   $upload->addValidator('Count',
                         array(2, 3));

   // Same example for 1.7
   $upload = new Zend_File_Transfer_Adapter_Http();
   $upload->addValidator('Count',
                         false,
                         array('min' => 2,
                               'max' => 3));

.. _migration.17.zend.file.transfer.validators.extension:

Validator:Extension
^^^^^^^^^^^^^^^^^^^

- Old method *API*: ``Zend_Validate_File_Extension($extension, $case)``

- New method *API*: ``Zend_Validate_File_Extension($options)`` where ``$options`` accepts the following array keys: ***** equals to ``$extension`` and can have any other key, **case** equals to ``$case``.

.. _migration.17.zend.file.transfer.validators.extension.example:

.. rubric:: Changes for the extension validator from 1.6 to 1.7

.. code-block:: php
   :linenos:

   // Example for 1.6
   $upload = new Zend_File_Transfer_Adapter_Http();
   $upload->addValidator('Extension',
                         array('jpg,gif,bmp', true));

   // Same example for 1.7
   $upload = new Zend_File_Transfer_Adapter_Http();
   $upload->addValidator('Extension',
                         false,
                         array('extension1' => 'jpg,gif,bmp',
                               'case' => true));

.. _migration.17.zend.file.transfer.validators.filessize:

Validator: FilesSize
^^^^^^^^^^^^^^^^^^^^

- Old method *API*: ``Zend_Validate_File_FilesSize($min, $max, $bytestring)``

- New method *API*: ``Zend_Validate_File_FilesSize($options)`` where ``$options`` accepts the following array keys: **min** equals to ``$min``, **max** equals to ``$max``, **bytestring** equals to ``$bytestring``.

Additionally, the ``useByteString()`` method signature has changed. It can only be used to test if the validator is expecting to use byte strings in generated messages. To set the value of the flag, use the ``setUseByteString()`` method.

.. _migration.17.zend.file.transfer.validators.filessize.example:

.. rubric:: Changes for the filessize validator from 1.6 to 1.7

.. code-block:: php
   :linenos:

   // Example for 1.6
   $upload = new Zend_File_Transfer_Adapter_Http();
   $upload->addValidator('FilesSize',
                      array(100, 10000, true));

   // Same example for 1.7
   $upload = new Zend_File_Transfer_Adapter_Http();
   $upload->addValidator('FilesSize',
                         false,
                         array('min' => 100,
                               'max' => 10000,
                               'bytestring' => true));

   // Example for 1.6
   $upload->useByteString(true); // set flag

   // Same example for 1.7
   $upload->setUseByteSting(true); // set flag

.. _migration.17.zend.file.transfer.validators.hash:

Validator: Hash
^^^^^^^^^^^^^^^

- Old method *API*: ``Zend_Validate_File_Hash($hash, $algorithm)``

- New method *API*: ``Zend_Validate_File_Hash($options)`` where ``$options`` accepts the following array keys: ***** equals to ``$hash`` and can have any other key, **algorithm** equals to ``$algorithm``.

.. _migration.17.zend.file.transfer.validators.hash.example:

.. rubric:: Changes for the hash validator from 1.6 to 1.7

.. code-block:: php
   :linenos:

   // Example for 1.6
   $upload = new Zend_File_Transfer_Adapter_Http();
   $upload->addValidator('Hash',
                      array('12345', 'md5'));

   // Same example for 1.7
   $upload = new Zend_File_Transfer_Adapter_Http();
   $upload->addValidator('Hash',
                         false,
                         array('hash1' => '12345',
                               'algorithm' => 'md5'));

.. _migration.17.zend.file.transfer.validators.imagesize:

Validator: ImageSize
^^^^^^^^^^^^^^^^^^^^

- Old method *API*: ``Zend_Validate_File_ImageSize($minwidth, $minheight, $maxwidth, $maxheight)``

- New method *API*: ``Zend_Validate_File_FilesSize($options)`` where ``$options`` accepts the following array keys: **minwidth** equals to ``$minwidth``, **maxwidth** equals to ``$maxwidth``, **minheight** equals to ``$minheight``, **maxheight** equals to ``$maxheight``.

.. _migration.17.zend.file.transfer.validators.imagesize.example:

.. rubric:: Changes for the imagesize validator from 1.6 to 1.7

.. code-block:: php
   :linenos:

   // Example for 1.6
   $upload = new Zend_File_Transfer_Adapter_Http();
   $upload->addValidator('ImageSize',
                         array(10, 10, 100, 100));

   // Same example for 1.7
   $upload = new Zend_File_Transfer_Adapter_Http();
   $upload->addValidator('ImageSize',
                         false,
                         array('minwidth' => 10,
                               'minheight' => 10,
                               'maxwidth' => 100,
                               'maxheight' => 100));

.. _migration.17.zend.file.transfer.validators.size:

Validator: Size
^^^^^^^^^^^^^^^

- Old method *API*: ``Zend_Validate_File_Size($min, $max, $bytestring)``

- New method *API*: ``Zend_Validate_File_Size($options)`` where ``$options`` accepts the following array keys: **min** equals to ``$min``, **max** equals to ``$max``, **bytestring** equals to ``$bytestring``.

.. _migration.17.zend.file.transfer.validators.size.example:

.. rubric:: Changes for the size validator from 1.6 to 1.7

.. code-block:: php
   :linenos:

   // Example for 1.6
   $upload = new Zend_File_Transfer_Adapter_Http();
   $upload->addValidator('Size',
                         array(100, 10000, true));

   // Same example for 1.7
   $upload = new Zend_File_Transfer_Adapter_Http();
   $upload->addValidator('Size',
                         false,
                         array('min' => 100,
                               'max' => 10000,
                               'bytestring' => true));

.. _migration.17.zend.locale:

Zend_Locale
-----------

.. _migration.17.zend.locale.islocale:

Changes when using isLocale()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

According to the coding standards ``isLocale()`` had to be changed to return a boolean. In previous releases a string was returned on success. For release 1.7 a compatibility mode has been added which allows to use the old behaviour of a returned string, but it triggers a user warning to mention you to change to the new behaviour. The rerouting which the old behaviour of ``isLocale()`` could have done is no longer neccessary as all I18n will now process a rerouting themself.

To migrate your scripts to the new *API*, simply use the method as shown below.

.. _migration.17.zend.locale.islocale.example:

.. rubric:: How to change isLocale() from 1.6 to 1.7

.. code-block:: php
   :linenos:

   // Example for 1.6
   if ($locale = Zend_Locale::isLocale($locale)) {
       // do something
   }

   // Same example for 1.7

   // You should change the compatiblity mode to prevent user warnings
   // But you can do this in your bootstrap
   Zend_Locale::$compatibilityMode = false;

   if (Zend_Locale::isLocale($locale)) {
   }

Note that you can use the second parameter to see if the locale is correct without processing a rerouting.

.. code-block:: php
   :linenos:

   // Example for 1.6
   if ($locale = Zend_Locale::isLocale($locale, false)) {
       // do something
   }

   // Same example for 1.7

   // You should change the compatiblity mode to prevent user warnings
   // But you can do this in your bootstrap
   Zend_Locale::$compatibilityMode = false;

   if (Zend_Locale::isLocale($locale, false)) {
       if (Zend_Locale::isLocale($locale, true)) {
           // no locale at all
       }

       // original string is no locale but can be rerouted
   }

.. _migration.17.zend.locale.islocale.getdefault:

Changes when using getDefault()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The meaning of the ``getDefault()`` method has been change due to the fact that we integrated a framework locale which can be set with ``setDefault()``. It does no longer return the locale chain but only the set framework locale.

To migrate your scripts to the new *API*, simply use the method as shown below.

.. _migration.17.zend.locale.islocale.getdefault.example:

.. rubric:: How to change getDefault() from 1.6 to 1.7

.. code-block:: php
   :linenos:

   // Example for 1.6
   $locales = $locale->getDefault(Zend_Locale::BROWSER);

   // Same example for 1.7

   // You should change the compatiblity mode to prevent user warnings
   // But you can do this in your bootstrap
   Zend_Locale::$compatibilityMode = false;

   $locale = Zend_Locale::getOrder(Zend_Locale::BROWSER);

Note that the second parameter of the old ``getDefault()`` implementation is not available anymore, but the returned values are the same.

.. note::

   Per default the old behaviour is still active, but throws a user warning. When you have changed your code to the new behaviour you should also change the compatibility mode to ``FALSE`` so that no warning is thrown anymore.

.. _migration.17.zend.translator:

Zend_Translator
---------------

.. _migration.17.zend.translator.languages:

Setting languages
^^^^^^^^^^^^^^^^^

When using automatic detection of languages, or setting languages manually to ``Zend_Translator`` you may have mentioned that from time to time a notice is thrown about not added or empty translations. In some previous release also an exception was raised in some cases.

The reason is, that when a user requests a non existing language, you have no simple way to detect what's going wrong. So we added those notices which show up in your log and tell you that the user requested a language which you do not support. Note that the code, even when we trigger such an notice, keeps working without problems.

But when you use a own error or exception handler, like xdebug, you will get all notices returned, even if this was not your intention. This is due to the fact that these handlers override all settings from within *PHP*.

To get rid of these notices you can simply set the new option 'disableNotices' to ``TRUE``. It defaults to ``FALSE``.

.. _migration.17.zend.translator.example:

.. rubric:: Setting languages without getting notices

Let's assume that we have 'en' available and our user requests 'fr' which is not in our portfolio of translated languages.

.. code-block:: php
   :linenos:

   $language = new Zend_Translator('gettext',
                                  '/path/to/translations',
                                  'auto');

In this case we will get an notice about a not available language 'fr'. Simply add the option and the notices will be disabled.

.. code-block:: php
   :linenos:

   $language = new Zend_Translator('gettext',
                                  '/path/to/translations',
                                  'auto',
                                  array('disableNotices' => true));

.. _migration.17.zend.view:

Zend_View
---------

.. note::

   The *API* changes within ``Zend_View`` are only notable for you when you are upgrading to release 1.7.5 or higher.

Prior to the 1.7.5 release, the Zend Framework team was notified of a potential Local File Inclusion (*LFI*) vulnerability in the ``Zend_View::render()`` method. Prior to 1.7.5, the method allowed, by default, the ability to specify view scripts that included parent directory notation (e.g., "../" or "..\\"). This opens the possibility for an *LFI* attack if unfiltered user input is passed to the ``render()`` method:

.. code-block:: php
   :linenos:

   // Where $_GET['foobar'] = '../../../../etc/passwd'
   echo $view->render($_GET['foobar']); // LFI inclusion

``Zend_View`` now by default raises an exception when such a view script is requested.

.. _migration.17.zend.view.disabling:

Disabling LFI protection for the render() method
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Since a number of developers reported that they were using such notation within their applications that was **not** the result of user input, a special flag was created to allow disabling the default protection. You have two methods for doing so: by passing the 'lfiProtectionOn' key to the constructor options, or by explicitly calling the ``setLfiProtection()`` method.

.. code-block:: php
   :linenos:

   // Disabling via constructor
   $view = new Zend_View(array('lfiProtectionOn' => false));

   // Disabling via exlicit method call:
   $view = new Zend_View();
   $view->setLfiProtection(false);


