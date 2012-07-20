.. _zend.filter.input:

Zend_Filter_Input
=================

Zend_Filter_Input 提供了一个声明接口来联合多重过滤器和校验器，使用
它们来收集数据并在用过滤器和校验器处理之后来获取输入值。为 HTML 输出
安区起见，缺省的返回值是转义格式。

形象地说，这个类是一个外部数据的笼子。数据从外部资源输入到程序，如 HTTP
请求参数、HTTP 头、web 服务或者甚至从数据库或其它文件读取的数据。
首先把数据放入笼子，随后程序只可以通过告诉笼子数据应该是什么样子和如何
使用它来访问数据。笼子检验数据的合法性。对于适当的上下文，可能使用
转义数据。在全部符合这些条件时，笼子才释放数据。用一个简单方便的接口，
它鼓励好的变成习惯并使开发者仔细考虑如何使用数据。

- **Filters** 通过删除或修改字符来 转换输入值，目标是 “规格化”
  输入值一直到它们符合期望的格式。例如： 如果需要数字字符串，而输入值是
  “abc123” ，那么它就被合理地转换成 “123”.

- **Validators** 根据条件来检查输入值并报告输入值是否通过测试。
  它不修改输入值，但检查可能会失败。例如：如果需要一个 email
  地址字符串，而输入值是 “abc123” ，那么这个值就无效。

- **Escapers** 通过去除特定字符的魔术行为（magic behavior）来转换一个值。
  在一些输出山下文中，特殊字符是有它的意义的。例如：字符 '<' 和 '>' 界定 HTML
  标签，如果包含这些字符 的字符串输出到 HTML 上下文，在它们之间的文本可能影响
  HTML 的输出和功能。转义字符除掉了特殊意义，所以它们 的输出就是文字输出了。

为使用 Zend_Filter_Input，执行下列步骤：

. 声明过滤器和校验器规则

. 创建过滤器和校验器的处理器

. 提供输入数据

. 获取被校验的字段和其它报告

下面一节描述使用这个类的步骤。

.. _zend.filter.input.declaring:

声明过滤器和校验器规则
---------------------------------

在创建 Zend_Filter_Input 实例之前，声明过滤器规则数组和校验器规则数组。
这个关联数组映射规则名到过滤器或校验器，或者过滤器或校验器链。

在下面的例子中，过滤器规则设置声明 'month' 字段由 Zend_Filter_Digits 来过滤，'account'
字段由 Zend_Filter_StringTrim 来过滤。校验器规则设置 声明只有如果 'account'
字段只包含字母字符时有效。

.. code-block::
   :linenos:
   <?php
   $filters = array(
       'month'   => 'Digits',
       'account' => 'StringTrim'
   );

   $validators = array(
       'account' => 'Alpha'
   );

在上述 *$filters* 数组中的每个键是应用过滤器到特定数据字段的规则的名称。
缺省地，规则的名称也是使用改规则的输入数据字段的名称。

可以用若干格式来声明一个规则：

- 一个单个的字符串标量（scalar），它映射到一个类名。

     .. code-block::
        :linenos:
        <?php
        $validators = array(
            'month'   => 'Digits',
        );



- 实现 Zend_Filter_Interface 或 Zend_Validate_Interface 的类的一个对象实例。

     .. code-block::
        :linenos:
        <?php
        $digits = new Zend_Validate_Digits();

        $validators = array(
            'month'   => $digits
        );



- 一个数组，声明一个过滤器或者校验器链。这个数组的元素可以是
  映射到类名或过滤器/校验器对象的字符串，就像上述例子一样。
  另外，可以使用第三种选择：包含映射到带有传递给自己的构造器
  的类名的字符串的数组。

     .. code-block::
        :linenos:
        <?php
        $validators = array(
            'month'   => array(
                'Digits',                // string
                new Zend_Validate_Int(), // object instance
                array('Between', 1, 12)  // string with constructor arguments
            )
        );



.. note::

   如果用在数组种带有构造器参数来声明过滤器或校验器，
   即使这个规则只有一个过滤器或校验器，你也必需做一个规则数组。

