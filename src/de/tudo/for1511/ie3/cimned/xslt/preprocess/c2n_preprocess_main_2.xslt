<?xml version="1.0" encoding="UTF-8"?>

<!-- Third step of preprocessing: Additional informations are added to nodes.
	TODO -->
<!-- xmlns:cim="http://iec.ch/TC57/2009/CIM-schema-cim14#"-->
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:html="http://www.w3.org/1999/xhtml" 
	xmlns:cim="http://iec.ch/TC57/2013/CIM-schema-cim16#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:c2n="http://tu-dortmund/ie3/cim2ned"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">

	<xsl:include href="../c2n_config.xslt" />
	<xsl:include href="c2n_preprocess_functions.xslt" />

	<xsl:strip-space elements="*" />
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />

	<xsl:template match="/rdf:RDF">
		<xsl:copy>
			<c2n:NetworkInformation>
				<c2n:Network c2n:totalNumClients="{count($c2n_all_clients)}" />
				<xsl:for-each-group select="*/c2n:TargetRouter" group-by="@c2n:id">
					<xsl:variable name="router" as="node()*" select="/rdf:RDF/*/c2n:TargetRouter[@c2n:id = current-grouping-key()]/.." />
					<c2n:Router c2n:id="{current-grouping-key()}" c2n:clients="{count(/rdf:RDF/*/c2n:Client[@c2n:id [contains(.,current-grouping-key())]])}" />
				</xsl:for-each-group>

				<xsl:for-each select="$c2n_all_substations">
					<xsl:variable select="current()" name="outer" />
					<xsl:variable select="position()" name="p" />
					<xsl:for-each select="$c2n_all_substations">
						<xsl:if test="(c2n:connected(current(), $outer)) and (not(current()/@rdf:ID = $outer/@rdf:ID))">
							<c2n:RouterConnection c2n:id1="{current()/@rdf:ID}" c2n:id2="{$outer/@rdf:ID}" c2n:length="{c2n:getACLineLengthById(current()/@rdf:ID, $outer/@rdf:ID)}" />
						</xsl:if>
					</xsl:for-each>
				</xsl:for-each>

			</c2n:NetworkInformation>
			<xsl:apply-templates select="@* | node()" mode="preprocess-2" />
		</xsl:copy>
	</xsl:template>

	<!-- Add neighbour router to substations -->
	<xsl:template match="cim:Substation" mode="preprocess-2">
		<xsl:copy copy-namespaces="no">
	 		<xsl:apply-templates select="@*|node()" mode="preprocess-2" />
	 		
	 		<xsl:variable name="outer" select="current()"/>
			<xsl:for-each select="$c2n_all_substations">
				<xsl:if test="((c2n:connected(current(), $outer)) and (not ($outer=current())))">
					<c2n:NeighbourRouter c2n:id="{current()/@rdf:ID}" />
				</xsl:if>
			</xsl:for-each>

			<!-- Has equipment? -->
			<xsl:if test="c2n:has_equipment(current()/@rdf:ID)">
				<c2n:HasEquipment c2n:value="true" />
			</xsl:if>
			<c2n:RouterName c2n:value="{current()/@rdf:ID}"/>
		</xsl:copy>
	</xsl:template>

	<!-- Identity transform - copies all elements and attributes. -->
	<xsl:template match="@*|node()" mode="preprocess-2">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()" mode="preprocess-2" />
		</xsl:copy>
	</xsl:template>

</xsl:transform>