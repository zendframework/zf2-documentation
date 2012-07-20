.. _zend.view.helpers.initial.headstyle:

Assistente HeadStyle
====================

O elemento *HTML* **<style>** é usado para incluir folhas de estilo *CSS* de forma inline no elemento *HTML*
**<head>**.

.. note::

   **Use o HeadLink para "linkar" arquivos CSS**

   O :ref:`HeadLink <zend.view.helpers.initial.headlink>` deve ser usado para criar elementos **<link>** para a
   inclusão de folhas de estilo externas. ``HeadStyle`` é usado quando você deseja definir folhas de estilo
   inline.

O assistente ``HeadStyle`` dá suporte aos seguintes métodos para a configuração e adição de declarações de
folhas de estilo:

- ``appendStyle($content, $attributes = array())``

- ``offsetSetStyle($index, $content, $attributes = array())``

- ``prependStyle($content, $attributes = array())``

- ``setStyle($content, $attributes = array())``

Em todos os casos, ``$content`` é a verdadeira declaração *CSS*. ``$attributes`` são quaisquer atributos
adicionais que você dejesa prover para a tag ``style``: lang, title, media, ou dir são todos admissíveis.

.. note::

   **Setting Conditional Comments**

   ``HeadStyle`` allows you to wrap the style tag in conditional comments, which allows you to hide it from
   specific browsers. To add the conditional tags, pass the conditional value as part of the ``$attributes``
   parameter in the method calls.

   .. _zend.view.helpers.initial.headstyle.conditional:

   .. rubric:: Headstyle With Conditional Comments

   .. code-block:: php
      :linenos:

      // adding scripts
      $this->headStyle()->appendStyle($styles, array('conditional' => 'lt IE 7'));

``HeadStyle`` também permite a captura de declarações de estilo; isso pode ser útil se você quiser criar as
declarações através de programação, e então colocá-las em outro lugar. A utilização disso será mostrada
em um exemplo abaixo.

Finalmente, você pode usar o método ``headStyle()`` para acrescentar rapidamente elementos de declaração; a
assinatura para isso é ``headStyle($content$placement = 'APPEND', $attributes = array())``. ``$placement`` deve
ser 'APPEND', 'PREPEND', ou 'SET'.

``HeadStyle`` sobrescreve ``append()``, ``offsetSet()``, ``prepend()``, e ``set()`` para forçar o uso dos métodos
especiais listados acima. Internamente ele armazena cada item como um token ``stdClass``, que depois é serializado
usando o método ``itemToString()``. Isso permite que você faça verificações nos itens da pilha, e
opcionalmente modifique estes itens simplesmente modificando o objeto retornado.

O assistente ``HeadStyle`` é uma implementação concreta do :ref:`assistente Placeholder
<zend.view.helpers.initial.placeholder>`.

.. note::

   **UTF-8 encoding used by default**

   By default, Zend Framework uses *UTF-8* as its default encoding, and, specific to this case, ``Zend_View`` does
   as well. Character encoding can be set differently on the view object itself using the ``setEncoding()`` method
   (or the the ``encoding`` instantiation parameter). However, since ``Zend_View_Interface`` does not define
   accessors for encoding, it's possible that if you are using a custom view implementation with this view helper,
   you will not have a ``getEncoding()`` method, which is what the view helper uses internally for determining the
   character set in which to encode.

   If you do not want to utilize *UTF-8* in such a situation, you will need to implement a ``getEncoding()`` method
   in your custom view implementation.

.. _zend.view.helpers.initial.headstyle.basicusage:

.. rubric:: Uso Básico do Assistente HeadStyle

Você pode especificar uma nova tag de estilo a qualquer momento:

.. code-block:: php
   :linenos:

   // adding styles
   $this->headStyle()->appendStyle($styles);

A ordenação é muito importante no *CSS*; você talvez tenha que assegurar que as declarações sejam carregadas
em uma ordem específica devido à ordem da cascata; use as diretivas append, prepend, e offsetSet para lhe
auxiliar nessa tarefa:

.. code-block:: php
   :linenos:

   // Putting styles in order

   // place at a particular offset:
   $this->headStyle()->offsetSetStyle(100, $customStyles);

   // place at end:
   $this->headStyle()->appendStyle($finalStyles);

   // place at beginning
   $this->headStyle()->prependStyle($firstStyles);

When you're finally ready to output all style declarations in your layout script, simply echo the helper:

.. code-block:: php
   :linenos:

   <?php echo $this->headStyle() ?>

.. _zend.view.helpers.initial.headstyle.capture:

.. rubric:: Capturing Style Declarations Using the HeadStyle Helper

Sometimes you need to generate *CSS* style declarations programmatically. While you could use string concatenation,
heredocs, and the like, often it's easier just to do so by creating the styles and sprinkling in *PHP* tags.
``HeadStyle`` lets you do just that, capturing it to the stack:

.. code-block:: php
   :linenos:

   <?php $this->headStyle()->captureStart() ?>
   body {
       background-color: <?php echo $this->bgColor ?>;
   }
   <?php $this->headStyle()->captureEnd() ?>

The following assumptions are made:

- The style declarations will be appended to the stack. If you wish for them to replace the stack or be added to
  the top, you will need to pass 'SET' or 'PREPEND', respectively, as the first argument to ``captureStart()``.

- If you wish to specify any additional attributes for the **<style>** tag, pass them in an array as the second
  argument to ``captureStart()``.


