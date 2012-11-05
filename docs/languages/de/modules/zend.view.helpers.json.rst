.. EN-Revision: none
.. _zend.view.helpers.initial.json:

JSON Helfer
===========

Wenn Views erstellt werden die *JSON* zurückgeben ist es wichtig auch den entsprechenden Antwort-Header zu setzen.
Der *JSON* View Helfer macht exakt das. Zusätzlich schaltet er, standardmäßig, Layouts aus (wenn diese aktuell
eingeschaltet sind), weil Layouts generell nicht mit *JSON* Antworten verwendet werden.

Der *JSON* Helfer setzt die folgenden Header:

.. code-block:: text
   :linenos:

   Content-Type: application/json

Die meisten *AJAX* Bibliotheken sehen nach diesem Header wenn die Antworten geparst werden um festzustellen wie der
Inhalt handzuhaben ist.

Die Verwendung des *JSON* Helfers ist sehr geradlienig:

.. code-block:: php
   :linenos:

   <?php echo $this->json($this->data) ?>

.. note::

   **Layouts behalten und Encoding einschalten durch Verwendung von Zend\Json\Expr**

   Jede Methode im *JSON* Helfer akzwptiert ein zweites, optionales, Argument. Dieses zweite Argument kan ein
   boolsches Flag sein um Layouts ein- oder auszuschalten, oder ein Array von Optionen die an
   ``Zend\Json\Json::encode()`` übergeben und intern verwendet werden um Daten zu kodieren.

   Um Layouts zu behalten muß der zweite Parameter ein boolsches ``TRUE`` sein. Wenn der zweite Parameter ein
   Array ist, können Layouts behalten werden indem ein ``keepLayouts`` Schlüssel mit dem boolschen Wert ``TRUE``
   eingefügt wird.

   .. code-block:: php
      :linenos:

      // Ein boolsches true als zweites Argument aktiviert Layouts:
      echo $this->json($this->data, true);

      // Oder ein boolsches true als "keepLayouts" Schlüssel:
      echo $this->json($this->data, array('keepLayouts' => true));

   ``Zend\Json\Json::encode`` erlaubt es native *JSON* Ausdrücke zu kodieren indem ``Zend\Json\Expr`` Objekte verwendet
   werden. Diese Option ist standardmäßig deaktiviert. Um diese Option zu aktivieren, muß ein boolsches ``TRUE``
   an den ``enableJsonExprFinder`` Schlüssel des Options Arrays übergeben werden:

   .. code-block:: php
      :linenos:

      <?php echo $this->json($this->data, array(
          'enableJsonExprFinder' => true,
          'keepLayouts'          => true,
      )) ?>


