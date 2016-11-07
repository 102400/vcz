package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import rule.VerifySource;
import util.JDBC;
import util.MD5;

public class FollowTopic extends HttpServlet {
	
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.sendError(404);
	}
	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String URI = null;
		String f = request.getParameter("f");
		int topic_id = 0;
		try {
			topic_id = Integer.valueOf(request.getParameter("topic_id"));
			URI = "/topic/" + topic_id;
		}
		catch(Exception e) {
			e.printStackTrace();
			response.sendError(404);
		}
		
		int user_id = 0;
		String verify = "";
		Cookie[] cookies = request.getCookies();
		for(Cookie cookie:cookies) {
			if(cookie.getName().equals("user_id")) {
				try {
					user_id = Integer.valueOf(cookie.getValue());
				}
				catch(Exception e) {
					e.printStackTrace();
					return;
				}
			}
			
			if(cookie.getName().equals("verify")) {
				verify = cookie.getValue();
			}
		}
		
		String str_verify_source = VerifySource.get(user_id + "");    //"#vc" + user_id + "@*!6^xs";

		if(!verify.equals(MD5.code(str_verify_source))) {  //没有通过验证
			response.sendRedirect(URI);
			return;
		}
		
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		try {
			conn = JDBC.getConnection();
			if("follow".equals(f)) {
				sql.append("INSERT INTO topicfollowers ");
				sql.append("( ");
				sql.append("user_id, ");
				sql.append("topic_id, ");
				sql.append("create_time ");
				sql.append(") ");
				sql.append("VALUES ");
				sql.append("( ");
				sql.append("?, ");
				sql.append("?, ");
				sql.append("NOW() ");
				sql.append(") ");
				
				stmt = conn.prepareStatement(sql.toString());
				stmt.setInt(1, user_id);
				stmt.setInt(2, topic_id);
				
				stmt.executeUpdate();
			}
			else if("unfollow".equals(f)) {
				sql.append("DELETE FROM topicfollowers ");
				sql.append("WHERE user_id = ? ");
				sql.append("AND topic_id = ?; ");
				stmt = conn.prepareStatement(sql.toString());
				stmt.setInt(1, user_id);
				stmt.setInt(2, topic_id);
				
				stmt.executeUpdate();
			}
			else {
				response.sendError(404);
			}
		}
		catch(SQLException e) {
			e.printStackTrace();
		}
		finally {
			JDBC.release(conn, stmt, rs);
		}
		response.sendRedirect(URI);
	}

}
