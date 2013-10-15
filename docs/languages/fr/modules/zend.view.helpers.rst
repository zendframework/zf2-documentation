.. EN-Revision: none
.. _zend.view.helpers:

Aides de vue
============

Dans vos scripts de vue, il est souvent nécessaire d'effectuer certaines actions complexes encore et encore : par
exemple, formater une date, générer des éléments de formulaire, afficher des liens d'action. Vous pouvez
utiliser des classes d'aide pour effectuer ce genre de tâches.

Une aide est simplement une classe. Par exemple, nous voulons une aide nommée "foobar". Par défaut, la classe est
préfixée avec *"Zend\View\Helper\"* (vous pouvez spécifier un préfixe personnalisé en paramétrant votre
chemin d'aide), et le dernier segment du nom de classe est le nom de l'aide ; ce segment peut être avec des
CaracteresMajuscules ; le nom complet de la classe est alors : ``Zend\View\Helper\FooBar``. Cette classe doit
contenir au moins une méthode, nommée comme l'aide avec la notationCamel : ``fooBar()``.

.. note::

   **Surveillez la casse**

   Les noms des aides sont toujours en notationCamel, c'est-à-dire qu'ils ne commencent pas avec un caractère
   majuscule. Le nom de classe elle-même peut être en casseMélangée, mais la méthode qui est exécutée est en
   notationCamel.

Pour utiliser une aide dans votre script de vue, appelez la en utilisant *$this->nomAide()*. Dans les coulisses,
``Zend_View`` va charger la classe ``Zend\View\Helper\NomAide``, créer une instance de cet objet, et appeler sa
méthode ``nomAide()``. L'instance de l'objet est persistante dans l'instance de ``Zend_View``, et est réutilisée
pour tous les appels futurs à *$this->nomAide()*.

.. _zend.view.helpers.initial:

Aides initiales
---------------

``Zend_View`` fournit avec un jeu initial de classes d'aides, la plupart est liée à la génération d'éléments
de formulaire. Chacune affiche et échappe l'élément automatiquement. De plus, il existe des aides pour créer
des *URL*\ s sur la base de routes et des listes HTML, de la même manière que l'on déclarerait des variables.
Les aides actuellement incluses sont :

- ``declareVars()``: initialement prévu pour être utilisé avec ``strictVars()``, cette aide peut être utilisée
  pour déclarer les variables de modèle ("template") qui sont (ou pas) déjà déclarées dans l'objet de vue, ou
  pour gérer des valeurs par défaut. Les tableaux passés comme arguments à la méthode seront utilisés pour
  paramétrer des valeurs par défaut ; sinon, si la variable n'existe pas, on lui affecte une chaîne vide.

- ``fieldset($name, $content, $attribs)``: crée un ensemble de champs *XHTML*. Si ``$attribs`` contient une clé
  "legend", cette valeur sera utilisée comme légende du fieldset. Le fieldset entourera le contenu ``$content``
  tel qu'il aura été fourni à l'aide.

- ``form($name, $attribs, $content)``: génère un formulaire *XHTML*. Tous les éléments ``$attribs`` sont
  échappés et rendus sous la forme d'attributs de la balise "form". Si ``$content`` est présent et n'est pas un
  booléen valant ``FALSE``, alors ce contenu est rendu à l'intérieur des balises "form" ; si ``$content`` est un
  booléen valant ``FALSE`` (par défaut), seul la balise ouvrante "form" est générée.

- ``formButton($name, $value, $attribs)``: crée un élément <button />.

