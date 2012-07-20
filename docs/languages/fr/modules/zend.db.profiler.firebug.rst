.. _zend.db.profiler.profilers.firebug:

Profiler avec Firebug
=====================

``Zend_Db_Profiler_Firebug`` envoie des informations de profilage vers la `console`_ `Firebug`_.

Toutes les données sont envoyées via le composant ``Zend_Wildfire_Channel_HttpHeaders`` qui utilise les en-têtes
*HTTP* pour s'assurer que le contenu de la page n'est pas perturbé. Déboguer les requêtes *AJAX* qui requière
du *JSON*"propre" ou un réponse *XML* est possible avec cette approche.

Éléments requis :

- Navigateur Firefox idéalement en version 3 mais la version 2 est aussi supportée.

- L'extension Firefox nommée Firebug qui peut être téléchargée à cette adresse
  `https://addons.mozilla.org/en-US/firefox/addon/1843`_.

- L'extension Firefox nommée FirePHP qui peut être téléchargée à cette adresse
  `https://addons.mozilla.org/en-US/firefox/addon/6149`_.

.. _zend.db.profiler.profilers.firebug.example.with_front_controller:

.. rubric:: Profilage de base de données avec Zend_Controller_Front

.. code-block:: php
   :linenos:

   // Dans votre fichier d'amorçage
   $profiler = new Zend_Db_Profiler_Firebug('All DB Queries');
   $profiler->setEnabled(true);

   // Attacher le profileur à votre adaptateur de base de données
   $db->setProfiler($profiler)

   // Distribuer votre contrôleur frontal

   // Toutes les requêtes dans vos fichiers de modèles, vues et
   // contrôleurs seront maintenant profilées et envoyées à Firebug

.. _zend.db.profiler.profilers.firebug.example.without_front_controller:

.. rubric:: Profilage de base de données sans Zend_Controller_Front

.. code-block:: php
   :linenos:

   $profiler = new Zend_Db_Profiler_Firebug('All DB Queries');
   $profiler->setEnabled(true);

   // Attacher le profileur à votre adaptateur de base de données
   $db->setProfiler($profiler)

   $request  = new Zend_Controller_Request_Http();
   $response = new Zend_Controller_Response_Http();
   $channel  = Zend_Wildfire_Channel_HttpHeaders::getInstance();
   $channel->setRequest($request);
   $channel->setResponse($response);

   // Démarrer l'output buffering
   ob_start();

   // Maintenant vous pouvez lancer les requêtes
   // qui doivent être profilées

   // Envoi des données de profiling vers le navigateur
   $channel->flush();
   $response->sendHeaders();



.. _`console`: http://getfirebug.com/logging.html
.. _`Firebug`: http://www.getfirebug.com/
.. _`https://addons.mozilla.org/en-US/firefox/addon/1843`: https://addons.mozilla.org/en-US/firefox/addon/1843
.. _`https://addons.mozilla.org/en-US/firefox/addon/6149`: https://addons.mozilla.org/en-US/firefox/addon/6149
