<!-- This file contains templates that connect routers corresponding to the
	substations into a circular network. The voltagelevel routers are connected
	to the substations in this circle. -->
<!-- xmlns:cim="http://iec.ch/TC57/2009/CIM-schema-cim14#"-->
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:html="http://www.w3.org/1999/xhtml" 
	xmlns:cim="http://iec.ch/TC57/2013/CIM-schema-cim16#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:c2n="http://tu-dortmund/ie3/cim2ned"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">


	<!-- This template connects the control center router to one substation
		and triggers the creation of the ring of connected substations. Finally
		all substations that are connected via an aclinesegment are connected with a
		channel of length given by the aclinesegment. -->
	<xsl:template match="rdf:RDF" mode="c2n:cc_router_substation">
		<connection src-module="{$cc_router_id}" src-gate="ethg" src-gate-plusplus="true" dest-module="{$c2n_all_substations[1]/c2n:RouterName/@c2n:value}" dest-gate="ethg" dest-gate-plusplus="true"
			type="{$INTER_SUBSTATION_CHANNEL}" is-bidirectional="true">
			<parameters is-implicit="true">
				<param name="distance">
					<expression target="value">
						<literal type="quantity" text="{concat(0.1, $DEFAULT_DISTANCE_UNIT)}" value="{concat(0.1, $DEFAULT_DISTANCE_UNIT)}" />
					</expression>
				</param>
			</parameters>
		</connection>

<!-- 	<connection src-module="{$cc_router_id}" src-gate="ethg" dest-module="{$c2n_all_substations[1]/c2n:RouterName/@c2n:value}" dest-gate="ethg"
			type="{$INTER_SUBSTATION_CHANNEL}" is-bidirectional="true">
			<expression target="src-gate-index">
				<literal type="int" text="1" value="1" />
			</expression>
			<expression target="dest-gate-index">
				<literal type="int" text="4" value="4" />
			</expression>
			<parameters is-implicit="true">
				<param name="distance">
					<expression target="value">
						<literal type="quantity" text="{concat(10, $DEFAULT_DISTANCE_UNIT)}" value="{concat(10, $DEFAULT_DISTANCE_UNIT)}" />
					</expression>
				</param>
			</parameters>
		</connection> -->

		<!-- <xsl:apply-templates mode="c2n:substations_neighbours_connection" /> -->

		<xsl:for-each select="/rdf:RDF/c2n:NetworkInformation/c2n:RouterConnection">
<!-- 		<connection src-module="{current()/@c2n:id1}" src-gate="ethg" dest-module="{current()/@c2n:id2}" dest-gate="ethg" type="{$INTER_SUBSTATION_CHANNEL}"
				is-bidirectional="true">
				<expression target="src-gate-index">
					<literal type="int" text="{8 + current()/@c2n:port1}" value="{8 + current()/@c2n:port1}" />
				</expression>
				<expression target="dest-gate-index">
					<literal type="int" text="{8 + current()/@c2n:port2}" value="{8 + current()/@c2n:port2}" />
				</expression>
				<parameters is-implicit="true">
					<param name="distance">
						<expression target="value">
							<literal type="quantity" text="{concat(current()/@c2n:length * $DEFAULT_SUBSTATION_DISTANCE_FACTOR, $DEFAULT_DISTANCE_UNIT)}" value="{concat(current()/@c2n:length * $DEFAULT_SUBSTATION_DISTANCE_FACTOR, $DEFAULT_DISTANCE_UNIT)}" />
						</expression>
					</param>
				</parameters>
			</connection> -->
			<connection src-module="{current()/@c2n:id1}" src-gate="ethg" src-gate-plusplus="true" dest-module="{current()/@c2n:id2}" dest-gate="ethg" dest-gate-plusplus="true" 
				type="{$INTER_SUBSTATION_CHANNEL}" is-bidirectional="true">
				<parameters is-implicit="true">
					<param name="distance">
						<expression target="value">
							<literal type="quantity" text="{concat(current()/@c2n:length * $DEFAULT_SUBSTATION_DISTANCE_FACTOR, $DEFAULT_DISTANCE_UNIT)}" value="{concat(current()/@c2n:length * $DEFAULT_SUBSTATION_DISTANCE_FACTOR, $DEFAULT_DISTANCE_UNIT)}" />
						</expression>
					</param>
				</parameters>
			</connection>
		</xsl:for-each>

	<xsl:apply-templates mode="c2n:substations_hosts" />
	
	</xsl:template>


	<!-- <xsl:template match="rdf:RDF/cim:Substation" mode="c2n:substations_neighbours_connection">
		<xsl:variable select="current()" name="sub"/>
		<xsl:for-each select="current()/c2n:NeighbourRouter">
		<connection src-module="{$sub/@rdf:ID}" src-gate="ethg" dest-module="{current()/@c2n:id}"
		dest-gate="ethg" type="{$INTER_SUBSTATION_CHANNEL}" is-bidirectional="true">
		<expression target="src-gate-index">
		<literal type="int" text="{6 + position()}" value="{6 + position()}" />
		</expression>
		<expression target="dest-gate-index">
		<literal type="int" text="{12 + position()}" value="{12 + position()}" />
		</expression>
		<parameters is-implicit="true">
		<param name="distance">
		<expression target="value">
		<literal type="quantity"
		text="{concat(c2n:getACLineLengthById($sub/@rdf:ID, current()/@c2n:id) * $DEFAULT_SUBSTATION_DISTANCE_FACTOR, $DEFAULT_DISTANCE_UNIT)}"
		value="{concat(c2n:getACLineLengthById($sub/@rdf:ID, current()/@c2n:id) * $DEFAULT_SUBSTATION_DISTANCE_FACTOR, $DEFAULT_DISTANCE_UNIT)}" />
		</expression>
		</param>
		</parameters>
		</connection>
		</xsl:for-each>
		</xsl:template> -->

