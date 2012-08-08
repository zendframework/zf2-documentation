.. EN-Revision: none
.. _zend.uri.chapter:

Zend_Uri
========

.. _zend.uri.overview:

Aperçu
------

``Zend_Uri`` est un composant destiné à aider à la manipulation et à la validation des `Uniform Resource
Identifiers`_ (URIs). ``Zend_Uri`` existe dans le but d'aider les autres composants de Zend Framework tels que
``Zend_Http_Client`` mais peut aussi être utilisé comme composant individuel.

Les *URI*\ s commence toujours avec la définition de leur schéma, suivie d'un double-points. La construction des
différents schémas variant beaucoup, une fabrique est à votre disposition. ``Zend_Uri`` possède une fabrique
qui retourne des instances sous-classes d'elle même. Chaque sous classe possède le nom du schéma dans son nom,
comme ``Zend_Uri_<scheme>``, où *<scheme>* est le nom du schéma utilisé, tout en minuscule, sauf la première
lettre. Une exception à cette règle est *HTTPS*, qui est aussi géré par ``Zend_Uri_Http``.

.. _zend.uri.creation:

Créer un nouvel URI
-------------------

``Zend_Uri`` fabriquera un *URI* vierge, si seul son schéma est passé à ``Zend_Uri::factory()``.

.. _zend.uri.creation.example-1:

.. rubric:: Créer un URI avec ``Zend_Uri::factory()``

.. code-block:: php
   :linenos:

   // Création d'un URI vierge
   $uri = Zend_Uri::factory('http');

   // $uri instanceof Zend_Uri_Http

