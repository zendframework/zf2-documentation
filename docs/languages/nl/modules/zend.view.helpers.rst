.. _zend.view.helpers:

View Helpers
============

In je view scripts is het dikwijls nodig een aantal complexe functies steeds weer uit te voeren, bv: een datum
formateren, formulierelementen genereren of aktielinks afbeelden. Je kan helper klassen gebruiken om deze
gedragingen voor jou uit te voeren.

Om een helper in jouw script te gebruiken moet je het oproepen door $this->helperName() te gebruiken. Achter de
scène zal Zend_View de Zend_View_Helper klasse laden, een instantie van het objekt maken en zijn helperName()
methode oproepen. De instantie van het objekt is Behind the scenes, Zend_View will load the
Zend_View_Helper_HelperName class, create an object instance of it, and call its helperName() method. The object
instance is blijvend in de Zend_View instantie, en is hergebruikt voor alle verdere oproepen aan
$this->helperName().

.. _zend.view.helpers.initial:

Initiële Helpers
----------------

Zend_View komt met een set van initiële helper klassen die allemaal relatief zijn aan formulierelementen
generatie. Ze doen elk automatisch de juiste output escaping. Ze zijn:

- formButton($name, $value, $attribs): Maakt een <input type="button" /> element.

- formCheckbox($name, $value, $attribs, $options): maakt een <input type="checkbox" /> element. De $options
  parameter is een array waar de eerste waarde de "checked" waarde is, en de tweede waarde de "unchecked" waarde
  (standaard waarden '1' en '0'). Als $value overeenkomt met de "checked" waarde, zal de checkbox aangezet worden.

- formFile($name, $value, $attribs): Maakt een <input type="file" /> element.

- formHidden($name, $value, $attribs): Maakt een <input type="hidden" /> element.

- formPassword($name, $value, $attribs): Maakt een <input type="password" /> element.

- formRadio($name, $value, $attribs, $options): Maakt een serie <input type="radio" /> elementen, één voor elk
  van de $options elementen. In de $options array is de element key de radio waarde en de elementwaarde is de
  radiolabel. De $value radio zal worden voorgeselecteerd.

- formReset($name, $value, $attribs): Maakt een <input type="reset" /> element.

- formSelect($name, $value, $attribs, $options): Maakt een <select>...</select> blok met één <option> voor elk
  van de $options elementen. In de $options array is de element key de optiewaarde en de elementwaarde is de
  optielabel. De $value optie(s) zal/zullen worden voorgeselecteerd.

- formSubmit($name, $value, $attribs): Maakt een <input type="submit" /> element.

- formText($name, $value, $attribs): Maakt een <input type="text" /> element.

- formTextarea($name, $value, $attribs): Maakt een <textarea>...</textarea> blok.

Deze gebruiken in je scripts is heel eenvoudig. Hier is een voorbeeld. Merk op dat het enige je hoeft te doen is ze
op te roepen, ze laden en instantiëren zichzelf wanneer dat nodig is.

.. code-block::
   :linenos:
   <?php
   // binnenin je view script verwijst $this naar de Zend_View instantie.
   //
   // veronderstel dat je reeds een serie select opties hebt toegewezen onder de naam
   // $landen als Array('us' => 'Verenigde Staten', 'il' =>
   // 'Israël', 'be' => 'België', 'nl' => 'Nederland').
   ?>
   <form action="aktie.php" method="post">
       <p><label>Jouw Email:
           <?php echo $this->formText('email', 'you@example.com', array('size' => 32)) ?>
       </label></p>
       <p><label>Je land:
           <?php echo $this->formSelect('country', 'be', null, $this->landen) ?>
       </label></p>
       <p><label>Zou je je graag inschrijven ?
           <?php echo $this->formCheckbox('opt_in', 'ja', null, array('ja', 'nee')) ?>
       </label></p>
   </form>

Het resultaat van het view script zal op het volgende lijken:

.. code-block::
   :linenos:
   <form action="aktie.php" method="post">
       <p><label>Jouw Email:
           <input type="text" name="email" value="you@example.com" size="32" />
       </label></p>
       <p><label>Je land:
           <select name="country">
               <option value="us">Verenigde Staten</option>
               <option value="il">Israël</option>
               <option value="be" selected="selected">België</option>
               <option value="nl">Nederland</option>
           </select>
       </label></p>
       <p><label>Zou je je graag inschrijven ?
           <input type="hidden" name="opt_in" value="nee" />
           <input type="checkbox" name="opt_in" value="ja" checked="checked" />
       </label></p>
   </form>

