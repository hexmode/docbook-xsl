<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>

<!-- ********************************************************************
     $Id$
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<xsl:variable name="list-indent">
  <xsl:choose>
    <xsl:when test="not($man.indent.lists = 0)">
      <xsl:value-of select="$man.indent.width"/>
    </xsl:when>
    <xsl:when test="not($man.indent.refsect = 0)">
      <!-- * "zq" is the name of a register we set for -->
      <!-- * preserving the original default indent value -->
      <!-- * when $man.indent.refsect is non-zero; -->
      <!-- * "u" is a roff unit specifier -->
      <xsl:text>\n(zqu</xsl:text>
    </xsl:when>
    <xsl:otherwise/> <!-- * otherwise, just leave it empty -->
  </xsl:choose>
</xsl:variable>

<!-- ================================================================== -->

<xsl:template match="para[ancestor::listitem or ancestor::step or ancestor::glossdef]|
	             simpara[ancestor::listitem or ancestor::step or ancestor::glossdef]|
		     remark[ancestor::listitem or ancestor::step or ancestor::glossdef]">
  <xsl:call-template name="mixed-block"/>
  <xsl:text>&#10;</xsl:text>
  <xsl:if test="following-sibling::*[1][
                self::para or
                self::simpara or
                self::remark
                ]">
    <!-- * Make sure multiple paragraphs within a list item don't -->
    <!-- * merge together.                                        -->
    <xsl:text>&#x2302;sp&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="variablelist|glosslist">
  <xsl:if test="title">
    <xsl:text>&#x2302;PP&#10;</xsl:text>
    <xsl:apply-templates mode="bold" select="title"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="varlistentry|glossentry">
  <xsl:text>&#x2302;PP&#10;</xsl:text> 
  <xsl:for-each select="term|glossterm">
    <xsl:variable name="content">
      <xsl:apply-templates/>
    </xsl:variable>
    <xsl:value-of select="normalize-space($content)"/>
    <xsl:choose>
      <xsl:when test="position() = last()"/> <!-- do nothing -->
      <xsl:otherwise>
        <!-- * if we have multiple terms in the same varlistentry, generate -->
        <!-- * a separator (", " by default) and/or an additional line -->
        <!-- * break after each one except the last -->
        <!-- * -->
        <!-- * note that it is not valid to have multiple glossterms -->
        <!-- * within a glossentry, so this logic never gets exercised -->
        <!-- * for glossterms (every glossterm is always the last in -->
        <!-- * its parent glossentry) -->
        <xsl:value-of select="$variablelist.term.separator"/>
        <xsl:if test="not($variablelist.term.break.after = '0')">
          <xsl:text>&#10;</xsl:text>
          <xsl:text>&#x2302;br&#10;</xsl:text>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
  <xsl:text>&#10;</xsl:text>
  <xsl:text>&#x2302;RS</xsl:text> 
  <xsl:if test="not($list-indent = '')">
    <xsl:text> </xsl:text>
    <xsl:value-of select="$list-indent"/>
  </xsl:if>
  <xsl:text>&#10;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&#x2302;RE&#10;</xsl:text>
</xsl:template>

<xsl:template match="varlistentry/term"/>
<xsl:template match="glossentry/glossterm"/>

<xsl:template match="variablelist[ancestor::listitem or ancestor::step or ancestor::glossdef]|
                     glosslist[ancestor::listitem or ancestor::step or ancestor::glossdef]">
  <xsl:text>&#10;</xsl:text>
  <xsl:text>&#x2302;RS</xsl:text> 
  <xsl:if test="not($list-indent = '')">
    <xsl:text> </xsl:text>
    <xsl:value-of select="$list-indent"/>
  </xsl:if>
  <xsl:text>&#10;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&#x2302;RE&#10;</xsl:text>
  <xsl:if test="following-sibling::node() or
                parent::para[following-sibling::node()] or
                parent::simpara[following-sibling::node()] or
                parent::remark[following-sibling::node()]">
    <xsl:text>&#x2302;IP ""</xsl:text> 
    <xsl:if test="not($list-indent = '')">
      <xsl:text> </xsl:text>
      <xsl:value-of select="$list-indent"/>
    </xsl:if>
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="varlistentry/listitem|glossentry/glossdef">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="itemizedlist/listitem">
  <!-- * We output a real bullet here (rather than, "\(bu", -->
  <!-- * the roff bullet) because, when we do character-map -->
  <!-- * processing before final output, the character-map will -->
  <!-- * handle conversion of the &#x2022; to "\(bu" for us -->
  <xsl:text>&#10;</xsl:text>
  <xsl:text>&#x2302;RS</xsl:text>
  <xsl:if test="not($list-indent = '')">
    <xsl:text> </xsl:text>
    <xsl:value-of select="$list-indent"/>
  </xsl:if>
  <xsl:text>&#10;</xsl:text>
  <xsl:text>\h'-</xsl:text>
    <xsl:if test="not($list-indent = '')">
    <xsl:text>0</xsl:text>
    <xsl:value-of select="$list-indent"/>
  </xsl:if>
  <xsl:text>'</xsl:text>
  <xsl:text>&#x2022;</xsl:text>
  <xsl:text>\h'+</xsl:text>
    <xsl:if test="not($list-indent = '')">
    <xsl:text>0</xsl:text>
    <xsl:value-of select="$list-indent - 1"/>
  <xsl:text>'</xsl:text>
  </xsl:if>
  <xsl:apply-templates/>
  <xsl:text>&#x2302;RE&#10;</xsl:text>
