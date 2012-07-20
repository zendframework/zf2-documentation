.. _zend.log.filters:

Filtres
=======

Un objet *Filter* bloque les messages avant l'écriture dans le log.

.. _zend.log.filters.all-writers:

Filtrer pour tous les rédacteurs (Writers)
------------------------------------------

Pour filtrer avant tous les rédacteurs, vous pouvez ajouter autant de filtres que vous souhaitez à l'objet
enregistreur en utilisant la méthode ``addFilter()``:

   .. code-block:: php
      :linenos:

      $logger = new Zend_Log();

      $redacteur = new Zend_Log_Writer_Stream('php://output');
      $logger->addWriter($redacteur);

      $filtre = new Zend_Log_Filter_Priority(Zend_Log::CRIT);
      $logger->addFilter($filtre);

      // bloqué
      $logger->info("Message d'information");

      // écrit dans le log
      $logger->emerg("Message d'urgence");

Quand vous ajoutez un ou plusieurs filtres à l'objet enregistreur, le message doit passer par tous les filtres
avant que tous les rédacteurs le reçoive.

.. _zend.log.filters.single-writer:

Filtrer pour une seule instance de rédacteur
--------------------------------------------

Pour filtrer seulement sur un instance spécifique de rédacteur, employer la méthode ``addFilter()`` de ce
rédacteur :

   .. code-block:: php
      :linenos:

      $logger = new Zend_Log();

      $redacteur1 =
          new Zend_Log_Writer_Stream('/chemin/vers/premier/fichierdelog');
      $logger->addWriter($redacteur1);

      $redacteur2 =
          new Zend_Log_Writer_Stream('/chemin/vers/second/fichierdelog');
      $logger->addWriter($redacteur2);

      // ajoute le filter seulement pour le redacteur2
      $filter = new Zend_Log_Filter_Priority(Zend_Log::CRIT);
      $redacteur2->addFilter($filter);

      // écrit par le redacteur1, bloqué par le redacteur2
      $logger->info("Message d'information");

      // écrit dans les 2 logs
      $logger->emerg("Message d'urgence");




