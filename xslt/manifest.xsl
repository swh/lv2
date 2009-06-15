<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:param name="obj"/>
<xsl:output method="text" indent="no"/>
<xsl:template match="/">@prefix : &lt;http://lv2plug.in/ns/lv2core#&gt; .
@prefix rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#&gt; .
@prefix swh: &lt;http://plugin.org.uk/swh-plugins/&gt; .
<xsl:for-each select="ladspa/plugin">
swh:<xsl:value-of select="@label"/> a :Plugin ;
  :binary &lt;<xsl:value-of select="$obj"/>&gt; ;
  rdfs:seeAlso &lt;plugin.ttl&gt; ;
.
</xsl:for-each>
</xsl:template>
</xsl:stylesheet>
