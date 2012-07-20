.. _zend.currency.options:

Options des monnaies
====================

En fonction de vos besoins, certaines options peuvent être passées à l'instanciation, elles ont toutes des
valeurs par défaut. Voici quelques exemples:

- **Symbole des monnaies, noms courts ou noms**:

  ``Zend_Currency`` connait tous les noms, abbréviations et signes des monnaies mais il peut s'avérer nécessaire
  de devoir remplacer la représentation visuelle d'une monnaie.

- **Position du symbole de monnaie**:

  La position du symbole de la monnaie est défini automatiquement. Il peut cependant être précisé manuellement.

- **Script**:

  Vous pouvez définit les scripts à utiliser pour le rendu des chiffres des monnaies. Vous trouverez des détails
  sur les scripts dans le chapitre de ``Zend_Locale`` concernant :ref:`Les systèmes de conversion des nombres
  <zend.locale.numbersystems>`.

- **Formatter les nombres**:

  Le nombre qui représente la somme est par défaut formatté via les valeurs que fournit la locale en cours. Par
  exemple, la virgule ',' est utilisée pour séparer les milliers dans la langue anglaise, mais en français il
  s'agit du séparateur des décimales.

La liste suivante précise les options disponibles qui peuvent être passées en constructeur ou via la méthode
``setFormat()``, sous forme de tableau.

- **currency**: Précise l'abbréviation.

- **display**: Définit la partie de la monnaie utilisée pour le rendu visuel. Il y a 4 représentations
  disponibles, précisées dans :ref:`ce tableau <zend.currency.description>`.

- **format**: Précise le format pour représenter les nombres. Ce format inclut par exemple le séparateur des
  milliers. Vous pouvez vous reposer sur la locale en passant un identifiant de locale, ou définir un format
  manuellement. Si aucun format n'est précisé, la locale dans ``Zend_Currency`` sera utilisée. Voyez :ref:`le
  chapitre sur le formattage des nombres <zend.locale.number.localize.table-1>`.

- **locale**: Définit la locale à utiliser pour cette monnaie. Elle sera utilisée pour les paramètres par
  défaut si il faut les utiliser. Notez que si vous ne passez pas de locale vous-même, elle sera alors détectée
  de manière automatique, ce qui pourrait créer des problèmes.

- **name**: Définit le nom long de la monnaie.

- **position**: Définit la position de la monnaie. Pour plus d'informations, voyez :ref:`cette section
  <zend.currency.position>`.

- **precision**: Définit la précision à utiliser pour représenter la monnaie. La valeur par défaut dépend de
  la locale et vaut la plupart du temps **2**.

- **script**: Indique le script à utiliser pour représenter les chiffres. Souvent par défaut **'Latn'**, qui
  inclut les chiffres de 0 à 9. Les autres scripts comme 'Arab' utilisent d'autres chiffres. Voyez :ref:`Le
  chapitre sur les système numérraires <zend.locale.numbersystems>` pour plus de détails.

- **service**: Définit le service de change à consulter lors de conversions entre monnaies.

- **symbol**: Précise le symbole de la monnaie.

- **value**: Indique le montant (la valeur de la monnaie). S'utilise avec l'option ``service``.

Beaucoup d'options sont donc ajustables, et la plupart trouvent leurs valeurs par défaut dans les représentations
normalisées de la monnaie utilisée.


