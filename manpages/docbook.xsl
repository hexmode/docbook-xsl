<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                xmlns:ng="http://docbook.org/docbook-ng"
                xmlns:db="http://docbook.org/ns/docbook"
                exclude-result-prefixes="exsl"
                version='1.0'>

  <xsl:import href="../html/docbook.xsl"/>
  <xsl:import href="../html/manifest.xsl"/>
  <!-- * html-synop.xsl file is generated by build -->
  <xsl:import href="html-synop.xsl"/>
  <xsl:output method="text"
              encoding="UTF-8"
              indent="no"/>
  <!-- ********************************************************************
       $Id$
       ********************************************************************

       This file is part of the XSL DocBook Stylesheet distribution.
       See ../README or http://docbook.sf.net/release/xsl/current/ for
       copyright and other information.

       ******************************************************************** -->

  <!-- ==================================================================== -->

  <xsl:include href="../common/refentry.xsl"/>
  <xsl:include href="param.xsl"/>
  <xsl:include href="utility.xsl"/>
  <xsl:include href="info.xsl"/>
  <xsl:include href="other.xsl"/>
  <xsl:include href="refentry.xsl"/>
  <xsl:include href="block.xsl"/>
  <xsl:include href="inline.xsl"/>
  <xsl:include href="synop.xsl"/>
  <xsl:include href="lists.xsl"/>
  <xsl:include href="links.xsl"/>
  <xsl:include href="table.xsl"/>

  <!-- * we rename the following just to avoid using params with "man" -->
  <!-- * prefixes in the table.xsl stylesheet (because that stylesheet -->
  <!-- * can potentially be reused for more than just man output) -->
  <xsl:param name="tbl.font.headings" select="$man.font.table.headings"/>
  <xsl:param name="tbl.font.title" select="$man.font.table.title"/>

  <!-- ==================================================================== -->

  <xsl:template match="/">
    <!-- * If we detect that this document is a DocBook 5/NG doc, then we -->
    <!-- * need to pre-process it to strip out the namespace and to change -->
    <!-- * a few other things so that we can process it with the stylesheets -->
    <xsl:choose>
      <xsl:when test="*/self::ng:* or */self::db:*">
        <xsl:message>Note: Stripping NS from DocBook 5/NG document.</xsl:message>
        <xsl:variable name="nons">
          <xsl:apply-templates mode="stripNS"/>
        </xsl:variable>
        <xsl:message>Note: Processing stripped document.</xsl:message>
        <xsl:apply-templates select="exsl:node-set($nons)"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- * Otherwise, we do not have a DocBook 5/NG document, or we are -->
        <!-- * at the point where the first pass has already been done to -->
        <!-- * strip out the namespace; so we can now process it. -->
        <xsl:choose>
          <xsl:when test="//refentry">
            <!-- * Check to see if we have any refentry children in this -->
            <!-- * document; if so, process them. -->
            <xsl:apply-templates select="//refentry"/>
            <!-- * if $man.output.manifest.enabled is non-zero, -->
            <!-- * generate a manifest file -->
            <xsl:if test="not($man.output.manifest.enabled = 0)">
              <xsl:call-template name="generate.manifest">
                <xsl:with-param name="filename">
                  <xsl:choose>
                    <xsl:when test="not($man.output.manifest.filename = '')">
                      <!-- * If a name for the manifest file is specified, -->
                      <!-- * use that name. -->
                      <xsl:value-of select="$man.output.manifest.filename"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <!-- * Otherwise, if user has unset -->
                      <!-- * $man.output.manifest.filename, default to -->
                      <!-- * using "MAN.MANIFEST" as the filename. Because -->
                      <!-- * $man.output.manifest.enabled is non-zero and -->
                      <!-- * so we must have a filename in order to -->
                      <!-- * generate the manifest. -->
                      <xsl:text>MAN.MANIFEST</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <!-- * Otherwise, the document does not contain any -->
            <!-- * refentry elements, so emit message and stop. -->
            <xsl:variable name="title">
              <!-- * Get a title so that we let the user know what -->
              <!-- * document we are processing at this point. -->
              <xsl:choose>
                <xsl:when test="title">
                  <xsl:value-of select="title[1]"/>
                </xsl:when>
                <xsl:when test="substring(local-name(*[1]),
                                string-length(local-name(*[1])-3) = 'info')
                                and *[1]/title">
                  <xsl:value-of select="*[1]/title[1]"/>
                </xsl:when>
              </xsl:choose>
            </xsl:variable>
            <xsl:message>
              <xsl:text>Note: No refentry elements found in "</xsl:text>
              <xsl:value-of select="local-name(.)"/>
              <xsl:if test="$title != ''">
                <xsl:choose>
                  <xsl:when test="string-length($title) &gt; 30">
                    <xsl:value-of select="substring($title,1,30)"/>
                    <xsl:text>...</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$title"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:if>
              <xsl:text>"</xsl:text>
            </xsl:message>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ============================================================== -->

  <xsl:template match="refentry">
    <xsl:param name="lang">
      <xsl:call-template name="l10n.language"/>
    </xsl:param>
    <!-- * Just use the first refname found as the "name" of the man -->
    <!-- * page (which may different from the "title"...) -->
    <xsl:variable name="first.refname" select="refnamediv[1]/refname[1]"/>

    <xsl:call-template name="root.messages">
      <xsl:with-param name="refname" select="$first.refname"/>
    </xsl:call-template>

    <!-- * Because there are several times when we need to check *info of -->
    <!-- * each refentry and its ancestors, we get those and store the -->
    <!-- * data from them as a node-set in memory. -->

    <!-- * Make a node-set with contents of *info -->
    <xsl:variable name="get.info"
                  select="ancestor-or-self::*/*[substring(local-name(),
                          string-length(local-name()) - 3) = 'info']"
                  />
    <xsl:variable name="info" select="exsl:node-set($get.info)"/>

    <!-- * The get.refentry.metadata template is in -->
    <!-- * ../common/refentry.xsl. It looks for metadata in $info -->
    <!-- * and in various other places and then puts it into a form -->
    <!-- * that's easier for us to digest. -->
    <xsl:variable name="get.refentry.metadata">
      <xsl:call-template name="get.refentry.metadata">
        <xsl:with-param name="refname" select="$first.refname"/>
        <xsl:with-param name="info" select="$info"/>
        <xsl:with-param name="prefs" select="$refentry.metadata.prefs"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="refentry.metadata" select="exsl:node-set($get.refentry.metadata)"/>

    <!-- * Assemble the various parts into a complete page, then store into -->
    <!-- * $manpage.contents so that we can manipluate them further. -->
    <xsl:variable name="manpage.contents">
      <!-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
      <!-- * top.comment = commented-out section at top of roff source -->
      <!-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
      <xsl:call-template name="top.comment">
        <xsl:with-param name="info"       select="$info"/>
        <xsl:with-param name="date"       select="$refentry.metadata/date"/>
        <xsl:with-param name="title"      select="$refentry.metadata/title"/>
        <xsl:with-param name="manual"     select="$refentry.metadata/manual"/>
        <xsl:with-param name="source"     select="$refentry.metadata/source"/>
      </xsl:call-template>
      <!-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
      <!-- * TH.title.line = title line in header/footer of man page -->
      <!-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
      <xsl:call-template name="TH.title.line">
        <!-- * .TH TITLE  section  extra1  extra2  extra3 -->
        <!-- *  -->
        <!-- * According to the man(7) man page: -->
        <!-- *  -->
        <!-- * extra1 = date,   "the date of the last revision" -->
        <!-- * extra2 = source, "the source of the command" -->
        <!-- * extra3 = manual, "the title of the manual -->
        <!-- *                  (e.g., Linux Programmer's Manual)" -->
        <!-- * -->
        <!-- * So, we end up with: -->
        <!-- *  -->
        <!-- * .TH TITLE  section  date  source  manual -->
        <!-- * -->
        <xsl:with-param name="title"   select="$refentry.metadata/title"/>
        <xsl:with-param name="section" select="$refentry.metadata/section"/>
        <xsl:with-param name="extra1"  select="$refentry.metadata/date"/>
        <xsl:with-param name="extra2"  select="$refentry.metadata/source"/>
        <xsl:with-param name="extra3"  select="$refentry.metadata/manual"/>
      </xsl:call-template>
      <!-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
      <!-- * Set default hyphenation, justification, indentation, and -->
      <!-- * line-breaking -->
      <!-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
      <xsl:call-template name="set.default.formatting"/>
      <!-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
      <!-- * Main body of man page -->
      <!-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
      <xsl:apply-templates/>
      <!-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
      <!-- * AUTHOR section -->
      <!-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
      <xsl:call-template name="author.section">
        <xsl:with-param name="info" select="$info"/>
      </xsl:call-template>
      <!-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
      <!-- * COPYRIGHT section -->
      <!-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
      <xsl:call-template name="copyright.section">
        <xsl:with-param name="info" select="$info"/>
      </xsl:call-template>
      <!-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
      <!-- * LINKS list (only if user wants links numbered and/or listed) -->
      <!-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
      <xsl:if test="$man.links.list.enabled != 0 or
                    $man.links.are.numbered != 0">
        <xsl:call-template name="endnotes.list"/>
      </xsl:if>
    </xsl:variable> <!-- * end of manpage.contents -->

    <!-- * Prepare the page contents for final output, then store in -->
    <!-- * $manpage.contents.prepared so the we can pass it on to the -->
    <!-- * write.text.chunk() function -->
    <xsl:variable name="manpage.contents.prepared">
      <!-- * "Preparing" the page contents involves, at a minimum, -->
      <!-- * doubling any backslashes found (so they aren't interpreted -->
      <!-- * as roff escapes). -->
      <!-- * -->
      <!-- * If $charmap.enabled is true, "preparing" the page contents also -->
      <!-- * involves applying a character map to convert Unicode symbols and -->
      <!-- * special characters into corresponding roff escape sequences. -->
      <xsl:call-template name="prepare.manpage.contents">
        <xsl:with-param name="content" select="$manpage.contents"/>
      </xsl:call-template>
    </xsl:variable>
    
    <!-- * Write the prepared page contents to disk to create -->
    <!-- * the final man page. -->
    <xsl:call-template name="write.man.file">
      <xsl:with-param name="name" select="$first.refname"/>
      <xsl:with-param name="section" select="$refentry.metadata/section"/>
      <xsl:with-param name="lang" select="$lang"/>
      <xsl:with-param name="content" select="$manpage.contents.prepared"/>
    </xsl:call-template>

    <!-- * Generate "stub" (alias) pages (if any needed) -->
    <xsl:call-template name="write.stubs">
      <xsl:with-param name="first.refname" select="$first.refname"/>
      <xsl:with-param name="section" select="$refentry.metadata/section"/>
      <xsl:with-param name="lang" select="$lang"/>
    </xsl:call-template>

  </xsl:template>

</xsl:stylesheet>
