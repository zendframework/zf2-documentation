.. _zend.validate.set.barcode:

Barcode
=======

``Zend_Validate_Barcode`` permet de vérifier si une donnée représente un code barres.

``Zend_Validate_Barcode`` supporte de multiples standards de codes à barres et peut être étendu pour les codes
barres propriétaires. Les formats suivants sont supportés:

- **CODE25**: Aussi appelé "two of five" ou "Code25 Industrial".

  Ce code n'a pas de limite de taille. Il supporte les chiffres et le dernier chiffre peut être une somme de
  contrôle optionnelle calculée sur un modulo 10. Ce standard est très vieux et plus trop utilisé. Les cas
  d'utilisations classiques sont l'industrie

- **CODE25INTERLEAVED**: Aussi appelé "Code 2 of 5 Interleaved".

  C'est une variante de CODE25. Il n'a pas de limite de taille mais il doit contenir un nombre de caractères pair.
  Il supporte uniquement les chiffres et le dernier chiffre peut être une somme de contrôle optionnelle calculée
  sur un modulo 10. Il est utilisé au travers le monde et typiquement dans l'industrie / la distribution.

- **CODE39**: CODE39 est un des codes les plus vieux.

  Ce code a une taille variable. Il supporte les chiffres, les lettres majuscules, et 7 caractères spéciaux comme
  l'espace, le point ou le signe dollar. Il peut posséder optionnellement une somme de contrôle calculée sur un
  modulo 43. Il est utilisé dans le monde, dans l'industrie.

- **CODE39EXT**: CODE39EXT est une extension de CODE39.

  Ce code à barres a les mêmes propriétés que CODE39. Aussi, il autorise l'utilisation de tous les caractères
  ASCII (128). Ce standard est très utilisé dans l'industrie, dans le monde.

- **CODE93**: CODE93 est le successeur de CODE39.

  Ce code a une taille variable. Il supporte les chiffres, les lettres de l'alphabet et 7 caractères spéciaux. Il
  possède optionnellement une somme de contrôle à 2 caractères calculée sur un modulo 47. Ce standard produit
  un code plus dense que CODE39 et est plus sécurisé.

- **CODE93EXT**: CODE93EXT est une extension de CODE93.

  Ce type de code à barres a les mêmes propriétés que CODE93. Aussi, il permet l'utilisation des 128
  caractères du jeu ASCII. Ce standard est utilisé dans le monde et principalement dans l'industrie.

- **EAN2**: EAN est un raccourci de "European Article Number".

  Ces codes ont deux caractères. Seuls les chiffres sont supportés et ils n'ont pas de somme de contrôle. Ce
  standard est utilisé principalement en plus de EAN13 (ISBN) sur les livres imprimés.

- **EAN5**: EAN est un raccourci pour "European Article Number".

  Ce code barres doit comporter 5 caractères. Il ne supporte que les chiffres et ne possède pas de somme de
  contrôle. Ce standard est principalement utilisé en plus de EAN13 (ISBN) pour l'impression de livres.

- **EAN8**: EAN est un raccourci pour "European Article Number".

  Ce code barres se compose de 7 ou 8 caractères. Il supporte les chiffres uniquement. Lorsqu'il est à 8
  caractères, il inclut une somme de contrôle. Ce standard est utilisé dans le monde mais pour des besoins
  limités. On le trouve pour les petits articles où un code barres plus long n'aurait pas pu être imprimé.

- **EAN12**: EAN est un raccourci pour "European Article Number".

  Ce code doit faire 12 caractères de long. Il ne supporte que les chiffres et le dernier chiffre est une somme de
  contrôle calculée sur un modulo 10. C'est un code utilisé aux Etats-Unis et courant sur le marché. Il a été
  dépassé par EAN13.

- **EAN13**: EAN est un raccourci pour "European Article Number".

  Ce code doit faire 13 caractères de long, il ne supporte que les chiffres et le dernier chiffre est une somme de
  contrôle calculée sur un modulo 10. Ce standard est utilisé dans le monde et est très commun sur le marché.

- **EAN14**: EAN est un raccourci pour "European Article Number".

  Ce code fait 14 caractères de longueur et ne supporte que les chiffres. Le dernier chiffre représente la somme
  de contrôle calculée sur un modulo 10. Ce code barres est utilisé dans le monde pour la distribution. C'est le
  successeur de EAN13.

