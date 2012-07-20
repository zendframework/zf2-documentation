.. _zend.view.helpers.initial.headmeta:

Помощник HeadMeta
=================

Элемент *<meta>* используется для добавления мета-информации о
вашем HTML-документе, обычно это ключевые слова, кодировка
документа, директивы управления кэшированием и т.д. Метатег
может быть одного из следующих типов: 'http-equiv' или 'name', должен
содержать атрибут 'content', также он может иметь атрибуты 'lang' и
'scheme'.

Помощник *HeadMeta* поддерживает следующие методы для установки и
добавления метатегов:

- *appendName($keyValue, $content, $conditionalName)*

- *offsetSetName($index, $keyValue, $content, $conditionalName)*

- *prependName($keyValue, $content, $conditionalName)*

- *setName($keyValue, $content, $modifiers)*

- *appendHttpEquiv($keyValue, $content, $conditionalHttpEquiv)*

- *offsetSetHttpEquiv($index, $keyValue, $content, $conditionalHttpEquiv)*

- *prependHttpEquiv($keyValue, $content, $conditionalHttpEquiv)*

- *setHttpEquiv($keyValue, $content, $modifiers)*

Параметр ``$keyValue`` используется для установки значения атрибута
'name' или 'http-equiv'; ``$content`` является значением атрибута 'content', а
``$modifiers``- необязательный параметр, который может быть
ассоциативным массивом с ключами 'lang' и/или 'scheme'.

Вы можете также устанавливать метатеги, используя метод
*headMeta()*, который имеет следующую сигнатуру: *headMeta($content, $keyValue,
$keyType = 'name', $modifiers = array(), $placement = 'APPEND')*. Через ``$keyValue`` передается
содержимое ключа, указанного в ``$keyType`` (ключом может быть 'name'
или 'http-equiv'). ``$placement`` может иметь одно из следующих значений: 'SET'
(замена всех ранее сохраненных значений), 'APPEND' (добавление в
конец стека) или 'PREPEND' (добавление в начало стека).

*HeadMeta* перегружает методы *append()*, *offsetSet()*, *prepend()* и *set()* с целью
принудительного использования специальных методов,
перечисленных выше. Внутри себя помощник сохраняет каждый
элемент в виде маркера *stdClass*, который затем преобразовывается
в строку через метод *itemToString()*. Это позволяет производить
проверку элементов в стеке и при необходимости модифицировать
их, просто извлекая объект и изменяя его.

Помощник *HeadMeta* является частной реализацией :ref:`помощника
Placeholder <zend.view.helpers.initial.placeholder>`.

.. _zend.view.helpers.initial.headmeta.basicusage:

.. rubric:: Использование помощника HeadMeta

Вы можете указывать новые метатеги в любой момент времени.
Обычно это правила кэширования для клиентской стороны и
ключевые слова для поисковой оптимизации.

Например, если вы хотите указать ключевые слова для поисковой
оптимизации, то вам нужно создать метатег с именем 'keywords' и
ключевыми словами для вашей страницы:

.. code-block:: php
   :linenos:

   // установка мета-ключевых слов
   $this->headMeta()->appendName('keywords', 'framework php productivity');

Если требуется установить правила кэширования для клиентской
стороны, то вы можете установить теги http-equiv с требуемыми
правилами кэширования:

.. code-block:: php
   :linenos:

   // отключает кэширование на клиентской стороне
   $this->headMeta()->appendHttpEquiv('expires',
                                      'Wed, 26 Feb 1997 08:21:57 GMT')
                    ->appendHttpEquiv('pragma', 'no-cache')
                    ->appendHttpEquiv('Cache-Control', 'no-cache');

Другие распространенные случаи использования - установка типа
содержимого, кодировки и языка документа:

.. code-block:: php
   :linenos:

   // установка типа содержимого и кодировки
   $this->headMeta()->appendHttpEquiv('Content-Type',
                                      'text/html; charset=UTF-8')
                    ->appendHttpEquiv('Content-Language', 'en-US');

И последний пример - мета-обновление как простой способ
отображения промежуточного сообщения до перенаправления:

.. code-block:: php
   :linenos:

   // установка мета-обновления через 3 секунды с новым URL:
   $this->headMeta()->appendHttpEquiv('Refresh',
                                      '3;URL=http://www.some.org/some.html');

Когда все будет готово для помещения тегов в макет, просто
"выводите" помощника:

.. code-block:: php
   :linenos:

   <?php echo $this->headMeta() ?>


