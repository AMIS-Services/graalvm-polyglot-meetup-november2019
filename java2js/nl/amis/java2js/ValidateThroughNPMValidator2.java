package nl.amis.java2js;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.graalvm.polyglot.*;

public class ValidateThroughNPMValidator2 {

	private Context c;
	// store JavaScript resource read from file (for example from JAR)
	private static String jsResource;
	static {
        System.out.println("Inside Static Initializer.");
		try {
			// load file validatorbundled.js from root of Java package structure aka root of
			// JAR archive file
			InputStream is = ValidateThroughNPMValidator2.class.getResourceAsStream("/validatorbundled.js");
			
			ByteArrayOutputStream result = new ByteArrayOutputStream();
			byte[] buffer = new byte[1024];
			int length;
			while ((length = is.read(buffer)) != -1) {
			    result.write(buffer, 0, length);
			}
			// StandardCharsets.UTF_8.name() > JDK 7
			jsResource = result.toString("UTF-8");
			
			is.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
        System.out.println("End Static Initializer.\n");
    }

	public ValidateThroughNPMValidator2() {
		// create Polyglot Context for JavaScript and load NPM module validator (bundled
		// as self contained resource)
		c = Context.create("js");
		c.eval("js",jsResource);
		System.out.println("All JavaScript functions now available from Java (as loaded into Bindings) "
				+ c.getBindings("js").getMemberKeys());
	}


	public Boolean isPostalCode(String postalCodeToValidate, String country) {
		// use validation function isPostalCode(str, locale) from NPM Validator Module
		// to validate postal code
		Value postalCodeValidator = c.getBindings("js").getMember("isPostalCode");
		Boolean postalCodeValidationResult = postalCodeValidator.execute(postalCodeToValidate, country).asBoolean();
		return postalCodeValidationResult;
	}

	public static void main(String[] args) {
		for(int i = 0; i < args.length; i++) {
            System.out.println("Args "+i+": "+args[i]);
        }
		ValidateThroughNPMValidator2 v = new ValidateThroughNPMValidator2();
		System.out.println("Postal Code Validation Result " + v.isPostalCode("3214 TT", "NL"));
		System.out.println("Postal Code Validation Result " + v.isPostalCode("XX 27165", "NL"));
	}

}
