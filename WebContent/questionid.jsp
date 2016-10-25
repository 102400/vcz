<%@page import="rule.VerifySource"%>
<%@page import="util.MD5"%>
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
int question_id = 0;

try {
	question_id = Integer.valueOf(strs[2]);
}
catch(Exception e) {
	e.printStackTrace();
	response.sendError(404);
}
//System.out.println(question_id);

if("GET".equals(request.getMethod())) {

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
	
	String question_name = "";
	String question_content = "";
	int question_author = 0;
	int author_anonymous = 0;
	String question_nickname = "";
	String create_time = "";
	int answer_count = 0;
	int view_count = 0;
	
	int[] topic_ids = new int[5];
	
	String[] topic_names = new String[5];
	
	StringBuilder sql = new StringBuilder();
	sql.append("SELECT ");
	sql.append("q.question_name,q.question_content,q.question_author,q.anonymous,u.user_nickname AS question_nickname,q.create_time,q.answer_count,q.view_count,");
	sql.append("q.topic0 AS topic0_id,");
	sql.append("q.topic1 AS topic1_id,");
	sql.append("q.topic2 AS topic2_id,");
	sql.append("q.topic3 AS topic3_id,");
	sql.append("q.topic4 AS topic4_id ");
	sql.append("FROM questions AS q,users AS u ");
	sql.append("WHERE ");
	sql.append("q.question_id = " + question_id + " AND ");
	sql.append("u.user_id = question_author");
	
	rs = stmt.executeQuery(sql.toString());
	if(rs.next()) {
		question_name = rs.getString("question_name");
		question_content = rs.getString("question_content");
		question_author = rs.getInt("question_author");
		author_anonymous = rs.getInt("anonymous");
		question_nickname = rs.getString("question_nickname");
		create_time = rs.getString("create_time");
		answer_count = rs.getInt("answer_count");
		view_count = rs.getInt("view_count");
		topic_ids[0] = rs.getInt("topic0_id");
		topic_ids[1] = rs.getInt("topic1_id");
		topic_ids[2] = rs.getInt("topic2_id");
		topic_ids[3] = rs.getInt("topic3_id");
		topic_ids[4] = rs.getInt("topic4_id");
	}
	
	//question_content 处理格式
	question_content = question_content.replaceAll(" ", "&nbsp;");
	question_content = question_content.replaceAll("\n", "<br />");
	
	sql = new StringBuilder();
	sql.append("SELECT t.topic_name ");
	sql.append("FROM questions AS q,topics AS t ");
	sql.append("WHERE ");
	sql.append("question_id = " + question_id + " AND ");
	sql.append("(");
	sql.append("q.topic0 = t.topic_id ");
	
	if(topic_ids[1]!=0) {
		sql.append("OR q.topic1 = t.topic_id ");
	}
	if(topic_ids[2]!=0) {
		sql.append("OR q.topic2 = t.topic_id ");
	}
	if(topic_ids[3]!=0) {
		sql.append("OR q.topic3 = t.topic_id ");
	}
	if(topic_ids[4]!=0) {
		sql.append("OR q.topic4 = t.topic_id ");
	}
	sql.append(")");
	
	rs.close();
	rs = stmt.executeQuery(sql.toString());
	
	for(int i=0;rs.next()&&i<topic_names.length;i++) {
		topic_names[i] = rs.getString("topic_name");
	}
	
	/*
	System.out.println(question_name);
	System.out.println(question_content);
	System.out.println(question_author);
	System.out.println(question_nickname);
	System.out.println(create_time);
	System.out.println(answer_count);
	System.out.println(view_count);
	
	for(int x:topic_ids) {
		System.out.println(x);
	}
	
	for(String s:topic_names) {
		System.out.println(s);
	}
	*/
	
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=question_name %></title>
<style type="text/css">
.leftfloat {
	float: left;
}
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
<div class="rightfloat">
topic:
<% 
for(int i=0;i<topic_names.length;i++) {
	if(topic_names[i]!=null) { 
%>
<button type="button" class="btn btn-default"><a href="/topic/<%=topic_ids[i] %>"><%=topic_names[i] %></a></button>
<%
	}
}
%>
<br />
<%if(author_anonymous==0) { %>
author:<small><a href="/people/<%=question_author %>"><%=question_nickname %></a></small><br />
<%}else{ %>
author:<small><a>匿名用户</a></small><br />
<%} %>
create time:<%=create_time %><br />
last modify time:<br />
answer count:<%=answer_count %><br />
view count:<%=view_count %><br />
</div>
<h2>
<%=question_name %><a href="#answer_question"><button type="button" class="btn btn-primary">回答问题</button></a><br />
</h2>
<div>
    <%=question_content %>
</div>
<hr>
<div>
<% 
int answer_id = 0;
int user_id = 0;
String user_nickname = "";
String answer_content = "";
boolean anonymous = true;
String license_name = "";
int answer_weight = 0;
int agree_count = 0;
int disagree_count = 0;
String answer_create_time = "";

sql = new StringBuilder();
sql.append("SELECT a.answer_id,a.user_id,u.user_nickname,a.answer_content,a.anonymous,l.license_name,a.answer_weight,a.agree_count,a.disagree_count,a.create_time ");
sql.append("FROM answers AS a,licenses AS l,users AS u ");
sql.append("WHERE question_id = " + question_id + " ");
sql.append("AND a.license = l.license_id ");
sql.append("AND a.user_id = u.user_id; ");
rs.close();
rs = stmt.executeQuery(sql.toString());

while(rs.next()) {
	answer_id = rs.getInt("answer_id");
	user_id = rs.getInt("user_id");
	user_nickname = rs.getString("user_nickname");
	answer_content = rs.getString("answer_content");
	anonymous = rs.getBoolean("anonymous");
	license_name = rs.getString("license_name");
	answer_weight = rs.getInt("answer_weight");
	agree_count = rs.getInt("agree_count");
	disagree_count = rs.getInt("disagree_count");
	answer_create_time = rs.getString("create_time");
	
	//对answer_content进行换行处理
	answer_content = answer_content.replaceAll(" ", "&nbsp;");
	answer_content = answer_content.replaceAll("\n", "<br />");
	System.out.println(answer_content);
	
	%>
	<div>
		<div>
			<div class="leftfloat">
				<button type="button" class="btn btn-default btn-xs"><%=agree_count %></button><br />
				<button type="button" class="btn btn-default btn-xs"><%=disagree_count %></button>
			</div>
	<%
		if(anonymous) {
	%>
		<a>匿名用户</a>
	<%
		}
		else {
	%>
		<a href="/people/<%=user_id %>"><%=user_nickname %></a>
	<% } %>
		</div>
	<div class="clearboth">
		<div><%=answer_content %></div>
		<div class="rightfloat">create:<%=answer_create_time %>  license:<%=license_name %></div>
	</div>
	</div>
	<hr>
</div>
	<%
}

%>
<div id="answer_question">
	<%
		int my_user_id = (int)request.getAttribute("user_id");
		String my_verify = (String)request.getAttribute("verify");
		
		boolean isLogin = (boolean)request.getAttribute("isLogin");
		if(!isLogin) {
	%>
		<form>
	<%}else{ %>
		<form action="<%=request.getRequestURI() %>" method="post">
	<%} %>
		<input type="hidden" name="question_id" value="<%=question_id %>">
		<input type="hidden" name="user_id" value="<%=my_user_id %>">
		<input type="hidden" name="verify" value="<%=my_verify %>">
		
		<textarea class="form-control" rows="5" name = "content"></textarea>
		<div>
	<%
		if(!isLogin) {
	%>
		<button type=button class="btn btn-primary" onclick="alert('请先登录');" >发布回答</button>
	<%}else{ %>
		<button type="submit" class="btn btn-primary">发布回答</button>
	<%} %>
			<input type="checkbox" name="anonymous">匿名
			<select name="license">
				<option value ="1" >禁止转载</option>
				<option value ="2" >作者保留权利</option>
				<option value="3" >3</option>
				<option value="4" >4</option>
			</select>
		</div>
	</form>
</div>
questionid.jsp
</body>
</html>

<%

//对 view_count++
view_count++;
rs.close();
String ssss = "UPDATE questions SET view_count=" + view_count + " WHERE question_id=" + question_id + ";";
stmt.executeUpdate(ssss);
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
}

