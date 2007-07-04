<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                exclude-result-prefixes="doc"
                version='1.0'>

<!-- ********************************************************************
     $Id$
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<doc:reference xmlns="">
  <referenceinfo>
    <releaseinfo role="meta">
      $Id$
    </releaseinfo>
    <authorgroup>
      <author>
        <orgname>The DocBook Project Development Team</orgname>
      </author>
    </authorgroup>
    <copyright>
      <year>2007</year>
      <holder>The DocBook Project</holder>
    </copyright>
  </referenceinfo>
  <title>HTML Processing Instruction Reference</title>

  <partintro id="partintro">
    <title>Introduction</title>

    <para>This is generated reference documentation for all
      user-specifiable processing instructions (PIs) in the DocBook
      XSL stylesheets for HTML output.
      <note>
        <para>You add these PIs at particular points in a document to
          cause specific “exceptions” to formatting/output behavior. To
          make global changes in formatting/output behavior across an
          entire document, it’s better to do it by setting an
          appropriate stylesheet parameter (if there is one).</para>
      </note>
    </para>
  </partintro>
</doc:reference>

<!-- ==================================================================== -->

<doc:pi name="dbhtml_dir" xmlns="">
  <refpurpose>Specifies a directory name in which to write files</refpurpose>
  <refdescription>
    <para>When chunking output, use the <tag>dbhtml dir</tag> PI
      as a child of a chunk source to cause the output of that
      chunk to be written to the specified directory; also, use it
      as a child of a <tag>mediaobject</tag> to specify a
      directory into which any long-description files for that
      <tag>mediaobject</tag> will be written.</para>
  </refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbhtml dir="<replaceable>path</replaceable>"</tag></synopsis>
  </refsynopsisdiv>
  <refparameter>
    <variablelist>
      <varlistentry><term>dir="<replaceable>path</replaceable>"</term>
        <listitem>
          <para>Specifies the pathname for the directory</para>
        </listitem>
      </varlistentry>
    </variablelist>
  </refparameter>
  <refsee role="params">
    <para><parameter>base.dir</parameter></para>
  </refsee>
  <refsee>
    <para><ulink
        url="http://www.sagehill.net/docbookxsl/Chunking.html#dbhtmlDirPI"
        >dbhtml dir processing instruction</ulink> section in Bob
      Stayton’s book <ulink
        url="http://www.sagehill.net/docbookxsl/" >DocBook XSL:
        The Complete Guide</ulink></para>
  </refsee>
</doc:pi>
<xsl:template name="pi.dbhtml_dir">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbhtml-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbhtml')"/>
    <xsl:with-param name="attribute" select="'dir'"/>
  </xsl:call-template>
</xsl:template>

<doc:pi name="dbhtml_dir" xmlns="">
  <refpurpose>Specifies a filename for a chunk</refpurpose>
  <refdescription>
    <para>When chunking output, use the <tag>dbhtml filename</tag>
      PI as a child of a chunk source to specify a filename for
      the output file for that chunk.</para>
  </refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbhtml filename="<replaceable>filename</replaceable>"</tag></synopsis>
  </refsynopsisdiv>
  <refparameter>
    <variablelist>
      <varlistentry><term>filename="<replaceable>path</replaceable>"</term>
        <listitem>
          <para>Specifies the filename for the file</para>
        </listitem>
      </varlistentry>
    </variablelist>
  </refparameter>
  <refsee role="params">
    <para><parameter>use.id.as.filename</parameter></para>
  </refsee>
  <refsee>
    <para><ulink
        url="http://www.sagehill.net/docbookxsl/Chunking.html#DbhtmlFilenames"
        >dbhtml filenames</ulink> section in Bob Stayton’s book
      <ulink url="http://www.sagehill.net/docbookxsl/" >DocBook
        XSL: The Complete Guide</ulink></para>
  </refsee>
</doc:pi>
<xsl:template name="pi.dbhtml_filename">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbhtml-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbhtml')"/>
    <xsl:with-param name="attribute" select="'filename'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="pi.dbhtml_img.src.path">
  <!-- * called on parent of graphic, inlinegraphic, imagedata, or videodata -->
  <xsl:call-template name="dbhtml-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbhtml')"/>
    <xsl:with-param name="attribute" select="'img.src.path'"/>
  </xsl:call-template>
</xsl:template>

<doc:pi name="dbhtml_background-color" xmlns="">
  <refpurpose>Sets background color for an image</refpurpose>
  <refdescription>
    <para>Use the <tag>dbhtml background-color</tag> PI before or
      after an image (<tag>graphic</tag>, <tag>inlinegraphic</tag>,
      <tag>imagedata</tag>, or <tag>videodata</tag> element) as a
      sibling to the element, to set a background color for the
      image.</para>
  </refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbhtml background-color="<replaceable>color</replaceable>"</tag></synopsis>
  </refsynopsisdiv>
  <refparameter>
    <variablelist>
      <varlistentry><term>background-color="<replaceable>color</replaceable>"</term>
        <listitem>
          <para>An HTML color value</para>
        </listitem>
      </varlistentry>
    </variablelist>
  </refparameter>
  <refsee>
    <para><ulink
        url="http://www.sagehill.net/docbookxsl/BGcolor.html"
        >Background color</ulink> section in Bob Stayton’s book
      <ulink url="http://www.sagehill.net/docbookxsl/" >DocBook
        XSL: The Complete Guide</ulink></para>
  </refsee>
