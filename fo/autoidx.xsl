<?xml version="1.0"?>
<!DOCTYPE xsl:stylesheet [

<!ENTITY lowercase "'abcdefghijklmnopqrstuvwxyz'">
<!ENTITY uppercase "'ABCDEFGHIJKLMNOPQRSTUVWXYZ'">

<!ENTITY primary   'normalize-space(concat(primary/@sortas, primary[not(@sortas)]))'>
<!ENTITY secondary 'normalize-space(concat(secondary/@sortas, secondary[not(@sortas)]))'>
<!ENTITY tertiary  'normalize-space(concat(tertiary/@sortas, tertiary[not(@sortas)]))'>

<!ENTITY sep '" "'>
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">

<!-- ********************************************************************
     $Id$
     ********************************************************************

     This file is part of the DocBook XSL Stylesheet distribution.
     See ../README or http://docbook.sf.net/ for copyright
     and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->
<!-- Derived from Jeni Tennison's work in the HTML case -->

<xsl:key name="letter"
         match="indexterm"
         use="translate(substring(&primary;, 1, 1),&lowercase;,&uppercase;)"/>

<xsl:key name="primary"
         match="indexterm"
         use="&primary;"/>

<xsl:key name="secondary"
         match="indexterm"
         use="concat(&primary;, &sep;, &secondary;)"/>

<xsl:key name="tertiary"
         match="indexterm"
         use="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;)"/>

<xsl:key name="endofrange"
         match="indexterm[@class='endofrange']"
         use="@startref"/>

<xsl:key name="see-also"
         match="indexterm[seealso]"
         use="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, seealso)"/>

<xsl:key name="see"
         match="indexterm[see]"
         use="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, see)"/>

<xsl:template name="generate-index">
  <xsl:variable name="scope" select=".." />
  <xsl:variable name="terms"
                select="..//indexterm[count(.|key('letter',
                                                translate(substring(&primary;, 1, 1),
                                                          &lowercase;,
                                                          &uppercase;))[ancestor::* = $scope][1]) = 1
                                    and not(@class = 'endofrange')]"/>

  <xsl:variable name="alphabetical"
                select="$terms[contains(concat(&lowercase;, &uppercase;),
                                        substring(&primary;, 1, 1))]"/>
  <xsl:variable name="others" select="$terms[not(contains(concat(&lowercase;,
                                                 &uppercase;),
                                             substring(&primary;, 1, 1)))]"/>
  <fo:block>
    <xsl:if test="$others">
      <fo:block font-size="16pt"
                font-weight="bold"
                keep-with-next.within-column="always"
                space-before="1em">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'index symbols'"/>
        </xsl:call-template>
      </fo:block>
      <fo:block>
        <xsl:apply-templates select="$others[count(.|key('primary',
                                     &primary;)[ancestor::* = $scope][1]) = 1]"
                             mode="index-symbol-div">
          <xsl:with-param name="scope" select="$scope"/>
          <xsl:sort select="translate(&primary;, &lowercase;, &uppercase;)"/>
        </xsl:apply-templates>
      </fo:block>
    </xsl:if>
    <xsl:apply-templates select="$alphabetical[count(.|key('letter',
                                 translate(substring(&primary;, 1, 1),&lowercase;,&uppercase;))[ancestor::* = $scope][1]) = 1]"
                         mode="index-div">
      <xsl:with-param name="scope" select="$scope"/>
      <xsl:sort select="translate(&primary;, &lowercase;, &uppercase;)"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<xsl:template match="indexterm" mode="index-div">
  <xsl:param name="scope" select="."/>
  <xsl:variable name="key" select="translate(substring(&primary;, 1, 1),&lowercase;,&uppercase;)"/>
  <xsl:variable name="terms" select="key('letter', $key)[ancestor::* = $scope][count(.|key('primary', &primary;)[1]) = 1]"/>
  <fo:block>
    <xsl:if test="contains(concat(&lowercase;, &uppercase;), $key)">
      <fo:block font-size="16pt"
                font-weight="bold"
                keep-with-next.within-column="always"
                space-before="1em">
        <xsl:value-of select="translate($key, &lowercase;, &uppercase;)"/>
      </fo:block>
    </xsl:if>
    <fo:block>
      <xsl:apply-templates select="$terms"
                           mode="index-primary">
        <xsl:sort select="translate(&primary;, &lowercase;, &uppercase;)"/>
        <xsl:with-param name="scope" select="$scope"/>
      </xsl:apply-templates>
    </fo:block>
  </fo:block>
