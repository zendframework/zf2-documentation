.. _zend.view.helpers.initial.headmeta:

L'aide de vue HeadMeta
======================

L'élément HTML *<meta>* est utilisé pour fournir des métadonnées concernant votre document HTML - typiquement,
les mots-clés, l'encodage du document, les directives de mise en cache, etc. Les balises de métadonnées peuvent
être soit de type "http-equiv" ou "name", doivent contenir un attribut "content" et peuvent avoir aussi un
attribut modificateur "lang" ou "scheme".

L'aide de vue *HeadMeta* supporte les méthodes suivantes pour le paramétrage et l'ajout de métadonnées :

- ``appendName($keyValue, $content, $conditionalName)``

- *offsetSetName($index, $keyValue, $content, $conditionalName)*

- ``prependName($keyValue, $content, $conditionalName)``

- ``setName($keyValue, $content, $modifiers)``

- *appendHttpEquiv($keyValue, $content, $conditionalHttpEquiv)*

- *offsetSetHttpEquiv($index, $keyValue, $content, $conditionalHttpEquiv)*

- *prependHttpEquiv($keyValue, $content, $conditionalHttpEquiv)*

- ``setHttpEquiv($keyValue, $content, $modifiers)``

Le paramètre ``$keyValue`` est utilisé pour définir une valeur pour la clé "name" ou "http-equiv" ;
``$content`` est la valeur pour la clé "content", et ``$modifiers`` est un tableau associatif optionel qui peut
contenir les clés "lang" et/ou "scheme".

Vous pouvez aussi spécifier les métadonnées en utilisant la méthode ``headMeta()`` qui a la signature suivante
: *headMeta($content, $keyValue, $keyType = 'name', $modifiers = array(), $placement = 'APPEND')*. ``$keyValue``
est le contenu de la clé spécifiée dans ``$keyType``, qui peut être "name" ou "http-equiv". ``$placement`` peut
être soit "SET" (efface toutes les valeurs sauvegardées précédentes), soit "APPEND" (ajout en fin de pile),
soit "PREPEND" (ajout en début de pile).

*HeadMeta* surcharge chacune des méthodes ``append()``, ``offsetSet()``, ``prepend()``, et ``set()``, pour imposer
l'utilisation des méthodes spéciales énumérées ci-dessus. En interne, il stocke chaque élément sous la forme
d'un *stdClass*, qui peut ensuite être sérialiser grâce à la méthode ``itemToString()``. Ceci vous permet de
réaliser des contrôles sur les éléments de la pile, et optionnellement de modifier ces éléments simplement en
modifiant l'objet retourné.

L'aide de vue *HeadMeta* est une implémentation concrète de l'aide :ref:`Placeholder
<zend.view.helpers.initial.placeholder>`.

.. _zend.view.helpers.initial.headmeta.basicusage:

.. rubric:: Utilisation basique de l'aide HeadMeta

Vous pouvez spécifier une nouvelle métadonnée à n'importe quel moment. Typiquement, vous pouvez spécifier les
règles de mise en cache côté client ou les mots clés SEO (Search Engine Optimization : pour l'optimisation des
moteurs de recherche).

Par exemple, si vous souhaitez spécifier des mots clés SEO, vous devez créer une métadonnée de type "name"
ayant pour nom "keywords" et pour contenu les mots clés que vous souhaitez associer à votre page :

.. code-block:: php
   :linenos:

   // paramètrage des mots clés
   $this->headMeta()->appendName('keywords', 'framework, PHP, productivité');

Si vous souhaitez paramètrer des règles de mise en cache côté client, vous devez créer une métadonnée de
type "http-equiv" avec les règles que vous souhaitez imposer :

.. code-block:: php
   :linenos:

   // désactiver la mise en cache côté client
   $this->headMeta()->appendHttpEquiv('expires',
                                      'Wed, 26 Feb 1997 08:21:57 GMT')
                    ->appendHttpEquiv('pragma', 'no-cache')
                    ->appendHttpEquiv('Cache-Control', 'no-cache');

Une autre utilisation habituelle des métadonnées est le réglage du type de contenu ("content type"), de
l'encodage, et le langage :

.. code-block:: php
   :linenos:

   // régler le type de contenu et l'encodage
   $this->headMeta()->appendHttpEquiv('Content-Type', 'text/html; charset=UTF-8')
                    ->appendHttpEquiv('Content-Language', 'fr-FR');

Si vous proposez un document *HTML5*, vous pouvez fournir l'encodage de cette manière :

.. code-block:: php
   :linenos:

   // régler l'encodage en HTML5
   $this->headMeta()->setCharset('UTF-8');
   // donnera <meta charset="UTF-8">

Et comme exemple final, une manière simple d'afficher un message de transition avant une redirection est
d'utiliser une métadonnée "refresh" :

.. code-block:: php
   :linenos:

   // paramètrer une métadonnée refresh pour 3 secondes
   // avant une nouvel URL :
   $this->headMeta()->appendHttpEquiv('Refresh',
                                      '3;URL=http://www.some.org/some.html');

Quand vous êtes prêts à placer vos métadonnées dans votre script de disposition, réalisez un "*echo*" de
l'aide :

.. code-block:: php
   :linenos:

   <?php echo $this->headMeta() ?>


