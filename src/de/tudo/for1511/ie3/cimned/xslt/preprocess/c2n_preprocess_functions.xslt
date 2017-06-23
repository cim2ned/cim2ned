<?xml version="1.0" encoding="UTF-8"?>

<!-- Helperfunctions -->
<!-- xmlns:cim="http://iec.ch/TC57/2009/CIM-schema-cim14#"-->
<xsl:transform version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:html="http://www.w3.org/1999/xhtml"
	 xmlns:cim="http://iec.ch/TC57/2013/CIM-schema-cim16#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:c2n="http://tu-dortmund/ie3/cim2ned"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">

	<xsl:include href="../c2n_var_func.xslt" />

	<xsl:function name="c2n:getACLineSegmentTerminals">
		<xsl:param name="acl" />
		<xsl:sequence
			select="if (count($all_terminals/cim:Terminal.ConductingEquipment[@rdf:resource = $acl/@rdf:ID]/..) &gt; 1) 
			then $all_terminals/cim:Terminal.ConductingEquipment[@rdf:resource = $acl/@rdf:ID]/.. else ()" />
	</xsl:function>
	
	<xsl:function name="c2n:getEquipmentTerminals">
		<xsl:param name="equipment" />
		<xsl:sequence
			select="$all_terminals/cim:Terminal.ConductingEquipment[@rdf:resource = $equipment/@rdf:ID]/.." />
	</xsl:function>

	<xsl:function name="c2n:getACLineSegmentVoltageLevelId">
		<xsl:param name="aclinesegment" />
		<xsl:sequence
			select="(
			c2n:getVlOfTerminal_pp(c2n:getACLineSegmentTerminals($aclinesegment)[1]/@rdf:ID)/@rdf:ID,
			c2n:getVlOfTerminal_pp(c2n:getACLineSegmentTerminals($aclinesegment)[2]/@rdf:ID)/@rdf:ID
			)" />
	</xsl:function>

	<xsl:function name="c2n:getEquipmentVoltageLevelId">
		<xsl:param name="equipment" />
		<xsl:sequence
			select="c2n:getVlOfTerminal_pp(c2n:getEquipmentTerminals($equipment)[1]/@rdf:ID)/@rdf:ID" />
	</xsl:function>
	
	<xsl:function name="c2n:getVlOfTerminal_pp">
		<xsl:param name="terminal_id" />
		<xsl:sequence select="$c2n_all_voltagelevel[@rdf:ID = 
					$all_conn_nodes[@rdf:ID = 
					$all_terminals[@rdf:ID = $terminal_id]/cim:Terminal.ConnectivityNode/@rdf:resource]
						/cim:ConnectivityNode.ConnectivityNodeContainer/@rdf:resource]" />
	</xsl:function>

<!-- 	select="$c2n_all_voltagelevel[@rdf:ID = 
					$all_conn_nodes[@rdf:ID = 
					$all_terminals[@rdf:ID = $terminal_id]/cim:Terminal.ConnectivityNode/@rdf:resource]
						/cim:ConnectivityNode.ConnectivityNodeContainer/@rdf:resource]" />

<xsl:function name="c2n:getVlOfTerminal_pp"> !!!get voltage levels with help of topological nodes CIM14
		<xsl:param name="terminal_id" />
		<xsl:sequence
			select="$c2n_all_voltagelevel
			[@rdf:ID = $all_topo_nodes
									[@rdf:ID = $all_terminals[@rdf:ID = $terminal_id]/cim:Terminal.TopologicalNode/@rdf:resource]
						/cim:TopologicalNode.ConnectivityNodeContainer/@rdf:resource]" />
	</xsl:function>  -->

	<xsl:function name="c2n:has_equipment">
		<xsl:param name="substation_id" />
		<xsl:sequence
			select="count($c2n_all_equipment/c2n:Substation[@c2n:id = $substation_id]) &gt; 0" />
	</xsl:function>


</xsl:transform>