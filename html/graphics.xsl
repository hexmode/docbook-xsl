<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:stext="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.TextFactory"
                xmlns:simg="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.ImageIntrinsics"
                xmlns:ximg="xaln://com.nwalsh.xalan.ImageIntrinsics"
                xmlns:xtext="com.nwalsh.xalan.Text"
                xmlns:lxslt="http://xml.apache.org/xslt"
                exclude-result-prefixes="xlink stext xtext lxslt simg ximg"
                extension-element-prefixes="stext xtext"
                version='1.0'>

<!-- ********************************************************************
     $Id$
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://nwalsh.com/docbook/xsl/ for copyright
     and other information.

     Contributors:
     Colin Paul Adams, <colin@colina.demon.co.uk>

     ******************************************************************** -->

<lxslt:component prefix="xtext" elements="insertfile"/>
<lxslt:component prefix="ximg" functions="new getWidth getDepth"/>

<!-- ==================================================================== -->
<!-- Graphic format tests for the HTML backend -->

<xsl:template name="is.graphic.format">
  <xsl:param name="format"></xsl:param>
  <xsl:if test="$format = 'SVG'
                or $format = 'PNG'
                or $format = 'JPG'
                or $format = 'JPEG'
                or $format = 'linespecific'
                or $format = 'GIF'
                or $format = 'GIF87a'
                or $format = 'GIF89a'
                or $format = 'BMP'">1</xsl:if>
</xsl:template>