</doc:pi>
<xsl:template name="pi.dbhtml_background-color">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbhtml-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbhtml')"/>
    <xsl:with-param name="attribute" select="'background-color'"/>
  </xsl:call-template>
</xsl:template>

<doc:pi name="dbhtml_bgcolor" xmlns="">
  <refpurpose>Sets background color on an table row or table cell</refpurpose>
  <refdescription>
    <para>Use the <tag>dbhtml bgcolor</tag> PI as child of a table row
      or cell to set a background color for that table row or cell.</para>
  </refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbhtml bgcolor="<replaceable>color</replaceable>"</tag></synopsis>
  </refsynopsisdiv>
  <refparameter>
    <variablelist>
      <varlistentry><term>bgcolor="<replaceable>color</replaceable>"</term>
        <listitem>
          <para>An HTML color value</para>
        </listitem>
      </varlistentry>
    </variablelist>
  </refparameter>
  <refsee>
    <para><ulink
        url="http://www.sagehill.net/docbookxsl/BGtableColor.html#CellBGColor"
        >Cell background color</ulink> section in Bob Stayton’s
      book <ulink url="http://www.sagehill.net/docbookxsl/"
        >DocBook XSL: The Complete Guide</ulink></para>
  </refsee>
</doc:pi>
<xsl:template name="pi.dbhtml_bgcolor">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbhtml-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbhtml')"/>
    <xsl:with-param name="attribute" select="'bgcolor'"/>
  </xsl:call-template>
</xsl:template>

<doc:pi name="dbhtml_cellpadding" xmlns="">
  <refpurpose>Specifies the value of the cellpadding attribute in
    output of a table or qandaset</refpurpose>
  <refdescription>
    <para>Use the <tag>dbhtml cellpadding</tag> PI as a child of a
      <tag>table</tag> or <tag>qandaset</tag> to specify the value
      for the HTML <literal>cellpadding</literal> attribute in the
      output HTML table.</para>
  </refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbhtml cellpadding="<replaceable>number</replaceable>"</tag></synopsis>
  </refsynopsisdiv>
  <refparameter>
    <variablelist>
      <varlistentry><term>cellpadding="<replaceable>number</replaceable>"</term>
        <listitem>
          <para>Specifies the cellpadding</para>
        </listitem>
      </varlistentry>
    </variablelist>
  </refparameter>
  <refsee role="params">
    <para><parameter>html.cellpadding</parameter></para>
  </refsee>
  <refsee>
    <itemizedlist>
      <listitem>
        <para><ulink
            url="http://www.sagehill.net/docbookxsl/CellSpacing.html"
            >Cell spacing and cell padding</ulink> section in Bob
          Stayton’s book <ulink
            url="http://www.sagehill.net/docbookxsl/"
            >DocBook XSL: The Complete Guide</ulink></para>
      </listitem>
      <listitem>
        <para><ulink
            url="http://www.sagehill.net/docbookxsl/QandAformat.html"
            >Q and A formatting</ulink> section in Bob Stayton’s
          book <ulink url="http://www.sagehill.net/docbookxsl/"
            >DocBook XSL: The Complete Guide</ulink></para>
      </listitem>
    </itemizedlist>
  </refsee>
</doc:pi>
<xsl:template name="pi.dbhtml_cellpadding">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbhtml-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbhtml')"/>
    <xsl:with-param name="attribute" select="'cellpadding'"/>
  </xsl:call-template>
</xsl:template>

<doc:pi name="dbhtml_cellspacing" xmlns="">
  <refpurpose>Specifies the value of the cellspacing attribute in
    output of a table or qandaset</refpurpose>
  <refdescription>
    <para>Use the <tag>dbhtml cellspacing</tag> PI as a child of a
      <tag>table</tag> or <tag>qandaset</tag> to specify the value
      for the HTML <literal>cellspacing</literal> attribute in the
      output HTML table.</para>
  </refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbhtml cellspacing="<replaceable>number</replaceable>"</tag></synopsis>
  </refsynopsisdiv>
  <refparameter>
    <variablelist>
      <varlistentry><term>cellspacing="<replaceable>number</replaceable>"</term>
        <listitem>
          <para>Specifies the cellspacing</para>
        </listitem>
      </varlistentry>
    </variablelist>
  </refparameter>
  <refsee role="params">
    <para><parameter>html.cellspacing</parameter></para>
  </refsee>
  <refsee>
    <itemizedlist>
      <listitem>
        <para><ulink
            url="http://www.sagehill.net/docbookxsl/CellSpacing.html"
            >Cell spacing and cell padding</ulink> section in Bob
          Stayton’s book <ulink
            url="http://www.sagehill.net/docbookxsl/"
            >DocBook XSL: The Complete Guide</ulink></para>
      </listitem>
      <listitem>
        <para><ulink
            url="http://www.sagehill.net/docbookxsl/QandAformat.html"
            >Q and A formatting</ulink> section in Bob Stayton’s
          book <ulink url="http://www.sagehill.net/docbookxsl/"
            >DocBook XSL: The Complete Guide</ulink></para>
      </listitem>
    </itemizedlist>
  </refsee>
