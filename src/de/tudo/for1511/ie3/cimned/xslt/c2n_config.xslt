<?xml version="1.0" encoding="UTF-8"?>
<!-- Configuration file. -->
<!-- xmlns:cim="http://iec.ch/TC57/2009/CIM-schema-cim14#"-->
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns:cim="http://iec.ch/TC57/2013/CIM-schema-cim16#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:c2n="http://tu-dortmund/ie3/cim2ned"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:md="http://iec.ch/TC57/61970-552/ModelDescription/1#">


	<!-- Max. # of host connected to subvoltagelevel router -->
	<xsl:variable name="MAX_CES" select="16" />

	<!-- Max. # of ports for each router -->
	<xsl:variable name="MAX_ETH_PORTS" select="64" />

	<!-- Port offset for host connection -->
	<xsl:variable name="CE_PORT_OFFSET" select="16" />



	<!-- Channel configuration. -->

	<!-- Channel used for connecting substations -->
	<xsl:variable name="INTER_SUBSTATION_CHANNEL" select="$fibre_optic_channel" />
	<!-- The default distance between two substations that are not connected
		by an acline. Connections between substations that are connected by an acline
		use the acline length as length of their channel. -->
	<xsl:variable name="DEFAULT_INTER_SUBSTATION_DISTANCE" select="0.0001" />

	<!-- Channel used for connecting a voltagelevel router with its subvoltagelevel
		routers -->
	<xsl:variable name="VOLTAGELEVEL_GROUP_CHANNEL" select="$ethernet_channel" />
	<xsl:variable name="DEFAULT_INTER_VOLTAGELEVEL_DISTANCE" select="0.050" />
	
	<!-- Channel used for connecting a substation router with its voltagelevel
		routers -->
	<xsl:variable name="SUBSTATION_VOLTAGELEVEL_CHANNEL" select="$ethernet_channel" />
	<xsl:variable name="DEFAULT_SUBSTATION_VOLTAGELEVEL_DISTANCE" select="0.150" />
	<!-- <xsl:variable name="VOLTAGELEVEL_GROUP_CHANNEL" select="$fibre_optic_channel" /> -->

	<xsl:variable name="DEFAULT_VOLTAGELEVEL_HOST_DISTANCE" select="1" />
	<xsl:variable name="DEFAULT_SUBSTATION_HOST_DISTANCE_FACTOR" select="0.050" />
	<!-- ... - TODO replace other channel usages with variables! -->
	<!-- ... -->


	<!-- Distance unit, i.e. m for meters and km for kilometers. -->
	<xsl:variable name="DEFAULT_DISTANCE_UNIT" select="'km'" />

	<!-- Distance factor. Multiplier for correcting the distance unit. -->
	<xsl:variable name="DEFAULT_SUBSTATION_DISTANCE_FACTOR" select="1" />

</xsl:transform>