</xsl:template>

<xsl:template match="indexterm" mode="index-symbol-div">
  <xsl:param name="scope" select="."/>
  <xsl:variable name="key" select="translate(substring(&primary;, 1, 1),&lowercase;,&uppercase;)"/>

  <fo:block>
    <xsl:apply-templates select="key('letter', $key)[count(.|key('primary', &primary;)[ancestor::* = $scope][1]) = 1]"
                         mode="index-primary">
      <xsl:with-param name="scope" select="$scope"/>
      <xsl:sort select="translate(&primary;, &lowercase;, &uppercase;)"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<xsl:template match="indexterm" mode="index-primary">
  <xsl:param name="scope" select="."/>
  <xsl:variable name="key" select="&primary;"/>
  <xsl:variable name="refs" select="key('primary', $key)[ancestor::* = $scope]"/>
  <fo:block>
    <xsl:value-of select="primary"/>

    <xsl:variable name="page-number-citations">
      <xsl:for-each select="$refs[not(see) and not(seealso)]">
        <xsl:apply-templates select="." mode="reference">
          <xsl:with-param name="scope" select="$scope"/>
        </xsl:apply-templates>
      </xsl:for-each>

      <xsl:if test="$refs[not(secondary)]/*[self::see]">
        <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see', concat(&primary;, &sep;, &sep;, &sep;, see))[ancestor::* = $scope][1])]"
                             mode="index-see">
           <xsl:with-param name="scope" select="$scope"/>
           <xsl:sort select="translate(see, &lowercase;, &uppercase;)"/>
        </xsl:apply-templates>
      </xsl:if>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$passivetex.extensions != '0'">
        <fotex:sort xmlns:fotex="http://www.tug.org/fotex">
          <xsl:copy-of select="$page-number-citations"/>
        </fotex:sort>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$page-number-citations"/>
      </xsl:otherwise>
    </xsl:choose>
  </fo:block>

  <xsl:if test="$refs/secondary or $refs[not(secondary)]/*[self::seealso]">
    <fo:block start-indent="1pc">
      <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see-also', concat(&primary;, &sep;, &sep;, &sep;, seealso))[ancestor::* = $scope][1])]"
                           mode="index-seealso">
         <xsl:with-param name="scope" select="$scope"/>
         <xsl:sort select="translate(seealso, &lowercase;, &uppercase;)"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="$refs[secondary and count(.|key('secondary', concat($key, &sep;, &secondary;))[ancestor::* = $scope][1]) = 1]"
                           mode="index-secondary">
       <xsl:with-param name="scope" select="$scope"/>
       <xsl:sort select="translate(&secondary;, &lowercase;, &uppercase;)"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="indexterm" mode="index-secondary">
  <xsl:param name="scope" select="."/>
  <xsl:variable name="key" select="concat(&primary;, &sep;, &secondary;)"/>
  <xsl:variable name="refs" select="key('secondary', $key)[ancestor::* = $scope]"/>
  <fo:block>
    <xsl:value-of select="secondary"/>

    <xsl:variable name="page-number-citations">
      <xsl:for-each select="$refs[not(see) and not(seealso)]">
        <xsl:apply-templates select="." mode="reference">
          <xsl:with-param name="scope" select="$scope"/>
        </xsl:apply-templates>
      </xsl:for-each>

      <xsl:if test="$refs[not(tertiary)]/*[self::see]">
        <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see', concat(&primary;, &sep;, &secondary;, &sep;, &sep;, see))[ancestor::* = $scope][1])]"
                             mode="index-see">
          <xsl:with-param name="scope" select="$scope"/>
          <xsl:sort select="translate(see, &lowercase;, &uppercase;)"/>
        </xsl:apply-templates>
      </xsl:if>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$passivetex.extensions != '0'">
        <fotex:sort xmlns:fotex="http://www.tug.org/fotex">
          <xsl:copy-of select="$page-number-citations"/>
        </fotex:sort>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$page-number-citations"/>
      </xsl:otherwise>
    </xsl:choose>
  </fo:block>

  <xsl:if test="$refs/tertiary or $refs[not(tertiary)]/*[self::seealso]">
    <fo:block start-indent="2pc">
      <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see-also', concat(&primary;, &sep;, &secondary;, &sep;, &sep;, seealso))[ancestor::* = $scope][1])]"
                           mode="index-seealso">
          <xsl:with-param name="scope" select="$scope"/>
          <xsl:sort select="translate(seealso, &lowercase;, &uppercase;)"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="$refs[tertiary and count(.|key('tertiary', concat($key, &sep;, &tertiary;))[ancestor::* = $scope][1]) = 1]" 
                           mode="index-tertiary">
          <xsl:with-param name="scope" select="$scope"/>
          <xsl:sort select="translate(&tertiary;, &lowercase;, &uppercase;)"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="indexterm" mode="index-tertiary">
  <xsl:param name="scope" select="."/>
  <xsl:variable name="key" select="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;)"/>
  <xsl:variable name="refs" select="key('tertiary', $key)[ancestor::* = $scope]"/>
  <fo:block>
    <xsl:value-of select="tertiary"/>

    <xsl:variable name="page-number-citations">
      <xsl:for-each select="$refs[not(see) and not(seealso)]">
        <xsl:apply-templates select="." mode="reference">
          <xsl:with-param name="scope" select="$scope"/>
        </xsl:apply-templates>
      </xsl:for-each>

      <xsl:if test="$refs/see">
        <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see', concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, see))[ancestor::* = $scope][1])]"
                             mode="index-see">
          <xsl:with-param name="scope" select="$scope"/>
          <xsl:sort select="translate(see, &lowercase;, &uppercase;)"/>
        </xsl:apply-templates>
      </xsl:if>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$passivetex.extensions != '0'">
        <fotex:sort xmlns:fotex="http://www.tug.org/fotex">
          <xsl:copy-of select="$page-number-citations"/>
        </fotex:sort>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$page-number-citations"/>
      </xsl:otherwise>
    </xsl:choose>
  </fo:block>

  <xsl:if test="$refs/seealso">
    <fo:block>
      <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see-also', concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, seealso))[ancestor::* = $scope][1])]"
                           mode="index-seealso">
        <xsl:with-param name="scope" select="$scope"/>
        <xsl:sort select="translate(seealso, &lowercase;, &uppercase;)"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="indexterm" mode="reference">
  <xsl:param name="scope" select="."/>
  <xsl:param name="separator" select="', '"/>

  <xsl:if test="$passivetex.extensions = '0'">
    <xsl:value-of select="$separator"/>
  </xsl:if>

  <xsl:choose>
    <xsl:when test="@zone and string(@zone)">
      <xsl:call-template name="reference">
        <xsl:with-param name="zones" select="normalize-space(@zone)"/>
        <xsl:with-param name="scope" select="$scope"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="id">
        <xsl:call-template name="object.id"/>
      </xsl:variable>

      <fo:basic-link internal-destination="{$id}">
        <fo:page-number-citation ref-id="{$id}"/>
      </fo:basic-link>

      <xsl:if test="key('endofrange', @id)">
        <xsl:apply-templates select="key('endofrange', @id)[ancestor::* = $scope][last()]"
                             mode="reference">
          <xsl:with-param name="scope" select="$scope"/>
          <xsl:with-param name="separator" select="'-'"/>
        </xsl:apply-templates>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="reference">
  <xsl:param name="scope" select="."/>
  <xsl:param name="zones"/>
  <xsl:choose>
    <xsl:when test="contains($zones, ' ')">
      <xsl:variable name="zone" select="substring-before($zones, ' ')"/>
      <xsl:variable name="target" select="key('id', $zone)[ancestor::* = $scope]"/>

      <xsl:variable name="id">
        <xsl:call-template name="object.id">
           <xsl:with-param name="object" select="$target[1]"/>
        </xsl:call-template>
      </xsl:variable>

      <fo:basic-link internal-destination="{$id}">
        <fo:page-number-citation ref-id="{$id}"/>
      </fo:basic-link>

      <xsl:if test="$passivetex.extensions = '0'">
        <xsl:text>, </xsl:text>
      </xsl:if>
      <xsl:call-template name="reference">
        <xsl:with-param name="zones" select="substring-after($zones, ' ')"/>
        <xsl:with-param name="scope" select="$scope"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="zone" select="$zones"/>
      <xsl:variable name="target" select="key('id', $zone)[ancestor::* = $scope]"/>

      <xsl:variable name="id">
        <xsl:call-template name="object.id">
          <xsl:with-param name="object" select="$target[1]"/>
        </xsl:call-template>
      </xsl:variable>

      <fo:basic-link internal-destination="{$id}">
        <fo:page-number-citation ref-id="{$id}"/>
      </fo:basic-link>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="indexterm" mode="index-see">
   <xsl:param name="scope" select="."/>
   <fo:inline>
     <xsl:text> (</xsl:text>
     <xsl:call-template name="gentext">
       <xsl:with-param name="key" select="'see'"/>
     </xsl:call-template>
     <xsl:text> </xsl:text>
     <xsl:value-of select="see"/>
     <xsl:text>)</xsl:text>
   </fo:inline>