</doc:pi>
<xsl:template name="pi.dbhtml_cellspacing">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbhtml-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbhtml')"/>
    <xsl:with-param name="attribute" select="'cellspacing'"/>
  </xsl:call-template>
</xsl:template>

<doc:pi name="dbhtml_class" xmlns="">
  <refpurpose>Set value of the class attribute for a table row</refpurpose>
  <refdescription>
    <para>Use the <tag>dbhtml class</tag> PI as a child of a
      <tag>row</tag> to specify a <literal>class</literal>
      attribute and value in the HTML output for that row.</para>
  </refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbhtml class="<replaceable>name</replaceable>"</tag></synopsis>
  </refsynopsisdiv>
  <refparameter>
    <variablelist>
      <varlistentry><term>class="<replaceable>name</replaceable>"</term>
        <listitem>
          <para>Specifies the class name</para>
        </listitem>
      </varlistentry>
    </variablelist>
  </refparameter>
  <refsee>
    <para><ulink
        url="http://www.sagehill.net/docbookxsl/CSSTableCells.html"
        >Table styles in HTML output</ulink> section in Bob
      Stayton’s book <ulink
        url="http://www.sagehill.net/docbookxsl/"
        >DocBook XSL: The Complete Guide</ulink></para>
  </refsee>
</doc:pi>
<xsl:template name="pi.dbhtml_class">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbhtml-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbhtml')"/>
    <xsl:with-param name="attribute" select="'class'"/>
  </xsl:call-template>
</xsl:template> 

<doc:pi name="dbhtml_funcsynopsis-style" xmlns="">
  <refpurpose>Specifies presentation style for a funcsynopsis</refpurpose>
  <refdescription>
    <para>Use the <tag>dbhtml funcsynopsis-style</tag> PI as a child of
      a <tag>funcprototype</tag> or anywhere within a funcprototype
      control the presentation style for the <tag>funcsynopsis</tag>
      in output.</para>
  </refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbhtml funcsynopsis-style="kr"|"ansi"</tag></synopsis>
  </refsynopsisdiv>
  <refparameter>
    <variablelist>
      <varlistentry><term>funcsynopsis-style="kr"</term>
        <listitem>
          <para>Displays the <tag>funcprototype</tag> in K&amp;R style</para>
        </listitem>
      </varlistentry>
      <varlistentry><term>funcsynopsis-style="ansi"</term>
        <listitem>
          <para>Displays the <tag>funcprototype</tag> in ANSI style</para>
        </listitem>
      </varlistentry>
    </variablelist>
  </refparameter>
  <refsee role="params">
    <para><parameter>funcsynopsis.style</parameter></para>
  </refsee>
</doc:pi>
<xsl:template name="pi.dbhtml_funcsynopsis-style">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbhtml-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbhtml')"/>
    <xsl:with-param name="attribute" select="'funcsynopsis-style'"/>
  </xsl:call-template>
</xsl:template>

<doc:pi name="dbhtml_label-width" xmlns="">
  <refpurpose>Specifies the label width for a qandaset</refpurpose>
  <refdescription>
    <para>Use the <tag>dbhtml label-width</tag> PI as a child of a
      <tag>qandaset</tag> to specify the width of labels.</para>
  </refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbhtml label-width="<replaceable>width</replaceable>"</tag></synopsis>
  </refsynopsisdiv>
  <refparameter>
    <variablelist>
      <varlistentry><term>label-width="<replaceable>width</replaceable>"</term>
        <listitem>
          <para>FIXME: Specifies the label width (in what units?)</para>
        </listitem>
      </varlistentry>
    </variablelist>
  </refparameter>
  <refsee>
    <para><ulink
        url="http://www.sagehill.net/docbookxsl/QandAformat.html"
        >Q and A formatting</ulink> section in Bob Stayton’s book
      <ulink url="http://www.sagehill.net/docbookxsl/"
        >DocBook XSL: The Complete Guide</ulink></para>
  </refsee>
</doc:pi>
<xsl:template name="pi.dbhtml_label-width">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbhtml-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbhtml')"/>
    <xsl:with-param name="attribute" select="'label-width'"/>
  </xsl:call-template>
</xsl:template> 