- *formCheckbox($name, $value, $attribs, $options):* crée un élément <input type="checkbox" />.

  Par défaut, quand aucune ``$value`` n'est fournie et qu'aucune ``$options`` n'est présente, alors "0" est
  considéré comme la valeur non cochée et "1" comme la valeur cochée. Si une ``$value`` est fournie, mais
  qu'aucune ``$options`` n'est présente, l'état coché est considéré égal à la ``$value`` fournie.

  ``$options`` devrait être un tableau. Si ce tableau est indexé, la première valeur est la valeur cochée, la
  seconde est la valeur non cochée ; et tout autre valeur est ignorée. Vous pouvez aussi passer un tableau
  associatif avec les clés "*checked*" et "*unChecked*".

  Si ``$options`` est fourni, et que ``$value`` correspond à la valeur cochée, alors l'élément sera marqué
  comme coché. Vous pouvez aussi marquer l'élément comme coché ou décoché en passant une valeur booléenne à
  l'attribut "*checked*".

  Ceci pourra sûrement être plus explicite avec quelques exemples :

  .. code-block:: php
     :linenos:

     // "1" et "0" en tant qu'options cochée/décochée ; cochée
     echo $this->formCheckbox('foo');

     // "1" et "0" en tant qu'options cochée/décochée ; cochée
     echo $this->formCheckbox('foo', null, array('checked' => true));

     // "bar" et "0" en tant qu'options cochée/décochée ; décochée
     echo $this->formCheckbox('foo', 'bar');

     // "bar" et "0" en tant qu'options cochée/décochée ; cochée
     echo $this->formCheckbox('foo', 'bar', array('checked' => true));

     // "bar" et "baz" en tant qu'options cochée/décochée ; décochée
     echo $this->formCheckbox('foo', null, null, array('bar', 'baz'));

     // "bar" et "baz" en tant qu'options cochée/décochée ; décochée
     echo $this->formCheckbox('foo', null, null, array(
         'checked' => 'bar',
         'unChecked' => 'baz'
     ));

     // "bar" et "baz" en tant qu'options cochée/décochée ; cochée
     echo $this->formCheckbox('foo', 'bar', null, array('bar', 'baz'));
     echo $this->formCheckbox('foo',
                              null,
                              array('checked' => true),
                              array('bar', 'baz'));

     // "bar" et "baz" en tant qu'options cochée/décochée ; décochée
     echo $this->formCheckbox('foo', 'baz', null, array('bar', 'baz'));
     echo $this->formCheckbox('foo',
                              null,
                              array('checked' => false),
                              array('bar', 'baz'));

  Dans tous les cas, la balise est précédée d'un élément masqué ("hidden") avec la valeur de l'état
  décoché ; ainsi, si la valeur est décochée, vous aurez toujours une valeur valide retournée par votre
  formulaire.

- ``formErrors($errors, $options)``: génère une liste non ordonnée *XHTML* pour montrer des erreurs. ``$errors``
  peut être une chaîne de caractères ou un tableau de chaînes ; ``$options`` peut être tout attribut que vous
  pourriez vouloir placer dans la balise ouvrante de la liste.

  Vous pouvez spécifier des éléments ouvrants, fermants et des séparateurs de contenu alternatifs lors du rendu
  des erreurs en appelant les différentes méthodes suivantes de l'aide :

  - ``setElementStart($string)``; par défaut vaut "<ul class="errors"%s"><li>", où *%s* est remplacé avec les
    attributs spécifiés dans ``$options``.

  - ``setElementSeparator($string)``; par défaut vaut "</li><li>".

  - ``setElementEnd($string)``; par défaut vaut "</li></ul>".

- ``formFile($name, $attribs)``: crée un élément <input type="file" />.

- ``formHidden($name, $value, $attribs)``: crée un élément <input type="hidden" />.

- ``formLabel($name, $value, $attribs)``: crée un élément <label>, en réglant l'attribut *for* avec ``$name``,
  et le texte du label avec ``$value``. Si *disable* est fourni via *attribs*, rien n'est retourné.

- *formMultiCheckbox($name, $value, $attribs, $options, $listsep)*: crée une liste de cases à cocher.
  ``$options`` devrait être un tableau associatif, avec une profondeur arbitraire. ``$value`` peut être une
  valeur unique ou un tableau de valeurs sélectionnées qui correspondent aux clés du tableau ``$options``.
  ``$listsep`` est un séparateur HTML ("<br />") par défaut. Par défaut, cet élément est traité comme un
  tableau ; toutes les cases à cocher partagent le même nom, et sont soumises sous la forme d'un tableau.

