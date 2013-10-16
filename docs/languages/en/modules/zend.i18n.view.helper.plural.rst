.. _zend.i18n.view.helper.plural:

Plural Helper
-------------

Most languages have specific rules for handling plurals. For instance, in English, we say "0 cars" and "2 cars" (plural)
while we say "1 car" (singular). On the other hand, French uses the singular form for 0 and 1 ("0 voiture" and "1 voiture")
and uses the plural form otherwise ("3 voitures").

Therefore, we often need to handle those plural cases even without using translation (mono-lingual application). The
``Plural`` helper was created for this. Please remember that, if you need to both handle translation and plural, you must
use the ``TranslatePlural`` helper for that. ``Plural`` does not deal with translation.

Internally, the ``Plural`` helper uses the ``Zend\I18n\Translator\Plural\Rule`` class to handle rules.

.. _zend.i18n.view.helper.plural.setup:

**Setup**

In Zend Framework 1, there was a similar helper. However, this helper hardcoded rules for mostly every languages. The problem
with this approach is that languages are alive and can evolve over time. Therefore, we would need to change the rules and
hence break current applications that may (or may not) want those new rules.

That's why defining rules is now up to the developer. To help you with this process, here are some links with up-to-date
plural rules for tons of languages:

* http://unicode.org/repos/cldr-tmp/trunk/diff/supplemental/language_plural_rules.html
* https://developer.mozilla.org/en-US/docs/Localization_and_Plurals

.. _zend.i18n.view.helper.plural.usage:

**Basic Usage**

The first thing to do is to defining rule. You may want to add this in your ``Module.php`` file, for example:

.. code-block:: php
   :linenos:

   // Get the ViewHelperPlugin Manager from Service manager, so we can fetch the ``Plural``
   // helper and add the plural rule for the application's language
   $viewHelperManager = $serviceManager->get('ViewHelperManager');
   $pluralHelper      = $viewHelperManager->get('Plural');
   
   // Here is the rule for French
   $pluralHelper->setPluralRule('nplurals=2; plural=(n==0 || n==1 ? 0 : 1)');

The string reads like that:

1. First, we specify how many plurals forms we have. For French, only two (singular/plural).
2. Then, we specify the rule. Here, if the count is 0 or 1, this is rule n°0 (singular) while it's rule n°1 otherwise.

As we said earlier, English consider "1" as singular, and "0/other" as plural. Here is such a rule:

.. code-block:: php
   :linenos:

   // Here is the rule for English
   $pluralHelper->setPluralRule('nplurals=2; plural=(n==1 ? 0 : 1)');
   
Now that we have defined the rule, we can use it in our views:

.. code-block:: php
   :linenos:

   <?php 
      // If the rule defined in Module.php is the English one:
      
      echo $this->plural(array('car', 'cars'), 0); // prints "cars"
      echo $this->plural(array('car', 'cars'), 1); // prints "car"
      
      // If the rule defined in Module.php is the French one:
      echo $this->plural(array('voiture', 'voitures'), 0); // prints "voiture"
      echo $this->plural(array('voiture', 'voitures'), 1); // prints "voiture"
      echo $this->plural(array('voiture', 'voitures'), 2); // prints "voitures"
   ?>
   