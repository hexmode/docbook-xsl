<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- ********************************************************************
     $Id$
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

  <!-- * The following function is a modified version of Jeni -->
  <!-- * Tennison's 'replace_strings' in the 'multiple string -->
  <!-- * replacements' section of Dave Pawson's XSLT FAQ: -->
  <!-- *  -->
  <!-- *   http://www.dpawson.co.uk/xsl/sect2/StringReplace.html -->
  <!-- *  -->
  <!-- * This stylesheet is meant to be used as part of the DocBook -->
  <!-- * stylesheets, where the value of the $charmap.filename param -->
  <!-- * is specified in a separate params.xsl file which gets -->
  <!-- * included, along with this file, by the docbook.xsl driver. -->
  <!-- *  -->
  <!-- * If you instead want to use it as a standalone stylesheet, you -->
  <!-- * need to add an xsl:param for $charmap.filename; for example: -->
  <!-- *  -->
  <!-- *   <xsl:param name="charmap.filename">charmap.groff.xml</xsl:param> -->

  <xsl:template name="replace.unicode.chars">
    <xsl:param name="content" />
    <xsl:param name="search"
               select="document($charmap.filename)//*[local-name()='output-character']" />
    <xsl:variable name="replaced_text">
      <xsl:call-template name="string.subst">
        <xsl:with-param name="string" select="$content" />
        <xsl:with-param name="target" 
                        select="$search[1]/@char" />
        <xsl:with-param name="replacement" 
                        select="$search[1]/@string" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$search[2]">
        <xsl:call-template name="replace.unicode.chars">
          <xsl:with-param name="content" select="$replaced_text" />
          <xsl:with-param name="search" select="$search[position() > 1]" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$replaced_text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
