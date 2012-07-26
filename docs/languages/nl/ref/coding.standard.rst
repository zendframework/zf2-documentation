.. _coding-standard:

************************************
Zend Framework Programmeer Standaard
************************************

.. _coding-standard.overview:

Overzicht
---------

.. _coding-standard.overview.scope:

Bereik
^^^^^^

Dit document beschrijft de richtlijnen en hulpmiddelen voor softwareontwikkelaars en teams die programmeren met
behulp van of die programmeren op het Zend Framework. De volgende onderwerpen zullen aan de orde komen:



   - PHP bestandsformattering

   - Benamingsovereenkomst

   - Codestijl

   - Inline Documentatie



.. _coding-standard.overview.goals:

Doelen
^^^^^^

Goede coderichtlijnen zijn belangrijk in alle ontwikkelingsprojecten, in het bijzonder wanneer meerdere
programmeurs aan eenzelfde project werken. De coderichtlijnen spelen een grote rol in het produceren van
kwaliteitscode met minder bugs en die gemakkelijker kan worden onderhouden.

.. _coding-standard.php-file-formatting:

PHP Bestandsformattering
------------------------

.. _coding-standard.php-file-formatting.general:

Algemeen
^^^^^^^^

Voor bestanden die alleen PHP code bevatten is de sluitende tag ("?>") nooit toegelaten. Die wordt niet geëist
door PHP. Het niet schrijven van deze afbakening voorkomt het toevoegen van spaties in de output.

**BELANGRIJK**: Toevoegen van binaire gegevens zoals toegelaten door *__HALT_COMPILER()* is niet toegelaten in
eender welk Zend Framework PHP bestand of bestanden die daarvan zijn afgeleid. Het gebruik van deze mogelijkheid is
alleen toegelaten in speciale installatie scripts.

.. _coding-standard.php-file-formatting.indentation:

Indenting
^^^^^^^^^

Gebruik een indent van 4 spaties, zonder tabulatie

.. _coding-standard.php-file-formatting.max-line-length:

Maximale regellengte
^^^^^^^^^^^^^^^^^^^^

De doellengte voor een regel is 80 tekens, dus ontwikkelaars zouden moeten proberen om zo dicht mogelijk bij de 80
kolommengrens te blijven èn praktisch te blijven. Langere regels zijn aanvaardbaar. De maximale lengte voor eender
welke regel code in PHP is 120 tekens.

.. _coding-standard.php-file-formatting.line-termination:

Regeleinde
^^^^^^^^^^

Regeleindes worden geschreven volgens de Unix standaard. Regels moeten eindigen op één enkele linefeed (LF). Een
linefeed is een ordinal 10, of een hexadecimale 0x0A.

Gebruik geen carriage returns (CR) zoals Macintosh computers (0x0D).

Gebruik geen carriage return/linefeed combinatie (CRLF) zoals Windows computers (0x0D, 0x0A).

.. _coding-standard.naming-conventions:

Benamingsovereenkomst
---------------------

.. _coding-standard.naming-conventions.classes:

Klassen
^^^^^^^

Het Zend Framework gebruikt een klassebenamingsovereenkomst waarbij de namen van de klassen direct overeenkomen met
de mappen waarin ze zijn opgeslagen. De root directory van de Zend Framework is de "Zend" map, waaronder alle
klassen hiërarchisch zijn ondergebracht.

Klassenamen mogen alleen alfanumerieke tekens bevatten. Nummers zijn toegelaten in klassename maar worden
afgeraden. Underscores zijn alleen toegelaten als vervanging van een padscheider -- de bestandsnaam
"Zend/Db/Table.php" moet overeenkomen met de klassenaam "Zend_Db_Table".

Indien een klassenaam bestaat uit meer dan één woord moet de eerste letter van elk woord een hoofdletter zijn.
Opeenvolgende hoofdletters zijn niet toegestaan, bv. een klasse "Zend_PDF" is niet toegestaan terwijl "Zend_Pdf"
aanvaardbaar is.

