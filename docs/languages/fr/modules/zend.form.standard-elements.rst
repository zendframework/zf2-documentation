.. _zend.form.standardElements:

Les éléments standards fournis avec Zend Framework
==================================================

Zend Framework est fournis avec des classes d'éléments couvrant la plupart des éléments de formulaire HTML. La
plupart spécifie un helper de vue en particulier à utiliser pour décorer un élément, mais plusieurs d'entre
elles offrent des fonctionnalités supplémentaires. Ce qui suit est une liste de toutes ces classes, ainsi que des
descriptions des fonctionnalités offertes.

.. _zend.form.standardElements.button:

Zend_Form_Element_Button
------------------------

Utilisé pour créer des éléments boutons, ``Zend_Form_Element_Button`` étend :ref:`Zend_Form_Element_Submit
<zend.form.standardElements.submit>`, spécifie quelques fonctionnalités personnalisées. Il spécifie le helper
de vue 'formButton' pour la décoration.

Comme l'élément submit, il utilise le label de l'élément en tant que valeur de l'élément lors de l'affichage
; autrement dit, pour définir le text du bouton, définissez la valeur de l'élément. Le label sera traduit si
l'adapteur de traduction est présent.

Comme le label est utilisé comme faisant partie de l'élément, l'élément bouton utilise seulement
:ref:`ViewHelper <zend.form.standardDecorators.viewHelper>` et les décorateurs :ref:`DtDdWrapper
<zend.form.standardDecorators.dtDdWrapper>`.

Après avoir rempli ou validé un formulaire, vous pouvez vérifier si le bouton donné a été cliqué en
utilisant la méthode ``isChecked()``.

.. _zend.form.standardElements.captcha:

Zend_Form_Element_Captcha
-------------------------

Les CAPTCHAs sont utilisé pour empêcher la soumission automatique des formulaires par des bots et autre processus
automatisés.

L'élément de formulaire Captcha permet de spécifier quel :ref:`Adapteur Zend_Captcha <zend.captcha.adapters>`
vous désirez utiliser. Il définit ensuite cet adapteur comme validateur à l'objet, et utilise le décorateur du
Captcha pour l'affichage (ce qui fait office de proxy vers l'adapteur CAPTCHA).

Les adapteurs peuvent être n'importe quel adapteur de ``Zend_Captcha``, ou n'importe quel adapteur que vous avez
défini par ailleurs. Pour permettre ceci, vous devrez passer une clé supplémentaire de plugin loader, 'CAPTCHA'
ou 'captcha', lorsque vous spécifiez un prefixe de chemin de plugin loader :

.. code-block:: php
   :linenos:

   $element->addPrefixPath('My_Captcha', 'My/Captcha/', 'captcha');

Le Captcha peut ensuite être enregistré en utilisant la méthode ``setCaptcha()``, qui prend en paramètre soit
une instance concrête de CAPTCHA soit le nom court d'un adapteur CAPTCHA :

.. code-block:: php
   :linenos:

   // Instance concrête:
   $element->setCaptcha(new Zend_Captcha_Figlet());
   // Utilisation d'un nom court :
   $element->setCaptcha('Dumb');

Si vous souhaitez charger votre élément via la configuration, spécifiez soit la clé 'captcha' avec un tableau
contenant la clé 'captcha', soit les clés 'captcha' et 'captchaOptions' :

.. code-block:: php
   :linenos:

   // Utilisation d'une clé captcha :
   $element = new Zend_Form_Element_Captcha('foo', array(
       'label' => "Merci de confirmer que vous êtes humain",
       'captcha' => array(
           'captcha' => 'Figlet',
           'wordLen' => 6,
           'timeout' => 300,
       ),
   ));
   // Utilisation simultanée des clés captcha et captchaOption :
   $element = new Zend_Form_Element_Captcha('foo', array(
       'label' => "Merci de confirmer que vous êtes humain",
       'captcha' => 'Figlet',
       'captchaOptions' => array(
           'captcha' => 'Figlet',
           'wordLen' => 6,
           'timeout' => 300,
       ),
   ));

Le décorateur utilisé est déterminé lors de la récupération de l'adapteur du captcha. Par défaut, le
:ref:`décorateur du captcha <zend.form.standardDecorators.captcha>` est utilisé, mais un adapteur peut spécifier
un décorateur différent via sa méthode ``getDecorator()``.

