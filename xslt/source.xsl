<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" indent="no"/>
<xsl:variable name="lcase">abcdefghijklmnopqrstuvwxyz</xsl:variable>
<xsl:variable name="ucase">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
<xsl:template match="/">
<xsl:value-of select="/ladspa/global/code"/>
<xsl:for-each select="ladspa/plugin">
<xsl:variable name="pluginLabel"><xsl:value-of select="@label"/></xsl:variable>
<xsl:variable name="PluginLabel"><xsl:call-template name="initialCaps"><xsl:with-param name="in" select="$pluginLabel" /></xsl:call-template></xsl:variable>
<xsl:variable name="PLUGINLABEL"><xsl:call-template name="allCaps"><xsl:with-param name="in" select="$pluginLabel" /></xsl:call-template></xsl:variable>
#include &lt;math.h&gt;
#include &lt;stdlib.h&gt;
#include "lv2.h"
static LV2_Descriptor *<xsl:value-of select="$pluginLabel"/>Descriptor = NULL;

typedef struct _<xsl:value-of select="$PluginLabel"/> {
<xsl:for-each select="port">  float *<xsl:value-of select="@label"/>;
</xsl:for-each>
<xsl:for-each select="instance-data">  <xsl:value-of select="@type"/><xsl:text> </xsl:text><xsl:value-of select="@label"/>;
</xsl:for-each>} <xsl:value-of select="$PluginLabel"/>;

static void cleanup<xsl:value-of select="$PluginLabel"/>(LV2_Handle instance)
{
<xsl:if test="callback[@event='cleanup']">
  <xsl:value-of select="$PluginLabel"/> *plugin_data = (<xsl:value-of select="$PluginLabel"/> *)instance;
<xsl:value-of select="callback[@event='cleanup']" />
</xsl:if>
  free(instance);
}

static void connectPort<xsl:value-of select="$PluginLabel"/>(LV2_Handle instance, uint32_t port, void *data)
{
  <xsl:value-of select="$PluginLabel"/> *plugin = (<xsl:value-of select="$PluginLabel"/> *)instance;

  switch (port) {
<xsl:for-each select="port">  case <xsl:number value="position()-1" format="1" />:
    plugin-><xsl:value-of select="@label"/> = data;
    break;
</xsl:for-each>  }
}

static LV2_Handle instantiate<xsl:value-of select="$PluginLabel"/>(const LV2_Descriptor *descriptor,
            double s_rate, const char *path,
            const LV2_Feature *const *features)
{
  <xsl:value-of select="$PluginLabel"/> *plugin_data = (<xsl:value-of select="$PluginLabel"/> *)malloc(sizeof(<xsl:value-of select="$PluginLabel"/>));
  <xsl:for-each select="instance-data">  <xsl:value-of select="@type"/><xsl:text> </xsl:text><xsl:value-of select="@label"/> = plugin_data-><xsl:value-of select="@label"/>;
  </xsl:for-each>

<xsl:value-of select="callback[@event='instantiate']" /><xsl:text>
</xsl:text>

  <xsl:text>  </xsl:text><xsl:for-each select="instance-data">plugin_data-><xsl:value-of select="@label"/> = <xsl:value-of select="@label"/>;
  </xsl:for-each>
  return (LV2_Handle)plugin_data;
}

<xsl:if test="callback[@event='activate']">
static void activate<xsl:value-of select="$PluginLabel"/>(LV2_Handle instance)
{
  <xsl:value-of select="$PluginLabel"/> *plugin_data = (<xsl:value-of select="$PluginLabel"/> *)instance;
  <xsl:for-each select="instance-data">  <xsl:value-of select="@type"/><xsl:text> </xsl:text><xsl:value-of select="@label"/> __attribute__ ((unused)) = plugin_data-><xsl:value-of select="@label"/>;
  </xsl:for-each>
<xsl:value-of select="callback[@event='activate']" />
}
</xsl:if>

