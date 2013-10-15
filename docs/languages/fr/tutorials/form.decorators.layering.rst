.. EN-Revision: none
.. _learning.form.decorators.layering:

Chainer les décorateurs
=======================

Si vous avez bien suivi :ref:`la section précédente <learning.form.decorators.simplest>`, vous avez pu remarquer
que la méthode ``render()`` prend un argument, ``$content``. Il est de type chaîne de caractères. ``render()``
va utiliser cette chaîne et décider de la remplacer, de rajouter ou de faire précéder du contenu à celle-ci.
Ceci permet de chaîner les décorateurs -- ce qui ouvre des possibilités de créer ses propres décorateurs qui
vont rendre chacun une petite partie des données d'un élément -- c'est la chaîne complète de décorateurs qui
déterminera le rendu final réel de l'élément.

Voyons voir en pratique comment ça fonctionne.

Pour la plupart des éléments, les décorateurs suivants sont chargés par défaut :

- ``ViewHelper``\  : utilise une aide de vue pour rendre l'élément balise de formulaire à proprement parlé.

- ``Errors``\  : utilise l'aide de vue ``FormErrors`` pour afficher les erreurs de validation éventuelles.

- ``Description``\  : utilise l'aide de vue ``FormNote`` afin de rendre la description éventuelle de l'élément.

- ``HtmlTag``\  : encapsule les trois objets ci-dessus dans un tag *<dd>*.

- ``Label``\  : rend l'intitulé de l'élément en utilisant l'aide de vue ``FormLabel`` (et en encapsulant le
  tout dans un tag *<dt>*).

Notez bien que chaque décorateur n'a qu'une petite tâche particulière et opère sur une partie spécifique des
données de l'élément auquel il est rattaché, le décorateur ``Errors`` récupère les messages de validation de
l'élément et effectue leur rendu, le décorateur ``Label`` rend simplement le libellé. Ceci fait que chaque
décorateur est très petit, réutilisable, et surtout testable.

Cet argument ``$content`` vient de là aussi : chaque décorateur travaille avec sa méthode ``render()`` sur un
contenu (généralement généré par le décorateur immédiatement précédent dans la pile globale) et embellit
ce contenu en lui rajoutant ou en lui faisant précéder des informations. Il peut aussi remplacer totalement son
contenu.

Ainsi, pensez au mécanisme des décorateurs comme la conception d'un oignon de l'intérieur vers l'extérieur.

Voyons voir un exemple, le même que celui :ref:`de la section précédente <learning.form.decorators.simplest>`\
 :

.. code-block:: php
   :linenos:

   class My_Decorator_SimpleInput extends Zend\Form\Decorator\Abstract
   {
       protected $_format = '<label for="%s">%s</label>'
                          . '<input id="%s" name="%s" type="text" value="%s"/>';

       public function render($content)
       {
           $element = $this->getElement();
           $name    = htmlentities($element->getFullyQualifiedName());
           $label   = htmlentities($element->getLabel());
           $id      = htmlentities($element->getId());
           $value   = htmlentities($element->getValue());

           $markup  = sprintf($this->_format, $id, $label, $id, $name, $value);
           return $markup;
       }
   }

Supprimons la fonctionnalité libellé (label) et créons un décorateur spécifique pour lui.

.. code-block:: php
   :linenos:

   class My_Decorator_SimpleInput extends Zend\Form\Decorator\Abstract
   {
       protected $_format = '<input id="%s" name="%s" type="text" value="%s"/>';

       public function render($content)
       {
           $element = $this->getElement();
           $name    = htmlentities($element->getFullyQualifiedName());
           $id      = htmlentities($element->getId());
           $value   = htmlentities($element->getValue());

           $markup  = sprintf($this->_format, $id, $name, $value);
           return $markup;
       }
   }

   class My_Decorator_SimpleLabel extends Zend\Form\Decorator\Abstract
   {
       protected $_format = '<label for="%s">%s</label>';

       public function render($content)
       {
           $element = $this->getElement();
           $id      = htmlentities($element->getId());
           $label   = htmlentities($element->getLabel());

           $markup = sprint($this->_format, $id, $label);
           return $markup;
       }
   }

Ok, ca semble bon mais il y a un problème : le dernier décorateur va l'emporter. Vous allez vous retrouver avec
comme seul rendu, celui du dernier décorateur.

Pour faire fonctionner le tout comme il se doit, concaténez simplement le contenu précédent ``$content`` avec le
contenu généré :

.. code-block:: php
   :linenos:

   return $content . $markup;

Le problème avec cette approche est que vous ne pouvez pas choisir où se place le contenu du décorateur en
question. Heureusement, un mécanisme standard existe ; ``Zend\Form\Decorator\Abstract`` possède le concept de
place et définit des constantes pour le régler. Aussi, il permet de préciser un séparateur à placer entre les
2. Voyons celà :

