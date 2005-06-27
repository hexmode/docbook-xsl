<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                version='1.0'>

<!-- ********************************************************************
     $Id$
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<!-- This file contains named and "non element" templates that are called -->
<!-- by templates in the other manpages stylesheet files. -->

<!-- ==================================================================== -->

  <!-- * NOTE TO DEVELOPERS: For ease of maintenance, the current -->
  <!-- * manpages stylesheets use the mode="bold" and mode="italic" -->
  <!-- * templates for *anything and everything* that needs to get -->
  <!-- * boldfaced or italicized.   -->
  <!-- * -->
  <!-- * So if you add anything that needs bold or italic character -->
  <!-- * formatting, try to apply these templates to it rather than -->
  <!-- * writing separate code to format it. This can be a little odd if -->
  <!-- * the content you want to format is not element content; in those -->
  <!-- * cases, you need to turn it into element content before applying -->
  <!-- * the template; see examples of this in the existing code. -->

  <xsl:template mode="bold" match="*">
    <xsl:for-each select="node()">
      <xsl:text>\fB</xsl:text>
      <xsl:apply-templates select="."/>
      <xsl:text>\fR</xsl:text>
    </xsl:for-each>
  </xsl:template>

  <xsl:template mode="italic" match="*">
    <xsl:for-each select="node()">
      <xsl:text>\fI</xsl:text>
      <xsl:apply-templates select="."/>
      <xsl:text>\fR</xsl:text>
    </xsl:for-each>
  </xsl:template>

  <!-- ================================================================== -->

  <!-- * NOTE TO DEVELOPERS: For ease of maintenance, the current -->
  <!-- * manpages stylesheets use the mode="prevent.line.breaking" -->
  <!-- * templates for *anything and everything* that needs to have -->
  <!-- * embedded spaces turned into no-break spaces in output - in -->
  <!-- * order to prevent that output from getting broken across lines -->
  <!-- * -->
  <!-- * So if you add anything that whose output, try to apply this -->
  <!-- * template to it rather than writing separate code to format -->
  <!-- * it. This can be a little odd if the content you want to -->
  <!-- * format is not element content; in those cases, you need to -->
  <!-- * turn it into element content before applying the template; -->
  <!-- * see examples of this in the existing code. -->
  <!-- * -->
  <!-- * This template is currently called by the funcdef and paramdef -->
  <!-- * and group/arg templates. -->
  <xsl:template mode="prevent.line.breaking" match="*">
    <xsl:variable name="rcontent">
      <xsl:apply-templates/>
    </xsl:variable>
    <xsl:variable name="content">
      <xsl:value-of select="normalize-space($rcontent)"/>
    </xsl:variable>
    <xsl:call-template name="string.subst">
      <xsl:with-param name="string" select="$content"/>
      <xsl:with-param name="target" select="' '"/>
      <!-- * We output a real nobreak space here (rather than, "\ ", -->
      <!-- * the roff nobreak space) because, when we do character-map -->
      <!-- * processing before final output, the character-map will -->
      <!-- * handle conversion of the &#160; to "\ " for us -->
      <xsl:with-param name="replacement" select="'&#160;'"/>
    </xsl:call-template>
  </xsl:template>

  <!-- ================================================================== -->

  <!-- * The nested-section-title template is called for refsect3, and any -->
  <!-- * refsection nested more than 2 levels deep, and for formalpara. -->
  <xsl:template name="nested-section-title">
    <!-- * The next few lines are some arcane roff code to control line -->
    <!-- * spacing after headings. -->
    <xsl:text>.sp&#10;</xsl:text>
    <xsl:text>.it 1 an-trap&#10;</xsl:text>
    <xsl:text>.nr an-no-space-flag 1&#10;</xsl:text>
    <xsl:text>.nr an-break-flag 1&#10;</xsl:text>
    <xsl:text>.br&#10;</xsl:text>
    <!-- * make title wrapper so that we can use mode="bold" template to -->
    <!-- * apply character formatting to it -->
    <xsl:variable name="title.wrapper">
      <bold><xsl:choose>
        <xsl:when test="title">
          <xsl:value-of select="normalize-space(title[1])"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="." mode="object.title.markup.textonly"/>
        </xsl:otherwise>
      </xsl:choose></bold>
    </xsl:variable>
    <xsl:apply-templates mode="bold" select="exsl:node-set($title.wrapper)"/>
  </xsl:template>

  <!-- ================================================================== -->

  <!-- * The mixed-block template jumps through a few hoops to deal with -->
  <!-- * mixed-content blocks, so that we don't end up munging verbatim -->
  <!-- * environments or lists and so that we don't gobble up whitespace -->
  <!-- * when we shouldn't -->
  <xsl:template name="mixed-block">
    <xsl:for-each select="node()">
      <xsl:choose>
        <xsl:when test="self::address|self::literallayout|self::programlisting|
                        self::screen|self::synopsis">
          <!-- * Check to see if this node is a verbatim environment. -->
          <!-- * If so, put a line break before it. -->
          <!-- * -->
          <!-- * Yes, address and synopsis are vertabim environments. -->
          <!-- * -->
          <!-- * The code here previously also treated informaltable as a -->
          <!-- * verbatim, presumably to support some kludge; I removed it -->
          <xsl:text>&#10;</xsl:text>
          <xsl:apply-templates select="."/>
          <!-- * we don't need an extra line break after verbatim environments -->
          <!-- * <xsl:text> &#10;</xsl:text> -->
        </xsl:when>
        <xsl:when test="self::itemizedlist|self::orderedlist|
                        self::variablelist|self::simplelist[@type !='inline']">
          <!-- * Check to see if this node is a list; if so, -->
          <!-- * put a line break before it. -->
          <xsl:text>&#10;</xsl:text>
          <xsl:apply-templates select="."/>
          <!-- * we don't need an extra line break after lists -->
          <!-- * <xsl:text> &#10;</xsl:text> -->
        </xsl:when>
        <xsl:when test="self::text()">
          <!-- * Check to see if this is a text node. -->
          <!-- * -->
          <!-- * If so, take any multiple whitespace at the beginning or end of -->
          <!-- * it, and replace it with a space plus a linebreak. -->
          <!-- * -->
          <!-- * This hack results in some ugliness in the generated roff -->
          <!-- * source. But it ensures the whitespace around text nodes in mixed -->
          <!-- * content gets preserved; without the hack, that whitespace -->
          <!-- * effectively gets gobbled. -->
          <!-- * -->
          <!-- * Note if the node is just space, we just pass it through -->
          <!-- * without (re)adding a line break. -->
          <!-- * -->
          <!-- * There must be a better way to do with this...  -->
          <xsl:variable name="content">
            <xsl:apply-templates select="."/>
          </xsl:variable>
          <xsl:if
              test="starts-with(translate(.,'&#9;&#10;&#13; ','    '), ' ')
                    and preceding-sibling::node()[name(.)!='']
                    and normalize-space($content) != ''
                    ">
            <xsl:text> &#10;</xsl:text>
          </xsl:if>
          <xsl:value-of select="normalize-space($content)"/>
          <xsl:if
              test="translate(substring(., string-length(.), 1),'&#9;&#10;&#13; ','    ')  = ' '
                    and following-sibling::node()[name(.)!='']
                    ">
            <xsl:text> </xsl:text>
            <xsl:if test="normalize-space($content) != ''">
              <xsl:text>&#10;</xsl:text>
            </xsl:if>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <!-- * At this point, we know that this node is not a verbatim -->
          <!-- * environment, list, or text node; so we can safely -->
          <!-- * normalize-space() it. -->
          <xsl:variable name="content">
            <xsl:apply-templates select="."/>
          </xsl:variable>
          <xsl:value-of select="normalize-space($content)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <!-- ================================================================== -->

  <xsl:template name="prepare.manpage.contents">
    <xsl:param name="content" select="''"/>
    <xsl:call-template name="apply-character-map">
      <xsl:with-param name="content" select="$content"/>
      <xsl:with-param name="character.map.contents"
                      select="exsl:node-set($man.charmap.contents)/*"/>
    </xsl:call-template>
  </xsl:template>

  <!-- * We don't add backslashes before periods/dots or hyphens (&#45;) -->
  <!-- * Here's why: -->
  <!-- * -->
  <!-- * - Backslashes in front of periods/dots are needed only in the very -->
  <!-- *   rare case where a period is the very first character in a line, -->
  <!-- *   without any space in front of it. A better way to deal with that -->
  <!-- *   rare case is for authors to add a zero-width space in front of -->
  <!-- *   the offending dot(s) in their source -->
  <!-- * -->
  <!-- * - Backslashes in front of (&#45;/&#x2D;) are needed... when? -->
  <!-- *   Myself, I don't know, so the current stylesheet does not add -->
  <!-- *   backslashes in front of them, ever. If there is a specific case -->
  <!-- *   where they are necessary or desirable, then we need to add code -->
  <!-- *   for that case, not just do a blanket conversion. -->
  <!-- * -->
  <!-- *   And, anyway, my understanding from reading the groff docs -->
  <!-- *   is that \- is, specifically, a _minus sign_. So if users -->
  <!-- *   have places where they want a minus sign to be output -->
  <!-- *   instead of (&#45;), then they should use (&#8722;/&#x2212;) -->
  <!-- *   in their source instead. And if they have a place where -->
  <!-- *   they want an en dash, (&#8211;/&#x2013;). Or if there are -->
  <!-- *   places where the stylesheets are internally generating -->
  <!-- *   (&#45;) where they should be generating &#8722; or &#8211;, -->
  <!-- *   then we need to fix those, not just do blanket conversion. -->

<!--   TODO: We do need to add backslash in front of single-quote if it is -->
<!--   the first character in a line. And escaping of -->
<!--   backslashes need to be restored before release. -->

</xsl:stylesheet>