你可以在过滤器数组或校验器数组里使用特殊的“通配符”规则键'\*'。
意思是在这个规则中声明的过滤器或校验器将应用于所有输入数据域。
注意在过滤器数组或校验器数组里的条目的顺序意义重大，规则使用和你声明时的相同顺序。

.. code-block::
   :linenos:
   <?php
   $filters = array(
       '*'     => 'StringTrim',
       'month' => 'Digits'
   );

.. _zend.filter.input.running:

生成过滤器和校验器的处理器
---------------------------------------

在声明过滤器或校验器数组后，把它们用作 Zend_Filter_Input 的构造器的参数。
它返回一个知道所有过滤和校验规则的对象，你可以用这个对象来处理一组或多组输入数据。

.. code-block::
   :linenos:
   <?php
   $input = new Zend_Filter_Input($filters, $validators);

你可以指定输入数据为第三个构造器参数。数据结构是个关联数组。
键是字段名，值是数据值。在 PHP 中标准的 *$_GET* 和 *$_POST* 全局变量是该格式的例子。
你可以使用这些变量的一个作为 Zend_Filter_Input 的输入数据。

.. code-block::
   :linenos:
   <?php
   $data = $_GET;

   $input = new Zend_Filter_Input($filters, $validators, $data);

另外，使用 *setData()* 方法，用和上述相同的格式传递一个键/值对的关联数组。

.. code-block::
   :linenos:
   <?php
   $input = new Zend_Filter_Input($filters, $validators);
   $input->setData($newData);

*setData()* 方法在一个已存在的 Zend_Filter_Input 对象中
在不改变过滤和校验规则下重定义数据。使用该方法，你可以对不同的数据集
运行相同的规则。

.. _zend.filter.input.results:

获取校验过的字段和其它报告
---------------------------------------

在声明过滤器和校验器与创建输入处理器之后，你可以获取丢失的、未知的和无效字段的报告。
你也可以在应用过滤器之后获得字段的值。

.. _zend.filter.input.results.isvalid:

输入值有效的查询
^^^^^^^^^^^^^^^^^^^^^^^^

如果所有输入数据通过校验， *isValid()* 方法返回 *true*\ 。
如果有任何字段无效或者任何要求的字段不存在，则返回 *false*\ 。

.. code-block::
   :linenos:
   <?php
   if ($input->isValid()) {
     echo "OK\n";
   }

该方法接受一个可选的字符串参数，即一个独立字段。如果指定的字段
通过校验并为读取准备好， *isValid('fieldName')* 返回 *true*\ 。

.. code-block::
   :linenos:
   <?php
   if ($input->isValid('month')) {
     echo "Field 'month' is OK\n";
   }

.. _zend.filter.input.results.reports:

获得无效、丢失或未知的字段
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Invalid** 是不能通过一个或多个校验检查的字段。

- **Missing** 是那些不存在于输入数据，但用 metacommand *'presence'=>'required'*\ （参见在
  metacommands 中 :ref:`后面的章节 <zend.filter.input.metacommands.presence>`\ ）声明过的字段。

- **Unknown**
  是那些没有在任何校验器数组中的规则声明的，但出现在输入数据中的字段。

.. code-block::
   :linenos:
   <?php
   if ($input->hasInvalid() || $input->hasMissing()) {
     $messages = $input->getMessages();
   }

   // getMessages() simply returns the merge of getInvalid() and getMissing()

   if ($input->hasInvalid()) {
     $invalidFields = $input->getInvalid();
   }

   if ($input->hasMissing()) {
     $missingFields = $input->getMissing();
   }

   if ($input->hasUnknown()) {
     $unknownFields = $input->getUnknown();
   }

*getMessages()*
方法的结果是一个关联数组，映射规则名到一个和该规则相关的错误消息的数组。
注意该数组的索引是用在规则声明的规则名，它可能和由该规则检查的字段名不同。

*getMessages()* 方法返回由 *getInvalid()* 和 *getMissing()* 的返回的数组的合并。
这些方法返回消息的子集，和校验失败相关，或者必需声明的字段没有输入。