</xsl:template>

<xsl:template match="indexterm" mode="index-seealso">
   <xsl:param name="scope" select="."/>
   <fo:block>
     <xsl:text>(</xsl:text>
     <xsl:call-template name="gentext">
       <xsl:with-param name="key" select="'seealso'"/>
     </xsl:call-template>
     <xsl:text> </xsl:text>
     <xsl:value-of select="seealso"/>
     <xsl:text>)</xsl:text>
   </fo:block>
</xsl:template>

<!-- ====================================================================== -->

<xsl:template name="generate-index-markup">
  <xsl:variable name="scope" select=".."/>
  <xsl:variable name="terms" select="..//indexterm[count(.|key('letter',
                                     translate(substring(&primary;, 1, 1),&lowercase;,&uppercase;))[ancestor::* = $scope][1]) = 1]"/>
  <xsl:variable name="alphabetical"
                select="$terms[contains(concat(&lowercase;, &uppercase;),
                                        substring(&primary;, 1, 1))]"/>
  <xsl:variable name="others" select="$terms[not(contains(concat(&lowercase;,
                                                 &uppercase;),
                                             substring(&primary;, 1, 1)))]"/>

  <xsl:text>&lt;index&gt;&#10;</xsl:text>
  <xsl:if test="$others">
    <xsl:text>&#10;&lt;indexdiv&gt;&#10;</xsl:text>
    <xsl:text>&lt;title&gt;</xsl:text>
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'index symbols'"/>
    </xsl:call-template>
    <xsl:text>&lt;/title&gt;&#10;</xsl:text>
    <xsl:apply-templates select="$others[count(.|key('primary',
                                 &primary;)[ancestor::* = $scope][1]) = 1]"
                         mode="index-symbol-div-markup">
      <xsl:with-param name="scope" select="$scope"/>
      <xsl:sort select="translate(&primary;, &lowercase;, &uppercase;)"/>
    </xsl:apply-templates>
    <xsl:text>&lt;/indexdiv&gt;&#10;</xsl:text>
  </xsl:if>

  <xsl:apply-templates select="$alphabetical[count(.|key('letter',
                               translate(substring(&primary;, 1, 1),&lowercase;,&uppercase;))[ancestor::* = $scope][1]) = 1]"
                       mode="index-div-markup">
      <xsl:with-param name="scope" select="$scope"/>
      <xsl:sort select="translate(&primary;, &lowercase;, &uppercase;)"/>
  </xsl:apply-templates>
  <xsl:text>&lt;/index&gt;&#10;</xsl:text>
