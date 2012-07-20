.. _zend.filter.set.realpath:

RealPath
========

Ce filtre va résoudre un lien ou un chemin en chemin absolu canonique. Toutes références à ``'/./'``,
``'/../'`` et tout ajout supplémentaire de ``'/'`` sera résolu ou supprimé. Aucun caractère de lien symbolique
ne sera présent dans le résultat (``'/./'`` ou ``'/../'``)

``Zend_Filter_RealPath`` retourne ``FALSE`` en cas d'echec par exemple si le fichier n'existe pas. Sur les systems
BSD, ``Zend_Filter_RealPath`` n'échoue pas si seule la dernière partie du chemin n'existe pas, les autres
systèmes retourneront ``FALSE``.

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_RealPath();
   $path   = '/www/var/path/../../mypath';
   $filtered = $filter->filter($path);

   // retourne '/www/mypath'

Il peut être nécessaire quelques fois de vouloir utiliser ce filtre sur des chemins inexistants. Par exemple
récupérer le realpath d'un chemin à créer. Dans ce cas vous pouvez passer ``FALSE`` au constructeur, ou
utiliser ``setExists()``.

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_RealPath(false);
   $path   = '/www/var/path/../../non/existing/path';
   $filtered = $filter->filter($path);

   // retourne '/www/non/existing/path' même si file_exists ou realpath retourneraient false


