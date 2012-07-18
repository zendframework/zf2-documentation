.. _migration.19:

Zend Framework 1.9
==================

When upgrading from a release of Zend Framework earlier than 1.9.0 to any 1.9 release, you should note the
following migration notes.

.. _migration.19.zend.file.transfer:

Zend_File_Transfer
------------------

.. _migration.19.zend.file.transfer.mimetype:

MimeType validation
^^^^^^^^^^^^^^^^^^^

For security reasons we had to turn off the default fallback mechanism of the ``MimeType``, ``ExcludeMimeType``,
``IsCompressed`` and ``IsImage`` validators. This means, that if the **fileInfo** or **magicMime** extensions can
not be found, the validation will always fail.

If you are in need of validation by using the *HTTP* fields which are provided by the user then you can turn on
this feature by using the ``enableHeaderCheck()`` method.

.. note::

   **Security hint**

   You should note that relying on the *HTTP* fields, which are provided by your user, is a security risk. They can
   easily be changed and could allow your user to provide a malcious file.

.. _migration.19.zend.file.transfer.example:

.. rubric:: Allow the usage of the HTTP fields

.. code-block:: php
   :linenos:

   // at initiation
   $valid = new Zend_File_Transfer_Adapter_Http(array('headerCheck' => true);

   // or afterwards
   $valid->enableHeaderCheck();

.. _migration.19.zend.filter:

Zend_Filter
-----------

Prior to the 1.9 release, ``Zend_Filter`` allowed the usage of the static ``get()`` method. As with release 1.9
this method has been renamed to ``filterStatic()`` to be more descriptive. The old ``get()`` method is marked as
deprecated.

.. _migration.19.zend.http.client:

Zend_Http_Client
----------------

.. _migration.19.zend.http.client.fileuploadsarray:

Changes to internal uploaded file information storage
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In version 1.9 of Zend Framework, there has been a change in the way ``Zend_Http_Client`` internally stores
information about files to be uploaded, set using the ``Zend_Http_Client::setFileUpload()`` method.

This change was introduced in order to allow multiple files to be uploaded with the same form name, as an array of
files. More information about this issue can be found in `this bug report`_.

.. _migration.19.zend.http.client.fileuploadsarray.example:

.. rubric:: Internal storage of uploaded file information

.. code-block:: php
   :linenos:

   // Upload two files with the same form element name, as an array
   $client = new Zend_Http_Client();
   $client->setFileUpload('file1.txt',
                          'userfile[]',
                          'some raw data',
                          'text/plain');
   $client->setFileUpload('file2.txt',
                          'userfile[]',
                          'some other data',
                          'application/octet-stream');

   // In Zend Framework 1.8 or older, the value of
   // the protected member $client->files is:
   // $client->files = array(
   //     'userfile[]' => array('file2.txt',
                                'application/octet-stream',
                                'some other data')
   // );

   // In Zend Framework 1.9 or newer, the value of $client->files is:
   // $client->files = array(
   //     array(
   //         'formname' => 'userfile[]',
   //         'filename' => 'file1.txt,
   //         'ctype'    => 'text/plain',
   //         'data'     => 'some raw data'
   //     ),
   //     array(
   //         'formname' => 'userfile[]',
   //         'filename' => 'file2.txt',
   //         'formname' => 'application/octet-stream',
   //         'formname' => 'some other data'
   //     )
   // );

As you can see, this change permits the usage of the same form element name with more than one file - however, it
introduces a subtle backwards-compatibility change and as such should be noted.

.. _migration.19.zend.http.client.getparamsrecursize:

Deprecation of Zend_Http_Client::\_getParametersRecursive()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Starting from version 1.9, the protected method ``_getParametersRecursive()`` is no longer used by
``Zend_Http_Client`` and is deprecated. Using it will cause an ``E_NOTICE`` message to be emitted by *PHP*.

If you subclass ``Zend_Http_Client`` and call this method, you should look into using the
``Zend_Http_Client::_flattenParametersArray()`` static method instead.

Again, since this ``_getParametersRecursive()`` is a protected method, this change will only affect users who
subclass ``Zend_Http_Client``.

.. _migration.19.zend.locale:

Zend_Locale
-----------

.. _migration.19.zend.locale.deprecated:

Deprecated methods
^^^^^^^^^^^^^^^^^^

Some specialized translation methods have been deprecated because they duplicate existing behaviour. Note that the
old methods will still work, but a user notice is triggered which describes the new call. The methods will be
erased with 2.0. See the following list for old and new method call.

.. _migration.19.zend.locale.deprecated.table-1:

