.. _zend.search.lucene.extending:

Extensibilité
=============

.. _zend.search.lucene.extending.analysis:

Analyse de texte
----------------

La classe ``Zend_Search_Lucene_Analysis_Analyzer`` est utilisé par l'indexeur afin de transformer en segments les
champs texte du document.

Les méthodes ``Zend_Search_Lucene_Analysis_Analyzer::getDefault()`` et
*Zend_Search_Lucene_Analysis_Analyzer::setDefault()* sont utilisées pour récupérer et définir l'analyseur par
défaut.

Vous pouvez assigner votre propre analyseur de texte ou choisir parmi un ensemble d'analyseurs prédéfinis :
``Zend_Search_Lucene_Analysis_Analyzer_Common_Text`` et
``Zend_Search_Lucene_Analysis_Analyzer_Common_Text_CaseInsensitive`` (par défaut). Tout deux interprètent les
segments comme des séquences de lettres. ``Zend_Search_Lucene_Analysis_Analyzer_Common_Text_CaseInsensitive``
convertit tous les segments en minuscule.

Pour changer d'analyseur :

.. code-block:: php
   :linenos:

   Zend_Search_Lucene_Analysis_Analyzer::setDefault(
       new Zend_Search_Lucene_Analysis_Analyzer_Common_Text());
   ...
   $index->addDocument($doc);

La classe ``Zend_Search_Lucene_Analysis_Analyzer_Common`` a été conçu pour être l'ancêtre de tous les
analyseurs définis par l'utilisateur. L'utilisateur doit uniquement définir les méthodes ``reset()`` et
``nextToken()``, qui prennent leur chaîne de caractères depuis la propriété $_input et retournent les segments
un par un (une valeur ``NULL`` indique la fin du flux).

La méthode ``nextToken()`` doit appeler la méthode ``normalize()`` sur chacun des segments. Ce qui vous permet
d'utiliser des filtres de segments avec votre analyseur.

Voici l'exemple d'analyseur personnalisé, qui accepte des mots contenant des chiffres comme terme :



      .. _zend.search.lucene.extending.analysis.example-1:

      .. rubric:: Analyseur de texte personnalisé

      .. code-block:: php
         :linenos:

         /**
          * Voici un analyseur de texte qui traite les mots contenant des chiffres comme
          * un seul terme
          */
         class My_Analyzer extends Zend_Search_Lucene_Analysis_Analyzer_Common
         {
             private $_position;
             /**
              * Remet à Zéro le flux de segments
              */
             public function reset()
             {
                 $this->_position = 0;
             }
             /**
              * API du flux de segmentation
              * Récupère le segment suivant
              * Retourne null à la fin du flux
              *
              * @return Zend_Search_Lucene_Analysis_Token|null
              */
             public function nextToken()
             {
                 if ($this->_input === null) {
                     return null;
                 }
                 while ($this->_position < strlen($this->_input)) {
                     // Saute les espaces
                     while ($this->_position < strlen($this->_input) &&
                            !ctype_alnum( $this->_input[$this->_position] )) {
                         $this->_position++;
                     }
                     $termStartPosition = $this->_position;
                     // lit le segment
                     while ($this->_position < strlen($this->_input) &&
                            ctype_alnum( $this->_input[$this->_position] )) {
                         $this->_position++;
                     }
                     // Segment vide, fin de flux.
                     if ($this->_position == $termStartPosition) {
                         return null;
                     }
                     $token = new Zend_Search_Lucene_Analysis_Token(
                                               substr($this->_input,
                                                      $termStartPosition,
                                                      $this->_position -
                                                      $termStartPosition),
                                               $termStartPosition,
                                               $this->_position);
                     $token = $this->normalize($token);
                     if ($token !== null) {
                         return $token;
                     }
                     // Continue si le segment est sauté
                 }
                 return null;
             }
         }
         Zend_Search_Lucene_Analysis_Analyzer::setDefault(
             new My_Analyzer());



.. _zend.search.lucene.extending.filters:

Filtrage des segments
---------------------

L'analyseur ``Zend_Search_Lucene_Analysis_Analyzer_Common`` offre aussi un mécanisme de filtrage des segments.

La classe ``Zend_Search_Lucene_Analysis_TokenFilter`` fournit une interface abstraites pour ces filtres. Vos
propres filtres devraient étendre cette classe directement ou indirectement.

Chaque filtre personnalisé doit implémenter la méthode ``normalize()`` qui devrait transformer le segment en
entrée ou signaler que le segment courant doit être sauté.

Il y a trois filtres déjà défini dans le sous-paquet d'analyse :

   - ``Zend_Search_Lucene_Analysis_TokenFilter_LowerCase``

   - ``Zend_Search_Lucene_Analysis_TokenFilter_ShortWords``

   - ``Zend_Search_Lucene_Analysis_TokenFilter_StopWords``



Le filtre *LowerCase* filtre est déjà utilisé par défaut par l'analyseur
``Zend_Search_Lucene_Analysis_Analyzer_Common_Text_CaseInsensitive``.

