<!-- This files contains the templates for creating the network elements 
	like hosts and routers. For every (conducting) equipment in the CIM one host 
	is created. Routers are created for substations and voltagelevels. One voltagelevel 
	connects to a number of (sub-)routers that are connected to max. MAX_CES 
	hosts. -->
<!-- xmlns:cim="http://iec.ch/TC57/2009/CIM-schema-cim14#"-->
<xsl:transform version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:html="http://www.w3.org/1999/xhtml"
	 xmlns:cim="http://iec.ch/TC57/2013/CIM-schema-cim16#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:c2n="http://tu-dortmund/ie3/cim2ned"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">

	<!-- host -->
	<xsl:template match="rdf:RDF" mode="c2n:CreateEquipmentHosts">
		<xsl:for-each select="$c2n_all_clients">
			<submodule name="{substring-before(current()/@c2n:id,';')}"
				type="StandardHost">
				<gates>
					<gate name="ethg" is-vector="true">
						<expression target="vector-size">
							<literal type="int" text="1" value="1" />
						</expression>
					</gate>
				</gates>
			</submodule>
		</xsl:for-each>
	</xsl:template>


	<!-- router -->
	<xsl:template match="rdf:RDF" mode="c2n:VoltageLevel">
		<!-- TODO hier vielleicht wieder prüfen ob voltagelevel überhaupt benötigt, daher ob was dran hängt-->
		<xsl:for-each select="$c2n_all_voltagelevel">
			<submodule name="{current()/@rdf:ID}"
				type="OSPFRouter">
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
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="rdf:RDF" mode="c2n:Substations">
		<xsl:for-each select="$c2n_all_substations">
			<submodule name="{current()/@rdf:ID}"
				type="OSPFRouter">
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
			
			<submodule name="{current()/@rdf:ID}_pc"
				type="StandardHost">
				<gates>
					<gate name="ethg" is-vector="true">
						<expression target="vector-size">
							<literal type="int" text="1" value="1" />
						</expression>
					</gate>
				</gates>
			</submodule>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="rdf:RDF" mode="c2n:VoltageLevelSubRouterNodes">

		<xsl:for-each-group select="$c2n_all_equipment"	group-by="c2n:TargetRouter/@c2n:id">

			<xsl:variable name="ces" as="node()*" select="$c2n_all_equipment/c2n:TargetRouter[@c2n:id = current-grouping-key()]/.." />

			<xsl:for-each select="$ces">

				<xsl:if test="(position() - 1) mod $MAX_CES = 0">
					<submodule
						name="{concat(current-grouping-key(), '_', floor((position() - 1) div $MAX_CES))}"
						type="OSPFRouter">
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
				</xsl:if>

			</xsl:for-each>


		</xsl:for-each-group>
	</xsl:template>


</xsl:transform>