.. _zend.view.helpers.initial.translator:

L'aide de vue Translate
=======================

Souvent le sites Web sont disponibles en plusieurs langues. Pour traduire le contenu d'un site, vous pouvez
simplement utiliser :ref:`Zend Translator <zend.translator.introduction>` et pour intégrer *Zend_Translator* à
l'intérieur de vos vues, vous devriez utiliser l'aide de vue *Translator*.

Dans tous les exemples suivants nous allons utiliser l'adaptateur de traduction *Array*. Bien sûr vous pouvez
aussi utiliser toute instance de ``Zend_Translator`` ainsi que toutes sous-classes de ``Zend_Translator_Adapter``.
Il y a plusieurs manières d'initialiser l'aide de vue *Translator*:

- enregistré préalablement dans ``Zend_Registry``

- après, par l'interface fluide

- directement en initialisant la classe

Une instance préalablement enregistré de ``Zend_Translator`` est l'utilisation préférée pour cette aide. Vous
pouvez ainsi sélectionner la locale à utiliser avant d'ajouter l'adaptateur dans le registre.

.. note::

   Nous parlons de locales et non de langues car une langue peut aussi contenir une région. Par exemple l'anglais
   est parlé en différents dialectes. Il peut y avoir une traduction pour l'anglais et une pour l'américain.
   Ainsi, nous disons "locale" plutôt que "langues".

.. _zend.view.helpers.initial.translator.registered:

.. rubric:: Instance enregistrée

Pour utiliser une instance enregistrée, créez une instance de ``Zend_Translator`` ou ``Zend_Translator_Adapter``
et enregistrez la dans ``Zend_Registry`` en utilisant la clé ``Zend_Translator``.

.. code-block:: php
   :linenos:

   // notre adaptateur d'exemple
   $adapter = new Zend_Translator(
       array(
           'adapter' => 'array',
           'content' => array('simple' => 'einfach'),
           'locale'  => 'de'
       )
   );
   Zend_Registry::set('Zend_Translator', $adapter);

   // à l'intérieur de votre vue
   echo $this->translate('simple');
   // ceci retourne 'einfach'

Si vous êtes plus familier avec l'interface fluide, alors vous pouvez aussi créer une instance à l'intérieur de
votre vue et initialiser l'aide ensuite.

.. _zend.view.helpers.initial.translator.afterwards:

.. rubric:: A l'intérieur de la vue

Pour utiliser l'interface fluide, créez une instance de ``Zend_Translator`` ou ``Zend_Translator_Adapter``,
appelez l'aide sans paramètres, et appelez la méthode ``setTranslator()``.

.. code-block:: php
   :linenos:

   // à l'intérieur de votre vue
   $adapter = new Zend_Translator(
       array(
           'adapter' => 'array',
           'content' => array('simple' => 'einfach'),
           'locale'  => 'de'
       )
   );
   $this->translate()->setTranslator($adapter)->translate('simple');
   // ceci retourne 'einfach'

Si vous utilisez votre aide sans ``Zend_View``, alors vous pouvez aussi l'utiliser directement.

.. _zend.view.helpers.initial.translator.directly:

.. rubric:: Utilisation directe

.. code-block:: php
   :linenos:

   // notre adaptateur d'exemple
   $adapter = new Zend_Translator(
       array(
           'adapter' => 'array',
           'content' => array('simple' => 'einfach'),
           'locale'  => 'de'
       )
   );

   // initialiser l'adaptateur
   $translate = new Zend_View_Helper_Translator($adapter);
   print $translate->translate('simple');
   // ceci retourne 'einfach'

Vous devriez utiliser cette façon de faire si vous ne travaillez pas avec ``Zend_View`` et que vous avez besoin de
créer des affichages traduits.

Comme vu auparavant, la méthode ``translate()`` est utilisé pour retourner la traduction. Appelez la simplement
avec l'identifiant de message de votre adaptateur de traduction. Mais il peut aussi avoir à remplacer des
paramètres dans la chaîne de traduction. Donc, il accepte des paramètres de deux manières : soit comme une
liste de paramètres, soit comme un tableau de paramètres. Par exemple :