.. table:: List of measurement types

   +----------------------------------------+--------------------------------------------+
   |Old call                                |New call                                    |
   +========================================+============================================+
   |getLanguageTranslationList($locale)     |getTranslationList('language', $locale)     |
   +----------------------------------------+--------------------------------------------+
   |getScriptTranslationList($locale)       |getTranslationList('script', $locale)       |
   +----------------------------------------+--------------------------------------------+
   |getCountryTranslationList($locale)      |getTranslationList('territory', $locale, 2) |
   +----------------------------------------+--------------------------------------------+
   |getTerritoryTranslationList($locale)    |getTranslationList('territory', $locale, 1) |
   +----------------------------------------+--------------------------------------------+
   |getLanguageTranslation($value, $locale) |getTranslation($value, 'language', $locale) |
   +----------------------------------------+--------------------------------------------+
   |getScriptTranslation($value, $locale)   |getTranslation($value, 'script', $locale)   |
   +----------------------------------------+--------------------------------------------+
   |getCountryTranslation($value, $locale)  |getTranslation($value, 'country', $locale)  |
   +----------------------------------------+--------------------------------------------+
   |getTerritoryTranslation($value, $locale)|getTranslation($value, 'territory', $locale)|
   +----------------------------------------+--------------------------------------------+

.. _migration.19.zend.view.helper.navigation:

Zend_View_Helper_Navigation
---------------------------

Prior to the 1.9 release, the menu helper (``Zend_View_Helper_Navigation_Menu``) did not render sub menus
correctly. When ``onlyActiveBranch`` was ``TRUE`` and the option ``renderParents`` ``FALSE``, nothing would be
rendered if the deepest active page was at a depth lower than the ``minDepth`` option.

In simpler words; if ``minDepth`` was set to '1' and the active page was at one of the first level pages, nothing
would be rendered, as the following example shows.

Consider the following container setup:

.. code-block:: php
   :linenos:

   <?php
   $container = new Zend_Navigation(array(
       array(
           'label' => 'Home',
           'uri'   => '#'
       ),
       array(
           'label'  => 'Products',
           'uri'    => '#',
           'active' => true,
           'pages'  => array(
               array(
                   'label' => 'Server',
                   'uri'   => '#'
               ),
               array(
                   'label' => 'Studio',
                   'uri'   => '#'
               )
           )
       ),
       array(
           'label' => 'Solutions',
           'uri'   => '#'
       )
   ));

The following code is used in a view script:

.. code-block:: php
   :linenos:

   <?php echo $this->navigation()->menu()->renderMenu($container, array(
       'minDepth'         => 1,
       'onlyActiveBranch' => true,
       'renderParents'    => false
   )); ?>

Before release 1.9, the code snippet above would output nothing.

Since release 1.9, the ``_renderDeepestMenu()`` method in ``Zend_View_Helper_Navigation_Menu`` will accept active
pages at one level below ``minDepth``, as long as the page has children.

The same code snippet will now output the following:

.. code-block:: html
   :linenos:

   <ul class="navigation">
       <li>
           <a href="#">Server</a>
       </li>
       <li>
           <a href="#">Studio</a>
       </li>
   </ul>

.. _migration.19.security:

Security fixes as with 1.9.7
----------------------------

Additionally, users of the 1.9 series may be affected by other changes starting in version 1.9.7. These are all
security fixes that also have potential backwards compatibility implications.

.. _migration.19.security.zend.filter.html-entities:

Zend_Filter_HtmlEntities
^^^^^^^^^^^^^^^^^^^^^^^^

In order to default to a more secure character encoding, ``Zend_Filter_HtmlEntities`` now defaults to *UTF-8*
instead of *ISO-8859-1*.

Additionally, because the actual mechanism is dealing with character encodings and not character sets, two new
methods have been added, ``setEncoding()`` and ``getEncoding()``. The previous methods ``setCharSet()`` and
``setCharSet()`` are now deprecated and proxy to the new methods. Finally, instead of using the protected members
directly within the ``filter()`` method, these members are retrieved by their explicit accessors. If you were
extending the filter in the past, please check your code and unit tests to ensure everything still continues to
work.

.. _migration.19.security.zend.filter.strip-tags:

Zend_Filter_StripTags
^^^^^^^^^^^^^^^^^^^^^

``Zend_Filter_StripTags`` contains a flag, ``commentsAllowed``, that, in previous versions, allowed you to
optionally whitelist *HTML* comments in *HTML* text filtered by the class. However, this opens code enabling the
flag to *XSS* attacks, particularly in Internet Explorer (which allows specifying conditional functionality via
*HTML* comments). Starting in version 1.9.7 (and backported to versions 1.8.5 and 1.7.9), the ``commentsAllowed``
flag no longer has any meaning, and all *HTML* comments, including those containing other *HTML* tags or nested
commments, will be stripped from the final output of the filter.



.. _`this bug report`: http://framework.zend.com/issues/browse/ZF-5744
