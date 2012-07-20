.. _zend.view.controllers:

Controller Skripte
==================

Der Controller ist der Ort, wo du ``Zend_View`` instanziieren und konfigurieren kannst. Du übergibst dann die
Variablen an den View und teilst ihm mit, welches bestimmte Skript für die Ausgabe benutzt werden soll.

.. _zend.view.controllers.assign:

Variablen übergeben
-------------------

Dein Controller Skript sollte notwendige Variablen an den View übergeben, bevor es die Kontrolle an das View
Skript übergibt. Normalerweise kannst du eine Variable nach der anderen übergeben und an den bezeichneten
Eigenschaften der View Instanz zuordnen.

.. code-block:: php
   :linenos:

   $view = new Zend_View();
   $view->a = "Hay";
   $view->b = "Bee";
   $view->c = "Sea";

Allerdings kann dies mühsam sein, wenn du bereits alle Werte gesammelt hast, um sie einem Array oder einem Objekt
zuzuordnen.

Mit der assign() Methode kannst Du auch ein Array oder ein Objekt auf einmal übergeben. Das folgende Beispiel hat
den selben Effekt wie die obigen einzelnen Übergaben.

.. code-block:: php
   :linenos:

   $view = new Zend_View();

   // übergebe ein Array mit Schlüssel-Wert Paaren,
   // wo der Schlüssel der Variablenname und der
   // Wert die übergebene Variable ist
   $array = array(
       'a' => "Hay",
       'b' => "Bee",
       'c' => "Sea",
   );
   $view->assign($array);

   // mache das selbe mit den öffentlichen Eigenschaften
   // eines Objektes; beachte wir wir das Objekt beim
   // Übergeben in ein Array umwandeln
   $obj = new StdClass;
   $obj->a = "Hay";
   $obj->b = "Bee";
   $obj->c = "Sea";
   $view->assign((array) $obj);

Alternativ kannst du die assign() Methode auch benutzen, um nacheinander einen Variablennamen und den Wert der
Variable zu übergeben.

.. code-block:: php
   :linenos:

   $view = new Zend_View();
   $view->assign('a', "Hay");
   $view->assign('b', "Bee");
   $view->assign('c', "Sea");

.. _zend.view.controllers.render:

Verarbeitung eines View Skripts
-------------------------------

Sobald du alle notwendigen Variablen übergeben hast, sollte der Controller dem ``Zend_View`` mitteilen, ein
bestimmtes View Skript zu verarbeiten. Dies funktioniert über die render() Methode. Beachte, dass diese Methode
die verarbeitete Ausgabe zurück- aber nicht ausgibt, so dass du die Ausgabe selber zur passenden Zeit per echo()
oder print() ausgeben musst.

.. code-block:: php
   :linenos:

   $view = new Zend_View();
   $view->a = "Hay";
   $view->b = "Bee";
   $view->c = "Sea";
   echo $view->render('someView.php');

.. _zend.view.controllers.script-paths:

Pfade für View Skripte
----------------------

Standardmäßig erwartet ``Zend_View``, dass deine View Skripte im selben Verzeichnis wie das Conntroller Skript
liegen. Wenn dein Controller Skript zum Beispiel im Pfad "/path/to/app/controllers" liegt und es
$view->render('someView.php') aufruft, wird ``Zend_View`` nach der Datei "/path/to/app/controllers/someView.php"
schauen.

Es ist durchaus wahrscheinlich, dass deine View Skripte woanders liegen. Verwende die setScriptPath() Methode, um
``Zend_View`` mitzuteilen, wo es nach View Skripten schauen soll.

.. code-block:: php
   :linenos:

   $view = new Zend_View();
   $view->setScriptPath('/path/to/app/views');

Wenn du nun $view->render('someView.php') aufrufst, wird es nach der Datei "/path/to/app/views/someView.php"
schauen.

Durch Verwendung der addScriptPath() Methode können die Pfade "gestapelt" werden. Wenn du Pfade zu diesem
Stapelspeicher hinzufügst, wird ``Zend_View`` im zuletzt hinzugefügten Pfad nach dem angeforderten View Skript
schauen. Dies erlaubt dir, Standard Views mit spezialisierten Views zu überschreiben, so dass Du "Themen" oder
"Skins" für einige Views erstellen kannst, während du andere bestehen lässt.

.. code-block:: php
   :linenos:

   $view = new Zend_View();
   $view->addScriptPath('/path/to/app/views');
   $view->addScriptPath('/path/to/custom/');

   // wenn du nun $view->render('booklist.php') aufrufst, wird
   // Zend_View zuerst nach der Datei "/path/to/custom/booklist.php",
   // dann nach "/path/to/app/views/booklist.php" und zuguterletzt
   // im aktuellen Pfad nach der Datei "booklist.php" schauen

.. note::

   **Benutze nie Eingaben des Benutzers um den Skriptpfad zu setzen**

   ``Zend_View`` verwendet Skriptpfade um Viewskripte zu eruieren und Sie darzustellen. Deshalb sollten diese
   Verzeichnisse im Vorhinein bekannt sein, und unter der eigenen Kontrolle. **Niemals** sollten Pfade von
   Viewskripten basierend auf Benutzereingaben gesetzt werden, da diese dazu führen können das man sich
   potentiell gegen Local File Inclusion Angriffe öffnet wenn der spezifizierte Pfad den Übergang in das
   Elternverzeichnis enthält. Die folgende Eingabe könnte zu Beispiel so einen Fall verursachen:

   .. code-block:: php
      :linenos:

      // $_GET['foo'] == '../../../etc'
      $view->addScriptPath($_GET['foo']);
      $view->render('passwd');

   Obwohl dieses Beispiel erfunden ist, zeigt es doch sehr klar das potentielle Problem. Wenn man Benutzereingaben
   vertrauen **muß** um den eigenen Skriptpfad zu setzen, muß man die Eingabe entsprechend Filtern und prüfen um
   sicherzustellen das Sie in dem Pfaden existiert die von der eigenen Anwendung kontrolliert werden.