</xsl:template>

<xsl:template match="*" mode="index-markup">
  <xsl:param name="scope" select="."/>

  <xsl:text>&lt;</xsl:text>
  <xsl:value-of select="name(.)"/>
  <xsl:text>&gt;&#10;</xsl:text>
  <xsl:apply-templates mode="index-markup">
    <xsl:with-param name="scope" select="$scope"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="indexterm" mode="index-div-markup">
  <xsl:param name="scope" select="."/>
  <xsl:variable name="key" select="translate(substring(&primary;, 1, 1),&lowercase;,&uppercase;)"/>
  <xsl:text>&#10;&lt;indexdiv&gt;&#10;</xsl:text>
  <xsl:text>&lt;title&gt;</xsl:text>
  <xsl:value-of select="translate($key, &lowercase;, &uppercase;)"/>
  <xsl:text>&lt;/title&gt;&#10;</xsl:text>

  <xsl:apply-templates select="key('letter', $key)[count(.|key('primary', &primary;)[ancestor::* = $scope][1]) = 1]"
                       mode="index-primary-markup">
    <xsl:with-param name="scope" select="$scope"/>
    <xsl:sort select="translate(&primary;, &lowercase;, &uppercase;)"/>
  </xsl:apply-templates>
  <xsl:text>&lt;/indexdiv&gt;&#10;</xsl:text>
