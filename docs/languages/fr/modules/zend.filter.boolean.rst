.. EN-Revision: none
.. _zend.filter.set.boolean:

Boolean
=======

Ce filtre transforme toute donnée en valeur ``BOOLEENNE``. Ce peut être utile en travaillant avec des bases de
données ou des formulaires.

.. _zend.filter.set.boolean.default:

Comportement par défaut de Zend\Filter\Boolean
----------------------------------------------

Par défaut, ce filtre caste (transtype) sa valeur vers un ``BOOLEEN``\  ; en d'autres termes, il fonctionne comme
un appel PHP ``(boolean) $value``.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Boolean();
   $value  = '';
   $result = $filter->filter($value);
   // retourne false

Ceci signifie que sans paramètre additionnel, ``Zend\Filter\Boolean`` prend toute valeur d'entrée et retourne un
``BOOLEEN`` comme le cast PHP vers le ``BOOLEEN``.

.. _zend.filter.set.boolean.types:

Changer le comportement de Zend\Filter\Boolean
----------------------------------------------

Quelques fois, le cast vers tel que ``(boolean)`` peut ne pas suffire. ``Zend\Filter\Boolean`` permet ainsi de
configurer les types d'entrée à convertir, et ceux à ignorer.

Les types suivants sont acceptés :

- **booléen**\  : retourne la valeur booléenne telle quelle.

- **entier**\  : convertit l'entier **0** en ``FALSE``.

- **flottant**\  : convertit le flottant **0.0** en ``FALSE``.

- **chaine**\  : convertit la chaîne vide **''** en ``FALSE``.

- **zero**\  : convertit la chaîne contenant zéro (**'0'**) en ``FALSE``.

- **empty_array**\  : convertit le tableau vide **array()** en ``FALSE``.

- **null**\  : convertit une valeur ``NULL`` en ``FALSE``.

- **php**\  : convertit une valeur, comme *PHP* le ferait, en ``BOOLEEN``.

- **false_string**\  : convertit une chaine contenant le mot "false" en booléen ``FALSE``.

- **yes**\  : convertit une chaîne localisée contenant le mot "no" en ``FALSE``.

- **all**: Convertit tous les types ci-dessus vers un ``BOOLEEN``.

Toute autre valeur fournie retournera ``TRUE``.

Pour préciser les options ci-dessus, plusieurs manières sont données : utilisez des chaînes, des constantes,
ajoutez les, utilisez des tableaux... Voyez l'exemple :

.. code-block:: php
   :linenos:

   // convertit 0 vers false
   $filter = new Zend\Filter\Boolean(Zend\Filter\Boolean::INTEGER);

   // convertit 0 et '0' vers false
   $filter = new Zend\Filter\Boolean(
       Zend\Filter\Boolean::INTEGER + Zend\Filter\Boolean::ZERO
   );

   // convertit 0 et '0' vers false
   $filter = new Zend\Filter\Boolean(array(
       'type' => array(
           Zend\Filter\Boolean::INTEGER,
           Zend\Filter\Boolean::ZERO,
       ),
   ));

   // convertit 0 et '0' vers false
   $filter = new Zend\Filter\Boolean(array(
       'type' => array(
           'integer',
           'zero',
       ),
   ));

Vous pouvez aussi passer une instance de ``Zend_Config`` pour préciser les options. Pour préciser ces options
après la création de votre objet, utilisez la méthode ``setType()``.

.. _zend.filter.set.boolean.localized:

Booléens localisés
------------------

Comme déja précisé, ``Zend\Filter\Boolean`` reconnait les chaînes localisées "yes" et "no". Ceci signifie que
vous pouvez demander au client au travers d'un formulaire "oui" ou "non" dans sa propre langue et
``Zend\Filter\Boolean`` convertira la valeur vers le booléen approprié.

Préciser la locale s'effectue grâce à la clé de configuration ``locale`` ou la méthode ``setLocale()``.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Boolean(array(
       'type'   => Zend\Filter\Boolean::ALL,
       'locale' => 'de',
   ));

   // retourne false
   echo $filter->filter('nein');

   $filter->setLocale('en');

   // retourne true
   $filter->filter('yes');

.. _zend.filter.set.boolean.casting:

Désactiver le cast (transtypage)
--------------------------------

Il peut arriver de ne vouloir que reconnaitre ``TRUE`` ou ``FALSE`` et donc retourner les autres valeurs telles
quelles. ``Zend\Filter\Boolean`` permet un tel comportement via son option ``casting`` lorsque réglée sur
``FALSE``.

Dans un tel cas, ``Zend\Filter\Boolean`` fonctionnera comme décrit dans le tableau ci-dessous qui montre quelles
valeurs retournent ``TRUE`` ou ``FALSE``. Toute autre valeur non présente dans ce tableau sera retournée telle
quelle lorsque l'option ``casting`` vaut ``FALSE``.

.. _zend.filter.set.boolean.casting.table:

.. table:: Utilisation sans transtypage

   +---------------------------------+----------------------------------------+----------------------------------------+
   |Type                             |True                                    |False                                   |
   +=================================+========================================+========================================+
   |Zend\Filter\Boolean::BOOLEAN     |TRUE                                    |FALSE                                   |
   +---------------------------------+----------------------------------------+----------------------------------------+
   |Zend\Filter\Boolean::INTEGER     |0                                       |1                                       |
   +---------------------------------+----------------------------------------+----------------------------------------+
   |Zend\Filter\Boolean::FLOAT       |0.0                                     |1.0                                     |
   +---------------------------------+----------------------------------------+----------------------------------------+
   |Zend\Filter\Boolean::STRING      |""                                      |                                        |
   +---------------------------------+----------------------------------------+----------------------------------------+
   |Zend\Filter\Boolean::ZERO        |"0"                                     |"1"                                     |
   +---------------------------------+----------------------------------------+----------------------------------------+
   |Zend\Filter\Boolean::EMPTY_ARRAY |array()                                 |                                        |
   +---------------------------------+----------------------------------------+----------------------------------------+
   |Zend\Filter\Boolean::NULL        |NULL                                    |                                        |
   +---------------------------------+----------------------------------------+----------------------------------------+
   |Zend\Filter\Boolean::FALSE_STRING|"false" (non sensible à la casse)       |"true" (non sensible à la casse)        |
   +---------------------------------+----------------------------------------+----------------------------------------+
   |Zend\Filter\Boolean::YES         |"oui" localisé (non sensible à la casse)|"non" localisé (non sensible à la casse)|
   +---------------------------------+----------------------------------------+----------------------------------------+

L'exemple qui suit illustre l'utilisation de l'option ``casting``\  :

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Boolean(array(
       'type'    => Zend\Filter\Boolean::ALL,
       'casting' => false,
   ));

   // retourne false
   echo $filter->filter(0);

   // retourne true
   echo $filter->filter(1);

   // retourne la valeur
   echo $filter->filter(2);


