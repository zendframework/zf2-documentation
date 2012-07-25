.. _zend.layout.quickstart:

Zend_Layout Snelle Start
========================

Er zijn twee belangrijke gebruiksomgevingen voor *Zend_Layout*: mét en zonder Zend Framework MVC-componenten

.. _zend.layout.quickstart.layouts:

Layout scripts
--------------

In beide gevallen heb je een layout script nodig. Layout scripts gebruiken Zend_View (of elke implementatie daarvan
die je gebruikt). Layoutvariabelen worden geregistreerd met een *Zend_Layout* :ref:`placeholder
<zend.view.helpers.initial.placeholder>`. Toegang tot deze variabelen krijg je via de Placeholder Helper of door ze
op te vragen als eigenschappen van het layoutobject via de layout helper.

Bijvoorbeeld:

.. code-block:: php
   :linenos:

   <!DOCTYPE html
       PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
       "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
   <html>
   <head>
       <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
       <title>Mijn website</title>
   </head>
   <body>
   <?php
       // Vraag de 'content'-sleutel op met behulp van de layout helper:
       echo $this->layout()->content;

       // Vraag de 'foo'-sleutel op met behulp van de placeholder helper:
       echo $this->placeholder('Zend_Layout')->foo;

       // Vraag het layout object op en vraag daaruit verschillende sleutels op:
       $layout = $this->layout();
       echo $layout->bar;
       echo $layout->baz;
   ?>
   </body>
   </html>

Doordat *Zend_Layout* *Zend_View* gebruikt om het layout script te renderen kun je alle geregistreerde View Helpers
gebruiken en heb je ook toegang tot alle viewvariabelen die reeds zijn ingesteld. Vooral handig zijn de
verschillende :ref:`placeholder helpers <zend.view.helpers.initial.placeholder>`, die je in staat stellen om
velerlei gegevens voor bijvoorbeeld de <head>-sectie, navigatie, etc. op te vragen:

.. code-block:: php
   :linenos:

   <!DOCTYPE html
       PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
       "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
   <html>
   <head>
       <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
       <!-- Gebruik verschillende placeholder helpers om specifieke informatie op te vragen:
       <title><?= $this->headTitle() ?></title>
       <?= $this->headScript() ?>
       <?= $this->headStyle() ?>
   </head>
   <body>
       <?= $this->render('header.phtml') ?>

       <div id="nav"><?= $this->placeholder('nav') ?></div>

       <div id="content"><?= $this->layout()->content ?></div>

       <?= $this->render('footer.phtml') ?>
   </body>
   </html>

.. _zend.layout.quickstart.mvc:

Zend_Layout met Zend Framework MVC-componenten
----------------------------------------------

*Zend_Controller* biedt een uitgebreide set aan uitbreidingsfunctionaliteiten via de :ref:`front controller plugins
<zend.controller.plugins>` en :ref:`actiiecontroller helpers <zend.controller.actionhelpers>`. *Zend_View* heeft
ook :ref:`helpers <zend.view.helpers>`. *Zend_Layout* gebruikt deze verschillende uitbreidingsmogelijkheden als het
wordt gebruikt in een MVC-context.

*Zend_Layout::startMvc()* instantieert *Zend_Layout* met behulp van de optionele configuratie die wordt meegegeven.
Vervolgens registreert het een front controller plugin die zorg draagt voor het renderen van de layout ná; de
dispatch loop en een actiecontroller helper die de ontwikkelaar toegang geeft tot het layoutobject vanuit de
actiecontrollers. De ontwikkelaar kan verder op ieder gewenst moment de layoutinstantie opvragen via de *layout*
view helper.

Laten we om te beginnen kijken naar het initialiseren van *Zend_Layout* in een MVC-context.

.. code-block:: php
   :linenos:

   <?php
   // In de bootstrap:
   Zend_Layout::startMvc();
   ?>
Je kunt aan *startMvc()* een optionele array van configuratieopties of een instantie van *Zend_Config* meegeven om
de instantie aan te passen aan jouw wensen. De verschillende beschikbare opties worden uitgelegd in :ref:`
<zend.layout.options>`.

In een actiecontroller kun je toegang tot het layoutobject krijgen alsof het een action helper is.

.. code-block:: php
   :linenos:

   <?php
   class FooController extends Zend_Controller_Action
   {
       public function barAction()
       {
           // Schakel de layout uit voor deze actie:
           $this->_helper->layout->disableLayout();
       }

       public function bazAction()
       {
           // Gebruik een ander layout script voor deze actie:
           $this->_helper->layout->setLayout('foobaz');
       };
   }
   ?>
