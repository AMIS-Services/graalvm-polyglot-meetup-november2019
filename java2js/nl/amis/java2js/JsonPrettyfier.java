package nl.amis.java2js;

import java.io.*;
import java.util.stream.*;
import org.graalvm.polyglot.*;

public class JsonPrettyfier {

	public static void main(String[] args) throws java.io.IOException {
		BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
		String input = reader.lines().collect(Collectors.joining(System.lineSeparator()));
		System.out.println(prettyPrint(input));
	}

	private static String prettyPrint(String input) {
		try (Context context = Context.create("js")) {
			Value parse = context.eval("js", "JSON.parse");
			Value stringify = context.eval("js", "JSON.stringify");
			Value result = stringify.execute(parse.execute(input));
			return result.asString();
		}
	}
}