The *getErrors()* 方法返回一个关联数组，映射规则名到错误识别器的数组。
错误识别器是规定字符串，用来识别校验错误的原因，消息可以定制。 参见 :ref:`
<zend.validate.introduction.using>` 有更多信息。

你可以指定使用 'missingMessage' 选项的 *getMissing()* 返回的消息作为 Zend_Filter_Input
构造器的参数或者使用 *setOptions()* 方法。

.. code-block::
   :linenos:
   <?php
   $options = array(
       'missingMessage' => "Field '%field%' is required"
   );

   $input = new Zend_Filter_Input($filters, $validators, $data, $options);

   // alternative method:

   $input = new Zend_Filter_Input($filters, $validators, $data);
   $input->setOptions($options);

*getUnknown()* 方法的结果是一个关联数组，映射字段名到字段值。
在这个例子中，字段名（而不是规则名）用作数组键，因为不涉及规则的字段被当作未知字段。

.. _zend.filter.input.results.escaping:

获得有效字段
^^^^^^^^^^^^^^^^^^

所有不是无效的、丢失的、未知的字段都是有效的（好像废话一样 Jason Qi）。
你可以用魔术访问器来获得有效字段的值。也有非魔术访问器方法 *getEscaped()* 和
*getUnescaped()*\ 。

.. code-block::
   :linenos:
   <?php
   $m = $input->month;                 // escaped output from magic accessor
   $m = $input->getEscaped('month');   // escaped output
   $m = $input->getUnescaped('month'); // not escaped

缺省地，当读取一个值时，用 Zend_Filter_HtmlEntities 来过滤。 因为它是在 HTML
中输出字段值的最普通的用法，所以它是缺省的。 HtmlEntities
过滤器有助于防止无意识的、可能会导致安全问题的代码输出。

.. note::

   正如上所述，你可以使用 *getUnescaped()* 方法读取非转义的值，
   但必需安全地使用这些值，避免安全问题如被跨站脚本攻击的弱点。

你可以通过在构造器选项数组里指定转义值来为它指定一个不同的过滤器：

.. code-block::
   :linenos:
   <?php
   $options = array('escapeFilter' => 'StringTrim');
   $input = new Zend_Filter_Input($filters, $validators, $data, $options);

另外，你也可以使用 *setDefaultEscapeFilter()* 方法：

.. code-block::
   :linenos:
   <?php
   $input = new Zend_Filter_Input($filters, $validators, $data);
   $input->setDefaultEscapeFilter(new Zend_Filter_StringTrim());

对于任何一种用法，你可以指定转义过滤器作为过滤器类的字符串基础名
或者过滤器类的对象实例。转义过滤器可以是过滤器链的实例、Zend_Filter 类的对象。

转义输出的过滤器应当确保在校验之后运行，其它在过滤器规则的数组中声明的过滤器在数据校验之前应用。
如果转义过滤器在校验之前运行，校验的处理将会很复杂，也将很难提供转义的和非转义的数据版本。
建议使用 *setDefaultEscapeFilter()* 来声明转义输出的过滤器，而不是在 *$filters* 数组中。

只有一个方法 *getEscaped()*\
，所以你只可以为转义（尽管这个过滤器可以是个过滤器链）指定一个过滤器。
如果需要一个单个的 Zend_Filter_Input
实例来返回使用超过一个过滤器方法的转义输出，你应该继承 Zend_Filter_Input
并在你的子类里实现新方法来用不同的方法获取数值。

.. _zend.filter.input.metacommands:

使用 Metacommands 来控制过滤器或校验器规则
--------------------------------------------------------

除了声明从字段到过滤器或校验器的映射，你可以在数组声明中指定一些 "metacommands"
，开控制一些 Zend_Filter_Input 的可选的行为。 Metacommands
在给定的过滤器或校验器数组值里以字符串索引条目的形式出现。

.. _zend.filter.input.metacommands.fields:

The FIELDS metacommand
^^^^^^^^^^^^^^^^^^^^^^

