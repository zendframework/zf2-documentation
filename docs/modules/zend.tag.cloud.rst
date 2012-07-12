
Zend_Tag_Cloud
==============

``Zend_Tag_Cloud`` is the rendering part of ``Zend_Tag`` . By default it comes with a set of *HTML* decorators, which allow you to create tag clouds for a website, but also supplies you with two abstract classes to create your own decorators, to create tag clouds in *PDF* documents for example.

You can instantiate and configure ``Zend_Tag_Cloud`` either programatically or completely via an array or an instance of ``Zend_Config`` . The available options are:

.. _zend.tag.cloud.decorators:

Decorators
----------

``Zend_Tag_Cloud`` requires two types of decorators to be able to render a tag cloud. This includes a decorator which renders the single tags as well as a decorator which renders the surounding cloud. ``Zend_Tag_Cloud`` ships a default decorator set for formatting a tag cloud in *HTML* . This set will by default create a tag cloud as ul/li-list, spread with different font-sizes according to the weight values of the tags assigned to them.

.. _zend.tag.cloud.decorators.htmltag:

HTML Tag decorator
------------------

The *HTML* tag decorator will by default render every tag in an anchor element, surounded by a li element. The anchor itself is fixed and cannot be changed, but the surounding element(s) can.

.. note::
    **URL parameter**

    As the *HTML* tag decorator always surounds the tag title with an anchor, you should define an *URL* parameter for every tag used in it.

The tag decorator can either spread different font-sizes over the anchors or a defined list of classnames. When setting options for one of those possibilities, the corespondening one will automatically be enabled. The following configuration options are available:

    - fontSizeUnit: defines the font-size unit
    - used for all font-sizes. The possible values are:
    - em, ex, px, in, cm, mm, pt, pc and %.
    - minFontSize: the minimum font-size
    - distributed through the tags (must be an integer).
    - maxFontSize: the maximum font-size
    - distributed through the tags (must be an integer).
    - classList: an arry of classes distributed
    - through the tags.
    - htmlTags: an array of HTML tags
    - surounding the anchor. Each element can either be a string, which
    - is used as element type then, or an array containing
    - an attribute list for the element, defined as key/value
    - pair. In this case, the array key is used as element
    - type.


.. _zend.tag.cloud.decorators.htmlcloud:

HTML Cloud decorator
--------------------

The *HTML* cloud decorator will suround the *HTML* tags with an ul-element by default and add no separation. Like in the tag decorator, you can define multiple surounding *HTML* tags and additionally define a separator. The available options are:

    - separator: defines the separator which
    - is placed between all tags.
    - htmlTags: an array of HTML tags
    - surounding all tags. Each element can either be a string, which
    - is used as element type then, or an array containing
    - an attribute list for the element, defined as key/value
    - pair. In this case, the array key is used as element type.



