.. EN-Revision: none
.. _zend.serializer.adapter:

Zend\Serializer\Adapter
=======================

Les adaptateurs ``Zend_Serializer`` servent à changer les méthodes de sérialisation facilement.

Chaque adaptateurs possède ses propres atouts et inconvénients. Dans certains cas, certains types PHP (objets) ne
peuvent être représentés sous forme de chaînes. Dans ce cas, ces types seront convertis vers un type
sérialisable (par exemple, les objets seront convertis en tableaux). Ci ceci échoue, une exception
``Zend\Serializer\Exception`` sera alors envoyée.

Voici une liste des adaptateurs disponibles.

.. _zend.serializer.adapter.phpserialize:

Zend\Serializer\Adapter\PhpSerialize
------------------------------------

Cet adaptateur utilise les fonctions PHP ``un/serialize`` et constitue un bon choix d'adaptateur par défaut.

Aucune option de configuration n'existe pour cet adaptateur.

.. _zend.serializer.adapter.igbinary:

Zend\Serializer\Adapter\Igbinary
--------------------------------

`Igbinary`_ est un logiciel Open Source crée par Sulake Dynamoid Oy. C'est un remplaçant du sérialiseur utiliser
par PHP. Au lieu d'utiliser une représentation textuelle (coûteuse en temps et en poids), igbinary représente les
structures de données PHP dans un format binaire compact. Les gains sont importants lorsqu'un système de stockage
comme memcache est utilisé pour les données sérialisées.

L'extension PHP igbinary est requise pour l'utilisation de cet adaptateur.

Aucune option de configuration n'existe pour cet adaptateur.

.. _zend.serializer.adapter.wddx:

Zend\Serializer\Adapter\Wddx
----------------------------

`WDDX`_ (Web Distributed Data eXchange) est à la fois un langage de programmation, une plateforme et un mecanisme
de transport de données entre différents environnements.

Cet adaptateur utilise simplement les fonctions PHP `wddx_*()`_. Veuillez lire le manuel PHP afin de vérifier la
disponibilité et l'installation de ces fonctions.

Aussi, l'extension PHP `SimpleXML`_ est utilisée pour vérifier si une valeur ``NULL`` retournée par
``wddx_unserialize()`` est basée sur une donnée sérialisée ``NULL`` ou au contraire des données non valides

Les options disponibles sont:

.. _zend.serializer.adapter.wddx.table.options:

.. table:: Options Zend\Serializer\Adapter\Wddx

   +-------+--------------+-----------------+-----------------------------------------------------+
   |Option |Type de donnée|Valeur par défaut|Description                                          |
   +=======+==============+=================+=====================================================+
   |comment|chaîne        |                 |Un commentaire qui apparaît dans l'entête du paquet. |
   +-------+--------------+-----------------+-----------------------------------------------------+

.. _zend.serializer.adapter.json:

Zend\Serializer\Adapter\Json
----------------------------

L'adaptateur *JSON* créer un pont vers ``Zend_Json`` et/ou ext/json (l'extension json de PHP). Pour plus
d'informations, lisez le manuel de :ref:`Zend_Json <zend.json.introduction>`.

Les options disponibles sont:

.. _zend.serializer.adapter.json.table.options:

.. table:: Options Zend\Serializer\Adapter\Json

   +--------------------+-----------------+---------------------+-----------+
   |Option              |Type de donnée   |Valeur par défaut    |Description|
   +====================+=================+=====================+===========+
   |cycleCheck          |booléen          |false                |Voyez      |
   +--------------------+-----------------+---------------------+-----------+
   |objectDecodeType    |Zend\Json\Json::TYPE_*|Zend\Json\Json::TYPE_ARRAY|Voyez      |
   +--------------------+-----------------+---------------------+-----------+
   |enableJsonExprFinder|booléen          |false                |Voyez      |
   +--------------------+-----------------+---------------------+-----------+

.. _zend.serializer.adapter.amf03:

Zend\Serializer\Adapter\Amf 0 et 3
----------------------------------

Les adaptateurs *AMF*, ``Zend\Serializer\Adapter\Amf0`` et ``Zend\Serializer\Adapter\Amf3``, sont un pont vers le
sérialiseur du composant ``ZendAmf``. Veuillez lire la documentation de :ref:`ZendAmf documentation
<zend.amf.introduction>` pour plus d'informations.

Aucune option de configuration n'existe pour cet adaptateur.

