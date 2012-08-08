.. EN-Revision: none
.. _introduction.installation:

**********
Instalação
**********

Veja o :ref:`apêndice sobre requisitos <requirements>` para uma lista detalhada dos requisitos para o Zend
Framework.

A instalação do Zend Framework é extremamente simples. Após baixar e extrair o framework, você pode adicionar
a pasta ``/library`` da distribuição no início de seu include path. Se quiser também, pode mover a pasta da
biblioteca para outro local, possivelmente compartilhado, em seu sistema de arquivos.

- `Baixe a versão estável mais recente.`_ Esta versão, disponível nos formatos ``.zip`` e ``.tar.gz``, é uma
  boa opção para aqueles que ainda não conhecem o Zend Framework.

- `Baixe o nightly snapshot mais recente.`_ Para aqueles que gostam de desafios, a versão nightly snapshot
  representa o último progresso no desenvolvimento do Zend Framework. Snapshots são feitos com a documentação
  somente em inglês ou com todos os idiomas disponíveis. Se você quiser antecipar o trabalho com a versão de
  desenvolvimento do Zend Framework, considere usar um cliente de Subversion (*SVN*).

- Usar um cliente `Subversion`_ (*SVN*). Zend Framework é um software de código aberto, e o repositório
  Subversion utilizado para o seu desenvolvimento está disponível publicamente. Considere o uso do *SVN* para
  obter o Zend Framework caso já utilize o *SVN* no desenvolvimento de sua aplicação, se desejar contribuir com
  o framework, ou se precisar atualizar sua versão do framework antes que os lançamentos ocorram.

  `Exportação`_ é útil se você quiser pegar uma determinada revisão do framework sem que os diretórios
  ``.svn`` sejam criados em uma cópia de trabalho.

  `Verifique uma cópia de trabalho`_ caso queira contribuir com o Zend Framework, uma cópia de trabalho pode ser
  atualizado a qualquer momento com `svn update`_ e alterações podem ser entregues para o nosso repositório
  *SVN* com o comando `svn commit`_.

  Uma `definição externa`_ é altamente conveniente para desenvolvedores que já usam *SVN* para gerenciar
  cópias de trabalho de sua aplicação.

  A *URL* para o trunk do repositório *SVN* do Zend Framework é:
  `http://framework.zend.com/svn/framework/standard/trunk`_

Uma vez que você tiver uma cópia do Zend Framework disponível, sua aplicação terá de ser capaz de acessar as
classes do framework. Embora haja `várias maneiras de fazer isto`_, o `include_path`_ de seu *PHP* precisa conter
o caminho para a biblioteca do Zend Framework.

Zend proporciona um `Guia de Início Rápido`_ para você aprender e seguir em frente o mais rápido possível.
Esta é uma excelente maneira de começar a aprender sobre o framework, com ênfase em exemplos do mundo real que
você pode desenvolver em cima.

Como os componentes do Zend Framework são levemente ligados, vários componentes podem ser escolhidos para uso
independente conforme a necessidade. Cada um dos capítulos seguintes documenta o uso de um determinado componente.



.. _`Baixe a versão estável mais recente.`: http://framework.zend.com/download/latest
.. _`Baixe o nightly snapshot mais recente.`: http://framework.zend.com/download/snapshot
.. _`Subversion`: http://subversion.tigris.org
.. _`Exportação`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.export.html
.. _`Verifique uma cópia de trabalho`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.checkout.html
.. _`svn update`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.update.html
.. _`svn commit`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.commit.html
.. _`definição externa`: http://svnbook.red-bean.com/nightly/en/svn.advanced.externals.html
.. _`http://framework.zend.com/svn/framework/standard/trunk`: http://framework.zend.com/svn/framework/standard/trunk
.. _`várias maneiras de fazer isto`: http://www.php.net/manual/en/configuration.changes.php
.. _`include_path`: http://www.php.net/manual/en/ini.core.php#ini.include-path
.. _`Guia de Início Rápido`: http://framework.zend.com/docs/quickstart
