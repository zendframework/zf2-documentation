.. EN-Revision: 96c6ad3
.. _user-guide.styling-and-translations:

Estilizando e Traduzindo
========================

Nos usamos inicialmente o estilo da Aplicação Skeleton, e não existe nenhum problema quanto
a isso, porem nos queremos mudar o título e remoer a mensagem de licenciamento. 

A Aplicação Skeleton está configurada para utilizar as funcionalidades de tradução de ``Zend\I18n``
para todos os textos. Para isso são usados arquivos ``.po`` armazenados em ``Application/language``,
e por isso nos precisamos usar `poedit <http://www.poedit.net/download.php>`_ para alterar esse texto.
Inicie o poedit e abra o arquivo ``application/language/en_US.po``. Clique em “Skeleton Application”
na lista ``Original string`` e então digite “Tutorial” como uma tradução.

.. image:: ../images/user-guide.styling-and-translations.poedit.png

Clique em ``Save`` na barra de ferramentas para que o poedit crie um arquivo ``en_US.mo`` para nos.  
Se você achar que nenhum arquivo ``.mo`` foi gerado, verifique em ``Preferences -> Editor -> Behavior`` 
se o checkbox ``Automatically compile .mo file on save`` está marcado.

Para remover a mensagem de licenciamento nos precisamos editar o arquivo ``layout.phtml`` no
modulo ``Application``:

.. code-block:: php

    // module/Application/view/layout/layout.phtml:
    // Remova essa linha:
    <p>&copy; 2005 - 2012 by Zend Technologies Ltd. <?php echo $this->translate('All 
    rights reserved.') ?></p>

A página agora parece ter ficado um pouco melhor agora!

.. image:: ../images/user-guide.styling-and-translations.translated-image.png
    :width: 940 px
