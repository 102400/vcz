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
	<input type="hidden" name="q" value="<%=q %>">
	<%if(isTopic) { %>
	<button type="submit" name="type" value="topic" class="btn btn-success" >话题</button>
	<%}else { %>
	<button type="submit" name="type" value="topic" class="btn btn-default" >话题</button>
	<%} %>
</form>
<form action="/search" method="get" class="leftfloat">
	<input type="hidden" name="q" value="<%=q %>">
	<%if(isContent) { %>
	<button type="submit" name="type" value="content" class="btn btn-success" >内容</button>
	<%}else { %>
	<button type="submit" name="type" value="content" class="btn btn-default" >内容</button>
	<%} %>
</form>
<form action="/search" method="get" class="leftfloat">
	<input type="hidden" name="q" value="<%=q %>">
	<%if(isPeople) { %>
	<button type="submit" name="type" value="people" class="btn btn-success" >用户</button>
	<%}else { %>
	<button type="submit" name="type" value="people" class="btn btn-default" >用户</button>
	<%} %>
</form>
<hr class="clearboth">

<%
if(isTopic) {
%>
<div>
<h5>完整匹配:</h5>
<%
int topic_id = 0;

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
	sql.append("SELECT topic_id ");
	sql.append("FROM topics ");
	sql.append("WHERE topic_name='" + q + "';");
	
	rs = stmt.executeQuery(sql.toString());
	
	if(rs.next()) {
		topic_id = rs.getInt("topic_id");
		%>
		<div><ul><li><a href="/topic/<%=topic_id %>"><%=q %></a></li></ul></div>
		<%
	}
	else {
		out.println("没有找到相关的话题");
	}
}
catch(SQLException e) {
	e.printStackTrace();
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


%>
</div>
<%
}
else if(isContent) {
	out.println("未开放<br />");
}
else if(isPeople) {
	out.println("未开放<br />");
}

%>
</body>
</html>
<%} %>