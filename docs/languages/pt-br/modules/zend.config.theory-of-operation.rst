.. _zend.config.theory_of_operation:

Teoria de Operação
==================

Dados de configuração são disponibilizados para o construtor ``Zend_Config`` através de uma matriz associativa,
que pode ser multi-dimensional, a fim organizar os dados do geral ao específico. Classes adaptadoras específicas
adaptam os dados de configuração armazenados para produzir uma matriz associativa para o construtor
``Zend_Config``. Scripts do usuário poderão fornecer matrizes diretamente para o construtor ``Zend_Config``, sem
usar uma classe adaptadora, visto que pode ser conveniente em determinadas situações.

Cada dado de configuração de cada valor da matriz torna-se uma propriedade do objeto ``Zend_Config``. A chave é
usada como o nome da propriedade. Se um valor é também uma matriz, então a propriedade do objeto resultante é
criada como um novo objeto ``Zend_Config``, carregado com os dados da matriz. Isso ocorre recursivamente, tal como
uma hierarquia de dados de configuração podendo ser criados com qualquer número de níveis.

``Zend_Config`` implementa as interfaces **Countable** e **Iterator**, a fim de facilitar o acesso simplificado aos
dados de configuração. Assim, pode-se usar a função `count()`_ e construtores do *PHP* como `foreach`_ com os
objetos ``Zend_Config``.

Por padrão, os dados de configuração disponibilizados através de ``Zend_Config`` são somente leitura, e uma
atribuição (por exemplo, ``$config->database->host = 'example.com';``) resulta em uma exceção. Esse
comportamento padrão pode ser anulado através do construtor, no entanto, permitindo apenas a modificação dos
valores dos dados. Além disso, quando as modificações são permitidas, ``Zend_Config`` suporta a desativação
dos valores (ou seja, ``unset($config->database->host)``). O método ``readOnly()`` pode ser usado para determinar
se as modificações para um determinado objeto ``Zend_Config`` são permitidas e o método ``setReadOnly()`` pode
ser usado para interromper quaisquer alterações posteriores a um objeto ``Zend_Config`` que foi criado permitindo
modificações.

.. note::

   É importante não confundir alterações em memória com dados de configuração salvos em mídia específica
   de armazenamento. Ferramentas para criar e modificar dados de configuração em diversas mídia de armazenamento
   estão fora do escopo em relação ao ``Zend_Config``. Soluções de código aberto de terceiros estão
   prontamente disponíveis para esta finalidade.

Classes adaptadoras herdam da classe ``Zend_Config`` visto que utilizam a sua funcionalidade.

A família de classes ``Zend_Config`` permite que os dados de configuração sejam organizados em seções. Os
objetos adaptadores ``Zend_Config`` podem ser carregados com uma única seção especificada, várias seções
especificadas, ou todas as seções (se nenhum for especificado).

Classes adaptadoras ``Zend_Config`` suportam um modelo de herança única que permite que dados de configuração
sejam herdados de uma seção de dados de configuração para outra. Isso é oferecido de forma a reduzir ou
eliminar a necessidade de duplicação dos dados de configuração para diferentes fins. Uma seção herdada
também pode substituir os valores que ela herda através de sua seção pai. Como a herança de classe no *PHP*,
uma seção pode herdar de uma seção pai, que pode herdar de uma seção avó, e assim por diante, mas a herança
múltipla (ou seja, seção C herdando diretamente das seções pais A e B) não é suportada.

Se você tem dois objetos ``Zend_Config``, você pode juntá-los em um único objeto usando a função ``merge()``.
Por exemplo, dados ``$config`` e ``$localConfig``, você poderá unificar os dados de ``$localConfig`` para
``$config`` usando ``$config->merge($localConfig);``. Os itens em ``$localConfig`` serão substituídos por
quaisquer itens com mesmo nome em ``$config``.

.. note::

   O objeto ``Zend_Config`` que está executando a fusão deve ter sido construído permitindo modificações,
   passando ``TRUE`` como o segundo parâmetro do construtor. O método ``setReadOnly()`` pode então ser usado
   para impedir quaisquer alterações posteriores, após a fusão estiver completa.



.. _`count()`: http://php.net/count
.. _`foreach`: http://php.net/foreach