<doc:pi name="dbhtml_linenumbering.everyNth" xmlns="">
  <refpurpose>Specifies the interval at which lines are numbered in
    output of verbatim environments</refpurpose>
  <refdescription>
    <para>Use the <tag>dbhtml linenumbering.everyNth</tag> PI as a child
      of a “verbatim” element – <tag>programlisting</tag>,
      <tag>screen</tag>, <tag>synopsis</tag> — to specify
      the interval at which lines are numbered.</para>
  </refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbhtml linenumbering.everyNth="<replaceable>N</replaceable>"</tag></synopsis>
  </refsynopsisdiv>
  <refparameter>
    <variablelist>
      <varlistentry><term>linenumbering.everyNth="<replaceable>N</replaceable>"</term>
        <listitem>
          <para>FIXME: Specifies numbering interval; a number is
            output before every <replaceable>N</replaceable>th line</para>
        </listitem>
      </varlistentry>
    </variablelist>
  </refparameter>
  <refsee role="params">
    <para><parameter>linenumbering.everyNth</parameter></para>
  </refsee>
  <refsee>
    <para><ulink
        url="http://www.sagehill.net/docbookxsl/AnnotateListing.html#LineNumbering"
        >Line numbering</ulink> section in Bob Stayton’s book
      <ulink url="http://www.sagehill.net/docbookxsl/" >DocBook
        XSL: The Complete Guide</ulink></para>
  </refsee>
</doc:pi>
<xsl:template name="pi.dbhtml_linenumbering.everyNth">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbhtml-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbhtml')"/>
    <xsl:with-param name="attribute" select="'linenumbering.everyNth'"/>
  </xsl:call-template>
</xsl:template>

<doc:pi name="dbhtml_linenumbering.separator" xmlns="">
  <refpurpose>Specifies the separator text used between line numbers
    and content in output of verbatim environments</refpurpose>
  <refdescription>
    <para>Use the <tag>dbhtml linenumbering.separator</tag> PI as a child
      of a “verbatim” element – <tag>programlisting</tag>,
      <tag>screen</tag>, <tag>synopsis</tag> — to specify
      the separator text output between the line numbers and content.</para>
  </refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbhtml linenumbering.separator="<replaceable>text</replaceable>"</tag></synopsis>
  </refsynopsisdiv>
  <refparameter>
    <variablelist>
      <varlistentry><term>linenumbering.separator="<replaceable>text</replaceable>"</term>
        <listitem>
          <para>Specifies the text (zero or more characters)</para>
        </listitem>
      </varlistentry>
    </variablelist>
  </refparameter>
  <refsee role="params">
    <para><parameter>linenumbering.separator</parameter></para>
  </refsee>
  <refsee>
    <para><ulink
        url="http://www.sagehill.net/docbookxsl/AnnotateListing.html#LineNumbering"
        >Line numbering</ulink> section in Bob Stayton’s book
      <ulink url="http://www.sagehill.net/docbookxsl/" >DocBook
        XSL: The Complete Guide</ulink></para>
  </refsee>
</doc:pi>
<xsl:template name="pi.dbhtml_linenumbering.separator">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbhtml-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbhtml')"/>
    <xsl:with-param name="attribute" select="'linenumbering.separator'"/>
  </xsl:call-template>
</xsl:template>

<doc:pi name="dbhtml_linenumbering.width" xmlns="">
  <refpurpose>Specifies the width set aside for line numbers in
    output of verbatim environments</refpurpose>
  <refdescription>
    <para>Use the <tag>dbhtml linenumbering.width</tag> PI as a child
      of a “verbatim” element – <tag>programlisting</tag>,
      <tag>screen</tag>, <tag>synopsis</tag> — to specify
      the width set aside for line numbers.</para>
  </refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbhtml linenumbering.width="<replaceable>width</replaceable>"</tag></synopsis>
  </refsynopsisdiv>
  <refparameter>
    <variablelist>
      <varlistentry><term>linenumbering.width="<replaceable>width</replaceable>"</term>
        <listitem>
          <para>FIXME: Specifies the width (in what units?)</para>
        </listitem>
      </varlistentry>
    </variablelist>
  </refparameter>
  <refsee role="params">
    <para><parameter>linenumbering.width</parameter></para>
  </refsee>
  <refsee>
    <para><ulink
        url="http://www.sagehill.net/docbookxsl/AnnotateListing.html#LineNumbering"
        >Line numbering</ulink> section in Bob Stayton’s book
      <ulink url="http://www.sagehill.net/docbookxsl/" >DocBook
        XSL: The Complete Guide</ulink></para>
  </refsee>
</doc:pi>
<xsl:template name="pi.dbhtml_linenumbering.width">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbhtml-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbhtml')"/>
    <xsl:with-param name="attribute" select="'linenumbering.width'"/>
  </xsl:call-template>
</xsl:template>

<doc:pi name="dbhtml_list-presentation" xmlns="">
  <refpurpose>Specifies presentation style for a variablelist or
    segmentedlist</refpurpose>
  <refdescription>
    <para>Use the <tag>dbhtml list-presentation</tag> PI as a child of
      a <tag>variablelist</tag> or <tag>segmentedlist</tag> to
      control the presentation style for the list (to cause it, for
      example, to be displayed as a table).</para>
  </refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbhtml list-presentation="list"|"table"</tag></synopsis>
  </refsynopsisdiv>
  <refparameter>
    <variablelist>
      <varlistentry><term>list-presentation="list"</term>
        <listitem>
          <para>Displays the list as a list</para>
        </listitem>
      </varlistentry>
      <varlistentry><term>list-presentation="table"</term>
        <listitem>
          <para>Displays the list as a table</para>
        </listitem>
      </varlistentry>
    </variablelist>
  </refparameter>
  <refsee role="params">
    <itemizedlist>
      <listitem>
        <para><parameter>variablelist.as.table</parameter></para>
      </listitem>
      <listitem>
        <para><parameter>segmentedlist.as.table</parameter></para>
      </listitem>
    </itemizedlist>
  </refsee>
  <refsee>
    <para><ulink
        url="http://www.sagehill.net/docbookxsl/Variablelists.html#VarListFormatting"
        >Variable list formatting in HTML</ulink> section in Bob
      Stayton’s book <ulink
        url="http://www.sagehill.net/docbookxsl/"
        >DocBook XSL: The Complete Guide</ulink></para>
  </refsee>