</xsl:template>

<xsl:template match="indexterm" mode="index-symbol-div-markup">
  <xsl:param name="scope" select="."/>
  <xsl:variable name="key" select="translate(substring(&primary;, 1, 1),&lowercase;,&uppercase;)"/>

  <xsl:apply-templates select="key('letter', $key)[count(.|key('primary', &primary;)[ancestor::* = $scope][1]) = 1]"
                       mode="index-primary-markup">
    <xsl:with-param name="scope" select="$scope"/>
    <xsl:sort select="translate(&primary;, &lowercase;, &uppercase;)"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="indexterm" mode="index-primary-markup">
  <xsl:param name="scope" select="."/>
  <xsl:variable name="key" select="&primary;"/>
  <xsl:variable name="refs" select="key('primary', $key)[ancestor::* = $scope]"/>
  <xsl:variable name="pages" select="$refs[not(see) and not(seealso)]"/>

  <xsl:text>&#10;&lt;indexentry&gt;&#10;</xsl:text>
  <xsl:text>&lt;primaryie&gt;</xsl:text>
  <xsl:text>&lt;phrase&gt;</xsl:text>
  <xsl:call-template name="escape-text">
    <xsl:with-param name="text" select="string(primary)"/>
  </xsl:call-template>
  <xsl:text>&lt;/phrase&gt;</xsl:text>
  <xsl:if test="$pages">,</xsl:if>
  <xsl:text>&#10;</xsl:text>

  <xsl:for-each select="$pages">
    <xsl:apply-templates select="." mode="reference-markup">
      <xsl:with-param name="scope" select="$scope"/>
    </xsl:apply-templates>
  </xsl:for-each>

  <xsl:text>&lt;/primaryie&gt;&#10;</xsl:text>

  <xsl:if test="$refs/secondary or $refs[not(secondary)]/*[self::see or self::seealso]">
    <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see', concat(&primary;, &sep;, &sep;, &sep;, see))[ancestor::* = $scope][1])]"
                         mode="index-see-markup">
      <xsl:with-param name="scope" select="$scope"/>
      <xsl:sort select="translate(see, &lowercase;, &uppercase;)"/>
    </xsl:apply-templates>

    <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see-also', concat(&primary;, &sep;, &sep;, &sep;, seealso))[ancestor::* = $scope][1])]"
                         mode="index-seealso-markup">
      <xsl:with-param name="scope" select="$scope"/>
      <xsl:sort select="translate(seealso, &lowercase;, &uppercase;)"/>
    </xsl:apply-templates>

    <xsl:apply-templates select="$refs[secondary and count(.|key('secondary', concat($key, &sep;, &secondary;))[ancestor::* = $scope][1]) = 1]" 
                         mode="index-secondary-markup">
      <xsl:with-param name="scope" select="$scope"/>
      <xsl:sort select="translate(&secondary;, &lowercase;, &uppercase;)"/>
    </xsl:apply-templates>
  </xsl:if>
  <xsl:text>&lt;/indexentry&gt;&#10;</xsl:text>
