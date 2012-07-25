.. _zend.view.scripts:

View Scripts
============

Eenmaal je controller de variabelen heeft toegewezen en render() heeft opgeroepen zal Zend_View het gevraagde view
script oproepen en het binnenin de Zend_View instantie uitvoeren. Daarom wijzen referenties naar $this in je view
scripts eigenlijk naar de Zend_View instantie zelf.

Variabelen die aan het view script werden toegewezen door de controller worden beschouwd als
instantie-eigenschappen. Bijvoorbeeld, indien de controller een variabele 'iets' zou toewijzen, zou je ernaar
verwijzen in je view script als $this->iets. (Dit laat je toe de variabelen die werden toegewezen te scheiden van
de variabelen die intern zijn aan het script zelf.)

Bij wijze van geheugenverfrisser vindt je hieronder het view script van de Zend_View inleiding:

.. code-block:: php
   :linenos:

   <?php if ($this->books): ?>

       <!-- Een tabel van enige boeken. -->
       <table>
           <tr>
               <th>Auteur</th>
               <th>Titel</th>
           </tr>

           <?php foreach ($this->books as $key => $val): ?>
           <tr>
               <td><?php echo $this->escape($val['author']) ?></td>
               <td><?php echo $this->escape($val['title']) ?></td>
           </tr>
           <?php endforeach; ?>

       </table>

   <?php else: ?>

       <p>Er zijn geen boeken af te beelden.</p>

   <?php endif; ?>

.. _zend.view.scripts.escaping:

Escaping Output
---------------

Eén van de meest belangrijke taken die in een view script moeten worden uitgevoerd is die welke verzekert dat
output op een korrekte wijze wordt ge-escaped; dit helpt, onder andere, cross-site scripting aanvallen te
voorkomen. Behalve als je een functie, methode of helper gebruilt die zelf het escapen voor rekening neemt, zou je
altijd variabelen moeten escapen als je ze output.

Zend_View komt met een methode escape() die veel van het escape werk voor je uitvoert.

.. code-block:: php
   :linenos:

   <?php
   // slecht gebruik van het view-script:
   echo $this->variable;

   // goed gebruik van het view-script:
   echo $this->escape($this->variable);
   ?>

Standaard gebruikt de escape() methode de PHP functie htmlspecialchars() om data te escapen. Afhangende van jouw
environment zou het kunnen dat je zou willen dat het escapen op een andere manier wordt uitgevoerd. Gebruik de
setEscape() methode op controller niveau om Zend_View te laten weten welke escape callback te gebruiken.

.. code-block:: php
   :linenos:

   <?php
   // Maak een Zend_View instantie
   $view = new Zend_View();

   // vertel het htmlentities te gebruiken als escape callback
   $view->setEscape('htmlentities');

   // of vertel het een statische klassemethode te gebruiken als callback
   $view->setEscape(array('EenClass', 'methodeNaam'));

   // of zelfs een instantiemethode
   $obj = new EenClass();
   $view->setEscape(array($obj, 'methodeNaam'));

   // en geef dan je view weer
   echo $view->render(...);
   ?>

De callback functie of methode zou de waarde die ge-escaped moet worden als eerste parameter moeten nemen en alle
andere parameters moeten optioneel zijn.

.. _zend.view.scripts.templates:

Template Systemen
-----------------

Alhoewel PHP zelf een machtig template systeem is vinden vele developpeurs dat het een tè machtig of complex
systeem is voor template designers. Daarom kan het view script gebruikt worden om een ander template objekt te
instantiëren en te manipuleren, zoals een PHPLIB-stijl template. Het view script voor dit soort aktiviteir zou er
als volgt kunnen uitzien:

.. code-block:: php
   :linenos:

   <?php
   include_once 'template.inc';
   $tpl = new Template();

   if ($this->books) {
       $tpl->setFile(array(
           "boeklijst" => "boeklijst.tpl",
           "elkboek" => "elkboek.tpl",
       ));

       foreach ($this->boeken as $key => $val) {
           $tpl->set_var('auteur', $this->escape($val['author']);
           $tpl->set_var('titel', $this->escape($val['title']);
           $tpl->parse("boeken", "elkboek", true);
       }

       $tpl->pparse("output", "boeklijst");
   } else {
       $tpl->setFile("geenboeken", "geenboeken.tpl")
       $tpl->pparse("output", "geenboeken");
   }
   ?>

Dit zouden de template bestanden zijn:

.. code-block:: php
   :linenos:

   <!-- boeklijst.tpl -->
   <table>
       <tr>
           <th>Auteur</th>
           <th>Titel</th>
       </tr>
       {boeken}
   </table>

   <!-- elkboek.tpl -->
       <tr>
           <td>{auteur}</td>
           <td>{titel}</td>
       </tr>

   <!-- geenboeken.tpl -->
   <p>Er zijn geen boeken af te beelden.</p>



