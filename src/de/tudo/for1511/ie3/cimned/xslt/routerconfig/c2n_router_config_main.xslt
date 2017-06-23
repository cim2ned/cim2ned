<?xml version="1.0" encoding="UTF-8"?>
<!--  

Creates the router config file using the data of the given cim.

-->
<!-- xmlns:cim="http://iec.ch/TC57/2009/CIM-schema-cim14#"-->
<xsl:transform version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns:cim="http://iec.ch/TC57/2013/CIM-schema-cim16#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:c2n="http://tu-dortmund/ie3/cim2ned"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">

	<xsl:output method="xml" version="1.0" encoding="UTF-8"
		indent="yes" />

	<!-- include files -->
	<xsl:include href="../c2n_var_func.xslt" />
	<xsl:include href="../c2n_config.xslt" />
	<xsl:include href="c2n_router_config_modules_1.xslt" />
	<xsl:include href="c2n_router_config_modules_2.xslt" />


	<!-- main template -->
	<xsl:template match="/">

		<OSPFASConfig xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
			xsi:schemaLocation="OSPF.xsd">

			<!-- Areas -->
			<Area id="0.0.0.0">
				<AddressRange address="_0000_cc_router" mask="_0000_cc_router"
					status="Advertise" />

				<xsl:apply-templates mode="c2n:VoltageLevel_1" />
				<xsl:apply-templates mode="c2n:Substations_1" />
				<xsl:apply-templates mode="c2n:VoltageLevelSubRouterNodes_1" />
			</Area>

			<Router name="_0000_cc_router" RFC1583Compatible="true"/>
			<xsl:apply-templates mode="c2n:VoltageLevel_2" />
			<xsl:apply-templates mode="c2n:Substations_2" />
			<xsl:apply-templates mode="c2n:VoltageLevelSubRouterNodes_2" />

		</OSPFASConfig>

	</xsl:template>

	<!-- ignore everything else -->
	<xsl:template match="*/text()" mode="c2n:VoltageLevel_1" />
	<xsl:template match="*/text()" mode="c2n:VoltageLevel_2" />
	<xsl:template match="*/text()" mode="c2n:Substations_1" />
	<xsl:template match="*/text()" mode="c2n:Substations_2" />
	<xsl:template match="*/text()" mode="c2n:VoltageLevelSubRouterNodes_1" />
	<xsl:template match="*/text()" mode="c2n:VoltageLevelSubRouterNodes_2" />

</xsl:transform>