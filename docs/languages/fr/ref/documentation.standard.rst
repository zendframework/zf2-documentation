.. EN-Revision: none
.. _doc-standard:

*****************************************************
Recommandation sur la documentation de Zend Framework
*****************************************************

.. _doc-standard.overview:

Présentation
------------

.. _doc-standard.overview.scope:

Cadre
^^^^^

Ce document fournit les lignes directrices pour la création de documentation pour Zend Framework. Il s'agit d'un
guide pour les contributeurs, qui doivent écrire la documentation nécessaire lors de la contribution d'un
composant, mais aussi pour les traducteurs. Les recommandations contenues dans le présent document ont pour
objectif de faciliter la traduction de la documentation, de minimiser les différences visuelles et stylistiques
entre les différents fichiers, et de faciliter la recherche de différences avec la commande ``diff``.

Vous pouvez adopter et/ou modifier ces recommandations tant que vous respectez les termes de notre `license`_.

Les sujets couverts dans ce document incluent le format des fichiers ainsi que des recommandations sur le maintien
de la qualité de la documentation.

.. _doc-standard.file-formatting:

Format des fichiers de documentation
------------------------------------

.. _doc-standard.file-formatting.xml-tags:

Balises XML
^^^^^^^^^^^

Chaque fichier du manuel doit inclure la déclaration *XML* suivante à la première ligne du fichier :

.. code-block:: xml
   :linenos:

   <?xml version="1.0" encoding="UTF-8"?>
   <!-- Reviewed: no -->

Les fichiers *XML* provenant des traductions doivent également inclure le tag de révision correspondant au
fichier original en anglais duquel la traduction est tirée.

.. code-block:: xml
   :linenos:

   <?xml version="1.0" encoding="UTF-8"?>
   <!-- EN-Revision: 14978 -->
   <!-- Reviewed: no -->

.. _doc-standard.file-formatting.max-line-length:

Longueur maximum d'une ligne
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La longueur maximum d'une ligne, incluant les balises, les attributs, l'indentation ne doit pas excéder 100
caractères. Il existe une seule exception à cette règle, un couple attribut / valeur peut excéder 100
caractères puisqu'il n'est pas autorisé de les séparer.

.. _doc-standard.file-formatting.indentation:

Indentation
^^^^^^^^^^^

L'indentation est faite de 4 espaces. Les tabulations ne sont pas autorisées.

Les éléments qui sont aux même niveaux doivent avoir la même indentation.

.. code-block:: xml
   :linenos:

   <sect1>
   </sect1>
   <sect1>
   </sect1>

Les éléments qui sont un niveau en-dessous de l'élément précédent doivent être indentés de 4 espaces
supplémentaires.

.. code-block:: xml
   :linenos:

   <sect1>
       <sect2>
       </sect2>
   </sect1>

Plusieurs éléments bloc sur une même ligne ne sont pas autorisés ; plusieurs éléments en-ligne le sont en
revanche.

.. code-block:: xml
   :linenos:

   <!-- NON AUTORISÉ : -->
   <sect1><sect2>
   </sect2></sect1>
   <!-- AUTORISÉ -->
   <para>
       <classname>Zend_Magic</classname> n'existe pas. <classname>Zend\Permissions\Acl</classname> existe.
   </para>

.. _doc-standard.file-formatting.line-termination:

Fin de ligne
^^^^^^^^^^^^

Les fins de ligne suivent les conventions de fichier Unix. Les lignes doivent être terminées par un seul saut de
ligne (LF), le caractère de saut de ligne s'écrit 10 en notation ordinal 10, et 0x0A en hexadécimal.

Note : N'utilisez pas les retours chariot (*CR*) comme c'est le cas sur les systèmes Apple, ni l'association d'un
retour chariot avec un saut de ligne (*CRLF*) qui est le standard sur les systèmes Windows (0X0D, 0x0A).

.. _doc-standard.file-formatting.empty-tags:

Éléments vides
^^^^^^^^^^^^^^

Les éléments vides ne sont pas autorisés, tous les éléments doivent contenir du texte ou des éléments
enfants.

.. code-block:: xml
   :linenos:

   <!-- NON AUTORISÉ : -->
   <para>
       Lorem ipsum. <link></link>
   </para>
   <para>
   </para>

.. _doc-standard.file-formatting.whitespace:

Utilisation des espaces dans les documents
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _doc-standard.file-formatting.whitespace.trailing:

Espace entre les balises
^^^^^^^^^^^^^^^^^^^^^^^^

