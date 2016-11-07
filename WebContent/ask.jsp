<%@page import="util.JDBC"%>
<%@page import="rule.VerifySource"%>
<%@page import="util.MD5"%>
<%@page import="com.mysql.jdbc.Driver"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%if("GET".equals(request.getMethod())) {  %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ask</title>
</head>
<body>
<jsp:include page="WEB-INF/head.jsp"></jsp:include>
<%
	boolean isLogin = (boolean)request.getAttribute("isLogin");
	int my_user_id = (int)request.getAttribute("user_id");
	String my_verify = (String)request.getAttribute("verify");
%>
 <form action="/ask" method="post" class="form-horizontal" role="form">
	<input type="hidden" name="user_id" value="<%=my_user_id %>">
	<input type="hidden" name="verify" value="<%=my_verify %>">
    <div class="form-group">
	    <div class="col-sm-10">
	    	<input type="text" name="question_name" class="form-control" placeholder="你的问题" />
	    </div>
	</div>
	  	</div>
	  	<div class="form-group">
	    <div class="col-sm-10">
	    	<textarea class="form-control" rows="8" name = "content" placeholder="内容"></textarea>
	    </div>
		</div>
  	    <div class="form-group">
	    <div class="col-sm-10">
	    	<input type="text" name="topic0" class="" placeholder="话题0" />
	    	<input type="text" name="topic1" class="" placeholder="话题1" />
	    	<input type="text" name="topic2" class="" placeholder="话题2" />
	    	<input type="text" name="topic3" class="" placeholder="话题3" />
	    	<input type="text" name="topic4" class="" placeholder="话题4" />
	    	不输入默认为Object,最多5个,话题不存并不会创建新话题
		</div>
		</div>
  	<div class="form-group">
	    <div class="col-sm-10">
	    	<div class="checkbox">
	        <label>
	        	<input type="checkbox" name="anonymous">匿名
	        </label>
	      	</div>
	      	</div>
	    </div>
    <div class="form-group">
	    <div class="col-sm-10">
	    <%
	    	if(isLogin) {
	    %>
	    	<button type="submit" class="btn btn-default">发布</button>
	    <%}else {%>
	    	<button type="button" class="btn btn-default" onclick="alert('请先登录');">发布</button>
	    <%} %>
		</div>
	</div>
</form>


ask.jsp
</body>
</html>
<%
}
else if("POST".equals(request.getMethod())) {

	request.setCharacterEncoding("UTF-8");
	
	String user_id = request.getParameter("user_id");
	String verify = request.getParameter("verify");
	String question_name = request.getParameter("question_name");
	String question_content = request.getParameter("content");
	String str_anonymous = request.getParameter("anonymous");
	boolean anonymous = false;
	
	//对用户进行验证
	String str_verify_source = VerifySource.get(user_id);   //修改这里！修改这里！修改这里！重要的事情要说三遍

	if(!verify.equals(MD5.code(str_verify_source))) {
		response.sendError(404);
	}
	
	if(question_name.length()<1) {
		response.sendRedirect(request.getRequestURL() + "");
		return;
	}
	
	String[] t_topics_name = new String[5];
	String[] topics_name = new String[5];  //null值全部在数组后方
	int[] topics_id = new int[5];
	
	t_topics_name[0] = request.getParameter("topic0");
	t_topics_name[1] = request.getParameter("topic1");
	t_topics_name[2] = request.getParameter("topic2");
	t_topics_name[3] = request.getParameter("topic3");
	t_topics_name[4] = request.getParameter("topic4");
	
	
	for(int i=0,j=0;i<t_topics_name.length;i++) {  //处理”“值
		if(!t_topics_name[i].equals("")) {
			topics_name[j] = t_topics_name[i];
			j++;
		}
	}
	
	for(String str:topics_name) {
		System.out.println(str);
	}
	
	//System.out.println(content);
	
	if("on".equals(str_anonymous)) {
		anonymous = true;
	}
	
	synchronized(this) {
	
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;

	try {
		conn = JDBC.getConnection();
		stmt = conn.createStatement();
		
		StringBuilder sql = new StringBuilder();
		
		if(topics_name[0]!=null) {  //如果用户输入了话题
			sql.append("SELECT topic_id ");
			sql.append("FROM topics " );
			sql.append("WHERE ");
			sql.append("topic_name = '" + topics_name[0] + "' ");
			for(int i=1;i<topics_name.length;i++) {
				if(topics_name[i]!=null) {
					sql.append("OR topic_name = '" + topics_name[i] + "' ");
				}
				else {
					break;
				}
			}
			sql.append(";");
			
			rs = stmt.executeQuery(sql.toString());
			
			for(int i=0;rs.next()&&i<topics_id.length;i++) {
				topics_id[i] = rs.getInt("topic_id");
			}
		}
		if(topics_id[0]==0) {  //没有输topic或者topics表中没有此topic
			topics_id[0] = 1;
		}
		
		for(int x:topics_id) {
			//System.out.println(x);
		}
		
		sql = new StringBuilder();  //插入操作
		sql.append("INSERT INTO questions ");
		sql.append("( ");
		sql.append("question_name, ");
		sql.append("question_content, ");
		sql.append("question_author, ");
		sql.append("anonymous, ");
		for(int i=0;i<topics_id.length;i++) {
			if(topics_id[i]!=0) {
				sql.append("topic" + i +", ");
			}
			else {
				break;
			}
		}
		sql.append("create_time ");
		sql.append(") ");
		sql.append("VALUES ");
		sql.append("( ");
		sql.append("'" + question_name + "', ");
		sql.append("'" + question_content + "', ");
		sql.append(user_id + ", ");
		sql.append(anonymous + ", ");
		for(int i=0;i<topics_id.length;i++) {
			if(topics_id[i]!=0) {
				sql.append(topics_id[i] +", ");
			}
			else {
				break;
			}
		}
		sql.append("NOW() ");
		sql.append(") ");
		stmt.executeUpdate(sql.toString());
		
		rs = stmt.executeQuery("SELECT last_insert_id() AS last_question_id");
		if(rs.next()) {
			int last_question_id = rs.getInt("last_question_id");
			
			response.sendRedirect("/question/" + last_question_id);
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

}
%>