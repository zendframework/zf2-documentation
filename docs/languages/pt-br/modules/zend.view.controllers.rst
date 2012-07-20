.. _zend.view.controllers:

Scripts Controladores
=====================

O controlador é onde você instancia e configura o ``Zend_View``. Você atribui variáveis ao visualizador,
instruindo-o a renderizar a saída usando um script particular.

.. _zend.view.controllers.assign:

Atribuindo Variáveis
--------------------

Seu script controlador deverá atribuir as variáveis necessárias ao visualizador antes de passar o controle para
ele. Normalmente, você pode fazer isso atribuindo valores aos nomes de propriedades da instância do visualizador:

.. code-block:: php
   :linenos:

   $view = new Zend_View();
   $view->a = "Hay";
   $view->b = "Bee";
   $view->c = "Sea";

Porém, isto pode ser tedioso quando você coletar os valores a serem atribuídos a partir de uma matriz ou objeto.

O método assign() permite a atribuições a partir de uma matriz ou objeto "a granel". O exemplo seguinte tem o
mesmo efeito que o exemplo de atribuição de propriedades uma a uma.

.. code-block:: php
   :linenos:

   $view = new Zend_View();

   // atribui uma matriz associativa onde a chave é nome da variável
   // e o valor é proprio valor atribuído.
   $array = array(
       'a' => "Hay",
       'b' => "Bee",
       'c' => "Sea",
   );
   $view->assign($array);

   // faz o mesmo com as propriedades públicas do objeto;
   // note a forma a conversão ao tipo matriz na atribuição.
   $obj = new StdClass;
   $obj->a = "Hay";
   $obj->b = "Bee";
   $obj->c = "Sea";
   $view->assign((array) $obj);

Alternativamente, você pode usar o método assign para fazer atribuições uma a uma passando a string contendo o
nome da variável, e logo em seguida o valor a ser atribuído.

.. code-block:: php
   :linenos:

   $view = new Zend_View();
   $view->assign('a', "Hay");
   $view->assign('b', "Bee");
   $view->assign('c', "Sea");

.. _zend.view.controllers.render:

Renderizando um Script de Visualização
--------------------------------------

Uma vez que tenhamos atribuído todas as variáveis necessárias, o controlador irá instruir o ``Zend_View`` a
renderizar um script de visualização particular. Ele fará isso chamando o método render(). Note que o método
irá retornar a visualização renderizada, mas não irá imprimí-la, ficando ao seu encargo fazê-lo (echo() ou
print()) no momento apropriado.

.. code-block:: php
   :linenos:

   $view = new Zend_View();
   $view->a = "Hay";
   $view->b = "Bee";
   $view->c = "Sea";
   echo $view->render('someView.php');

.. _zend.view.controllers.script-paths:

Caminhos do Script de Visualização
----------------------------------

Por padrão, ``Zend_View`` espera encontrar os scripts de visualização localizados no mesmo diretório onde
reside o script controlador. Por exemplo, se o seu script controlador estiver em "/path/to/app/controllers" e
chamar $view->render('someView.php'), ``Zend_View`` irá procurar por ele em
"/path/to/app/controllers/someView.php".

Obviamente, os seus scripts de visualização estarão provavelmente situados em outro lugar. Para informar ao
``Zend_View`` onde procurar pelos referidos scripts, use o método setScriptPath().

.. code-block:: php
   :linenos:

   $view = new Zend_View();
   $view->setScriptPath('/path/to/app/views');

Agora quando você chamar $view->render('someView.php'), ele irá procurar em "/path/to/app/views/someView.php".

De fato, você pode "empilhar" caminhos usando o método addScriptPath(). A medida que você acrescenta caminhos à
pilha, ``Zend_View`` irá procurar pela visão no caminho mais recentemente adicionado à pilha. Isto permite
sobrepor visões padronizadas por visões customizadas, permitindo a criação de "temas" e "peles" para algumas
visões, deixando outras intocadas.

.. code-block:: php
   :linenos:

   $view = new Zend_View();
   $view->addScriptPath('/path/to/app/views');
   $view->addScriptPath('/path/to/custom/');

   // agora quando você chamar $view->render('booklist.php'),
   // Zend_View procurará primeiro em "/path/to/custom/booklist.php",
   // depois em "/path/to/app/views/booklist.php", e finalmente no
   // diretório corrente, por "booklist.php".

.. note::

   **Nunca utilize uma entrada do usuário para definir caminhos de script**

   ``Zend_View`` utiliza caminhos de script para pesquisar e renderizar os scripts de visualização. Como tal,
   estes diretórios devem ser conhecidos de antemão, e estarem sob seu controle. **Nunca** defina caminhos de
   script de visualização com base em entradas do usuário, pois você pode se abrir potencialmente para a
   vulnerabilidade de Inclusão Local de Arquivo se o caminho especificado incluir percursos ao diretório pai. Por
   exemplo, a seguinte entrada pode desencadear o problema:

   .. code-block:: php
      :linenos:

      // $_GET['foo'] == '../../../etc'
      $view->addScriptPath($_GET['foo']);
      $view->render('passwd');

   Embora este exemplo seja artificial, ele mostra claramente o problema em potencial. Se você **deve** contar com
   a entrada do usuário para definir o caminho do script, filtre a entrada de forma apropriada e certifique-se de
   que os caminhos sejam controlados por sua aplicação.


