package test;

public class A {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		
		String nickname = "我是谁！";
		
		StringBuilder sb = new StringBuilder();  //简单加密过后的nickname
		for(char c:nickname.toCharArray()) {
			int x = c;
			sb.append((int)c + "&");
		}
		
		String[] sss = sb.toString().split("&");
		StringBuilder bs = new StringBuilder();
		for(String str:sss) {
			int x = Integer.valueOf(str);
			char c = (char)x;
			bs.append(c);
		}
		System.out.println(bs);

	}
}