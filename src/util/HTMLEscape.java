package util;

public class HTMLEscape {
	
	private String str;
	
	public HTMLEscape(String str) {
		this.str = str;
	}
	
	public String escape() {
		str = this.cleanXSS();
		str = this.format();
		return str;
	}
	
	private String cleanXSS() {
		str = str.replace("&", "&amp;");
		str = str.replace("<", "&lt;");
		str = str.replace(">", "&gt;");
		str = str.replace("\"", "&quot;");
		str = str.replace("/", "&#x2F;");
		str = str.replaceAll("script", "\u0073\u0063\u0072\u0069\u0070\u0074");
		return str;
	}
	
	private String format() {
		str = str.replaceAll(" ", "&nbsp;");
		str = str.replaceAll("\n", "<br />");
		return str;
	}

}