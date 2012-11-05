.. EN-Revision: none
.. _migration.17:

Zend Framework 1.7
==================

Lors de la migration d'un version précédente vers Zend Framework 1.7 ou plus récent vous devriez prendre note de
ce qui suit.

.. _migration.17.zend.controller:

Zend_Controller
---------------

.. _migration.17.zend.controller.dispatcher:

Changement dans l'interface Dispatcher
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Les utilisateurs ont portés l'attention sur le fait que ``Zend\Controller\Action\Helper\ViewRenderer`` utilisait
une méthode de la classe abstraite du distributeur standard qui n'était pas présente dans l'interface
Dispatcher.La méthode suivante a donc été ajoutée pour s'assurer que les distributeurs personnalisés
continueront à fonctionner avec les implémentations embarquées :

- ``formatModuleName()``\  : devrait être utilisé pour prendre un nom de contrôleur brut, comme un qui aurait
  été embarqué dans un objet requête, et pour le formater en un nom de classe approprié qu'une classe
  étendant ``Zend\Controller\Action`` pourra utiliser.

.. _migration.17.zend.file.transfer:

Zend\File\Transfer
------------------

.. _migration.17.zend.file.transfer.validators:

Changements quand vous utilisez des filtres ou des validateurs
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Certaines remarques des utilisateurs indiquaient que les validateurs de ``Zend\File\Transfer`` ne fonctionnaient
pas correctement avec ``Zend_Config`` dû au fait qu'ils n'utilisait pas de tableaux nommés.

De plus, tous les filtres et validateurs de ``Zend\File\Transfer`` ont été réécrits. Même si les anciennes
signatures continuent à fonctionner, elles ont été marqués comme dépréciées et émettent une notice *PHP*
vous informant de faire le changement.

La liste suivante vous montre les changements à réaliser pour une utilisation appropriée des paramètres.

.. _migration.17.zend.file.transfer.validators.rename:

Filtre Rename
^^^^^^^^^^^^^

- Ancienne *API*\  : ``Zend\Filter_File\Rename($oldfile, $newfile, $overwrite)``

- Nouvelle *API*\  : ``Zend\Filter_File\Rename($options)`` où ``$options`` accepte un tableau avec les clés
  suivantes : **source** est équivalent à ``$oldfile``, **target** est équivalent à ``$newfile``, **overwrite**
  est équivalent à *$overwrite.*

.. _migration.17.zend.file.transfer.validators.rename.example:

.. rubric:: Changer le filtre rename entre 1.6 et 1.7

.. code-block:: php
   :linenos:

   // Exemple pour 1.6
   $upload = new Zend\File\Transfer\Adapter\Http();
   $upload->addFilter('Rename',
                      array('/path/to/oldfile', '/path/to/newfile', true));

   // Même exemple pour 1.7
   $upload = new Zend\File\Transfer\Adapter\Http();
   $upload->addFilter('Rename',
                      array('source' => '/path/to/oldfile',
                            'target' => '/path/to/newfile',
                            'overwrite' => true));

.. _migration.17.zend.file.transfer.validators.count:

Validateur Count
^^^^^^^^^^^^^^^^

- Ancienne *API*\  : ``Zend\Validate_File\Count($min, $max)``

- Nouvelle *API*\  : ``Zend\Validate_File\Count($options)`` où ``$options`` accepte un tableau avec les clés
  suivantes : **min** est équivalent à ``$min``, **max** est équivalent à ``$max``.

.. _migration.17.zend.file.transfer.validators.count.example:

.. rubric:: Changer le validateur count entre 1.6 et 1.7

.. code-block:: php
   :linenos:

   // Exemple pour 1.6
   $upload = new Zend\File\Transfer\Adapter\Http();
   $upload->addValidator('Count',
                         array(2, 3));

   // Même exemple pour 1.7
   $upload = new Zend\File\Transfer\Adapter\Http();
   $upload->addValidator('Count',
                         false,
                         array('min' => 2,
                               'max' => 3));

.. _migration.17.zend.file.transfer.validators.extension:

Validateur Extension
^^^^^^^^^^^^^^^^^^^^

- Ancienne *API*\  : ``Zend\Validate_File\Extension($extension, $case)``

- Nouvelle *API*\  : ``Zend\Validate_File\Extension($options)`` où ``$options`` accepte un tableau avec les clés
  suivantes : ***** est équivalent à ``$extension`` et peut avoir tout autre clé, **case** est équivalent à
  ``$case``.