</xsl:template>

<xsl:template match="indexterm" mode="index-secondary-markup">
  <xsl:param name="scope" select="."/>
  <xsl:variable name="key" select="concat(&primary;, &sep;, &secondary;)"/>
  <xsl:variable name="refs" select="key('secondary', $key)[ancestor::* = $scope]"/>
  <xsl:variable name="pages" select="$refs[not(see) and not(seealso)]"/>

  <xsl:text>&lt;secondaryie&gt;</xsl:text>
  <xsl:text>&lt;phrase&gt;</xsl:text>
  <xsl:call-template name="escape-text">
    <xsl:with-param name="text" select="string(secondary)"/>
  </xsl:call-template>
  <xsl:text>&lt;/phrase&gt;</xsl:text>
  <xsl:if test="$pages">,</xsl:if>
  <xsl:text>&#10;</xsl:text>

  <xsl:for-each select="$pages">
    <xsl:apply-templates select="." mode="reference-markup">
      <xsl:with-param name="scope" select="$scope"/>
    </xsl:apply-templates>
  </xsl:for-each>

  <xsl:text>&lt;/secondaryie&gt;&#10;</xsl:text>

  <xsl:if test="$refs/tertiary or $refs[not(tertiary)]/*[self::see or self::seealso]">
    <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see', concat(&primary;, &sep;, &secondary;, &sep;, &sep;, see))[ancestor::* = $scope][1])]"
                         mode="index-see-markup">
      <xsl:with-param name="scope" select="$scope"/>
      <xsl:sort select="translate(see, &lowercase;, &uppercase;)"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see-also', concat(&primary;, &sep;, &secondary;, &sep;, &sep;, seealso))[ancestor::* = $scope][1])]"
                         mode="index-seealso-markup">
      <xsl:with-param name="scope" select="$scope"/>
      <xsl:sort select="translate(seealso, &lowercase;, &uppercase;)"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="$refs[tertiary and count(.|key('tertiary', concat($key, &sep;, &tertiary;))[ancestor::* = $scope][1]) = 1]" 
                         mode="index-tertiary-markup">
      <xsl:with-param name="scope" select="$scope"/>
      <xsl:sort select="translate(&tertiary;, &lowercase;, &uppercase;)"/>
    </xsl:apply-templates>
  </xsl:if>
</xsl:template>