.. _zend.serializer.adapter.pythonpickle:

Zend\Serializer\Adapter\PythonPickle
------------------------------------

Cet adaptateur convertit des types PHP vers une chaine `Python Pickle`_ Grâce à lui, vous pouvez lire en Python
des données sérialisées de PHP et inversement.

Les options disponibles sont:

.. _zend.serializer.adapter.pythonpickle.table.options:

.. table:: Options Zend\Serializer\Adapter\PythonPickle

   +--------+----------------------+-----------------+---------------------------------------------+
   |Option  |Type de donnée        |Valeur par défaut|Description                                  |
   +========+======================+=================+=============================================+
   |protocol|entier (0 | 1 | 2 | 3)|0                |La version du protocole Pickle pour serialize|
   +--------+----------------------+-----------------+---------------------------------------------+

Le transtypage (PHP vers Python) se comporte comme suit:

.. _zend.serializer.adapter.pythonpickle.table.php2python:

.. table:: Le transtypage (PHP vers Python)

   +------------------+------------+
   |Type PHP          |Type Python |
   +==================+============+
   |NULL              |None        |
   +------------------+------------+
   |booléen           |booléen     |
   +------------------+------------+
   |entier            |entier      |
   +------------------+------------+
   |flottant          |flottant    |
   +------------------+------------+
   |chaine            |chaine      |
   +------------------+------------+
   |tableau           |liste       |
   +------------------+------------+
   |tableau associatif|dictionnaire|
   +------------------+------------+
   |objet             |dictionnaire|
   +------------------+------------+

Le transtypage (Python vers PHP) se comporte comme suit:

.. _zend.serializer.adapter.pythonpickle.table.python2php:

.. table:: Transtypage (Python vers PHP):

   +---------------+------------------------------------------------------+
   |Type Python    |Type PHP                                              |
   +===============+======================================================+
   |None           |NULL                                                  |
   +---------------+------------------------------------------------------+
   |booléen        |booléen                                               |
   +---------------+------------------------------------------------------+
   |entier         |entier                                                |
   +---------------+------------------------------------------------------+
   |long           |entier | flottant | chaine | Zend\Serializer\Exception|
   +---------------+------------------------------------------------------+
   |flottant       |flottant                                              |
   +---------------+------------------------------------------------------+
   |chaine         |chaine                                                |
   +---------------+------------------------------------------------------+
   |octets         |chaine                                                |
   +---------------+------------------------------------------------------+
   |chaine Unicode |chaine UTF-8                                          |
   +---------------+------------------------------------------------------+
   |list           |tableau                                               |
   +---------------+------------------------------------------------------+
   |tuple          |tableau                                               |
   +---------------+------------------------------------------------------+
   |dictionnaire   |tableau associatif                                    |
   +---------------+------------------------------------------------------+
   |Tout autre type|Zend\Serializer\Exception                             |
   +---------------+------------------------------------------------------+

.. _zend.serializer.adapter.phpcode:

Zend\Serializer\Adapter\PhpCode
-------------------------------

Cet adaptateur génère une chaine représentant du code analysable par PHP via `var_export()`_.A la
désérialisation, les données seront exécutées par `eval`_.

Aucune option de configuration n'existe pour cet adaptateur.

.. warning::

   **Désérialiser des objets**

   Les objets seront sérialisés en utilisant la méthode magique `\__set_state`_ Si la classe ne propose pas
   cette méthode, une erreur fatale aboutira.

.. warning::

   **Utilisation de eval()**

   L'adaptateur ``PhpCode`` utilise ``eval()`` pour désérialiser. Ceci mène à des problèmes de performance et
   de sécurité, un nouveau processus sera crée. Typiquement, vous devriez utiliser l'adaptateur ``PhpSerialize``
   à moins que vous ne vouliez que les données sérialisées ne soient analysables à l'oeil humain.



.. _`Igbinary`: http://opensource.dynamoid.com
.. _`WDDX`: http://wikipedia.org/wiki/WDDX
.. _`wddx_*()`: http://php.net/manual/book.wddx.php
.. _`SimpleXML`: http://php.net/manual/book.simplexml.php
.. _`Python Pickle`: http://docs.python.org/library/pickle.html
.. _`var_export()`: http://php.net/manual/function.var-export.php
.. _`eval`: http://php.net/manual/function.eval.php
.. _`\__set_state`: http://php.net/manual/language.oop5.magic.php#language.oop5.magic.set-state
