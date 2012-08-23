.. EN-Revision: none
.. _zend.validator.set.regex:

Regex
=====

Ce validateur valide si une chaine correspond à un motif d'expression régulière.

.. _zend.validator.set.regex.options:

Options supportées par Zend_Validate_Regex
------------------------------------------

Les options suivantes sont supportées par ``Zend_Validate_Regex``\  :

- **pattern**\  : le motif d'expression régulière.

.. _zend.validator.set.regex.basic:

Validation avec Zend_Validate_Regex
-----------------------------------

La validation au travers d'expressions régulières est pratique, très utilisée et simple dans la mesure où elle
vous évite la plupart du temps d'écrire votre propre validateur. Voyons quelques exemples :

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Regex(array('pattern' => '/^Test/');

   $validator->isValid("Test"); // retourne true
   $validator->isValid("Testing"); // retourne true
   $validator->isValid("Pest"); // retourne false

Comme vous le voyez, le motif doit être passé avec la même forme que pour ``preg_match()``. Pour plus de
détails sur les expressions régulières, voyez `le manuel de PHP sur la syntaxe des motifs d'expressions PCRE`_.

.. _zend.validator.set.regex.handling:

Gestion des motifs
------------------

Vous pouvez affecter / récupérer le motif après avoir crée le validateur en utilisant les méthodes
``setPattern()`` et ``getPattern()``.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Regex(array('pattern' => '/^Test/');
   $validator->setPattern('ing$/');

   $validator->isValid("Test"); // retourne false
   $validator->isValid("Testing"); // retourne true
   $validator->isValid("Pest"); // retourne false



.. _`le manuel de PHP sur la syntaxe des motifs d'expressions PCRE`: http://php.net/manual/en/reference.pcre.pattern.syntax.php
