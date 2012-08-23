.. EN-Revision: none
.. _zend.view.helpers.initial.partial:

L'aide de vue Partial
=====================

L'aide de vue *Partial* est utilisée pour effectuer le rendu d'un modèle ("template") spécifique dans sa propre
portée de variable. L'utilisation principale est pour les fragments réutilisables de modèle avec lesquels vous
n'avez pas besoin de vous inquiéter des conflits de noms de variable. De plus, ils vous permettent de spécifier
les scripts de vue partiels dans des modules spécifiques.

Une soeur de l'aide *Partial*, l'aide de vue de *PartialLoop* vous permet de passer des données itératives, et
effectue un rendu partiel pour chaque élément.

.. note::

   **Compteur de PartialLoop**

   L'aide de vue *PartialLoop* assigne une variable à la vue nommée *partialCounter* qui fournit la position
   courante du tableau au script de vue. Ce qui permet simplement d'avoir des couleurs alternatives dans les lignes
   d'un tableau par exemple.

.. _zend.view.helpers.initial.partial.usage:

.. rubric:: Utilisation de base des Partials

L'utilisation de base des *Partials* est d'effectuer le rendu d'un fragment de modèle dans sa propre portée de
vue. Examinez le script partiel suivant :

.. code-block:: php
   :linenos:

   <!--partiel.phtml-->
   <ul>
       <li>De : <?php echo $this->escape($this->de) ?></li>
       <li>Sujet : <?php echo $this->escape($this->sujet) ?></li>
   </ul>

Vous l'appelleriez alors dans votre script de vue en utilisant ce qui suit :

.. code-block:: php
   :linenos:

   <?php echo $this->partial('partiel.phtml', array(
       'de' => 'Equipe Framework',
       'sujet' => 'vues partielles')); ?>

Qui vous retournerait :

.. code-block:: html
   :linenos:

   <ul>
       <li>De : Equipe Framework</li>
       <li>Sujet : vues partielles</li>
   </ul>

.. note::

   **Qu'est qu'un modèle ?**

   Un modèle utilisé avec l'aide de vue *Partial* peut être un des suivants :

   - **Tableaux ("array")**: si un tableau est fourni, il devrait être associatif, car ses paires de clé/valeur
     sont assignées à la vue avec les clés comme variables de vue.

   - **Objet implémentant la méthode toArray()**: si un objet est fourni et qu'il possède une méthode
     ``toArray()``, le résultat de ``toArray()`` sera assigné à la vue comme variable de vue.

   - **Objet standard**: tout autre objet assignera le résultat de ``object_get_vars()`` (essentiellement toutes
     les propriétés publiques de l'objet) à l'objet de vue.

   Si votre modèle est un objet, vous pouvez vouloir le fournir en tant qu'objet au script partiel, plutôt que de
   le sérialiser en un tableau de variables. Vous pouvez faire ceci en paramétrant la propriété "objectKey" de
   l'aide de vue approprié :

   .. code-block:: php
      :linenos:

      // Tell partial to pass objects as 'model' variable
      $view->partial()->setObjectKey('model');

      // Tell partial to pass objects from partialLoop as 'model' variable in final
      // partial view script:
      $view->partialLoop()->setObjectKey('model');

   Cette technique est particulièrement utile quand vous fournissez un ``Zend_Db_Table_Rowset``\ s à
   ``partialLoop()``, ainsi vous avez un accès complet à vos objets *Row* à l'intérieur de vos scripts de vue,
   permettant d'appeler des méthodes sur ceux-ci (comme récupérer des valeurs d'un *Row* parent ou dépendant).

.. _zend.view.helpers.initial.partial.partialloop:

.. rubric:: Utiliser PartialLoop pour effectuer le rendu d'éléments itératifs

Typiquement, vous voudrez employer des *Partials* dans une boucle, pour rendre le même fragment de contenu
plusieurs fois ; de cette façon vous pouvez mettre de grands blocs de contenu répété ou de logique complexe
d'affichage dans un endroit unique. Toutefois ceci a un impact d'exécution, car l'aide Partial doit être appelée
une fois par itération.

L'aide de vue *PartialLoop* résout ce problème. Elle vous permet de fournir un élément itérable (tableau ou
objet implémentant *Iterator*) comme modèle. Elle réitère alors au-dessus de celui-ci en fournissant les
éléments au script partiel. Les éléments dans l'itérateur peuvent être n'importe quel modèle que l'aide de
vue *Partial* permet (cf. ci-dessus).

Considérons le script partiel suivant :

.. code-block:: php
   :linenos:

   <!--partialLoop.phtml-->
       <dt><?php echo $this->key ?></dt>
       <dd><?php echo $this->value ?></dd>

Et le "modèle" suivant :

.. code-block:: php
   :linenos:

   $model = array(
       array('key' => 'Mammifère', 'value' => 'Chameau'),
       array('key' => 'Oiseau',    'value' => 'Pingouin'),
       array('key' => 'Reptile',   'value' => 'Asp'),
       array('key' => 'Poisson',   'value' => 'Flounder')
   );

Dans votre script de vue, vous pouvez maintenant appeler l'aide *PartialLoop*:

.. code-block:: php
   :linenos:

   <dl>
   <?php echo $this->partialLoop('partialLoop.phtml', $model) ?>
   </dl>

.. code-block:: html
   :linenos:

   <dl>
       <dt>Mammifère</dt>
       <dd>Chameau</dd>

       <dt>Oiseau</dt>
       <dd>Pingouin</dd>

       <dt>Reptile</dt>
       <dd>Asp</dd>

       <dt>Poisson</dt>
       <dd>Flounder</dd>

   </dl>

.. _zend.view.helpers.initial.partial.modules:

.. rubric:: Effectuer le rendu partiel dans des modules différents

Parfois un partiel existera dans un module différent. Si vous connaissez le nom du module, vous pouvez le fournir
comme deuxième argument à ``partial()`` ou à ``partialLoop()``, en déplaçant l'argument ``$model`` à la
troisième position.

Par exemple, s'il y a un gestionnaire de page partiel que vous souhaitez utiliser et qui est dans le module
"liste", vous pourriez le saisir comme suit :

.. code-block:: php
   :linenos:

   <?php echo $this->partial('pager.phtml', 'liste', $pagerData) ?>

De cette façon, vous pouvez réutiliser des partiels créés spécifiquement pour d'autre modules. Ceci dit, il
est probablement une meilleure pratique de mettre des partiels réutilisables dans des dossiers partagés de script
de vue.


