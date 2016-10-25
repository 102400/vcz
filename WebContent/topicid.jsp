<%@page import="com.mysql.jdbc.Driver"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%

String str = request.getRequestURI();
String[] strs = str.split("/");
int topic = 1;
try {
	topic = Integer.valueOf(strs[2]);
}
catch(Exception e) {
	e.printStackTrace();
	response.sendError(404);
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
	
	int topic_id = 0;
	String topic_name = "";
	int parent_id = 0;
	String parent_name = "";
	String create_time = "";
	
	rs = stmt.executeQuery("SELECT a.topic_id,a.topic_name,a.create_time,a.topic_parent AS parent_id,b.topic_name AS parent_name FROM topics AS a,topics AS b WHERE a.topic_id = " + topic + " AND a.topic_parent = b.topic_id;");
	while(rs.next()) {
		topic_id = rs.getInt("topic_id");
		topic_name = rs.getString("topic_name");
		create_time = rs.getString("create_time");
		parent_id = rs.getInt("parent_id");
		parent_name = rs.getString("parent_name");
	}
	%>
<!DOCTYPE html">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=topic_name %></title>
</head>
<body>
<jsp:include page="WEB-INF/head.jsp"></jsp:include>
	<h4><a href="/topic/<%=parent_id %>"><%=parent_name %></a></h4>
	<h2>&nbsp;|----<%=topic_name %><!-- (create time:<%=create_time %>) --></h2>

	<table class="table table-hover table-condensed">
	<tr>
	<!-- 
	<th>topic_id</th>
	<th>topic_name</th>
	 -->
	<th>question_id</th>
	<th>question_name</th>
	</tr>
	
	<%
	//查询话题下的问题
	//按最后回复时间排序?
	rs = stmt.executeQuery("SELECT q.question_id,q.question_name FROM topics AS t,questions AS q WHERE (q.topic0 = " + topic +" AND t.topic_id = " + topic + ") OR (q.topic1 = " + topic + " AND t.topic_id = " + topic +") OR (q.topic2 = " + topic +" AND t.topic_id = " + topic +") OR(q.topic3 = " + topic +" AND t.topic_id = " + topic + ") OR (q.topic4 = " + topic + " AND t.topic_id = " + topic + ");");
	
	while(rs.next()) {
		//int topic_id = rs.getInt("topic_id");
		//String topic_name = rs.getString("topic_name");
		int question_id = rs.getInt("question_id");
		String question_name = rs.getString("question_name");
		%>
		<tr>
		<th><a href="/question/<%=question_id %>" target="_blank"><%=question_id %></a></th>
		<th><a href="/question/<%=question_id %>" target="_blank"><%=question_name %></a></th>
		</tr>
		<% 
	}
	%>
	</table>
	
	topicid.jsp
</body>
</html>
<%
	
}
catch(SQLException e) {
	e.printStackTrace();
	response.sendError(404);
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