.. code-block:: php
   :linenos:

   class My_Decorator_SimpleInput extends Zend\Form\Decorator\Abstract
   {
       protected $_format = '<input id="%s" name="%s" type="text" value="%s"/>';

       public function render($content)
       {
           $element = $this->getElement();
           $name    = htmlentities($element->getFullyQualifiedName());
           $id      = htmlentities($element->getId());
           $value   = htmlentities($element->getValue());

           $markup  = sprintf($this->_format, $id, $name, $value);

           $placement = $this->getPlacement();
           $separator = $this->getSeparator();
           switch ($placement) {
               case self::PREPEND:
                   return $markup . $separator . $content;
               case self::APPEND:
               default:
                   return $content . $separator . $markup;
           }
       }
   }

   class My_Decorator_SimpleLabel extends Zend\Form\Decorator\Abstract
   {
       protected $_format = '<label for="%s">%s</label>';

       public function render($content)
       {
           $element = $this->getElement();
           $id      = htmlentities($element->getId());
           $label   = htmlentities($element->getLabel());

           $markup = sprintf($this->_format, $id, $label);

           $placement = $this->getPlacement();
           $separator = $this->getSeparator();
           switch ($placement) {
               case self::APPEND:
                   return $markup . $separator . $content;
               case self::PREPEND:
               default:
                   return $content . $separator . $markup;
           }
       }
   }

Notez que dans l'exemple ci-dessus, nous intervertissons les comportements par défaut avec append et prepend.

Créons dès lors un élément de formulaire qui va utiliser tout celà :

.. code-block:: php
   :linenos:

   $element = new Zend\Form\Element('foo', array(
       'label'      => 'Foo',
       'belongsTo'  => 'bar',
       'value'      => 'test',
       'prefixPath' => array('decorator' => array(
           'My_Decorator' => 'path/to/decorators/',
       )),
       'decorators' => array(
           'SimpleInput',
           'SimpleLabel',
       ),
   ));

Comment ça fonctionne ? et bien nous appelons ``render()``, l'élément va alors commencer une itération sur
tous ses décorateurs, en appelant ``render()`` sur chacun. Il va passer une chaîne vide comme contenu pour le
premier décorateur, et le rendu de chaque décorateur va servir de contenu pour le suivant, ainsi de suite :

- Contenu initial : chaîne vide: ''.

- Chaîne vide ('') est passée au décorateur ``SimpleInput``, qui génère un tag de formulaire de type input
  qu'il ajoute à la chaîne vide : **<input id="bar-foo" name="bar[foo]" type="text" value="test"/>**.

- Ce contenu généré est alors passé comme contenu original pour le décorateur ``SimpleLabel`` qui génère un
  libellé et le place avant le contenu original avec comme séparateur ``PHP_EOL``, ce qui donne : **<label
  for="bar-foo">\n<input id="bar-foo" name="bar[foo]" type="text" value="test"/>**.

Mais attendez une minute ! Et si nous voulions que le libellé soit rendu après le tag de formulaire pour une
raison quelconque ? Vous souvenez-vous de l'option "placement" ? Vous pouvez la préciser comme option de
décorateur, et le plus simple est alors de la passer à la création de l'élément :

.. code-block:: php
   :linenos:

   $element = new Zend\Form\Element('foo', array(
       'label'      => 'Foo',
       'belongsTo'  => 'bar',
       'value'      => 'test',
       'prefixPath' => array('decorator' => array(
           'My_Decorator' => 'path/to/decorators/',
       )),
       'decorators' => array(
           'SimpleInput'
           array('SimpleLabel', array('placement' => 'append')),
       ),
   ));

Notez que passer des options vous oblige à préciser le nom du décorateur dans un tableau en tant que premier
élément, le deuxième élément est un tableau d'options.

Le code ci-dessus propose un rendu : **<input id="bar-foo" name="bar[foo]" type="text" value="test"/>\n<label
for="bar-foo">**.

Grâce à cette technique, vous pouvez avoir plusieurs décorateurs dont chacun s'occupe de rendre une petite
partie d'un élément ; et c'est en utilisant plusieurs décorateurs et en les chaînant correctement que vous
obtiendrez un rendu complet : l'oignon final.

Avantages et inconvénients d'une telle technique, commençons par les inconvénients :

- C'est plus complexe qu'un rendu simple. Vous devez faire attention à chaque décorateur mais en plus à l'ordre
  dans lequel ils agissent.

- Ça consomme plus de ressources. Plus de décorateurs, plus d'objets, multipliés par le nombre d'éléments dans
  un formulaire et la consommation en ressources augmente. La mise en cache peut aider.

Les avantages sont :

- Réutilisabilité. Vous pouvez créer des décorateurs complètement réutilisables car vous ne vous souciez pas
  du rendu final, mais de chaque petit bout de rendu.

- Fléxibilité. Il est en théorie possible d'arriver au rendu final voulu très exactement, et ceci avec une
  petite poignée de décorateurs.

Les exemples ci-dessus montrent l'utilisation de décorateurs au sein même d'un objet ``Zend_Form`` et nous avons
vu comment les décorateurs jouent les uns avec les autres pour arriver au rendu final. Afin de pouvoir les
utiliser de manière indépendante, a version 1.7 a ajouté des méthodes flexibles rendant les formulaires
ressemblant au style Rail. Nous allons nous pencher sur ce fait dans la section suivante.