<!--	<xsl:template match="rdf:RDF/cim:Substation" mode="c2n:substations_hosts">
		<connection src-module="{current()/@rdf:ID}" src-gate="ethg" dest-module="{current()/c2n:SubstationId/@c2n:value}" dest-gate="ethg" type="{$INTER_SUBSTATION_CHANNEL}"
			is-bidirectional="true">
			<expression target="src-gate-index">
				<literal type="int" text="7" value="7" />
			</expression>
			<expression target="dest-gate-index">
				<literal type="int" text="0" value="0" />
			</expression>
			<parameters is-implicit="true">
				<param name="distance">
					<expression target="value">
						<literal type="quantity"
							text="{concat($DEFAULT_SUBSTATION_HOST_DISTANCE_FACTOR, $DEFAULT_DISTANCE_UNIT)}" value="{concat($DEFAULT_SUBSTATION_HOST_DISTANCE_FACTOR, $DEFAULT_DISTANCE_UNIT)}" />
					</expression>
				</param>
			</parameters>
		</connection>
	</xsl:template>  -->

	<xsl:template match="rdf:RDF/cim:Substation" mode="c2n:substations_hosts">
		<connection src-module="{current()/@rdf:ID}" src-gate="ethg" src-gate-plusplus="true" dest-module="{current()/@rdf:ID}_pc" dest-gate="ethg" dest-gate-plusplus="true" type="{$SUBSTATION_VOLTAGELEVEL_CHANNEL}"
			is-bidirectional="true">
			<parameters is-implicit="true">
				<param name="distance">
					<expression target="value">
						<literal type="quantity"
							text="{concat($DEFAULT_SUBSTATION_HOST_DISTANCE_FACTOR, $DEFAULT_DISTANCE_UNIT)}" value="{concat($DEFAULT_SUBSTATION_HOST_DISTANCE_FACTOR, $DEFAULT_DISTANCE_UNIT)}" />
					</expression>
				</param>
			</parameters>
		</connection>
	</xsl:template>
	
	<!-- Connect substations as ring iff there is at least one equipment connected
		to a voltagelevel of this substation. -->
	<xsl:template match="rdf:RDF" name="c2n:substations_ring">
		<xsl:param name="i" select="1" />

		<!-- recurvive call if there are still substations to visit -->
		<xsl:if test="$i &lt; count($c2n_all_substations)">
			<xsl:call-template name="c2n:substations_ring">
				<xsl:with-param name="i" select="$i+1" />
			</xsl:call-template>
		</xsl:if>

		<!-- create connection -->
<!-- 	<connection src-module="{$c2n_all_substations[$i]/@rdf:ID}" src-gate="ethg"
			dest-module="{$c2n_all_substations[($i mod count($c2n_all_substations)+1)]/@rdf:ID}" dest-gate="ethg" type="{$INTER_SUBSTATION_CHANNEL}"
			is-bidirectional="true">
			<expression target="src-gate-index">
				<literal type="int" text="2" value="2" />
			</expression>
			<expression target="dest-gate-index">
				<literal type="int" text="3" value="3" />
			</expression>
			<parameters is-implicit="true">
				<param name="distance">
					<expression target="value">
						<literal type="quantity"
							text="{concat(c2n:getACLineLength($c2n_all_substations[$i], $c2n_all_substations[($i mod count($c2n_all_substations)+1)]) * $DEFAULT_SUBSTATION_DISTANCE_FACTOR, $DEFAULT_DISTANCE_UNIT)}"
							value="{concat(c2n:getACLineLength($c2n_all_substations[$i], $c2n_all_substations[($i mod count($c2n_all_substations)+1)]) * $DEFAULT_SUBSTATION_DISTANCE_FACTOR, $DEFAULT_DISTANCE_UNIT)}" />
					</expression>
				</param>
			</parameters>
		</connection>
	</xsl:template>  -->

	<connection src-module="{$c2n_all_substations[$i]/@rdf:ID}" src-gate="ethg" src-gate-plusplus="true"
			dest-module="{$c2n_all_substations[($i mod count($c2n_all_substations)+1)]/@rdf:ID}" dest-gate="ethg" dest-gate-plusplus="true" type="{$INTER_SUBSTATION_CHANNEL}"
			is-bidirectional="true">
			<parameters is-implicit="true">
				<param name="distance">
					<expression target="value">
						<literal type="quantity"
							text="{concat(c2n:getACLineLength($c2n_all_substations[$i], $c2n_all_substations[($i mod count($c2n_all_substations)+1)]) * $DEFAULT_SUBSTATION_DISTANCE_FACTOR, $DEFAULT_DISTANCE_UNIT)}"
							value="{concat(c2n:getACLineLength($c2n_all_substations[$i], $c2n_all_substations[($i mod count($c2n_all_substations)+1)]) * $DEFAULT_SUBSTATION_DISTANCE_FACTOR, $DEFAULT_DISTANCE_UNIT)}" />
					</expression>
				</param>
			</parameters>
		</connection>
	</xsl:template>

	<!-- connect substations and voltagelevel -->
	<xsl:template match="rdf:RDF" mode="c2n:substation_voltagelevel">
		<!-- <comment locid="banner" content="// Substation to voltagelevel &#10;"/> -->
		<xsl:for-each-group select="$c2n_all_voltagelevel" group-by="cim:VoltageLevel.Substation/@rdf:resource">

			<xsl:for-each select="$c2n_all_voltagelevel/cim:VoltageLevel.Substation[@rdf:resource = current-grouping-key()]/..">

