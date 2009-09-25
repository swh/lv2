<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" indent="no"/>
<xsl:template match="/">@prefix : &lt;http://lv2plug.in/ns/lv2core#&gt; .
@prefix swh: &lt;http://plugin.org.uk/swh-plugins/&gt; .
@prefix foaf: &lt;http://xmlns.com/foaf/0.1/&gt; .
@prefix doap: &lt;http://usefulinc.com/ns/doap#&gt; .
@prefix swhext: &lt;http://plugin.org.uk/extensions#&gt; .
@prefix pg: &lt;http://lv2plug.in/ns/dev/port-groups#&gt; .
@prefix epp: &lt;http://lv2plug.in/ns/dev/extportinfo#&gt; .
<xsl:for-each select="ladspa/plugin">
  <xsl:variable name="pluglabel" select="@label"/>
  <xsl:for-each select="group">
    <xsl:variable name="grouplabel" select="@label"/>
    <xsl:variable name="groupuri">
      <xsl:value-of select="$pluglabel"/>-<xsl:value-of select="$grouplabel"/>
    </xsl:variable>
swh:<xsl:value-of select="$groupuri"/> a pg:Group ;
   a pg:<xsl:value-of select="@type"/> ;
   :symbol "<xsl:value-of select="$grouplabel"/>"<xsl:if test="@source"> ;
   pg:source swh:<xsl:value-of select="$pluglabel"/>-<xsl:value-of select="@source"/></xsl:if> .
  </xsl:for-each>
swh:<xsl:value-of select="$pluglabel"/> a :Plugin ;
<xsl:call-template name="csl2type">
     <xsl:with-param name="in" select="@class"/>
   </xsl:call-template>
   doap:name "<xsl:value-of select="name"/>" ;
   doap:maintainer [
      foaf:name "Steve Harris";
      foaf:homepage &lt;http://plugin.org.uk/&gt; ;
      foaf:mbox &lt;mailto:steve@plugin.org.uk&gt; ;
   ] ;
   doap:license &lt;http://usefulinc.com/doap/licenses/gpl&gt; ;
   :documentation &lt;http://plugin.org.uk/ladspa-swh/docs/ladspa-swh.html#<xsl:value-of select="@label"/>&gt; ;
<!--   <xsl:if test="p">swhext:documentation """<xsl:value-of select="p"/>""" ;
  </xsl:if>-->
  <xsl:for-each select="/ladspa/global/meta">
      <xsl:if test="@name = 'properties' and @value = 'HARD_RT_CAPABLE'">
   :pluginProperty :hardRtCapable ;
    </xsl:if>
  </xsl:for-each>
  <xsl:for-each select="port">
   :port [
     a :<xsl:if test="@dir = 'input'">InputPort</xsl:if><xsl:if test="@dir = 'output'">OutputPort</xsl:if>, :<xsl:if test="@type = 'control'">ControlPort</xsl:if><xsl:if test="@type = 'audio'">AudioPort</xsl:if> ;
     :name "<xsl:value-of select="name"/>" ;
     :index <xsl:number value="position()-1" format="1" /> ;
     :symbol "<xsl:value-of select="@label"/>" ;<xsl:for-each select="range">
     :minimum <xsl:value-of select="@min"/> ;
     :maximum <xsl:value-of select="@max"/> ;</xsl:for-each>
     <xsl:if test="@label = 'latency'">
     :portProperty :reportsLatency ;</xsl:if>
     <xsl:if test="contains(@hint, 'default_0')">
     :default 0.0 ;</xsl:if>
     <xsl:if test="contains(@hint, 'default_1')">
     :default 1.0 ;</xsl:if>
     <xsl:if test="contains(@hint, 'default_440')">
     :default 440.0 ;</xsl:if>
     <xsl:if test="contains(@hint, 'default_high')">
     :default <xsl:value-of select="(number(range/@max) * 3.0 + number(range/@min)) div 4.0"/> ;</xsl:if>
     <xsl:if test="contains(@hint, 'default_high')">
     :default <xsl:value-of select="(3.0 * number(range/@max) + number(range/@min)) div 4.0"/> ;</xsl:if>
     <xsl:if test="contains(@hint, 'default_low')">
     :default <xsl:value-of select="(3.0 * number(range/@min) + number(range/@max)) div 4.0"/> ;</xsl:if>
     <xsl:if test="contains(@hint, 'default_middle')">
     :default <xsl:value-of select="(number(range/@min) + number(range/@max)) div 2.0"/> ;</xsl:if>
     <xsl:if test="contains(@hint, 'default_minimum')">
     :default <xsl:value-of select="range/@min"/> ;</xsl:if>
     <xsl:if test="contains(@hint, 'default_maximum')">
     :default <xsl:value-of select="range/@max"/> ;</xsl:if>
     <xsl:if test="range/@default">
     :default <xsl:value-of select="range/@default"/> ;</xsl:if>
     <xsl:if test="contains(@hint, 'integer')">
     :portProperty :integer ;</xsl:if>
     <xsl:if test="contains(@hint, 'logarithmic')">
     :portProperty epp:logarithmic ;</xsl:if>
     <xsl:if test="contains(@hint, 'sample_rate')">
     :portProperty :sampleRate ;</xsl:if>
     <xsl:if test="contains(@hint, 'toggled')">
     :portProperty :toggled ;</xsl:if>
     <xsl:if test="@group">
     pg:inGroup swh:<xsl:value-of select="$pluglabel"/>-<xsl:value-of select="@group"/> ;
     pg:role pg:<xsl:value-of select="@role"/> ;</xsl:if>
<!--     <xsl:if test="p">
     swhext:documentation """<xsl:value-of select="p"/>""" ;</xsl:if>-->
   ] ;
  </xsl:for-each>
  <xsl:if test="/ladspa/global/code">
   swhext:code """<xsl:value-of select="/ladspa/global/code"/>""" ;
</xsl:if>
  <xsl:for-each select="callback">
   swhext:callback [
     swhext:event "<xsl:value-of select="@event"/>" ;
     swhext:code """<xsl:value-of select="."/>""" ;
   ] ;
  </xsl:for-each>
   swhext:createdBy &lt;http://plugin.org.uk/swh-plugins/toTurtle.xsl&gt; .
</xsl:for-each>
</xsl:template>

<xsl:template name="csl2type">
  <xsl:param name="in"/>
  <xsl:choose>
    <xsl:when test="contains($in, ',')">   a :<xsl:value-of select="substring-before($in, ',')"/> ;
<xsl:call-template name="csl2type">
        <xsl:with-param name="in" select="substring-after($in, ',')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>   a :<xsl:value-of select="$in"/> ;
</xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
