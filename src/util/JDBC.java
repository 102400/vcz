package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ResourceBundle;

public class JDBC {
	
	private static String driver = "";
	private static String url = "";
	private static String user = "";
	private static String password = "";
	
	static {
		driver = ResourceBundle.getBundle("db").getString("driver");
		url = ResourceBundle.getBundle("db").getString("url");
		user = ResourceBundle.getBundle("db").getString("user");
		password = ResourceBundle.getBundle("db").getString("password");
		try {
			Class.forName(driver);
		}
		catch(ClassNotFoundException e) {
			e.printStackTrace();
		}
	}
	
	public static Connection getConnection() {
		
		Connection conn = null;
		try {
			conn = DriverManager.getConnection(url,user,password);
		}
		catch(SQLException e) {
			e.printStackTrace();
		}
		return conn;
	}
	
	public static void release(Connection conn,Statement stmt,ResultSet rs) {
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
	

}