Zend Framework klassenamen waarvan Zend of één van de bijdragende partners de auteur is en die met het Framework
worden verzonden moeten altijd beginnen met "Zend\_" en moeten in de "Zend/" map hiërarchie worden opgeslagen.

Dit zijn voorbeelden van aanvaardbare klassenamen:



   .. code-block:: php
      :linenos:

      Zend_Db

      Zend_View

      Zend_View_Helper

**BELANGRIJK:** Code die werkt met het Framework maar er geen deel van is, bv. code geschreven door een
Frameworkgebruiker en niet door Zend of één van de Framework partnerbedrijven, mogen nooit beginnen met "Zend\_".

.. _coding-standard.naming-conventions.interfaces:

Interfaces
^^^^^^^^^^

Interface klassen moeten dezelfde overeenkomsten respecteren als andere klassen (zie hierboven), maar moeten
bovendien eindigen op het woord "interface", zoals in deze voorbeelden:



   .. code-block:: php
      :linenos:

      Zend_Log_Adapter_Interface
      Zend_Controller_Dispatcher_Interface


.. _coding-standard.naming-conventions.filenames:

Bestandsnamen
^^^^^^^^^^^^^

Voor alle andere bestanden zijn alleen alfanumerieke tekens, underscores en het min teken ("-") toegestaan. Spaties
zijn verboden.

Elk bestand dat PHP code bevat moet eindigen op de extensie ".php". Deze voorbeelden tonen aanvaardbare
bestandsnamen voor bestanden die klassen bevatten uit de voorbeelden in de vorige sectie:



   .. code-block:: php
      :linenos:

      Zend/Db.php

      Zend/Controller/Front.php

      Zend/View/Helper/FormRadio.php
Bestandsnamen moeten de overeenkomst met de klassenamen respecteren, zoals hierboven beschreven.

.. _coding-standard.naming-conventions.functions-and-methods:

Functies en methodes
^^^^^^^^^^^^^^^^^^^^

Functienamen mogen alleen alfanumerieke tekens bevatten. Underscores zijn niet toegestaan. Nummers zijn toegestaan
in functienamen maar worden afgeraden.

Functienamen moeten altijd met een kleine letter beginnen. Indien een functienaam bestaat uit meer dan één woord,
moet de eerste letter van elk nieuw woord een hoofdletter zijn. Dit wordt de "studlyCaps" of "camelCaps" methode
genoemd.

Langsprekendheid wordt aangeraden. Functienamen zouden zoveel woorden moeten bevatten als praktisch is om het
begrijpen van de code te vergemakkelijken.

Dit zijn voorbeelden van aanvaardbare functienamen:

   .. code-block:: php
      :linenos:

      filterInput()

      getElementById()

      widgetFactory()


Voor objectgeoriënteerd programmeren zouden databenaderingsmethodes altijd met "get" of "set" moeten worden
voorafgegaan. Bij het gebruik van ontwerppatronen, zoals het singleton of factory patroon, zou de naam van de
methode de patroonnaam moeten bevatten indien mogelijk. Dit om het gebruik van het patroon gemakkelijker herkenbaar
te maken.

Functies in het globale bereik ("drijvende functies") zijn toegestaan maar afgeraden. Het is aanbevolen deze
functies in een statische klasse te wikkelen.

.. _coding-standard.naming-conventions.variables:

Variabelen
^^^^^^^^^^

Namen van variabelen mogen alleen bestaan uit alfanumerieke tekens. Underscores zijn niet toegestaan. Nummers zijn
toegestaan maar worden afgeraden.

Voor eigenschappen die verklaard worden met het "private" of "protected" concept moet het eerste teken van de
functienaam een enkele underscore zijn. Dit is het enige aanvaardbare gebruik van de underscore in een functienaam.
Eigenschappen verklaard als "public" mogen nooit met een underscore beginnen.

