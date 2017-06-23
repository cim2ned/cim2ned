<!-- xmlns:cim="http://iec.ch/TC57/2009/CIM-schema-cim14#"-->
<xsl:transform version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns:cim="http://iec.ch/TC57/2013/CIM-schema-cim16#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:c2n="http://tu-dortmund/ie3/cim2ned"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">

	<!-- router -->
	<xsl:template match="rdf:RDF/cim:VoltageLevel" mode="c2n:VoltageLevel_1">
		<AddressRange address="{current()/@rdf:ID}" mask="{current()/@rdf:ID}" status="Advertise" />
	</xsl:template>

	<xsl:template match="rdf:RDF/cim:Substation" mode="c2n:Substations_1">
		<AddressRange address="{current()/@rdf:ID}" mask="{current()/@rdf:ID}" status="Advertise" />
	</xsl:template>

	<xsl:template match="rdf:RDF" mode="c2n:VoltageLevelSubRouterNodes_1">
		<xsl:for-each-group select="$c2n_all_equipment"	group-by="c2n:TargetRouter/@c2n:id">
			<xsl:variable name="ces" as="node()*" select="$c2n_all_equipment/c2n:TargetRouter[@c2n:id = current-grouping-key()]/.." />
			<xsl:for-each select="$ces">
				<xsl:if test="(position() - 1) mod $MAX_CES = 0">
					<AddressRange address="{concat(current-grouping-key(), '_', floor((position() - 1) div $MAX_CES))}" 
							mask="{concat(current-grouping-key(), '_', floor((position() - 1) div $MAX_CES))}" status="Advertise" />
				 </xsl:if>
			</xsl:for-each>
		</xsl:for-each-group>
	</xsl:template>

</xsl:transform>