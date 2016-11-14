package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import util.JDBC;
import vo.User;

public class UserDAO {
	
	public boolean isUserNameExists(User user) {
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		try {
			conn = JDBC.getConnection();
			StringBuilder sql = new StringBuilder();
			sql.append("SELECT user_id ");
			sql.append("FROM users ");
			sql.append("WHERE user_name = ? ");
			stmt = conn.prepareStatement(sql.toString());
			stmt.setString(1, user.getUserName());
			rs = stmt.executeQuery();
			if(rs.next()) {
				return true;  //user_name存在
			}
			else {
				return false;
			}
		}
		catch(SQLException e) {
			e.printStackTrace();
			return false;
		}
		finally {
			JDBC.release(conn, stmt, rs);
		}
	}
	
	public boolean isUserEmailExists(User user) {
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		try {
			conn = JDBC.getConnection();
			StringBuilder sql = new StringBuilder();
			sql.append("SELECT user_id ");
			sql.append("FROM users ");
			sql.append("WHERE user_email = ? ");
			stmt = conn.prepareStatement(sql.toString());
			stmt.setString(1, user.getUserEmail());
			rs = stmt.executeQuery();
			if(rs.next()) {
				return true;  //user_name存在
			}
			else {
				return false;
			}
		}
		catch(SQLException e) {
			e.printStackTrace();
			return false;
		}
		finally {
			JDBC.release(conn, stmt, rs);
		}
	}
	
	/**
	 * @return if {@code user} is found then return {@code user}(include nickname,id)
	 * 				 else return null.
	 */
	public User findUserByNameAndPassword(User user) {
		return findUserByModeAndPassword(user,0);
	}
	
	/**
	 * @return if {@code user} is found then return {@code user}(include nickname,id)
	 * 				 else return null.
	 */
	public User findUserByEmailAndPassword(User user) {
		return findUserByModeAndPassword(user,1);
	}
	
	private User findUserByModeAndPassword(User user,int mode) {
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		try {
			conn = JDBC.getConnection();
			
			StringBuilder sql = new StringBuilder();
			sql.append("SELECT user_nickname,user_id ");
			sql.append("FROM users ");
			sql.append("WHERE ");
			if(mode==1) {
				sql.append("user_email =? ");
			}
			else if(mode==0){
				sql.append("user_name =? ");
			}
			sql.append("AND user_password_md5 =? ;");
			System.out.println(sql.toString());
			
			stmt = conn.prepareStatement(sql.toString());
			
			if(mode==1) {
				stmt.setString(1, user.getUserEmail());
			}
			else if(mode==0){
				stmt.setString(1, user.getUserName());
			}
			stmt.setString(2, user.getUserPasswordMd5());
			
			rs = stmt.executeQuery();

			if(rs.next()) {
				user.setUserNickname(rs.getString("user_nickname"));
				user.setUserID(rs.getInt("user_id"));
			}
			else{
				return null;
				//response.sendRedirect("/login");  //用户名或者密码不通过
			}
			
		}
		catch(SQLException e) {
			e.printStackTrace();
			return null;
		}
		finally {
			JDBC.release(conn, stmt, rs);
		}
		return user;
	}

}