Zoals functienamen (zie sectie 3.3, hierboven) moeten namen van variabelen altijd met een kleine letter beginnen en
volgen ze de "camelCaps" behoofdletteringsovereenkomst.

Langsprekendheid is aangeraden. Variabelen zouden zoveel woorden moeten bevatten als praktisch is. Beknopte
variabelnamen zoals "$i" en "$n" worden afgeraden voor alles behalve de kleinst mogelijke loops. Als een loop meer
dan 20 coderegels bevat, moeten de index variabelen meer beschrijvende namen hebben.

.. _coding-standard.naming-conventions.constants:

Constanten
^^^^^^^^^^

Namen voor constanten mogen zowel alfanumerieke tekens als de underscore bevatten. Nummers zijn toegelaten in
constantnamen.

constantnamen moeten altijd alleen bestaan uit hoofdletters wat de alfanumerieke tekens betreft.

Constanten moeten worden gedefinieerd als klasseleden door het concept "const" te gebruiken. Constanten verklaren
in het globale bereik met "define" is toegelaten maar wordt afgeraden.

.. _coding-standard.coding-style:

Codestijl
---------

.. _coding-standard.coding-style.php-code-demarcation:

PHP Code Afbakening
^^^^^^^^^^^^^^^^^^^

PHP code moet altijd worden afgebakend met de volledige standaard PHP markeringen:

   .. code-block:: php
      :linenos:

      <?php

      ?>


Korte markeringen zijn nooit toegelaten

.. _coding-standard.coding-style.strings:

Strings
^^^^^^^

.. _coding-standard.coding-style.strings.literals:

String Literals
^^^^^^^^^^^^^^^

Wanneer een string letterlijk is (hij bevat geen variabelvervanging), moet altijd de apostroof of "enkele quote"
gebruikt worden om de string af te bakenen:

   .. code-block:: php
      :linenos:

      $a = 'Voorbeeld String';


.. _coding-standard.coding-style.strings.literals-containing-apostrophes:

Letterlijke strings die apostrofen bevatten
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Wanneer een letterlijke string zelf apostrofen bevat is het toegelaten de string af te bakenen met aanhalingstekens
("double quotes"). Dit is dringend aangeraden voor SQL verklaringen:

   .. code-block:: php
      :linenos:

      $sql = "SELECT `id`, `name` from `people` WHERE `name`='Fred' OR `name`='Susan'";
De bovenstaande syntax is verkozen boven het "escapen" van de apostrofen.

.. _coding-standard.coding-style.strings.variable-substitution:

Variabelvervanging
^^^^^^^^^^^^^^^^^^

Variabelvervanging is toegestaan met respect voor de volgende vormen:

   .. code-block:: php
      :linenos:

      $greeting = "Hello $name, welcome back!";

      $greeting = "Hello {$name}, welcome back!";


Om uniformiteit te respecteren is deze vorm niet toegestaan:

   .. code-block:: php
      :linenos:

      $greeting = "Hello ${name}, welcome back!";


.. _coding-standard.coding-style.strings.string-concatenation:

String samenvoeging
^^^^^^^^^^^^^^^^^^^

Strings kunnen samengevoegd worden met de "." operator. Er moet steeds een spatie vòòr en na de "." operator
worden ingevoegd om de leesbaarheid te verbeteren:

   .. code-block:: php
      :linenos:

      $company = 'Zend' . 'Technologies';


Wanneer men strings samenvoegt met de "." operator is het toegelaten de verklaring in meerdere regels op te breken
om de leesbaarheid te vergroten. In dat geval moet elke opeenvolgende regel met spaties worden opgevuld zodat de
"." operator uitgelijnd is onder de "=" operator:

   .. code-block:: php
      :linenos:

      $sql = "SELECT `id`, `name` FROM `people` "
           . "WHERE `name` = 'Susan' "
           . "ORDER BY `name` ASC ";


.. _coding-standard.coding-style.arrays:

Arrays
^^^^^^

.. _coding-standard.coding-style.arrays.numerically-indexed:

