.. _zend.search.lucene.extending:

Uitbreidbaarheid
================

.. _zend.search.lucene.extending.analysis:

Tekst analysator
----------------

De *Zend_Search_Lucene_Analysis_Analyzer* klasse wordt gebruikt door de indexer om tekstvelden van het document van
tokens te voorzien.

De *Zend_Search_Lucene_Analysis_Analyzer::getDefault()* en *Zend_Search_Lucene_Analysis_Analyzer::setDefault()*
methodes worden gebruikt om de standaard analysator te verkrijgen of te zetten.

Je kan dus je eigen tekst analysator aanwijzen of er één kiezen uit de aangeboden set van analysators:
*Zend_Search_Lucene_Analysis_Analyzer_Common_Text* en
*Zend_Search_Lucene_Analysis_Analyzer_Common_Text_CaseInsensitive* (standaard). Beiden interpreteren tokens als een
opeenvolging van letters. *Zend_Search_Lucene_Analysis_Analyzer_Common_Text_CaseInsensitive* past tokens aan naar
kleine letters.

Om tussen analysatoren te wisselen kan je de volgende code gebruiken:

.. code-block::
   :linenos:
   <?php

   Zend_Search_Lucene_Analysis_Analyzer::setDefault(
       new Zend_Search_Lucene_Analysis_Analyzer_Common_Text());
   ...
   $index->addDocument($doc);

   ?>
De *Zend_Search_Lucene_Analysis_Analyzer_Common* is ontworpen om de parent van alle door gebruikers gedefinieerde
analysatoren te zijn. De gebruiker zou alleen de *tokenize()* methode moeten schrijven, die een string als input
data moet aanvaarden en een array van tokens moet terugsturen.

De *tokenize()* methode zou de *normalize()* methode op alle tokens moeten toepassen. Dit laat toe token filters te
gebuiken met jouw analysator.

Hier is een voorbeeld van een zelfgemaakte analysator, welke woorden met cijfers als termen aanvaardt:

   .. rubric:: Custom tekst Analysator

   .. code-block::
      :linenos:
      <?php
      /** Dit is een zelfgemaakte tekst analysator, die woorden met cijfers als een enkele term beschouwt */


      /** Zend_Search_Lucene_Analysis_Analyzer_Common */
      require_once 'Zend/Search/Lucene/Analysis/Analyzer/Common.php';

      class My_Analyzer extends Zend_Search_Lucene_Analysis_Analyzer_Common
      {
          /**
           * Tekst van termtokens voorzien
           * Geeft een array van Zend_Search_Lucene_Analysis_Token objecten terug
           *
           * @param string $data
           * @return array
           */
          public function tokenize($data)
          {
              $tokenStream = array();

              $position = 0;
              while ($position < strlen($data)) {
                  // spaties overslaan
                  while ($position < strlen($data) && !ctype_alpha($data{$position}) && !ctype_digit($data{$position})) {
                      $position++;
                  }

                  $termStartPosition = $position;

                  // token lezen
                  while ($position < strlen($data) && (ctype_alpha($data{$position}) || ctype_digit($data{$position}))) {
                      $position++;
                  }

                  // Leeg token, einde van de stream.
                  if ($position == $termStartPosition) {
                      break;
                  }

                  $token = new Zend_Search_Lucene_Analysis_Token(substr($data,
                                                   $termStartPosition,
                                                   $position-$termStartPosition),
                                            $termStartPosition,
                                            $position);
                  $tokenStream[] = $this->normalize($token);
              }

              return $tokenStream;
          }
      }

      Zend_Search_Lucene_Analysis_Analyzer::setDefault(
          new My_Analyzer());

      ?>


.. _zend.search.lucene.extending.scoring:

Score Algorithmes
-----------------

De score van een query ``q`` voor document ``d`` is als volgt gedefinieerd:

*score(q,d) = sum( tf(t in d) * idf(t) * getBoost(t.field in d) * lengthNorm(t.field in d) ) * coord(q,d) *
queryNorm(q)*

tf(t in d) -*Zend_Search_Lucene_Search_Similarity::tf($freq)*- een score factor gebaseerd op de frequentie van een
term of zin in een document.

idf(t) -*Zend_Search_Lucene_Search_SimilaritySimilarity::tf($term, $reader)*- een score factor van een eenvoudige
term voor de gespecificeerde index.

getBoost(t.field in d) - boost factor voor het termveld.

lengthNorm($term) - de normalisatiewaarde voor een veld, gegeven het totaal aantal termen in een veld. Deze waarde
wordt opgeslagen met de index. Deze waarden, samen met de veldboosts, worden opgeslaan in een index en
vermenigvuldigd in scores door de zoekcode voor hits op elk veld.

Overeenkomsten op langere velden zijn minder precies, dus geven implementaties van deze methode meestal kleinere
waarden terug als numTokens groot is, en grotere waarden als numTokens klein is.

coord(q,d) -*Zend_Search_Lucene_Search_Similarity::coord($overlap, $maxOverlap)*- een score factor gebaseerd op de
fractie van alle query termen dat een document bevat.

De aanwezigheid van een groot deel van de query termen duidt een betere overeenkomst met de query aan, dus zullen
implementaties van deze methode meestal grotere waarden teruggeven wanneer de ratio tussen deze parameters groot is
en kleinere waarden wanneer de ratio ertussen klein is.

