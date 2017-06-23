<?xml version="1.0" encoding="UTF-8"?>

<!-- 4. step of preprocessing: Additional informations are added to nodes.
	TODO -->
<!-- xmlns:cim="http://iec.ch/TC57/2009/CIM-schema-cim14#"-->
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:html="http://www.w3.org/1999/xhtml" 
	xmlns:cim="http://iec.ch/TC57/2013/CIM-schema-cim16#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:c2n="http://tu-dortmund/ie3/cim2ned"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">

	<xsl:include href="../c2n_config.xslt" />
	<xsl:include href="c2n_preprocess_functions.xslt" />

	<xsl:strip-space elements="*" />
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />

	<xsl:template match="/*">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()" mode="preprocess-3" />
		</xsl:copy>
	</xsl:template>

	<!-- Filter substations -->
	<xsl:template match="cim:Substation" mode="preprocess-3">
		<!-- count(/rdf:RDF/c2n:NetworkInformation/c2n:RouterConnection[@c2n:id1 = current()/@rdf:ID]) +
					  count(/rdf:RDF/c2n:NetworkInformation/c2n:RouterConnection[@c2n:id2 = current()/@rdf:ID]) &gt; 0
					  or  -->
		<xsl:if test="current()/c2n:HasEquipment[@c2n:value = 'true']">
			<xsl:copy copy-namespaces="no">
				<xsl:apply-templates select="@*|node()" mode="preprocess-3" />
			</xsl:copy>
		</xsl:if>
	</xsl:template>


	<!-- Identity transform - copies all elements and attributes. -->
	<xsl:template match="@*|node()" mode="preprocess-3">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()" mode="preprocess-3" />
		</xsl:copy>
	</xsl:template>

</xsl:transform>