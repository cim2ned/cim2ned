<?xml version="1.0" encoding="UTF-8"?>

<!-- First step of preprocessing: Removes all components from cim file that 
	are not needed for the transformation and unifies the identifiers. -->

<!-- xmlns:cim="http://iec.ch/TC57/2009/CIM-schema-cim14#"-->
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns:cim="http://iec.ch/TC57/2013/CIM-schema-cim16#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:c2n="http://tu-dortmund/ie3/cim2ned"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:md="http://iec.ch/TC57/61970-552/ModelDescription/1#">

	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:include href="../c2n_var_func.xslt" />
	<xsl:include href="../c2n_config.xslt" />
	
	<!-- copy root element and apply templates on all equipment, equipment container and terminals -->
	<xsl:template match="/rdf:RDF">
		<xsl:copy>
			 
			<xsl:apply-templates select="cim:Terminal |
						 cim:ConnectivityNode |
						 cim:ConnectivityNodeContainer |
						 cim:Substation |
						 cim:VoltageLevel |
						 cim:Switch | 
						 cim:Breaker |
						 cim:ACLineSegment | 
						 cim:PowerTransformer |
						 cim:PowerTransformerEnd |
						 cim:ShuntCompensator |
						 cim:EnergyConsumer | 
						 cim:SynchronousMachine |
						 cim:GeneratingUnit" mode="copy-elements" />
		</xsl:copy>
	</xsl:template>

	<!-- copy tags of selected elements and apply templates on their childs -->
	<xsl:template match="*" mode="copy-elements">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="normalizeRDFID" />
			<xsl:apply-templates select="current()/*" mode="normalizeRDFRESOURCE" />
			<xsl:if test="contains($equipmentstr, name(../current()))">
				<xsl:apply-templates select="../current()" mode="markEQUIPMENT" />
			</xsl:if>
		</xsl:copy>
	</xsl:template>

	<!-- normalize all occurences of attribute rdf:ID -->
	<xsl:template match="@rdf:ID" mode="normalizeRDFID">
		<xsl:attribute name="rdf:ID">
   			<xsl:value-of select="translate(current(), '#-', '')" />
		</xsl:attribute>
	</xsl:template>

	<!-- normalize all occurences of attribute rdf:resource -->
	<xsl:template match="*" mode="normalizeRDFRESOURCE">
		<xsl:choose>
			<xsl:when test="current()/@rdf:resource">
				<xsl:copy>
					<xsl:attribute name="rdf:resource">
			   			<xsl:value-of select="translate(current()/@rdf:resource, '#-', '')" />
					</xsl:attribute>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="current()" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- add c2n:meta tag as a marker for equipment elements -->
	<xsl:template match="cim:Switch | 
						 cim:Breaker |
						 cim:ACLineSegment | 
						 cim:PowerTransformer |
						 cim:ShuntCompensator |
						 cim:EnergyConsumer | 
						 cim:SynchronousMachine |
						 cim:GeneratingUnit" mode="markEQUIPMENT">
		<c2n:Meta c2n:type="equipment" />
	</xsl:template>
	
</xsl:transform>