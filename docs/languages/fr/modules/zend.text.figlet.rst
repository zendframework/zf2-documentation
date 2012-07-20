.. _zend.text.figlet:

Zend_Text_Figlet
================

``Zend_Text_Figlet`` est un composant qui permet aux développeurs de créer des textes dénommés FIGlet. Un texte
FIGlet test une chaîne de caractères, qui est représenté en "ASCII-art". FIGlet utilise une format de police
spécial , nommée FLT (FigLet Font). Par défaut, une police standard est fourni avec ``Zend_Text_Figlet``, mais
vous pouvez ajouter des polices additionnels à `http://www.figlet.org`_.

.. note::

   **Polices compressée**

   ``Zend_Text_Figlet`` supporte les polices compressées en gzip. Ceci veut dire que vous pouvez prendre un
   fichier *.flf* et le gzipper. Pour permettre à ``Zend_Text_Figlet`` de les reconnaître, les polices gzippées
   doivent avoir l'extension *.gz*. De plus, pour pouvoir utiliser les polices compressées, vous devez activer
   l'extension GZIP de *PHP*.

.. note::

   **Encodage**

   ``Zend_Text_Figlet`` considère que vos chaînes sont encodées en UTF-8 par défaut. Si ce n'est pas le cas,
   vous pouvez fournir le type d'encodage des caractères en tant que second paramètre à la méthode
   ``render()``.

Il existe plusieurs options pour un FIGlet. Quand vous instanciez ``Zend_Text_Figlet``, vous pouvez les fournir
sous la forme d'un tableau ou d'un objet ``Zend_Config``.

   - *font*: défini la police utilisée pour le rendu. Par défaut la police incorporé sera utilisée.

   - *outputWidth*: défini la largeur maximum de la chaîne résultat. Ceci est utilisé pour le retour à la
     ligne automatique ainsi que pour la justification. Attention cependant à de trop petites valeurs, qui
     pourraient induire un comportement indéfini. La valeur par défaut est 80.

   - *handleParagraphs*: un booléen qui indique, comment les nouvelles lignes sont gérées. Réglé à ``TRUE``,
     les nouvelles lignes uniques sont ignorées et traitées comme un espace unique. Seules des nouvelles lignes
     multiples seront gérées comme telles. La valeur par défaut est ``FALSE``.

   - *justification*: peut être une des valeurs de type ``Zend_Text_Figlet::JUSTIFICATION_*``. Il existe
     ``JUSTIFICATION_LEFT``, ``JUSTIFICATION_CENTER`` et ``JUSTIFICATION_RIGHT``. La justification par défaut est
     défini par la valeur de *rightToLeft*.

   - *rightToLeft*: défini la direction d'écriture du texte. Peut être
     ``Zend_Text_Figlet::DIRECTION_LEFT_TO_RIGHT`` ou ``Zend_Text_Figlet::DIRECTION_RIGHT_TO_LEFT``. Par défaut le
     réglage du fichier de police est utilisé. Quand aucune justification n'est définie, un texte écrit de
     droite à gauche est automatiquement aligné à droite.

   - *smushMode*: un entier qui définit comme chaque caractère est fusionné avec les autres. Peut être la somme
     de multiple valeurs de type ``Zend_Text_Figlet::SM_*``. Il existe les modes de fusion suivant : SM_EQUAL,
     SM_LOWLINE, SM_HIERARCHY, SM_PAIR, SM_BIGX, SM_HARDBLANK, SM_KERN et SM_SMUSH. Une valeur de 0 ne désactive
     pas entièrement la fusion, mais force la valeur SM_KERN, tandis que la valeur de -1 la désactive. Une
     explication des différents modes de fusion peut être trouvé `ici`_. Par défaut le réglage de la police
     est utilisé. L'option du mode de fusion est normalement seulement utilisé par les concepteurs de police
     testant les différents mode de disposition d'une nouvelle police.



.. _zend.text.figlet.example.using:

.. rubric:: Utilisation Zend_Text_Figlet

Cet exemple illustre une utilisation basique de ``Zend_Text_Figlet`` pour créer une texte FIGlet simple :

.. code-block:: php
   :linenos:

   $figlet = new Zend_Text_Figlet();
   echo $figlet->render('Zend');

En considérant que vous utilisez une police à espacement fixe, vous obtiendrez quelque chose comme ceci :

.. code-block:: text
   :linenos:

     ______    ______    _  __   ______
    |__  //   |  ___||  | \| || |  __ \\
      / //    | ||__    |  ' || | |  \ ||
     / //__   | ||___   | .  || | |__/ ||
    /_____||  |_____||  |_|\_|| |_____//
    `-----`'  `-----`   `-` -`'  -----`



.. _`http://www.figlet.org`: http://www.figlet.org/fontdb.cgi
.. _`ici`: http://www.jave.de/figlet/figfont.txt
