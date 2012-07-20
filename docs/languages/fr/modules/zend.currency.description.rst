.. _zend.currency.description:

Qu'est ce qui définit une monnaie?
==================================

Une monnaie consiste en plusieurs informations. Un nom, une abbréviation et un signe. Chacune de ces informations
n'est pertinente à l'affichage que si elle est seule, par exemple il est un peu idiot d'écrire "USD 1.000 $" ou
"EUR 1.000 €"

De ce fait, ``Zend_Currency`` garde en mémoire l'information pertinente pour la monnaie en cours à l'affichage.
Les constantes suivantes sont utilisées:

.. _zend.currency.description.table-1:

.. table:: Informations rendues pour une monnaie

   +-------------+------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Constante    |Description                                                                                                                                                 |
   +=============+============================================================================================================================================================+
   |NO_SYMBOL    |Aucun symbole de représentation de la monnaie                                                                                                               |
   +-------------+------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |USE_SYMBOL   |Le symbole de la monnaie sera rendu. Pour l'Euro : '€'                                                                                                      |
   +-------------+------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |USE_SHORTNAME|L'abbréviation sera utilisée pour le rendu visuel. L'Euro aura 'EUR' comme abbréviation par exemple. La plupart des abbréviations tiennent sur 3 caractères.|
   +-------------+------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |USE_NAME     |Le nom complet de la monnaie sera utilisé. Pour le dollar américain : "US Dollar".                                                                          |
   +-------------+------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.currency.description.example-1:

.. rubric:: Sélectionner la description de la monnaie

Imaginons que le client utilise la locale "en_US". Sans autre option, la valeur de monnaie retournée ressemblerait
à ceci:

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency(
       array(
           'value' => 100,
       )
   );

   print $currency; // Pourrait afficher '$ 100'

En donnant des options vous précisez quelle information afficher.

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency(
       array(
           'value'   => 100,
           'display' => Zend_Currency::USE_SHORTNAME,
       )
   );

   print $currency; // Pourrait retourner 'USD 100'

Sans le paramètre ``display``, le signe de la monnaie sera utilisé lors du rendu visuel. Si la monnaie n'a pas de
signe, son abbréviation sera utilisée à la place.

.. note::

   **Toutes les monnaies n'ont pas de signe**

   Toutes les monnaies ne possèdent pas forcément un signe. Ceci signifie que s'il n'y a pas de signe par défaut
   pour la monnaie, et que vous spécifiez manuellement de rendre un signe, alors le rendu de la monnaie sera nul
   car le signe serait alors une chaine vide.

Pour changer des options concernant les monnaies, voyez le paragraphe ci-après.

.. _zend.currency.description.example-2:

.. rubric:: Changer la description de la monnaie

Imaginons que le client utilise la locale "en_US". Nous ne voulons pas des paramètres par défaut, mais nous
voulons préciser manuellement notre propre description. Ceci s'applique au moyen d'une option simple:

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency(
       array(
           'value' => 100,
           'name'  => 'Dollar',
       )
   );

   print $currency; // Retournerait 'Dollar 100'

Vous pourriez aussi passer un signe et une abbréviation spécifiques.

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency(
       array(
           'value'    => 100,
           'symbol' => '$$$',
       )
   );

   print $currency; // Retournerait '$$$ 100'

.. note::

   **Paramètres de rendu automatiques**

   Lorsque vous précisez un nom, une abbréviation ou un signe, alors ces informations seront rendues
   automatiquement. Cette supposition simplifie les traitements car vous n'avez de ce fait pas à toucher à
   l'option ``display``.

   Ainsi, utiliser l'option ``sign`` peut se faire en évitant de toucher à ``display``, nul besoin de passer
   cette dernière à '``USE_SYMBOL``'.


