<%@page import="java.sql.PreparedStatement"%>
<%@page import="util.JDBC"%>
<%@page import="com.mysql.jdbc.Driver"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%if(request.getMethod().equals("GET")) {%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>search</title>
<style type="text/css">
.leftfloat {
	float:left;
}
.clearboth {
	clear:both;
}

</style>
</head>
<body>
<jsp:include page="WEB-INF/head.jsp"></jsp:include>
<%
boolean isTopic = false;
boolean isContent = false;
boolean isPeople = false;

String type = request.getParameter("type");
switch(type) {
	case "topic":
		isTopic = true;
		break;
	case "content":
		isContent = true;
		break;
	case "people":
		isPeople = true;
		break;
}


String q = request.getParameter("q");
%>
<form action="/search" method="get" class="leftfloat">
	<%if(isTopic) { %>
	<button type="submit" name="type" value="topic" class="btn btn-success" >话题</button>
	<%}else { %>
	<button type="submit" name="type" value="topic" class="btn btn-default" >话题</button>
	<%} %>
	<input type="hidden" name="q" value="<%=q %>">
</form>
<form action="/search" method="get" class="leftfloat">
	<%if(isContent) { %>
	<button type="submit" name="type" value="content" class="btn btn-success" >内容</button>
	<%}else { %>
	<button type="submit" name="type" value="content" class="btn btn-default" >内容</button>
	<%} %>
	<input type="hidden" name="q" value="<%=q %>">
</form>
<form action="/search" method="get" class="leftfloat">
	<%if(isPeople) { %>
	<button type="submit" name="type" value="people" class="btn btn-success" >用户</button>
	<%}else { %>
	<button type="submit" name="type" value="people" class="btn btn-default" >用户</button>
	<%} %>
	<input type="hidden" name="q" value="<%=q %>">
</form>
<hr class="clearboth">

<%
if(isTopic) {
%>
<div>
<%
int topic_id = 0;
String topic_name = null;

Connection conn = null;
PreparedStatement stmt = null;
ResultSet rs = null;
try {
	conn = JDBC.getConnection();
	
	StringBuilder sql = new StringBuilder();
	sql.append("SELECT topic_id ");
	sql.append("FROM topics ");
	sql.append("WHERE topic_name=?;");
	stmt = conn.prepareStatement(sql.toString());
	stmt.setString(1, q);
	
	rs = stmt.executeQuery();
	
	if(rs.next()) {
		topic_id = rs.getInt("topic_id");
		%>
		<h5>完整匹配:</h5>
		<div><ul><li><a href="/topic/<%=topic_id %>"><%=q %></a></li></ul></div>
		<%
		topic_id = 0;
	}
}
catch(SQLException e) {
	e.printStackTrace();
}
finally {
	JDBC.release(conn, stmt, rs);
}

conn = null;
stmt = null;
rs = null;
try {
	conn = JDBC.getConnection();
	
	StringBuilder sql = new StringBuilder();
	sql.append("SELECT topic_id,topic_name ");
	sql.append("FROM topics ");
	sql.append("WHERE topic_name LIKE ?;");
	stmt = conn.prepareStatement(sql.toString());
	stmt.setString(1, "%" + q + "%");
	
	rs = stmt.executeQuery();
	%><div><h5>全部结果</h5><%
	while(rs.next()) {
		topic_id = rs.getInt("topic_id");
		topic_name = rs.getString("topic_name");
		%>
		<div><ul><li><a href="/topic/<%=topic_id %>"><%=topic_name %></a></li></ul></div>
		<%
	}
	%></div><%
}
catch(SQLException e) {
	e.printStackTrace();
}
finally {
	JDBC.release(conn, stmt, rs);
}


%>
</div>
<%
}
else if(isContent) {
	int question_id = 0;
	String question_name = null;
	
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	try {
		conn = JDBC.getConnection();
		
		StringBuilder sql = new StringBuilder();
		sql.append("SELECT question_id,question_name ");
		sql.append("FROM questions ");
		sql.append("WHERE question_name LIKE ?;");
		stmt = conn.prepareStatement(sql.toString());
		stmt.setString(1, "%" + q + "%");
		log(q + "!!!!!!!!!!!!!!!!");
		rs = stmt.executeQuery();
		%><div><h5>全部结果</h5><%
		while(rs.next()) {
			log("rs.next()");
			question_id = rs.getInt("question_id");
			question_name = rs.getString("question_name");
			%>
			<div><ul><li><a href="/question/<%=question_id %>"><%=question_name %></a></li></ul></div>
			<%
		}
		%></div><%
	}
	catch(SQLException e) {
		e.printStackTrace();
	}
	finally {
		JDBC.release(conn, stmt, rs);
	}
}
else if(isPeople) {
	out.println("未开放<br />");
}

%>
</body>
</html>
<%} %>