static void run<xsl:value-of select="$PluginLabel"/>(LV2_Handle instance, uint32_t sample_count)
{
  <xsl:value-of select="$PluginLabel"/> *plugin_data = (<xsl:value-of select="$PluginLabel"/> *)instance;

  <xsl:for-each select="port">
  <xsl:if test="@dir = 'input'"><xsl:if test="@type = 'control'">const float <xsl:value-of select="@label"/> = *(plugin_data-><xsl:value-of select="@label"/>)</xsl:if><xsl:if test="@type = 'audio'">const float * const <xsl:value-of select="@label"/> = plugin_data-><xsl:value-of select="@label"/></xsl:if></xsl:if><xsl:if test="@dir = 'output'"><xsl:if test="@type = 'control'">float <xsl:value-of select="@label"/></xsl:if><xsl:if test="@type = 'audio'">float * const <xsl:value-of select="@label"/> = plugin_data-><xsl:value-of select="@label"/></xsl:if></xsl:if>;
  </xsl:for-each>
  <xsl:for-each select="instance-data">  <xsl:value-of select="@type"/><xsl:text> </xsl:text><xsl:value-of select="@label"/> = plugin_data-><xsl:value-of select="@label"/>;
  </xsl:for-each>
<xsl:value-of select="callback[@event='run']" />
}

static void init_<xsl:value-of select="$pluginLabel" />()
{
  <xsl:value-of select="$pluginLabel" />Descriptor = (LV2_Descriptor *)malloc(sizeof(LV2_Descriptor));

  <xsl:value-of select="$pluginLabel" />Descriptor->URI = "http://plugin.org.uk/swh-plugins/<xsl:value-of select="$pluginLabel" />";
  <xsl:value-of select="$pluginLabel" />Descriptor->activate = <xsl:choose><xsl:when test="callback[@event='activate']">activate<xsl:value-of select="$PluginLabel" /></xsl:when><xsl:otherwise>NULL</xsl:otherwise></xsl:choose>;
  <xsl:value-of select="$pluginLabel" />Descriptor->cleanup = cleanup<xsl:value-of select="$PluginLabel" />;
  <xsl:value-of select="$pluginLabel" />Descriptor->connect_port = connectPort<xsl:value-of select="$PluginLabel" />;
  <xsl:value-of select="$pluginLabel" />Descriptor->deactivate = <xsl:choose><xsl:when test="callback[@event='deactivate']">deactivate<xsl:value-of select="$PluginLabel" /></xsl:when><xsl:otherwise>NULL</xsl:otherwise></xsl:choose>;
  <xsl:value-of select="$pluginLabel" />Descriptor->instantiate = instantiate<xsl:value-of select="$PluginLabel" />;
  <xsl:value-of select="$pluginLabel" />Descriptor->run = <xsl:choose><xsl:when test="callback[@event='run']">run<xsl:value-of select="$PluginLabel" /></xsl:when><xsl:otherwise>NULL</xsl:otherwise></xsl:choose>;
}
</xsl:for-each>

LV2_SYMBOL_EXPORT
const LV2_Descriptor *lv2_descriptor(uint32_t index)
{
<xsl:for-each select="ladspa/plugin">  if (!<xsl:value-of select="@label" />Descriptor) init_<xsl:value-of select="@label" />();
</xsl:for-each>
  switch (index) {
<xsl:for-each select="ladspa/plugin">  case <xsl:number value="position()-1" format="1" />:
    return <xsl:value-of select="@label" />Descriptor;
</xsl:for-each>  default:
    return NULL;
  }
}
</xsl:template>

<xsl:template name="initialCaps">
  <xsl:param name="in" />
  <xsl:variable name="f" select="substring($in, 1, 1)" />
  <xsl:variable name="r" select="substring($in, 2)" />
  <xsl:value-of select="concat(translate($f, $lcase, $ucase),$r)"/>
</xsl:template>

<xsl:template name="allCaps">
  <xsl:param name="in" />
  <xsl:value-of select="translate($in, $lcase, $ucase)"/>
</xsl:template>

</xsl:stylesheet>