Comme noté, l'adapteur de captcha lui même agit comme un validateur pour l'élément. De plus, le validateur
NotEmpty n'est pas utilisé, et l'élément est marqué comme requis. Dans la plupart des cas, vous n'aurez besoin
de rien d'autre pour que le captcha soit présent dans votre formulaire.

.. _zend.form.standardElements.checkbox:

Zend_Form_Element_Checkbox
--------------------------

Les cases à cocher HTML vous permettent de retourner une valeur spécifique, mais elles fonctionnent
essentiellement comme des booléens. Lorsque elle est cochée, la valeur de la case à cocher est soumise. Lorsque
la case à cocher n'est pas cochée, rien n'est soumis. En interne, ``Zend_Form_Element_Checkbox`` applique cet
état.

Par défaut, la valeur cochée est '1', et la valeur non cochée est '0'. Vous pouvez spécifier les valeurs en
utilisant respectivement les accesseurs ``setCheckedValue()`` et ``setUncheckedValue()``. En interne, à chaque
fois que vous définissez une valeur, si la valeur fournie correspond à la valeur cochée, alors elle sera
définie, mais toutes autres valeurs aura pour effet que la valeur non cochée sera sélectionnée.

En sus, définir la valeur définit la propriété *checked* de la case à cocher. Vous pouvez la récupérer en
utilisant ``isChecked()`` ou simplement en accédant à la propriété. Utiliser la méthode ``setChecked($flag)``
l'état du flag ainsi que la valeur cochée ou non cochée de l'élément. Veillez à utiliser cette méthode
lorsque vous définissez l'état coché d'un élément case à cocher afin d'être sûr que la valeur est
correctement définie.

``Zend_Form_Element_Checkbox`` utilise le helper de vue 'formCheckbox'. La valeur cochée est toujours utilisé
pour le remplir.

.. _zend.form.standardElements.file:

Zend_Form_Element_File
----------------------

L'élément de formulaire File fournit un mécanisme pour fournir des champs d'upload de fichier à votre
formulaire. Il utilise :ref:`Zend_File_Transfer <zend.file.transfer.introduction>` en interne pour fournir cette
fonctionnalité et le helper de vue *FormFile* ainsi que le décorateur *File* pour afficher l'élément de
formulaire.

Par défaut, il utilise l'adapteur de transfert *Http* qui inspecte le tableau ``$_FILES`` et vous permet
d'attacher des validateurs et des filtres. Les validateurs et les filtres attachés au formulaire sont à leur tour
attachés à l'adapteur de transfert.

.. _zend.form.standardElements.file.usage:

.. rubric:: Utilisation de l'élément de formulaire File

L'explication d'utilisation de l'élément de formulaire File ci-dessous peut sembler ésotérique, mais l'usage
est en fait relativement trivial :

.. code-block:: php
   :linenos:

   $element = new Zend_Form_Element_File('foo');
   $element->setLabel('Upload une image:')
           ->setDestination('/var/www/upload');
   // Fait en sorte qu'il y ait un seul fichier
   $element->addValidator('Count', false, 1);
   // limite à 100K
   $element->addValidator('Size', false, 102400);
   // seulement des JPEG, PNG, et GIFs
   $element->addValidator('Extension', false, 'jpg,png,gif');
   $form->addElement($element, 'foo');

Vous devez aussi vous assurer que le type d'encodage correct est fourni au formulaire ; vous devez utiliser
'multipart/form-data'. Vous pouvez faire cela en définissant l'attribut 'enctype' du formulaire:

.. code-block:: php
   :linenos:

   $form->setAttrib('enctype', 'multipart/form-data');

Après que le formulaire soit validé avec succès, vous devriez recevoir le fichier afin de le stocker dans sa
destination finale en utilisant ``receive()``. De plus, vous pouvez déterminer son emplacement finale en utilisant
``getFileName()``:

.. code-block:: php
   :linenos:

   if (!$form->isValid()) {
       print "Uh oh... erreur de validation";
   }
   if (!$form->foo->receive()) {
       print "Erreur de réception de fichier";
   }
   $location = $form->foo->getFileName();

.. note::

   **Emplacement d'upload par défaut**

   Par défaut, les fichiers sont uploadés dans le répertoire temp du système.

.. note::

   **Valeur de fichier**

   Au sein du *HTTP* un élément fichier n'a aucune valeur. Pour cette raison et pour des raisons de sécurité
   ``getValue()`` retourne seulement le nom du fichier uploadé et non le chemin complet. Si vous avez besoin du
   chemin du fichier, appellez ``getFileName()``, qui retourne à la fois le chemin et le nom du fichier.

