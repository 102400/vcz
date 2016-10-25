package rule;

public class Nickname {
	
	private String username;
	private char[] c_username;
	
	public Nickname(String username) {
		this.username = username;
		this.c_username = username.toCharArray();
	}
	
	public boolean isLegal() {
		
		if(c_username.length>16||c_username.length<1) {
			return false;
		}
		
		return true;
	}

}