如果过滤器或校验器的规则名和需要应用规则的字段名不同，可以用 'fields' metacommand
来指定字段名。

可以用类常量 *Zend_Filter_Input::FIELDS* 而不是字符串来指定这个 metacommand。

.. code-block::
   :linenos:
   <?php
   $filters = array(
       'month' => array(
           'Digits',        // filter name at integer index [0]
           'fields' => 'mo' // field name at string index ['fields']
       )
   );

在上例中，过滤器规则使用 'digits' 过滤器给名为 'mo' 的输入字段。 字符串 'month'
变成这个过滤规则的助记键，如果用 'fields' metacommand
指定字段，它不能用做字段名，但可用作规则名。

'fields' metacommand 的缺省值是当前规则的索引。在上例中，如果 'fields' metacommand
没有被指定，规则就应用于名为 'month' 的输入字段。

'fields' metacommand
的另一个使用是为过滤器或校验器指定字段，这里过滤器或校验器要求多个字段作为输入。
如果 'fields' metacommand 是个数组，过滤器或校验器相应的参数是一个那些字段值的数组。
例如，通常用户会在两个字段中指定密码字符串，他们必需在两个字段中输入相同的字符串。
假定你实现一个校验器类，带有一个数组参数，如果数组中所有的值彼此相等，就返回
*true*\ 。

.. code-block::
   :linenos:
   <?php
   $validators = array(
       'password' => array(
           'StringEquals',
           'fields' => array('password1', 'password2')
       )
   );
   // Invokes hypothetical class Zend_Validate_StringEquals, passing an array argument
   // containing the values of the two input data fields named 'password1' and 'password2'.

如果这个规则校验失败，规则键（ *'password'*\ ）用于 *getInvalid()* 的返回值，不是命名在
'fields' metacommand 中的其它字段。

.. _zend.filter.input.metacommands.presence:

The PRESENCE metacommand
^^^^^^^^^^^^^^^^^^^^^^^^

在校验器数组里的每个条目可能有一个叫做 'presence' 的 metacommand。 如果这个 metacommand
的值是 'required'，那么字段必需存在于输入数据， 否则，就报告为丢失字段。

你可以用类常量 *Zend_Filter_Input::PRESENCE* 而不是字符串来指定这个 metacommand。

.. code-block::
   :linenos:
   <?php
   $validators = array(
       'month' => array(
           'digits',
           'presence' => 'required'
       )
   );

这个 metacommand 的缺省值是 'optional'。

.. _zend.filter.input.metacommands.default:

The DEFAULT_VALUE metacommand
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

如果字段没有出现在输入数据里，并且你为了规则为 'default' metacommand 指定一个值，
这个字段就用 metacommand 的值。

你可以用类常量 *Zend_Filter_Input::DEFAULT_VALUE* 而不是字符串来指定这个 metacommand。

在任何校验器被调用之前，这个缺省值被分配给字段。缺省值只为当前规则应用于字段，
如果同样的字段在后来的规则被引用，当评估规则时字段没有值。
这样，对于给定的字段不同的规则可以声明不同的缺省值。

.. code-block::
   :linenos:
   <?php
   $validators = array(
       'month' => array(
           'digits',
           'default' => '1'
       )
   );

   // no value for 'month' field
   $data = array();

   $input = new Zend_Filter_Input(null, $validators, $data);
   echo $input->month; // echoes 1

如果你的规则使用 *FIELDS* metacommand 来定义多重字段的数组， 你可以为 *DEFAULT_VALUE*
metacommand 定义一个数组并且相应键的缺省用于任何丢失的字段。 如果 *FIELDS*
定义多重字段但 *DEFAULT_VALUE* 是个标量，那么 缺省值用于任何在数组中的丢失的字段。

这个 metacommand 没有缺省值。

.. _zend.filter.input.metacommands.allow-empty:

The ALLOW_EMPTY metacommand
^^^^^^^^^^^^^^^^^^^^^^^^^^^

缺省地，如果一个字段存在于输入数据，那么校验器就应用其上，即使字段值是空的（
*''*\ ）。
这可能导致一个校验失败，例如：如果校验器检查数字字符，并且因为零长度字符串是没有字符，那么校验器就报告数据错误。

