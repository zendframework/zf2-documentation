.. _zend.log.formatters:

Formateurs (mise en forme)
==========================

Un formateur est un objet qui est responsable de prendre un tableau *event* décrivant un événement de log et
produisant une ligne de log formatée sous la forme d'un une chaîne.

Quelques rédacteurs ("Writers") ne fonctionnent pas en terme de ligne et ne peuvent pas utiliser un formateur. Un
exemple est le rédacteur de base de données, qui insère les items d'événement directement en colonnes de base
de données. Pour les rédacteurs qui ne peuvent pas supporter un formateur, une exception est levée si vous
essayez d'affecter un formateur.

.. _zend.log.formatters.simple:

Formatage simple
----------------

``Zend_Log_Formatter_Simple`` est le formateur par défaut. Il est configuré automatiquement quand vous n'indiquez
aucun formateur. La configuration par défaut est équivalente à ce qui suit :

   .. code-block:: php
      :linenos:

      $format = '%timestamp% %priorityName% (%priority%): %message%' . PHP_EOL;
      $formatter = new Zend_Log_Formatter_Simple($format);



Un formateur est affecté à un objet individuel de rédacteur en utilisant la méthode ``setFormatter()`` du
rédacteur :

   .. code-block:: php
      :linenos:

      $redacteur = new Zend_Log_Writer_Stream('php://output');
      $formateur = new Zend_Log_Formatter_Simple('Bonjour %message%' . PHP_EOL);
      $redacteur->setFormatter($formateur);

      $logger = new Zend_Log();
      $logger->addWriter($redacteur);

      $logger->info('Monde');

      // affiche "Bonjour Monde"



Le constructeur de ``Zend_Log_Formatter_Simple`` accepte un paramètre unique : la chaîne de formatage. Cette
chaîne contient des clés entourées par le signe pourcentage (par exemple %message%). La chaîne de formatage
peut contenir n'importe quelle clé du tableau de données d'événement. Vous pouvez récupérer les clés par
défaut en utilisant la constante DEFAULT_FORMAT de ``Zend_Log_Formatter_Simple``.

.. _zend.log.formatters.xml:

Formater vers le XML
--------------------

``Zend_Log_Formatter_Xml`` formate des données de log dans des chaînes de type XML. Par défaut, il note
automatiquement tout le tableau de données d'événements :

   .. code-block:: php
      :linenos:

      $redacteur = new Zend_Log_Writer_Stream('php://output');
      $formateur = new Zend_Log_Formatter_Xml();
      $redacteur->setFormatter($formateur);

      $logger = new Zend_Log();
      $logger->addWriter($redacteur);

      $logger->info("Message d'information");



Le code ci-dessus affiche le XML suivant (des espaces supplémentaires sont ajoutés pour la clarté) :

   .. code-block:: xml
      :linenos:

      <logEntry>
        <timestamp>2007-04-06T07:24:37-07:00</timestamp>
        <message>Message d'information</message>
        <priority>6</priority>
        <priorityName>INFO</priorityName>
      </logEntry>



Il est possible d'adapter l'élément racine comme indiquent faire correspondre les éléments XML au tableau de
données d'évènements. Le constructeur de ``Zend_Log_Formatter_Xml`` accepte une chaîne avec le nom de
l'élément racine comme premier paramètre et un tableau associatif avec les éléments de correspondance comme
deuxième paramètre :

   .. code-block:: php
      :linenos:

      $redacteur = new Zend_Log_Writer_Stream('php://output');
      $formateur = new Zend_Log_Formatter_Xml('log',
                                              array('msg' => 'message',
                                                    'niveau' => 'priorityName'));
      $redacteur->setFormatter($formateur);

      $logger = new Zend_Log();
      $logger->addWriter($redacteur);

      $logger->info("Message d'information");

Le code ci-dessus change l'élément racine par défaut de *logEntry* en *log*. Il fait correspondre également les
éléments *msg* au *message* de l'item de donnée d'événement. Ceci a comme conséquence l'affichage suivant :

   .. code-block:: xml
      :linenos:

      <log>
        <msg>Message d'information</msg>
        <niveau>INFO</niveau>
      </log>




