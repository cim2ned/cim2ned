<?xml version="1.0" encoding="UTF-8"?>

<!-- Creates the XML-NED file using the preprocessed CIM file. -->
<!-- xmlns:cim="http://iec.ch/TC57/2009/CIM-schema-cim14#"-->
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns:cim="http://iec.ch/TC57/2013/CIM-schema-cim16#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:c2n="http://tu-dortmund/ie3/cim2ned"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">

	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />

	<!-- Include files -->
	<!-- Configuration file -->
	<xsl:include href="c2n_config.xslt" />
	<!-- Contains variables and functions that are used for dynamic content	generation -->
	<xsl:include href="c2n_var_func.xslt" />
	<!-- Templates for creating the hosts and routers -->
	<xsl:include href="c2n_modules.xslt" />
	<!-- Templates for connections between routers and hosts -->
	<xsl:include href="c2n_connections_ce_hosts.xslt" />
	<!-- Templates for connections between the routers -->
	<xsl:include href="c2n_connections_subs.xslt" />

	<!-- The main template. This template creates the root the xml ned file
		and all static content. Dynamic content is created by template calls.

		Static content:
		- the imports
		- the compount-module node that is parent of the network
		- the channel types
		- the control center host, its router and the connection between them

		Dynamic content:
		- hosts for the equipment
		- router for substations
		- router for voltagelevel
		- router that connect to a configurable number of hosts and to one voltagelevel
		- all connections between routers and hosts
	-->
	<xsl:template match="/">

		<xsl:variable name="temp-result">

			<ned-file filename="test.ned" version="1.0">
				<package name="simulations">
					<comment locid="right" content="&amp;#10;&amp;#10;" />
				</package>
				