<xsl:template name="is.graphic.extension">
  <xsl:param name="ext"></xsl:param>
  <xsl:variable name="lcext" select="translate($ext,
                                       'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
                                       'abcdefghijklmnopqrstuvwxyz')"/>
  <xsl:if test="$lcext = 'svg'
             or $lcext = 'png'
             or $lcext = 'jpeg'
             or $lcext = 'jpg'
             or $lcext = 'avi'
             or $lcext = 'mpg'
             or $lcext = 'mpeg'
             or $lcext = 'qt'
             or $lcext = 'gif'
             or $lcext = 'bmp'">1</xsl:if>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="screenshot">
  <div class="{name(.)}">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="screeninfo">
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="process.image">
  <!-- When this template is called, the current node should be  -->
  <!-- a graphic, inlinegraphic, imagedata, or videodata. All    -->
  <!-- those elements have the same set of attributes, so we can -->
  <!-- handle them all in one place.                             -->
  <xsl:param name="tag" select="'img'"/>
  <xsl:param name="alt"/>
  <xsl:param name="longdesc"/>

  <!-- The HTML img element only supports the notion of content-area
       scaling; it doesn't support the distinction between a
       content-area and a viewport-area, so we have to make some
       compromises.

       1. If only the content-area is specified, everything is fine.
          (If you ask for a three inch image, that's what you'll get.)

       2. If only the viewport-area is provided:
          - If scalefit=1, treat it as both the content-area and
            the viewport-area. (If you ask for an image in a five inch
            area, we'll make the image five inches to fill that area.)
          - If scalefit=0, ignore the viewport-area specification.

          Note: this is not quite the right semantic and has the additional
          problem that it can result in anamorphic scaling, which scalefit
          should never cause.

       3. If both the content-area and the viewport-area is specified
          on a graphic element, ignore the viewport-area.
          (If you ask for a three inch image in a five inch area, we'll assume
           it's better to give you a three inch image in an unspecified area
           than a five inch image in a five inch area.

       Relative units also cause problems. As a general rule, the stylesheets
       are operating too early and too loosely coupled with the rendering engine
       to know things like the current font size or the actual dimensions of
       an image. Therefore:

       1. We use a fixed size for pixels, $pixels.per.inch

       2. We use a fixed size for "em"s, $points.per.em

       Percentages are problematic. In the following discussion, we speak
       of width and contentwidth, but the same issues apply to depth and
       contentdepth

       1. A width of 50% means "half of the available space for the image."
          That's fine. But note that in HTML, this is a dynamic property and
          the image size will vary if the browser window is resized.

       2. A contentwidth of 50% means "half of the actual image width". But
          the stylesheets have no way to assess the image's actual size. Treating
          this as a width of 50% is one possibility, but it produces behavior
          (dynamic scaling) that seems entirely out of character with the
          meaning.

          Instead, the stylesheets define a $nominal.image.width
          and convert percentages to actual values based on that nominal size.

       Scale can be problematic. Scale applies to the contentwidth, so
       a scale of 50 when a contentwidth is not specified is analagous to a
       width of 50%. (If a contentwidth is specified, the scaling factor can
       be applied to that value and no problem exists.)

       If scale is specified but contentwidth is not supplied, the
       nominal.image.width is used to calculate a base size
       for scaling.

       Warning: as a consequence of these decisions, unless the aspect ratio
       of your image happens to be exactly the same as (nominal width / nominal height),
       specifying contentwidth="50%" and contentdepth="50%" is NOT going to
       scale the way you expect (or really, the way it should).

       Don't do that. In fact, a percentage value is not recommended for content
       size at all. Use scale instead.

       Finally, align and valign are troublesome. Horizontal alignment is now
       supported by wrapping the image in a <div align="{@align}"> (in block
       contexts!). I can't think of anything (practical) to do about vertical
       alignment.
  -->

  <xsl:variable name="width-units">
    <xsl:choose>
      <xsl:when test="$ignore.image.scaling != 0"></xsl:when>
      <xsl:when test="@width">
        <xsl:call-template name="length-units">
          <xsl:with-param name="length" select="@width"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="not(@depth) and $default.image.width != ''">
        <xsl:call-template name="length-units">
          <xsl:with-param name="length" select="$default.image.width"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="width">
    <xsl:choose>
      <xsl:when test="$ignore.image.scaling != 0"></xsl:when>
      <xsl:when test="@width">
        <xsl:choose>
          <xsl:when test="$width-units = '%'">
            <xsl:value-of select="@width"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="length-spec">
              <xsl:with-param name="length" select="@width"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="not(@depth) and $default.image.width != ''">
        <xsl:value-of select="$default.image.width"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="scalefit">
    <xsl:choose>
      <xsl:when test="$ignore.image.scaling != 0">0</xsl:when>
      <xsl:when test="@contentwidth or @contentdepth">0</xsl:when>
      <xsl:when test="@scale">0</xsl:when>
      <xsl:when test="@scalefit"><xsl:value-of select="@scalefit"/></xsl:when>
      <xsl:when test="$width != '' or @depth">1</xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="scale">
    <xsl:choose>
      <xsl:when test="$ignore.image.scaling != 0">1.0</xsl:when>
      <xsl:when test="@contentwidth or @contentdepth">1.0</xsl:when>
      <xsl:when test="@scale">
        <xsl:value-of select="@scale div 100.0"/>
      </xsl:when>
      <xsl:otherwise>1.0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="filename">
    <xsl:choose>
      <xsl:when test="local-name(.) = 'graphic'
                      or local-name(.) = 'inlinegraphic'">
        <!-- handle legacy graphic and inlinegraphic by new template --> 
        <xsl:call-template name="mediaobject.filename">
          <xsl:with-param name="object" select="."/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <!-- imagedata, videodata, audiodata -->
        <xsl:call-template name="mediaobject.filename">
          <xsl:with-param name="object" select=".."/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="filename.with.img.src.path">
    <xsl:choose>
      <xsl:when test="$img.src.path != '' and
                      $tag = 'img' and
                      not(starts-with($filename, '/')) and
                      not(contains($filename, '://'))">
        <xsl:value-of select="concat($img.src.path, $filename)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$filename"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="intrinsicwidth">
    <!-- This funny compound test works around a bug in XSLTC -->
    <xsl:choose>
      <xsl:when test="$use.extensions != 0 and $graphicsize.extension != 0">
        <xsl:choose>
          <xsl:when test="function-available('simg:getWidth')">
            <xsl:value-of select="simg:getWidth(simg:new($filename.with.img.src.path),
                                                $nominal.image.width)"/>
          </xsl:when>
          <xsl:when test="function-available('ximg:getWidth')">
            <xsl:value-of select="ximg:getWidth(ximg:new($filename.with.img.src.path),
                                                $nominal.image.width)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$nominal.image.width"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$nominal.image.width"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="intrinsicdepth">
    <!-- This funny compound test works around a bug in XSLTC -->
    <xsl:choose>
      <xsl:when test="$use.extensions != 0 and $graphicsize.extension != 0">
        <xsl:choose>
          <xsl:when test="function-available('simg:getDepth')">
            <xsl:value-of select="simg:getDepth(simg:new($filename.with.img.src.path),
                                                $nominal.image.depth)"/>
          </xsl:when>
          <xsl:when test="function-available('ximg:getDepth')">
            <xsl:value-of select="ximg:getDepth(ximg:new($filename.with.img.src.path),
                                                $nominal.image.depth)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$nominal.image.depth"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$nominal.image.depth"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="contentwidth">
    <xsl:choose>
      <xsl:when test="$ignore.image.scaling != 0"></xsl:when>
      <xsl:when test="@contentwidth">
        <xsl:variable name="units">
          <xsl:call-template name="length-units">
            <xsl:with-param name="length" select="@contentwidth"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:choose>
          <xsl:when test="$units = '%'">
            <xsl:variable name="cmagnitude">
              <xsl:call-template name="length-magnitude">
                <xsl:with-param name="length" select="@contentwidth"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="$intrinsicwidth * $cmagnitude div 100.0"/>
            <xsl:text>px</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="length-spec">
              <xsl:with-param name="length" select="@contentwidth"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$intrinsicwidth"/>
        <xsl:text>px</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="scaled.contentwidth">
    <xsl:if test="$contentwidth != ''">
      <xsl:variable name="cwidth.in.points">
        <xsl:call-template name="length-in-points">
          <xsl:with-param name="length" select="$contentwidth"/>
          <xsl:with-param name="pixels.per.inch" select="$pixels.per.inch"/>
          <xsl:with-param name="em.size" select="$points.per.em"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:value-of select="$cwidth.in.points div 72.0 * $pixels.per.inch * $scale"/>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="html.width">
    <xsl:choose>
      <xsl:when test="$ignore.image.scaling != 0"></xsl:when>
      <xsl:when test="$width-units = '%'">
        <xsl:value-of select="$width"/>
      </xsl:when>
      <xsl:when test="$width != ''">
        <xsl:variable name="width.in.points">
          <xsl:call-template name="length-in-points">
            <xsl:with-param name="length" select="$width"/>
            <xsl:with-param name="pixels.per.inch" select="$pixels.per.inch"/>
            <xsl:with-param name="em.size" select="$points.per.em"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="round($width.in.points div 72.0 * $pixels.per.inch)"/>
      </xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="contentdepth">
    <xsl:choose>
      <xsl:when test="$ignore.image.scaling != 0"></xsl:when>
      <xsl:when test="@contentdepth">
        <xsl:variable name="units">
          <xsl:call-template name="length-units">
            <xsl:with-param name="length" select="@contentdepth"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:choose>
          <xsl:when test="$units = '%'">
            <xsl:variable name="cmagnitude">
              <xsl:call-template name="length-magnitude">
                <xsl:with-param name="length" select="@contentdepth"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="$intrinsicdepth * $cmagnitude div 100.0"/>
            <xsl:text>px</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="length-spec">
              <xsl:with-param name="length" select="@contentdepth"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$intrinsicdepth"/>
        <xsl:text>px</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="scaled.contentdepth">
    <xsl:if test="$contentdepth != ''">
      <xsl:variable name="cdepth.in.points">
        <xsl:call-template name="length-in-points">
          <xsl:with-param name="length" select="$contentdepth"/>
          <xsl:with-param name="pixels.per.inch" select="$pixels.per.inch"/>
          <xsl:with-param name="em.size" select="$points.per.em"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:value-of select="$cdepth.in.points div 72.0 * $pixels.per.inch * $scale"/>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="depth-units">
    <xsl:if test="@depth">
      <xsl:call-template name="length-units">
        <xsl:with-param name="length" select="@depth"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="depth">
    <xsl:if test="@depth">
      <xsl:choose>
        <xsl:when test="$depth-units = '%'">
          <xsl:value-of select="@depth"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="length-spec">
            <xsl:with-param name="length" select="@depth"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="html.depth">
    <xsl:choose>
      <xsl:when test="$ignore.image.scaling != 0"></xsl:when>
      <xsl:when test="$depth-units = '%'">
        <xsl:value-of select="$depth"/>
      </xsl:when>
      <xsl:when test="@depth and @depth != ''">
        <xsl:variable name="depth.in.points">
          <xsl:call-template name="length-in-points">
            <xsl:with-param name="length" select="$depth"/>
            <xsl:with-param name="pixels.per.inch" select="$pixels.per.inch"/>
            <xsl:with-param name="em.size" select="$points.per.em"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="round($depth.in.points div 72.0 * $pixels.per.inch)"/>
      </xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="viewport">
    <xsl:choose>
      <xsl:when test="$ignore.image.scaling != 0">0</xsl:when>
      <xsl:when test="local-name(.) = 'inlinegraphic'
                      or ancestor::inlinemediaobject
                      or ancestor::inlineequation">0</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$make.graphic.viewport"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

