<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:date="http://exslt.org/dates-and-times"
                xmlns:exsl="http://exslt.org/common"
                exclude-result-prefixes="date exsl"
                version='1.0'>

<!-- ********************************************************************
     $Id$
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

  <!-- ================================================================== -->
  <!-- * Get user "refentry metadata" preferences -->
  <!-- ================================================================== -->

  <xsl:variable name="get.refentry.metadata.prefs">
    <xsl:call-template name="get.refentry.metadata.prefs"/>
  </xsl:variable>

  <xsl:variable name="refentry.metadata.prefs"
                select="exsl:node-set($get.refentry.metadata.prefs)"/>
  
  <!-- * ============================================================== -->
  <!-- *    Get content for Author metainfo field. -->
  <!-- * ============================================================== -->

  <!-- * The author.names template and mode are used only for -->
  <!-- * populating the Author field in the metadata "top comment" -->
  <!-- * we embed at the beginning of each man page. -->

  <xsl:template name="author.names">
    <xsl:param name="info"/>
    <xsl:param name="parentinfo"/>
    <!-- * Try to find a "best match" for putting into metadata Author -->
    <!-- * field; prefer Author, but keep looking in descending order of -->
    <!-- * preference until we can find something usable. -->
    <!-- * -->
    <!-- * Note that will only use the *first* match found, and ignore -->
    <!-- * all others. -->
    <xsl:choose>
      <xsl:when test="$info//author">
        <xsl:apply-templates select="($info//author)[1]" mode="author.names"/>
      </xsl:when>
      <xsl:when test="$parentinfo//author">
        <xsl:apply-templates select="($parentinfo//author)[1]" mode="author.names"/>
      </xsl:when>
      <xsl:when test="$info//corpauthor">
        <xsl:apply-templates select="($info//corpauthor)[1]" mode="author.names"/>
      </xsl:when>
      <xsl:when test="$parentinfo//corpauthor">
        <xsl:apply-templates select="($parentinfo//corpauthor)[1]" mode="author.names"/>
      </xsl:when>
      <xsl:when test="$info//editor">
        <xsl:apply-templates select="($info//editor)[1]" mode="author.names"/>
      </xsl:when>
      <xsl:when test="$parentinfo//editor">
        <xsl:apply-templates select="($parentinfo//editor)[1]" mode="author.names"/>
      </xsl:when>
      <xsl:when test="$info//corpcredit">
        <xsl:apply-templates select="($info//corpcredit)[1]" mode="author.names"/>
      </xsl:when>
      <xsl:when test="$parentinfo//corpcredit">
        <xsl:apply-templates select="($parentinfo//corpcredit)[1]" mode="author.names"/>
      </xsl:when>
      <xsl:when test="$info//othercredit">
        <xsl:apply-templates select="($info//othercredit)[1]" mode="author.names"/>
      </xsl:when>
      <xsl:when test="$parentinfo//othercredit">
        <xsl:apply-templates select="($parentinfo//othercredit)[1]" mode="author.names"/>
      </xsl:when>
      <xsl:when test="$info//collab">
        <xsl:apply-templates select="($info//collab)[1]" mode="author.names"/>
      </xsl:when>
      <xsl:when test="$parentinfo//collab">
        <xsl:apply-templates select="($parentinfo//collab)[1]" mode="author.names"/>
      </xsl:when>
      <xsl:when test="$info//orgname">
        <xsl:apply-templates select="($info//orgname)[1]" mode="author.names"/>
      </xsl:when>
      <xsl:when test="$parentinfo//orgname">
        <xsl:apply-templates select="($parentinfo//orgname)[1]" mode="author.names"/>
      </xsl:when>
      <xsl:when test="$info//publishername">
        <xsl:apply-templates select="($info//publishername)[1]" mode="author.names"/>
      </xsl:when>
      <xsl:when test="$parentinfo//publishername">
        <xsl:apply-templates select="($parentinfo//publishername)[1]" mode="author.names"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="author|editor|othercredit" mode="author.names">
    <xsl:call-template name="person.name"/>
    <xsl:if test=".//email">
      <xsl:text> </xsl:text>
      <!-- * use only the first e-mail address for each author -->
      <xsl:apply-templates select="(.//email)[1]"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="collab" mode="author.names">
    <xsl:value-of select="collabname"/>
    <xsl:if test=".//email">
      <xsl:text> </xsl:text>
      <!-- * use only the first e-mail address for each author -->
      <xsl:apply-templates select="(.//email)[1]"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="corpauthor|corpcredit|orgname|publishername" mode="author.names">
    <xsl:value-of select="."/>
  </xsl:template>

  <!-- * ============================================================== -->
  <!-- *     Assemble the AUTHOR/AUTHORS section -->
  <!-- * ============================================================== -->

  <xsl:template name="author.section">
    <xsl:param name="info"/>
    <xsl:param name="parentinfo"/>
    <xsl:choose>
      <xsl:when test="$info//author|$info//editor|
                      $info//collab|$info//corpauthor|
                      $info//corpcredit|$info//othercredit|
                      $info/orgname|$info/publishername|
                      $info/publisher">
        <xsl:apply-templates select="$info" mode="authorsect"/>
      </xsl:when>
      <xsl:when test="$parentinfo//author|$parentinfo//editor|
                      $parentinfo//collab|$parentinfo//corpauthor|
                      $parentinfo//corpcredit|$parentinfo//othercredit|
                      $parentinfo/orgname|$parentinfo/publishername|
                      $parentinfo/publisher">
        <xsl:apply-templates select="$parentinfo" mode="authorsect"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- * Match only the direct *info children of Refentry, along with -->
  <!-- * any of the *info for the valid direct parents of Refentry. -->
  <xsl:template match="info|refentryinfo|referenceinfo
                       |articleinfo|chapterinfo|sectioninfo
                       |sect1info|sect2info|sect3info|sect4info|sect5info
                       |partinfo|prefaceinfo|appendixinfo|docinfo"
                mode="authorsect">
    <!-- * Count to make see how many instances of attributable -->
    <!-- * people/entities we actually have. -->
    <xsl:variable name="authorcount">
      <xsl:value-of select="count(.//author|.//editor|.//collab|
                            .//corpauthor|.//corpcredit|.//othercredit)">
      </xsl:value-of>
    </xsl:variable>
    <xsl:if test="$authorcount > 0">
      <xsl:text>.SH "</xsl:text>
      <xsl:call-template name="make.authorsecttitle">
        <xsl:with-param name="authorcount" select="$authorcount"/>
      </xsl:call-template>
      <!-- * now output all the actual author, editor, etc. content -->
      <xsl:for-each select=".//author|.//editor|.//collab|.//corpauthor|
                            .//corpcredit|.//othercredit|
                            orgname|publishername|publisher">
        <xsl:apply-templates select="." mode="authorsect"/>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <xsl:template name="make.authorsecttitle">
    <!-- * if we have exactly one attributable person/entity, then output -->
    <!-- * localized gentext for 'Author'; otherwise, output 'Authors’ -->
    <xsl:param name="authorcount"/>
    <xsl:param name="authorsecttitle">
      <xsl:choose>
        <xsl:when test="$authorcount = 1">
          <xsl:text>Author</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Authors</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <xsl:call-template name="string.upper">
      <xsl:with-param name="string">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="$authorsecttitle"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:text>"&#10;</xsl:text>
  </xsl:template>
  
  <xsl:template match="author|editor|othercredit" mode="authorsect">
    <xsl:text>.PP&#10;</xsl:text>
    <xsl:variable name="person-name">
      <xsl:call-template name="person.name"/>
    </xsl:variable>
    <!-- * Display person name in bold -->
    <xsl:apply-templates mode="bold" select="exsl:node-set($person-name)"/>
    <!-- * Display e-mail address(es) on same line as name -->
    <xsl:apply-templates select=".//email" mode="authorsect"/>
    <xsl:text>&#10;</xsl:text>
    <!-- * Display affiliation(s) on separate lines -->
    <xsl:apply-templates select="affiliation" mode="authorsect"/>
    <!-- * Display direct-child addresses on separate lines -->
    <xsl:apply-templates select="address" mode="authorsect"/>
    <!-- * Call template for handling various attribution possibilities -->
    <xsl:call-template name="attribution"/>
  </xsl:template>

  <xsl:template match="collab" mode="authorsect">
    <xsl:text>.PP&#10;</xsl:text>
    <xsl:apply-templates mode="bold" select="collabname"/>
    <!-- * Display e-mail address(es) on same line as name -->
    <xsl:apply-templates select=".//email" mode="authorsect"/>
    <xsl:text>&#10;</xsl:text>
    <!-- * Display affilition(s) on separate lines -->
    <xsl:apply-templates select="affiliation" mode="authorsect"/>
  </xsl:template>

  <xsl:template match="corpauthor|corpcredit|orgname|publishername" mode="authorsect">
    <xsl:text>.PP&#10;</xsl:text>
    <xsl:apply-templates mode="bold" select="."/>
    <xsl:text>&#10;</xsl:text>
    <xsl:if test="self::publishername">
       <!--* Display localized "Publisher" gentext -->
      <xsl:call-template name="publisher.attribution"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="publisher" mode="authorsect">
    <xsl:text>.PP&#10;</xsl:text>
    <xsl:apply-templates mode="bold" select="publishername"/>
    <!-- * Display e-mail address(es) on same line as name -->
    <xsl:apply-templates select=".//email" mode="authorsect"/>
    <!-- * Display addresses on separate lines -->
    <xsl:apply-templates select="address" mode="authorsect"/>
       <!--* Display localized "Publisher" literal -->
    <xsl:call-template name="publisher.attribution"/>
  </xsl:template>

  <xsl:template name="publisher.attribution">
    <xsl:text>&#10;.sp -1&#10;</xsl:text>
    <xsl:text>.IP&#10;</xsl:text>
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'Publisher'"/>
    </xsl:call-template>
    <xsl:text>.&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="email" mode="authorsect">
    <xsl:choose>
      <xsl:when test="position() != 1"/> <!-- do nothing -->
      <xsl:otherwise>
        <!-- * this is 1st e-mail address, so put space before it -->
        <xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>&lt;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&gt;</xsl:text>
    <xsl:choose>
      <xsl:when test="position() = last()"/> <!-- do nothing -->
      <xsl:otherwise>
        <!-- * separate multiple e-mail addresses with a comma -->
        <xsl:text>, </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="affiliation" mode="authorsect">
    <xsl:text>.br&#10;</xsl:text>
    <xsl:for-each select="shortaffil|jobtitle|orgname|orgdiv|address">
      <!-- * only display output of nodes other than Email element -->
      <xsl:apply-templates select="node()[local-name() != 'email']"/>
      <xsl:choose>
        <xsl:when test="position() = last()"/> <!-- do nothing -->
        <xsl:otherwise>
          <!-- * only add comma if the node has a child node other than -->
          <!-- * an Email element -->
          <xsl:if test="child::node()[local-name() != 'email']">
            <xsl:text>, </xsl:text>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    <xsl:text>&#10;</xsl:text>
    <xsl:choose>
      <xsl:when test="position() = last()"/> <!-- do nothing -->
      <xsl:otherwise>
        <!-- * put a line break after every Affiliation instance except -->
        <!-- * the last one in the set -->
        <xsl:text>.br&#10;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="address" mode="authorsect">
    <xsl:text>&#10;</xsl:text>
    <xsl:text>.br&#10;</xsl:text>
    <!--*  Skip Email children of Address (rendered elsewhere) -->
    <xsl:apply-templates select="node()[local-name() != 'email']"/>
  </xsl:template>

  <xsl:template name="attribution">
  <!-- * Determine appropriate attribution a particular person's role. -->
    <xsl:choose>
      <!-- * if we have a *blurb or contrib, just use that -->
      <xsl:when test="contrib|personblurb|authorblurb">
        <xsl:apply-templates select="(contrib|personblurb|authorblurb)" mode="authorsect"/>
        <xsl:text>&#10;</xsl:text>
      </xsl:when>
      <!-- * If we have no *blurb or contrib, but this is an Author or -->
      <!-- * Editor, then render the corresponding localized gentext -->
      <xsl:when test="self::author">
        <xsl:text>&#10;.sp -1&#10;</xsl:text>
        <xsl:text>.IP&#10;</xsl:text>
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'Author'"/>
        </xsl:call-template>
        <xsl:text>.&#10;</xsl:text>
      </xsl:when>
      <xsl:when test="self::editor">
        <xsl:text>&#10;.sp -1&#10;</xsl:text>
        <xsl:text>.IP&#10;</xsl:text>
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'Editor'"/>
        </xsl:call-template>
        <xsl:text>.&#10;</xsl:text>
      </xsl:when>
      <!-- * If we have no *blurb or contrib, but this is an Othercredit, -->
      <!-- * check value of Class attribute and use corresponding gentext. -->
      <xsl:when test="self::othercredit">
        <xsl:choose>
          <xsl:when test="@class and @class != 'other'">
            <xsl:text>&#10;.sp -1&#10;</xsl:text>
            <xsl:text>.IP&#10;</xsl:text>
            <xsl:call-template name="gentext">
              <xsl:with-param name="key" select="@class"/>
            </xsl:call-template>
            <xsl:text>.&#10;</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <!-- * We have an Othercredit, but not usable value for the Class -->
            <!-- * attribute, so nothing to show, do nothing -->
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <!-- * We have no *blurb or contrib or anything else we can use to -->
        <!-- * display appropriate attribution for this person, so do nothing -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="personblurb|authorblurb" mode="authorsect">
    <xsl:text>&#10;.sp -1&#10;</xsl:text>
    <xsl:text>.IP&#10;</xsl:text>
     <!-- * yeah, it's possible for a *blurb to have a "title" -->
    <xsl:apply-templates select="title"/>
    <xsl:for-each select="*[name() != 'title']">
      <xsl:apply-templates/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="personblurb/title|authorblurb/title">
       <!-- * always render period after title -->
    <xsl:apply-templates/>
    <xsl:text>.</xsl:text>
    <!-- * render space after Title+period if the title is followed -->
    <!-- * by something element content -->
    <xsl:if test="following-sibling::*[name() != '']">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="contrib" mode="authorsect">
    <!-- * We treat Contrib the same as Personblurb/Authorblurb -->
    <!-- * except that we don't need to check for a title. -->
    <xsl:text>&#10;.sp -1&#10;</xsl:text>
    <xsl:text>&#10;.IP&#10;</xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- * ============================================================== -->

  <!-- * suppress refmeta and all *info (we grab what we need from them -->
  <!-- * elsewhere) -->

  <xsl:template match="refmeta"/>

  <xsl:template match="info|refentryinfo|referenceinfo|refsynopsisdivinfo
                       |refsectioninfo|refsect1info|refsect2info|refsect3info
                       |articleinfo|chapterinfo|sectioninfo
                       |sect1info|sect2info|sect3info|sect4info|sect5info
                       |partinfo|prefaceinfo|appendixinfo|docinfo"/>

  <!-- ============================================================== -->
  
</xsl:stylesheet>