<!-- 				<import import-spec="inet.base.LifecycleController" /> -->
<!-- 				<import import-spec="inet.linklayer.ethernet.EtherHub" /> -->
<!-- 				<import import-spec="inet.networklayer.autorouting.ipv4.IPv4NetworkConfigurator" /> -->
<!-- 				<import import-spec="inet.nodes.inet.StandardHost" /> -->
<!-- 				<import import-spec="inet.nodes.ospfv2.OSPFRouter" /> -->
<!-- 				<import import-spec="inet.util.ThruputMeteringChannel" /> -->
<!-- 				<import import-spec="inet.world.scenario.ScenarioManager"> -->
<!-- 					<comment locid="right" content="&amp;amp;#10;&amp;amp;#10;&amp;amp;#10;" /> -->
<!-- 				</import> -->
				<import import-spec="inet.common.lifecycle.LifecycleController" />
				<import import-spec="inet.linklayer.ethernet.EtherHub" />
				<import import-spec="inet.networklayer.configurator.ipv4.IPv4NetworkConfigurator" />
				<import import-spec="inet.node.inet.StandardHost" />
				<import import-spec="inet.node.ospfv2.OSPFRouter" />
				<import import-spec="inet.common.misc.ThruputMeteringChannel" />
				<import import-spec="inet.common.scenario.ScenarioManager">
					<comment locid="right" content="&amp;amp;#10;&amp;amp;#10;&amp;amp;#10;" />
				</import>
				<compound-module name="CIM_network">
					<parameters>
						<property is-implicit="true" name="isNetwork" />
						<property name="display">
							<property-key>
								<!-- @display("p=10,10;b=712,152;bgb=2320,1293"); 698,309 -->
								<literal type="string" text="&quot;p=10,10;b=712,152;bgb=2320,1293&quot;" value="p=10,10;b=712,152;bgb=2320,1293" />
							</property-key>
						</property>
					</parameters>
					<types>
						<channel name="{$ethernet_channel}">
							<extends name="ThruputMeteringChannel" />
							<!-- <parameters is-implicit="true"> <param name="delay"> <expression
								target="value"> <literal type="quantity" text="0.1us" value="0.1us"
								/> </expression>
								</param> <param name="datarate"> <expression target="value"> <literal
								type="quantity"
								text="100Mbps" value="100Mbps" /> </expression> </param> <param name="thruputDisplayFormat">
								<expression target="value"> <literal type="string" text="&quot;#N&quot;"
								value="#N" /> </expression> </param> </parameters> -->
							<parameters is-implicit="true">
								<param name="datarate">
									<expression target="value">
										<literal type="quantity" text="1Gbps" value="1Gbps" />
									</expression>
								</param>
								<param name="thruputDisplayFormat">
									<expression target="value">
										<literal type="string" text="&quot;#N&quot;" value="#N" />
									</expression>
								</param>
								<param type="double" name="distance">
									<property name="unit">
										<property-key>
											<literal type="spec" text="{$DEFAULT_DISTANCE_UNIT}" value="{$DEFAULT_DISTANCE_UNIT}" />
										</property-key>
									</property>
								</param>
								<param name="delay">
									<expression target="value">
										<operator name="*">
											<operator name="/">
												<ident module="this" name="distance" />
												<literal type="quantity" text="200000km" value="200000km" />
											</operator>
											<literal type="quantity" text="1s" value="1s" />
										</operator>
									</expression>
								</param>
								<param name="per">
									<expression target="value">
										<literal type="int" text="0" value="0" />
									</expression>
								</param>
								<param name="ber">
									<expression target="value">
										<literal type="int" text="0" value="0" />
									</expression>
								</param>
							</parameters>
						</channel>
						<channel name="{$fibre_optic_channel}">
							<extends name="ThruputMeteringChannel" />
							<parameters is-implicit="true">
								<param name="datarate">
									<expression target="value">
										<literal type="quantity" text="100Gbps" value="100Gbps" />
									</expression>
								</param>
								<param name="thruputDisplayFormat">
									<expression target="value">
										<literal type="string" text="&quot;#N&quot;" value="#N" />
									</expression>
								</param>
								<param type="double" name="distance">
									<property name="unit">
										<property-key>
											<literal type="spec" text="{$DEFAULT_DISTANCE_UNIT}" value="{$DEFAULT_DISTANCE_UNIT}" />
										</property-key>
									</property>
								</param>
								<param name="delay">
									<expression target="value">
										<operator name="*">
											<operator name="/">
												<ident module="this" name="distance" />
												<literal type="quantity" text="300000km" value="300000km" />
											</operator>
											<!-- TODO -->
											<literal type="quantity" text="1s" value="1s" />
										</operator>
									</expression>
								</param>
								<param name="per">
									<expression target="value">
										<literal type="int" text="0" value="0" />
									</expression>
								</param>
								<param name="ber">
									<expression target="value">
										<literal type="int" text="0" value="0" />
									</expression>
								</param>
							</parameters>
						</channel>
					</types>

					<submodules>

						<submodule name="configurator" type="IPv4NetworkConfigurator">
							<parameters>
								<param name="addStaticRoutes">
									<expression target="value">
										<literal type="bool" text="true" value="true" />
									</expression>
								</param>
								<param name="addDefaultRoutes">
									<expression target="value">
										<literal type="bool" text="false" value="false" />
									</expression>
								</param>
								<property name="display">
									<property-key>
										<literal type="string" text="&quot;p=56,43&quot;" value="p=56,43" />
									</property-key>
								</property>
							</parameters>
						</submodule>

						<!-- <submodule name="scenarioManager" type="ScenarioManager"> <parameters
							is-implicit="true"> <property name="display"> <property-key> <literal
							type="string"
							text="&quot;p=136,20&quot;" value="p=136,20" /> </property-key> </property>
							</parameters> </submodule> <submodule name="lifecycleController" type="LifecycleController">
							<parameters is-implicit="true"> <property name="display"> <property-key>
							<literal type="string" text="&quot;p=208,43&quot;" value="p=208,43"
							/> </property-key>
							</property> </parameters> </submodule> -->

						<!-- Control center host -->
						<submodule name="{$cc_host_id}" type="StandardHost">
							<gates>
								<gate name="ethg" is-vector="true">
									<expression target="vector-size">
										<literal type="int" text="1" value="1" />
									</expression>
								</gate>
							</gates>
						</submodule>

						<!-- Control center router -->
						<submodule name="{$cc_router_id}" type="OSPFRouter">
							<parameters>
								<param name="hasStatus">
									<expression target="value">
										<literal type="bool" text="true" value="true" />
									</expression>
								</param>
							</parameters>
							<gates>
								<gate name="ethg" is-vector="true">
									<expression target="vector-size">
										<literal type="int" text="{$MAX_ETH_PORTS}" value="{$MAX_ETH_PORTS}" />
									</expression>
								</gate>
							</gates>
						</submodule>

						<!-- ce create hosts -->
						<xsl:apply-templates mode="c2n:CreateEquipmentHosts" />

						<!-- create router -->
						<xsl:apply-templates mode="c2n:VoltageLevelSubRouterNodes" />
						<xsl:apply-templates mode="c2n:Substations" />
						<xsl:apply-templates mode="c2n:VoltageLevel" />

					</submodules>

					<connections>

						<!-- Control center connection -->
						<connection src-module="{$cc_host_id}" src-gate="ethg" src-gate-plusplus="true" dest-module="_0000_cc_router" dest-gate="ethg" dest-gate-plusplus="true" type="{$ethernet_channel}"
							is-bidirectional="true">
							<parameters is-implicit="true">
								<param name="distance">
									<expression target="value">
										<literal type="quantity" text="{concat(0.1, $DEFAULT_DISTANCE_UNIT)}" value="{concat(0.1, $DEFAULT_DISTANCE_UNIT)}" />
									</expression>
								</param>
							</parameters>
						</connection>

						<xsl:apply-templates mode="c2n:cc_router_substation" />

						<xsl:apply-templates mode="c2n:substation_voltagelevel" />

						<!-- TODO -->
						<xsl:apply-templates mode="c2n:VoltageLevelRouter_SubRouter" />
						<xsl:apply-templates mode="c2n:voltagelevels_voltagelevels" />

						<!-- connect ce hosts to routers -->
						<xsl:apply-templates mode="c2n:CEHostsConnections" />

					</connections>
				</compound-module>
			</ned-file>

		</xsl:variable>

		<xsl:apply-templates select="$temp-result" mode="c2n:finalize" />

		<!-- uncomment for testing purposes -->
		<!-- <xsl:apply-templates mode="c2n:test_helper_functions" /> -->

	</xsl:template>

	<xsl:template match="@*|node()" mode="c2n:finalize">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="c2n:finalize" />
		</xsl:copy>
	</xsl:template>


	<!-- ignore everything else -->
	<xsl:template match="*/text()" mode="c2n:test_helper_functions" />
	<xsl:template match="*/text()" mode="c2n:CreateEquipmentHosts" />
	<xsl:template match="*/text()" mode="c2n:Terminal_1" />
	<xsl:template match="*/text()" mode="c2n:VoltageLevel" />
	<xsl:template match="*/text()" mode="c2n:SwitchConnection" />
	<xsl:template match="*/text()" mode="c2n:SwitchConnection_TERMINAL" />
	<xsl:template match="*/text()" mode="c2n:TopologicalNodes" />
	<xsl:template match="*/text()" mode="c2n:VoltageLevelRouter_BayRouter" />
	<xsl:template match="*/text()" mode="c2n:BayRouter_Hosts" />
	<xsl:template match="*/text()" mode="c2n:VoltageLevelConnections" />
	<xsl:template match="*/text()" mode="c2n:Substations" />
	<xsl:template match="*/text()" mode="c2n:cc_router_substation" />
	<xsl:template match="*/text()" mode="c2n:voltagelevels_voltagelevels" />
	<xsl:template match="*/text()" mode="c2n:substation_voltagelevel" />
	<xsl:template match="*/text()" mode="c2n:CEHostsConnections" />
	<xsl:template match="*/text()" mode="c2n:ACLineHostsConnections" />
	<xsl:template match="*/text()" mode="c2n:substations_connections_rec" />
	<xsl:template match="*/text()" mode="c2n:substations_hosts" />

</xsl:transform>