- **EAN18**: EAN est un raccourci pour "European Article Number".

  Ce code fait 18 caractères de longueur et ne supporte que les chiffres. Le dernier chiffre représente la somme
  de contrôle calculée sur un modulo 10. Ce code barres est utilisé pour identifier les conteneur d'envoi dans
  le transport.

- **GTIN12**: GTIN est le raccourci de "Global Trade Item Number".

  Ce code utilise le même standard que EAN12 et est son successeur. Il est utilisé paticulièrement aux
  Etats-Unis.

- **GTIN13**: GTIN est le raccourci de "Global Trade Item Number".

  Ce code utilise le même standard que EAN13 et est son successeur. Il est utilisé dans le monde entier par
  l'industrie.

- **GTIN14**: GTIN est le raccourci de "Global Trade Item Number".

  Ce code utilise le même standard que EAN14 et est son successeur. Il est utilisé dans le monde entier par
  l'industrie.

- **IDENTCODE**: Identcode est utilisé par Deutsche Post et DHL. C'est un cas particulier de Code25.

  Ce code fait 12 caractères de longueur et ne supporte que les chiffres. Le dernier chiffre représente la comme
  de contrôle calculée modulo 10. Ce code barres est utilisé principalement par les entreprises DP et DHL.

- **INTELLIGENTMAIL**: Intelligent Mail est utilisé par les services postaux.

  Ce code fait 20, 25, 29 ou 31 caractères de longueur. Il ne support que les chiffres et ne contient pas de somme
  de contrôle. Il est le successeur de *PLANET* et *POSTNET*. Il est utilisé principalement dans les services
  postaux aux Etats-Unis.

- **ISSN**: *ISSN* est l'abréviation de International Standard Serial Number.

  Ce code a une longueur de 8 ou 13 caractères. Il ne supporte que les chiffres et le dernier chiffre représente
  la somme de contrôle calculée sur un modulo 11. Il est utilisé dans le print à travers le monde.

- **ITF14**: ITF14 est l'implémentation GS1 de Interleaved Two of Five bar code.

  Ce code est une implémentation particulière de Interleaved 2 of 5. Il doit mesurer 14 caractères de long et
  est basé sur GTIN14. Il ne contient que des chiffres et le dernier chiffre est une somme de contrôle calculée
  sur un modulo 10. Il est utilisé dans le monde dans la distribution.

- **LEITCODE**: Leitcode est utilisé par Deutsche Post et DHL. C'est un cas particulier de Code25.

  Ce code mesure 14 caractères de longueur et ne supporte que les chiffres. Le dernier chiffre est une somme de
  contrôle calculée sur un modulo 10. Il est principalement utilisé par les entreprises DP et DHL.

- **PLANET**: Planet est l'abréviation de Postal Alpha Numeric Encoding Technique.

  Ce code fait 12 ou 14 caractères de long. Il ne supporte que les chiffres et le dernier chiffre est une somme de
  contrôle. Ce code barres est utilisé principalement dans les services postaux des Etats-Unis.

- **POSTNET**: Postnet est utilisé par le service des Postes des Etats-Unis.

  Ce code fait 6, 7, 10 ou 12 caractères. Il ne supporte que les chiffres et le dernier chiffre est une somme de
  contrôle. Ce code barres est utilisé dans les services postaux aux Etats-Unis principalement.

- **ROYALMAIL**: Royalmail est utilisé par Royal Mail.

  Ce code n'a pas de taille précise. Il supporte les chiffres, les lettres majuscules et le dernier caractère est
  une somme de contrôle. Ce standard est utilisé par Royal Mail pour le service Cleanmail. Il est aussi appelé
  *RM4SCC*.

- **SSCC**: SSCC est un raccourci pour "Serial Shipping Container Code".

  Ce code est une variante de EAN, il doit faire 18 caractères de long et ne supporte que les chiffres. Le dernier
  chiffre doit être la somme de contrôle qui est calculée sur un modulo 10. Ce code est utilisé principalement
  dans le transport.

- **UPCA**: UPC est le raccourci de "Univeral Product Code".

  Ce code a précédé EAN13. Il doit faire 12 caractères et ne supporte que les chiffres. Le dernier chiffre est
  une somme de contrôle calculée sur un modulo 10. Ce code barres est utilisé aux Etats-Unis.

