.. _zend.filter.set.normalizedtolocalized:

NormalizedToLocalized
=====================

Ce filtre est l'inverse de ``Zend_Filter_LocalizedToNormalized`` et convertira toute entrée normalisée en entrée
localisée. Il utilise ``Zend_Locale`` pour celà.

Ceci permet de représenter une valeur normalisée dans la locale de l'utilisateur, qu'il reconnaitra donc sans
problème.

.. note::

   Notez bien que la localisation n'est pas de la traduction, ce filtre ne sait pas traduire des chaines d'une
   langue à l'autre (comme des noms de jours ou de mois).

Les types suivants peuvent être localisés:

- **entiers**: Nombres entiers.

- **float**: Nombres flottants.

- **nombres**: Autres nombres, comme les réels.

- **temps**: Valeurs de temps, localisées sous forme de chaines.

- **date**: Valeurs de dates, localisées sour forme de chaines.

Tout autre type d'entrée sera retourné tel quel, sans transformation.

.. _zend.filter.set.normalizedtolocalized.numbers:

Localisation des nombres
------------------------

Tout type de nombre peut être localisé, à l'exception des nombres représentant une notation scientifique.

Comment fonctionne la localisation pour les nombres ?:

.. code-block:: php
   :linenos:

   // Initialise le filtre
   $filter = new Zend_Filter_NormalizedToLocalized();
   $filter->filter(123456.78);
   // retourne '123.456,78'

Imaginons que vous avez affecté une locale 'de' comme locale de l'application.
``Zend_Filter_NormalizedToLocalized`` va utiliser cette locale pour détecter le type de sortie à produire, ceci
sous forme de chaine de caractères.

Il est aussi possible de contrôler le look de vos nombres localisés. Pour cela vous pouvez préciser toute option
que ``Zend_Locale_Format`` reconnait. Les plus courantes sont:

- **date_format**

- **locale**

- **precision**

Pour plus de détails sur ces options, voyez le :ref:`chapitre sur Zend_Locale <zend.locale.parsing>`.

Voici un exemple utilisant ces options:

.. code-block:: php
   :linenos:

   // Numeric Filter
   $filter = new Zend_Filter_NormalizedToLocalized(array('precision' => 2));

   $filter->filter(123456);
   // retourne '123.456,00'

   $filter->filter(123456.78901);
   // retourne '123.456,79'

.. _zend.filter.set.normalizedtolocalized.dates:

Localiser des dates et des temps
--------------------------------

Les dates et les temps peuvent aussi être localisés. Des chaines de caractères sont alors retournées, agissant
avec la locale définie.

.. code-block:: php
   :linenos:

   // Initialise le filtre
   $filter = new Zend_Filter_NormalizedToLocalized();
   $filter->filter(array('day' => '12', 'month' => '04', 'year' => '2009');
   // retoures '12.04.2009'

Imaginons que vous ayiez spécifié la locale 'de' au niveau de l'application, celle-ci est alors automatiquement
détectée et utilisée pour localiser la date.

Bien sûr, vous pouvez contrôler le format d'affichage de vos dates, grâce aux paramètres **date_format** et
**locale**.

.. code-block:: php
   :linenos:

   // Date Filter
   $filter = new Zend_Filter_LocalizedToNormalized(
       array('date_format' => 'ss:mm:HH')
   );

   $filter->filter(array('hour' => '33', 'minute' => '22', 'second' => '11'));
   // retourne '11:22:33'


