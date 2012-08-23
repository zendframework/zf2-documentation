.. EN-Revision: none
.. _migration.10:

Zend Framework 1.0
==================

Lors de la migration d'un version précédente vers Zend Framework 0.8 ou plus récent vous devriez prendre note de
ce qui suit.

.. _migration.10.zend.controller:

Zend_Controller
---------------

Les principaux changements introduits dans la version 1.0.0RC1 sont l'ajout et l'activation par défaut du plugin
:ref:`ErrorHandler <zend.controller.plugins.standard.errorhandler>`\ et de l'aide d'action :ref:`ViewRenderer
<zend.controller.actionhelpers.viewrenderer>`. Veuillez lire la documentation de chacun des éléments directement
pour apprendre leur fonctionnement et quels effets, ils peuvent avoir sur vos applications.

Le plugin *ErrorHandler* est exécuté pendant ``postDispatch()`` vérifiant la présence d'exceptions, et
redirigeant vers le contrôleur de gestion d'erreur spécifié. Vous pouvez le désactiver en réglant le
paramètre *noErrorHandler* du contrôleur frontal :

.. code-block:: php
   :linenos:

   $front->setParam('noErrorHandler', true);

L'aide d'action *ViewRenderer* automatise l'injection de vues dans les contrôleurs d'action en tant
qu'autogénération des scripts de vues suivant l'action courante. Le principal problème que vous pourriez
rencontrer intervient quand vous avez des actions qui ne rendent pas de scripts de vues ni ne font suivre ou
redirige, alors *ViewRenderer* va tenter de rendre un script de vue basé sur le nom de l'action.

Il existe plusieurs possibilités pour mettre à jour votre code. Dans un premier temps, vous pouvez globalement
désactiver *ViewRenderer* dans votre fichier d'amorçage du contrôleur frontal avant toute distribution :

.. code-block:: php
   :linenos:

   // En considérant que $front est une instance de Zend_Controller_Front
   $front->setParam('noViewRenderer', true);

Cependant, ceci n'est pas une bonne stratégie à long terme, car il apparaît aisément que vous devrez écrire
plus de code.

Quand vous serez prêt à utiliser la fonctionnalité *ViewRenderer*, il y a plusieurs choses à vérifier dans
votre code de contrôleur. Premièrement, regardez vos méthodes d'actions (les méthodes se terminant par
"Action"), et déterminez ce que chacune d'elle réalise. Si rien de ce qui suit n'est réalisé, vous devrez
réaliser des changements :

- Appel de *$this->render()*

- Appel de *$this->_forward()*

- Appel de *$this->_redirect()*

- Appel de l'aide d'action *Redirector*

Le changement le plus simple est la désactivation de l'auto-rendu pour cette méthode :

.. code-block:: php
   :linenos:

   $this->_helper->viewRenderer->setNoRender();

Si vous trouvez qu'aucune de vos méthodes d'actions n'effectue de rendu, ne font suivre, ou redirige, vous pouvez
préférer mettre la ligne suivante dans la méthode ``preDispatch()`` ou ``init()``\  :

.. code-block:: php
   :linenos:

   public function preDispatch()
   {
       // désactive l'auto-rendu des scripts de vues
       $this->_helper->viewRenderer->setNoRender()
       // ... faire autre chose ...
   }

Si vous appelez ``render()``, et que vous utilisez la :ref:`structure de dossier modulaire conventionnelle
<zend.controller.modular>`, vous voudrez modifier votre code pour utiliser l'auto-rendu :

- Si vous rendez de multiples scripts de vues dans une seule action, vous n'avez rien à modifier.

- Si vous appelez simplement ``render()`` sans aucun argument, vous pouvez effacer ces lignes.

- Si vous appelez ``render()`` avec des arguments, et que vous ne réalisez pas ensuite d'exécution de code ou
  effectuez le rendu de scripts de vues multiples, vous pouvez changer ces appels par
  *$this->_helper->viewRenderer()*.

Si vous n'utilisez pas la structure de dossier modulaire conventionnelle, il existe une variété de méthodes pour
paramétrer le chemin de base des vues et les spécifications du chemin vers les scripts ainsi vous pourrez
utiliser *ViewRenderer*. Veuillez lire la :ref:`documentation de ViewRenderer
<zend.controller.actionhelpers.viewrenderer>`\ pour plus d'informations sur ces méthodes.

Si vous utilisez un objet de vue issu du registre, ou que vous personnalisez votre objet vue, ou que vous utilisez
une implémentation de vue différente, vous pouvez vouloir injecter *ViewRenderer* dans cet objet. Ceci peut être
réalisé facilement à tout moment.

- Avant la distribution d'une instance de contrôleur frontal :

  .. code-block:: php
     :linenos:

     // En considérant que $view a déjà été définie
     $viewRenderer = new Zend_Controller_Action_Helper_ViewRenderer($view);
     Zend_Controller_Action_HelperBroker::addHelper($viewRenderer);

- A tout moment durant le processus d'amorçage :

  .. code-block:: php
     :linenos:

     $viewRenderer =
         Zend_Controller_Action_HelperBroker::getStaticHelper('viewRenderer');
     $viewRenderer->setView($view);

Il existe plusieurs manières de modifier *ViewRenderer*, incluant le réglage d'un script de vue différent à
rendre, la spécification d'un remplaçant pour tous les éléments remplaçables d'un chemin de script de vues
(incluant le suffixe), le choix d'un segment nommé de la réponse à utiliser, et plus encore. Si vous n'utilisez
pas la structure de dossier modulaire conventionnelle, vous pouvez tout de même associer différentes
spécifications de chemin à *ViewRenderer*.

Nous vous encourageons à adapter votre code pour utiliser *ErrorHandler* et *ViewRenderer* puisqu'il s'agit
maintenant de fonctionnalités natives.

.. _migration.10.zend.currency:

Zend_Currency
-------------

Créer un objet ``Zend_Currency`` est devenu plus simple. Vous n'avez plus besoin de passer un script ou de le
mettre à ``NULL``, le paramètre script est optionnel et peut être spécifié par la méthode ``setFormat()``.

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency($currency, $locale);

La méthode ``setFormat()`` prend maintenant en paramètre un tableau d'options. Ces options sont permanentes et
écrasent les précédentes déjà présentes. La nouvelle option "precision" a été intégrée :

   - **position**\  : Remplacement de l'ancien paramètre "rules"

   - **script**\  : Remplacement de l'ancien paramètre "script"

   - **format**\  : Remplacement de l'ancien paramètre "locale" qui n'affecte plus de nouvelle monnaie, mais
     seulement un format de nombre.

   - **display**\  : Remplacement de l'ancien paramètre "rules"

   - **precision**\  : Nouveau paramètre

   - **name**\  : Remplacement de l'ancien paramètre "rules". Affecte le nom complet de la monnaie.

   - **currency**\  : Nouveau paramètre

   - **symbol**\  : Nouveau paramètre



.. code-block:: php
   :linenos:

   $currency->setFormat(array $options);

La méthode ``toCurrency()`` ne supporte plus les paramètres optionnels "script" et "locale". A la place, elle
accepte un tableau d'options qui sera de la même forme que celui utilisé par *setFormat*.

.. code-block:: php
   :linenos:

   $currency->toCurrency($value, array $options);

Les méthodes ``getSymbol()``, ``getShortName()``, ``getName()``, ``getRegionList()`` et ``getCurrencyList()`` ne
sont plus statiques. Elles retournent les valeurs affectées dans l'objet, si on ne leur passe pas de paramètre.


