.. _requirements:

********************************
Pré-requisitos do Zend Framework
********************************

.. _requirements.introduction:

Introdução
----------

Zend Framework requer um interpretador de *PHP* 5 com um servidor web configurado para trabalhar corretamente com
scripts *PHP*. Algumas funcionalidades requerem extensões adicionais ou recursos do servidor web; na maioria dos
casos o framework pode ser usado sem eles, embora o desempenho possa cair ou os recursos auxiliares não ficarem
totalmente funcionais. Um exemplo dessa dependência é o mod_rewrite em um ambiente do Apache, que pode ser usado
para implementar as "*URL*'s amigáveis" como "``http://www.example.com/user/edit``". Se mod_rewrite não estiver
habilitado, o Zend Framework poderá ser configurado para suportar *URL*'s como
"``http://www.example.com?controller=user&action=edit``". *URL*'s amigáveis podem ser usadas para encurtar *URL*'s
para uma representação textual ou para otimização de sites (*SEO*), mas elas não afetam diretamente a
funcionalidade da aplicação.

.. _requirements.version:

Versão do PHP
^^^^^^^^^^^^^

Zend recomenda a versão mais atual do *PHP* em razão das melhorias na segurança e no desempenho, e atualmente
oferece suporte ao *PHP* 5.2.4 ou posterior.

Zend Framework tem uma extensa coleção de testes unitários, que você pode executar usando PHPUnit 3.3.0 ou
posterior.

.. _requirements.extensions:

Extensões do PHP
^^^^^^^^^^^^^^^^

Você encontrará abaixo uma tabela listando todas as extensões normalmente encontradas no *PHP* e como o Zend
Framework as utiliza. Você deve verificar se as extensões no qual os componentes do Zend Framework que você
está usando em sua aplicação estão disponíveis em seu ambiente *PHP*. Muitas das aplicações não requerem
todas as extensões listadas abaixo.

Uma dependência do tipo "hard" indica que os componentes ou classes não poderão funcionar corretamente se a
respectiva extensão não estiver disponível, enquanto uma dependência do tipo "soft" indica que o componente
poderá usar a extensão, se estiver disponível, mas irá funcionar corretamente se não estiver. Muitos
componentes utilizarão automaticamente determinadas extensões, se estas estiverem disponíveis, para otimizar o
desempenho, mas vão executar um código com funcionalidade similar no próprio componente caso as extensões
estejam indisponíveis.

.. include:: ../../en/ref/requirements.php.extensions.table.rst
.. _requirements.zendcomponents:

Componentes do Zend Framework
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Abaixo está uma tabela que lista todos os componentes do Zend Framework disponíveis e qual a extensão *PHP* que
necessitam. Isso pode te ajudar a saber quais extensões são necessárias em sua aplicação. Nem todas as
extensões utilizadas pelo Zend Framework são necessárias em cada aplicação.

Uma dependência do tipo "hard" indica que os componentes ou classes não poderão funcionar corretamente se a
respectiva extensão não estiver disponível, enquanto uma dependência do tipo "soft" indica que o componente
poderá usar a extensão, se estiver disponível, mas irá funcionar corretamente se não estiver. Muitos
componentes utilizarão automaticamente determinadas extensões, se estas estiverem disponíveis, para otimizar o
desempenho, mas vão executar um código com funcionalidade similar no próprio componente caso as extensões
estejam indisponíveis.

.. include:: ../../en/ref/requirements.zendcomponents.table.rst
.. _requirements.dependencies:

Dependências do Zend Framework
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Abaixo você encontrará uma tabela com os componentes do Zend Framework e suas respectivas dependências com
outros componentes do Zend Framework. Isto te ajudará se precisar ter apenas componentes individuais em vez do
Zend Framework completo.

Uma dependência do tipo "hard" indica que os componentes ou classes não poderão funcionar corretamente se o
respectivo componente dependente não estiver disponível, enquanto uma dependência do tipo "soft" indica que o
componente pode precisar do componente dependente em situações especiais ou com adaptadores especiais. Enfim, uma
dependência do tipo "fix" indica que estes componentes ou classes, em todo caso, são utilizados por
subcomponentes, e uma dependência do tipo "sub" indica que estes componentes podem ser utilizados pelos
subcomponentes em situações especiais ou com adaptadores especiais.

.. note::

   Mesmo se for possível separar os componentes individuais para o uso do Zend Framework completo, você deve ter
   em mente que isso pode levar a problemas quando os arquivos são perdidos ou os componentes são usados de
   dinamicamente.

.. include:: ../../en/ref/requirements.dependencies.table.rst

