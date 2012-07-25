.. _zend.log.overview:

Présentation
============

``Zend_Log`` est un composant destiné à tous les usages du log. Il supporte l'écriture multiple centralisée,
formate les messages envoyés vers les logs, et les filtre. Ces fonctions sont divisées en objets suivants :

   - Un enregistreur (instance de ``Zend_Log``) est l'objet que votre application emploie le plus. Vous pouvez
     avoir autant d'objets d'enregistreur que vous voulez ; ils n'agissent pas l'un sur l'autre. Un objet
     enregistreur doit contenir au moins un rédacteur (Writer), et peut facultativement contenir un ou plusieurs
     filtres.

   - Un rédacteur [ou Writer] (hérite de ``Zend_Log_Writer_Abstract``) est responsable de la sauvegarde des
     données dans le stockage.

   - Un filtre (implémente ``Zend_Log_Filter_Interface``) bloque des données de log ne devant pas être écrites.
     Un filtre peut être appliqué à un rédacteur en particulier, ou à tous les rédacteurs. Dans l'un ou
     l'autre cas, les filtres peuvent être enchaînés.

   - Un formateur (implémente ``Zend_Log_Formatter_Interface``) peut formater les données de log avant qu'elles
     soient écrites par un rédacteur. Chaque rédacteur a exactement un formateur.



.. _zend.log.overview.creating-a-logger:

Créer un log
------------

Pour commencer à enregistrer, instanciez un rédacteur et passez le à une instance d'un enregistreur :

   .. code-block:: php
      :linenos:

      $logger = new Zend_Log();
      $redacteur = new Zend_Log_Writer_Stream('php://output');

      $logger->addWriter($redacteur);

Il est important de noter que l'enregistreur doit avoir au moins un rédacteur. Vous pouvez ajouter tout nombre de
rédacteurs en utilisant la méthode ``addWriter()``.

Alternativement, vous pouvez passer un rédacteur directement au constructeur de l'enregistreur :

   .. code-block:: php
      :linenos:

      $logger = new Zend_Log(new Zend_Log_Writer_Stream('php://output'));

L'enregistreur est maintenant prêt à être utilisé.

.. _zend.log.overview.logging-messages:

Messages de logs
----------------

Pour enregistrer un message, appelez la méthode ``log()`` de l'instance de l'enregistreur et passez lui le message
avec son niveau de priorité.

   .. code-block:: php
      :linenos:

      $logger->log("Message d'information", Zend_Log::INFO);

Le premier paramètre de la méthode ``log()`` est une chaîne *message* et le deuxième paramètre est une
*priority* fourni en nombre entier. La priorité doit être l'une des priorités identifiées par l'instance de
l'enregistreur. Ceci est expliqué dans la prochaine section.

Un raccourci est également disponible. Au lieu d'appeler la méthode ``log()``, vous pouvez appeler une méthode
par le même nom que la priorité :

   .. code-block:: php
      :linenos:

      $logger->log("Message d'information", Zend_Log::INFO);
      $logger->info("Message d'information");

      $logger->log("Message d'urgence", Zend_Log::EMERG);
      $logger->emerg("Message d'urgence");



.. _zend.log.overview.destroying-a-logger:

Détruire un log
---------------

Si l'objet enregistreur n'est plus nécessaire, vous devez affectez la valeur ``NULL`` à la variable le contenant
pour le détruire. Ceci appellera automatiquement la méthode ``shutdown()`` de chaque rédacteur avant que l'objet
enregistreur ne soit détruit :

   .. code-block:: php
      :linenos:

      $logger = null;

Explicitement détruire le log de cette façon est facultatif et est exécuté automatiquement à la fermeture de
PHP.

.. _zend.log.overview.builtin-priorities:

Utiliser les priorités intégrées
--------------------------------

La classe de ``Zend_Log`` définit les priorités suivantes :

   .. code-block:: php
      :linenos:

      EMERG   = 0;  // Urgence : le système est inutilisable
      ALERT   = 1;  // Alerte: une mesure corrective
                    // doit être prise immédiatement
      CRIT    = 2;  // Critique : états critiques
      ERR     = 3;  // Erreur: états d'erreur
      WARN    = 4;  // Avertissement: états d'avertissement
      NOTICE  = 5;  // Notice: normal mais état significatif
      INFO    = 6;  // Information: messages d'informations
      DEBUG   = 7;  // Debug: messages de déboguages

Ces priorités sont toujours disponibles, et une méthode de convenance de même nom est disponible pour chacun.

