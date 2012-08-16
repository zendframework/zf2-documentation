.. EN-Revision: none
.. _zend.view.helpers.initial.headlink:

Помощник HeadLink
=================

HTML-элемент *<link>* все чаще используется для создания связей с
различными ресурсами - таблицами стилей, лентами новостей,
пиктограммами (favicon), обратными ссылками (trackback) и многим другим.
Помощник *HeadLink* предоставляет простой интерфейс для создания и
агрегирования этих элементов с целью последующего извлечения
и вывода в вашем скрипте макета (layout script).

Помощник *HeadLink* имеет специальные методы для добавления таблиц
стилей в его стек:

- *appendStylesheet($href, $media, $conditionalStylesheet, $extras)*

- *offsetSetStylesheet($index, $href, $media, $conditionalStylesheet, $extras)*

- *prependStylesheet($href, $media, $conditionalStylesheet, $extras)*

- *setStylesheet($href, $media, $conditionalStylesheet, $extras)*

По умолчанию аргумент ``$media`` имеет значение 'screen', но через него
могут передаваться и другие допустимые значения атрибута media.
``$conditionalStylesheet`` может быть либо строкой, либо иметь булево
значение false, он используется для определения того, требуется
ли использовать специальные комментарии для предотвращения
загрузки данной таблицы стилей на определенных платформах.
``$extras`` является массивом дополнительных атрибутов, которые вы
хотите добавить в элемент.

Помощник *HeadLink* также имеет специальные методы для добавления
альтернативных связей в его стек:

- *appendAlternate($href, $type, $title, $extras)*

- *offsetSetAlternate($index, $href, $type, $title, $extras)*

- *prependAlternate($href, $type, $title, $extras)*

- *setAlternate($href, $type, $title, $extras)*

Метод *headLink()* позволяет указывать все атрибуты, необходимые
для элемента *<link>*, он также позволяет указывать место
размещения - новый элемент либо замещает все остальные
элементы, либо добавляется в начало/конец стека.

Помощник *HeadLink* является частной реализацией :ref:`помощника
Placeholder <zend.view.helpers.initial.placeholder>`.

.. _zend.view.helpers.initial.headlink.basicusage:

.. rubric:: Использование помощника HeadLink

Вы можете указывать *headLink* в любой момент времени. Глобальные
ссылки обычно указываются в скрипте макета, а специальные (для
отдельных страниц) - в скриптах вида. В вашем скрипте макета, в
разделе <head>, вы "выводите" помощника, при этом будут выведены
ссылки, которые вы добавили ранее.

.. code-block:: php
   :linenos:

   <?php // установка ссылок в скрипте вида:
   $this->headLink()->appendStylesheet('/styles/basic.css')
                    ->headLink(array('rel' => 'favicon',
                                     'href' => '/img/favicon.ico'),
                                     'PREPEND')
                    ->prependStylesheet('/styles/moz.css',
                                        'screen',
                                        true,
                                        array('id' => 'my_stylesheet'));
   ?>
   <?php // вывод ссылок: ?>
   <?php echo $this->headLink() ?>