Pour créer un *URI* à partir de rien, passez simplement le schéma à ``Zend_Uri::factory()`` [#]_. Si un schéma
non supporté lui est passé ou aucune classe n'est spécifié, une ``Zend_Uri_Exception`` sera levée.

Si un schéma ou *URI* fourni est supporté, ``Zend_Uri::factory()`` retournera une sous-classe d'elle-même
spécialisée pour le schéma à créer.

Creating a New Custom-Class URI
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Starting from Zend Framework 1.10.5, you can specify a custom class to be used when creating the Zend_Uri instance,
as a second parameter to the ``Zend_Uri::factory()`` method. This enables you to subclass Zend_Uri and create your
own custom URI classes, and instantiate new URI objects based on your own custom classes.

The 2nd parameter passed to ``Zend_Uri::factory()`` must be a string with the name of a class extending
``Zend_Uri``. The class must either be alredy-loaded, or loadable using ``Zend_Loader::loadClass()``- that is, it
must follow the Zend Framework class and file naming conventions, and must be in your include_path.

.. _zend.uri.creation.custom.example-1:

.. rubric:: Creating a URI using a custom class

.. code-block:: php
   :linenos:

   // Create a new 'ftp' URI based on a custom class
   $ftpUri = Zend_Uri::factory(
       'ftp://user@ftp.example.com/path/file',
       'MyLibrary_Uri_Ftp'
   );

   // $ftpUri is an instance of MyLibrary_Uri_Ftp, which is a subclass of Zend_Uri

.. _zend.uri.manipulation:

Manipuler un URI existant
-------------------------

Pour manipuler un *URI* existant, passez le entièrement à ``Zend_Uri::factory()``.

.. _zend.uri.manipulation.example-1:

.. rubric:: Manipuler un URI existant avec ``Zend_Uri::factory()``

.. code-block:: php
   :linenos:

   // Passez l'URI complet à la fabrique
   $uri = Zend_Uri::factory('http://www.zend.com');

   // $uri instanceof Zend_Uri_Http

L'URI sera alors analysé et validé. S'il s'avère être invalide, une ``Zend_Uri_Exception`` sera envoyée
immédiatement. Sinon, ``Zend_Uri::factory()`` retournera une sous classe d'elle-même qui spécialisera le schéma
manipulé.

.. _zend.uri.validation:

Validation d'URI
----------------

La méthode ``Zend_Uri::check()`` peut être utilisée pour valider un *URI*.

.. _zend.uri.validation.example-1:

.. rubric:: Validation d'URI avec ``Zend_Uri::check()``

.. code-block:: php
   :linenos:

   // Valide si l'URI passé est bien formé
   $valid = Zend_Uri::check('http://uri.en.question');

   // $valid est TRUE ou FALSE

``Zend_Uri::check()`` retourne un simple booléen, ce qui est plus pratique que de passer par
``Zend_Uri::factory()`` et de capturer les exceptions.

.. _zend.uri.validation.allowunwise:

Autoriser les caractères "imprudents" dans les URIs
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Par défaut, ``Zend_Uri`` n'acceptera pas les caractères suivants, définis par la *RFC* comme "imprudents" et
invalide : *"{", "}", "|", "\", "^", "`"*. Cependant, de nombreuses implémentations acceptent ces caractères
comme valides.

``Zend_Uri`` peut être paramètré pour accepter ces caractères "imprudents" en réglant l'option "allow_unwise"
à ``TRUE`` en utilisant la méthode ``Zend_Uri::setConfig()``:

.. _zend.uri.validation.allowunwise.example-1:

.. rubric:: Autoriser les caractères spéciaux dans les URIs

.. code-block:: php
   :linenos:

   // Normalement, ceci devrait retourner false :
   $valid = Zend_Uri::check('http://example.com/?q=this|that'); // Contient le symbole '|'

   // Cependant, vous pouvez autorise les caractères "imprudents"
   Zend_Uri::setConfig(array('allow_unwise' => true));
   $valid = Zend_Uri::check('http://example.com/?q=this|that'); // Retournera 'true'

   // Initialiser 'allow_unwise' à sa valeur par défaut FALSE
   Zend_Uri::setConfig(array('allow_unwise' => false));

.. note::

   ``Zend_Uri::setConfig()`` paramètre les options de configuration de manière globale. Il est recommandé de
   réinitialiser l'option *allow_unwise* à ``FALSE`` comme dans l'exemple ci-dessus, à moins d'être certain de
   vouloir utiliser les caractères "imprudents" de manière globale.

.. _zend.uri.instance-methods:

Méthodes communes
-----------------

Toute instance sous-classe de ``Zend_Uri`` (par exemple ``Zend_Uri_Http``) possède plusieurs méthodes utiles :

.. _zend.uri.instance-methods.getscheme:

Retrouver le schéma d'un URI
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Le schéma d'un *URI* est la partie précédent les double-points (:). Par exemple, le schéma de
*http://www.zend.com* est *http*.

.. _zend.uri.instance-methods.getscheme.example-1:

.. rubric:: Récupérer le schéma d'un objet ``Zend_Uri_*``

.. code-block:: php
   :linenos:

   $uri = Zend_Uri::factory('http://www.zend.com');

   $scheme = $uri->getScheme();  // "http"

La méthode ``getScheme()`` retourne une chaîne de caractères.

.. _zend.uri.instance-methods.geturi:

Récupérer l'URI entier
^^^^^^^^^^^^^^^^^^^^^^

.. _zend.uri.instance-methods.geturi.example-1:

.. rubric:: Récupérer l'URI entier depuis un objet ``Zend_Uri_*``

.. code-block:: php
   :linenos:

   $uri = Zend_Uri::factory('http://www.zend.com');

   echo $uri->getUri();  // "http://www.zend.com"

La méthode ``getUri()`` retourne une chaîne de caractères représentant l'URI entier.

.. _zend.uri.instance-methods.valid:

Valider l'URI
^^^^^^^^^^^^^

``Zend_Uri::factory()`` validera de toute façon systématiquement l'URI qui lui est passé en paramètre. Par
contre, l'URI peut devenir invalide après, s'il est modifié.

.. _zend.uri.instance-methods.valid.example-1:

.. rubric:: Valider un objet ``Zend_Uri_*``

.. code-block:: php
   :linenos:

   $uri = Zend_Uri::factory('http://www.zend.com');

   $isValid = $uri->valid();  // TRUE

La méthode ``valid()`` propose une façon de vérifier si l'URI est toujours valide.



.. _`Uniform Resource Identifiers`: http://www.w3.org/Addressing/

.. [#] Actuellement, ``Zend_Uri`` ne supporte que les schémas intégrés *HTTP* et *HTTPS*