Les priorités ne sont pas arbitraires. Elles viennent du protocole BSD *syslog*, qui est décrit dans la
`RFC-3164`_. Les noms et les niveaux de priorité correspondants sont également compatibles avec un autre système
de log de *PHP*, `PEAR Log`_, ce qui favorise l'interopérabilité entre lui et ``Zend_Log``.

Les numéros de priorité descendent par ordre d'importance. ``EMERG`` (0) est la priorité la plus importante.
``DEBUG`` (7) est la priorité la moins importante des priorités intégrées. Vous pouvez définir des priorités
d'importance inférieure que ``DEBUG``. En choisissant la priorité pour votre message de log, faîtes attention à
cette hiérarchie prioritaire et choisissez convenablement.

.. _zend.log.overview.user-defined-priorities:

Ajouter ses propres priorités
-----------------------------

Des priorités définies par l'utilisateur peuvent être ajoutées en cours d'exécution en utilisant la méthode
de ``addPriority()`` de l'enregistreur :

   .. code-block:: php
      :linenos:

      $logger->addPriority('ESSAI', 8);

L'extrait ci-dessus crée une nouvelle priorité, ``ESSAI``, dont la valeur est *8*. La nouvelle priorité est
alors disponible pour l'enregistreur :

   .. code-block:: php
      :linenos:

      $logger->log("Message d'essai", 8);
      $logger->essai("Message d'essai");

Les nouvelles priorités ne peuvent pas surcharger celles existantes.

.. _zend.log.overview.understanding-fields:

Comprendre les événements de logs
---------------------------------

Quand vous appelez la méthode ``log()`` ou l'un de ses raccourcis, un événement de log est créé. C'est
simplement un tableau associatif avec des données décrivant l'événement qui est envoyé aux rédacteurs. Les
clés suivantes sont toujours créées dans ce tableau : *timestamp*, *message*, *priority*, et *priorityName*.

La création du tableau *event* est complètement transparente. Cependant, la connaissance du tableau d'événement
est exigée pour ajouter un élément qui n'existerait pas dans le réglage par défaut ci-dessus.

Pour ajouter un nouvel élément à chaque futur événement, appeler la méthode ``setEventItem()`` en donnant une
clé et une valeur :

   .. code-block:: php
      :linenos:

      $logger->setEventItem('pid', getmypid());

L'exemple ci-dessus place un nouvel élément nommé *pid* et lui donne comme valeur le PID du processus courant.
Une fois qu'un nouvel élément a été placé, il est disponible automatiquement pour tous les rédacteurs avec
toutes les autres données d'événement pendant l'enregistrement. Un élément peut être surchargé à tout
moment en appelant une nouvelle fois la méthode ``setEventItem()``.

Le réglage d'un nouvel élément d'événement avec ``setEventItem()`` entraîne que le nouvel élément sera
envoyé à tous les rédacteurs de l'enregistreur. Cependant, ceci ne garantit pas que les rédacteurs utilisent
réellement l'élément. C'est parce que les rédacteurs ne sauront pas quoi faire avec lui à moins qu'un objet
formateur soit informé du nouvel élément. Veuillez vous reporter à la section sur des formateurs pour en
apprendre davantage.

.. _zend.log.overview.as-errorHandler:

Log PHP Errors
--------------

``Zend_Log`` can also be used to log *PHP* errors. Calling ``registerErrorHandler()`` will add ``Zend_Log`` before
the current error handler, and will pass the error along as well.

.. _zend.log.overview.as-errorHandler.properties.table-1:

.. table:: Zend_Log events from PHP errors have the additional fields matching handler ( int $errno , string $errstr [, string $errfile [, int $errline [, array $errcontext ]]] ) from set_error_handler

   +-------+-----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Name   |Error Handler Paramater|Description                                                                                                                                                                                                                                                           |
   +=======+=======================+======================================================================================================================================================================================================================================================================+
   |message|errstr                 |Contains the error message, as a string.                                                                                                                                                                                                                              |
   +-------+-----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |errno  |errno                  |Contains the level of the error raised, as an integer.                                                                                                                                                                                                                |
   +-------+-----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |file   |errfile                |Contains the filename that the error was raised in, as a string.                                                                                                                                                                                                      |
   +-------+-----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |line   |errline                |Contains the line number the error was raised at, as an integer.                                                                                                                                                                                                      |
   +-------+-----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |context|errcontext             |(optional) An array that points to the active symbol table at the point the error occurred. In other words, errcontext will contain an array of every variable that existed in the scope the error was triggered in. User error handler must not modify error context.|
   +-------+-----------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+



.. _`RFC-3164`: http://tools.ietf.org/html/rfc3164
.. _`PEAR Log`: http://pear.php.net/package/log
