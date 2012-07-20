.. _zend.cache.introduction:

Introducere
===========

*Zend_Cache* oferă un mod generic de a stoca temporar orice fel de date.

Stocarea temporară a datelor (caching) este operată în Zend Framework de interfeţe (frontend), în timp ce
stocarea înregistrărilor se face prin adaptoare (backend adapters). (*File*, *Sqlite*, *Memcache*...) cu ajutorul
unui sistem flexibil de ID-uri şi etichete. Folosind aceste adaptoare, vă va fi uşor să ştergeţi ulterior
tipuri specifice de înregistrări (de exemplu: „şterge toate înregistrările memorate marcate cu o etichetă
dată”).

Nucleul modulului (*Zend_Cache_Core*) este generic, flexibil şi configurabil. Totuşi, pentru nevoi specifice,
există interfeţe care extind *Zend_Cache_Core* pentru convenienţă: *Output*, *File*, *Function* şi *Class*.

.. rubric:: Obţinerea unei interfeţe (frontend) cu *Zend_Cache::factory()*

*Zend_Cache::factory()* creează instanţe ale obiectelor şi face legătura între ele. În acest prim exemplu,
vom folosi interfaţa *Core* împreună cu adaptorul *File*.

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Cache.php';

   $frontendOptions = array(
      'lifetime' => 7200, // timp de viaţă pentru înregistrări de 2 ore
      'automatic_serialization' => true
   );

   $backendOptions = array(
       'cache_dir' => './tmp/' // Directorul unde se pun fişierele cache
   );

   // getting a Zend_Cache_Core object
   $cache = Zend_Cache::factory('Core', 'File', $frontendOptions, $backendOptions);?>

.. note::

   **Frontend şi backend construit din mai multe cuvinte**

   Numele unor interfeţe şi backend-uri este construit din mai multe cuvinte, cum ar fi „ZendPlatform”. Când
   le specificaţi fabricii, separaţi-le cu un separator cum ar fi spaţiu („ ”), liniuţă („-”) sau
   punct („.”).

.. _zend.cache.introduction.example-2:

.. rubric:: Păstrarea în cache a unui rezultat de interogare

Acum că avem o interfaţă, putem stoca orice tip de date (am pornit serializarea). De exemplu, putem stoca un
rezultat al unei interogări foarte complexe în baza de date. După ce este stocat, nu mai este nevoie nici măcar
să ne conectăm la baza de date; înregistrările sunt preluate din

.. code-block::
   :linenos:
   <?php
   // $cache a fost iniţializat în exemplul anterior

   // vezi dacă obiectul este deja în cache
   if(!$result = $cache->load('myresult')) {

       // nu e în cache, se face o conexiune la baza de date

       $db = Zend_Db::factory( [...] );

       $result = $db->fetchAll('SELECT * FROM huge_table');

       $cache->save($result, 'myresult');

   } else {

       // e în cache, hai să ne lăudăm cu asta
       echo "This one is from cache!\n\n";

   }

   print_r($result);?>

.. _zend.cache.introduction.example-3:

.. rubric:: Punerea în cache a textelor afişate cu interfaţa de ieşire din *Zend_Cache*

Marcăm secţiuni în care dorim să punem în cache textele care vor fi afişate adăugând nişte condiţii, mai
exact încapsulăm fiecare secţiune între metodele *start()* şi *end()*

În secţiune, afişaţi datele în mod normal - tot ceea ce este afişat va fi pus în cache în loc să fie
afişat până când este executată metoda *end()* (este poate cel mai util exemplu de a folosi această clasă).
La următoarea rulare, codul din secţiune nu va mai fi executat, rezultatul aflându-se deja în cache (cu
condiţia ca înregistrarea din cache să fie validă).

.. code-block::
   :linenos:
   <?php
   $frontendOptions = array(
      'lifetime' => 30,                  // timpul de viaţă este jumătate de minut
      'automatic_serialization' => false  // valoarea false este implicită oricum
   );

   $backendOptions = array('cacheDir' => './tmp/');

   $cache = Zend_Cache::factory('Output', 'File', $frontendOptions, $backendOptions);

   // pasăm un identificator unic metodei start()
   if(!$cache->start('mypage')) {
       // afişare normală:

       echo 'Salut lume! ';
       echo 'Acest mesaj este păstrat temporar ('.time().') ';

       $cache->end(); // ieşirea este salvată şi trimisă navigatorului
   }

   echo 'Acest text nu este păstrat în cache niciodată ('.time().').';?>

Notaţi că afişăm rezultatul funcţiei *time()* de două ori; o facem în scop demonstrativ. Încercaţi să
reîmprospătaţi pagina de mai multe ori; veţi vedea că primul număr nu se schimbă în timp ce al doilea se
schimbă pe măsură ce trece timpul. Acest lucru se întâmplă pentru că primul număr a fost salvat în cache
şi este citit de acolo la a doua accesare. După jumătate de minut (am setat timpul de expirare la 30 de secunde)
numerele ar trebui să se potrivească din nou pentru că înregistrarea din cache a expirat -- doar pentru ca
rezultatul să fie din nou pus în cache. Ar trebui să încercaţi codul acesta în navigator sau în consolă.

.. note::

   Când folosiţi Zend_Cache, fiţi atenţi la identificatorul de cache (pasat metodei *save()* şi metodei
   *start()*). Trebuie să fie unic pentru fiecare resursă pe care o puneţi în cache, altfel înregistrările se
   vor suprapune, sau se vor şterge reciproc.