.. _zend.view.helpers.paths:

Helper Paden
------------

Zoals met view scripts kan de controller een stapel van paden specifiëren waar Zend_View naar helper klassen moet
zoeken. Standaard kijkt Zend_View in "Zend/View/Helper/\*" voor helper klassen. Je kan Zend_View vertellen in
andere plaatsen te kijken door de setHelperPath() en addHelperPath() methodes te gebruiken.

.. code-block::
   :linenos:
   <?php
   $view = new Zend_View();
   $view->setHelperPath('/pad/naar/meer/helpers');
   ?>

In feite kan je paden "opstapelen" door de addHelperPath() methode te gebruiken. Terwijl je paden aan de stapel
toevoegt zal Zned_Viewer steeds in het meest-recent-toegevoegde pad naar de gevraagde helper klasse zoeken. Dit
laat je toe de initiële distributie van helpers uit te breiden (of zelfs te vervangen) door je eigen persoonlijke
helpers.

.. code-block::
   :linenos:
   <?php
   $view = new Zend_View();
   $view->addHelperPath('/pad/naar/enige/helpers');
   $view->addHelperPath('/ander/pad/naar/helpers');

   // wanneer je nu $this->helperName() oproept zal Zend_View eerst kijken naar
   // "/other/path/to/helpers/HelperName.php", dan naar
   // "/path/to/some/helpers/HelperName", en uiteindelijk naar
   // "Zend/View/Helpers/HelperName.php".
   ?>

.. _zend.view.helpers.custom:

Je eigen Helpers schrijven
--------------------------

Je eigen helpers schrijven is gemakkelijk. Volg gewoon deze regels:

- De klassenaam moet Zend_View_Helper_* zijn, waar * de naam van de helper zelf is. Bijvoorbeeld, als je een helper
  genaamd "speciaalDoel" schrijft zou de klassenaam "Zend_View_Helper_SpeciaalDoel" zijn (let op de hoofdletters).

- De klasse moet een publieke methode hebben die overeenkomt met de helpernaam; dit is de methode die zal worden
  opgeroepen wanneer je template "$this->speciaalDoel()" oproept. In ons "speciaalDoel" helpervoorbeeld zou de
  verplichte methodeverklaring "public function speciaalDoel()" zijn.

- In het algemeen zou de klasse niets moeten printen, echo-en of op eender welke andere wijze output genereren. In
  plaats daarvan zou het waarden moeten terugsturen die kunnen worden geprint of ge-echod. De teruggestuurde
  waarden moeten korrekt worden ge-escaped.

- De klasse moet in een bastand worden opgeslaan dat genoemd is naar de helper methode. Voortbouwend op ons
  "speciaalDoel" helper voorbeeld, moet het bestand "SpeciaalDoel.php" noemen.

Plaats het helper klasse bestand ergens in je helper pad stapel en Zend_View zal het automatisch laden,
instantiëren en uitvoeren.

Hier is een voorbeeld van onze SpeciaalDoel helpercode:

.. code-block::
   :linenos:
   <?php
   class Zend_View_Helper_SpeciaalDoel {
       protected $_count = 0;
       public function speciaalDoel()
       {
           $this->_count++;
           $output = "Ik heb 'The Jerk' {$this->_count} keer gezien.";
           return htmlspecialchars($output);
       }
   }
   ?>

Je kan de SpeciaalDoel helper zoveel keer oproepen als je wil een een view script; het zal éénmaal
geïnstantieerd worden, en is dan blijvend aanwezig voor de gehele leefduur van de Zend_View instantie.

.. code-block::
   :linenos:
   <?php
   // denk eraan: in een view script verwijst $this naar de Zend_View instantie.
   echo $this->speciaalDoel();
   echo $this->speciaalDoel();
   echo $this->speciaalDoel();
   ?>

De output zou hierop moeten lijken:

.. code-block::
   :linenos:
   Ik heb 'The Jerk' 1 keer gezien.
   Ik heb 'The Jerk' 2 keer gezien.
   Ik heb 'The Jerk' 3 keer gezien.