Numeriek Geïndexeerde Arrays
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Negatieve nummers zijn verboden voor indexen.

Een geïndexeerde array mag starten met eender welk niet negatief nummer. Dit wordt evenwel afgeraden. Het is
aangeraden dat alle arrays een basisindex van 0 hebben.

Wanneer men een geïndexeerde array definieert met het *array* concept moet er een spatie worden ingevoegd na elke
komma afbakening om de leesbaarheid te verbeteren:

   .. code-block:: php
      :linenos:

      $sampleArray = array(1, 2, 3, 'Zend', 'Studio');


Het is ook toegelaten om een geïndexeerde array op meerdere regels te definieren. In dat geval moet elke
opeenvolgende regel met spaties worden opgevuld zodanig dat het begin van elke regel als volgt is uitgelijnd:

   .. code-block:: php
      :linenos:

      $sampleArray = array(1, 2, 3, 'Zend', 'Studio',
                           $a, $b, $c,
                           56.44, $d, 500);


.. _coding-standard.coding-style.arrays.associative:

Associatieve Arrays
^^^^^^^^^^^^^^^^^^^

Wanneer men associatieve arrays met het *array* concept definieert is het aangeraden de verklaring in meerdere
regels op te breken. In dat geval moet elke opeenvolgende regel met spaties worden opgevuld zodat de indexen (keys)
en waarden (values) uitgelijnd zijn:

   .. code-block:: php
      :linenos:

      $sampleArray = array('firstKey'  => 'firstValue',
                           'secondKey' => 'secondValue');


.. _coding-standard.coding-style.classes:

Klassen
^^^^^^^

.. _coding-standard.coding-style.classes.declaration:

Klasse Verklaring
^^^^^^^^^^^^^^^^^

Klassebenaming moet de volgende overeenkomsten volgen.

De accolade wordt steeds op de regel onder de klassenaam geschreven ("one true brace" vorm).

Elke klasse moet een documentatieblok hebben dat de PHPDocumentor standaard volgt.

Code in een klasse moet geïndenteerd zijn met vier spaties.

Eén klasse, éen bestand.

Bijkomende code schrijven in een klassebestand is toegelaten maar wordt afgeraden. Indien men het toch doet moet de
bijkomende code met twee lege regels worden gescheiden van de klassecode.

Dit is een voorbeeld van een aanvaardbare klasseverklaring:

   .. code-block:: php
      :linenos:

      /**
       * Documentatie Blok Hier
       */
      class SampleClass
      {
          // de gehele inhoud van de klasse
          // moet geindenteerd worden met vier spaties
      }


.. _coding-standard.coding-style.classes.member-variables:

Klasse lidvariabelen
^^^^^^^^^^^^^^^^^^^^

Lidvariabelen moeten benaamd worden volgens de variabele benamingsovereenkomst.

Variabelen die in de klasse worden verklaard moeten bovenaan in de klasse worden opgesomd, vòòrdat functies
worden verklaard.

Het concept *var* is niet toegestaan. Lidvariabelen moeten steeds hun zichtbaarheid verklaren door één van de
*private*, *protected*, of *public* concepten te gebruiken. Toegang verlenen aan lidvariabelen door hen publiek te
maken is toegestaan maar wordt afgeraden ten voordele van de databenaderingsmethodes (set/get).

.. _coding-standard.coding-style.functions-and-methods:

Functies en Methodes
^^^^^^^^^^^^^^^^^^^^

.. _coding-standard.coding-style.functions-and-methods.declaration:

Functie en Methode Verklaring
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Functiebenaming moet de benamingsovereenkomsten volgen.

Functies binnen klasses moeten steeds hun zichtbaarheid verklaren door één van de *private*, *protected*, of
*public* concepten te gebruiken.

Net zoals klassen, moet de accolade steeds op de regel onder de functienaam worden geschreven ("one true brace"
vorm). Er is geen spatie tussen de functienaam en de haakjes voor de argumenten. Er is één spatie tussen de
sluitende haakjes en de accolade.