<!--
  <xsl:message>=====================================
scale: <xsl:value-of select="$scale"/>, <xsl:value-of select="$scalefit"/>
@contentwidth <xsl:value-of select="@contentwidth"/>
$contentwidth <xsl:value-of select="$contentwidth"/>
scaled.contentwidth: <xsl:value-of select="$scaled.contentwidth"/>
@width: <xsl:value-of select="@width"/>
width: <xsl:value-of select="$width"/>
html.width: <xsl:value-of select="$html.width"/>
@contentdepth <xsl:value-of select="@contentdepth"/>
$contentdepth <xsl:value-of select="$contentdepth"/>
scaled.contentdepth: <xsl:value-of select="$scaled.contentdepth"/>
@depth: <xsl:value-of select="@depth"/>
depth: <xsl:value-of select="$depth"/>
html.depth: <xsl:value-of select="$html.depth"/>
align: <xsl:value-of select="@align"/>
valign: <xsl:value-of select="@valign"/></xsl:message>
-->

  <xsl:variable name="img">
    <xsl:choose>
      <xsl:when test="@format = 'SVG'">
        <object data="{$filename}" type="image/svg+xml">
          <xsl:call-template name="process.image.attributes">
            <!--xsl:with-param name="alt" select="$alt"/ there's no alt here-->
            <xsl:with-param name="html.depth" select="$html.depth"/>
            <xsl:with-param name="html.width" select="$html.width"/>
            <xsl:with-param name="longdesc" select="$longdesc"/>
            <xsl:with-param name="scale" select="$scale"/>
            <xsl:with-param name="scalefit" select="$scalefit"/>
            <xsl:with-param name="scaled.contentdepth" select="$scaled.contentdepth"/>
            <xsl:with-param name="scaled.contentwidth" select="$scaled.contentwidth"/>
            <xsl:with-param name="viewport" select="$viewport"/>
          </xsl:call-template>
          <xsl:if test="@align">
            <xsl:attribute name="align">
                <xsl:choose>
                  <xsl:when test="@align = 'center'">middle</xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="@align"/>
                  </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="$use.embed.for.svg != 0">
            <embed src="{$filename}" type="image/svg+xml">
              <xsl:call-template name="process.image.attributes">
                <!--xsl:with-param name="alt" select="$alt"/ there's no alt here -->
                <xsl:with-param name="html.depth" select="$html.depth"/>
                <xsl:with-param name="html.width" select="$html.width"/>
                <xsl:with-param name="longdesc" select="$longdesc"/>
                <xsl:with-param name="scale" select="$scale"/>
                <xsl:with-param name="scalefit" select="$scalefit"/>
                <xsl:with-param name="scaled.contentdepth" select="$scaled.contentdepth"/>
                <xsl:with-param name="scaled.contentwidth" select="$scaled.contentwidth"/>
                <xsl:with-param name="viewport" select="$viewport"/>
              </xsl:call-template>
            </embed>
          </xsl:if>
        </object>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="{$tag}">
          <xsl:attribute name="src">
	    <xsl:choose>
	      <xsl:when test="$img.src.path != '' and
			      $tag = 'img' and
	                      not(starts-with($filename, '/')) and
			      not(contains($filename, '://'))">
	        <xsl:value-of select="$img.src.path"/>
	      </xsl:when>
	    </xsl:choose>
            <xsl:value-of select="$filename"/>
          </xsl:attribute>

          <xsl:if test="@align">
            <xsl:attribute name="align">
              <xsl:choose>
                <xsl:when test="@align = 'center'">middle</xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="@align"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
          </xsl:if>

          <xsl:call-template name="process.image.attributes">
            <xsl:with-param name="alt">
              <xsl:choose>
                <xsl:when test="$alt != ''">
                  <xsl:copy-of select="$alt"/>
                </xsl:when>
                <xsl:when test="ancestor::figure">
                  <xsl:value-of select="normalize-space(ancestor::figure/title)"/>
                </xsl:when>
              </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="html.depth" select="$html.depth"/>
            <xsl:with-param name="html.width" select="$html.width"/>
            <xsl:with-param name="longdesc" select="$longdesc"/>
            <xsl:with-param name="scale" select="$scale"/>
            <xsl:with-param name="scalefit" select="$scalefit"/>
            <xsl:with-param name="scaled.contentdepth" select="$scaled.contentdepth"/>
            <xsl:with-param name="scaled.contentwidth" select="$scaled.contentwidth"/>
            <xsl:with-param name="viewport" select="$viewport"/>
          </xsl:call-template>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>


  <xsl:variable name="bgcolor">
    <xsl:call-template name="dbhtml-attribute">
      <xsl:with-param name="pis"
                      select="../processing-instruction('dbhtml')"/>
      <xsl:with-param name="attribute" select="'background-color'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="use.viewport"
                select="$viewport != 0
                        and ($html.width != ''
                             or ($html.depth != '' and $depth-units != '%')
                             or $bgcolor != ''
                             or @valign)"/>

  <xsl:choose>
    <xsl:when test="$use.viewport">
      <table border="0" summary="manufactured viewport for HTML img"
             cellspacing="0" cellpadding="0">
        <xsl:if test="$html.width != ''">
          <xsl:attribute name="width">
            <xsl:value-of select="$html.width"/>
          </xsl:attribute>
        </xsl:if>
        <tr>
          <xsl:if test="$html.depth != '' and $depth-units != '%'">
            <!-- don't do this for percentages because browsers get confused -->
            <xsl:choose>
              <xsl:when test="$css.decoration != 0">
                <xsl:attribute name="style">
                  <xsl:text>height: </xsl:text>
                  <xsl:value-of select="$html.depth"/>
                  <xsl:text>px</xsl:text>
                </xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="height">
                  <xsl:value-of select="$html.depth"/>
                </xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
          <td>
            <xsl:if test="$bgcolor != ''">
              <xsl:choose>
                <xsl:when test="$css.decoration != 0">
                  <xsl:attribute name="style">
                    <xsl:text>background-color: </xsl:text>
                    <xsl:value-of select="$bgcolor"/>
                  </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="bgcolor">
                    <xsl:value-of select="$bgcolor"/>
                  </xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:if>
            <xsl:if test="@align">
              <xsl:attribute name="align">
                <xsl:value-of select="@align"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:if test="@valign">
              <xsl:attribute name="valign">
                <xsl:value-of select="@valign"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:copy-of select="$img"/>
          </td>
        </tr>
      </table>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$img"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="process.image.attributes">
  <xsl:param name="alt"/>
  <xsl:param name="html.width"/>
  <xsl:param name="html.depth"/>
  <xsl:param name="longdesc"/>
  <xsl:param name="scale"/>
  <xsl:param name="scalefit"/>
  <xsl:param name="scaled.contentdepth"/>
  <xsl:param name="scaled.contentwidth"/>
  <xsl:param name="viewport"/>

  <xsl:choose>
    <xsl:when test="@contentwidth or @contentdepth">
      <!-- ignore @width/@depth, @scale, and @scalefit if specified -->
      <xsl:if test="@contentwidth">
        <xsl:attribute name="width">
          <xsl:value-of select="$scaled.contentwidth"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@contentdepth">
        <xsl:attribute name="height">
          <xsl:value-of select="$scaled.contentdepth"/>
        </xsl:attribute>
      </xsl:if>
    </xsl:when>

    <xsl:when test="number($scale) != 1.0">
      <!-- scaling is always uniform, so we only have to specify one dimension -->
      <!-- ignore @scalefit if specified -->
      <xsl:attribute name="width">
        <xsl:value-of select="$scaled.contentwidth"/>
      </xsl:attribute>
    </xsl:when>

    <xsl:when test="$scalefit != 0">
      <xsl:choose>
        <xsl:when test="contains($html.width, '%')">
          <xsl:choose>
            <xsl:when test="$viewport != 0">
              <!-- The *viewport* will be scaled, so use 100% here! -->
              <xsl:attribute name="width">
                <xsl:value-of select="'100%'"/>
              </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="width">
                <xsl:value-of select="$html.width"/>
              </xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>

        <xsl:when test="contains($html.depth, '%')">
          <!-- HTML doesn't deal with this case very well...do nothing -->
        </xsl:when>

        <xsl:when test="$scaled.contentwidth != '' and $html.width != ''
                        and $scaled.contentdepth != '' and $html.depth != ''">
          <!-- scalefit should not be anamorphic; figure out which direction -->
          <!-- has the limiting scale factor and scale in that direction -->
          <xsl:choose>
            <xsl:when test="$html.width div $scaled.contentwidth &gt;
                            $html.depth div $scaled.contentdepth">
              <xsl:attribute name="height">
                <xsl:value-of select="$html.depth"/>
              </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="width">
                <xsl:value-of select="$html.width"/>
              </xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>

        <xsl:when test="$scaled.contentwidth != '' and $html.width != ''">
          <xsl:attribute name="width">
            <xsl:value-of select="$html.width"/>
          </xsl:attribute>
        </xsl:when>

        <xsl:when test="$scaled.contentdepth != '' and $html.depth != ''">
          <xsl:attribute name="height">
            <xsl:value-of select="$html.depth"/>
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>
    </xsl:when>
  </xsl:choose>

  <xsl:if test="$alt != ''">
    <xsl:attribute name="alt">
      <xsl:value-of select="$alt"/>
    </xsl:attribute>
  </xsl:if>

  <xsl:if test="$longdesc != ''">
    <xsl:attribute name="longdesc">
      <xsl:value-of select="$longdesc"/>
    </xsl:attribute>
  </xsl:if>

  <xsl:if test="@align and $viewport = 0">
    <xsl:attribute name="align">
      <xsl:choose>
        <xsl:when test="@align = 'center'">middle</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@align"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:if>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="graphic">
  <xsl:choose>
    <xsl:when test="parent::inlineequation">
      <xsl:call-template name="anchor"/>
      <xsl:call-template name="process.image"/>
    </xsl:when>
    <xsl:otherwise>
      <div>
        <xsl:if test="@align">
          <xsl:attribute name="align">
            <xsl:value-of select="@align"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:call-template name="anchor"/>
        <xsl:call-template name="process.image"/>
      </div>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="inlinegraphic">
  <xsl:variable name="filename">
    <xsl:choose>
      <xsl:when test="@entityref">
        <xsl:value-of select="unparsed-entity-uri(@entityref)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="@fileref"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:if test="@id">
    <a name="{@id}"/>
  </xsl:if>

  <xsl:choose>
    <xsl:when test="@format='linespecific'">
      <xsl:choose>
        <xsl:when test="$use.extensions != '0'
                        and $textinsert.extension != '0'">
          <xsl:choose>
            <xsl:when test="element-available('stext:insertfile')">
              <stext:insertfile href="{$filename}" encoding="{$textdata.default.encoding}"/>
            </xsl:when>
            <xsl:when test="element-available('xtext:insertfile')">
              <xtext:insertfile href="{$filename}"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:message terminate="yes">
                <xsl:text>No insertfile extension available.</xsl:text>
              </xsl:message>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <a xlink:type="simple" xlink:show="embed" xlink:actuate="onLoad"
             href="{$filename}"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="process.image"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="mediaobject|mediaobjectco">

  <xsl:variable name="olist" select="imageobject|imageobjectco
                     |videoobject|audioobject
                     |textobject"/>

  <xsl:variable name="object.index">
    <xsl:call-template name="select.mediaobject.index">
      <xsl:with-param name="olist" select="$olist"/>
      <xsl:with-param name="count" select="1"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="object" select="$olist[position() = $object.index]"/>

  <xsl:variable name="align">
    <xsl:value-of select="$object/imagedata[@align][1]/@align"/>
  </xsl:variable>

  <div class="{name(.)}">
    <xsl:if test="$align != '' ">
      <xsl:attribute name="align">
        <xsl:value-of select="$align"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@id">
      <a name="{@id}"/>
    </xsl:if>

    <xsl:apply-templates select="$object"/>
    <xsl:apply-templates select="caption"/>
  </div>