Les balises ouvrantes des éléments bloc ne devrait pas être suivi par autre chose qu'un saut de ligne (et
l'indentation de la ligne suivante).

.. code-block:: xml
   :linenos:

   <!-- NON AUTORISÉ : -->
   <sect1>ESPACE
   </sect1>

Les balises ouvrantes des éléments en-ligne ne devrait pas être suivi d'espace.

.. code-block:: xml
   :linenos:

   <!-- NON AUTORISÉ : -->
   C'est la classe <classname> Zend_Class</classname>.
   <!-- AUTORISÉ : -->
   C'est la classe <classname>Zend_Class</classname>.

Les balises des éléments bloc peuvent être précédés par des espaces, si ceux-ci sont équivalents aux nombres
d'espaces nécessaires pour l'indentation, mais pas plus.

.. code-block:: xml
   :linenos:

   <!-- NON AUTORISÉ : -->
       <sect1>
        </sect1>
   <!-- AUTORISÉ : -->
       <sect1>
       </sect1>

Les balises des éléments en-ligne ne doivent pas être précédés d'espaces.

.. code-block:: xml
   :linenos:

   <!-- NON AUTORISÉ -->
   C'est la classe <classname>Zend_Class </classname>
   <!-- AUTORISÉ -->
   C'est la classe  <classname>Zend_Class</classname>

.. _doc-standard.file-formatting.whitespace.multiple-line-breaks:

Sauts de ligne multiples
^^^^^^^^^^^^^^^^^^^^^^^^

Les sauts de ligne multiples ne sont pas autorisés ni dans les balises, ni entre elles.

.. code-block:: xml
   :linenos:

   <!-- NON AUTORISÉ -->
   <para>
       Lorem ipsum...
       ... dolor sid amet
   </para>


   <para>
       Un autre paragraphe.
   </para>
   <!-- AUTORISÉ -->
   <para>
       Lorem ipsum...
       ... dolor sid amet
   </para>

   <para>
       Un autre paragraphe.
   </para>

.. _doc-standard.file-formatting.whitespace.tag-separation:

Séparation entre les balises
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Les éléments qui sont au même niveau doivent être séparés par une ligne vide pour améliorer la lisibilité.

.. code-block:: xml
   :linenos:

   <!-- NON AUTORISÉ -->
   <para>
       Lorem ipsum...
   </para>
   <para>
       Dolor sid amet...
   </para>
   <!-- AUTORISÉ -->
   <para>
       Lorem ipsum...
   </para>

   <para>
       Dolor sid amet...
   </para>

Le premier élément enfant devrait être ouvert directement après son parent, sans ligne vide entre eux ; le
dernier élément enfant quant à lui, devrait être fermé juste avant la balise fermante de son parent.

.. code-block:: xml
   :linenos:

   <!-- NON AUTORISÉ -->
   <sect1>

       <sect2>
       </sect2>

       <sect2>
       </sect2>

       <sect2>
       </sect2>

   </sect1>
   <!-- AUTORISÉ -->
   <sect1>
       <sect2>
       </sect2>

       <sect2>
       </sect2>

       <sect2>
       </sect2>
   </sect1>

.. _doc-standard.file-formatting.program-listing:

Exemple de code
^^^^^^^^^^^^^^^

La balise ouvrante de l'élement **<programlisting>** doit indiquer l'attribut de langage (language) approprié et
doit être indenté au même niveau que ces blocs frères.