queryNorm(q) - de normalizatiewaarde voor een query gegeven de som van de gewichten van elk van de querytermen in
het vierkant. Het gewicht van elke query term wordt dan vermenigvuldigd met deze waarde.

Dit beïnvloedt het ordenen niet, maar probeert enkel scores van verschillende queries vergelijkbaar te maken.

Het scoring algoritme kan verpersoonlijkt worden door je eigen Similarity klasse te maken. Om dit te doen moet je
de Zend_Search_Lucene_Search_Similarity klasse uitbreiden zoals hierna is gedefinieerd, en dan de
*Zend_Search_Lucene_Search_Similarity::setDefault($similarity);* methode gebruiken om het tot standaard te zetten.

.. code-block::
   :linenos:
   <?php

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
        * Wordt nu niet gebruikt. Berekent het aandeel van een slordige zinovereenkomst,
        * gebaseerd op een edit afstand.
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

   ?>
.. _zend.search.lucene.extending.storage:

Opslag containers
-----------------

Een abstracte klasse Zend_Search_Lucene_Storage_Directory definieert mapfunctionaliteit.

De Zend_Search_Lucene constructor gebruikt ofwel een string of een Zend_Search_Lucene_Storage_Directory object als
input.

De Zend_Search_Lucene_Storage_Directory_Filesystem klasse implementeert mapfunctionaliteit voor het bestandssyteem.

Indien een string werd opgegeven als input voor de Zend_Search_Lucene constructor, zal de indexlezer
(Zend_Search_Lucene object) het beschouwen als een bestandssysteempad en zelf een
Zend_Search_Lucene_Storage_Directory_Filesystem object instantiëren.

Je kan je eigen implementatiemap definiëren door de Zend_Search_Lucene_Storage_Directory klasse uit te breiden.

Zend_Search_Lucene_Storage_Directory methodes:

.. code-block:: php
   :linenos:
   <?php

   abstract class Zend_Search_Lucene_Storage_Directory {
   /**
    * Sluit de opslag.
    *
    * @return void
    */
   abstract function close();


   /**
    * Maakt een nieuw, leeg bestand in de map met gegeven $filename.
    *
    * @param string $name
    * @return void
    */
   abstract function createFile($filename);


   /**
    * Verwijdert een bestaande $filename uit de map.
    *
    * @param string $filename
    * @return void
    */
   abstract function deleteFile($filename);


   /**
    * Geeft true terug indien een bestand met gegeven $filename bestaat.
    *
    * @param string $filename
    * @return boolean
    */
   abstract function fileExists($filename);


   /**
    * Geeft de lengte terug van een bestand $filename in de map.
    *
    * @param string $filename
    * @return integer
    */
   abstract function fileLength($filename);


   /**
    * Geeft de UNIX timestamp terug van de laatste wijziging van $filename.
    *
    * @param string $filename
    * @return integer
    */
   abstract function fileModified($filename);


   /**
    * Hernoemt een bestaand bestand in de map.
    *
    * @param string $from
    * @param string $to
    * @return void
    */
   abstract function renameFile($from, $to);


   /**
    * Zet de gewijzigde tijd van $filename naar nu.
    *
    * @param string $filename
    * @return void
    */
   abstract function touchFile($filename);


   /**
    * Geeft een Zend_Search_Lucene_Storage_File object terug voor een gegeven $filename in de map.
    *
    * @param string $filename
    * @return Zend_Search_Lucene_Storage_File
    */
   abstract function getFileObject($filename);

   }

   ?>
De *getFileObject($filename)* methode van de Zend_Search_Lucene_Storage_Directory klasse geeft een
Zend_Search_Lucene_Storage_File object terug.

De abstrakte klasse Zend_Search_Lucene_Storage_File implementeert bestandsabstractie en voorziet in indexbestand
leesprimitieven.

Je moet ook de Zend_Search_Lucene_Storage_File klasse uitbreiden voor jouw Directory implementatie.

Slechts twee methodes van de Zend_Search_Lucene_Storage_File klasse hoeven te worden overloaded in jouw
implementatie:

.. code-block:: php
   :linenos:
   <?php

   class MyFile extends Zend_Search_Lucene_Storage_File {
       /**
        * Zet de bestandpositie indicator en zet de bestandswijzer voort.
        * De nieuwe positie, berekend in bytes vanaf het begin van het
        * bestand, wordt verkregen door offset aan de door $whence aangegeven
        * positie te voegen, welke waarden als volgt zijn gedefinieerd::
        * SEEK_SET - Zet de positie gelijk aan offset bytes.
        * SEEK_CUR - Zet de positie aan de huidige lokatie plus offset.
        * SEEK_END - Zet de positie tot einde-van-bestand plus offset. (Om naar
        * een positie vòòr einde-van-bestand te gaan moet je een negatieve waarde
        * aan offset toekennen.)
        * Geeft 0 indien success; anders -1
        *
        * @param integer $offset
        * @param integer $whence
        * @return integer
        */
       public function seek($offset, $whence=SEEK_SET) {
           ...
       }

       /**
        * Lees $length bytes van het bestand en beweeg de bestandswijzer voort.
        *
        * @param integer $length
        * @return string
        */
       protected function _fread($length=1) {
           ...
       }
   }

   ?>