</doc:pi>
<xsl:template name="pi.dbhtml_list-presentation">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbhtml-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbhtml')"/>
    <xsl:with-param name="attribute" select="'list-presentation'"/>
  </xsl:call-template>
</xsl:template>

<doc:pi name="dbhtml_linenumbering.width" xmlns="">
<refpurpose>Specifies the width set aside for line numbers in
  output of verbatim environments</refpurpose>
<refdescription>
  <para>Use the <tag>dbhtml linenumbering.width</tag> PI as a child
    of a “verbatim” element – <tag>programlisting</tag>,
    <tag>screen</tag>, <tag>synopsis</tag> — to specify
    the width set aside for line numbers.</para>
</refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbhtml linenumbering.width="<replaceable>width</replaceable>"</tag></synopsis>
  </refsynopsisdiv>
<refparameter>
  <variablelist>
    <varlistentry><term>linenumbering.width="<replaceable>width</replaceable>"</term>
      <listitem>
        <para>Specifies the width, in number of characters. Line
          numbers appear right justified in a field
          <replaceable>width</replaceable> characters wide.</para>
      </listitem>
    </varlistentry>
  </variablelist>
</refparameter>
  <refsee role="params">
    <para><parameter>linenumbering.width</parameter></para>
  </refsee>
</doc:pi>
<xsl:template name="pi.dbhtml_linenumbering.width">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbhtml-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbhtml')"/>
    <xsl:with-param name="attribute" select="'linenumbering.width'"/>
  </xsl:call-template>
</xsl:template>

<doc:pi name="dbhtml_list-width" xmlns="">
  <refpurpose>Specifies the width of a variablelist or simplelist</refpurpose>
  <refdescription>
    <para>Use the <tag>dbhtml list-width</tag> PI as a child of a
      <tag>variablelist</tag> or a <tag>simplelist</tag> presented
      as a table, to specify the output width.</para>
  </refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbhtml list-width="<replaceable>width</replaceable>"</tag></synopsis>
  </refsynopsisdiv>
  <refparameter>
    <variablelist>
      <varlistentry><term>list-width="<replaceable>width</replaceable>"</term>
        <listitem>
          <para>FIXME: Specifies the ouytput width (in what units?)</para>
        </listitem>
      </varlistentry>
    </variablelist>
  </refparameter>
  <refsee>
    <para><ulink
        url="http://www.sagehill.net/docbookxsl/Variablelists.html#VarListFormatting"
        >Variable list formatting in HTML</ulink> section in Bob
      Stayton’s book <ulink
        url="http://www.sagehill.net/docbookxsl/"
        >DocBook XSL: The Complete Guide</ulink></para>
  </refsee>
</doc:pi>
<xsl:template name="pi.dbhtml_list-width">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbhtml-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbhtml')"/>
    <xsl:with-param name="attribute" select="'list-width'"/>
  </xsl:call-template>
</xsl:template>

<doc:pi name="dbhtml_row-height" xmlns="">
  <refpurpose>Specifies the height for a table row</refpurpose>
  <refdescription>
    <para>Use the <tag>dbhtml row-height</tag> PI as a child of a
      <tag>row</tag> to specify the height of the row.</para>
  </refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbhtml row-height="<replaceable>height</replaceable>"</tag></synopsis>
  </refsynopsisdiv>
  <refparameter>
    <variablelist>
      <varlistentry><term>row-height="<replaceable>height</replaceable>"</term>
        <listitem>
          <para>FIXME: Specifies the label height (in what units?)</para>
        </listitem>
      </varlistentry>
    </variablelist>
  </refparameter>
  <refsee>
    <para><ulink
        url="http://www.sagehill.net/docbookxsl/RowHeight.html"
        >Row height</ulink> section in Bob Stayton’s book <ulink
        url="http://www.sagehill.net/docbookxsl/"
        >DocBook XSL: The Complete Guide</ulink></para>
  </refsee>
</doc:pi>
<xsl:template name="pi.dbhtml_row-height">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbhtml-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbhtml')"/>
    <xsl:with-param name="attribute" select="'row-height'"/>
  </xsl:call-template>
</xsl:template> 