Functies in het globale bereik zijn zeer sterk afgeraden.

Dit is een voorbeeld van een aanvaardbare verklaring van een functie in een klasse:

   .. code-block:: php
      :linenos:

      /*
       * Documentatie blok hier
       */
      function sampleMethod($a)
      {
          // de gehele inhoud van de functie
          // moet geindenteerd worden met vier spaties
      }


**NOTA:** Doorgeven per verwijzing (pass by reference) is alleen toegestaan in de functieverklaring:

   .. code-block:: php
      :linenos:

      function sampleMethod(&$a)
      {}


Call-time pass by reference is verboden.

De terugkeerwaarde mag niet tussen haakjes worden ingesloten. Dat kan de leesbaarheid hinderen en kan ook de code
breken indien een methode later wordt veranderd om per verwijzing terug te sturen.

   .. code-block:: php
      :linenos:

      function foo()
      {
          // FOUT
          return($this->bar);

          // GOED
          return $this->bar;
      }


.. _coding-standard.coding-style.functions-and-methods.usage:

Functie- en Methodegebruik
^^^^^^^^^^^^^^^^^^^^^^^^^^

Functie-argumenten worden gescheiden door één enkele spatie na de komma afbakening. Dit is een voorbeeld van een
aanvaardbare functie-aanroep voor een functie die drie argumenten heeft:

   .. code-block:: php
      :linenos:

      threeArguments(1, 2, 3);


Call-time pass by reference is verboden. Zie de sectie over functieverklaringen voor de juiste wijze om argumenten
per verwijzing door te sturen.

Voor functies welke arrays als argument aanvaardden mag de functieaanroep het "array" concept bevatten en kan deze
in meerdere regels worden opgesplitst om de leesbaarheid te vergroten. In deze gevallen blijven de regels voor het
schrijven van arrays van kracht:

   .. code-block:: php
      :linenos:

      threeArguments(array(1, 2, 3), 2, 3);

      threeArguments(array(1, 2, 3, 'Zend', 'Studio',
                           $a, $b, $c,
                           56.44, $d, 500), 2, 3);


.. _coding-standard.coding-style.control-statements:

Control Statements
^^^^^^^^^^^^^^^^^^

.. _coding-standard.coding-style.control-statements.if-else-elseif:

If / Else / Elseif
^^^^^^^^^^^^^^^^^^

Control statements gebaseerd op *if* en *elseif* concepten moeten een enkele spatie voor de openende haakjes van de
conditie, en een enkele spatie na de sluitende haakjes.

In de voorwaardeverklaringen tussen de haakjes moeten operators gescheiden worden met spaties om de leesbaarheid te
bevorderen. Binnenhaakjes zijn aangeraden voor het groeperen van meer complexe voorwaarden.

De openingsaccolade wordt op dezelfde regel als de voorwaardeverklaring geschreven. De sluitende accolade wordt
altijd op een alleenstaande regel geschreven. Alle inhoud binnenin de accolades moet steeds met vier spaties
geïndenteerd worden.

   .. code-block:: php
      :linenos:

      if ($a != 2) {
          $a = 2;
      }


Voor "if" verklaringen die "else if" of "else" inhouden moet de vorm zoals in de volgende voorbeelden zijn:

   .. code-block:: php
      :linenos:

      if ($a != 2) {
          $a = 2;
      } else {
          $a = 7;
      }


      if ($a != 2) {
          $a = 2;
      } else if ($a == 3) {
          $a = 4;
      } else {
          $a = 7;
      }
PHP laat het toe om in bepaalde gevallen deze verklaringen zonder accolades te schrijven. De codestandaard maakt
geen verschil en alle "if", "else if" of "else" verklaringen moeten accolades gebruiken.

Het gebruik van "elseif" is toegestaan maar "else if" wordt sterk aanbevolen.

.. _coding-standards.coding-style.control-statements.switch:

