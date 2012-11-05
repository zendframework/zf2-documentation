.. EN-Revision: none
.. _zend.file.transfer.introduction:

Zend\File\Transfer
==================

*Zend\File\Transfer* 让开发者控制文件上载和下载。它有用于文件的内置的校验器
并且甚至可以用过滤器来修改文件。 *Zend\File\Transfer* 使用适配器，这样对于
不同的传输协议如 HTTP、 FTP、 WEBDAV 等等就可以使用相同的 API。

.. note::

   **局限**

   当前的 *Zend\File\Transfer* 实现包含在 1.6.0 版中，仅限于 HTTP Post 上载。文件下载和
   其它适配器在下次发行时会增加。没实现的功能会抛出异常。所以应该直接使用
   *Zend\File\Transfer\Adapter\Http* 的实例。 当多重适配器可用时，这个就会改变。

*Zend\File\Transfer* 的用法非常简单。它包括两个部分：用于上载的 HTTP 表单和用
*Zend\File\Transfer* 来处理上载文件。参见下面的例子：

.. _zend.file.transfer.introduction.example:

.. rubric:: 简单的文件上载表单

本例示范了一个基本的文件上传，它使用 *Zend\File\Transfer* 来完成。
第一部分是文件表单。在例子中，有一个文件要上载。

.. code-block:: php
   :linenos:

   <form enctype="multipart/form-data" action="/file/upload" method="POST">
       <input type="hidden" name="MAX_FILE_SIZE" value="100000" />
           Choose a file to upload: <input name="uploadedfile" type="file" />
       <br />
       <input type="submit" value="Upload File" />
   </form>


注意利用 :ref:`Zend\Form_Element\File <zend.form.standardElements.file>` 而不需要手工编写 HTML。

下一步是生成上载的接收者。在本例中接收者是 */file/upload* 。所以我们就编写
带有动作 *upload* 的控制器 *file* 。

.. code-block:: php
   :linenos:

   $adapter = new Zend\File\Transfer\Adapter\Http();

   $adapter->setDestination('C:\temp');

   if (!$adapter->receive()) {
       $messages = $adapter->getMessages();
       echo implode("\n", $messages);
   }


正如你所看到的简单的用法，使用 *setDestination* 定义一个目的地然后调用 *receive()*
方法。 如果有任何上载错误，就会包含在返回的异常里。

.. note::

   **注意**

   记住这只是个最简单的用法，应该 **永远不要**\ 仅仅把它用于实际的环境，
   因为它有严重的安全问题。实际中需要用校验器来增强安全性。


