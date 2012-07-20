.. _zend.form.i18n:

Internationalisierung von Zend_Form
===================================

Immer mehr Entwickler müssen ihren Inhalt für mehere Sprachen und Regionen zur Verfügung stellen. ``Zend_Form``
versucht so einen Arbeitsschritt so einfach wie möglich zu machen und verwendet Funktionalitäten sowohl in
:ref:`Zend_Translator <zend.translator>`, als auch in :ref:`Zend_Validate <zend.validate>` um das zu tun.

Standardmäßig wird keine Internationalisiernug (I18n) durchgeführt. Um I18n Features in ``Zend_Form``
einzuschalten, muss ein ``Zend_Translator`` Objekt mit einem gewünschten Adapter instanziert werden, und es mit
``Zend_Form`` und/oder ``Zend_Validate`` verbunden werden. Für weitere Informationen darüber, wie ein
Übersetzungsobjekt und Übersetzungsdateien erstellt werden, sehen Sie bite in die :ref:`Dokumentation zu
Zend_Translator <zend.translator>`.

.. note::

   **Die Übersetzung kann für jedes Element einzeln abgeschaltet werden**

   Übersetzung kann für jedes Formular, Element, Anzeigegruppe, oder Unterformular, durch den Aufruf dessen
   ``setDisableTranslator($flag)`` Methode oder der Übergabe der ``disableTranslator`` Option an das Objekt,
   ausgeschaltet werden. Das kann nützlich sein, wenn man Übersetzungen selektiv für individuelle Elemente oder
   Sets von Elementen ausschalten will.

.. _zend.form.i18n.initialization:

I18n in Formularen initialisieren
---------------------------------

Um I18n in Formularen zu initialisieren, muss man entweder ein ``Zend_Translator`` Objekt oder ein
``Zend_Translator_Adapter`` haben, wie in der ``Zend_Translator`` Dokumentation beschrieben. Sobald man ein
Übersetzungsobjekt hat, besitzt man verschiedene Möglichkeiten:

- **Einfachste:** es der Registry hinzufügen. Alle I18n fähigen Komponenten vom Zend Framework erkennen ein
  Übersetzungsobjekt automatisch wenn es in der Registrierung unter dem 'Zend_Translator' Schlüssel vorhanden ist
  und verwenden es um eine Übersetzung und/oder Lokalisierung durchzuführen:

  .. code-block:: php
     :linenos:

     // verwende den 'Zend_Translator' Schlüssel; $translate ist ein Zend_Translator Objekt:
     Zend_Registry::set('Zend_Translator', $translate);

  Das wird von ``Zend_Form``, ``Zend_Validate``, und ``Zend_View_Helper_Translator`` aufgegriffen.

- Wenn man besorgt ist wegen der Übersetzung von Fehlermeldungen, kann das Übersetzungsobjekt in
  ``Zend_Validate_Abstract`` registriert werden:

  .. code-block:: php
     :linenos:

     // Allen Prüfklassen mitteilen, dass ein spezieller Übersetzungsadapter verwendet werden soll:
     Zend_Validate_Abstract::setDefaultTranslator($translate);

- Alternativ kann das ``Zend_Form`` Objekt als globaler Übersetzer angefügt werden. Das hat auch einen
  Nebeneffekt auf die Übersetzung von Fehlermeldungen:

  .. code-block:: php
     :linenos:

     // Allen Formularklassen mitteilen, dass ein spezieller Übersetzungsadapter
     // verwendet werden soll, sowie, dass der Adapter für die Übersetzung von
     // Fehlermeldungen verwendet werden soll:
     Zend_Form::setDefaultTranslator($translate);

- Letztendlich kann ein Übersetzer mit einer speziellen Instanz eines Formulars verbunden werden oder zu einem
  speziellen Element indem dessen ``setTranslator()`` Methode verwendet wird:

  .. code-block:: php
     :linenos:

     // *Dieser* Formularklassen mitteilen, dass ein spezieller Übersetzungsadapter
     // verwendet werden soll, sie wird auch für die Übersetzung von allen
     // Fehlermeldungen für alle Elemente verwendet:
     $form->setTranslator($translate);

     // *Diesem* Element mitteilen, dass ein spezieller Übersetzungsadapter
     // verwendet werden soll, sie wird auch für die Übersetzung von allen
     // Fehlermeldungen für dieses Elemente verwendet:
     $element->setTranslator($translate);

.. _zend.form.i18n.standard:

Standard I18n Ziele
-------------------

Was kann nun standardmäßig übersetzt werden, nachdem ein Übersetzungsobjekt definiert wurde?

- **Prüfungsfehlermeldungen.** Prüfungsfehlermeldungen können übersetzt werden. Um das zu tun, müssen die
  verschiedenen Konstanten der Fehlercodes von den ``Zend_Validate`` Prüfungsklassen als Message IDs verwendet
  werden. Für weitere Details über diese Codes, kann in die Dokumentation zu :ref:`Zend_Validate <zend.validate>`
  gesehen werden.

  Zusätzlich können ab Version 1.6.0, Übersetzungen angegeben werden, indem die aktuelle Fehlermeldung als
  Identifikator der Meldung verwendet wird. Das ist die bevorzugte Verwendung für 1.6.0 und höher, da die
  Übersetzung der Nachrichtenschlüssel in zukünftigen Releases veraltet sein wird.

- **Labels.** Element Labels werden übersetzt, wenn eine Übersetzung existiert.

- **Fieldset Legenden.** Anzeigegruppen und Unterformulare werden standardmäßig in Fieldsets dargestellt. Der
  Fieldset Dekorator versucht die Legende zu übersetzen, bevor das Fieldset dargestellt wird.

- **Formulare- und Elementbeschreibungen.** Alle Formtypen (Elemente, Formulare, Anzeigegruppen, Unterformulare)
  erlauben die Spezifikation von optionalen Elementbeschreibungen. Der Beschreibungs Dekorator kann verwendet
  werden, um sie darzustellen und standardmäßig nimmt er den Wert und versucht ihn zu übersetzen.

- **Multi-Option Werte.** Für die verschiedenen Elemente die von ``Zend_Form_Element_Multi`` abgeleitet sind
  (enthält die MultiCheckbox, Multiselect, und Radio Elemente), werden die Optionswerte (nicht die Schlüssel)
  übersetzt, wenn eine Übersetzung vorhanden ist; das bedeutet, dass die Label der vorhandenen Optionen die dem
  Benutzer angezeigt werden, übersetzt werden.

- **Submit und Button Labels.** Die verschiedenen Submit- und Button-Elemente (Button, Submit und Reset)
  übersetzen das Label, welches dem Benutzer angezeigt wird.


