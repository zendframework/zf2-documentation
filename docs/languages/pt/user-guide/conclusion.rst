.. EN-Revision: 96c6ad3
.. _user-guide.conclusion:

Conclusão
=========

Com isso concluímos nossa olhada rápida sobre como construir uma simples mas funcional
aplicação MVC usando Zend Framework 2. 

Nesse tutorial nos passamos rapidamente sobre um grande número de diferentes partes do
framework.

As partes mais importantes de nossa aplicação desenvolvida com Zend Framework 2 são os
:ref:`modules <zend.module-manager.intro>`, os blocos de desenvolvimento de qualquer 
:ref:`MVC ZF2 application <zend.mvc.intro>`.

Para facilitar o trabalho com as dependencias da nossa aplica~ção nos usamos o
:ref:`service manager <zend.service-manager.intro>`.

Para conseguirmos mapear uma requisição para nossos controllers e açõesos usamos as
:ref:`routes <zend.mvc.routing>`.

Persistencia de dados, na maioria dos casos, inclui o uso de :ref:`Zend\\Db <zend.db.adapter>`
para comunicar com o banco de dados. A entrada de dados foi filtrada e validada com
:ref:`input filters <zend.input-filter.intro>` e juntamente com o  
:ref:`Zend\\Form <zend.form.intro>` foi construida uma solida ponte entre a camada de regra de
negocios e a camada de visão.

:ref:`Zend\\View <zend.view.quick-start>` é responsável pela camada de visão do modelo MVC
juntamente com um grande número de :ref:`view helpers <zend.view.helpers>`.