.. _migration.17.zend.file.transfer.validators.extension.example:

.. rubric:: Changer le validateur extension entre 1.6 et 1.7

.. code-block:: php
   :linenos:

   // Exemple pour 1.6
   $upload = new Zend\File\Transfer\Adapter\Http();
   $upload->addValidator('Extension',
                      array('jpg,gif,bmp', true));

   // Même exemple pour 1.7
   $upload = new Zend\File\Transfer\Adapter\Http();
   $upload->addValidator('Extension',
                         false,
                         array('extension1' => 'jpg,gif,bmp',
                               'case' => true));

.. _migration.17.zend.file.transfer.validators.filessize:

Validateur FilesSize
^^^^^^^^^^^^^^^^^^^^

- Ancienne *API*\  : ``Zend\Validate_File\FilesSize($min, $max, $bytestring)``

- Nouvelle *API*\  : ``Zend\Validate_File\FilesSize($options)`` où ``$options`` accepte un tableau avec les clés
  suivantes : **min** est équivalent à ``$min``, **max** est équivalent à ``$max``, **bytestring** est
  équivalent à ``$bytestring``.

De plus la signature de la méthode ``useByteString()`` a changé. Elle peut être seulement utilisée pour tester
si le validateur prévoie d'utiliser les chaînes lisibles ou la valeur brute dans les messages générées. Pour
paramétrer la valeur de cette option, utilisez la méthode ``setUseByteString()``.

.. _migration.17.zend.file.transfer.validators.filessize.example:

.. rubric:: Changer le validateur filessize entre 1.6 et 1.7

.. code-block:: php
   :linenos:

   // Exemple pour 1.6
   $upload = new Zend\File\Transfer\Adapter\Http();
   $upload->addValidator('FilesSize',
                         array(100, 10000, true));

   // Même exemple pour 1.7
   $upload = new Zend\File\Transfer\Adapter\Http();
   $upload->addValidator('FilesSize',
                         false,
                         array('min' => 100,
                               'max' => 10000,
                               'bytestring' => true));

   // Exemple pour 1.6
   $upload->useByteString(true); // set flag

   // Même exemple pour 1.7
   $upload->setUseByteSting(true); // set flag

.. _migration.17.zend.file.transfer.validators.hash:

Validateur Hash
^^^^^^^^^^^^^^^

- Ancienne *API*\  : ``Zend\Validate_File\Hash($hash, $algorithm)``

- Nouvelle *API*\  : ``Zend\Validate_File\Hash($options)`` où ``$options`` accepte un tableau avec les clés
  suivantes : ***** est équivalent à ``$hash`` et peut avoir tout autre clé, **algorithm** est équivalent à
  ``$algorithm``.

.. _migration.17.zend.file.transfer.validators.hash.example:

.. rubric:: Changer le validateur hash entre 1.6 et 1.7

.. code-block:: php
   :linenos:

   // Exemple pour 1.6
   $upload = new Zend\File\Transfer\Adapter\Http();
   $upload->addValidator('Hash',
                         array('12345', 'md5'));

   // Même exemple pour 1.7
   $upload = new Zend\File\Transfer\Adapter\Http();
   $upload->addValidator('Hash',
                         false,
                         array('hash1' => '12345',
                               'algorithm' => 'md5'));

.. _migration.17.zend.file.transfer.validators.imagesize:

Validateur ImageSize
^^^^^^^^^^^^^^^^^^^^

- Ancienne *API*\  : ``Zend\Validate_File\ImageSize($minwidth, $minheight, $maxwidth, $maxheight)``

- Nouvelle *API*\  : ``Zend\Validate_File\FilesSize($options)`` où ``$options`` accepte un tableau avec les clés
  suivantes : **minwidth** est équivalent à ``$minwidth``, **maxwidth** est équivalent à ``$maxwidth``,
  **minheight** est équivalent à ``$minheight``, **maxheight** est équivalent à ``$maxheight``.

.. _migration.17.zend.file.transfer.validators.imagesize.example:

.. rubric:: Changer le validateur imagesize entre 1.6 et 1.7

.. code-block:: php
   :linenos:

   // Exemple pour 1.6
   $upload = new Zend\File\Transfer\Adapter\Http();
   $upload->addValidator('ImageSize',
                         array(10, 10, 100, 100));

   // Même exemple pour 1.7
   $upload = new Zend\File\Transfer\Adapter\Http();
   $upload->addValidator('ImageSize',
                         false,
                         array('minwidth' => 10,
                               'minheight' => 10,
                               'maxwidth' => 100,
                               'maxheight' => 100));

