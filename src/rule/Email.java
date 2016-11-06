package rule;

public class Email {
	
	private String email;
	private char[] c_email;
	
	private int at_count = 0;  //@计数
	private int dot_count = 0;  //.计数
	
	public Email(String email) {
		this.email = email;
		this.c_email = email.toCharArray();
	}
	
	public boolean isLegal() {
		
		if(c_email.length>64||c_email.length<5) {
			return false;
		}
		
		for(int i=0;i<c_email.length;i++) {
			/**
			 * 数字,大写字母,小写字母...
			 * 48-57,65-90,97-122
			 */
			int temp = c_email[i];
			if(!((temp>=48&&temp<=57)||(temp>=65&&temp<=90)||(temp>=97&&temp<=122))) {  //不在此范围里
				if(temp=='.') {
					dot_count++;
					continue;
				}
				if(temp=='-') {
					continue;
				}
				if(temp=='@') {
					at_count++;
					continue;
				}
				else {
					return false;
				}
			}
		}
		
		if(at_count!=1) {
			return false;
		}
		if(dot_count<1) {
			return false;
		}
		
		return true;
	}

}