Par défaut, le fichier sera automatiquement reçu quand vous appellerez ``getValues()`` sur le formulaire. La
raison derrière ce comportement est que le fichier lui même est la valeur de l'élément fichier.

.. code-block:: php
   :linenos:

   $form->getValues();

.. note::

   Ainsi, un appel supplémentaire de ``receive()`` après avoir appellé ``getValues()`` n'aura aucun effet. De
   même, créer une instance de ``Zend_File_Transfer`` n'aura aucun effet non plus puisqu'il n'y aura plus de
   fichier à recevoir.

Cela dit, parfois vous aurez besoin d'appeller ``getValues()`` sans recevoir le fichier. Vous pouvez l'archiver en
appellant ``setValueDisabled(true)``. Afin de recevoir la véritable valeur de ce flag vous pouvez appeller
``isValueDisabled()``.

.. _zend.form.standardElements.file.retrievement:

.. rubric:: Récupération explicite de fichier

Tout d'abord appellez ``setValueDisabled(true)``.

.. code-block:: php
   :linenos:

   $element = new Zend_Form_Element_File('foo');
   $element->setLabel('Uploadez une image:')
           ->setDestination('/var/www/upload')
           ->setValueDisabled(true);

Désormais le fichier sera reçu lorsque vous appellerez ``getValues()``. Donc vous devez appeller vous même
``receive()`` sur l'élément fichier, ou une instance de ``Zend_File_Transfer``.

.. code-block:: php
   :linenos:

   $values = $form->getValues();
   if ($form->isValid($form->getPost())) {
       if (!$form->foo->receive()) {
           print "Erreur d'upload";
       }
   }

Il ya plusieurs étapes du fichier uploadés qui peuvent être vérifiées avec les méthodes suivantes :

- ``isUploaded()``: Vérifie si l'élément fichier a été uploadé ou non.

- ``isReceived()``: Vérifie si l'élément fichier a déjà été reçu.

- ``isFiltered()``: Vérifie si les filtres ont déjà été appliqué ou non sur l'élément fichier.

.. _zend.form.standardElements.file.isuploaded:

.. rubric:: Vérifier si un fichier optionnel a été uploadé

.. code-block:: php
   :linenos:

   $element = new Zend_Form_Element_File('foo');
   $element->setLabel('Uploader une image:')
           ->setDestination('/var/www/upload')
           ->setRequired(false);
   $element->addValidator('Size', false, 102400);
   $form->addElement($element, 'foo');
   // L'élément fichier foo est optionnel mais quand il est renseigné va là
   if ($form->foo->isUploaded()) {
       // fichier foo donné, faire quelque chose
   }

``Zend_Form_Element_File`` supporte aussi les fichiers multiples. En appellant la méthode ``setMultiFile($count)``
vous pouvez définir, le nombre d'éléments fichier à créer. Ceci vous évite de définir les mêmes réglages
plusieurs fois.

.. _zend.form.standardElements.file.multiusage:

.. rubric:: Définir plusieurs fichiers

Créer un élément multifichier est identique à la création d'un élément unique. Appellez simplement
``setMultiFile()`` après que l'élément soit créé:

.. code-block:: php
   :linenos:

   $element = new Zend_Form_Element_File('foo');
   $element->setLabel('Uploadez une image:')
           ->setDestination('/var/www/upload');
   // s'assure qu'il y a un fichier au minimum, 3 au maximum
   $element->addValidator('Count', false, array('min' => 1, 'max' => 3));
   // Limite à 100K
   $element->addValidator('Size', false, 102400);
   // seulement des JPEG, PNG, et des GIF
   $element->addValidator('Extension', false, 'jpg,png,gif');
   // définit 3 éléments fichiers identiques
   $element->setMultiFile(3);
   $form->addElement($element, 'foo');

Vous avez maintenant 3 éléments d'upload de fichier identiques avec les mêmes paramètres. Pour obtenir le
nombre de fichiers multiples défini, appellez simplement ``getMultiFile()``.

