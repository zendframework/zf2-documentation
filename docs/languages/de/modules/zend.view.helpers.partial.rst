.. EN-Revision: none
.. _zend.view.helpers.initial.partial:

Partielle Helfer
================

Der ``Partial`` (Partielle) View Helfer wird verwendet um ein spezielles Template innerhalb seines eigenen
variablen Bereichs zu rendern. Primär wird er für wiederverwendbare Templatefragmente verwendet bei denen man
keine Vorsorge wegen variablen Namenskonflikten aufpassen muß. Zusätzlich erlauben Sie es Teile von View Skripten
von speziellen Modulen zu spezifizieren.

Ein Geschwisterteil zum ``Partial`` ist der ``PartialLoop`` View Helfer der es erlaubt Daten zu übergeben die
durchlaufen werden können, und einen Abschnitt für jedes Teil auszugeben.

.. note::

   **PartialLoop Zähler**

   Der ``PartialLoop`` View Helfer fügt der View eine Variable hinzu die **partialCounter** heißt und welche die
   aktuelle Position des Arrays zum View Skript übergibt. Das bietet einen einfachen Weg um alternative
   Farbgebungen zum Bespiel bei Tabellenzeilen zu haben.

.. _zend.view.helpers.initial.partial.usage:

.. rubric:: Grundsätzliche Verwendung von Partials

Die grundsätzliche Verwendung von Partials ist die Ausgabe von Templatefragmenten im eigenen Viewbereich. Es wird
das folgende teilweise Skript angenommen:

.. code-block:: php
   :linenos:

   <?php // partial.phtml ?>
   <ul>
       <li>Von: <?php echo $this->escape($this->from) ?></li>
       <li>Subjekt: <?php echo $this->escape($this->subject) ?></li>
   </ul>

Dieses würde dann vom View Skript aufgerufen indem das folgende verwendet wird:

.. code-block:: php
   :linenos:

   <?php echo $this->partial('partial.phtml', array(
       'from' => 'Team Framework',
       'subject' => 'Teil der View')); ?>

Was dann das folgende ausgibt:

.. code-block:: html
   :linenos:

   <ul>
       <li>From: Team Framework</li>
       <li>Subject: Teil der View</li>
   </ul>

.. note::

   **Was ist ein Modell?**

   Ein Modell das mit dem ``Partial`` View Helfer verwendet wird kann eines der folgenden sein:

   - **Array**. Wenn ein Array übergeben wird, sollte es assoziativ sein, und seine Schlüssel/Werte Paare werden
     der View mit dem Schlüssel als View Variable zugeordnet.

   - **Objekt das die toArray() Methode implementiert**. Wenn ein Objekt übergeben wird das eine ``toArray()``
     Methode besitzt, wird das Ergebnis von ``toArray()`` dem View Objekt als View Variablen zugeordnet.

   - **Standard Objekt**. Jedes andere Objekt wird die Ergebnisse von ``object_get_vars()`` (essentiell alle
     öffentlichen Eigenschaften des Objektes) dem View Objekt zuordnen.

   Wenn das eigene Modell ein Objekt ist, kann es gewünscht sein, es **als Objekt** an das Partielle Skript zu
   übergeben, statt es in ein Array von Variablen zu serialisieren. Das kann durch das Setzen der 'objectKey'
   Eigenschaft des betreffenden Helfers getan werden:

   .. code-block:: php
      :linenos:

      // Dem Partiellen mitteilen das ein Objekt als 'model' Variable übergeben wird
      $view->partial()->setObjectKey('model');

      // Dem Partiellen mitteilen das ein Objekt von partialLoop als 'model'
      // Variable im letzten Partiellen View Skript übergeben wird
      $view->partialLoop()->setObjectKey('model');

   Diese Technik ist speziell dann sinnvoll wenn ``Zend\Db_Table\Rowset``\ s an ``partialLoop()`` übergeben
   werden, da man dann kompletten Zugriff auf die Zeilenobjekte im View Skript hat, was es einem erlaubt Ihre
   Methoden auszurufen (wie das empfangen von Werten bei Eltern- oder abhängigen Zeilen).

.. _zend.view.helpers.initial.partial.partialloop:

.. rubric:: Verwendung von PartialLoop um iterierbare Modelle darzustellen

Typischerweise, wird man Partials in einer Schleife verwenden um das selbe Inhaltsfragment, viele Male,
darzustellen; auf diesem Weg können große Blöcke von wiederholenden Inhalten oder komplexe Anzeigelogik auf
einen einzelnen Platz gegeben werden. Trotzdem hat das einen Geschwindigkeitsnachteil, da der partielle Helfer
einmal für jede Iteration aufgerufen werden muß.

Der ``PartialLoop`` View Helfer hilft bei der Lösung dieses Problems. Er erlaubt es einen wiederholenden Teil
(Array oder Objekt das einen **Iterator** implementiert) als Modell zu übergeben. Er iteriert dann darüber, und
übergibt dessen Teile dem Partial Skript als Modell. Teil in diesem Iterator kann jedes Modell sein das der
``Partial`` View Helfer erlaubt.

Es wird das folgende teilweise View Skript angenommen:

.. code-block:: php
   :linenos:

   <?php // partialLoop.phtml ?>
       <dt><?php echo $this->key ?></dt>
       <dd><?php echo $this->value ?></dd>

Und das folgende "Modell":

.. code-block:: php
   :linenos:

   $model = array(
       array('key' => 'Säugetier', 'value' => 'Kamel'),
       array('key' => 'Vogel', 'value' => 'Pinguin'),
       array('key' => 'Reptil', 'value' => 'Viper'),
       array('key' => 'Fisch', 'value' => 'Flunder'),
   );

Im View Skript wird dann der ``PartialLoop`` Helfer aufgerufen:

.. code-block:: php
   :linenos:

   <dl>
   <?php echo $this->partialLoop('partialLoop.phtml', $model) ?>
   </dl>

.. code-block:: html
   :linenos:

   <dl>
       <dt>Säugetier</dt>
       <dd>Kamel</dd>

       <dt>Vogel</dt>
       <dd>Pinguin</dd>

       <dt>Reptil</dt>
       <dd>Viper</dd>

       <dt>Fisch</dt>
       <dd>Flunder</dd>
   </dl>

.. _zend.view.helpers.initial.partial.modules:

.. rubric:: Partials in anderen Modulen darstellen

Zeitweise existiert ein Parial in einem anderen Modul. Wenn der Name des Moduls bekannt ist, kann dieses als
zweites Argument entweder ``partial()`` oder ``partialLoop()`` übergeben werden, indem das ``$model`` Argument an
dritte Stelle verschoben wird.

Wenn zum Beispiel, eine Teilseite existiert im 'list' Modul existiert die verwendet werden soll, kann diese wie
folgt genommen werden:

.. code-block:: php
   :linenos:

   <?php echo $this->partial('pager.phtml', 'list', $pagerData) ?>

Auf diesem Weg, können Teile wiederverwendet werden die speziell für andere Module erstellt wurden. Deshalb ist
es besser, wiederverwendbare Teile in einen Pfad für geteilt View Skripte zu geben.


