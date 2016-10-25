package rule;

public class Password {

	private String password;
	private char[] c_password;
	
	public Password(String password) {
		this.password = password;
		this.c_password = password.toCharArray();
	}
	
	public boolean isLegal() {
		
		if(c_password.length>16||c_password.length<6) {
			return false;
		}
		
		for(int i=0;i<c_password.length;i++) {
			/**
			 * 数字,大写字母,小写字母
			 * 48-57,65-90,97-122
			 */
			int temp = c_password[i];
			if(!((temp>=48&&temp<=57)||(temp>=65&&temp<=90)||(temp>=97&&temp<=122))) {  //不在此范围里
				return false;
			}
		}
		
		return true;
	}

}