<doc:pi name="dbhtml_table-summary" xmlns="">
  <refpurpose>Specifies the text of the summary attribute for
    output of a table, variablelist, segmentedlist, or
    qandaset</refpurpose>
  <refdescription>
    <para>Use the <tag>dbhtml table-summary</tag> PI as a child of
      a <tag>table</tag>, <tag>variablelist</tag>,
      <tag>segmentedlist</tag>, or <tag>qandaset</tag> to specify
      the text for the HTML <literal>summary</literal> attribute
      in the output HTML table.</para>
  </refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbhtml table-summary="<replaceable>text</replaceable>"</tag></synopsis>
  </refsynopsisdiv>
  <refparameter>
    <variablelist>
      <varlistentry><term>table-summary="<replaceable>text</replaceable>"</term>
        <listitem>
          <para>Specifies the summary text (zero or more characters)</para>
        </listitem>
      </varlistentry>
    </variablelist>
  </refparameter>
  <refsee>
    <itemizedlist>
      <listitem>
        <para><ulink
            url="http://www.sagehill.net/docbookxsl/Variablelists.html#VarListFormatting"
            >Variable list formatting in HTML</ulink> section in Bob
          Stayton’s book <ulink
            url="http://www.sagehill.net/docbookxsl/"
            >DocBook XSL: The Complete Guide</ulink></para>
      </listitem>
      <listitem>
        <para><ulink
            url="http://www.sagehill.net/docbookxsl/TableSummary.html"
            >Table summary text</ulink> section in Bob
          Stayton’s book <ulink
            url="http://www.sagehill.net/docbookxsl/"
            >DocBook XSL: The Complete Guide</ulink></para>
      </listitem>
    </itemizedlist>
  </refsee>
</doc:pi>
<xsl:template name="pi.dbhtml_table-summary">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbhtml-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbhtml')"/>
    <xsl:with-param name="attribute" select="'table-summary'"/>
  </xsl:call-template>
</xsl:template>

<doc:pi name="dbhtml_table-width" xmlns="">
  <refpurpose>Specifies the width for a table</refpurpose>
  <refdescription>
    <para>Use the <tag>dbhtml table-width</tag> PI as a child of a
      <tag>table</tag> to specify the width of the table in
      output.</para>
  </refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbhtml table-width="<replaceable>width</replaceable>"</tag></synopsis>
  </refsynopsisdiv>
  <refparameter>
    <variablelist>
      <varlistentry><term>table-width="<replaceable>width</replaceable>"</term>
        <listitem>
          <para>FIXME: Specifies the table width (in what units?)</para>
        </listitem>
      </varlistentry>
    </variablelist>
  </refparameter>
  <refsee>
    <para><ulink
        url="http://www.sagehill.net/docbookxsl/Tables.html#TableWidth"
        >Table width</ulink> section in Bob
      Stayton’s book <ulink
        url="http://www.sagehill.net/docbookxsl/" >DocBook XSL:
        The Complete Guide</ulink></para>
  </refsee>
</doc:pi>
<xsl:template name="pi.dbhtml_table-width">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbhtml-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbhtml')"/>
    <xsl:with-param name="attribute" select="'table-width'"/>
  </xsl:call-template>
</xsl:template>

<doc:pi name="dbhtml_term-presentation" xmlns="">
  <refpurpose>Sets character formatting for terms in a variablelist</refpurpose>
  <refdescription>
    <para>Use the <tag>dbhtml term-presentation</tag> PI as a child
      of a <tag>variablelist</tag> to set character formatting for
      the <tag>term</tag> output of the list.</para>
  </refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbhtml term-presentation="bold"|"italic"|"bold-italic"</tag></synopsis>
  </refsynopsisdiv>
  <refparameter>
    <variablelist>
      <varlistentry><term>term-presentation="<replaceable>bold</replaceable>"</term>
        <listitem>
          <para>Specifies that terms are displayed in bold</para>
        </listitem>
      </varlistentry>
      <varlistentry><term>term-presentation="<replaceable>italic</replaceable>"</term>
        <listitem>
          <para>Specifies that terms are displayed in italic</para>
        </listitem>
      </varlistentry>
      <varlistentry><term>term-presentation="<replaceable>bold-italic</replaceable>"</term>
        <listitem>
          <para>Specifies that terms are displayed in bold-italic</para>
        </listitem>
      </varlistentry>
    </variablelist>
  </refparameter>
  <refsee>
    <para><ulink
        url="http://www.sagehill.net/docbookxsl/Variablelists.html#VarListFormatting"
        >Variable list formatting in HTML</ulink> section in Bob
      Stayton’s book <ulink
        url="http://www.sagehill.net/docbookxsl/"
        >DocBook XSL: The Complete Guide</ulink></para>
  </refsee>
</doc:pi>
<xsl:template name="pi.dbhtml_term-presentation">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbhtml-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbhtml')"/>
    <xsl:with-param name="attribute" select="'term-presentation'"/>
  </xsl:call-template>
</xsl:template>

