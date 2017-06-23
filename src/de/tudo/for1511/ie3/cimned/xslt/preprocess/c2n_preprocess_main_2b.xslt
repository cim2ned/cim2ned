<?xml version="1.0" encoding="UTF-8"?>

<!-- Third step of preprocessing: Additional informations are added to nodes. 
	TODO -->
<!-- xmlns:cim="http://iec.ch/TC57/2009/CIM-schema-cim14#"-->
<xsl:transform version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns:cim="http://iec.ch/TC57/2013/CIM-schema-cim16#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:c2n="http://tu-dortmund/ie3/cim2ned"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">

	<xsl:include href="../c2n_config.xslt" />
	<xsl:include href="c2n_preprocess_functions.xslt" />

	<xsl:strip-space elements="*" />
	<xsl:output method="xml" version="1.0" encoding="UTF-8"
		indent="yes" />

	<xsl:template match="/*">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()" mode="preprocess-2b" />
		</xsl:copy>
	</xsl:template>

	<!-- Add neighbor router to substations -->
	<xsl:template match="c2n:NetworkInformation" mode="preprocess-2b">
		<xsl:copy copy-namespaces="no">

			<xsl:variable select="c2n:RouterConnection" name="a" />

			<xsl:for-each-group select="$a" group-by="@c2n:id2">
			
				<xsl:variable select="max((0, $a[@c2n:id1 = current()/@c2n:id2]/@c2n:port1))" name="max_port" />
			
				<xsl:for-each select="$a[@c2n:id2 = current()/@c2n:id2]">
					<c2n:RouterConnection c2n:id1="{current()/@c2n:id1}"
						c2n:id2="{current()/@c2n:id2}" c2n:length="{current()/@c2n:length}"
						c2n:port1="{current()/@c2n:port1}" c2n:port2="{$max_port + position()}" />
				</xsl:for-each>
				
			</xsl:for-each-group>
			
			<xsl:apply-templates select="@*|node()" mode="preprocess-2b" />

		</xsl:copy>
	</xsl:template>

	<xsl:template match="c2n:RouterConnection" mode="preprocess-2b">
<!-- 		<xsl:copy copy-namespaces="no"> -->
<!-- 			<xsl:apply-templates select="@*|node()" mode="preprocess-2a" /> -->
<!-- 		</xsl:copy> -->
	</xsl:template>

	<!-- Identity transform - copies all elements and attributes. -->
	<xsl:template match="@*|node()" mode="preprocess-2b">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()" mode="preprocess-2b" />
		</xsl:copy>
	</xsl:template>

</xsl:transform>