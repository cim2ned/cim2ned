package de.tudo.for1511.ie3.cimned.main;

import java.io.File;
import java.io.IOException;
import java.net.URISyntaxException;

import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

public class CNXMain {

	/*DEBUG VARIABLES*/
	long start = 0;
	long stop = 0;

	String duration = "";
	
	private static final String TMPNAME = "output_tmp.xml";
		
	private void transform(String xsltFile, String inFile, String outFile) throws TransformerException {
		TransformerFactory factory = TransformerFactory.newInstance();
		Source xslt = new StreamSource(new File(xsltFile));
		Transformer transformer = factory.newTransformer(xslt);

		Source text = new StreamSource(new File(inFile));
		transformer.transform(text, new StreamResult(new File(outFile)));
	}
	
	private long preprocessCimXML(String inFile, String outFile) throws TransformerException {
		start=System.currentTimeMillis();
		transform("src/de/tudo/for1511/ie3/cimned/xslt/preprocess/c2n_preprocess_main_0.xslt", inFile, "output_0.xml");
//		stop=System.currentTimeMillis();
//		System.out.println("Transform 0 duration:" + String.valueOf(stop-start));
		System.out.println("Transform 0 finished.");
/*		start=System.currentTimeMillis();
		transform("src/de/tudo/for1511/ie3/cimned/xslt/preprocess/c2n_preprocess_main_0a.xslt", "output_0.xml", "output_0a.xml");
		stop=System.currentTimeMillis();
		System.out.println("Transform 0a duration:" + String.valueOf(stop-start));	*/
//		start=System.currentTimeMillis();
		transform("src/de/tudo/for1511/ie3/cimned/xslt/preprocess/c2n_preprocess_main_1.xslt", "output_0.xml", "output_1.xml");
//		stop=System.currentTimeMillis();
//		System.out.println("Transform 1 duration:" + String.valueOf(stop-start));
		System.out.println("Transform 1 finished.");
//		start=System.currentTimeMillis();
		transform("src/de/tudo/for1511/ie3/cimned/xslt/preprocess/c2n_preprocess_main_1a.xslt", "output_1.xml", "output_1a.xml");
//		stop=System.currentTimeMillis();
//		System.out.println("Transform 1a duration:" + String.valueOf(stop-start));
		System.out.println("Transform 1a finished.");
//		start=System.currentTimeMillis();
		transform("src/de/tudo/for1511/ie3/cimned/xslt/preprocess/c2n_preprocess_main_2.xslt", "output_1a.xml", "output_2.xml");
//		stop=System.currentTimeMillis();
//		System.out.println("Transform 2 duration:" + String.valueOf(stop-start));
		System.out.println("Transform 2 finished.");
//		start=System.currentTimeMillis();
		transform("src/de/tudo/for1511/ie3/cimned/xslt/preprocess/c2n_preprocess_main_2a.xslt", "output_2.xml", outFile);
//		stop=System.currentTimeMillis();
//		System.out.println("Transform 2a duration:" + String.valueOf(stop-start));
		System.out.println("Transform 2a finished.");
/*		start=System.currentTimeMillis();
		transform("src/de/tudo/for1511/ie3/cimned/xslt/preprocess/c2n_preprocess_main_2b.xslt", "output_2a.xml", "output_2b.xml");
		stop=System.currentTimeMillis();
		System.out.println("Transform 2b duration:" + String.valueOf(stop-start));
		start=System.currentTimeMillis();
		transform("src/de/tudo/for1511/ie3/cimned/xslt/preprocess/c2n_preprocess_main_3.xslt", "output_2b.xml", outFile);*/
		stop=System.currentTimeMillis();
		System.out.println("Transform 3 duration:" + String.valueOf(stop-start));
		return(stop-start);
	}

	private void createNedXML(String inFile, String outFile) throws TransformerException {
		transform("src/de/tudo/for1511/ie3/cimned/xslt/c2n_main.xslt", inFile, outFile);
	}

	private void createRouterConfigXML(String inFile, String outFile) throws TransformerException {
		transform("src/de/tudo/for1511/ie3/cimned/xslt/routerconfig/c2n_router_config_main.xslt", inFile, outFile);
	}
	
	public static void main(String[] args) throws IOException,
			URISyntaxException, TransformerException {
		
	
		CNXMain cnx = new CNXMain();
		
		String cim_input = "";
		String ned_output = "output.xml";
		String config_output = "ASConfig.xml";
		long result = 0;
		
		if (args.length == 0) {
			System.out.println("Usage: cnxmain [input cim filename] [output ned-xml filename]");
			System.exit(0);
		} else if (args.length >= 1) {
			cim_input = args[0];
		} 
		if (args.length >= 2) {
			ned_output = args[1];
		}

		System.out.println("Converting cim file (" + cim_input + ") to ned-xml file (" + ned_output + ").");
		
		System.setProperty("javax.xml.transform.TransformerFactory",    
		        "net.sf.saxon.TransformerFactoryImpl");
		
		String transformer = System.getProperty("javax.xml.transform.TransformerFactory");
		System.out.println("Using: " + transformer);

		// Step 1: Preprocessing
		System.out.println("Preprocessing cim input...");
		result = cnx.preprocessCimXML(cim_input, TMPNAME);
		System.out.println("done.");
		
		// Step 2: Ned xml generation
		System.out.print("Creating ned file...");
		long start = System.currentTimeMillis();
		cnx.createNedXML(TMPNAME, ned_output);
		long stop = System.currentTimeMillis();
		System.out.println("done (" + String.valueOf(stop-start) + ").");
		result += stop-start;
		// Step 3: Router config
		System.out.print("Creating router config file...");
		start = System.currentTimeMillis();
		cnx.createRouterConfigXML(TMPNAME, config_output);
		stop = System.currentTimeMillis();
		System.out.println("done (" + String.valueOf(stop-start) + ")");
		result += stop-start;
		System.out.println("Finished successfully. Elapsed Time: " + result);
	}

}