</xsl:template>

<xsl:template match="inlinemediaobject">
  <span class="{name(.)}">
    <xsl:if test="@id">
      <a name="{@id}"/>
    </xsl:if>
    <xsl:call-template name="select.mediaobject"/>
  </span>
</xsl:template>

<xsl:template match="programlisting/inlinemediaobject
                     |screen/inlinemediaobject" priority="2">
  <!-- the additional span causes problems in some cases -->
  <xsl:call-template name="select.mediaobject"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="imageobjectco">
  <xsl:if test="@id">
    <a name="{@id}"/>
  </xsl:if>
  <xsl:apply-templates select="imageobject"/>
  <xsl:apply-templates select="calloutlist"/>
</xsl:template>

<xsl:template match="imageobject">
  <xsl:choose>
    <xsl:when xmlns:svg="http://www.w3.org/2000/svg"
              test="svg:*">
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="imagedata"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="imagedata">
  <xsl:variable name="filename">
    <xsl:call-template name="mediaobject.filename">
      <xsl:with-param name="object" select=".."/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="@format='linespecific'">
      <xsl:choose>
        <xsl:when test="$use.extensions != '0'
                        and $textinsert.extension != '0'">
          <xsl:choose>
            <xsl:when test="element-available('stext:insertfile')">
              <stext:insertfile href="{$filename}" encoding="{$textdata.default.encoding}"/>
            </xsl:when>
            <xsl:when test="element-available('xtext:insertfile')">
              <xtext:insertfile href="{$filename}"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:message terminate="yes">
                <xsl:text>No insertfile extension available.</xsl:text>
              </xsl:message>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <a xlink:type="simple" xlink:show="embed" xlink:actuate="onLoad"
             href="{$filename}"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="longdesc.uri">
        <xsl:call-template name="longdesc.uri">
          <xsl:with-param name="mediaobject"
                          select="ancestor::imageobject/parent::*"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:variable name="phrases"
                    select="ancestor::mediaobject/textobject[phrase]
                            |ancestor::inlinemediaobject/textobject[phrase]
                            |ancestor::mediaobjectco/textobject[phrase]"/>

      <xsl:call-template name="process.image">
        <xsl:with-param name="alt">
          <xsl:apply-templates select="$phrases[not(@role) or @role!='tex'][1]"/>
        </xsl:with-param>
        <xsl:with-param name="longdesc">
          <xsl:call-template name="write.longdesc">
            <xsl:with-param name="mediaobject"
                            select="ancestor::imageobject/parent::*"/>
          </xsl:call-template>
        </xsl:with-param>
      </xsl:call-template>

      <xsl:if test="$html.longdesc != 0 and $html.longdesc.link != 0
                    and ancestor::imageobject/parent::*/textobject[not(phrase)]">
        <xsl:call-template name="longdesc.link">
          <xsl:with-param name="longdesc.uri" select="$longdesc.uri"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="longdesc.uri">
  <xsl:param name="mediaobject" select="."/>

  <xsl:if test="$html.longdesc">
    <xsl:if test="$mediaobject/textobject[not(phrase)]">
      <xsl:variable name="image-id">
        <xsl:call-template name="object.id">
          <xsl:with-param name="object" select="$mediaobject"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="dbhtml.dir">
        <xsl:call-template name="dbhtml-dir"/>
      </xsl:variable>
      <xsl:variable name="filename">
        <xsl:call-template name="make-relative-filename">
          <xsl:with-param name="base.dir">
            <xsl:choose>
              <xsl:when test="$dbhtml.dir != ''">
                <xsl:value-of select="$dbhtml.dir"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$base.dir"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="base.name"
                          select="concat('ld-',$image-id,$html.ext)"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:value-of select="$filename"/>
    </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template name="write.longdesc">
  <xsl:param name="mediaobject" select="."/>
  <xsl:if test="$html.longdesc != 0 and $mediaobject/textobject[not(phrase)]">
    <xsl:variable name="filename">
      <xsl:call-template name="longdesc.uri">
        <xsl:with-param name="mediaobject" select="$mediaobject"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:value-of select="$filename"/>

    <xsl:call-template name="write.chunk">
      <xsl:with-param name="filename" select="$filename"/>
      <xsl:with-param name="quiet" select="$chunk.quietly"/>
      <xsl:with-param name="content">
      <xsl:call-template name="user.preroot"/>
        <html>
          <head>
            <xsl:call-template name="system.head.content"/>
            <xsl:call-template name="head.content">
              <xsl:with-param name="title" select="'Long Description'"/>
            </xsl:call-template>
            <xsl:call-template name="user.head.content"/>
          </head>
          <body>
            <xsl:call-template name="body.attributes"/>
            <xsl:for-each select="$mediaobject/textobject[not(phrase)]">
              <xsl:apply-templates select="./*"/>
            </xsl:for-each>
          </body>
        </html>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="longdesc.link">
  <xsl:param name="longdesc.uri" select="''"/>

  <xsl:variable name="this.uri">
    <xsl:call-template name="make-relative-filename">
      <xsl:with-param name="base.dir" select="$base.dir"/>
      <xsl:with-param name="base.name">
        <xsl:call-template name="href.target.uri"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="href.to">
    <xsl:call-template name="trim.common.uri.paths">
      <xsl:with-param name="uriA" select="$longdesc.uri"/>
      <xsl:with-param name="uriB" select="$this.uri"/>
      <xsl:with-param name="return" select="'A'"/>
    </xsl:call-template>
  </xsl:variable>

  <div class="longdesc-link" align="right">
    <br clear="all"/>
    <span class="longdesc-link">
      <xsl:text>[</xsl:text>
      <a href="{$href.to}" target="longdesc">D</a>
      <xsl:text>]</xsl:text>
    </span>
  </div>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="videoobject">
  <xsl:apply-templates select="videodata"/>
