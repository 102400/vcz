package servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class LogOut extends HttpServlet {
	
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Cookie user_id = new Cookie("user_id", "");
		Cookie nickname = new Cookie("nickname", "");
		Cookie verify = new Cookie("verify", "");
		
		user_id.setMaxAge(0);
		nickname.setMaxAge(0);
		verify.setMaxAge(0);
		
//		if(request.getCookies()!=null) {
//			Cookie[] cookies = request.getCookies();
//			for(Cookie cookie:cookies) {
//				if(cookie.getName().equals("user")) {
//					if(cookie.getValue().equals("root")) {
//						log("isLogin=true");
//						break;
//					}
//				}
//			}
//		}
		
		response.addCookie(user_id);
		response.addCookie(nickname);
		response.addCookie(verify);
		
		response.sendRedirect("/");
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