Les filtres *ShortWords* et *StopWords* peuvent être utilisés avec des analyseurs prédéfinis ou personnalisés
comme ceci :

   .. code-block:: php
      :linenos:

      $stopWords = array('a', 'an', 'at', 'the', 'and', 'or', 'is', 'am');
      $stopWordsFilter =
          new Zend_Search_Lucene_Analysis_TokenFilter_StopWords($stopWords);
      $analyzer =
          new Zend_Search_Lucene_Analysis_Analyzer_Common_TextNum_CaseInsensitive();
      $analyzer->addFilter($stopWordsFilter);
      Zend_Search_Lucene_Analysis_Analyzer::setDefault($analyzer);



   .. code-block:: php
      :linenos:

      $shortWordsFilter = new Zend_Search_Lucene_Analysis_TokenFilter_ShortWords();
      $analyzer =
          new Zend_Search_Lucene_Analysis_Analyzer_Common_TextNum_CaseInsensitive();
      $analyzer->addFilter($shortWordsFilter);
      Zend_Search_Lucene_Analysis_Analyzer::setDefault($analyzer);



Le constructeur ``Zend_Search_Lucene_Analysis_TokenFilter_StopWords`` prends un tableau de stop-words en entrée.
Mais les stop-words peuvent aussi être chargé à partir d'un fichier :

   .. code-block:: php
      :linenos:

      $stopWordsFilter = new Zend_Search_Lucene_Analysis_TokenFilter_StopWords();
      $stopWordsFilter->loadFromFile($my_stopwords_file);
      $analyzer =
         new Zend_Search_Lucene_Analysis_Analyzer_Common_TextNum_CaseInsensitive();
      $analyzer->addFilter($stopWordsFilter);
      Zend_Search_Lucene_Analysis_Analyzer::setDefault($analyzer);

Ce fichier doit être un simple fichier texte avec un mot par ligne. Le caractère '#' transforme la ligne en
commentaire.

Le constructeur de la classe ``Zend_Search_Lucene_Analysis_TokenFilter_ShortWords`` a un argument optionnel. Il
s'agit de la longueur maximum de mot, elle est définie par défaut à 2.

.. _zend.search.lucene.extending.scoring:

Algorithme de score
-------------------

Le score d'un document ``d`` pour une requête ``q`` est défini comme suit :

*score(q,d) = sum( tf(t in d) * idf(t) * getBoost(t.field in d) * lengthNorm(t.field in d) ) * coord(q,d) *
queryNorm(q)*

tf(t in d) -``Zend_Search_Lucene_Search_Similarity::tf($freq)``- un facteur de score basé sur la fréquence d'un
terme ou d'une phrase dans un document.

idf(t) -``Zend_Search_Lucene_Search_Similarity::idf($input, $reader)``- un facteur de score pour un terme simple de
l'index spécifié.

getBoost(t.field in d) - le facteur d'impulsion pour le champ du terme.

lengthNorm($term) - la valeur de normalisation pour un champ donné du nombre total de terme contenu dans un champ.
Cette valeur est stockée dans l'index. Ces valeurs, ainsi que celle du champ d'impulsion, sont stocké dans un
index et multipliées par le score de hits par code de recherche sur chaque champ.

La correspondance au sein de champs plus long est moins précise, ainsi l'implémentation de cette méthode
retourne généralement de plus petites valeurs quand numTokens est important, et de plus grandes valeurs lorsque
numTokens est petit.

coord(q,d) -``Zend_Search_Lucene_Search_Similarity::coord($overlap, $maxOverlap)``- un facteur de score basé sur
la fraction de tout les termes de la recherche que le document contient.

La présence d'une grande partie des termes de la requête indique une meilleure correspondance avec la requête,
ainsi les implémentations de cette méthode retourne habituellement de plus grandes valeurs lorsque le ration
entre ces paramètres est grand que lorsque le ratio entre elle est petit.

queryNorm(q) - la valeur de normalisation pour la requête en fonction de la somme des poids au carré de chaque
terme de la requête. Cette valeur est ensuite multipliée par le poids de chacun des termes de la requête.

Ceci n'affecte pas le classement, mais tente plutôt de faire des scores à partir de différentes requêtes
comparables entre elles.

Les algorithmes de score peuvent être personnalisés en définissant votre propre classe de similitude. Pour ce
faire, étendez la classe ``Zend_Search_Lucene_Search_Similarity`` comme défini ci-dessous, puis appelez la
méthode ``Zend_Search_Lucene_Search_Similarity::setDefault($similarity);`` afin de la définir par défaut.

