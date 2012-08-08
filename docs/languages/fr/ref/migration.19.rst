.. EN-Revision: none
.. _migration.19:

Zend Framework 1.9
==================

Lors de la migration d'une version précédente à Zend Framework 1.9.0 vers une version 1.9, vous devriez prendre
note de ce qui suit.

.. _migration.19.zend.file.transfer:

Zend_File_Transfer
------------------

.. _migration.110.zend.file.transfer.mimetype:

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

.. _migration.110.zend.file.transfer.example:

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

Avant la version 1.9, ``Zend_Filter`` permettait l'utilisation de la méthode statique ``get()``. Avec la version
1.9 cette méthode a été renommée en ``filterStatic()`` afin d'être plus descriptive. L'ancienne méthode
``get()`` est marquée comme dépréciée.

.. _migration.19.zend.http.client:

Zend_Http_Client
----------------

.. _migration.19.zend.http.client.fileuploadsarray:

Changement dans le stockage interne des fichiers d'upload
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Dans la version 1.9 de Zend Framework, il y a eu un changement dans la manière dont ``Zend_Http_Client`` stocke en
interne les informations concernant les fichiers ayant été uploadés, affectés grâce à
``Zend_Http_Client::setFileUpload()``

Ce changement a été mis en place de manière à permettre l'envoi de plusieurs fichiers avec le même nom dans le
formulaire, en tant que tableau de fichiers. Plus d'informations à ce sujet peuvent être trouvées dans ce
`rapport de bug`_.

.. _migration.19.zend.http.client.fileuploadsarray.example:

.. rubric:: Stockage interne des informations sur les fichiers uploadés

.. code-block:: php
   :linenos:

   // Uploade 2 fichiers avec le même nom d'élément de formulaire, en tant que tableau
   $client = new Zend_Http_Client();
   $client->setFileUpload('file1.txt', 'userfile[]', 'some raw data', 'text/plain');
   $client->setFileUpload('file2.txt', 'userfile[]', 'some other data', 'application/octet-stream');

   // Dans Zend Framework <=1.8, la valeur de l'attribut protégé $client->files est:
   // $client->files = array(
   //     'userfile[]' => array('file2.txt', 'application/octet-stream', 'some other data')
   // );

   // Dans Zend Framework >=1.9, la valeur de $client->files est:
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

Comme vous le voyez, ce changement permet l'utilisation du même élément de formulaire avec plusieurs fichiers.
Cependant ceci introduit un changement subtile dans l'API interne, il est donc signalé ici.

.. _migration.19.zend.http.client.getparamsrecursize:

Deprecation of Zend_Http_Client::\_getParametersRecursive()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Starting from version 1.9, the protected method ``_getParametersRecursive()`` is no longer used by
``Zend_Http_Client`` and is deprecated. Using it will cause an E_NOTICE message to be emitted by *PHP*.

If you subclass ``Zend_Http_Client`` and call this method, you should look into using the
``Zend_Http_Client::_flattenParametersArray()`` static method instead.

Again, since this ``_getParametersRecursive`` is a protected method, this change will only affect users who
subclass ``Zend_Http_Client``.

.. _migration.19.zend.locale:

Zend_Locale
-----------

.. _migration.19.zend.locale.deprecated:

Méthodes dépréciées
^^^^^^^^^^^^^^^^^^^

Quelques méthodes de traductions spéciales ont été dépréciées car elles dupliquaient un comportement
existant. Notez cependant que les anciens appels vont toujours fonctionner, mais une notice utilisateur, qui
décrira le nouvel appel, sera émise. Ces méthodes seront effacées en 2.0. Ci-dessous la liste des anciens et
nouveaux appels :

.. _migration.19.zend.locale.deprecated.table-1:

.. table:: Liste des types de mesures

   +----------------------------------------+--------------------------------------------+
   |Ancien appel                            |Nouvel appel                                |
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
correctly. When the *onlyActiveBranch* was ``TRUE`` and the option *renderParents* ``FALSE``, nothing would be
rendered if the deepest active page was at a depth lower than the *minDepth* option.

In simpler words; if *minDepth* was set to *1* and the active page was at one of the first level pages, nothing
would be rendered, as the following example shows.

Consider the following container setup:

.. code-block:: php
   :linenos:

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

   echo $this->navigation()->menu()->renderMenu($container, array(
       'minDepth'         => 1,
       'onlyActiveBranch' => true,
       'renderParents'    => false
   ));

Before release 1.9, the code snippet above would output nothing.

Since release 1.9, the ``_renderDeepestMenu()`` method in ``Zend_View_Helper_Navigation_Menu`` will accept active
pages at one level below *minDepth*, as long as the page has children.

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
optionally whitelist HTML comments in HTML text filtered by the class. However, this opens code enabling the flag
to *XSS* attacks, particularly in Internet Explorer (which allows specifying conditional functionality via HTML
comments). Starting in version 1.9.7 (and backported to versions 1.8.5 and 1.7.9), the ``commentsAllowed`` flag no
longer has any meaning, and all HTML comments, including those containing other HTML tags or nested commments, will
be stripped from the final output of the filter.



.. _`rapport de bug`: http://framework.zend.com/issues/browse/ZF-5744