<!-- 			<connection src-module="{current()/@rdf:ID}" src-gate="ethg" dest-module="{current-grouping-key()}" dest-gate="ethg"
					type="{$SUBSTATION_VOLTAGELEVEL_CHANNEL}" is-bidirectional="true">
					<expression target="src-gate-index">
						<literal type="int" text="1" value="1" />
					</expression>
					<expression target="dest-gate-index">
						<literal type="int" text="{-1+position()}" value="{-1+position()}" />
					</expression>
					<parameters is-implicit="true">
						<param name="distance">
							<expression target="value">
								<literal type="quantity" text="{concat($DEFAULT_SUBSTATION_VOLTAGELEVEL_DISTANCE, $DEFAULT_DISTANCE_UNIT)}" value="{concat($DEFAULT_SUBSTATION_VOLTAGELEVEL_DISTANCE, $DEFAULT_DISTANCE_UNIT)}" />
							</expression>
						</param>
					</parameters>
				</connection>  -->

				<connection src-module="{current()/@rdf:ID}" src-gate="ethg" src-gate-plusplus="true" dest-module="{current-grouping-key()}" dest-gate="ethg" dest-gate-plusplus="true"
					type="{$SUBSTATION_VOLTAGELEVEL_CHANNEL}" is-bidirectional="true">
					<parameters is-implicit="true">
						<param name="distance">
							<expression target="value">
								<literal type="quantity" text="{concat($DEFAULT_SUBSTATION_VOLTAGELEVEL_DISTANCE, $DEFAULT_DISTANCE_UNIT)}" value="{concat($DEFAULT_SUBSTATION_VOLTAGELEVEL_DISTANCE, $DEFAULT_DISTANCE_UNIT)}" />
							</expression>
						</param>
					</parameters>
				</connection>
			</xsl:for-each>
		</xsl:for-each-group>
	</xsl:template>


	<!-- create connections between VoltageLevel Router and its subrouters -->
	<xsl:template match="rdf:RDF" mode="c2n:VoltageLevelRouter_SubRouter">
		<!-- <comment locid="banner" content="// VoltageLevel to SubVoltageLevelRouter &#10;"/> -->

		<xsl:for-each-group select="$c2n_all_equipment" group-by="c2n:TargetRouter/@c2n:id">

			<xsl:variable name="ces" as="node()*" select="$c2n_all_equipment/c2n:TargetRouter[@c2n:id = current-grouping-key()]/.." />

			<xsl:for-each select="$ces">

				<xsl:variable name="pos" select="position()-1" />

				<xsl:if test="$pos mod $MAX_CES = 0">
					<xsl:variable name="node2" select="floor($pos div $MAX_CES)" />
					<connection src-module="{concat(current-grouping-key(), '_', $node2)}" src-gate="ethg" src-gate-plusplus="true" dest-module="{current-grouping-key()}"
						dest-gate="ethg" dest-gate-plusplus="true" type="{$VOLTAGELEVEL_GROUP_CHANNEL}" is-bidirectional="true">
						<parameters is-implicit="true">
							<param name="distance">
								<expression target="value">
									<literal type="quantity" text="{concat($DEFAULT_INTER_VOLTAGELEVEL_DISTANCE, $DEFAULT_DISTANCE_UNIT)}" value="{concat($DEFAULT_INTER_VOLTAGELEVEL_DISTANCE, $DEFAULT_DISTANCE_UNIT)}" />
								</expression>
							</param>
						</parameters>
					</connection>
				</xsl:if>

			</xsl:for-each>


		</xsl:for-each-group>
	</xsl:template>

</xsl:transform>