.. _zend.view.helpers.initial.currency:

Aide Currency
=============

Afficher des informations de monnaie localisées est très courant; l'aide de vue de ``Zend_Currency`` est dédiée
à cela. Voyez le chapitre :ref:`sur Zend Currency <zend.currency.introduction>` pour les détails sur la
localisation. Dans cette section, nous apprendrons à manipuler l'aide de vue uniquement.

Il existe plusieurs manières d'initialiser l'aide de vue **Currency**:

- Enrigistrée dans une instance de ``Zend_Registry``.

- Grâce à une interface fluide.

- En instanciant directement la classe.

L'enregistrement en registre de ``Zend_Currency`` est la manière recommandée. Grâce à cela vous pouvez
selectionner la monnaie à utiliser puis ajouter son adaptateur au registre.

Pour séléctionner la valeur de la monnaie à utiliser, passez une chaine ou encore une locale ce qui est
recommandé car les informations provenant du client HTTP seront alors utilisées par défaut.

.. note::

   Nous parlons bien de "locales" et non de "langues" car la langue peut varier en fonction de la position
   géorgraphique au sein d'un même pays.Par exemple, l'anglais est parlé dans différents dialectes : Anglais ou
   Américain. Une monnaie est liée directement à une région, vous devrez donc utiliser une locale complète
   c'est à dire représentant le pays **et** la région. Nous parlons donc de "locale" plutôt que de "langue."

.. _zend.view.helpers.initial.currency.registered:

.. rubric:: Instance en registre

Pour utiliser une instance en registre, créez une instance de ``Zend_Currency`` et enregistrez la dans
``Zend_Registry`` en utilisant la clé ``Zend_Currency``.

.. code-block:: php
   :linenos:

   // notre monnaie d'exemple
   $currency = new Zend_Currency('de_AT');
   Zend_Registry::set('Zend_Currency', $currency);

   // Dans votre vue
   echo $this->currency(1234.56);
   // Ceci affiche '€ 1.234,56'

Si vous préférez utiliser l'interface fluide, vous pouvez alors créer une instance dans votre vue et la
configurer après cela.

.. _zend.view.helpers.initial.currency.afterwards:

.. rubric:: Instance dans la vue

Pour utiliser l'interface fluide, créez une instance de ``Zend_Currency``, appelez l'aide de vue sans paramètre
et appelez ensuite la méthode ``setCurrency()``.

.. code-block:: php
   :linenos:

   // Dans votre vue
   $currency = new Zend_Currency('de_AT');
   $this->currency()->setCurrency($currency)->currency(1234.56);
   // Ceci affiche '€ 1.234,56'

Si vous utilisez l'aide sans ``Zend_View`` alors vous pouvez aussi l'utiliser de manière directe, via
instanciation manuelle.

.. _zend.view.helpers.initial.currency.directly.example-1:

.. rubric:: Utilisation directe via instanciation

.. code-block:: php
   :linenos:

   // Notre monnaie d'exemple
   $currency = new Zend_Currency('de_AT');

   // Initialisation de l'aide de vue
   $helper = new Zend_View_Helper_Currency($currency);
   echo $helper->currency(1234.56); // Ceci affiche '€ 1.234,56'

Comme déja vu, la méthode ``currency()`` est utilisée pour retourner la chaine représentant la monnaie. Appelez
la simplement avec la valeur que vous voulez voir affichée. Des options sont aussi disponibles, elles servent à
changer le comportement interne de l'aide.

.. _zend.view.helpers.initial.currency.directly.example-2:

.. rubric:: Utilisation directe

.. code-block:: php
   :linenos:

   // Notre monnaie d'exemple
   $currency = new Zend_Currency('de_AT');

   // Initialisation de l'aide de vue
   $helper = new Zend_View_Helper_Currency($currency);
   echo $helper->currency(1234.56); // Ceci affiche '€ 1.234,56'
   echo $helper->currency(1234.56, array('precision' => 1));
   // Ceci affiche '€ 1.234,6'

Concernant les options disponibles, voyez la méthode ``toCurrency()`` de ``Zend_Currency``.