</xsl:template>

<xsl:template match="orderedlist/listitem|procedure/step">
  <xsl:text>&#10;</xsl:text>
  <xsl:text>&#x2302;RS</xsl:text>
  <xsl:if test="not($list-indent = '')">
    <xsl:text> </xsl:text>
    <xsl:value-of select="$list-indent"/>
  </xsl:if>
  <xsl:text>&#10;</xsl:text>
  <xsl:text>\h'-</xsl:text>
    <xsl:if test="not($list-indent = '')">
    <xsl:text>0</xsl:text>
    <xsl:value-of select="$list-indent"/>
  </xsl:if>
  <xsl:text>'</xsl:text>
  <xsl:if test="count(preceding-sibling::listitem) &lt; 9">
    <xsl:text> </xsl:text>
  </xsl:if>
  <xsl:number format="1."/>
  <xsl:text>\h'+</xsl:text>
    <xsl:if test="not($list-indent = '')">
    <xsl:text>0</xsl:text>
    <xsl:value-of select="$list-indent - 2"/>
  <xsl:text>'</xsl:text>
  </xsl:if>
  <xsl:apply-templates/>
  <xsl:text>&#x2302;RE&#10;</xsl:text>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="itemizedlist|orderedlist|procedure">
  <xsl:if test="title">
    <xsl:text>&#x2302;PP&#10;</xsl:text>
    <xsl:apply-templates mode="bold" select="title"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
  <!-- * DocBook allows just about any block content to appear in -->
  <!-- * lists before the actual list items, so we need to get that -->
  <!-- * content (if any) before getting the list items -->
  <xsl:apply-templates
      select="*[not(self::listitem) and not(self::title)]"/>
  <xsl:apply-templates select="listitem"/>
  <!-- * If this list is a child of para and has content following -->
  <!-- * it, within the same para, then add a blank line and move -->
  <!-- * the left margin back to where it was -->
  <xsl:if test="parent::para and following-sibling::node()">
    <xsl:text>&#x2302;sp&#10;</xsl:text>
    <xsl:text>&#x2302;RE&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="itemizedlist[ancestor::listitem or ancestor::step  or ancestor::glossdef]|
	             orderedlist[ancestor::listitem or ancestor::step or ancestor::glossdef]|
                     procedure[ancestor::listitem or ancestor::step or ancestor::glossdef]">
  <xsl:if test="title">
    <xsl:text>&#x2302;PP&#10;</xsl:text>
    <xsl:apply-templates mode="bold" select="title"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
  <xsl:apply-templates/>
  <xsl:if test="following-sibling::node() or
                parent::para[following-sibling::node()] or
                parent::simpara[following-sibling::node()] or
                parent::remark[following-sibling::node()]">
    <xsl:text>&#x2302;IP ""</xsl:text> 
    <xsl:if test="not($list-indent = '')">
      <xsl:text> </xsl:text>
      <xsl:value-of select="$list-indent"/>
    </xsl:if>
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<!-- ================================================================== -->
  
<!-- * for simplelist type="inline", render it as a comma-separated list -->
<xsl:template match="simplelist[@type='inline']">

  <!-- * if dbchoice PI exists, use that to determine the choice separator -->
  <!-- * (that is, equivalent of "and" or "or" in current locale), or literal -->
  <!-- * value of "choice" otherwise -->
  <xsl:variable name="localized-choice-separator">
    <xsl:choose>
      <xsl:when test="processing-instruction('dbchoice')">
	<xsl:call-template name="select.choice.separator"/>
      </xsl:when>
      <xsl:otherwise>
	<!-- * empty -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:for-each select="member">
    <xsl:apply-templates/>
    <xsl:choose>
      <xsl:when test="position() = last()"/> <!-- do nothing -->
      <xsl:otherwise>
	<xsl:text>, </xsl:text>
	<xsl:if test="position() = last() - 1">
	  <xsl:if test="$localized-choice-separator != ''">
	    <xsl:value-of select="$localized-choice-separator"/>
	    <xsl:text> </xsl:text>
	  </xsl:if>
	</xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<!-- * if simplelist type is not inline, render it as a one-column vertical -->
