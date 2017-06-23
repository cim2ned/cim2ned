<?xml version="1.0" encoding="UTF-8"?>

<!-- Second step of preprocessing: Additional informations are added to nodes. 
	TODO -->
<!-- xmlns:cim="http://iec.ch/TC57/2009/CIM-schema-cim14#"-->
<xsl:transform version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns:cim="http://iec.ch/TC57/2013/CIM-schema-cim16#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:c2n="http://tu-dortmund/ie3/cim2ned"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">

	<xsl:include href="../c2n_config.xslt" />
	<xsl:include href="c2n_preprocess_functions.xslt" />
	
	<!-- Format definitions of created xml file: -->
	<xsl:strip-space elements="*" />
	<xsl:output method="xml" version="1.0" encoding="UTF-8"
		indent="yes" />

	<!-- add namespaces if required and apply templates -->
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


	<!-- Identity transform - copies all elements and attributes. -->
	<xsl:template match="node()" mode="allElements">
		<xsl:copy copy-namespaces="no">
			<xsl:attribute name="rdf:ID">
   				<xsl:value-of select="current()/@rdf:ID" />
			</xsl:attribute>
			<xsl:choose>
				<xsl:when test="contains($equipmentstr, name(current()))">
					<xsl:apply-templates select="current()/*" mode="copy" />
					<xsl:apply-templates select="current()" mode="add_terminals" />
					<xsl:apply-templates select="current()" mode="addTARGETROUTERandVLandSUBSandHOSTS" />
				</xsl:when>
				<xsl:when test="contains('cim:Terminal', name(current()))">
					<xsl:apply-templates select="current()/*" mode="copy" />
					<xsl:apply-templates select="current()" mode="addVLTOTERM" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="current()/*" mode="copy" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>

	<!-- add c2n:voltagelevel to terminal -->
	<xsl:template match="cim:Terminal" mode="addVLTOTERM">
		<c2n:VoltageLevel c2n:id="{c2n:getVlOfTerminal_pp(current()/@rdf:ID)/@rdf:ID}" />
	</xsl:template>

	<!-- add c2n:TargetRouter, c2n:VoltageLevel, c2n:Substation tags to all current nodes that are associations of terminal -->
	<xsl:template match="node()" mode="addTARGETROUTERandVLandSUBSandHOSTS">
		<xsl:variable name="eqid"
			select="current()/@rdf:ID" />
		<xsl:variable name="terminals"
			select="$all_terminals/cim:Terminal.ConductingEquipment[@rdf:resource = current()/@rdf:ID]/.." />
		<xsl:for-each select="$terminals">
			<c2n:TargetRouter c2n:id="{c2n:getVlOfTerminal_pp(current()/@rdf:ID)/@rdf:ID}"></c2n:TargetRouter>
			<c2n:VoltageLevel c2n:id="{c2n:getVlOfTerminal_pp(current()/@rdf:ID)/@rdf:ID}" />
			<c2n:Substation c2n:id="{c2n:getVlOfTerminal_pp(current()/@rdf:ID)/cim:VoltageLevel.Substation/@rdf:resource}" />
			<c2n:Client c2n:id="{concat($eqid,';', c2n:getVlOfTerminal_pp(current()/@rdf:ID)/@rdf:ID)}" />
		</xsl:for-each>
	</xsl:template>

	<!-- add c2n:Terminal tag to all current nodes that are associations of terminal -->
	<xsl:template match="node()" mode="add_terminals">
		<xsl:variable name="terminals"
			select="$all_terminals/cim:Terminal.ConductingEquipment[@rdf:resource = current()/@rdf:ID]/.." />
		<xsl:for-each select="$terminals">
			<c2n:Terminal c2n:id="{current()/@rdf:ID}" />
		</xsl:for-each>
	</xsl:template>

	<!-- copy matching elements to destination document -->
	<xsl:template match="*" mode="copy">
			<xsl:copy-of select="current()" />
	</xsl:template>

</xsl:transform>