- ``formPassword($name, $value, $attribs)``: crée un élément <input type="password" />.

- ``formRadio($name, $value, $attribs, $options)``: crée une série d'éléments <input type="button" />, un pour
  chaque élément ``$options``. Dans le tableau ``$options``, la clé de l'élément est la valeur du radio, et la
  valeur de l'élément est l'étiquette du radio. La radio ``$value`` sera précochée pour vous.

- ``formReset($name, $value, $attribs)``: crée un élément <input type="reset" />.

- ``formSelect($name, $value, $attribs, $options)``: crée un bloc <select>...</select>, avec une <option> pour
  chaque élément ``$options``. Dans le tableau ``$options``, la clé de l'élément est la valeur de l'option, et
  la valeur de l'élément est son étiquette optionnelle. L'option (ou les options) ``$value`` sera (ou seront)
  présélectionnée(s) pour vous.

- ``formSubmit($name, $value, $attribs)``: crée un élément <input type="submit" />.

- ``formText($name, $value, $attribs)``: crée un élément <input type="text" />.

- ``formTextarea($name, $value, $attribs)``: crée un bloc <textarea>...</textarea>.

- ``url($urlOptions, $name, $reset)``: crée un *URL* basé sur une route nommée. ``$urlOptions`` doit être un
  tableau associatif avec des paires de clés/valeurs utilisées par une route particulière.

- ``htmlList($items, $ordered, $attribs, $escape)``: génère des listes ordonnées ou non basées sur les
  ``$items`` qui lui sont fournis. Si ``$items`` est un tableau multidimensionnel, une liste imbriquée sera
  construite. Si le paramètre ``$escape`` vaut ``TRUE`` (valeur par défaut), chaque élément sera échappé en
  utilisant le mécanisme d'échappement enregistré dans les objets de vue ; fournissez une valeur ``FALSE`` si
  vous voulez autoriser du balisage dans vos listes.

Les utiliser dans vos script de vue est très simple, voici un exemple. Notez que tout ce dont vous avez besoin,
c'est de les appeler; elles vont se charger et s'instancier elle-même si besoin est.

.. code-block:: php
   :linenos:

   <!--
   Dans votre script de vue, $this se réfère à l'instance de Zend_View.
   Partons du principe que vous avez déjà assigné une série d'options
   de sélection dans un tableau $pays =
   array('us' => 'Etats-Unis', 'fr' => 'France', 'de' => 'Allemagne').
   -->
   <form action="action.php" method="post">
       <p><label>Votre email :
           <?php echo $this->formText('email',
                                      'vous@exemple.fr',
                                      array('size' => 32)) ?>
       </label></p>
       <p><label>Votre pays :
           <?php echo $this->formSelect('country',
                                        'us',
                                        null,
                                        $this->pays) ?>
       </label></p>
       <p><label>??? Would you like to opt in ???
           <?php echo $this->formCheckbox('opt_in',
                                          'oui',
                                          null,
                                          array('oui', 'non')) ?>
       </label></p>
   </form>

La sortie résultante du script de vue ressemblera à ceci :

.. code-block:: php
   :linenos:

   <form action="action.php" method="post">
       <p><label>Votre email :
           <input type="text" name="email"
                  value="vous@exemple.fr" size="32" />
       </label></p>
       <p><label>Votre pays :
           <select name="country">
               <option value="us" selected="selected">Etats-Unis</option>
               <option value="fr">France</option>
               <option value="de">Allemagne</option>
           </select>
       </label></p>
       <p><label>??? Would you like to opt in ???
           <input type="hidden" name="opt_in" value="non" />
           <input type="checkbox" name="opt_in"
                  value="oui" checked="checked" />
       </label></p>
   </form>