.. _zend.view.helpers.initial.translator.parameter:

.. rubric:: Paramètres unique

Pour utiliser un paramètre unique, ajoutez le en fin de méthode :

.. code-block:: php
   :linenos:

   // à l'intérieur de votre vue
   $date = "Monday";
   $this->translate("Today is %1\$s", $date);
   // ceci retourne 'Heute ist Monday'

.. note::

   Gardez à l'esprit que si vous utilisez des paramètres qui sont aussi des textes, vous pouvez aussi avoir à
   traduire ces paramètres.

.. _zend.view.helpers.initial.translator.parameterlist:

.. rubric:: Liste de paramètres

Ou utiliser une liste de paramètres et ajoutez les en fin de méthode :

.. code-block:: php
   :linenos:

   // à l'intérieur de votre vue
   $date = "Monday";
   $month = "April";
   $time = "11:20:55";
   $this->translate("Today is %1\$s in %2\$s. Actual time: %3\$s",
                    $date,
                    $month,
                    $time);
   // ceci retourne 'Heute ist Monday in April. Aktuelle Zeit: 11:20:55'

.. _zend.view.helpers.initial.translator.parameterarray:

.. rubric:: Tableau de paramètres

Ou utiliser un tableau de paramètres et ajoutez le en fin de méthode :

.. code-block:: php
   :linenos:

   // à l'intérieur de votre vue
   $date = array("Monday", "April", "11:20:55");
   $this->translate("Today is %1\$s in %2\$s. Actual time: %3\$s", $date);
   // Could return 'Heute ist Monday in April. Aktuelle Zeit: 11:20:55'

Parfois il est nécessaire de changer la locale pour une traduction. Ceci peut être fait soit dynamiquement par
traduction ou statiquement pour toutes les traductions suivantes. Et vous pouvez utiliser ceci avec une liste de
paramètres ou un tableau de paramètres. Dans les deux cas la locale doit être fournie comme un paramètre unique
final.

.. _zend.view.helpers.initial.translator.dynamic:

.. rubric:: Changement dynamique de la locale

.. code-block:: php
   :linenos:

   // à l'intérieur de votre vue
   $date = array("Monday", "April", "11:20:55");
   $this->translate("Today is %1\$s in %2\$s. Actual time: %3\$s", $date, 'it');

Cet exemple retourne la traduction italienne pour l'identifiant de message. Mais la locale ne sera utilisée qu'une
seule fois. La traduction suivante utilisera la locale de l'adaptateur. Normalement vous réglerez la locale au
niveau de votre adaptateur avant de le mettre dans le registre. Mais vous pouvez aussi paramétrer la locale avec
l'aide de vue :

.. _zend.view.helpers.initial.translator.static:

.. rubric:: Changement statique de la locale

.. code-block:: php
   :linenos:

   // à l'intérieur de votre vue
   $date = array("Monday", "April", "11:20:55");
   $this->translate()->setLocale('it');
   $this->translate("Today is %1\$s in %2\$s. Actual time: %3\$s", $date);

L'exemple ci-dessus paramètre *'it'* comme nouvelle locale par défaut, elle sera utilisée pour toutes les
traductions ultérieures.

Bien sûr il existe aussi la méthode ``getLocale()`` pour récupérer le réglage courant de la locale.

.. _zend.view.helpers.initial.translator.getlocale:

.. rubric:: Récupération de la locale courante

.. code-block:: php
   :linenos:

   // à l'intérieur de votre vue
   $date = array("Monday", "April", "11:20:55");

   // retourne 'de' comme réglé dans les exemples précédents
   $this->translate()->getLocale();

   $this->translate()->setLocale('it');
   $this->translate("Today is %1\$s in %2\$s. Actual time: %3\$s", $date);

   // retourne 'it' comme nouvelle locale par défaut
   $this->translate()->getLocale();


