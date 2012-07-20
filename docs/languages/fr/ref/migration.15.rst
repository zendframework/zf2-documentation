.. _migration.15:

Zend Framework 1.5
==================

Lors de la migration d'un version précédente vers Zend Framework 1.5 ou plus récent vous devriez prendre note de
ce qui suit.

.. _migration.15.zend.controller:

Zend_Controller
---------------

Bien que la plupart des fonctionnalités de base demeurent les mêmes, et que toutes les fonctionnalités
documentées restent les mêmes, il existe une "fonctionnalité" particulière **non documentée** qui a changé.

Quand vous écrivez des *URL*\ s, la manière documentée d'écrire les noms d'action en notationCamel est
d'utiliser un séparateur de mot ; ceux ci sont "." ou "-" par défaut, mais ils peuvent être configurés dans le
distributeur. Le distributeur en interne transforme les noms d'action en minuscules, et utilise ces séparateurs de
mots pour ré-assembler la méthode d'action en utilisant la notationCamel. Cependant, comme les fonctions *PHP* ne
sont pas sensibles à la casse, vous **pouvez** toujours écrire les *URL*\ s en utilisant la notationCamel, et le
distributeur les résoudra de la même manière. Par exemple, "notation-camel" deviendra "notationCamelAction" dans
le distributeur, tandis que "notationCamel" deviendra "notationcamelAction" ; cependant, à cause de
l'insensibilité à la casse de *PHP*, dans les deux cas cela exécutera la même méthode.

Ceci pose des problèmes avec le *ViewRenderer* lors de la résolution des scripts de vue. La manière canonique et
documentée est que tous les séparateurs de mot sont convertis en tirets, et les mots en minuscules. Ceci crée un
lien sémantique entre les actions et les scripts de vue, et la normalisation s'assure que les scripts peuvent
être trouvés. Cependant, si l'action "notationCamel" est appelée et est résolue, le séparateur de mot n'est
pas pour autant présent, et le *ViewRenderer* tente de résoudre un emplacement différent - "notationcamel.phtml"
au lieu de "notation-camel.phtml".

Quelques développeurs se sont fondés sur ce "dispositif", qui n'a jamais été prévu. Plusieurs changements de
l'arbre 1.5.0, cependant, l'ont fait de sorte que le *ViewRenderer* ne résout plus ces chemins ; le lien
sémantique est maintenant imposé. A partir de maintenant, le distributeur impose la sensibilité à la casse dans
les noms d'action. Ceci veut dire que la référence vers vos actions dans l'URL en utilisant la notationCamel ne
résoudra plus les mêmes méthodes qu'en utilisant les séparateurs de mots (par ex., "notation-camel"). Ceci
entraîne qu'à partir de maintenant le *ViewRenderer* honorera seulement les actions en "mots-séparés" lors de
la résolution des scripts de vue.

Si vous constatez que vous comptiez sur ce "dispositif", vous avez plusieurs options :

- Meilleure option : renommez vos scripts de vue. Pour : compatibilité ascendante. Contre : si vous avez
  beaucoup de scripts de vue basés sur l'ancien, comportement fortuit, vous aurez beaucoup de renommage à faire.

- Seconde meilleure option : le *ViewRenderer* délégue maintenant la résolution des scripts de vue à
  ``Zend_Filter_Inflector``; vous pouvez modifier les règles de l'inflecteur pour ne plus séparer les mots d'une
  action avec un tiret :

  .. code-block:: php
     :linenos:

     $viewRenderer =
         Zend_Controller_Action_HelperBroker::getStaticHelper('viewRenderer');
     $inflector = $viewRenderer->getInflector();
     $inflector->setFilterRule(':action', array(
         new Zend_Filter_PregReplace(
             '#[^a-z0-9' . preg_quote(DIRECTORY_SEPARATOR, '#') . ']+#i',
             ''
         ),
         'StringToLower'
     ));

  Le code ci-dessus modifiera l'inflecteur pour ne plus séparer les mots avec un tiret ; vous pouvez aussi
  vouloir supprimer le filtre *StringToLower* si vous **voulez** que vos scripts de vues utilisent aussi la
  notationCamel.

  Si le renommage de vos scripts de vue est trop fastidieux ou nécessite trop de temps, ceci est la meilleure
  option avant de trouver le temps de le faire.

- Option la moins souhaitable : vous pouvez forcer le distributeur à distribuer les noms d'action écrits en
  notationCamel avec un nouveau drapeau du contrôleur frontal, *useCaseSensitiveActions*\  :

  .. code-block:: php
     :linenos:

     $front->setParam('useCaseSensitiveActions', true);

  Ceci vous permettra d'utiliser la notationCamel dans l'URL et de toujours faire résoudre la même action que si
  vous utilisez les séparateurs de mots. Cependant, ceci signifiera que les problèmes décrits ci-dessus
  interviendront tôt ou tard ; vous devrez probablement utiliser la deuxième option ci-dessus en plus de celle-ci
  pour que tout fonctionne correctement.

  Notez, de plus, que l'utilisation de ce drapeau déclenchera une *notice* indiquant que cette utilisation est
  dépréciée.