.. include:: zend.view.helpers.action.rst
.. include:: zend.view.helpers.base-url.rst
.. include:: zend.view.helpers.cycle.rst
.. include:: zend.view.helpers.partial.rst
.. include:: zend.view.helpers.placeholder.rst
.. include:: zend.view.helpers.doctype.rst
.. include:: zend.view.helpers.head-link.rst
.. include:: zend.view.helpers.head-meta.rst
.. include:: zend.view.helpers.head-script.rst
.. include:: zend.view.helpers.head-style.rst
.. include:: zend.view.helpers.head-title.rst
.. include:: zend.view.helpers.html-object.rst
.. include:: zend.view.helpers.inline-script.rst
.. include:: zend.view.helpers.json.rst
.. include:: zend.view.helpers.navigation.rst
.. _zend.view.helpers.paths:

Chemin des aides
----------------

Comme pour les scripts de vue, votre contrôleur peut spécifier une pile de chemins dans lesquels ``Zend_View``
cherchera les classes d'aides. Par défaut, ``Zend_View`` cherche dans "Zend/View/Helper/\*". Vous pouvez dire à
``Zend_View`` de regarder dans d'autres chemins en utilisant les méthodes ``setHelperPath()`` et
``addHelperPath()``. De plus, vous pouvez indiquer un préfixe de classe pour utiliser les aides dans le
répertoire fourni, et permettre de donner des espaces de noms à vos classes d'aide. Par défaut, si aucun
préfixe n'est fourni, "Zend\View\Helper\_" est utilisé.

.. code-block:: php
   :linenos:

   $view = new Zend\View\View();
   $view->setHelperPath('/chemin/vers/plus/de/classes/d-aides',
                        'Ma_View_Helper');

En fait, vous pouvez "empiler" les chemins en utilisant la méthode ``addHelperPath()``. Comme vous ajoutez des
chemins dans la pile, ``Zend_View`` va regarder dans le chemin le plus récemment ajouté, pour inclure la classe
d'aide. Cela vous permet d'ajouter (ou bien de redéfinir) la distribution initiale des aides, avec vos propres
aides personnalisées.

.. code-block:: php
   :linenos:

   $view = new Zend\View\View();

   // Ajoute /chemin/vers/des/aides avec le préfixe
   // de classe 'Ma_View_Helper'
   $view->addHelperPath('/chemin/vers/des/aides',
                        'Ma_View_Helper');
   // Ajoute /autre/chemin/vers/des/aides avec le préfixe
   // de classe 'Votre_View_Helper'
   $view->addHelperPath('/autre/chemin/vers/des/aides',
                        'Votre_View_Helper');

   // maintenant, lorsque vous appelerez $this->helperName(), Zend_View
   // va rechercher en premier /autre/chemin/vers/des/aides/HelperName.php
   // en utilisant la classe "Votre_View_Helper_HelperName", et ensuite
   // dans /chemin/vers/des/aides/HelperName.php en utilisant la classe
   // "Ma_View_Helper_HelperName", et finalement dans
   // Zend/View/Helpers/HelperName.php en utilisant la classe
   // "Zend\View\Helper\HelperName"

.. _zend.view.helpers.custom:

Écrire des aides personnalisées
-------------------------------

Écrire des aides personnalisées est facile, vous devez juste suivre ces règles :

- Bien qu'il ne soit pas strictement nécessaire, il est recommandé soit d'implémenter
  ``Zend\View\Helper\Interface`` ou d'étendre ``Zend\View\Helper\Abstract`` quand vous créez vos aides. Introduit
  en 1.6.0, ceux-ci définissent la méthode ``setView()``; cependant, dans les prochaines releases, nous
  prévoyons d'implémenter un motif de conception Stratégie qui permettra de simplifier en grande partie le
  schéma de nomination détaillé ci-dessous. Contruire sur ces bases à partir de maintenant vous aidera pour vos
  codes futurs.

- Le nom de la classe doit, au minimum, se terminer avec le nom de l'aide en utilisant une notation en
  casseMélangée. Par exemple, si vous écrivez une aide appelée "actionSpeciale", le nom de la classe doit être
  au minimum "ActionSpeciale". Vous devriez donner au nom de la classe un préfixe, et il est recommandé
  d'utiliser "Ma_View_Helper" comme partie de ce préfixe : "Ma_View_Helper_ActionSpeciale". (Vous devez alors
  fournir le préfixe, avec ou sans le tiret bas, à ``addHelperPath()`` ou à ``setHelperPath()``).

