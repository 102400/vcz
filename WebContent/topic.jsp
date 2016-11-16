<%@page import="util.HTMLEscape"%>
<%@page import="rule.VerifySource"%>
<%@page import="util.MD5"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="util.JDBC"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>topic</title>
<style type="text/css">
.rightfloat {
	float: right;
}
.clearboth {
	clear:both;
}
</style>
</head>
<body>
<jsp:include page="WEB-INF/head.jsp"></jsp:include>
<div>
<a href="/topics"  target="blank"><button type="button" class="btn btn-primary btn-lg">话题列表</button></a>
</div>
<br />
<%
boolean isLogin = (boolean)request.getAttribute("isLogin");
if(isLogin) {
int user_id = (int)request.getAttribute("user_id");
String verify = (String)request.getAttribute("verify");
String str_verify_source = VerifySource.get(user_id + "");

if(!verify.equals(MD5.code(str_verify_source))) {
	response.sendError(404);
}

Connection conn = null;
PreparedStatement stmt = null;
ResultSet rs = null;
%>
<div>
<h3>已关注话题</h3>
<table class="table table-hover table-condensed">
	<tr>
	<th>topic_id</th>
	<th>topic_name</th>
	</tr>
<%
int topic_count = 0;
try {
	conn = JDBC.getConnection();
	StringBuilder sql = new StringBuilder(); 
	sql.append("SELECT t.topic_id,t.topic_name ");
	sql.append("FROM topicfollowers AS tf,topics AS t ");
	sql.append("WHERE tf.user_id = ? ");
	sql.append("AND tf.topic_id = t.topic_id ");
	stmt = conn.prepareStatement(sql.toString());
	
	stmt.setInt(1, user_id);
	
	rs = stmt.executeQuery();
	
	while(rs.next()) {
		int topic_id = rs.getInt("topic_id");
		String topic_name = rs.getString("topic_name");
		topic_name = new HTMLEscape(topic_name).escape();
		topic_count++;
		%>
		<tr>
		<th><a href="/topic/<%=topic_id %>" target="_blank"><%=topic_id %></a></th>
		<th><a href="/topic/<%=topic_id %>" target="_blank"><%=topic_name %></a></th>
		</tr>
		<%
	}
	
}
catch(SQLException e) {
	e.printStackTrace();
	response.sendError(404);
}
finally {
	JDBC.release(conn, stmt, rs);
}
 %>
 </table>
 <h5>共关注<%=topic_count %>个话题</h5>
 </div>
<%} %>
topic.jsp
</body>
</html>