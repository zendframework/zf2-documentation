.. EN-Revision: none
.. _zend.service.recaptcha:

Zend\Service\ReCaptcha
======================

.. _zend.service.recaptcha.introduction:

Einführung
----------

``Zend\Service\ReCaptcha`` bietet einen Client für das `reCAPTCHA Web Service`_. Laut der reCAPTCHA Seite ist
"reCAPTCHA ein freies CAPTCHA Service das hilft Bücher zu digitalisieren." Jedes reCAPTCHA verlangt das der
Benutzer zwei Wörter eingibt, das erste ist das aktuelle CAPTCHA, und das zweite ist ein Wort von einem
eingescannten Text bei dem Software für optische Zeichenerkennung (OCR) keine Identifizierung durchführen kann.
Die Annahme ist das, wenn der Benutzer das erste Wort richtig angegeben hat, dass dann das zweite auch korrekt
angegeben wird, und das dieses dann verwendet werden kann um OCR Software für die Digitalisierung von Büchern zu
verbessern.

Um den reCAPTCHA Service zu verwenden muß man `einen Account unterzeichnen`_ und eine oder mehrere Domains beim
Service registrieren um öffentliche und private Schlüssel zu erzeugen.

.. _zend.service.recaptcha.simplestuse:

Einfachste Verwendung
---------------------

Ein ``Zend\Service\ReCaptcha`` Objekt instanzieren, und ihm den öffentlichen und privaten Schlüssel übergeben:

.. _zend.service.recaptcha.example-1:

.. rubric:: Erstellung einer Instanz des reCAPTCHA Services

.. code-block:: php
   :linenos:

   $recaptcha = new Zend\Service\ReCaptcha($pubKey, $privKey);

Um das reCAPTCHA darzustellen, muß einfach die ``getHTML()`` Methode aufgerufen werden:

.. _zend.service.recaptcha.example-2:

.. rubric:: Das reCAPTCHA darstellen

.. code-block:: php
   :linenos:

   echo $recaptcha->getHTML();

Wenn das Formular übertragen wurde, sollte man zwei Felder empfangen haben, 'recaptcha_challenge_field' und
'recaptcha_response_field'. Diese sind an die ``verify()`` Methode des reCAPTCHA Objekts zu übergeben:

.. _zend.service.recaptcha.example-3:

.. rubric:: Das Formular Feld verifizieren

.. code-block:: php
   :linenos:

   $result = $recaptcha->verify(
       $_POST['recaptcha_challenge_field'],
       $_POST['recaptcha_response_field']
   );

Sobald man das Ergebnis hat, kann es getestet werden um zu sehen ob es gültig ist. Das Ergebnis ist ein
``Zend\Service_ReCaptcha\Response`` Objekt, welche eine ``isValid()`` Methode anbietet.

.. _zend.service.recaptcha.example-4:

.. rubric:: Das reCAPTCHA prüfen

.. code-block:: php
   :linenos:

   if (!$result->isValid()) {
       // Fehlerhafte Prüfung
   }

Noch einfacher zu verwenden ist :ref:`der ReCaptcha <zend.captcha.adapters.recaptcha>` ``Zend_Captcha`` Adapter,
oder man verwendet diesen Adapter als Backend für das :ref:`CAPTCHA Formularelement
<zend.form.standardElements.captcha>`. In jedem Fall werden die Details der Darstellung und Prüfung des reCAPTCHA
automatisch durchgeführt.

.. _zend.service.recaptcha.mailhide:

Email Adressen verstecken
-------------------------

``Zend\Service_ReCaptcha\MailHide`` kann verwendet werden um Email Adressen zu verstecken. Es ersetzt den Teil der
Email Adresse mit einem Link der ein Popup Fenster mit einer reCAPTCHA Challenge öffnet. Das Lösen der Challenge
gibt die komplette Email Adresse zurück.

Um diese Komponente zu verwenden benötigt man `einen Account`_ um öffentliche und private Schlüssel für die
Mailhide *API* erstellen.

.. _zend.service.recaptcha.mailhide.example-1:

.. rubric:: Verwenden der Mail Hide Komponente

.. code-block:: php
   :linenos:

   // Die Mail Adresse die wir verstecken wollen
   $mail = 'mail@example.com';

   // Eine Instanz der Mailhide Komponente erstellen, dieser die öffentlichen und
   // privaten Schlüssel übergeben sowie die Mail Adresse die man verstecken will
   $mailHide = new Zend\Service_ReCaptcha\Mailhide();
   $mailHide->setPublicKey($pubKey);
   $mailHide->setPrivateKey($privKey);
   $mailHide->setEmail($mail);

   // Es darstellen
   print($mailHide);

Das obige Beispiel zeigt "m...@example.com" wobei "..." einen Link enthält der sich mit einem Popup Fenster und
einer reCAPTCHA Challenge öffnet.

Der öffentliche Schlüssel, der private Schlüssel, und die Email Adresse können auch im Konstruktor der Klasse
spezifiziert werden. Es existiert ein viertes Argument das es erlaubt einige Optionen für die Komponente zu
setzen. Die vorhandenen Optionen sind in der folgenden Tabelle aufgelistet:



      .. _zend.service.recaptcha.mailhide.options.table:

      .. table:: Zend\Service_ReCaptcha\MailHide options

         +--------------+--------------------------------------+---------------+----------------------------+
         |Option        |Beschreibung                          |Erwartete Werte|Standard Werte              |
         +==============+======================================+===============+============================+
         |linkTitle     |Das Titel Attribut des Links          |string         |'Reveal this e=mail address'|
         +--------------+--------------------------------------+---------------+----------------------------+
         |linkHiddenText|Der Text welche den Popup Link enthält|string         |'...'                       |
         +--------------+--------------------------------------+---------------+----------------------------+
         |popupWidth    |Die Breite des Popup Fensters         |int            |500                         |
         +--------------+--------------------------------------+---------------+----------------------------+
         |popupHeight   |Die Höhe des Popup Fensters           |int            |300                         |
         +--------------+--------------------------------------+---------------+----------------------------+



Die Konfigurations Optionen können gesetzt werden indem Sie als viertes Argument an den Konstruktor gesendet
werden oder indem die ``setOptions($options)`` aufgerufen wird, welche ein assoziatives Array oder eine Instanz von
:ref:`Zend_Config <zend.config>` entgegen nimmt.

.. _zend.service.recaptcha.mailhide.example-2:

.. rubric:: Viele versteckte Email Adressen erzeugen

.. code-block:: php
   :linenos:

   // Eine Instanz der Mailhide Komponente erstellen, dieser die öffentlichen und
   // privaten Schlüssel übergeben sowie einige Konfigurations Optionen
   $mailHide = new Zend\Service_ReCaptcha\Mailhide();
   $mailHide->setPublicKey($pubKey);
   $mailHide->setPrivateKey($privKey);
   $mailHide->setOptions(array(
       'linkTitle' => 'Click me',
       'linkHiddenText' => '+++++',
   ));

   // Die Mail Adressen die wir verstecken wollen
   $mailAddresses = array(
       'mail@example.com',
       'johndoe@example.com',
       'janedoe@example.com',
   );

   foreach ($mailAddresses as $mail) {
       $mailHide->setEmail($mail);
       print($mailHide);
   }



.. _`reCAPTCHA Web Service`: http://recaptcha.net/
.. _`einen Account unterzeichnen`: http://recaptcha.net/whyrecaptcha.html
.. _`einen Account`: http://recaptcha.net/whyrecaptcha.html
