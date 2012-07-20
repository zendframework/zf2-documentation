.. _zend.layout.introduction:

Introdução
==========

``Zend_Layout`` implementa um clássico padrão de projeto Two Step View, permitindo aos desenvolvedores empacotar
o conteúdo da aplicação dentro de outra view, geralmente representando o template do site. Tais templates são
freqüentemente denominados de **layouts** por outros projetos, e Zend Framework adotou esse termo por
consistência.

Os objetivos globais de ``Zend_Layout`` são os seguintes:

- Automatizar seleção e renderização de layouts quando usado com os componentes *MVC* do Zend Framework.

- Fornecer escopo separado para variáveis relacionadas ao layout e ao conteúdo.

- Permitir configuração, incluindo o nome do layout, a resolução do script de layout (inflection), e o caminho
  do script de layout.

- Permitir a desabilitação de layouts, mudança de scripts de layout, e outros estados; permitir essas ações de
  dentro de action controllers e view scripts.

- Seguir as mesmas regras de resolução de script (inflection) que :ref:`ViewRenderer
  <zend.controller.actionhelpers.viewrenderer>`, mas permitir também o uso de regras diferentes.

- Permitir o uso sem os componentes *MVC* do Zend Framework.


