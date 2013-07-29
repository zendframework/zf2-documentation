.. _zend.view.helpers.initial.htmllist:

View Helper - HtmlList
----------------------

- ``htmlList($items, $ordered, $attribs, $escape)``: generates unordered and ordered lists based on the ``$items``
  passed to it. If ``$items`` is a multidimensional array, a nested list will be built. If the ``$escape`` flag is
  ``TRUE`` (default), individual items will be escaped using the view objects registered escaping mechanisms; pass
  a ``FALSE`` value if you want to allow markup in your lists.

Unordered list
^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   $items = array(
       'Level one, number one',
       array(
           'Level two, number one',
           'Level two, number two',
           array(
               'Level three, number one'
           ),
           'Level two, number three',
       ),
       'Level one, number two',
    );

   echo $this->htmlList($items);

Output:

.. code-block:: html
   :linenos:

   <ul>
       <li>Level one, number one
           <ul>
               <li>Level two, number one</li>
               <li>Level two, number two
                   <ul>
                       <li>Level three, number one</li>
                   </ul>
               </li>
               <li>Level two, number three</li>
           </ul>
       </li>
       <li>Level one, number two</li>
   </ul>

Ordered list
^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   echo $this->htmlList($items, true);

Output:

.. code-block:: html
   :linenos:

   <ol>
       <li>Level one, number one
           <ol>
               <li>Level two, number one</li>
               <li>Level two, number two
                   <ol>
                       <li>Level three, number one</li>
                   </ol>
               </li>
               <li>Level two, number three</li>
           </ol>
       </li>
       <li>Level one, number two</li>
   </ol>

HTML attributes
^^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   $attribs = array(
       'class' => 'foo',
   );

   echo $this->htmlList($items, false, $attribs);

Output:

.. code-block:: html
   :linenos:

   <ul class="foo">
       <li>Level one, number one
           <ul class="foo">
               <li>Level two, number one</li>
               <li>Level two, number two
                   <ul class="foo">
                       <li>Level three, number one</li>
                   </ul>
               </li>
               <li>Level two, number three</li>
           </ul>
       </li>
       <li>Level one, number two</li>
   </ul>

Escape Output
^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   $items = array(
       'Level one, number <strong>one</strong>',
       'Level one, number <em>two</em>',
    );

   // Escape output (default)
   echo $this->htmlList($items);

   // Don't escape output
   echo $this->htmlList($items, false, false, false);

Output:

.. code-block:: html
   :linenos:

   <!-- Escape output (default) -->
   <ul class="foo">
       <li>Level one, number &lt;strong&gt;one&lt;/strong&gt;</li>
       <li>Level one, number &lt;em&gt;two&lt;/em&gt;</li>
   </ul>

   <!-- Don't escape output -->
   <ul class="foo">
       <li>Level one, number <strong>one</strong></li>
       <li>Level one, number <em>two</em></li>
   </ul>
