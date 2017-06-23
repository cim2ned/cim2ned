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

	<xsl:template match="/rdf:RDF">
		<xsl:copy>
			<!-- Add a namespace nodes -->
			<xsl:namespace name="rdf"
				select="'http://www.w3.org/1999/02/22-rdf-syntax-ns#'" />
			<xsl:namespace name="cim"
				select="'http://iec.ch/TC57/2013/CIM-schema-cim16#'" />
			<xsl:namespace name="c2n" select="'http://tu-dortmund/ie3/cim2ned'" />
			<xsl:namespace name="html" select="'http://www.w3.org/1999/xhtml'" />
			<xsl:namespace name="xs" select="'http://www.w3.org/2001/XMLSchema'" />
			<xsl:apply-templates select="@* | node()" mode="allElements" />
		</xsl:copy>
	</xsl:template>

	<!-- Add neighbor router to substations -->
	<xsl:template match="node()" mode="allElements">
		<xsl:choose>
			<xsl:when test="contains(name(current()),'c2n:NetworkInformation')">
				<xsl:copy copy-namespaces="no">
					<xsl:apply-templates select="@* | node()" mode="preprocess-2a" />
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy copy-namespaces="no">
					<xsl:attribute name="rdf:ID">
   						<xsl:value-of select="current()/@rdf:ID" />
					</xsl:attribute>
					<xsl:apply-templates select="current()/*" mode="copy" />
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Add neighbor router to substations -->
	<xsl:template match="@* | node()" mode="preprocess-2a">
		<xsl:choose>
			<xsl:when test="contains(name(current()),'c2n:RouterConnection')">
<!-- 			<xsl:variable select="c2n:RouterConnection" name="a" />
				<xsl:for-each-group select="$a" group-by="@c2n:id1">
					<xsl:for-each select="$a[@c2n:id1 = current()/@c2n:id1]"> -->
						<xsl:variable name="rcsib1" select="preceding-sibling::c2n:RouterConnection/@c2n:id1" />
						<xsl:variable name="rcsib2" select="preceding-sibling::c2n:RouterConnection/@c2n:id2" />
						<xsl:choose>
							<!-- only add c2n:RouterConnection that are not in the same substation or already exists -->
							<xsl:when test="not ((current()/@c2n:id1 = $rcsib2) and (current()/@c2n:id2 = $rcsib1))">
<!--       						<c2n:RouterConnection c2n:id1="{current()/@c2n:id1}"
									c2n:id2="{current()/@c2n:id2}" c2n:length="{current()/@c2n:length}"
									c2n:port1="{position()}" /> -->
								<c2n:RouterConnection c2n:id1="{current()/@c2n:id1}"
									c2n:id2="{current()/@c2n:id2}" c2n:length="{current()/@c2n:length}" />
							</xsl:when>
							<xsl:otherwise>
							</xsl:otherwise>
						</xsl:choose>
<!--				</xsl:for-each>
				</xsl:for-each-group> -->
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="current()" mode="copy" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- copy matching elements to destination document -->
	<xsl:template match="*" mode="copy">
			<xsl:copy-of select="current()" />
	</xsl:template>
	
</xsl:transform>