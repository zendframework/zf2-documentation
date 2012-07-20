.. _zend.view.controllers:

Controller Scripts
==================

De controller is waar je Zend_View instantieert en configureert. Je wijst dan variabelen aan de view toe en vertelt
het view de output weer te geven door middel van een bepaald script.

.. _zend.view.controllers.assign:

Variabelen toewijzen
--------------------

Je controller script zou de nodige variabelen aan het view moeten toewijzen voordat het de controle aan het view
script overhandigd. Normaal gesproken kan je toewijzingen één per één doen door waarden aan de eigenschappen
van de view instantie toe te wijzen:

.. code-block::
   :linenos:
   <?php
   $view = new Zend_View();
   $view->a = "Hooi";
   $view->b = "Bij";
   $view->c = "Zee";
   ?>

Dit kan wel vervelend zijn als je reeds alle waarden die toegewezen moeten worden in een array of objekt voorhanden
hebt.

de assign() methode laat je "bulk" toewijzingen doen vanaf een array of objekt. De volgende voorbeelden hebben
hetzelfde effekt als de hierboven beschreven één per één eigenschapstoewijzingen:

.. code-block::
   :linenos:
   <?php
   $view = new Zend_View();

   // wij een array van key/waarde-paren toe, waar de key
   // de variabelnaam is, en de waarde de toegewezen waarde.
   $array = array(
       'a' => "Hooi",
       'b' => "Bij",
       'c' => "Zee",
   );
   $view->assign($array);

   // doe hetzelfde met de publieke eigenschappen van een
   // objekt. Merk op hoe we naar een array casten bij de toewijzing.
   $obj = new StdClass;
   $obj->a = "Hooi";
   $obj->b = "Bij";
   $obj->c = "Zee";
   $view->assign((array) $obj);
   ?>

Anderzijds kan je de toewijzingsmethode gebruiken om één per één toewijzingen te doen door een string
variabelnaam door te geven, en dan de variabelwaarde.

.. code-block::
   :linenos:
   <?php
   $view = new Zend_View();
   $view->assign('a', "Hooi");
   $view->assign('b', "Bij");
   $view->assign('c', "Zee");
   ?>

.. _zend.view.controllers.render:

Een View Script weergeven
-------------------------

Eenmaal je al de nodige variabelen hebt toegewezen zou de controller Zend_View moeten vertellen dat het een bepaald
view script moet weergeven. Dat doe je door de render() methode op te roepen. Merk op dat de methide het
weergegeven view zal terugsturen en niet afprinten. Je moet het dus zelf afprinten of echo-en wanneer dat jou past.

.. code-block::
   :linenos:
   <?php
   $view = new Zend_View();
   $view->a = "Hooi";
   $view->b = "Bij";
   $view->c = "Zee";
   echo $view->render('eenView.php');
   ?>

.. _zend.view.controllers.script-paths:

View Script Paden
-----------------

Standaard verwacht Zend_View dat je view scripts relatief zijn tenoverstaan van het aanroepende script.
Bijvoorbeeld, als je controller script zich in "/map/naar/toepassing/controllers" bevindt en het roept
$view->render('eenView.php') op, zal Zend_View naar "/map/naar/toepassing/controllers/eenView.php" zoeken.

waarschijnlijk zijn je scripts ergens anders ondergebracht. Om Zend_View daarvan op de hoogte te brengen gebruik je
de setScriptPath() methode.

.. code-block::
   :linenos:
   <?php
   $view = new Zend_View();
   $view->setScriptPath('/map/naar/toepassing/views');
   ?>

Als je nu $view->render('eenView.php') oproept zal het naar "/pad/naar/toepassing/views/eenView.php' kijken.

In feite kan je paden "opstapelen" door de addScriptPath() methode te gebruiken. Terwijl je paden aan de stapel
toevoegt zal Zend_View in het meest recente pad kijken voor het gevraagde view script. Dit laat je toe de standaard
te overschrijven met verpersoonlijkte views zodat je persoonlijke "thema's" of "skins" voor sommige views kan maken
terwijl die niet op andere views van toepassing zijn.

.. code-block::
   :linenos:
   <?php
   $view = new Zend_View();
   $view->addScriptPath('/pad/naar/toepassing/views');
   $view->addScriptPath('/pad/naar/persoonlijk/');

   // wanneer je nu $view->render('boeklijst.php') oproept zal Zend_View
   // eerst kijken naar "pad/naar/persoonlijk/boeklijst.php", dan naar
   // "/pad/naar/toepassing/views/boeklijst.php", en uiteindelijk in
   // de huidige map naar "boeklijst.php".
   ?>


