<!--This file contains the template responsible for connecting the hosts
	to its corresponding router. -->
<!-- xmlns:cim="http://iec.ch/TC57/2009/CIM-schema-cim14#"-->
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:html="http://www.w3.org/1999/xhtml" 
	xmlns:cim="http://iec.ch/TC57/2013/CIM-schema-cim16#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:c2n="http://tu-dortmund/ie3/cim2ned"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">

	<xsl:key name="subs" match="cim:Substation" use="c2n:SubstationId/@c2n:value" />
	
	<xsl:template match="rdf:RDF" mode="c2n:CEHostsConnections">
		<xsl:for-each-group select="$c2n_all_equipment" group-by="c2n:Client/@c2n:id">
		<xsl:variable name="ces" as="node()*" select="$c2n_all_equipment/c2n:Client[@c2n:id = current-grouping-key()]/.." />
			<xsl:for-each select="$ces">
				<xsl:variable name="nid" select="concat(substring-after(current-grouping-key(),';'), '_', floor((position()-1) div $MAX_CES))" />
					<connection src-module="{$nid}" src-gate="ethg" src-gate-plusplus="true" dest-module="{substring-before(current()/c2n:Client/@c2n:id,';')}" dest-gate="ethg" dest-gate-plusplus="true" type="C" is-bidirectional="true">
						<parameters is-implicit="true">
							<param name="distance">
								<expression target="value">
									<literal type="quantity" text="{concat($DEFAULT_VOLTAGELEVEL_HOST_DISTANCE, $DEFAULT_DISTANCE_UNIT)}" value="{concat($DEFAULT_VOLTAGELEVEL_HOST_DISTANCE, $DEFAULT_DISTANCE_UNIT)}" />
								</expression>
							</param>
						</parameters>
					</connection>
			</xsl:for-each>
		</xsl:for-each-group>
	</xsl:template>

</xsl:transform>