如果读你来说空字符应当认为有效，你可以设置 metacommand 'allowEmpty' 为 *true*\ 。
这样空字符的输入数据就可以通过校验。

你可以用类常量 *Zend_Filter_Input::ALLOW_EMPTY* 而不是字符串来指定这个 metacommand。

.. code-block::
   :linenos:
   <?php
   $validators = array(
       'address2' => array(
           'Alnum',
           'allowEmpty' => true
       )
   );

这个 metacommand 的缺省值是 *false*\ 。

在非正常情况下你声明没有校验器的校验规则，但 'allowEmpty' metacommand 是 *false*
（即如果字段是空的就被认为无效）， Zend_Filter_Input 返回缺省错误消息，你可以用
*getMessages()* 来读取。 你可以用 'notEmptyMessage' 选项作为 Zend_Filter_Input
构造器的参数或使用 *setOptions()* 方法来指定这个消息。

.. code-block::
   :linenos:
   <?php
   $options = array(
       'notEmptyMessage' => "A non-empty value is required for field '%field%'"
   );

   $input = new Zend_Filter_Input($filters, $validators, $data, $options);

   // alternative method:

   $input = new Zend_Filter_Input($filters, $validators, $data);
   $input->setOptions($options);

.. _zend.filter.input.metacommands.break-chain:

The BREAK_CHAIN metacommand
^^^^^^^^^^^^^^^^^^^^^^^^^^^

缺省地，如果一个规则有多于一个校验器，所有校验器应用于输入，并且返回的消息包含所有由输入导致的错误消息。

另外，如果 'breakChainOnFailure' metacommand 的值是 *true*\ ，
校验器链在第一次校验失败时就终止，输入数据不再被链中的后来的校验器检查，
即使你纠正被报告的那一个，也很可能导致更多的冲突。

你可以用类常量 *Zend_Filter_Input::BREAK_CHAIN* 而不是字符串来指定这个 metacommand。

.. code-block::
   :linenos:
   <?php
   $validators = array(
       'month' => array(
           'Digits',
           new Zend_Validate_Between(1,12),
           new Zend_Validate_GreaterThan(0),
           'breakChainOnFailure' => true
       )
   );
   $input = new Zend_Filter_Input(null, $validators);

这个 metacommand 的缺省值是 *false*\ 。

校验器链类 Zend_Validate 在中断链执行方面比 Zend_Filter_Input 更灵活。
对于前者，你可以设置选项来对链中每个校验器独立地根据失败来中断链。
对于后者，'breakChainOnFailure' metacommand
的定义值对规则来说一律适用所有规则中的校验器。
如果你需要更灵活的用法，要创建自己的校验器链，在校验器规则定义里把它用作一个对象：

.. code-block::
   :linenos:
   <?php
   // Create validator chain with non-uniform breakChainOnFailure attributes
   $chain = new Zend_Validate();
   $chain->addValidator(new Zend_Validate_Digits(), true);
   $chain->addValidator(new Zend_Validate_Between(1,12), false);
   $chain->addValidator(new Zend_Validate_GreaterThan(0), true);

   // Declare validator rule using the chain defined above
   $validators = array(
       'month' => $chain
   );
   $input = new Zend_Filter_Input(null, $validators);

.. _zend.filter.input.metacommands.messages:

The MESSAGES metacommand
^^^^^^^^^^^^^^^^^^^^^^^^

你可以使用 metacommand 'messages' 为在规则中的每个校验器指定错误消息。 这个 metacommand
的值在规则中根据你是否有多重校验器而不同，
或者如果你想在给定的校验器中为特定错误条件设置消息。

你可以用类常量 *Zend_Filter_Input::MESSAGES* 而不是字符串来指定这个 metacommand。

下面是为单个校验器设置缺省错误消息的例子。

.. code-block::
   :linenos:
   <?php
   $validators = array(
       'month' => array(
           'digits',
           'messages' => 'A month must consist only of digits'
       )
   );