- La classe doit avoir une méthode publique dont le nom correspond au nom de l'aide ; c'est la méthode qui sera
  appelée quand votre template appellera *$this->actionSpeciale()*. Dans notre exemple *$this->actionSpeciale()*,
  la déclaration de méthode requise serait *public function actionSpeciale()*.

- En général, la classe ne devrait pas afficher directement les données (via *echo* ou *print*). Elle devrait
  retourner les valeurs pour être ensuite affichées. Les valeurs retournées devrait être échappées de façon
  appropriées.

- La classe doit être dans un fichier ayant le même nom que la méthode d'aide. Si on utilise la méthode
  ``actionSpeciale()``, le fichier devra être nommé "ActionSpeciale.php"

Placez le fichier de classe d'aide quelque part dans la pile des chemins d'aide, et ``Zend_View`` le chargera,
l'instanciera, le rendra persistant, et l'exécutera automatiquement pour vous.

Voici un exemple de fichier "ActionSpeciale.php" :

.. code-block:: php
   :linenos:

   class Ma_View_Helper_ActionSpeciale
   {
       protected $_count = 0;
       public function actionSpeciale()
       {
           $this->_count++;
           $output = "J'ai vu 'The Big Lebowsky' {$this->_count} fois.";
           return htmlspecialchars($output);
       }
   }

Ensuite, dans un script de vue, vous pouvez appeler l'aide *ActionSpeciale* autant de fois que vous le souhaitez ;
elle sera instanciée une fois, et rendue persistante pendant toute la vie de l'instance de ``Zend_View``.

.. code-block:: php
   :linenos:

   // rappelez vous, $this se réfère à l'instance de Zend_View
   echo $this->actionSpeciale();
   echo $this->actionSpeciale();
   echo $this->actionSpeciale();

La sortie pourrait alors ressembler à ceci :

.. code-block:: php
   :linenos:

   J'ai vu 'The Big Lebowsky' 1 fois.
   J'ai vu 'The Big Lebowsky' 2 fois.
   J'ai vu 'The Big Lebowsky' 3 fois.

Quelquefois vous devez accéder à l'objet ``Zend_View`` appelant - par exemple, si vous devez utiliser l'encodage
enregistré ou voulez effectuer le rendu d'un autre script de vue comme une sous partie de votre aide. Pour avoir
accès à votre objet de vue, votre classe d'aide doit avoir une méthode ``setView($view)``, comme ceci :

.. code-block:: php
   :linenos:

   class Ma_View_Helper_ScriptPath
   {
       public $view;

       public function setView(Zend\View\Interface $view)
       {
           $this->view = $view;
       }

       public function scriptPath($script)
       {
           return $this->view->getScriptPath($script);
       }
   }

Si votre classe d'aide a une méthode ``setView()``, elle sera appelée quand votre classe sera instanciée la
première fois et fournira l'objet de la vue courante. Il est de votre responsabilité de maintenir la persistance
de l'objet dans votre classe, de même que de déterminer la façon dont il peut être accéder.

.. _zend.view.helpers.registering-concrete:

Registering Concrete Helpers
----------------------------

Sometimes it is convenient to instantiate a view helper, and then register it with the view. As of version 1.10.0,
this is now possible using the ``registerHelper()`` method, which expects two arguments: the helper object, and the
name by which it will be registered.

.. code-block:: php
   :linenos:

   $helper = new My_Helper_Foo();
   // ...do some configuration or dependency injection...

   $view->registerHelper($helper, 'foo');

If the helper has a ``setView()`` method, the view object will call this and inject itself into the helper on
registration.

.. note::

   **Helper name should match a method**

   The second argument to ``registerHelper()`` is the name of the helper. A corresponding method name should exist
   in the helper; otherwise, ``Zend_View`` will call a non-existent method when invoking the helper, raising a
   fatal PHP error.