<doc:pi name="dbhtml_term-separator" xmlns="">
  <refpurpose>Specifies the separator text shown among term
    instances in a multi-term varlistentry</refpurpose>
  <refdescription>
    <para>Use the <tag>dbhtml term-separator</tag> PI as a child
      of a <tag>variablelist</tag> to specify the separator text
      among <tag>term</tag> instances.</para>
  </refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbhtml term-separator="<replaceable>text</replaceable>"</tag></synopsis>
  </refsynopsisdiv>
  <refparameter>
    <variablelist>
      <varlistentry><term>term-separator="<replaceable>text</replaceable>"</term>
        <listitem>
          <para>Specifies the text (zero or more characters)</para>
        </listitem>
      </varlistentry>
    </variablelist>
  </refparameter>
  <refsee role="params">
    <para><parameter>variablelist.term.separator</parameter></para>
  </refsee>
  <refsee>
    <para><ulink
        url="http://www.sagehill.net/docbookxsl/Variablelists.html#VarListFormatting"
        >Variable list formatting in HTML</ulink> section in Bob
      Stayton’s book <ulink
        url="http://www.sagehill.net/docbookxsl/"
        >DocBook XSL: The Complete Guide</ulink></para>
  </refsee>
</doc:pi>
<xsl:template name="pi.dbhtml_term-separator">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbhtml-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbhtml')"/>
    <xsl:with-param name="attribute" select="'term-separator'"/>
  </xsl:call-template>
</xsl:template>

<doc:pi name="dbhtml_term-width" xmlns="">
  <refpurpose>Specifies the term width for a variablelist</refpurpose>
  <refdescription>
    <para>Use the <tag>dbhtml term-width</tag> PI as a child of a
      <tag>variablelist</tag> to specify the width for
      <tag>term</tag> output.</para>
  </refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbhtml term-width="<replaceable>width</replaceable>"</tag></synopsis>
  </refsynopsisdiv>
  <refparameter>
    <variablelist>
      <varlistentry><term>term-width="<replaceable>width</replaceable>"</term>
        <listitem>
          <para>FIXME: Specifies the term width (in what units?)</para>
        </listitem>
      </varlistentry>
    </variablelist>
  </refparameter>
  <refsee>
    <para><ulink
        url="http://www.sagehill.net/docbookxsl/Variablelists.html#VarListFormatting"
        >Variable list formatting in HTML</ulink> section in Bob
      Stayton’s book <ulink
        url="http://www.sagehill.net/docbookxsl/"
        >DocBook XSL: The Complete Guide</ulink></para>
  </refsee>
</doc:pi>
<xsl:template name="pi.dbhtml_term-width">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbhtml-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbhtml')"/>
    <xsl:with-param name="attribute" select="'term-width'"/>
  </xsl:call-template>
</xsl:template>

<doc:pi name="dbhtml_toc" xmlns="">
  <refpurpose>Species whether a TOC should be generated for a qandaset</refpurpose>
  <refdescription>
    <para>Use the <tag>dbhtml toc</tag> PI as a child of a
      <tag>qandaset</tag> to specify whether a table of contents
      (TOC) is generated for the <tag>qandaset</tag>.</para>
  </refdescription>
  <refsynopsisdiv>
    <synopsis><tag class="xmlpi">dbhtml toc="0"|"1"</tag></synopsis>
  </refsynopsisdiv>
  <refparameter>
    <variablelist>
      <varlistentry><term>toc="0"</term>
        <listitem>
          <para>If zero, no TOC is generated</para>
        </listitem>
      </varlistentry>
      <varlistentry><term>toc="1"</term>
        <listitem>
          <para>If <code>1</code> (or any non-zero value),
            a TOC is generated</para>
        </listitem>
      </varlistentry>
    </variablelist>
  </refparameter>
  <refsee>
    <itemizedlist>
      <listitem>
        <para><ulink
            url="http://www.sagehill.net/docbookxsl/QandAtoc.html"
            >Q and A list of questions</ulink> section in Bob
          Stayton’s book <ulink
            url="http://www.sagehill.net/docbookxsl/"
            >DocBook XSL: The Complete Guide</ulink></para>
      </listitem>
      <listitem>
        <para><ulink
            url="http://www.sagehill.net/docbookxsl/QandAformat.html"
            >Q and A formatting</ulink> section in Bob Stayton’s
          book <ulink url="http://www.sagehill.net/docbookxsl/"
            >DocBook XSL: The Complete Guide</ulink></para>
      </listitem>
    </itemizedlist>
  </refsee>
</doc:pi>
<xsl:template name="pi.dbhtml_toc">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="dbhtml-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('dbhtml')"/>
    <xsl:with-param name="attribute" select="'toc'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="pi.dbfunclist">
  <xsl:variable name="funcsynopses" select="..//funcsynopsis"/>
  <xsl:if test="count($funcsynopses)&lt;1">
    <xsl:message><xsl:text>No funcsynopsis elements matched dbfunclist PI, perhaps it's nested too deep?</xsl:text>
    </xsl:message>
  </xsl:if>
  <dl>
    <xsl:call-template name="process.funcsynopsis.list">
      <xsl:with-param name="funcsynopses" select="$funcsynopses"/>
    </xsl:call-template>
  </dl>
</xsl:template>

