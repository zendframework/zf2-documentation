.. EN-Revision: none
.. _zend.tag.cloud:

Zend\Tag\Cloud
==============

``Zend\Tag\Cloud`` ist der Darstellungs-Teil von ``Zend_Tag``. Standardmäßig kommt Sie mit einem Set von *HTML*
Dekoratoren welche es erlauben Tag Wolken für WebSites zu erstellen, bietet aber auch zwei abstrakte Klassen für
die Erstellung eigener Dekoratore, um zum Beispiel Tag Wolken in *PDF* Dokumenten zu erstellen.

Man kann ``Zend\Tag\Cloud`` entweder programmtechnisch instanziieren und konfigurieren, oder komplett über ein
Array oder eine Instanz von ``Zend_Config``. Die vorhandenen Optionen sind:

- ``cloudDecorator``: definiert den Dekorator für die Wolke. Das kann entweder der Name der Klasse sein, die vom
  PluginLoader geladen werden soll, eine Instanz von ``Zend\Tag\Cloud\Decorator\Cloud``, oder ein Array das den
  String 'decorator' enthält, und optional ein 'options' Array, welches an den Contructor des Dekorators
  übergeben wird.

- ``tagDecorator``: definiert den Dekorator für individuelle Tags. Das kann entweder der Name der Klasse sein, die
  vom PluginLoader geladen werden soll, eine Instanz von ``Zend\Tag\Cloud\Decorator\Tag``, oder ein Array das den
  String 'decorator' enthält, und optional ein 'options' Array, welches an den Contructor des Dekorators
  übergeben wird.

- ``pluginLoader``: ein anderer Plugin Loader der zu verwenden ist. Muß eine Instanz von
  ``Zend\Loader\PluginLoader\Interface`` sein.

- ``prefixPath``: Präfix Pfade die dem Plugin Loader hinzugefügt werden. Muß ein Array sein das die Schlüssel
  prefix und path oder mehrere Arrays enthält, welche die Schlüssel prefix und path enthalten. Ungültige
  Elemente werden übersprungen.

- ``pluginLoader``: ein anderer Plugin Loader der verwendet wird. Muß eine Instanz von
  ``Zend\Loader\PluginLoader\Interface`` sein.

- ``prefixPath``: Präfix Pfad der dem Plugin Loader hinzugefügt wird. Muß ein Array sein das die Schlüssel
  prefix und path enthält, oder mehrere Array welche die Schlüssel prefix und path enthalten. Ungültige Elemente
  werden übersprungen.

- ``itemList``: eine andere Liste von Elementen die verwendet wird. Muß eine Instanz von ``Zend\Tag\ItemList``
  sein.

- ``tags``: eine Liste von Tags die der Wolke zugeordnet werden. Jedes Tag muß entweder ``Zend\Tag\Taggable``
  implementieren oder ein Array sein welches verwendet werden kann um ``Zend\Tag\Item`` implementieren.

.. _zend.tag.cloud.example.using:

.. rubric:: Verwenden von Zend\Tag\Cloud

Dieses Beispiel zeigt ein grundsätzliches Beispiel davon, wie eine Tag Wolke erstellt, Ihr mehrere Tags
hinzugefügt, und Sie letztendlich dargestellt wird.

.. code-block:: php
   :linenos:

   // Die Wolke erstellen und Ihr statische Tags zuordnen
   $cloud = new Zend\Tag\Cloud(array(
       'tags' => array(
           array('title' => 'Code', 'weight' => 50,
                 'params' => array('url' => '/tag/code')),
           array('title' => 'Zend Framework', 'weight' => 1,
                 'params' => array('url' => '/tag/zend-framework')),
           array('title' => 'PHP', 'weight' => 5,
                 'params' => array('url' => '/tag/php')),
       )
   ));

   // Die Wolke darstellen
   echo $cloud;

Das gibt die Tag Wolke mit drei Tags aus, welche mit den standardmäßigen Schriftgrößen ausgebreitet wird.

.. _zend.tag.cloud.decorators:

Dekoratore
----------

``Zend\Tag\Cloud`` benötigt zwei Typen von Dekoratoren die fähig sein müssen eine Tag Wolke darzustellen. Das
beinhaltet einen Dekorator welcher ein einzelnes Tag darstellt, sowie einen Dekorator welcher die umgebende Wolke
darstellt. ``Zend\Tag\Cloud`` liefert ein standardmäßiges Set von Dekoratoren für die Formatierung einer Tag
Wolke in *HTML*. Dieses Set wird eine Tag Wolke standardmäßig als ul/li-Liste darstellen, und diese mit
unterschiedlichen Schriftgrößen, abhängig vom Gewicht der Werte Ihrer zugeordneten Tags, versehen.

.. _zend.tag.cloud.decorators.htmltag:

Der HTML Tag Dekorator
^^^^^^^^^^^^^^^^^^^^^^

Der *HTML* Tag Dekorator stellt standardmäßig jedes Tag in einem Anker Element dar, umgeben von einem li Element.
Der Anker selbst ist fixiert und kann nicht geändert werden; die umgebenden Elemente können hingegen geändert
werden.

.. note::

   **URL Parameter**

   Da der *HTML* Tag Dekorator immer den Titel des Tags mit einem Anker umgibt, sollte man einen *URL* Parameter,
   für jedes in Ihm verwendete Tag, definiert werden.

Der Tag Dekorator kann entweder unterschiedliche Schriftgrößen über die Anker, oder eine definierte Liste von
Klassennamen, verteilen. Wenn Optionen für eine dieser Möglichkeiten gesetzt werden, werden die
korrespondierenden automatisch aktiviert. Die folgenden Konfigurationsoptionen sind vorhanden:

- ``fontSizeUnit``: definiert die Einheit die für alle Schriftgrößen verwendet wird. Die möglichen Werte sind:
  em, ex, px, in, cm, mm, pt, pc und %.

- ``minFontSize``: definiert die minimale Schriftgröße der Tags (muß ein Integer sein).

- ``maxFontSize``: definiert die maximale Schriftgröße der Tags (muß ein Integer sein).

- ``classList``: ein Array von Klassen die an die Tags vergeben werden soll.

- ``htmlTags``: ein Array von *HTML* Tags die den Anker umgeben. Jedes Element kann entweder ein String sein,
  welches als Elementtyp verwendet wird, oder ein Array das eine Liste von Attributen für das Element enthält,
  welches wiederum als Schlüssel/Werte Paar definiert ist. In diesem Fall wird der Array Schlüssel als Elementtyp
  verwendet.

.. _zend.tag.cloud.decorators.htmlcloud:

HTML Cloud Dekorator
^^^^^^^^^^^^^^^^^^^^

Der *HTML* Cloud Dekorator umgibt die *HTML* Tags standardmäßig mit einem ul-Element und fügt keine Trennung
hinzu. Wie im Tag Dekorator, können mehrere umgebende *HTML* Tags und zusätzlich ein Trennzeichen definiert
werden. Die vorhandenen Optionen sind:

- ``separator``: definiert das Trennzeichen welches zwischen alle Tags platziert wird.

- ``htmlTags``: ein Array von *HTML* Tags, welche alle Tags umgeben. Jedes Element kann entweder ein String sein,
  welches als Elementtyp verwendet wird, oder ein Array das eine Liste von Attributen für das Element enthält,
  und als Schlüssel/Werte Paar definiert ist. In diesem Fall wird der Arrayschlüssel als Elementtyp verwendet.


