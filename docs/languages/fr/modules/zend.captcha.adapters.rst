.. _zend.captcha.adapters:

Adaptateurs CAPTCHA
===================

Les adaptateurs suivants sont fournis dans Zend Framework par défaut.

.. _zend.captcha.adapters.word:

Zend_Captcha_Word
-----------------

``Zend_Captcha_Word`` est un adaptateur abstrait qui sert de classe de base pour la plupart des autres adaptateurs
*CAPTCHA*. Il fournit des mutateurs permettant de spécifier la taille du mot le *TTL* de session, l'objet d'espace
de noms de session à utiliser, et la classe d'espace de noms de session à utiliser pour la persistance si vous ne
souhaitez pas utiliser ``Zend_Session_Namespace`` pour la persistance. ``Zend_Captcha_Word`` encapsule toute la
logique de validation.

Par défaut la taille du mot est de 8 caractères, le timeout de session est de 5 minutes et l'objet d'espace de
nom de session utilisé est ``Zend_Session_Namespace`` (avec l'espace de nom ("``Zend_Form_Captcha_<captcha
ID>``").

En plus des méthodes standards fournies par ``Zend_Captcha_Adapter``, ``Zend_Captcha_Word`` propose les méthodes
suivantes :

- ``setWordLen($length)`` et ``getWordLen()`` vous permettent de piloter la taille du "mot" généré, en
  caractères.

- ``setTimeout($ttl)`` et ``getTimeout()`` vous donnent la main sur le temps-de-vie du jeton de session. ``$ttl``
  est exprimé en secondes.

- ``setUseNumbers($numbers)`` et ``getUseNumbers()`` vous permettent de spécifier les chiffres seront considérés
  comme des caractères possibles pour la partie aléatoire ou si seules les lettres seront utilisées.

- ``setSessionClass($class)`` et ``getSessionClass()`` vous permettent de piloter la classe de session, si vous
  désirez utiliser une alternative à ``Zend_Session_Namespace``, ceci dans le but de faire persister le jeton
  *CAPTCHA* en session.

- ``getId()`` retourne l'identifiant du jeton actuel.

- ``getWord()`` retourne le mot généré utilisé avec le *CAPTCHA*. Il sera généré pour vous si aucun n'existe
  déjà.

- ``setSession(Zend_Session_Namespace $session)`` permet d'injecter un objet de session qui sera utilisé pour
  faire persister le jeton de *CAPTCHA*. ``getSession()`` retourne l'objet de session actuellement utilisé.

Tous les *CAPTCHA* Word vous autorisent à passer un tableau d'options au constructeur, ou à ``setOptions()`` (un
objet ``Zend_Config`` peut être utilisé avec ``setConfig()``). Par défaut, les clés **timeout** **wordLen** et
**sessionClass** seront utilisées.

.. note::

   ``Zend_Captcha_Word`` est une classe abstraite et ne peut être utilisée directement.

.. _zend.captcha.adapters.dumb:

Zend_Captcha_Dumb
-----------------

L'adaptateur ``Zend_Captch_Dumb`` propose une chaine aléatoire qui doit être ressaisie, mais inversée. Ce n'est
pas une solution *CAPTCHA* idéale (un robot peut la détourner), il devrait être utilisé comme solution de
remplacement extrême, ou pour les tests. Il étend ``Zend_Captcha_Word``.

.. _zend.captcha.adapters.figlet:

Zend_Captcha_Figlet
-------------------

L'adaptateur ``Zend_Captcha_Figlet`` utilise :ref:`Zend_Text_Figlet <zend.text.figlet>` pour présenter un captcha.
Seuls les caractères alphabétiques sont utilisables.

Les options passées au constructeur le seront pour l'objet :ref:`Zend_Text_Figlet <zend.text.figlet>` que
l'adaptateur va utiliser. Voyez la documentation de :ref:`Zend_Text_Figlet <zend.text.figlet>`\ pour plus
d'informations.

.. _zend.captcha.adapters.image:

Zend_Captcha_Image
------------------

L'adaptateur ``Zend_Captcha_Image`` prend le mot généré et le transforme en image difficile à analyser pour un
programme informatique (robot). Pour cela, il nécessite l'`extension GD`_, compilée avec le support TrueType et
Freetype. Actuellement, l'adaptateur ``Zend_Captcha_Image`` ne génère que des images *PNG*.

``Zend_Captcha_Image`` étend ``Zend_Captcha_Word``, et propose les méthodes additionnelles suivantes :