- **UPCE**: UPCE est une variante simplifié et plus courte de UPCA.

  Il peut faire 6, 7 ou 8 caractères et ne supporte que les chiffres. Lorsqu'il fait 8 caractères, il inclut une
  somme de contrôle calculée sur un modulo 10. Ce code barres est utilisé sur de petits produits sur lesquels
  UPCA ne pourrait pas tenir.

.. _zend.validate.set.barcode.options:

Options supportées par Zend_Validate_Barcode
--------------------------------------------

Les options suivantes sont supportées par ``Zend_Validate_Barcode``:

- **adapter**: Affecte l'adaptateur de code barres à utiliser. La liste des adaptateurs est donnée ci-dessus. Si
  vous voulez préciser un adaptateur personnalisé, le nom complet de la classe est requis.

- **checksum**: ``TRUE`` si oui ou non utiliser une somme de contrôle. Notez que certains adaptateurs ne
  supportent pas un telle option.

- **options**: Affecte des options personnalisées pour un adaptateur personnalisé.

.. _zend.validate.set.barcode.basic:

Utilisation classique
---------------------

Pour valider si une chaine est un code barres, vous devez juste connaitre son type. Voyez l'exemple suivant pour un
EAN13:

.. code-block:: php
   :linenos:

   $valid = new Zend_Validate_Barcode('EAN13');
   if ($valid->isValid($input)) {
       // input semble être valide
   } else {
       // input est invalide
   }

.. _zend.validate.set.barcode.checksum:

Somme de contrôle optionnelle
-----------------------------

Certains codes barres proposent une somme de contrôle. Ils peuvent être valides sans cette somme mais si vous
préciser celle-la alors elle devra être validée. Par défaut la somme de contrôle n'est pas activée. En
utilisant l'option ``checksum`` vous pouvez indiquer si oui ou non la somme de contrôle doit être vérifiée.

.. code-block:: php
   :linenos:

   $valid = new Zend_Validate_Barcode(array(
       'adapter'  => 'EAN13',
       'checksum' => false,
   ));
   if ($valid->isValid($input)) {
       // input semble être valide
   } else {
       // input est invalide
   }

.. note::

   **Sécurité moindre en désactivant la validation de la somme de contrôle**

   En désactivant la validation de la somme de contrôle vous réduirez la sécurité du code à barres. Aussi
   veuillez noter que si vous désactiver ce contrôle pour des codes l'utilisant vous risqueriez de considérer
   comme valides des codes barres qui ne le sont pas en réalité.

.. _zend.validate.set.barcode.custom:

Ecrire des validateurs personnalisés
------------------------------------

Vous pouvez créer vos propres validateurs pour ``Zend_Validate_Barcode``; ce qui est nécessaire si vous traitez
des codes barres propriétaires. Vous aurez alors besoin des informations suivantes.

- **Length**: La taille du code barres. Peut être une des valeur suivantes:

  - **Integer**: Une valeur plus grande que zéro qui définit exactement le nombre de caractères du code barres.

  - **-1**: Aucune limite de taille pour ce code barres.

  - **"even"**: La taille du code barres doit être un nombre de caractères pair.

  - **"odd"**: La taille du code barres doit être un nombre de caractères impair.

  - **array**: Un tableau de valeurs entières. La taille du code barres doit être exactement égale à une des
    valeurs dans le tableau.

- **Characters**: Une chaine qui contient tous les caractères autorisés pour ce code barres. La valeur entière
  spéciale 128 est autorisée ici, elle signifie "les 128 premiers caractères du jeu ASCII".

- **Checksum**: Une chaine utilisée comme callback pour valideer la somme de contrôle.

Votre validateur de code à barres personnalisé doit étendre ``Zend_Validate_Barcode_AdapterAbstract`` ou
implémenter Zend_Validate_Barcode_AdapterInterface.

Comme exemple, créons un validateur qui utilise un nombre pair de caractères pouvant être des chiffres et les
lettres 'ABCDE'. Une somme de contrôle sera aussi calculée.

.. code-block:: php
   :linenos:

   class My_Barcode_MyBar extends Zend_Validate_Barcode_AdapterAbstract
   {
       protected $_length     = 'even';
       protected $_characters = '0123456789ABCDE';
       protected $_checksum   = '_mod66';

       protected function _mod66($barcode)
       {
           // effectuer de la validation et retourner un booléen
       }
   }

   $valid = new Zend_Validate_Barcode('My_Barcode_MyBar');
   if ($valid->isValid($input)) {
       // input semble valide
   } else {
       // input est invalide
   }


