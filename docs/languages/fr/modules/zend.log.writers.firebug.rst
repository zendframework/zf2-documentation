.. _zend.log.writers.firebug:

Écrire vers Firebug
===================

``Zend_Log_Writer_Firebug`` envoie des données d'historisation vers la `console Firebug`_.

.. image:: ../images/zend.wildfire.firebug.console.png
   :width: 310


Toutes les données sont envoyées via le composant ``Zend_Wildfire_Channel_HttpHeaders`` qui utilise les en-têtes
*HTTP* pour s'assurer que le contenu de la page n'est pas perturbé. Déboguer les requêtes *AJAX* qui requière
du *JSON*"propre" ou un réponse *XML* est possible avec cette approche.

Éléments requis :

- Navigateur Firefox idéalement en version 3 mais la version 2 est aussi supportée.

- L'extension Firefox nommée Firebug qui peut être téléchargée à cette adresse
  `https://addons.mozilla.org/en-US/firefox/addon/1843`_.

- L'extension Firefox nommée FirePHP ui peut être téléchargée à cette adresse
  `https://addons.mozilla.org/en-US/firefox/addon/6149`_.

.. _zend.log.writers.firebug.example.with_front_controller:

.. rubric:: Journaliser avec Zend_Controller_Front

.. code-block:: php
   :linenos:

   // Placez ceci dans votre fichier d'amorçage
   // avant de distribuer votre contrôleur frontal
   $writer = new Zend_Log_Writer_Firebug();
   $logger = new Zend_Log($writer);

   // Utiliser ceci dans vos fichiers de modèles, vues et contrôleurs
   $logger->log('Ceci est un message de log !', Zend_Log::INFO);

.. _zend.log.writers.firebug.example.without_front_controller:

.. rubric:: Journaliser sans Zend_Controller_Front

.. code-block:: php
   :linenos:

   $writer = new Zend_Log_Writer_Firebug();
   $logger = new Zend_Log($writer);

   $request = new Zend_Controller_Request_Http();
   $response = new Zend_Controller_Response_Http();
   $channel = Zend_Wildfire_Channel_HttpHeaders::getInstance();
   $channel->setRequest($request);
   $channel->setResponse($response);

   // Démarrer l'output buffering
   ob_start();

   // Maintenant vous pouvez appeler le logguer
   $logger->log('Ceci est un message de log !', Zend_Log::INFO);

   // Envoi des données d'historisation vers le navigateur
   $channel->flush();
   $response->sendHeaders();

.. _zend.log.writers.firebug.priority-styles:

Paramétrer les styles pour les priorités
----------------------------------------

Les priorités incorporées et celles définies par l'utilisateur peuvent être stylisées avec la méthode
``setPriorityStyle()``.

.. code-block:: php
   :linenos:

   $logger->addPriority('FOO', 8);
   $writer->setPriorityStyle(8, 'TRACE');
   $logger->foo('Foo Message');

Le style par défaut pour les priorités définies par l'utilisateur peut être paramétrer avec la méthode
``setDefaultPriorityStyle()``.

.. code-block:: php
   :linenos:

   $writer->setDefaultPriorityStyle('TRACE');

Les styles supportés sont les suivants :



      .. _zend.log.writers.firebug.priority-styles.table:

      .. table:: Styles d'historisation de Firebug

         +---------+-------------------------------------------------------------------------------------------------------+
         |Style    |Description                                                                                            |
         +=========+=======================================================================================================+
         |LOG      |Affiche un message d'historisation basique                                                             |
         +---------+-------------------------------------------------------------------------------------------------------+
         |INFO     |Affiche un message d'historisation de type information                                                 |
         +---------+-------------------------------------------------------------------------------------------------------+
         |WARN     |Affiche un message d'historisation de type avertissement                                               |
         +---------+-------------------------------------------------------------------------------------------------------+
         |ERROR    |Affiche un message d'historisation de type erreur (celui-ci incrémente le compteur d'erreur de Firebug)|
         +---------+-------------------------------------------------------------------------------------------------------+
         |TRACE    |Affiche un message d'historisation avec une trace extensible                                           |
         +---------+-------------------------------------------------------------------------------------------------------+
         |EXCEPTION|Affiche un message d'historisation de type erreur avec une trace extensible                            |
         +---------+-------------------------------------------------------------------------------------------------------+
         |TABLE    |Affiche un message d'historisation avec une table extensible                                           |
         +---------+-------------------------------------------------------------------------------------------------------+



.. _zend.log.writers.firebug.preparing-data:

Préparer les données pour l'historisation
-----------------------------------------

Toute variable *PHP* peut être journalisée avec les priorités incorporées, un formatage spécial est requis si
vous utilisez des styles d'historisation un peu plus spécialisé.

Les styles ``LOG``, ``INFO``, ``WARN``, ``ERROR`` et ``TRACE`` ne requièrent pas de formatage spécial.

.. _zend.log.writers.firebug.preparing-data.exception:

Historisation des exceptions
----------------------------

Pour journaliser une ``Zend_Exception``, fournissez simplement l'objet exception au logguer. Il n'y a pas
d'importance sur la priorité ou le style que vous avez fourni puisque l'exception est automatiquement reconnue.

.. code-block:: php
   :linenos:

   $exception = new Zend_Exception('Test d\'exception');
   $logger->err($exception);

.. _zend.log.writers.firebug.preparing-data.table:

Historisation sous forme de tableau
-----------------------------------

Vous pouvez aussi journaliser des données en les formatant comme un tableau. Les colonnes sont automatiquement
reconnues et la première ligne de données devient automatiquement la ligne d'en-têtes.

.. code-block:: php
   :linenos:

   $writer->setPriorityStyle(8, 'TABLE');
   $logger->addPriority('TABLE', 8);

   $table = array('Ligne de résumé pour la table',
                  array(
                      array('Colonne 1', 'Colonne 2'),
                      array('Ligne 1 c 1',' Ligne 1 c 2'),
                      array('Ligne 2 c 1',' Ligne 2 c 2')
                  )
                 );
   $logger->table($table);



.. _`console Firebug`: http://www.getfirebug.com/
.. _`https://addons.mozilla.org/en-US/firefox/addon/1843`: https://addons.mozilla.org/en-US/firefox/addon/1843
.. _`https://addons.mozilla.org/en-US/firefox/addon/6149`: https://addons.mozilla.org/en-US/firefox/addon/6149