</xsl:template>

<xsl:template match="videodata">
  <xsl:call-template name="process.image">
    <xsl:with-param name="tag" select="'embed'"/>
    <xsl:with-param name="alt">
      <xsl:apply-templates select="(../../textobject/phrase)[1]"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="audioobject">
  <xsl:apply-templates select="audiodata"/>
</xsl:template>

<xsl:template match="audiodata">
  <xsl:call-template name="process.image">
    <xsl:with-param name="tag" select="'embed'"/>
    <xsl:with-param name="alt">
      <xsl:apply-templates select="(../../textobject/phrase)[1]"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="textobject">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="textdata">
  <xsl:variable name="filename">
    <xsl:choose>
      <xsl:when test="@entityref">
        <xsl:value-of select="unparsed-entity-uri(@entityref)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="@fileref"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="encoding">
    <xsl:choose>
      <xsl:when test="@encoding">
        <xsl:value-of select="@encoding"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$textdata.default.encoding"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$use.extensions != '0'
                    and $textinsert.extension != '0'">
      <xsl:choose>
        <xsl:when test="element-available('stext:insertfile')">
          <stext:insertfile href="{$filename}" encoding="{$encoding}"/>
        </xsl:when>
        <xsl:when test="element-available('xtext:insertfile')">
          <xtext:insertfile href="{$filename}"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message terminate="yes">
            <xsl:text>No insertfile extension available.</xsl:text>
          </xsl:message>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <a xlink:type="simple" xlink:show="embed" xlink:actuate="onLoad"
         href="{$filename}"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="caption">
  <div class="{name(.)}">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<!-- ==================================================================== -->
<!-- "Support" for SVG -->

<xsl:template match="svg:*" xmlns:svg="http://www.w3.org/2000/svg">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<!-- Resolve xml:base attributes -->
<xsl:template match="@fileref">
  <!-- need a check for absolute urls -->
  <xsl:choose>
    <xsl:when test="contains(., ':')">
      <!-- it has a uri scheme so it is an absolute uri -->
      <xsl:value-of select="."/>
    </xsl:when>
    <xsl:otherwise>
      <!-- its a relative uri -->
      <xsl:call-template name="relative-uri">
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
