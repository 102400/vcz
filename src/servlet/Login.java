package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import rule.VerifySource;
import util.MD5;

public class Login extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
//		response.setStatus(404);
		response.sendError(404);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		request.setCharacterEncoding("utf-8");
		
//		final String SESSION_ID;
		final String CAPTCHA;
		
		HttpSession session = request.getSession();
		
//		Cookie cookie = new Cookie("user", "sfg");
//		cookie.setDomain("");
		
//		Cookie[] cookies = request.getCookies();
//		for(Cookie cookie:cookies) {
//			if("CAPTCHA".equals(cookie.getName())) {
//				SESSION_ID = cookie.getValue();
//				break;
//			}
//		}
		
		CAPTCHA = (String)session.getAttribute("CAPTCHA");
		
		//修改
//		final String R_USERNAME = "root";
//		final String R_PASSWORD = "123456";
		
		boolean isEmail = false;
		
		String nickname = null;
		int user_id = 0;
		
		String username = request.getParameter("username");
//		String password = request.getParameter("password");
		String password = MD5.code(request.getParameter("password"));  //MD5加密后的提交密码
		String captcha = request.getParameter("captcha");
		String remember_me = request.getParameter("remember_me");  //remember me = "on","null"
		
		//验证码验证
		if(!captcha.equals(CAPTCHA)) {
			response.sendRedirect("/login");  //验证码未通过
			return;
		}
		
		for(char c:username.toCharArray()) {
			if(c=='@') {
				isEmail = true;
				break;
			}
		}
		
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		
		try {
			DriverManager.registerDriver(new com.mysql.jdbc.Driver());
			conn = DriverManager.getConnection(
					"jdbc:mysql://localhost:3306/vcz",
					"vcz",
					"VcZpaSSwORd"
					);
			stmt = conn.createStatement();
			StringBuilder sql = new StringBuilder();
			sql.append("SELECT user_nickname,user_id ");
			sql.append("FROM users ");
			sql.append("WHERE ");
			if(isEmail) {
				sql.append("user_email = '" + username + "' ");
			}
			else {
				sql.append("user_name = '" + username + "' ");
			}
			sql.append("AND user_password_md5 = '" + password + "';");
			
			rs = stmt.executeQuery(sql.toString());

			if(rs.next()) {
				nickname = rs.getString("user_nickname");
				user_id = rs.getInt("user_id");
			}
			else{
				response.sendRedirect("/login");  //用户名或者密码不通过
			}
			
		}
		catch(SQLException e) {
			e.printStackTrace();
			response.sendError(404);
		}
		finally {
			if(rs!=null) {
				try {
					rs.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			if(stmt!=null) {
				try {
					stmt.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			if(conn!=null) {
				try {
					conn.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		
		StringBuilder sb = new StringBuilder();  //简单加密过后的nickname
		for(char c:nickname.toCharArray()) {
			sb.append((int)c + "&");
		}
		
//		String[] sss = sb.toString().split("&");  //解密程序
//		StringBuilder bs = new StringBuilder();
//		for(String str:sss) {
//			int x = Integer.valueOf(str);
//			char c = (char)x;
//			bs.append(c);
//		}
//		System.out.println(bs);
		
		String str_verify_source = VerifySource.get(user_id + "");  //"#vc" + user_id + "@*!6^xs";
		
		Cookie cookie_nickname = new Cookie("nickname",sb.toString());
		Cookie cookie_user_id = new Cookie("user_id", user_id + "");
		
		Cookie verify = new Cookie("verify",MD5.code(str_verify_source));  //加密过后的 登录验证cookie
		
		if("on".equals(remember_me)) {
			verify.setMaxAge(60*60*24*42);  //42天
			cookie_nickname.setMaxAge(60*60*24*42);
			cookie_user_id.setMaxAge(60*60*24*42);
		}
		
		response.addCookie(verify);
		response.addCookie(cookie_nickname);
		response.addCookie(cookie_user_id);
		
		
		response.sendRedirect("/");
		
//		log(CAPTCHA);
//		log(username);
//		log(password);

//		response.setContentType("text/html");
//		PrintWriter out = response.getWriter();
//		out.println("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">");
//		out.println("<HTML>");
//		out.println("  <HEAD><TITLE>A Servlet</TITLE></HEAD>");
//		out.println("  <BODY>");
//		out.print("    This is ");
//		out.print(this.getClass());
//		out.println(", using the POST method");
//		out.println("  </BODY>");
//		out.println("</HTML>");
//		out.flush();
//		out.close();
	}

}
