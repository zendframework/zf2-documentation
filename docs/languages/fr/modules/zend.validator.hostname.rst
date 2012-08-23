.. EN-Revision: none
.. _zend.validator.set.hostname:

Hostname
========

``Zend_Validate_Hostname`` vous permet de valider un nom de domaine sur la base d'un ensemble de spécifications
connues. Il est ainsi possible de valider trois types différents de noms de domaine : un nom de domaine qualifié
(ex : domaine.com), une adresse IP (ex : 1.2.3.4) ou un nom de domaine local (ex : localhost). Par défaut, seul
les noms de domaine qualifiés sont acceptés.

**Utilisation basique**

Exemple simple :

   .. code-block:: php
      :linenos:

      $validateur = new Zend_Validate_Hostname();
      if ($validateur->isValid($domaine)) {
          // le nom de domaine est valide
      } else {
          // le nom de domaine est invalide ; afficher pourquoi
          foreach ($validateur->getMessages() as $message) {
              echo "$message\n";
          }
      }

Ceci validera le domaine ``$domaine`` et, en cas d'échec, fournira des messages d'erreur informatifs via
*$validator->getMessages()*.

**Validation de différents types de noms de domaine**

Il peut se trouver que vous souhaitez valider des adresses IP, des noms de domaine locaux ou toute combinaison de
tous les types disponibles. Cette opération peut être effectuée en passant un paramètre à
``Zend_Validate_Hostname`` au moment de l'instanciation. Le paramètre doit être un entier qui détermine quels
types de noms de domaine sont admis. Il est recommandé d'utiliser les constantes de la classe
``Zend_Validate_Hostname``.

Les constantes de ``Zend_Validate_Hostname`` sont : ``ALLOW_DNS`` qui autorise uniquement les noms de domaine
qualifiés, ``ALLOW_IP`` qui autorise les adresses IP, ``ALLOW_LOCAL`` qui autorise les domaines locaux et
``ALLOW_ALL`` qui autorise les trois types précédents. Pour vérifier uniquement les adresses IP, vous pouvez
utiliser l'exemple suivant :

   .. code-block:: php
      :linenos:

      $validateur = new Zend_Validate_Hostname(Zend_Validate_Hostname::ALLOW_IP);
      if ($validateur->isValid($hostname)) {
          // le nom de domaine est valide
      } else {
          // le nom de domaine est invalide ; afficher pourquoi
          foreach ($validateur->getMessages() as $message) {
              echo "$message\n";
          }
      }



Vous pouvez utiliser ``ALLOW_ALL`` pour accepter tous les types de domaines. De même, vous pouvez créer des
configurations combinant ces différents types. Par exemple, pour accepter les domaines qualifiés et les domaines
locaux, instanciez votre objet ``Zend_Validate_Hostname`` de la manière suivante :

   .. code-block:: php
      :linenos:

      $validateur = new Zend_Validate_Hostname(Zend_Validate_Hostname::ALLOW_DNS |
                                               Zend_Validate_Hostname::ALLOW_IP);



**Validation de Nom de Domaine International (IDN)**

Certains noms de domaines nationaux (Country Code Top Level Domains ou ccTLD), comme .de (Allemagne), supporte les
caractères internationaux dans leurs noms de domaine. Ceci est connu sous le nom de Nom de Domaine International
(IDN). Ces domaines peuvent être vérifiés par ``Zend_Validate_Hostname`` grâce aux caractères étendus qui
sont utilisés dans le processus de validation.

Jusqu'à maintenant plus de 50 ccTLDs supportent les domaines IDN.

Pour vérifier un domaine IDN c'est aussi simple que d'utiliser le validateur standard de nom de domaine puisque la
validation IDN est activé par défaut. Si vous voulez mettre hors service la validation IDN, cela peut être fait
par le passage d'un paramètre au constructeur ``Zend_Validate_Hostname`` ou via la méthode
*$validator->setValidateIdn()*.

Vous pouvez aussi désactiver la validation IDN en passant un second paramètre au constructeur du
``Zend_Validate_Hostname`` comme ceci :

   .. code-block:: php
      :linenos:

      $validator =
          new Zend_Validate_Hostname(
              array(
                  'allow' => Zend_Validate_Hostname::ALLOW_DNS,
                  'idn'   => false
              )
          );

Alternativement vous pouvez passer soit ``TRUE`` soit ``FALSE`` à *$validator->setValidateIdn()* pour activer ou
désactiver la validation IDN. Si vous essayez de vérifier un nom de domaine IDN qui n'est pas actuellement
soutenu il est probable qu'il retournera une erreur s'il y a des caractères internationaux. Quand un fichier de
ccTLD spécifiant les caractères supplémentaires n'existe pas dans "Zend/Validate/Hostname",une validation de nom
de domaine normale est réalisée.

Notez cependant que les IDNs sont seulement validés si vous autorisez la validation des noms de domaine.

**Validation des "Top Level Domains"**

Par défaut un nom de domaine sera vérifié grâce à une liste de TLDs connus. Si cette fonctionnalité n'est pas
nécessaire, elle peut être désactivée de la même façon que la désactivation du support des IDNs. Vous pouvez
désactiver la validation TLD en passant un troisième paramètre au constructeur de ``Zend_Validate_Hostname``.
Dans l'exemple ci-dessous, la validation IDN est supportée via le second paramètre.

   .. code-block:: php
      :linenos:

      $validator =
          new Zend_Validate_Hostname(
              array(
                  'allow' => Zend_Validate_Hostname::ALLOW_DNS,
                  'idn'   => true,
                  'tld'   => false
              )
          );

Alternativement vous pouvez passer soit ``TRUE`` soit ``FALSE`` à *$validator->setValidateTld()* pour activer ou
désactiver la validation TLD.

Notez cependant que les TLDs sont seulement validés si vous autorisez la validation des noms de domaine.