- ``setExpiration($expiration)`` et ``getExpiration()`` vous autorisent à manipuler le temps maximum que l'image
  *CAPTCHA* doit rester sur le disque. En général, il s'agit d'un temps supérieur à celui de la session. Un
  ramasse-miettes passe régulièrement à chaque instanciation de l'objet *CAPTCHA* Image : il détruit les images
  arrivées à expiration. La période d'expiration doit être exprimée en secondes.

- ``setGcFreq($gcFreq)`` et ``getGcFreg()`` vous permettent de manipuler la fréquence de collecte du
  ramasse-miettes des images. Le ramasse-miettes passera à une fréquence de ``1/$gcFreq``. Par défaut 1 / 100,
  soit toutes les 100 requêtes.

- ``setFont($font)`` et ``getFont()`` vous donnent le moyen de manipuler la police que vous souhaitez utiliser.
  ``$font`` doit indiquer le chemin complet vers la police à utiliser pour générer le *CAPTCHA*. Une exception
  sera levée si vous ne spécifiez pas ce paramètre.

- ``setFontSize($fsize)`` et ``getFontSize()`` servent pour spécifier et récupérer la taille de la police à
  utiliser (en pixels) pour générer l *CAPTCHA*. Par défaut : 24px.

- ``setHeight($height)`` et ``getHeight()`` servent pour spécifier et récupérer la hauteur de la police à
  utiliser (en pixels) pour générer le *CAPTCHA*. Par défaut : 50px.

- ``setWidth($width)`` et ``getWidth()`` servent pour spécifier et récupérer la largeur de la police à utiliser
  (en pixels) pour générer le *CAPTCHA*. Par défaut : 200px.

- ``setImgDir($imgDir)`` et ``getImgDir()`` vous permettent de manipuler le dossier dans lequel les images
  *CAPTCHA* générées seront stockées. Par défaut, il s'agit de "``./images/captcha/``", qui devrait être pris
  relativement au fichier de bootstrap du site.

- ``setImgUrl($imgUrl)`` et ``getImgUrl()`` vous donnent le moyen de manipuler le chemin relatif à utiliser pour
  la balise *HTML* servant à afficher l'image du *CAPTCHA*. Par défaut, il s'agit de "``/images/captcha/``".

- ``setSuffix($suffix)`` et ``getSuffix()`` vous donnent la main sur le suffixe à utiliser pour le nom du fichier
  de l'image générée par le *CAPTCHA*. Il s'agit par défaut de "``.png``". Note : changer ceci ne changera pas
  le type de l'image générée.

- ``setDotNoiseLevel($level)`` et ``getDotNoiseLevel()``, avec ``setLineNoiseLevel($level)`` et
  ``getLineNoiseLevel()``, vous permettent de contrôler le niveau de bruit sous forme de points et de lignes que
  l'image va contenir. Chaque unité de ``$level`` produit un point ou une ligne aléatoire. Les valeurs par
  défaut sont 100 points et 5 lignes. Le bruit est ajouté deux fois : avant et après la transformation de
  l'image.

Toutes les options ci-dessus peuvent aussi être passées en constructeur. Supprimer la partie "set" de leur
méthodes, et passez leur première lettre en minuscule pour avoir les clés du tableau d'options que le
constructeur utilise. ("suffix", "height", "imgUrl", etc...).

.. _zend.captcha.adapters.recaptcha:

Zend_Captcha_ReCaptcha
----------------------

L'adaptateur ``Zend_Captcha_ReCaptcha`` utilise :ref:`Zend_Service_ReCaptcha <zend.service.recaptcha>` pour
générer des *CAPTCHA*. Les méthodes suivantes lui sont propres :

- ``setPrivKey($key)`` et ``getPrivKey()`` vous permettent de gérer la clé privée utilisée avec le service
  ReCaptcha. Cette clé doit être spécifiée en constructeur, mais peut être ensuite modifiée.

- ``setPubKey($key)`` et ``getPubKey()`` vous permettent de gérer la clé publique utilisée avec le service
  ReCaptcha. Cette clé doit être spécifiée en constructeur, mais peut être ensuite modifiée.

- ``setService(Zend_Service_ReCaptcha $service)`` et ``getService()`` vous permettent d'interagir directement avec
  l'objet service ReCaptcha utilisé par l'adaptateur.



.. _`extension GD`: http://php.net/gd