.. code-block:: php
   :linenos:

   class MySimilarity extends Zend_Search_Lucene_Search_Similarity {
       public function lengthNorm($fieldName, $numTerms) {
           return 1.0/sqrt($numTerms);
       }
       public function queryNorm($sumOfSquaredWeights) {
           return 1.0/sqrt($sumOfSquaredWeights);
       }
       public function tf($freq) {
           return sqrt($freq);
       }
       /**
        * Ceci n'est pas encore utilisé. Cela évalue le nombre de correspondance
        * d'expressions vagues, basé sur une distance d'édition.
        */
       public function sloppyFreq($distance) {
           return 1.0;
       }
       public function idfFreq($docFreq, $numDocs) {
           return log($numDocs/(float)($docFreq+1)) + 1.0;
       }
       public function coord($overlap, $maxOverlap) {
           return $overlap/(float)$maxOverlap;
       }
   }
   $mySimilarity = new MySimilarity();
   Zend_Search_Lucene_Search_Similarity::setDefault($mySimilarity);

.. _zend.search.lucene.extending.storage:

Conteneur de stockage
---------------------

La classe abstraite ``Zend_Search_Lucene_Storage_Directory`` définit la fonctionnalité de répertoire.

Le constructeur ``Zend_Search_Lucene`` utilise soit une chaîne soit un objet
``Zend_Search_Lucene_Storage_Directory`` en paramètre.

La classe ``Zend_Search_Lucene_Storage_Directory_Filesystem`` implémente la fonctionnalité de répertoire pour un
système de fichier.

Si une chaîne est utilisé comme paramètre du constructeur ``Zend_Search_Lucene``, le lecteur
(``Zend_Search_Lucene`` object) le considère comme un chemin dans le système de fichier et instancie l'objet
``Zend_Search_Lucene_Storage_Directory_Filesystem``.

Vous pouvez définir votre propre implémentation de répertoire en étendant la classe
``Zend_Search_Lucene_Storage_Directory``.

Les méthodes de ``Zend_Search_Lucene_Storage_Directory``\  :

.. code-block:: php
   :linenos:

   abstract class Zend_Search_Lucene_Storage_Directory {
   /**
    * Ferme le stockage.
    *
    * @return void
    */
   abstract function close();
   /**
    * Crée un nouveau fichier vide dans le répertoire dont le nom est $filename.
    *
    * @param string $name
    * @return void
    */
   abstract function createFile($filename);
   /**
    * Supprime un fichier existant du répertoire.
    *
    * @param string $filename
    * @return void
    */
   abstract function deleteFile($filename);
   /**
    * Retourne true si un fichier portant le nom donné existe.
    *
    * @param string $filename
    * @return boolean
    */
   abstract function fileExists($filename);
   /**
    * Retourne la taille d'un $filename dans le répertoire.
    *
    * @param string $filename
    * @return integer
    */
   abstract function fileLength($filename);
   /**
    * Retourne le timestamp UNIX de la date de modification de $filename.
    *
    * @param string $filename
    * @return integer
    */
   abstract function fileModified($filename);
   /**
    * Renomme un fichier existant dans le répertoire.
    *
    * @param string $from
    * @param string $to
    * @return void
    */
   abstract function renameFile($from, $to);
   /**
    * Définit la date de modification de $filename à la date de maintenant.
    *
    * @param string $filename
    * @return void
    */
   abstract function touchFile($filename);
   /**
    * Retourne un objet Zend_Search_Lucene_Storage_File object pour un $filename
    * donné dans le répertoire
    *
    * @param string $filename
    * @return Zend_Search_Lucene_Storage_File
    */
   abstract function getFileObject($filename);
   }

La méthode ``getFileObject($filename)`` de l'instance ``Zend_Search_Lucene_Storage_Directory`` retourne un objet
``Zend_Search_Lucene_Storage_File``.

La classe abstraite ``Zend_Search_Lucene_Storage_File`` implémente l'abstraction de fichiers et les primitives de
lecture de fichier d'index.

Vous devez aussi étendre ``Zend_Search_Lucene_Storage_File`` dans votre implémentation de répertoire.

Seulement deux méthodes de ``Zend_Search_Lucene_Storage_File`` doivent être surchargées dans votre
implémentation :

.. code-block:: php
   :linenos:

   class MyFile extends Zend_Search_Lucene_Storage_File {
       /**
        * Définit l'indicateur de position du fichier and avance le pointeur
        * de fichier.
        * La nouvelle position, calculé en octets depuis le début du fichier,
        * est obtenu en ajoutant l'offset à la position spécifiée par $whence,
        * dont les valeurs sont définit comme suit :
        * SEEK_SET - Définit la position comme égale aux octets de l'offset.
        * SEEK_CUR - Définit la position à la position courante plus l'offset.
        * SEEK_END - Définit la position à la fin du fichier plus l'offset.
        *(Pour déplacer à une position avant la fin du fichier, vous devrez passer
        * une valeur négative à l'offset.)
        * En cas de succès, retourne 0; sinon, retourne -1
        *
        * @param integer $offset
        * @param integer $whence
        * @return integer
        */
       public function seek($offset, $whence=SEEK_SET) {
           ...
       }
       /**
        * Lit $length octets dans le fichier et avance le pointeur de fichier.
        *
        * @param integer $length
        * @return string
        */
       protected function _fread($length=1) {
           ...
       }
   }