if("POST".equals(request.getMethod())) {
	
	request.setCharacterEncoding("UTF-8");
	
	String user_id = request.getParameter("user_id");
	String verify = request.getParameter("verify");
	String content = request.getParameter("content");
	String str_anonymous = request.getParameter("anonymous");
	boolean anonymous = false;
	String license = request.getParameter("license");
	
	//System.out.println(content);
	
	//对用户进行验证
	String str_verify_source = VerifySource.get(user_id);   //修改这里！修改这里！修改这里！重要的事情要说三遍

	if(!verify.equals(MD5.code(str_verify_source))) {
		response.sendError(404);
	}
	//
	
	if("on".equals(str_anonymous)) {
		anonymous = true;
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
		sql.append("INSERT INTO answers ");
		sql.append("( ");
		sql.append("question_id, ");
		sql.append("user_id, ");
		sql.append("answer_content, ");
		sql.append("anonymous, ");
		sql.append("license, ");
		sql.append("create_time ");
		sql.append(") ");
		sql.append("VALUES ");
		sql.append("( ");
		sql.append(question_id + ", ");
		sql.append(user_id + ", ");
		sql.append("'" + content + "', ");
		sql.append(anonymous + ", ");
		sql.append(license + ", ");
		sql.append("NOW() ");
		sql.append("); ");
		
		stmt.executeUpdate(sql.toString());
		
		sql = new StringBuilder();
		
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
	
	response.sendRedirect(request.getRequestURL() + "");
	
	//response.setHeader("Refresh", "0;URL=" + request.getRequestURL());
}
%>