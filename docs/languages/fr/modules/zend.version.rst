.. _zend.version.reading:

Lire la version de Zend Framework
=================================

``Zend_Version`` fournit la constante de classe ``Zend_Version::VERSION`` qui contient une chaîne identifiant la
version courante de Zend Framework. ``Zend_Version::VERSION`` contient "1.7.2", par exemple.

La méthode statique ``Zend_Version::compareVersion($version)`` est basée sur la fonction *PHP*
`version_compare()`_. La méthode retourne -1 si la ``$version`` fournie est plus ancienne que la version courante
de Zend Framework, 0 si c'est la même, et +1 si la ``$version`` fournie est plus récente que la version courante
de Zend Framework.

.. _zend.version.reading.example:

.. rubric:: Exemple avec la méthode compareVersion()

.. code-block:: php
   :linenos:

   // retourne -1, 0 or 1
   $cmp = Zend_Version::compareVersion('2.0.0');

La méthode statique ``Zend_Version::getLatest()`` permet d'obtenir le numéro de version de la dernière release
stable disponible au téléchargement sur le site `Zend Framework`_.

.. _zend.version.latest.example:

.. rubric:: Example de la méthode getLatest()

.. code-block:: php
   :linenos:

   // retourne 1.11.0 (ou une version ultérieure)
   echo Zend_Version::getLatest();



.. _`version_compare()`: http://www.php.net/manual/fr/ref.version_compare.php
.. _`Zend Framework`: http://framework.zend.com/download/latest