Switch
^^^^^^

Control statements geschreven met "switch" moeten een enkele spatie voor de openende haakjes van de
voorwaardeverklaring hebben, en een enkele spatie na de sluitende haakjes.

Alle inhoud binnen een "switch" verklaring moet met vier spaties geïndenteerd worden. Inhoud onder elke "case"
moet geïndenteerd worden met vier extra spaties.

.. code-block:: php
   :linenos:

   switch ($numPeople) {
       case 1:
           break;

       case 2:
           break;

       default:
           break;
   }
*default* mag nooit weggelaten worden van een *switch* verklaring.

**NOTA:** Het is soms handig een *case* verklaring te hebben die doorvalt naar de volgende *case* verklaring door
het weglaten van *break* of *return* in de verklaring. Om deze gevallen van bugs te onderscheiden moet elk van de
gevallen waarin een *break* of *return* wordt weggelaten een commentaar "// break intentionally omitted" bevatten.

.. _coding-standards.inline-documentation:

Inline Documentatie
^^^^^^^^^^^^^^^^^^^

.. _coding-standards.inline-documentation.documentation-format:

Documentatie Formaat
^^^^^^^^^^^^^^^^^^^^

Alle documentatieblokken ("docblocks") moeten compatibel zijn met het phpDocumentor formaat. Een beschrijving van
het phpDocumentor formaat is buiten het bereik van dit document. Voor meer informatie kunt u terecht op:
`http://phpdoc.org"`_

Alle broncodebestanden geschreven voor het Zend Framework of dat ermee samenwerkt moet een "file-level" docblock
bevatten aan het begin van elk bestand en een "class-level" docblock onmiddellijk boven elke klasse. Hierna enkele
voorbeelden van zulke docblocks.

.. _coding-standards.inline-documentation.files:

Bestanden
^^^^^^^^^

Elk bestand dat PHP code bevat moet een hoofdblok aan het begin van het bestand bevatten dat minstens de volgende
phpDocumentor gegevens bevat:

   .. code-block:: php
      :linenos:

      /**
       * Korte beschrijving van het bestand
       *
       * Lange beschrijving van het bestand (indien aanwzeig)...
       *
       * LICENSE: Licentie informatie
       *
       * @copyright  Copyright (c) 2005-2012 Zend Technologies USA Inc. (http://www.zend.com)
       * @license    http://www.zend.com/license/3_0.txt   PHP License 3.0
       * @link       http://dev.zend.com/package/PackageName
       * @since      File available since Release 1.2.0
      */


.. _coding-standards.inline-documentation.classes:

Klassen
^^^^^^^

Elke klasse moet een docblock bevatten dat minstens de volgende phpDocumentor gegevens bevat:

   .. code-block:: php
      :linenos:

      /**
       * Korte beschrijving van de klasse
       *
       * Lange beschrijving van de klasse (indien aanwezig)...
       *
       * @copyright  Copyright (c) 2005-2012 Zend Technologies USA Inc. (http://www.zend.com)
       * @license    http://www.zend.com/license/3_0.txt   PHP License 3.0
       * @version    Release: @package_version@
       * @link       http://dev.zend.com/package/PackageName
       * @since      Class available since Release 1.2.0
       * @deprecated Class deprecated in Release 2.0.0
       */


.. _coding-standards.inline-documentation.functions:

Functies
^^^^^^^^

Elke functie, methodes inbegrepen, moet een docblock hebben dat minstens het volgende bevat:

   - Een beschrijving van de functie

   - Alle argumenten

   - Alle mogelijke terugwaarden



Het is niet nodig om de "@access" tags te gebruiken want de zichtbaarheid is reeds bekend via het gebruik van
"public", "private", of "protected" bij het verklaren van de functie.

Indien een functie of methode een exception mag teruggeven, gebruik @throws:

   .. code-block:: php
      :linenos:

      @throws exceptionClass [beschrijving]





.. _`http://phpdoc.org"`: http://phpdoc.org/