<xsl:template match="indexterm" mode="index-tertiary-markup">
  <xsl:param name="scope" select="."/>
  <xsl:variable name="key" select="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;)"/>
  <xsl:variable name="refs" select="key('tertiary', $key)[ancestor::* = $scope]"/>
  <xsl:variable name="pages" select="$refs[not(see) and not(seealso)]"/>

  <xsl:text>&lt;tertiaryie&gt;</xsl:text>
  <xsl:text>&lt;phrase&gt;</xsl:text>
  <xsl:call-template name="escape-text">
    <xsl:with-param name="text" select="string(tertiary)"/>
  </xsl:call-template>
  <xsl:text>&lt;/phrase&gt;</xsl:text>
  <xsl:if test="$pages">,</xsl:if>
  <xsl:text>&#10;</xsl:text>

  <xsl:for-each select="$pages">
    <xsl:apply-templates select="." mode="reference-markup">
      <xsl:with-param name="scope" select="$scope"/>
    </xsl:apply-templates>
  </xsl:for-each>

  <xsl:text>&lt;/tertiaryie&gt;&#10;</xsl:text>

  <xsl:variable name="see" select="$refs/see | $refs/seealso"/>
  <xsl:if test="$see">
    <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see', concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, see))[ancestor::* = $scope][1])]"
                         mode="index-see-markup">
      <xsl:with-param name="scope" select="$scope"/>
      <xsl:sort select="translate(see, &lowercase;, &uppercase;)"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see-also', concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, seealso))[ancestor::* = $scope][1])]"
                         mode="index-seealso-markup">
      <xsl:with-param name="scope" select="$scope"/>
      <xsl:sort select="translate(seealso, &lowercase;, &uppercase;)"/>
    </xsl:apply-templates>
  </xsl:if>
</xsl:template>

<xsl:template match="indexterm" mode="reference-markup">
  <xsl:param name="scope" select="."/>
  <xsl:choose>
    <xsl:when test="@zone and string(@zone)">
      <xsl:call-template name="reference-markup">
        <xsl:with-param name="zones" select="normalize-space(@zone)"/>
        <xsl:with-param name="scope" select="$scope"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="id">
        <xsl:call-template name="object.id"/>
      </xsl:variable>


      <xsl:choose>
        <xsl:when test="@startref and @class='endofrange'">
          <xsl:text>&lt;phrase role="pageno"&gt;</xsl:text>
          <xsl:text>&lt;link linkend="</xsl:text>
          <xsl:value-of select="@startref"/>
          <xsl:text>"&gt;</xsl:text>
          <fo:basic-link internal-destination="{@startref}">
            <fo:page-number-citation ref-id="{@startref}"/>
            <xsl:text>-</xsl:text>
            <fo:page-number-citation ref-id="{$id}"/>
          </fo:basic-link>
          <xsl:text>&lt;/link&gt;</xsl:text>
          <xsl:text>&lt;/phrase&gt;&#10;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>&lt;phrase role="pageno"&gt;</xsl:text>
          <xsl:if test="@id">
            <xsl:text>&lt;link linkend="</xsl:text>
            <xsl:value-of select="$id"/>
            <xsl:text>"&gt;</xsl:text>
          </xsl:if>
          <fo:basic-link internal-destination="{$id}">
            <fo:page-number-citation ref-id="{$id}"/>
          </fo:basic-link>
          <xsl:if test="@id">
            <xsl:text>&lt;/link&gt;</xsl:text>
          </xsl:if>
          <xsl:text>&lt;/phrase&gt;&#10;</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="reference-markup">
  <xsl:param name="scope" select="."/>
  <xsl:param name="zones"/>
  <xsl:choose>
    <xsl:when test="contains($zones, ' ')">
      <xsl:variable name="zone" select="substring-before($zones, ' ')"/>
      <xsl:variable name="target" select="key('id', $zone)[ancestor::* = $scope]"/>

      <xsl:variable name="id">
        <xsl:call-template name="object.id">
          <xsl:with-param name="object" select="$target[1]"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:text>&lt;phrase fole="pageno"&gt;</xsl:text>
      <xsl:if test="$target[1]/@id">
        <xsl:text>&lt;link linkend="</xsl:text>
        <xsl:value-of select="$id"/>
        <xsl:text>"&gt;</xsl:text>
      </xsl:if>
      <fo:basic-link internal-destination="{$id}">
        <fo:page-number-citation ref-id="{$id}"/>
      </fo:basic-link>
      <xsl:if test="$target[1]/@id">
        <xsl:text>&lt;/link&gt;</xsl:text>
      </xsl:if>
      <xsl:text>&lt;/phrase&gt;&#10;</xsl:text>

      <xsl:call-template name="reference">
        <xsl:with-param name="zones" select="substring-after($zones, ' ')"/>
        <xsl:with-param name="scope" select="$scope"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="zone" select="$zones"/>
      <xsl:variable name="target" select="key('id', $zone)"/>

      <xsl:variable name="id">
        <xsl:call-template name="object.id">
          <xsl:with-param name="object" select="$target[1]"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:text>&lt;phrase role="pageno"&gt;</xsl:text>
      <xsl:if test="$target[1]/@id">
        <xsl:text>&lt;link linkend="</xsl:text>
        <xsl:value-of select="$id"/>
        <xsl:text>"&gt;</xsl:text>
      </xsl:if>
      <fo:basic-link internal-destination="{$id}">
        <fo:page-number-citation ref-id="{$id}"/>
      </fo:basic-link>
      <xsl:if test="$target[1]/@id">
        <xsl:text>&lt;/link&gt;</xsl:text>
      </xsl:if>
      <xsl:text>&lt;/phrase&gt;&#10;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="indexterm" mode="index-see-markup">
  <xsl:param name="scope" select="."/>
  <fo:block>
    <xsl:text>&lt;seeie&gt;</xsl:text>
    <xsl:text>&lt;phrase&gt;</xsl:text>
    <xsl:call-template name="escape-text">
      <xsl:with-param name="text" select="string(see)"/>
    </xsl:call-template>
    <xsl:text>&lt;/phrase&gt;</xsl:text>
    <xsl:text>&lt;/seeie&gt;&#10;</xsl:text>
  </fo:block>
