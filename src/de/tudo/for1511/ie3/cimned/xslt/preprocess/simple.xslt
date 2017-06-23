<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- <xsl:include href="../helper_functions.xslt" />
	<xsl:include href="../variables.xslt" /> -->
	<xsl:template match="/root">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()" mode="allElements" />
		</xsl:copy>
	</xsl:template>
	<xsl:template match="node()" mode="allElements">
		<xsl:copy>
			<xsl:value-of select="name(current())"></xsl:value-of>
			<xsl:if test="contains(name(current()),'sibling')">
				<newElement>add</newElement>
			</xsl:if>
		</xsl:copy>
	</xsl:template>
</xsl:transform>