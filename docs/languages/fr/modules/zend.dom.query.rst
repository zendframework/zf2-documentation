.. _zend.dom.query:

Zend_Dom_Query
==============

``Zend_Dom_Query`` fournit des mécanismes pour requêter dans les documents *XML* et (X)HTML en utilisant soit
XPath ou les sélecteurs *CSS*. Il a été développé pour faciliter les tests fonctionnels des applications
*MVC*, mais pourrait également être employé pour le développement rapide de "screen scrapers".

La notation de type sélecteur *CSS* est fournie comme notation plus simple et plus familière pour les
développeurs Web à utiliser lors de la requête de documents ayant une structure de type *XML*. La notation
devrait être familière pour n'importe qui ayant écrit des feuilles de styles *CSS* ou ayant utiliser des
librairies Javascript qui fournissent pour sélectionner des noeuds en utilisant des sélecteurs *CSS*
(`Prototype's $$()`_\ et `Dojo's dojo.query`_\ ont tous les deux inspirer ce composant).

.. _zend.dom.query.operation:

Aspect théorique
----------------

Pour utiliser ``Zend_Dom_Query``, vous instanciez un objet ``Zend_Dom_Query``, en fournissant optionnellement un
document à analyser (sous la forme d'une chaîne). Une fois que vous avez un document, vous pouvez utiliser
indifféremment les méthodes ``query()`` ou ``queryXpath()``\  ; chaque méthode retournera un objet
``Zend_Dom_Query_Result`` avec tout noeud trouvé.

La différence principale entre ``Zend_Dom_Query`` et l'utilisation de DOMDocument + DOMXPath est la possibilité
de requêter avec les sélecteurs *CSS*. Vous pouvez utiliser n'importe quel élément suivant, dans n'importe
quelle combinaison :

- **types de l'élément**\  : fourni un type d'élément à rechercher : "div", "a", "span", "h2", etc.

- **attributs de style**\  : les classes *CSS* à rechercher : ".error", "div.error", "label.required", etc. Si
  un élément défini plus qu'une classe, la correspondance sera trouvé si la classe est présente quelque part
  dans la déclaration de l'attribut.

- **attribut id**\  : ID de l'élément à rechercher : "#content", "div#nav", etc.

- **attributs arbitraires**\  : tout attribut arbitraire de l'élément à rechercher. Trois types de recherche
  sont possibles :

  - **correspondance exacte**\  : l'attribut vaut exactement la chaîne fournie : "div[bar="baz"]" trouvera un
    élément div qui possède un attribut "bar" dont la valeur vaut exactement "baz".

  - **correspondance de mot**\  : l'attribut contient un mot correspondant à la chaîne fournie :
    "div[bar~="baz"]" trouvera un élément div qui possède un attribut "bar" dont la valeur contient le mot
    "baz". "<div bar="foo baz">" trouvera, mais pas "<div bar="foo bazbat">".

  - **correspondance de parties de chaînes**\  : l'attribut contient la chaîne fournie : "div[bar*="baz"]"
    trouvera un élément div qui possède un attribut "bar" dont la valeur contient la chaîne "baz".

- **Descendants directs**\  : utilise ">" entre les sélecteurs pour représenter une descendance direct. "div >
  span" trouvera seulement les éléments "span" qui sont des descendants directs d'un élément "div". Peut aussi
  être utilisé avec chacun des sélecteurs ci-dessus.

- **Descendants**\  : une chaîne avec des sélecteurs multiples ensemble pour indiquer hiérarchie à rechercher.
  "div .foo span #one" trouvera un élément avec un id "one" qui est un descendant avec un profondeur arbitraire
  d'un élément "span", qui est lui-même un descendant avec un profondeur arbitraire d'un élément ayant une
  classe "foo", qui est un descendant avec un profondeur arbitraire d'un élément "div". Par exemple, il trouvera
  le lien vers le mot "One" dans le code ci-dessous :

  .. code-block:: html
     :linenos:

     <div>
         <table>
             <tr>
                 <td class="foo">
                     <div>
                         Lorem ipsum <span class="bar">
                             <a href="/foo/bar" id="one">One</a>
                             <a href="/foo/baz" id="two">Two</a>
                             <a href="/foo/bat" id="three">Three</a>
                             <a href="/foo/bla" id="four">Four</a>
                         </span>
                     </div>
                 </td>
             </tr>
         </table>
     </div>

Une fois que vous avez réalisé votre recherche, vous pouvez ensuite travailler avec l'objet de résultat pour
déterminer les informations sur les noeuds, ainsi que pour les récupérer eux et/ou leurs contenus directement
afin de les examiner et les manipuler. ``Zend_Dom_Query_Result`` implémente *Countable* and *Iterator*, et stocke
le résultat en interne sous la forme DOMNodes/DOMElements. En exemple, considérons l'appel suivant sur l'HTML
ci-dessus :

.. code-block:: php
   :linenos:

   $dom = new Zend_Dom_Query($html);
   $results = $dom->query('.foo .bar a');

   $count = count($results);    // trouvera 4 correspondances
   foreach ($results as $result) {
       // $result is a DOMElement
   }

``Zend_Dom_Query`` permet aussi de faire directement des recherches de type XPath en utilisant la méthode
``queryXpath()``; vous pouvez fournir toute requête XPath valide à cette méthode, et elle retournera un objet
``Zend_Dom_Query_Result``.

.. _zend.dom.query.methods:

Méthodes disponibles
--------------------

La famille des classes ``Zend_Dom_Query`` possèdent les méthodes suivantes.

.. _zend.dom.query.methods.zenddomquery:

Zend_Dom_Query
^^^^^^^^^^^^^^

Ces méthodes sont disponibles pour ``Zend_Dom_Query``\  :

- ``setDocumentXml($document)``\  : spécifie une chaîne *XML* dans laquelle requêter.

- ``setDocumentXhtml($document)``\  : spécifie une chaîne *XHTML* dans laquelle requêter.

- ``setDocumentHtml($document)``\  : spécifie une chaîne HTML dans laquelle requêter.

- ``setDocument($document)``\  : spécifie une chaîne dans laquelle requêter ; ``Zend_Dom_Query`` tentera alors
  de détecter automatiquement le type de document.

- ``getDocument()``\  : récupère le document original fourni à l'objet.

- ``getDocumentType()``\  : récupère le type de document fourni à l'objet ; sera une des constantes de
  classe : ``DOC_XML``, ``DOC_XHTML``, ou ``DOC_HTML``.

- ``query($query)``\  : recherche dans le document en utilisant la notation de type sélecteur *CSS*.

- ``queryXpath($xPathQuery)``\  : recherche dans le document en utilisant la notation XPath.

.. _zend.dom.query.methods.zenddomqueryresult:

Zend_Dom_Query_Result
^^^^^^^^^^^^^^^^^^^^^

Comme mentionné auparavant, ``Zend_Dom_Query_Result`` implémente à la fois *Iterator* et *Countable*, et en tant
que tel peut être utilisé dans une boucle *foreach* ainsi qu'avec la fonction ``count()``. De plus il expose les
méthodes suivantes :

- ``getCssQuery()``\  : retourne le sélecteur *CSS* utilisé pour produire le résultat (si fourni).

- ``getXpathQuery()``\  : retourne la requête XPath utilisé pour produire le résultat, ``Zend_Dom_Query``
  convertit les recherches de type sélecteur *CSS* en notation XPath, donc cette valeur sera toujours présente.

- ``getDocument()``\  : récupère l'élément DOMDocument dans lequel la recherche à été effectuée.



.. _`Prototype's $$()`: http://prototypejs.org/api/utility/dollar-dollar
.. _`Dojo's dojo.query`: http://api.dojotoolkit.org/jsdoc/dojo/HEAD/dojo.query
