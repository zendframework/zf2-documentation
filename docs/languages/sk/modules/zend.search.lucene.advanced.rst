.. _zend.search.lucene.advanced:

Pokročilé
===========

.. _zend.search.lucene.advanced.static:

Použitie indexu ako statickej vlastnosti
-----------------------------------------

*Zend_Search_Lucene* objekt využíva deštruktor na zapísanie zmien a uvoľnenie zdrojov.

Pridaná dokumenty sa ukladajú v pamäti a zapísanie novej časti indexu na disk zavisí od parametra
*MaxBufferedDocs*.

Ak ešte nie je dosiahnutý limit určený parametrom *MaxBufferedDocs* potom existujú "neuložené" dokumenty
ktoré sa uložia ako nový segment v deštruktore objektu. Automatická optimalizácia indexu sa spúšťa podľa
potreby a jej spustenie je závislé na parametroch *MaxBufferedDocs*, *MaxMergeDocs* a *MergeFactor*.

Statické vlastnosti objektu sú zničené **po**"poslednom riadku bežiaceho skriptu"

   .. code-block::
      :linenos:
      <?php
      class Searcher {
          private static $_index;

          public static function initIndex() {
              self::$_index = Zend_Search_Lucene::open('path/to/index');
          }
      }

      Searcher::initIndex();



Predsa len, deštruktor statických vlastností je správne zavolaný a má možnosť urobiť všetko čo je
potrebné.

Jedným z problémov sú výnimky. Výnimky ktoré sú vyvolané deštruktorom statického objektu nemajú kontext,
lebo sú vykonané "za koncom skriptu"

V týchto prípadoch dostanente chybu "Fatal error: Exception thrown without a stack frame in Unknown on line 0"
namiesto výnimky.

Zend_Search_Lucene poskytuje možnosť na ošetriť tento problému pomocou metódy *commit()*. Pri jej zavolaní
sa uložia všetky zmeny a uvoľní pamäť ktorá bola použitá na uloženie nových segmentov. Túto operáciu
je možné urobiť v ľubovoľnom čase alebo aj viackrát počas behu skriptu. Po tejto operácii je stále
možné používať *Zend_Search_Lucene* na vyhľadávanie, pridávanie, alebo zmazanie dokumentov. Metóda
*commit()* zaistí, že už neexistujú žiadne dokumenty na pridanie, alebo zmazanie a teda deštruktor
*Zend_Search_Lucene* neurobí nič a preto ani nevznikne žiadna výnimka:

   .. code-block::
      :linenos:
      <?php
      class Searcher {
          private static $_index;

          public static function initIndex() {
              self::$_index = Zend_Search_Lucene::open('path/to/index');
          }

       ...

          public static function commit() {
              self::$_index->commit();
          }
      }

      Searcher::initIndex();

      ...

      // Script shutdown routine
      ...
      Searcher::commit();
      ...




