<!-- Contains constants and helper functions. -->
<!-- xmlns:cim="http://iec.ch/TC57/2009/CIM-schema-cim14#"-->
<xsl:transform version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns:cim="http://iec.ch/TC57/2013/CIM-schema-cim16#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:c2n="http://tu-dortmund/ie3/cim2ned"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:md="http://iec.ch/TC57/61970-552/ModelDescription/1#">


	<!-- Control center host id -->
	<xsl:variable name="cc_host_id" select="'_0000_cc_host'"
		as="xs:string" />

	<!-- Control center router id -->
	<xsl:variable name="cc_router_id" select="'_0000_cc_router'"
		as="xs:string" />

	<!-- Channels -->
	<xsl:variable name="ethernet_channel" select="'C'" as="xs:string" />
	<xsl:variable name="fibre_optic_channel" select="'Channel_1Gbps'"
		as="xs:string" />

	<!-- string of all equipment -->
	<xsl:variable name="equipmentstr" select="'cim:Switch,
		cim:Breaker,
		cim:ACLineSegment,
		cim:PowerTransformer,
		cim:ShuntCompensator,
		cim:EnergyConsumer,
		cim:SynchronousMachine,
		cim:GeneratingUnit'" />

	<!-- var holds all topological nodes -->
	<xsl:variable name="all_topo_nodes" as="node()*">
		<xsl:sequence select="/rdf:RDF/cim:TopologicalNode" />
	</xsl:variable>

	<!-- var holds all connectivity nodes -->
	<xsl:variable name="all_conn_nodes" as="node()*">
		<xsl:sequence select="/rdf:RDF/cim:ConnectivityNode" />
	</xsl:variable>
	
	<!-- var holds all terminals -->
	<xsl:variable name="all_terminals" as="node()*">
		<xsl:sequence select="/rdf:RDF/cim:Terminal" />
	</xsl:variable>

	<!-- var holds all aclines -->
	<xsl:variable name="all_aclinesegments" as="node()*">
		<xsl:sequence select="/rdf:RDF/cim:ACLineSegment" />
	</xsl:variable>

	<!-- var holds all c2n equipment meta markers -->
	<xsl:variable name="c2n_all_equipment"
		select="/rdf:RDF/*/c2n:Meta[@c2n:type='equipment']/.." as="node()*" />
		
	<!-- var holds all c2n client hosts of equipment -->
	<xsl:variable name="c2n_all_clients"
		select="/rdf:RDF/*/c2n:Client" as="node()*" />
	
	<!-- var holds all substations -->
	<xsl:variable name="c2n_all_substations" select="/rdf:RDF/cim:Substation" as="node()*" />

	<!-- var holds all voltage level -->
	<xsl:variable name="c2n_all_voltagelevel" as="node()*">
		<xsl:sequence select="/rdf:RDF/cim:VoltageLevel" />
	</xsl:variable>

<!-- <xsl:variable name="c2n_all_voltagelevel" as="node()*"> !!!CIM14 needs c2n:TargetRouter
		<xsl:sequence
			select=" 
			for $t in /rdf:RDF/cim:VoltageLevel 
				return (
					if (count($c2n_all_equipment[c2n:TargetRouter/@c2n:id = $t/@rdf:ID]) &gt; 0)
					then ($t) 
					else () 
					)
		" />
	</xsl:variable>  -->

	<!-- Helper functions -->


	<xsl:function name="c2n:isTerminalInSub">
		<xsl:param name="terminal" />
		<xsl:param name="sub" />
		<xsl:sequence
			select="if ($c2n_all_voltagelevel[@rdf:ID = $terminal/c2n:VoltageLevel/@c2n:id]/cim:VoltageLevel.Substation/@rdf:resource = $sub/@rdf:ID
				)
			then true()
			else false()" />
	</xsl:function>

 	<xsl:function name="c2n:getACLineLength">
		<xsl:param name="sub1" />
		<xsl:param name="sub2" />
		<xsl:sequence
			select="max (
			for $a in $all_aclinesegments return (
				if (
					(($sub1/@rdf:ID = $a/c2n:Substation/@c2n:id) and ($sub2/@rdf:ID = $a/c2n:Substation2/@c2n:id)) or
					(($sub1/@rdf:ID = $a/c2n:Substation2/@c2n:id) and ($sub2/@rdf:ID = $a/c2n:Substation/@c2n:id))
				)
				then $a/cim:Conductor.length 
				else ($DEFAULT_INTER_SUBSTATION_DISTANCE)
			) )
			" />
	</xsl:function>
	
	<xsl:function name="c2n:getACLineLengthById">
		<xsl:param name="sub1Id" />
		<xsl:param name="sub2Id" />
		<xsl:sequence
			select="max (
			for $seg in $all_aclinesegments return (
				if (
					(($sub1Id = $seg/c2n:Substation/@c2n:id) and ($sub2Id = $seg/c2n:Substation/@c2n:id)) or
					(($sub1Id = $seg/c2n:Substation/@c2n:id) and ($sub2Id = $seg/c2n:Substation/@c2n:id))
				)
				then $seg/cim:Conductor.length 
				else ($DEFAULT_INTER_SUBSTATION_DISTANCE)
			) )
			" />
	</xsl:function>
	
	<!-- (($sub1/@rdf:ID = $a/c2n:Substation/@c2n:id) and ($sub2/@rdf:ID = $a/c2n:Substation2/@c2n:id)) or -->
	<xsl:function name="c2n:connected">
		<xsl:param name="sub1" />
		<xsl:param name="sub2" />
		<xsl:sequence
			select="max (
			for $a in $all_aclinesegments return (
				if (
					
					(($sub1/@rdf:ID = $a/c2n:Substation/@c2n:id) and ($sub2/@rdf:ID = $a/c2n:Substation/@c2n:id))
				)
				then true() 
				else (false())
			) )
				   " />
	</xsl:function>
	
	<xsl:template match="rdf:RDF" mode="c2n:test_helper_functions">
		<helper_function_test>
			<!-- <c2neqip size="{count($c2n_all_equipment)}" /> -->
			<xsl:for-each select="$all_aclinesegments">
				<e id="{current()/@rdf:ID}" sub_id="{current()/c2n:Substation/@c2n:id}" sub2_id="{current()/c2n:Substation2/@c2n:id}" len="{current()/cim:Conductor.length}" />
			</xsl:for-each>

			<xsl:for-each select="$c2n_all_substations">
				<xsl:variable name="outer" select="current()" />
				<xsl:variable name="i" select="position()" />
				<xsl:for-each select="$c2n_all_substations">
					
					<dist id1="{$outer/@rdf:ID}" id2="{current()/@rdf:ID}" l="{c2n:getACLineLength($outer, current())}"/>
				</xsl:for-each>
			</xsl:for-each>
		</helper_function_test>
	</xsl:template>

</xsl:transform>