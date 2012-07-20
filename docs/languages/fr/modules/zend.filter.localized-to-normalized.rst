.. _zend.filter.set.localizedtonormalized:

LocalizedToNormalized
=====================

Ce filtre va transformer toute entrée localisée en sa représentation normalisée. La transformation est
effectuée grâce à ``Zend_Locale`` en interne.

Ceci permet à l'utilisateur de saisir des information dans sa propre locale, et du coté serveur de stocker les
informations normalisées relatives.

.. note::

   Attention la normalisation n'est pas de la traduction. Ce filtre ne sait pas traduire des chaines d'un langage
   à un autre.

Les types suivants peuvent être normalisés:

- **entiers**: Nombres entiers localisés. Ils seront normalisés dans la notation anglaise internationnale.

- **float**: Nombres flottants. Ils seront normalisés dans la notation anglaise internationnale.

- **nombres**: Nombres réels. Ils seront normalisés dans la notation anglaise internationnale.

- **time**: Valeurs de temps. Normalisées sous forme de tableaux.

- **date**: Valeurs de date. Normalisées sous forme de tableaux.

Tout autre type d'entrée sera retourné tel quel, sans tranformation, par ce filtre.

.. note::

   Notez bien que toute sortie normalisée de ce filtre est de type chaine de caractères.

.. _zend.filter.set.localizedtonormalized.numbers:

Normaliser des nombres
----------------------

Tout type de nombre peut être normalisé, excepté les nombres représentant une notation scientifique.

Voici un exemple:

.. code-block:: php
   :linenos:

   // Initialise le filtre
   $filter = new Zend_Filter_LocalizedToNormalized();
   $filter->filter('123.456,78');
   // retourne '123456.78'

Imaginons que nous utilisoons la locale 'de' de manière globale sur toute l'application.
``Zend_Filter_LocalizedToNormalized`` va utiliser cette locale là pour calculer sa sortie.

Il est possible de contrôler la normalisation des nombres. Toute options accépté par ``Zend_Locale_Format`` peut
alors être utilisée. Les plus courantes sont:

- **date_format**

- **locale**

- **precision**

Pour plus de détails à ce sujet, voyez le chapitre :ref:`Zend_Locale <zend.locale.parsing>`.

Voici un exemple utilisant la précision:

.. code-block:: php
   :linenos:

   // Numeric Filter
   $filter = new Zend_Filter_LocalizedToNormalized(array('precision' => 2));

   $filter->filter('123.456');
   // retourne '123456.00'

   $filter->filter('123.456,78901');
   // retourne '123456.79'

.. _zend.filter.set.localizedtonormalized.dates:

Normaliser des dates et des temps
---------------------------------

Les dates et temps peuvent être normalisés eux aussi. La sortie du filtre sera alors toujours de type tableau.

.. code-block:: php
   :linenos:

   // Initialise le filtre
   $filter = new Zend_Filter_LocalizedToNormalized();
   $filter->filter('12.April.2009');
   // retourne array('day' => '12', 'month' => '04', 'year' => '2009')

Imaginons une fois de plus une locale globale 'de'. L'entrée est donc automatiquement reconnue comme date et vous
aurez un tableau en sortie.

Vous pouvez contrôler la transformation du filtre grâce aux paramètres **date_format** et **locale**.

.. code-block:: php
   :linenos:

   // Date Filter
   $filter = new Zend_Filter_LocalizedToNormalized(
       array('date_format' => 'ss:mm:HH')
   );

   $filter->filter('11:22:33');
   // retourne array('hour' => '33', 'minute' => '22', 'second' => '11')