如果你想给多重校验器设置错误消息，对 'messages' metacommand 的值应当使用一个数组。

这个数组的每个元素应用于在同一索引位置的校验器。你可以通过把值 **n**
作为数组索引为在 **n** 位置的校验器指定消息。
这样当在链中为后来的校验器设置消息，一些校验器就使用它们自己的缺省消息。

.. code-block::
   :linenos:
   <?php
   $validators = array(
       'month' => array(
           'digits',
           new Zend_Validate_Between(1, 12),
           'messages' => array(
               // use default message for validator [0]
               // set new message for validator [1]
               1 => 'A month value must be between 1 and 12'
           )
       )
   );

如果你的校验器其中一个有多重错误消息，它们由消息键来识别。
在每个校验器类里有不同的键，作为识别器服务于各自校验器类可能产生的错误消息。
每个校验类为它的消息键定义常量。你可以通过传递关联数组而不是字符串来在
'messages' metacommand 里使用这些键。

.. code-block::
   :linenos:
   <?php
   $validators = array(
       'month' => array(
           'digits', new Zend_Validate_Between(1, 12),
           'messages' => array(
               'A month must consist only of digits',
               array(
                   Zend_Validate_Between::NOT_BETWEEN =>
                       'Month value %value% must be between %min% and %max%',
                   Zend_Validate_Between::NOT_BETWEEN_STRICT =>
                       'Month value %value% must be strictly between %min% and %max%'
               )
           )
       )
   );

你应当参考每个校验器类的文档来获知它是否有多重错误消息、这些消息的键和可用于消息模板的令牌。

.. _zend.filter.input.metacommands.global:

对所有的规则使用选项来设置 metacommands
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

'allowEmpty'、 'breakChainOnFailure' 和 'presence' metacommands 的缺省值可以使用 Zend_Filter_Input
构造器的 *$options* 参数来为所有的规则设置。
它让你为所有的规则设置缺省值而不需要为每个规则设置 metacommand。

.. code-block::
   :linenos:
   <?php
   // The default is set so all fields allow an empty string.
   $options = array('allowEmpty' => true);

   // You can override this in a rule definition,
   // if a field should not accept an empty string.
   $validators = array(
       'month' => array(
           'Digits',
           'allowEmpty' => false
       )
   );

   $input = new Zend_Filter_Input($filters, $validators, $data, $options);

'fields'、'messages' 和 'default' metacommands 不能用这个技术来设置。

.. _zend.filter.input.namespaces:

添加过滤器类命名空间
------------------------------

缺省地，当声明一个过滤器或校验器为一个字符串，Zend_Filter_Input 就搜索在 Zend_Filter 或
Zend_Validate 命名空间下的相应的类。 例如：名为字符串 'digits' 的过滤器在
Zend_Filter_digits 类中。

如果你写自己的过滤器或校验器类，或使用由第三方提供的过滤器或校验器，这些类存在于不同于
Zend_Filter 或 Zend_Validate 的命名空间。 你可以告诉 Zend_Filter_Input 搜索更多的命名空间，
你可以在构造器选项里指定命名空间：

.. code-block::
   :linenos:
   <?php
   $options = array('inputNamespace' => 'My_Namespace');
   $input = new Zend_Filter_Input($filters, $validators, $data, $options);

另外，你可以使用 addNamespace() 方法：

.. code-block::
   :linenos:
   <?php
   $input->addNamespace('Other_Namespace');

   // Now the search order is:
   // 1. My_Namespace
   // 2. Other_Namespace
   // 3. Zend_Filter
   // 4. Zend_Validate

你不能删除 Zend_Filter 和 Zend_Validate
的命名空间，只可以添加命名空间，系统首先搜索用户定义的命名空间，然后搜索 Zend
命名空间。

.. note::

   从版本 1.0.4 开始， *Zend_Filter_Input::NAMESPACE*, 把值 *namespace* 改成
   *Zend_Filter_Input::INPUT_NAMESPACE*\ ，使用值 *inputNamespace* 是为了服从 PHP 5.3 的保留字
   *namespace* 。


