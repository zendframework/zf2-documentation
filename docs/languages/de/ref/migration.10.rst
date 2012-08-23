.. EN-Revision: none
.. _migration.10:

Zend Framework 1.0
==================

Wenn man von einem älteren Release auf Zend Framework 1.0 oder höher hochrüstet sollte man die folgenden
Migrations Hinweise beachten.

.. _migration.10.zend.controller:

Zend_Controller
---------------

Die prinzipiellen Änderungen die durch 1.0.0RC1 angeboten werden sind die Einführung und standardmäßige
Aktivierung des :ref:`ErrorHandler <zend.controller.plugins.standard.errorhandler>` Plugins und den
:ref:`ViewRenderer <zend.controller.actionhelpers.viewrenderer>` Aktionhelfer. Bitte lies die Dokumentation jedes
einzelnen gründlich um zu sehen wie sie arbeiten und welchen Effekt Sie auf die eigene Anwendung haben können.

Der ``ErrorHandler`` Plugin läuft wärend der ``postDispatch()`` Prüfung auf Ausnahmen, und leitet zu einem
spezifizierten Fehlerhandler Controller weiter. Solch ein Controller sollte in der eigenen Anwendung inkludiert
werden. Er kann deaktiviert werden durch das setzen des Frontcontroller Parameters ``noErrorHandler``:

.. code-block:: php
   :linenos:

   $front->setParam('noErrorHandler', true);

Der ``ViewRenderer`` Aktionhelfer automatisiert die Injizierung der View in den Aktioncontroller genauso wie das
autorendern von Viewskripten basierend auf die aktuelle Aktion. Das primäre Problem dem man begegnen kann ist,
wenn man Aktionen hat die keine View Skripte rendern und weder vorwärts- noch weiterleiten, da der
``ViewRenderer`` versucht ein View Skript zu Rendern basierend auf dem Aktionnamen.

Es gibt verschiedene Strategien die man anwenden kann um den eigenen Code upzudaten. In kurzer Form, kann man
global den ``ViewRenderer`` im eigenen Frontcontroller Bootstrap vor dem Abarbeiten ausschalten:

.. code-block:: php
   :linenos:

   // Annahme das $front eine Instanz von Zend_Controller_Front ist
   $front->setParam('noViewRenderer', true);

Trotzdem ist es keine gute Langzeitstrategie, da es auch bedeutet das man mehr Code schreiben muß.

Wenn man bereit ist damit zu beginnen die ``ViewRenderer`` Funktionalität zu verwenden, gibt es verschiedene Dinge
die man im eigenen Controllercode beachten muß. Zuerst muß auf die Aktionmethoden (die Methoden die mit 'Action'
enden) geachtet werden, und ausgesucht werden was eine jede machen soll. Wenn nichts vom folgenden passiert, muß
man Änderungen durchführen:

- Aufruf von ``$this->render();``

- Aufruf von ``$this->_forward();``

- Aufruf von ``$this->_redirect();``

- Aufruf des ``Redirector`` Aktionhelfers

Die einfachste Änderung ist das Ausschalten des Auto-Rendering für diese Methode:

.. code-block:: php
   :linenos:

   $this->_helper->viewRenderer->setNoRender();

Wenn man herausfindet das keine der eigenen Aktionmethoden rendern, weiterleiten oder umleiten, wird man
voraussichtlich die oben angeführte Zeile in die eigene ``preDispatch()`` oder ``init()`` Methode einfügen
wollen:

.. code-block:: php
   :linenos:

   public function preDispatch()
   {
       // Ausschalten des autorendern vom View Skript
       $this->_helper->viewRenderer->setNoRender()
       // .. andere Dinge tun...
   }

Wenn ``render()`` aufgerufen wird, und man :ref:`die konventionelle Modulare Verzeichnis Struktur
<zend.controller.modular>` verwendet, wird man den Code ändern wollen um Autorendern zu Verwenden:

- Wenn man mehrere View Skripte in einer einzelnen Aktion rendert muß nichts geändert werden.

- Wenn man einfach ``render()`` ohne Argumente aufruft, können diese Zeilen entfernt werden.