<xsl:template name="pi.dbcmdlist">
  <xsl:variable name="cmdsynopses" select="..//cmdsynopsis"/>
  <xsl:if test="count($cmdsynopses)&lt;1">
    <xsl:message><xsl:text>No cmdsynopsis elements matched dbcmdlist PI, perhaps it's nested too deep?</xsl:text>
    </xsl:message>
  </xsl:if>
  <dl>
    <xsl:call-template name="process.cmdsynopsis.list">
      <xsl:with-param name="cmdsynopses" select="$cmdsynopses"/>
    </xsl:call-template>
  </dl>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="dbhtml-attribute">
  <!-- * dbhtml-attribute is an interal utility template for retrieving -->
  <!-- * pseudo-attributes/parameters from PIs -->
  <xsl:param name="pis" select="processing-instruction('dbhtml')"/>
  <xsl:param name="attribute">filename</xsl:param>
  <xsl:call-template name="pi-attribute">
    <xsl:with-param name="pis" select="$pis"/>
    <xsl:with-param name="attribute" select="$attribute"/>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="processing-instruction()">
</xsl:template>

<xsl:template match="processing-instruction('dbhtml')">
  <!-- nop -->
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="processing-instruction('dbcmdlist')">
  <xsl:call-template name="pi.dbcmdlist"/>
</xsl:template>
<xsl:template name="process.cmdsynopsis.list">
  <xsl:param name="cmdsynopses"/><!-- empty node list by default -->
  <xsl:param name="count" select="1"/>

  <xsl:choose>
    <xsl:when test="$count>count($cmdsynopses)"></xsl:when>
    <xsl:otherwise>
      <xsl:variable name="cmdsyn" select="$cmdsynopses[$count]"/>

       <dt>
       <a>
         <xsl:attribute name="href">
           <xsl:call-template name="object.id">
             <xsl:with-param name="object" select="$cmdsyn"/>
           </xsl:call-template>
         </xsl:attribute>

         <xsl:choose>
           <xsl:when test="$cmdsyn/@xreflabel">
             <xsl:call-template name="xref.xreflabel">
               <xsl:with-param name="target" select="$cmdsyn"/>
             </xsl:call-template>
           </xsl:when>
           <xsl:otherwise>
             <xsl:apply-templates select="$cmdsyn" mode="xref-to">
               <xsl:with-param name="target" select="$cmdsyn"/>
             </xsl:apply-templates>
           </xsl:otherwise>
         </xsl:choose>
       </a>
       </dt>

        <xsl:call-template name="process.cmdsynopsis.list">
          <xsl:with-param name="cmdsynopses" select="$cmdsynopses"/>
          <xsl:with-param name="count" select="$count+1"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="processing-instruction('dbfunclist')">
  <xsl:call-template name="pi.dbfunclist"/>
</xsl:template>
<xsl:template name="process.funcsynopsis.list">
  <xsl:param name="funcsynopses"/><!-- empty node list by default -->
  <xsl:param name="count" select="1"/>

  <xsl:choose>
    <xsl:when test="$count>count($funcsynopses)"></xsl:when>
    <xsl:otherwise>
      <xsl:variable name="cmdsyn" select="$funcsynopses[$count]"/>

       <dt>
       <a>
         <xsl:attribute name="href">
           <xsl:call-template name="object.id">
             <xsl:with-param name="object" select="$cmdsyn"/>
           </xsl:call-template>
         </xsl:attribute>

         <xsl:choose>
           <xsl:when test="$cmdsyn/@xreflabel">
             <xsl:call-template name="xref.xreflabel">
               <xsl:with-param name="target" select="$cmdsyn"/>
             </xsl:call-template>
           </xsl:when>
           <xsl:otherwise>
              <xsl:apply-templates select="$cmdsyn" mode="xref-to">
                <xsl:with-param name="target" select="$cmdsyn"/>
              </xsl:apply-templates>
           </xsl:otherwise>
         </xsl:choose>
       </a>
       </dt>

        <xsl:call-template name="process.funcsynopsis.list">
          <xsl:with-param name="funcsynopses" select="$funcsynopses"/>
          <xsl:with-param name="count" select="$count+1"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<!-- Copy well-formed external HTML content to the output. -->
<!-- An optional <html> wrapper will be removed before content is copied 
     to support multiple elements in output without a wrapper.
     No other processing is done to the content. -->
<xsl:template match="processing-instruction('dbhtml-include')">
  <xsl:param name="href">
    <xsl:call-template name="dbhtml-attribute">
      <xsl:with-param name="pis" select="."/>
      <xsl:with-param name="attribute">href</xsl:with-param>
    </xsl:call-template>
  </xsl:param>

  <xsl:choose>
    <xsl:when test="$href != ''">
      <xsl:variable name="content" select="document($href,/)"/>
      <xsl:choose>
        <xsl:when test="$content/*">
          <xsl:choose>
            <xsl:when test="$content/*[1][self::html]">
              <!-- include just the children of html wrapper -->
              <xsl:copy-of select="$content/*[1]/node()"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:copy-of select="$content"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>
            <xsl:text>ERROR: dbhtml-include processing instruction </xsl:text>
            <xsl:text>href has no content.</xsl:text>
          </xsl:message>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>ERROR: dbhtml-include processing instruction has </xsl:text>
        <xsl:text>missing or empty href value.</xsl:text>
      </xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
