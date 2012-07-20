.. _zend.db.profiler.profilers.firebug:

Analisando o Desempenho com Firebug
===================================

``Zend_Db_Profiler_Firebug`` envia informações de análise de desempenho para o `Firebug`_ `Console`_.

Todos os dados são enviados via componente ``Zend_Wildfire_Channel_HttpHeaders`` que usa cabeçalhos *HTTP* para
assegurar que o conteúdo da página não fique confuso. É possivel depurar requisições *AJAX* que exigem
respostas *JSON* e *XML* com esta abordagem.

Requisitos:

- Navegador Firefox preferencialmente na versão 3, mas a versão 2 também é suportada.

- Firebug Firefox Extension que você pode baixar de `https://addons.mozilla.org/en-US/firefox/addon/1843`_.

- FirePHP Firefox Extension que você pode baixar de `https://addons.mozilla.org/en-US/firefox/addon/6149`_.

.. _zend.db.profiler.profilers.firebug.example.with_front_controller:

.. rubric:: Análise de Desempenho de Banco de Dados com Zend_Controller_Front

.. code-block:: php
   :linenos:

   // Em seu arquivo de inicialização

   $profiler = new Zend_Db_Profiler_Firebug('All DB Queries');
   $profiler->setEnabled(true);

   // Anexa o analisador de desempenho ao seu adaptador de banco de dados
   $db->setProfiler($profiler)

   // Despache seu controlador frontal

   // Todas as consultas a banco de dados em seus arquivos de modelo,
   // visão e controle serão agora analisadas e enviadas para o Firebug

.. _zend.db.profiler.profilers.firebug.example.without_front_controller:

.. rubric:: DB Profiling without Zend_Controller_Front

.. code-block:: php
   :linenos:

   $profiler = new Zend_Db_Profiler_Firebug('All DB Queries');
   $profiler->setEnabled(true);

   // Anexa o analisador de desempenho ao seu adaptador de banco de dados
   $db->setProfiler($profiler)

   $request  = new Zend_Controller_Request_Http();
   $response = new Zend_Controller_Response_Http();
   $channel  = Zend_Wildfire_Channel_HttpHeaders::getInstance();
   $channel->setRequest($request);
   $channel->setResponse($response);

   // Inicia o buffering de saída
   ob_start();

   // Agora você pode rodar suas consultas de banco de dados a serem analisadas

   // Libera a análise de desempenho para o navegador
   $channel->flush();
   $response->sendHeaders();



.. _`Firebug`: http://www.getfirebug.com/
.. _`Console`: http://getfirebug.com/logging.html
.. _`https://addons.mozilla.org/en-US/firefox/addon/1843`: https://addons.mozilla.org/en-US/firefox/addon/1843
.. _`https://addons.mozilla.org/en-US/firefox/addon/6149`: https://addons.mozilla.org/en-US/firefox/addon/6149
