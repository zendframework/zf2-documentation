.. EN-Revision: none
.. _zend.filter.writing_filters:

Написание фильтров
==================

``Zend_Filter`` предоставляет набор наиболее часто используемых
фильтров, но в некоторых случаях может потребоваться
написание своих фильтров. Эта задача облегчается реализацией
интерфейса ``Zend\Filter\Interface``.

``Zend\Filter\Interface`` определяет единственный метод *filter()*, который
должен быть реализован классом фильтра. Объект класса,
реализующего данный интерфейс, может быть добавлен в цепочку
фильтров через метод *Zend\Filter\Filter::addFilter()*.

Следующий пример демонстрирует, как можно создавать свои
фильтры:

   .. code-block:: php
      :linenos:

      class MyFilter implements Zend\Filter\Interface
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

      $filterChain = new Zend\Filter\Filter();
      $filterChain->addFilter(new MyFilter());




