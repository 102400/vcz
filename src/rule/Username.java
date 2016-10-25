package rule;

public class Username {
	
	private String username;
	private char[] c_username;
	
	public Username(String username) {
		this.username = username;
		this.c_username = username.toCharArray();
	}
	
	public boolean isLegal() {
		
		if(c_username.length>16||c_username.length<6) {
			return false;
		}
		
		for(int i=0;i<c_username.length;i++) {
			/**
			 * 数字,大写字母,小写字母
			 * 48-57,65-90,97-122
			 */
			int temp = c_username[i];
			if(!((temp>=48&&temp<=57)||(temp>=65&&temp<=90)||(temp>=97&&temp<=122))) {  //不在此范围里
				return false;
			}
		}
		
		return true;
	}

}