.. note::

   **Eléments de fichier dans un sous formulaire**

   Quand vous l'utilisez dans des sous formulaires, vous devez définir des noms uniques. Par exemple, si vous
   nommez un élément fichier "file" dans le subform1, vous devez un nom différent à tout autre élément
   fichier dans subform2.

   Si il y a deux éléments fichier portant le même nom, le second élément n'est pas affiché ou soumis.

   De plus, les éléments fichiers ne sont pas affichés au sein du sous formulaire. Donc lorsque vous ajouter un
   élément fichier dans un sous formulaire, l'élément sera affiché dans le formulaire principal.

Afin de limiter, vous pouvez spécifier la taille maximum d'un fichier en définissant l'option ``MAX_FILE_SIZE``
sur le formulaire. Quand vous définissez cette valeur en utilisant la méthode ``setMaxFileSize($size)``, elle
sera affiché avec l'élément fichier.

.. code-block:: php
   :linenos:

   $element = new Zend_Form_Element_File('foo');
   $element->setLabel('Uploadez une image:')
           ->setDestination('/var/www/upload')
           ->addValidator('Size', false, 102400) // limit to 100K
           ->setMaxFileSize(102400); // limite la taille de fichier coté client
   $form->addElement($element, 'foo');

.. note::

   **MaxFileSize et Eléments fichier multiple**

   Quand vous utilisez des éléments fichiers multiples dans votre formulaire vous devez définir
   ``MAX_FILE_SIZE`` seulement une fois. La redéfinir écrasera la valeur précédente.

   Notez que c'est aussi le cas lorsque vous utilisez des formulaires multiples.

.. _zend.form.standardElements.hidden:

Zend_Form_Element_Hidden
------------------------

Les éléments cachés injectent des données qui doivent être soumises, mais pas manipulées par l'utilisateur.
``Zend_Form_Element_Hidden`` remplit cette tâche avec le helper de vue 'formHidden'.

.. _zend.form.standardElements.hash:

Zend_Form_Element_Hash
----------------------

Cette élément fournit une proctection contre les attaques CSRF sur les formulaires, en s'assurant que les
données sont soumises par la session utilisateur qui a générée le formulaire et non par un script malveillant.
La protection est réalisée en ajouté un élément de hachage au formulaire et en le vérifiant lors de la
soumission du formulaire.

Le nom de l'élément de hachage doit être unique. Nous recommandons d'utiliser l'option ``salt`` pour l'élément
- deux hachages ayant le même nom mais des salt différent ne causeront pas de collision :

.. code-block:: php
   :linenos:

   $form->addElement('hash', 'no_csrf_foo', array('salt' => 'unique'));

Vous pouvez définir le salt ultérieurement en utilisant la méthode ``setSalt($salt)``.

