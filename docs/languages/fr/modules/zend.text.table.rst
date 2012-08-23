.. EN-Revision: none
.. _zend.text.table.introduction:

Zend_Text_Table
===============

``Zend_Text_Table`` est un composant pour créer à la volée des tables de type texte avec différents
décorateurs. Ceci peut être utile, si vous souhaitez soit envoyé des données structurées dans des emails
textuels, qui sont sont utilisés pour leurs polices mono-espacés, ou pour afficher des informations sous forme de
tableaux dans une application CLI. ``Zend_Text_Table`` supporte les colonnes multi-lignes, les fusions de colonnes
ainsi que l'alignement.

.. note::

   **Encodage**

   ``Zend_Text_Table`` suppose que vos chaînes sont encodés en UTF-8 par défaut. Si ce n'est pas le cas, vous
   pouvez fournir l'encodage en tant que paramètre du constructeur ou à la méthode *setContent* de
   ``Zend_Text_Table_Column``. Alternativement si vous avez un encodage différent dans le processus complet, vous
   pouvez définir l'encodage d'entrée ("input") standard avec ``Zend_Text_Table::setInputCharset($charset)``.
   Dans le cas où vous avez besoin d'un autre encodage pour la sortie ("output") de la table, vous pouvez le
   paramétrer avec ``Zend_Text_Table::setOutputCharset($charset)``.

Un objet ``Zend_Text_Table`` consiste en des lignes, qui contiennent des colonnes, représenté par
``Zend_Text_Table_Row`` et ``Zend_Text_Table_Column``. Lors de la création d'une table, vous pouvez fournir un
tableau avec les options pour la table. Celles-ci sont :

   - *columnWidths* (obligatoire) : un tableau définissant toutes les largeurs de colonnes en nombre de
     caractères.

   - *decorator*: le décorateur à utiliser pour les bordures de la table. Le défaut est *unicode*, mais vous
     pouvez aussi spécifier *ascii* ou fournir une instance d'un objet décorateur personnalisé.

   - *padding*: le remplissage gauche et droit de la colonne en caractères. Le remplissage par défaut est zéro.

   - *AutoSeparate*: la manière comment les lignes sont séparées avec des lignes horizontales. Par défaut, il y
     a une séparation entre chaque ligne. Ceci est défini entant que bitmask contenant une ou plus des constantes
     de ``Zend_Text_Table`` suivantes :

        - ``Zend_Text_Table::AUTO_SEPARATE_NONE``

        - ``Zend_Text_Table::AUTO_SEPARATE_HEADER``

        - ``Zend_Text_Table::AUTO_SEPARATE_FOOTER``

        - ``Zend_Text_Table::AUTO_SEPARATE_ALL``

     Où "header" est toujours la première ligne, et "footer" est toujours la dernière.



Les lignes sont simplement ajoutées à la table en créant une nouvelle instance de ``Zend_Text_Table_Row``, et en
l'ajoutant à la table via la méthode *appendRow*. Les lignes elle-même n'ont pas d'options. Vous pouvez aussi
fournir un tableau directement à la méthode *appendRow*, qui le convertira automatiquement en des objets *Row*,
contenant les multiples objets *Column*.

De la même manière vous pouvez ajouter les colonnes aux lignes. Créez un instance de ``Zend_Text_Table_Column``
et ensuite paramétrer les options de colonnes soit dans le constructeur ou plus tard par les méthodes *set**. Le
premier paramètre est le contenu de la colonne qui peut avoir des lignes multiples, elles sont dans le meilleur
des cas séparées par le caractère *\n*. Le second paramètre définit l'alignement, qui est *left* par défaut
et peut être l'une des constantes de la classe ``Zend_Text_Table_Column``:

   - ``ALIGN_LEFT``

   - ``ALIGN_CENTER``

   - ``ALIGN_RIGHT``

Le troisième paramètre est le colspan ("fusion") de la colonne. Par exemple, quand vous choisissez "2 comme
colspan, la colonne va déborder sur deux colonnes de la table. Le dernier paramètre définit l'encodage du
contenu, qui peut être fourni, si le contenu n'est ni de l'ASCII ni de l'UTF-8. Pour ajouter la colonne à la
ligne, vous appelez simplement *appendColumn* dans votre objet *Row* avec l'objet *Column* en tant que paramètre.
Alternativement vous pouvez directement fournir la chaîne à la méthode *appendColumn*.

Pour finalement effectuer le rendu de la table, vous pouvez soit utiliser la méthode *render* de la table, ou
utilisez la méthode magique *__toString* en faisant *echo $table;* ou *$tableString = (string) $table*.

.. _zend.text.table.example.using:

.. rubric:: Utilisation de Zend_Text_Table

Cet exemple illustre un utilisation basique de ``Zend_Text_Table`` pour créer une table simple :

.. code-block:: php
   :linenos:

   $table = new Zend_Text_Table(array('columnWidths' => array(10, 20)));

   // Either simple
   $table->appendRow(array('Zend', 'Framework'));

   // Or verbose
   $row = new Zend_Text_Table_Row();

   $row->appendColumn(new Zend_Text_Table_Column('Zend'));
   $row->appendColumn(new Zend_Text_Table_Column('Framework'));

   $table->appendRow($row);

   echo $table;

Ceci entraînera l'affichage suivant :

.. code-block:: text
   :linenos:

   ┌──────────┬────────────────────┐
   │Zend      │Framework           │
   └──────────┴────────────────────┘