In je view scripts kun je toegang verkrijgen tot het layoutobject via de *layout* view helper. Deze view helper
verschilt van andere view helpers: hij neemt geen argumenten aan en geeft geen stringwaarde, maar een object terug.
Dit stelt je in staat om het layoutobject verder direct te benaderen:

.. code-block:: php
   :linenos:

   <?php $this->layout()->setLayout('foo'); // Stel een alternatieve layout in ?>

Je kunt te allen tijde het layoutobject (binnen MVC-context) opvragen via de statische methode *getMvcInstance()*:

.. code-block:: php
   :linenos:

   <?php
   // Geeft null terug als startMvc() nog niet aangeroepen is
   $layout = Zend_Layout::getMvcInstance();
   ?>
Tot slot heeft de front controller plugin van *Zend_Layout* één belangrijke toegevoegde functionaliteit ten
opzichte van het renderen van de layout: *Zend_Layout* vraagt alle benoemde segmenten uit het response object op en
wijst ze toe als layoutvariabelen. Het segment 'default' wordt toegewezen aan de variabele 'content'. Dit geeft je
de mogelijkheid om de verschillende delen van de output van je applicatie in de layout te renderen.

Een voorbeeldje: Stel dat je applicatiecode als eerst langs *FooController::indexAction()* komt, waarvan de
uitkomst in het 'default' response segment wordt geplaatst en de code vervolgens doorstuurt naar
*NavController::menuAction()*, waarvan de uitkomst in het 'nav' response segment wordt geplaatst en tot slot langs
*CommentController::fetchAction()* wordt gestuurd, waarvan de uitkomst aan het eind van het 'default' response
segment wordt toegevoegd. Je kunt dan beide segmenten apart door je layout script laten renderen:

.. code-block:: php
   :linenos:

   <body>
       <!-- Rendert /nav/menu -->
       <div id="nav"><?= $this->layout()->nav ?></div>

       <!-- Rendert /foo/index + /comment/fetch -->
       <div id="content"><?= $this->layout()->content ?></div>
   </body>

Deze functionaliteit is vooral handig als hij wordt gebruikt samen met de ActionStack :ref:`action helper
<zend.controller.actionhelpers.actionstack>` en :ref:`plugin <zend.controller.plugins.standard.actionstack>`.
Hiermee kun je een lijst van uit te voeren acties aanleggen, waardoor je allerlei widgets kunt laden binnen één
layout.

.. _zend.layout.quickstart.standalone:

Zend_Layout als standalone component
------------------------------------

Zonder de Zend Framework MVC-context is Zend_Layout niet half zo functioneel of handig als mét. Toch heeft het
twee belangrijke voordelen:

- *Zend_Layout* biedt een aparte omgeving voor layoutvariabelen.

- *Zend_Layout* isoleert het layout script (dat meestal op nagenoeg elke pagina hetzelfde zal zijn) van de andere,
  normale view scripts.

Als je *Zend_Layout* als standalone component gebruikt kun je simpelweg het layout object instantiëren en de
verschillende accessoren gebruiken om het object te configureren, variabelen aan het object toe te wijzen en de
layout te renderen:

.. code-block:: php
   :linenos:

   <?php
   $layout = new Zend_Layout();

   // Stel het layout script pad in:
   $layout->setLayoutPath('/path/to/layouts');

   // Wijs een paar variabelen toe:
   $layout->content = $content;
   $layout->nav     = $nav;

   // Wissel van layout script:
   $layout->setLayout('foo');

   // Render de uiteindelijke layout
   echo $layout->render();
   ?>
.. _zend.layout.quickstart.example:

Voorbeeld
---------

Soms zegt een plaatje meer dan duizend woorden. Vandaar de volgende afbeelding. Het laat zien hoe het allemaal bij
elkaar kan komen.

.. image:: ../images/zend.layout.quickstart.example.png
   :align: center

De daadwerkelijke volgorde van de elementen kan variëren; dat hangt af van de CSS die je gebruikt. Als je
bijvoorbeeld elementen absoluut positioneert kan het zijn dat je, hoewel de navigatie later in het document staat,
het alsnog bovenaan laat weergeven. Dit kan natuurlijk ook gelden voor de header of zijbalk. De technische kant van
het bij elkaar renderen van verschillende stukken inhoud blijft echter hetzelfde.