.. code-block:: xml
   :linenos:

   <para>Paragraphe frère.</para>
   <programlisting language="php"><![CDATA[

*CDATA* devrait être utilisé autour de tous les exemples de code.

Les sections **<programlisting>** ne doivent pas contenir de saut de ligne ou d'espace ni au début ni à la fin,
étant donné qu'ils sont représentés tels quels.

.. code-block:: xml
   :linenos:

   <!-- NON AUTORISÉ -->
   <programlisting language="php"><![CDATA[
   $render = "xxx";
   ]]></programlisting>
   <!-- AUTORISÉ -->
   <programlisting language="php"><![CDATA[
   $render = "xxx";
   ]]></programlisting>

La fermeture des éléments *CDATA* et **<programlisting>** devrait être sur la même ligne, sans aucune
indentation.

.. code-block:: xml
   :linenos:

   <!-- NON AUTORISÉ -->
       <programlisting language="php"><![CDATA[
   $render = "xxx";
   ]]>
       </programlisting>
   <!-- NON AUTORISÉ -->
       <programlisting language="php"><![CDATA[
   $render = "xxx";
       ]]></programlisting>
   <!-- AUTORISÉ -->
       <programlisting language="php"><![CDATA[
   $render = "xxx";
   ]]></programlisting>

L'élément **<programlisting>** devrait contenir l'attribut de langage avec la valeur appropriée au contenu. Les
valeurs les plus courantes sont "css", "html", "ini", "javascript", "text", et "xml".

.. code-block:: xml
   :linenos:

   <!-- PHP -->
   <programlisting language="php"><![CDATA[
   <!-- Javascript -->
   <programlisting language="javascript"><![CDATA[
   <!-- XML -->
   <programlisting language="xml"><![CDATA[

Pour les exemples contenant uniquement du code *PHP*, Les balises *PHP* ("<?php" et "?>") ne sont pas requises, et
ne devrait pas être utilisées. Elles compliquent la lisibilité du code, et sont implicites lors de l'utilisation
de l'élément **<programlisting>**.

.. code-block:: xml
   :linenos:

   <!-- NON AUTORISÉ -->
   <programlisting language="php"<![CDATA[<?php
       // ...
   ?>]]></programlisting>
   <programlisting language="php"<![CDATA[
   <?php
       // ...
   ?>
   ]]></programlisting>

La longueur maximum des lignes pour les exemples de code devrait suivre les recommandations de la :ref:`convention
de codage <coding-standard.php-file-formatting.max-line-length>`.

Évitez d'utiliser ``require_once()``, ``require()``, ``include_once()``, et ``include()`` dans les exemples *PHP*.
Ils emcombrent la documentation, et sont la plupart du temps inutile si vous utilisez un autoloader. Utilisez-les
uniquement lorsqu'ils sont essentiels à la compréhension d'un exemple.

.. note::

   **N'utilisez jamais les short tags**

   Les short tags (e.g., "<?", "<?=") ne devrait jamais être utilisés dans l'élément **programlisting** ni dans
   le reste de la documentation.

.. _doc-standard.file-formatting.inline-tags:

Notes spécifiques sur les éléments en-ligne
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _doc-standard.file-formatting.inline-tags.classname:

classname
^^^^^^^^^

L'élément **<classname>** doit être utilisé chaque fois que le nom d'une classe est mentionné ; il ne doivent
cependant pas être utilisé lorsque celle-ci est associé au nom d'une méthode, d'un membre, ou d'une constante,
rien d'autre n'est autorisé dans cet élément.

.. code-block:: xml
   :linenos:

   <para>
       La classe <classname>Zend_Class</classname>.
   </para>

.. _doc-standard.file-formatting.inline-tags.varname:

varname
^^^^^^^

Les variables doivent être entourées par les balises **<varname>**. Les variables doivent être écrites en
utilisant le symbole "$". Rien d'autre n'est autorisé dans cet élément, excepté le nom d'une classe, s'il
s'agit d'un membre de celle-ci.

.. code-block:: xml
   :linenos:

   <para>
       La variable <varname>$var</varname> et le membre de classe
       <varname>Zend_Class::$var</varname>.
   </para>

.. _doc-standard.file-formatting.inline-tags.methodname:

methodname
^^^^^^^^^^

Les méthodes doivent être entourées par les balises **<methodname>**. Les méthodes doivent soit contenir la
signature complète, soit au moins une paire de parenthèses (ex : "()"). Aucun autre contenu n'est autorisé dans
cet élément, excepté le nom d'une classe, pour indiquer qu'il s'agit d'une méthode de celle-ci.

.. code-block:: xml
   :linenos:

   <para>
       La fonction <methodname>foo()</methodname> et la méthode
       <methodname>Zend_Class::foo()</methodname>. Une fonction avec une signature :
       <methodname>foo($bar, $baz)</methodname>
   </para>

.. _doc-standard.file-formatting.inline-tags.constant:

constant
^^^^^^^^

Utilisez l'élément **<constant>** pour indiquer qu'il s'agit d'une constante. Les constantes doivent être
écrites en majuscules. Aucun autre contenu n'est autorisé, excepté le nom d'une classe, pour indiquer qu'il
s'agit d'une constante de classe.

.. code-block:: xml
   :linenos:

   <para>
       La constante <constant>FOO</constant> et la constante de classe
       <constant>Zend_Class::FOO</constant>.
   </para>

.. _doc-standard.file-formatting.inline-tags.filename:

filename
^^^^^^^^

Les noms de fichier et chemins doivent être entourés par les balises **<filename>**. Aucun autre contenu n'est
autorisé dans cet élément.

.. code-block:: xml
   :linenos:

   <para>
       Le nom de fichier <filename>application/Bootstrap.php</filename>.
   </para>

.. _doc-standard.file-formatting.inline-tags.command:

command
^^^^^^^

Les commandes, les scripts shell, ainsi que l'appel de programme doivent être entourés par les balises
**<command>**. Si la commande nécessite des arguments, ceux-ci doivent également être présent.

.. code-block:: xml
   :linenos:

   <para>
       Executez <command>zf.sh create project</command> pour créer un projet.
   </para>

.. _doc-standard.file-formatting.inline-tags.code:

code
^^^^

L'utilisation de l'élément **<code>** est déconseillée, en faveur des autres éléments discutés
précédement.

.. _doc-standard.file-formatting.block-tags:

Notes spécifiques sur les éléments bloc
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _doc-standard.file-formatting.block-tags.title:

title
^^^^^

L'élément **<title>** ne peut pas contenir d'éléments enfants.

.. code-block:: xml
   :linenos:

   <!-- NON AUTORISÉ -->
   <title>Utilisation de <classname>Zend_Class</classname></title>
   <!-- AUTORISÉ -->
   <title>Utilisation de Zend_Class</title>

.. _doc-standard.recommendations:

Recommendations
---------------

.. _doc-standard.recommendations.editors:

Utilisez un éditeur sans formatage automatique
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Pour éditer la documentation, vous ne devriez pas utiliser un éditeur *XML* classique. Ces éditeurs formattent
pour la plupart automatiquement les documents pour s'adapter à leurs propres standards et/ou ne suivent pas
strictement les recommandations du docbook. Par exemple, nous en avons vu certains d'entre eux supprimer
l'élément *CDATA*, remplacer 4 espaces par des tabulations, ou 2 espaces, etc.

Ces recommandations ont été écrites en grande partie afin d'aider les traducteurs à déterminer les changements
en utilisant la commande ``diff``. Le formatage automatique rend cette opération plus difficile.

.. _doc-standard.recommendations.images:

Utilisez des images
^^^^^^^^^^^^^^^^^^^

Les images et les diagrammes peuvent améliorer la lisibilité et la compréhension. Utilisez les chaque fois
qu'ils le permettent. Les images devrait être placées dans le répertoire ``documentation/manual/en/figures/``,
et nommées juste après l'identifiant de la section qui les concerne.

.. _doc-standard.recommendations.examples:

Utilisez des cas d'utilisations
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Cherchez de bons cas d'utilisation soumis par la communauté, particulièrement ceux des commentaires dans les
propositions ou encore sur l'une des liste de discussion. Un exemple vaut mieux qu'un long discours.

Lorsque vous écrivez des exemples à inclure dans le manuel, suivez les conventions de codages ainsi que les
recommandations pour la documentation.

.. _doc-standard.recommendations.phpdoc:

Évitez de répéter le contenu des phpdoc
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ce manuel a pour objectif d'être une référence pour l'utilisateur final. Recopier la documentation phpdoc pour
expliquer le fonctionnenement interne des composants et des classes n'est pas souhaité, l'accent devrait être mis
sur l'utilisation. Dans tous les cas, nous souhaiterions que l'équide de documentation se concentre sur la
traduction du manuel anglais, et non pas les commentaires phpdoc.

.. _doc-standard.recommendations.links:

Utilisez des liens
^^^^^^^^^^^^^^^^^^

Créez des liens vers les autres sections ou des ressources externes plutôt que de tout réécrire.

Les liens vers d'autres sections du manuel peuvent aussi bien utiliser l'élement **<xref>** (qui substitura le
titre de la section pour créer le nom du lien) ou l'élément **<link>** (pour lequel vous devez fournir le nom du
lien).

.. code-block:: xml
   :linenos:

   <para>
       "Xref" crée un lien vers la section : <xref
           linkend="doc-standard.recommendations.links" />.
   </para>
   <para>
       "Link" crée un lien vers une section, et utilise un titre explicite : <link
           linkend="doc-standard.recommendations.links">documentation sur la créer de liens</link>.
   </para>

Pour créer un lien vers une ressource externe utilisez l'élément **<ulink>**\  :

.. code-block:: xml
   :linenos:

   <para>
       Le site du <ulink url="http://framework.zend.com/">Zend Framework</ulink>.
   </para>



.. _`license`: http://framework.zend.com/license
