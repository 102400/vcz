<%@page import="util.JDBC"%>
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
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>topics</title>
</head>
<body>
<jsp:include page="WEB-INF/head.jsp"></jsp:include>

<%
boolean isLogin = (boolean)request.getAttribute("isLogin");
if(isLogin) {
%>
<form action="/topics" method="post" class="form-horizontal" role="form">
    <div class="form-group">
	    <div class="col-sm-10">
	    	<input type="text" name="topic_name" class="" placeholder="话题" />
	    	<input type="text" name="parent_topic_name" class="" placeholder="父话题(默认为Object)" />
	    	<button type="submit" class="btn btn-default">创建话题</button>
	    </div>
	</div>
</form>
<%
}
else {
%>
	<form class="form-horizontal" role="form">
    <div class="form-group">
	    <div class="col-sm-10">
	    	<input type="text" name="" class="" placeholder="话题" />
	    	<input type="text" name="" class="" placeholder="父话题(默认为Object)" />
	    	<button type="button" class="btn btn-default" onclick="alert('请先登录');">创建话题</button>
	    </div>
	</div>
</form>
<% 
}



Connection conn = null;
Statement stmt = null;
ResultSet rs = null;
try {
	conn = JDBC.getConnection();
	stmt = conn.createStatement();
	rs = stmt.executeQuery("SELECT a.topic_id,a.topic_name,a.topic_parent AS parent_id,b.topic_name AS parent_name FROM topics AS a,topics AS b WHERE a.topic_parent = b.topic_id;");
	
	%>
	<table class="table table-hover table-condensed">
	<tr>
	<th>topic_id</th>
	<th>topic_name</th>
	<th>parent_id</th>
	<th>parent_name</th>
	</tr>
	
	<%
	while(rs.next()) {
		int topic_id = rs.getInt("topic_id");
		String topic_name = rs.getString("topic_name");
		int parent_id = rs.getInt("parent_id");
		String parent_name = rs.getString("parent_name");
		%>
		<tr>
		<th><a href="/topic/<%=topic_id %>" target="_blank"><%=topic_id %></a></th>
		<th><a href="/topic/<%=topic_id %>" target="_blank"><%=topic_name %></a></th>
		<th><a href="/topic/<%=parent_id %>" target="_blank"><%=parent_id %></a></th>
		<th><a href="/topic/<%=parent_id %>" target="_blank"><%=parent_name %></a></th>
		</tr>
		<% 
	}
	%>
	</table>
	<%
}
catch(SQLException e) {
	e.printStackTrace();
}
finally {
	JDBC.release(conn, stmt, rs);
}

%>
topics.jsp
</body>
</html>
<%
}
else if("POST".equals(request.getMethod())) {
	
	request.setCharacterEncoding("UTF-8");
	
	String topic_name = request.getParameter("topic_name");
	if(topic_name.length()>32) {
		response.sendRedirect("/topics");
		return;
	}
	String parent_topic_name = request.getParameter("parent_topic_name");
	int parent_topic_id = 1;  //默认为Object
	
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;
	
	try {
		conn = JDBC.getConnection();
		
		stmt = conn.createStatement();
		
		StringBuilder sql = new StringBuilder();
		
		sql = new StringBuilder();
		sql.append("SELECT topic_id ");
		sql.append("FROM topics ");
		sql.append("WHERE topic_name = '" + parent_topic_name + "'; ");
		
		rs = stmt.executeQuery(sql.toString());
		if(rs.next()) {
			parent_topic_id = rs.getInt("topic_id");
		}
		
		
		sql = new StringBuilder();
		sql.append("INSERT INTO topics ");
		sql.append("( ");
		sql.append("topic_name, ");
		sql.append("topic_parent, ");
		sql.append("create_time ");
		sql.append(") ");
		sql.append("VALUES ");
		sql.append("( ");
		sql.append("'" +topic_name + "', ");
		sql.append(parent_topic_id + ", ");
		sql.append("NOW() ");
		sql.append("); ");
		
		stmt.executeUpdate(sql.toString());
		
		rs = stmt.executeQuery("SELECT last_insert_id() AS last_topic_id");
		if(rs.next()) {
			int last_question_id = rs.getInt("last_topic_id");
			
			response.sendRedirect("/topic/" + last_question_id);
			return;
		}
		
	}
	catch(SQLException e) {
		e.printStackTrace();
		response.sendError(404);
	}
	finally {
		JDBC.release(conn, stmt, rs);
	}
	
	response.sendRedirect(request.getRequestURL() + "");
}
%>