</xsl:template>

<xsl:template match="indexterm" mode="index-seealso-markup">
  <xsl:param name="scope" select="."/>
  <fo:block>
    <xsl:text>&lt;seealsoie&gt;</xsl:text>
    <xsl:text>&lt;phrase&gt;</xsl:text>
    <xsl:call-template name="escape-text">
      <xsl:with-param name="text" select="string(seealso)"/>
    </xsl:call-template>
    <xsl:text>&lt;/phrase&gt;</xsl:text>
    <xsl:text>&lt;/seealsoie&gt;&#10;</xsl:text>
  </fo:block>
</xsl:template>

<xsl:template name="escape-text">
  <xsl:param name="text" select="''"/>

  <xsl:variable name="ltpos" select="substring-before($text, '&lt;')"/>
  <xsl:variable name="amppos" select="substring-before($text, '&amp;')"/>

  <xsl:choose>
    <xsl:when test="contains($text,'&lt;') and contains($text, '&amp;')
                    and string-length($ltpos) &lt; string-length($amppos)">
      <xsl:value-of select="$ltpos"/>
      <xsl:text>&amp;lt;</xsl:text>
      <xsl:call-template name="escape-text">
        <xsl:with-param name="text" select="substring-after($text, '&lt;')"/>
      </xsl:call-template>
    </xsl:when>

    <xsl:when test="contains($text,'&lt;') and contains($text, '&amp;')
                    and string-length($amppos) &lt; string-length($ltpos)">
      <xsl:value-of select="$amppos"/>
      <xsl:text>&amp;amp;</xsl:text>
      <xsl:call-template name="escape-text">
        <xsl:with-param name="text" select="substring-after($text, '&amp;')"/>
      </xsl:call-template>
    </xsl:when>

    <xsl:when test="contains($text, '&lt;')">
      <xsl:value-of select="$ltpos"/>
      <xsl:text>&amp;lt;</xsl:text>
      <xsl:call-template name="escape-text">
        <xsl:with-param name="text" select="substring-after($text, '&lt;')"/>
      </xsl:call-template>
    </xsl:when>

    <xsl:when test="contains($text, '&amp;')">
      <xsl:value-of select="$amppos"/>
      <xsl:text>&amp;amp;</xsl:text>
      <xsl:call-template name="escape-text">
        <xsl:with-param name="text" select="substring-after($text, '&amp;')"/>
      </xsl:call-template>
    </xsl:when>

    <xsl:otherwise>
      <xsl:value-of select="$text"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