<!-- * list (ignoring the values of the type and columns attributes) -->
<xsl:template match="simplelist">
  <xsl:for-each select="member">
    <xsl:text>&#x2302;IP ""</xsl:text> 
    <xsl:if test="not($list-indent = '')">
      <xsl:text> </xsl:text>
      <xsl:value-of select="$list-indent"/>
    </xsl:if>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#10;</xsl:text>
  </xsl:for-each>
</xsl:template>

<!-- ================================================================== -->

<!-- * We output Segmentedlist as a table, using tbl(1) markup. There -->
<!-- * is no option for outputting it in manpages in "list" form. -->
<xsl:template match="segmentedlist">
  <xsl:if test="title">
    <xsl:text>&#x2302;PP&#10;</xsl:text>
    <xsl:apply-templates mode="bold" select="title"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
  <xsl:text>&#x2302;\" line length increase to cope w/ tbl weirdness&#10;</xsl:text>
  <xsl:text>&#x2302;ll +(\n(LLu * 62u / 100u)&#10;</xsl:text>
  <!-- * .TS = "Table Start" -->
  <xsl:text>&#x2302;TS&#10;</xsl:text>
    <!-- * first output the table "format" spec, which tells tbl(1) how -->
    <!-- * how to format each row and column. -->
  <xsl:for-each select=".//segtitle">
    <!-- * l = "left", which hard-codes left-alignment for tabular -->
    <!-- * output of all segmentedlist content -->
    <xsl:text>l</xsl:text>
  </xsl:for-each>
  <!-- * last line of table format section must end with a dot -->
  <xsl:text>&#x2302;&#10;</xsl:text>
  <!-- * optionally suppress output of segtitle -->
  <xsl:choose>
    <xsl:when test="$man.segtitle.suppress != 0">
      <!-- * non-zero = "suppress", so do nothing -->
    </xsl:when>
    <xsl:otherwise>
      <!-- * "0" = "do not suppress", so output the segtitle(s) -->
      <xsl:apply-templates select=".//segtitle" mode="table-title"/>
      <xsl:text>&#10;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates/>
  <!-- * .TE = "Table End" -->
  <xsl:text>&#x2302;TE&#10;</xsl:text>
  <xsl:text>&#x2302;\" line length decrease back to previous value&#10;</xsl:text>
  <xsl:text>&#x2302;ll -(\n(LLu * 62u / 100u)&#10;</xsl:text>
  <!-- * put a blank line of space below the table -->
  <xsl:text>&#x2302;sp&#10;</xsl:text>
</xsl:template>

<xsl:template match="segmentedlist/segtitle" mode="table-title">
  <!-- * italic makes titles stand out more reliably than bold (because -->
  <!-- * some consoles do not actually support rendering of bold -->
  <xsl:apply-templates mode="italic" select="."/>
  <xsl:choose>
      <xsl:when test="position() = last()"/> <!-- do nothing -->
      <xsl:otherwise>
        <!-- * tbl(1) treats tab characters as delimiters between -->
        <!-- * cells; so we need to output a tab after each except -->
        <!-- * segtitle except the last one -->
        <xsl:text>&#09;</xsl:text>
      </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="segmentedlist/seglistitem">
  <xsl:apply-templates/>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="segmentedlist/seglistitem/seg">
  <!-- * the “T{" and “T}” stuff are delimiters to tell tbl(1) that -->
  <!-- * the delimited contents are "text blocks" that groff(1) -->
  <!-- * needs to process -->
  <xsl:text>T{&#10;</xsl:text>
  <xsl:variable name="contents">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:value-of select="normalize-space($contents)"/>
  <xsl:text>&#10;T}</xsl:text>
  <xsl:choose>
    <xsl:when test="position() = last()"/> <!-- do nothing -->
    <xsl:otherwise>
      <!-- * tbl(1) treats tab characters as delimiters between -->
      <!-- * cells; so we need to output a tab after each except -->
      <!-- * segtitle except the last one -->
      <xsl:text>&#09;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
