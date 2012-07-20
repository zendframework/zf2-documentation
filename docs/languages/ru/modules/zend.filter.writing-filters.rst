.. _zend.filter.writing_filters:

Написание фильтров
==================

``Zend_Filter`` предоставляет набор наиболее часто используемых
фильтров, но в некоторых случаях может потребоваться
написание своих фильтров. Эта задача облегчается реализацией
интерфейса ``Zend_Filter_Interface``.

``Zend_Filter_Interface`` определяет единственный метод *filter()*, который
должен быть реализован классом фильтра. Объект класса,
реализующего данный интерфейс, может быть добавлен в цепочку
фильтров через метод *Zend_Filter::addFilter()*.

Следующий пример демонстрирует, как можно создавать свои
фильтры:

   .. code-block:: php
      :linenos:

      class MyFilter implements Zend_Filter_Interface
      {
          public function filter($value)
          {
              // Выполнение преобразований над $value,
              // результатом которых является $valueFiltered

              return $valueFiltered;
          }
      }



Добавление экземпляра этого фильтра в цепочку фильтров:

   .. code-block:: php
      :linenos:

      $filterChain = new Zend_Filter();
      $filterChain->addFilter(new MyFilter());