.. _migration.17.zend.file.transfer.validators.size:

Validateur Size
^^^^^^^^^^^^^^^

- Ancienne *API*\  : ``Zend\Validate_File\Size($min, $max, $bytestring)``

- Nouvelle *API*\  : ``Zend\Validate_File\Size($options)`` où ``$options`` accepte un tableau avec les clés
  suivantes : **min** est équivalent à ``$min``, **max** est équivalent à ``$max``, **bytestring** est
  équivalent à ``$bytestring``

.. _migration.17.zend.file.transfer.validators.size.example:

.. rubric:: Changer le validateur size entre 1.6 et 1.7

.. code-block:: php
   :linenos:

   // Exemple pour 1.6
   $upload = new Zend\File\Transfer\Adapter\Http();
   $upload->addValidator('Size',
                         array(100, 10000, true));

   // Même exemple pour 1.7
   $upload = new Zend\File\Transfer\Adapter\Http();
   $upload->addValidator('Size',
                         false,
                         array('min' => 100,
                               'max' => 10000,
                               'bytestring' => true));

.. _migration.17.zend.locale:

Zend_Locale
-----------

.. _migration.17.zend.locale.islocale:

Changement dans l'utilisation de isLocale()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Conformément aux standards de codage ``isLocale()`` a été changé pour retourner un booléen. Dans les versions
précédentes une chaîne était retournée lors du succès. Pour la version 1.7 un mode de compatibilité a été
ajouté qui vous permet d'utiliser l'ancien comportement (avec une chaîne retournée), mais ceci émet un warning
pour vous informer de changer vers le nouveau comportement. Le reroutage que l'ancien comportement de
``isLocale()`` pouvait avoir à faire n'est plus nécessaire car tous les composants de l'I18N traiteront
maintenant eux-mêmes le reroutage.

Pour migrer vos scripts vers la nouvelle *API*, utilisez simplement la méthode décrite ci-dessous.

.. _migration.17.zend.locale.example:

.. rubric:: Comment changer l'appel de isLocale() de 1.6 vers 1.7 ?

.. code-block:: php
   :linenos:

   // Exemple pour ZF 1.6
   if ($locale = Zend\Locale\Locale::isLocale($locale)) {
       // faire qqch
   }

   // Même exemple pour ZF 1.7

   // Vous devez changer le mode de compatibilité pour empêcher l'émission de warning
   // Mais ceci peut être fait dans votre bootstrap
   Zend\Locale\Locale::$compatibilityMode = false;

   if (Zend\Locale\Locale::isLocale($locale)) {
   }

Notez que vous pouvez utiliser le second paramètre pour voir si la locale est correcte sans nécessiter de
reroutage.

.. code-block:: php
   :linenos:

   // Exemple pour ZF 1.6
   if ($locale = Zend\Locale\Locale::isLocale($locale, false)) {
       // do something
   }

   // Même exemple pour ZF 1.7

   // Vous devez changer le mode de compatibilité pour empêcher l'émission de warning
   // Mais ceci peut être fait dans votre bootstrap
   Zend\Locale\Locale::$compatibilityMode = false;

   if (Zend\Locale\Locale::isLocale($locale, false)) {
       if (Zend\Locale\Locale::isLocale($locale, true)) {
           // pas de locale du tout
       }

       // original string is no locale but can be rerouted
   }

.. _migration.17.zend.locale.getdefault:

Changement dans l'utilisation de getDefault()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La signification de la méthode ``getDefault()`` a été changé étant donné que nous avons intégré une locale
de framework qui peut être paramétrée avec ``setDefault()``. Ceci ne renvoie plus la chaîne de la locale mais
seulement la locale du framework.

Pour migrer vos scripts vers la nouvelle *API*, utilisez simplement la méthode décrite ci-dessous.

.. _migration.17.zend.locale.getdefault.example:

.. rubric:: Comment changer l'appel de getDefaut() de 1.6 vers 1.7 ?

.. code-block:: php
   :linenos:

   // Exemple pour ZF 1.6
   $locales = $locale->getDefault(Zend\Locale\Locale::BROWSER);

   // Même exemple pour ZF 1.7

   // Vous devez changer le mode de compatibilité pour empêcher l'émission de warning
   // Mais ceci peut être fait dans votre bootstrap
   Zend\Locale\Locale::$compatibilityMode = false;

   $locale = Zend\Locale\Locale::getOrder(Zend\Locale\Locale::BROWSER);

