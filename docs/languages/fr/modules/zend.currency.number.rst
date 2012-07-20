.. _zend.currency.number:

A quoi ressemble une monnaie?
=============================

Le rendu visuel d'une monnaie va dépendre de la locale. La locale stocke plusieurs informations qui peuvent
chacune être redéfinies par vos propres options si besoin.

Par exemple, la plupart des locales utilisent le script latin pour rendre les nombres. Mais certaines langues,
comme l'arabe, utilisent d'autres chiffres. Et un site Web Arabe va utiliser le rendu arabe pour toutes les
monnaies, voyez l'exemple:

.. _zend.currency.number.example-1:

.. rubric:: Utiliser un script personnalisé

Imagnons que nous utisons la monnaie "Dollar". Mais nous voulons rendre notre page avec des scripts arabes.

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency(
       array(
           'value'  => 1000,
           'script' => 'Arab',
       )
   );

   print $currency; // Retournerait '$ ١٬٠٠٠٫٠٠'

Pour plus d'informations sur les scripts disponibles, voyez le manuel de ``Zend_Locale``\ sur :ref:`les systèmes
des nombres <zend.locale.numbersystems>`.

Le formattage d'une monnaie peut être changé. Par défaut, la locale est utilisée. Elle indique le séparateur
des milliers, le point de la décimale et la précision.

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency(
       array(
           'value'    => 1000,
           'currency' => 'USD'
           'format'   => 'de',
       )
   );

   print $currency; // Retournerait '$ 1.000'

Il existe deux manières de préciser le format à utiliser, manuellement ou via une locale.

Utiliser la locale vous permet de bénéficier de certains automatismes. Par exemple la locale 'de' definit le
point '.' comme séparateur des milliers, et la virgule ',' comme séparateur décimal. En anglais, c'est
l'inverse.

.. code-block:: php
   :linenos:

   $currency_1 = new Zend_Currency(
       array(
           'value'    => 1000,
           'currency' => 'USD'
           'format'   => 'de',
       )
   );

   $currency_2 = new Zend_Currency(
       array(
           'value'    => 1000,
           'currency' => 'USD'
           'format'   => 'en',
       )
   );

   print $currency_1; // Retournerait '$ 1.000'
   print $currency_2; // Retournerait '$ 1,000'

Si vous les définissez manuellement, vous devez alors respecter le format décrit dans :ref:`ce chapitre de la
localisation <zend.locale.number.localize.table-1>`. Voyez plutôt:

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency(
       array(
           'value'    => 1000,
           'currency' => 'USD'
           'format'   => '#0',
       )
   );

   print $currency; // Retournerait '$ 1000'

Dans l'exemple ci-dessus nous avons supprimé le séparateur et l'indicateur de précision.


