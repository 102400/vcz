<%@page import="com.mysql.jdbc.Driver"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
if("GET".equals(request.getMethod())) {
	
	String str = request.getRequestURI();
	String[] strs = str.split("/");
	int people_id = 0;

	try {
		people_id = Integer.valueOf(strs[2]);
	}
	catch(Exception e) {
		e.printStackTrace();
		response.sendError(404);
	}
	//System.out.println(people_id);
	
String user_nickname = "";
int ask_count = 0;
int answer_count = 0;
int following = 0;
int followers = 0;
int view_count = 0;
	
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
	sql.append("SELECT user_nickname,ask_count,answer_count,following,followers,view_count ");
	sql.append("FROM users ");
	sql.append("WHERE user_id = " + people_id + "; ");
	
	rs = stmt.executeQuery(sql.toString());
	
	if(rs.next()) {
		user_nickname = rs.getString("user_nickname");
		ask_count = rs.getInt("ask_count");
		answer_count = rs.getInt("answer_count");
		following = rs.getInt("following");
		followers = rs.getInt("followers");
		view_count = rs.getInt("view_count");
	}

%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=user_nickname %></title>
</head>
<body>
<jsp:include page="WEB-INF/head.jsp"></jsp:include>
<div>user_nickname:<%=user_nickname %></div>
<div>ask_count:<%=ask_count %></div>
<div>answer_count:<%=answer_count %></div>
<div>following:<%=following %></div>
<div>followers:<%=followers %></div>
<div>view_count:<%=view_count %></div>

<br />
peopleid.jsp
</body>
</html>
<%
view_count++;
rs.close();
String ssss = "UPDATE users SET view_count=" + view_count + " WHERE user_id=" + people_id + ";";
stmt.executeUpdate(ssss);
}
finally {
	if(rs!=null) {
		rs.close();
	}
	if(stmt!=null) {
		stmt.close();
	}
	if(conn!=null) {
		conn.close();
	}
}
} %>