En interne, l'élément stocke un identifiant unique en utilisant ``Zend_Session_Namespace``, et le vérifie lors
de la soumission (en vérifiant que le TTL n'a pas expiré). Le validateur 'Identical' est ensuite utilisé pour
s'assurer que le hachage soumis correspond au hachage stocké.

Le helper de vue 'formHidden' est utilisé pour rendre l'élément dans le formulaire.

.. _zend.form.standardElements.Image:

Zend_Form_Element_Image
-----------------------

Des images peuvent être utilisées comme éléments de formulaires, et vous pouvez utiliser ces images en tant
qu'éléments graphiques sur les boutons de formulaires.

Les images ont besoin d'une image source. ``Zend_Form_Element_Image`` permet de la spécifier en utilisant
l'accesseur ``setImage()`` (ou la clé de configuration 'imageValue'). Quant la valeur définie pour l'élément
corresponde à *imageValue*, alors l'accesseur ``isChecked()`` retournera ``TRUE``.

Les éléments image utilise le :ref:`décorateur Image <zend.form.standardDecorators.image>` pour le rendu, en
plus des décorateur standard Errors, HtmlTag et Label. Vous pouvez spécifier une balise en option au décorateur
*Image* qui entourera l'élément image.

.. _zend.form.standardElements.multiCheckbox:

Zend_Form_Element_MultiCheckbox
-------------------------------

Souvent, vous pouvez avoir un ensemble de case à cocher apparenté, et vous souhaitez grouper ces résultat. Cela
ressemble beaucoup à :ref:`Multiselect <zend.form.standardElements.multiselect>`, mais au lieu que ce soit une
liste déroulant, vous avez besoin d'afficher des paires case à cocher/valeur.

``Zend_Form_Element_MultiCheckbox`` rend cela simple comme bonjour. Comme tous les éléments qui étendent
l'élément de base Multi, vous pouvez spécifier une liste d'options et les valider simplement à l'aide de cette
même liste. Le helper de vue 'formMultiCheckbox' s'assure qu'elles seront retournées dans un tableau lors la
soumission du formulaire.

Par défaut, cet élément enregistre un validateur *InArray* qui effectue la validation à l'aide des clés du
tableau d'options enregistrées. Vous pouvez désactiver ce comportement, soit en appellant
``setRegisterInArrayValidator(false)``, soit en passant une valeur ``FALSE`` à la clé de configuration
*registerInArrayValidator*.

Vous pouvez manipuler les diverses options de case à cocher en utilisant les méthodes suivantes :

- ``addMultiOption($option, $value)``

- ``addMultiOptions(array $options)``

- ``setMultiOptions(array $options)`` (écrase les options existantes)

- ``getMultiOption($option)``

- ``getMultiOptions()``

- ``removeMultiOption($option)``

- ``clearMultiOptions()``

Pour marquer les éléments cochés, vous devez passer un tableau de valeur à ``setValue()``. Ce qui suit cochera
les valeur "bar" et "bat":

.. code-block:: php
   :linenos:

   $element = new Zend_Form_Element_MultiCheckbox('foo', array(
       'multiOptions' => array(
           'foo' => 'Foo Option',
           'bar' => 'Bar Option',
           'baz' => 'Baz Option',
           'bat' => 'Bat Option',
       );
   ));
   $element->setValue(array('bar', 'bat'));

Notez que même en définissant une valeur unique vous devrez passer un tableau.

.. _zend.form.standardElements.multiselect:

Zend_Form_Element_Multiselect
-----------------------------

Les éléments *select* *XHTML* autorisent un attribut 'multiple', indiquant que plusieurs options peuvent être
sélectionné pour la soumission du formulaire, au lieu d'une seule habituellement.
``Zend_Form_Element_Multiselect`` étend :ref:`Zend_Form_Element_Select <zend.form.standardElements.select>`, et
définit l'attribut *multiple* à 'multiple'. Comme les autres classes qui hétite la classe de base
``Zend_Form_Element_Multi``, vous pouvez manipuler les options du select en utilisant :

- ``addMultiOption($option, $value)``

- ``addMultiOptions(array $options)``

- ``setMultiOptions(array $options)`` (écrase les options existantes)

- ``getMultiOption($option)``

- ``getMultiOptions()``

- ``removeMultiOption($option)``

- ``clearMultiOptions()``

Si un adapteur de traduction est enregistré au niveau du formulaire et/ou de l'élément, les valeurs des options
seront traduites dans le cadre de l'affichage.

Par défaut, cette élément utilise un validateur *InArray* qui effectue sa validation à partir des clés de
tableau des options enregistrées. Vous pouvez désactiver ce comportement, soit en appellant
``setRegisterInArrayValidator(false)``, ou en passant une valeur ``FALSE`` à la clé de configuration
*registerInArrayValidator*.

.. _zend.form.standardElements.password:

Zend_Form_Element_Password
--------------------------

Les éléments mot de passe sont fondamentalement des éléments texte normaux -- à l'exception du fait que vous
ne voulez pas que le mot de passe soumis soit affiché dans les messages d'erreurs ou lorsque le formulaire est
affiché à nouveau.

``Zend_Form_Element_Password`` effectue cela en appellant ``setValueObscured(true)`` sur chaque validateur
(s'assurant ainsi que le mot de passe est dissimulé dans les messages d'erreur de validation), et utilise le
helper de vue 'formPassword' qui n'affiche pas la valeur qui lui est passé).

.. _zend.form.standardElements.radio:

Zend_Form_Element_Radio
-----------------------

Les éléments radio vous permettend de spécifier plusieurs options, parmi lesquelles vous n'avez besoin que d'une
seule. ``Zend_Form_Element_Radio`` étend la classe de base ``Zend_Form_Element_Multi``, vous permettant ainsi de
spécifier un nombre indéfini d'options, et utilise ensuite le helper de vue *formRadio* pour les afficher.

Par défaut, cette élément utilise un validateur *InArray* qui effectue sa validation à partir des clés de
tableau des options enregistrées. Vous pouvez désactiver ce comportement, soit en appellant
``setRegisterInArrayValidator(false)``, ou en passant une valeur ``FALSE`` à la clé de configuration
*registerInArrayValidator*.

Comme tous les éléments étendant la classe de base Multi element, les méthodes suivantes peuvent être utilisé
pour manipuler les options radio affichées :

- ``addMultiOption($option, $value)``

- ``addMultiOptions(array $options)``

- ``setMultiOptions(array $options)`` (écrase les options existantes)

- ``getMultiOption($option)``

- ``getMultiOptions()``

- ``removeMultiOption($option)``

- ``clearMultiOptions()``

.. _zend.form.standardElements.reset:

Zend_Form_Element_Reset
-----------------------

Les boutons de mise à zéro sont typiquement utilisé pour vider un formulaire, et ne font pas partie des données
soumises. Cela dit, comme ils remplissent un rôle dans l'affichage, ils sont inclus dans les éléments standards.

``Zend_Form_Element_Reset`` étend :ref:`Zend_Form_Element_Submit <zend.form.standardElements.submit>`. Ainsi, le
label est utilisé pour l'affichage du bouton et sera traduit, si un adapteur de traduction est présent. Il
utilise seulement les décorateurs 'ViewHelper' et 'DtDdWrapper', puisqu'il ne devrait jamais y avoir de messages
d'erreur pour ces éléments, le label ne sera pas non plus nécessaire.

.. _zend.form.standardElements.select:

Zend_Form_Element_Select
------------------------

Les listes d'options sont une manière habituelle de limiter des choix spécifiques. ``Zend_Form_Element_Select``
vous permet de les générer rapidement et facilement.

Par défaut, cette élément utilise un validateur *InArray* qui effectue sa validation à partir des clés de
tableau des options enregistrées. Vous pouvez désactiver ce comportement, soit en appellant
``setRegisterInArrayValidator(false)``, ou en passant une valeur ``FALSE`` à la clé de configuration
*registerInArrayValidator*.

Comme il étend l'élément de base Multi, les méthodes suivantes peuvent être utilisées pour manipuler les
options du select :

- ``addMultiOption($option, $value)``

- ``addMultiOptions(array $options)``

- ``setMultiOptions(array $options)`` (écrase les options existantes)

- ``getMultiOption($option)``

- ``getMultiOptions()``

- ``removeMultiOption($option)``

- ``clearMultiOptions()``

``Zend_Form_Element_Select`` utilise le helper de vue 'formSelect pour la décoration.

.. _zend.form.standardElements.submit:

Zend_Form_Element_Submit
------------------------

Les boutons Submit sont utilisé pour soumettre un formulaire. Vous pouvez utiliser plusieurs boutons submit ; vous
pouvez utiliser le bouton utilisé pour soumettre le formulaire afin de décider quelle action effectuer avec les
données soumises. ``Zend_Form_Element_Submit`` rend cette décisions simple, en ajoutant une méthode
``isChecked()`` method ; puisqu'un seul élément bouton sera soumis par le formulaire, après avoir rempli ou
validé le formulaire, vous pourrez appeller cette méthode sur chacun des boutons submit afin de déterminer
lequel a été utilisé.

``Zend_Form_Element_Submit`` utilise le label comme "value" du bouton submit, il sera traduit si un adapeur de
traduction est présent. ``isChecked()`` vérifie la valeur soumises avec le label pour déterminer si le bouton a
été utilisé.

Les décorateurs :ref:`ViewHelper <zend.form.standardDecorators.viewHelper>` et :ref:`DtDdWrapper
<zend.form.standardDecorators.dtDdWrapper>` sont utilisé pour rendre cet élément. Aucun décorateur de label
n'est utilisé, puisque le label du bouton est utilisé lors du rendu de l'élément ; de plus, vous n'associerez
aucune erreurs avec l'élément submit.

.. _zend.form.standardElements.text:

Zend_Form_Element_Text
----------------------

De loin le type d'élément de formulaire le plus répandu est l'élément text, celui ci autorise des saisies de
texte limité ; c'est un élément idéal pour la plupart des saisies de données. ``Zend_Form_Element_Text``
utilise simplement le helper de vue 'formText' pour afficher l'élément.

.. _zend.form.standardElements.textarea:

Zend_Form_Element_Textarea
--------------------------

Les Textareas sont utilisé lorsque de grandes quantités de texte sont attendues, et ne limite pas la quantité de
texte soumise (si ce n'est la taille limite fixée par votre serveur ou *PHP*). ``Zend_Form_Element_Textarea``
utilise le helper de vue 'textArea' pour afficher ces éléments, et place la valeur comme contenu de l'élément.


