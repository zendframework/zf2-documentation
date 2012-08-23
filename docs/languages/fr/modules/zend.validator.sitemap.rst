.. EN-Revision: none
.. _zend.validator.sitemap:

Validateurs de Sitemap
======================

Les validateurs suivant sont conformes au protocole `XML Sitemap`_.

.. _zend.validator.sitemap.changefreq:

Sitemap_Changefreq
------------------

Valide si oui ou non une chaîne utilisable en tant qu'élément "changefreq" dans un document *XML* Sitemap. Les
valeurs valides sont : "always", "hourly", "daily", "weekly", "monthly", "yearly", or "never".

Retourne ``TRUE`` si et seulement si la valeur est une chaîne et qu'elle vaut une dès fréquences ci-dessus.

.. _zend.validator.sitemap.lastmod:

Sitemap_Lastmod
---------------

Valide si oui ou non une chaîne utilisable en tant qu'élément "lastmod" dans un document *XML* Sitemap.
L'élément "lasmod" doit contenir une date sous la forme *W3C*, optionnellement en omettant les informations
concernant l'heure.

Retourne ``TRUE`` si et seulement si la valeur est une chaîne et qu'elle est valide suivant le protocole.

.. _zend.validator.sitemap.lastmod.example:

.. rubric:: Validateur de "lastmod" Sitemap

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Sitemap_Lastmod();
   $validator->isValid('1999-11-11T22:23:52-02:00'); // true
   $validator->isValid('2008-05-12T00:42:52+02:00'); // true
   $validator->isValid('1999-11-11'); // true
   $validator->isValid('2008-05-12'); // true
   $validator->isValid('1999-11-11t22:23:52-02:00'); // false
   $validator->isValid('2008-05-12T00:42:60+02:00'); // false
   $validator->isValid('1999-13-11'); // false
   $validator->isValid('2008-05-32'); // false
   $validator->isValid('yesterday'); // false

.. _zend.validator.sitemap.loc:

Sitemap_Loc
-----------

Valide si oui ou non une chaîne utilisable en tant qu'élément "loc" dans un document *XML* Sitemap. Ceci utilise
en interne la méthode ``Zend_Form::check()``. Vous pouvez en lire davantage avec la :ref:`validation d'URI
<zend.uri.validation>`.

.. _zend.validator.sitemap.priority:

Sitemap_Priority
----------------

Valide si oui ou non une valeur est utilisable en tant qu'élément "priority" dans un document *XML* Sitemap. La
valeur doit être un nombre compris entre 0.0 et 1.0. Ce validateur accepte à la fois des valeurs numériques ou
textuelles.

.. _zend.validator.sitemap.priority.example:

.. rubric:: Validateur de "priority" Sitemap

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Sitemap_Priority();
   $validator->isValid('0.1'); // true
   $validator->isValid('0.789'); // true
   $validator->isValid(0.8); // true
   $validator->isValid(1.0); // true
   $validator->isValid('1.1'); // false
   $validator->isValid('-0.4'); // false
   $validator->isValid(1.00001); // false
   $validator->isValid(0xFF); // false
   $validator->isValid('foo'); // false

.. _zend.validator.set.sitemap.options:

Options supportées par Zend_Validate_Sitemap_*
----------------------------------------------

Il n'y a pas d'options supportées par ce validateur.



.. _`XML Sitemap`: http://www.sitemaps.org/protocol.php
