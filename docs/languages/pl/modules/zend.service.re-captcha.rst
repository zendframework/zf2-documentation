.. EN-Revision: none
.. _zend.service.recaptcha:

Zend_Service_ReCaptcha
======================

.. _zend.service.recaptcha.introduction:

Wprowadzenie
------------

Komponent *Zend_Service_ReCaptcha* zapewnia klienta dla usługi `reCAPTCHA Web Service`_. Cytując serwis
internetowy reCAPTCHA, "reCAPTCHA jest darmowym serwisem CAPTCHA który pomaga skanować książki." Każdy element
reCAPTCHA wymaga, aby użytkownik wpisał dwa słowa: pierwsze które jest tradycyjnym captcha, oraz drugie które
jest słowem zeskanowanym z jakiegoś tekstu, którego oprogramowanie do optycznego rozpoznawania tekstu (OCR) nie
mogło zidentyfikować. Założeniem jest, że jeśli użytkownik poprawnie wpisze pierwsze słowo, to także i
drugie wpisze poprawnie, co będzie mogło być wykorzystane to ulepszenia oprogramowania OCR używanego do
skanowania książek.

Aby używać serwisu reCAPTCHA, będziesz potrzebował `założyć konto`_ i zarejestrować w serwisie jedną lub
więcej domen w celu wygenerowania publicznego oraz prywatnego klucza.

.. _zend.service.recaptcha.simplestuse:

Najprostsze użycie
------------------

Utwórz obiekt klasy *Zend_Service_ReCaptcha*, przekazując mu twoje klucze: publiczny oraz prywatny:

.. code-block:: php
   :linenos:

   $recaptcha = new Zend_Service_ReCaptcha($pubKey, $privKey);


Aby wyświetlić element reCAPTCHA, po prostu wywołaj metodę *getHTML()*:

.. code-block:: php
   :linenos:

   echo $recaptcha->getHTML();


Gdy formularz zostanie wysłany, powinieneś otrzymać dwa pola, 'recaptcha_challenge_field' oraz
'recaptcha_response_field'. Przekaż je do metody *verify()* obiektu ReCaptcha:

.. code-block:: php
   :linenos:

   $result = $recaptcha->verify(
       $_POST['recaptcha_challenge_field'],
       $_POST['recaptcha_response_field']
   );


Gdy posiadasz wynik, sprawdź czy jest pozytywny. Wynik działania metody jest obiektem klasy
*Zend_Service_ReCaptcha_Response* i zapewnia on metodę *isValid()*.

.. code-block:: php
   :linenos:

   if (!$result->isValid()) {
       // Failed validation
   }


Jeszcze prostszy w użyciu jest :ref:`sterownik ReCaptcha <zend.captcha.adapters.recaptcha>` dla klasy
*Zend_Captcha* lub użycie tego sterownika w :ref:`elemencie formularza Captcha
<zend.form.standardElements.captcha>`. W każdym z tych przypadków wyświetlanie oraz weryfikacja elementu
reCAPTCHA jest zautomatyzowana.



.. _`reCAPTCHA Web Service`: http://recaptcha.net/
.. _`założyć konto`: http://recaptcha.net/whyrecaptcha.html
