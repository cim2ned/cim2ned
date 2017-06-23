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
			<c2n:element-count select="{count(current()/*)}" />
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
					<xsl:apply-templates select="current()/*" mode="removeDUPLICATES" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="current()/*" mode="copy" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="node()" mode="removeDUPLICATES">
		<xsl:choose>
			<!-- only add c2n:TargetRouter that are not in the same substation or already exists -->
			<xsl:when test="name(current()) = 'c2n:TargetRouter'" > <!-- test if current node is c2n:TargetRouter -->
				<xsl:variable name="trsib" select="preceding-sibling::c2n:TargetRouter/@c2n:id" />
	            <xsl:if test="not ($c2n_all_voltagelevel[@rdf:ID = $trsib]/cim:VoltageLevel.Substation/@rdf:resource =
	            		$c2n_all_voltagelevel[@rdf:ID = current()/@c2n:id]/cim:VoltageLevel.Substation/@rdf:resource)"> <!-- test if substation of current node is
	            				the same as preceding sibling-->
	            	<xsl:copy-of select="current()" />
	            </xsl:if>
	        </xsl:when>
	        <!-- only add c2n:VoltageLevel that are not in the same substation or already exists-->
	        <xsl:when test="name(current()) = 'c2n:VoltageLevel'" > <!-- test if current node is c2n:VoltageLevel -->
	        	<xsl:variable name="sib" select="preceding-sibling::c2n:VoltageLevel/@c2n:id" />
	            <xsl:if test="not ($c2n_all_voltagelevel[@rdf:ID = $sib]/cim:VoltageLevel.Substation/@rdf:resource =
	            		$c2n_all_voltagelevel[@rdf:ID = current()/@c2n:id]/cim:VoltageLevel.Substation/@rdf:resource)"> <!-- test if substation of current node is
	            				the same as preceding sibling-->
	            	<xsl:copy-of select="current()" />
	            	<!-- <c2n:meta type="log"><xsl:value-of select="($c2n_all_voltagelevel[@rdf:ID = $sib])/cim:VoltageLevel.Substation/@rdf:resource"/></c2n:meta> -->
	            </xsl:if>
	        </xsl:when>
	        <!-- only add c2n:Substation that are not already exists-->
	        <xsl:when test="name(current()) = 'c2n:Substation'"> <!-- test if current node is c2n:VoltageLevel -->
	        	<xsl:if test="not (preceding-sibling::c2n:Substation/@c2n:id = current()/@c2n:id)"> <!-- test if substation with same c2n:id already exists -->
	        		<xsl:copy-of select="current()" />
	        	</xsl:if>
	        </xsl:when>
	        <!-- only add c2n:Client that are not already exists-->
	        <xsl:when test="name(current()) = 'c2n:Client'"> <!-- test if current node is c2n:Client -->
	        	<xsl:if test="not (preceding-sibling::c2n:Client/@c2n:id = current()/@c2n:id)"> <!-- test if client with same c2n:id already exists -->
	        		<xsl:copy-of select="current()" />
	        	</xsl:if>
	        </xsl:when>
	     	<xsl:otherwise>
	            <xsl:copy-of select="current()" />
	     	</xsl:otherwise>
        </xsl:choose>
	 </xsl:template>

	<!-- copy matching elements to destination document -->
	<xsl:template match="*" mode="copy">
			<xsl:copy-of select="current()" />
	</xsl:template>
	
</xsl:transform>