Notez que le second paramètre de l'ancienne implémentation de ``getDefault()`` n'est plus disponible non plus,
mais les valeurs retournées sont les mêmes.

.. note::

   Par défaut l'ancien comportement est toujours actif, mais émet un warning. Quand vous avez changé votre code
   vers le nouveau comportement, vous devriez aussi changer le mode de compatibilité à ``FALSE`` ainsi aucun
   nouveau warning ne sera émis.

.. _migration.17.zend.translator:

Zend_Translator
---------------

.. _migration.17.zend.translator.languages:

Paramétrer les langues
^^^^^^^^^^^^^^^^^^^^^^

Lors de l'utilisation de la détection automatique des langues, ou du réglage manuel des langues de
``Zend_Translator``, vous avez peut-être remarqué que de temps en temps une notice est envoyée concernant le
non-ajout de traductions vides. Dans certaines versions précédentes, une exception était levée dans certains
cas.

Ceci intervient quand un utilisateur requête une langue non existante, vous n'avez alors aucun moyen simple de
détecter ce qui ne va pas. Nous avons donc ajouté ces notices qui apparaîtront dans votre historisation et qui
vous diront qu'un utilisateur a requêté une langue que vous ne supportez pas. Notez bien que votre code, même si
une notice est déclenchée, fonctionnera sans problèmes.

Mais quand vous utilisez votre propre gestionnaire d'erreur ou d'exception, comme xDebug, toutes les notices vous
seront retournées, même si ce n'est pas votre intention initiale. Ceci est du au fait, que ces gestionnaires
surchargent tous les réglages internes de *PHP*.

Pour vous affranchir de ces notices, vous pouvez simplement paramétrer la nouvelle option *disableNotices* à
``TRUE``, sa valeur par défaut étant ``FALSE``.

.. _migration.17.zend.translator.example:

.. rubric:: Paramétrer les langues sans avoir de notices

Assumons que "*fr*" soit disponible et qu'un utilisateur requête pour "*de*" qui ne fait pas partie de votre
portefeuille de traductions.

.. code-block:: php
   :linenos:

   $language = new Zend\Translator\Translator('gettext',
                                  '/chemin/vers/les/traductions',
                                  'auto');

Dans ce cas nous aurons une notice indiquant la non-disponibilité de la langue "*de*". Ajoutez simplement l'option
et les notices seront désactivées.

.. code-block:: php
   :linenos:

   $language = new Zend\Translator\Translator('gettext',
                                  '/chemin/vers/les/traductions',
                                  'auto',
                                  array('disableNotices' => true));

.. _migration.17.zend.view:

Zend_View
---------

.. note::

   Les changements de l'API de ``Zend_View`` sont seulement notables pour vous si vous mettez à jour vers les
   version 1.7.5 ou plus récent.

Avant la version 1.7.5, l'équipe de Zend Framework a été avertie d'une faille potentielle d'inclusion de fichier
local ("Local File Inclusion" (LFI)) dans la méthode ``Zend\View\View::render()``. Avant 1.7.5, la méthode acceptait
par défaut la possibilité de spécifier des scripts de vue comportant des indications de dossier parent (comme,
"../" ou "..\\"). Ceci ouvre la possibilité à une attaque LFI si des données utilisateurs non filtrées sont
passées directement à la méthode ``render()``:

.. code-block:: php
   :linenos:

   // Ici, $_GET['foobar'] = '../../../../etc/passwd'
   echo $view->render($_GET['foobar']); // inclusion LFI

``Zend_View`` émet maintenant une exception dans un tel cas.

.. _zend.view.migration.zf5748.disabling:

Désactiver la protection LFI de render()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Comme des développeurs utilisaient de telles notations, mais qui n'étaient **pas** des données en provenance de
l'extérieur, un drapeau spécial a été crée, il permet de désactiver la protection. Pour manipuler ce drapeau,
il existe 2 moyens : le paramètre 'lfiProtectionOn' du constructeur de votre vue, ou encore la méthode
``setLfiProtection()``.

.. code-block:: php
   :linenos:

   // Désactivation de la protection par le constructeur
   $view = new Zend\View\View(array('lfiProtectionOn' => false));

   // Désactivation de la protection par la méthode dédiée
   $view = new Zend\View\View();
   $view->setLfiProtection(false);