- Wenn man ``render()`` mit Argumenten aufruft, und danach nicht irgendeine Bearbeitung durchführt oder mehrere
  View sktipe rendert, können diese Aufrufe zu ``$this->_helper->viewRenderer();`` geändert werden.

Wenn die konventionelle modulare Verzeichnisstruktur nicht verwendet wird, gibt es eine Vielzahl von Methoden für
das Setzen des View Basispfades und der Skript Pfadspezifikationen so das man den ``ViewRenderer`` verwenden kann.
Bitte lies die :ref:`ViewRenderer Dokumentation <zend.controller.actionhelpers.viewrenderer>` für Informationen
über diese Methoden.

Wenn ein View Objekt von der Registry verwendet, oder das eigene View Objekt verändert, oder eine andere View
Implementation verwendet wird, dann wird man den ``ViewRenderer`` in diesem Objekt injiziieren wollen. Das kann
ganz einfach jederzeit durchgeführt werden.

- Vor dem Verarbeiten einer Frontcontroller Instanz:

  .. code-block:: php
     :linenos:

     // Annahme das $view bereits definiert wurde
     $viewRenderer = new Zend_Controller_Action_Helper_ViewRenderer($view);
     Zend_Controller_Action_HelperBroker::addHelper($viewRenderer);

- Jederzeit wärend des Bootstrap Prozesses:

  .. code-block:: php
     :linenos:

     $viewRenderer =
         Zend_Controller_Action_HelperBroker::getStaticHelper('viewRenderer');
     $viewRenderer->setView($view);

Es gibt viele Wege den ``ViewRenderer`` zu modifizieren inklusive dem Setzen eines anderen View Skripts zum
Rendern, dem Spezifizieren von Veränderungen für alle veränderbaren Elemente eines View Skript Pfades (inklusive
der Endung), dem Auswählen eines Antwort-benannten Segments zur Anpassung und mehr. Wenn die konventionelle
modulare Verzeichnisstruktur nicht verwendet wird, kann noch immer eine andere Pfad Spezifikation mit dem
``ViewRenderer`` zugeordnet werden.

Wir empfehlen die Adaptierung des eigenen Codes um den ``ErrorHandler`` und ``ViewRenderer`` zu verwenden da diese
neue Kernfunktionalitäten sind.

.. _migration.10.zend.currency:

Zend_Currency
-------------

Die Erstellung von ``Zend_Currency`` wurde vereinfacht. Es muß nicht länger ein Skript angegeben oder auf
``NULL`` gesetzt werden. Der optionale script Parameter ist jetzt eine Option welche durch die ``setFormat()``
Methode gesetzt werden kann.

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency($currency, $locale);

Die ``setFormat()`` Methode nimmt jetzt ein Array von Optionen. Diese Optionen werden permanent gesetzt und
überschreiben alle vorher gesetzten Werte. Auch eine neue Option 'precision' wurde integriert. Die folgenden
Optionen wurden überarbeitet:

- **position**: Ersetzt den alten 'rules' Parameter.

- **script**: Ersetzt den alten 'script' Parameter.

- **format**: Ersetzt den alten 'locale' Parameter welcher keine neue Währung, sondern nur das Format der Nummern
  setzt.

- **display**: Ersetzt den alten 'rules' Parameter.

- **precision**: Neuer Parameter.

- **name**: Ersetzt den alten 'rules' Parameter. Setzt den vollständigen Namen der Währung.

- **currency**: Neuer Parameter.

- **symbol**: Neuer Parameter.

.. code-block:: php
   :linenos:

   $currency->setFormat(array $options);

Die ``toCurrency()`` Methode unterstützt die optionalen 'script' und 'locale' Parameter nicht mehr. Stattdessen
nimmt sie ein Array von Optionen welche die selben Schlüssel enthalten können wie die ``setFormat()`` Methode.

.. code-block:: php
   :linenos:

   $currency->toCurrency($value, array $options);

Die Methoden ``getSymbol()``, ``getShortName()``, ``getName()``, ``getRegionList()`` und ``getCurrencyList()`` sind
nicht länger statisch und können vom Objekt aus aufgerufen werden. Die geben den aktuell gesetzten Wert des
Objekts zurück wenn kein Parameter gesetzt wurde.


