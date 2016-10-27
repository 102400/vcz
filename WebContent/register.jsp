<%@page import="util.JDBC"%>
<%@page import="util.MD5"%>
<%@page import="rule.Nickname"%>
<%@page import="rule.Password"%>
<%@page import="rule.Email"%>
<%@page import="rule.Username"%>
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
<!DOCTYPE html">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>register</title>
<script type="text/javascript">
	function changeimg(){
		
		document.getElementById("img").src="CAPTCHA?" + new Date().getMilliseconds();
	}
</script>
</head>
<body>
<jsp:include page="WEB-INF/head.jsp"></jsp:include>
<%
boolean isLogin = (boolean)request.getAttribute("isLogin");
if(isLogin) {
	response.sendRedirect("/");
}

%>
<form action="register" method="post" class="form-horizontal" role="form">
    <div class="form-group">
	    <div class="col-sm-10">
	    	<input type="text" name="nickname" class="form-control" placeholder="Nickname(length:1-16)" />
	    </div>
	</div>
    <div class="form-group">
	    <div class="col-sm-10">
	    	<input type="text" name="username" class="form-control" placeholder="Username(length:6-16)" />
	    </div>
	</div>
	<div class="form-group">
	    <div class="col-sm-10">
	    	<input type="text" name="email" class="form-control" placeholder="email address(length:5+)" />
	    </div>
	</div>
	<div class="form-group">
	    <div class="col-sm-10">
	    	<input type="password" name="password" class="form-control" placeholder="Password(length:6-16)" />
	    </div>
  	</div>
  	<div class="form-group">
	    <div class="col-sm-10">
    		<img src="CAPTCHA" style="cursor: pointer;" onclick="changeimg();" id="img"/>
    	 </div>
  	</div>
  	<div class="form-group">
	    <div class="col-sm-10">
    		<input type="text" name="captcha" class="form-control" placeholder="CAPTCHA" />
    	 </div>
  	</div>
    <div class="form-group">
    <div class="col-sm-10">
    	<button type="submit" class="btn btn-default">register</button>
	</div>
	</div>
    </form>


register.jsp
</body>
</html>
<%
}
if("POST".equals(request.getMethod())) {
	request.setCharacterEncoding("UTF-8");
	
	final String CAPTCHA = (String)session.getAttribute("CAPTCHA");
	
	
	String nickname = request.getParameter("nickname");
	String username = request.getParameter("username");
	String email = request.getParameter("email");
	String password = request.getParameter("password");
	String captcha = request.getParameter("captcha");
	
	if(!captcha.equals(CAPTCHA)) {
		response.sendRedirect("/register");  //验证码未通过
		return;
	}
	//检查是否符合规则  详见rule包
	//username长度限制6-16
	//email长度限制5-？
	//password长度限制6-16
	boolean isN = new Nickname(nickname).isLegal();
	boolean isU = new Username(username).isLegal();
	boolean isE = new Email(email).isLegal();
	boolean isP = new Password(password).isLegal();
	
	String password_md5 = MD5.code(password);
	
	if(isN&isU&&isE&&isP) {  //都符合规则时
		
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		
		try {
			conn = JDBC.getConnection();
					
			stmt = conn.createStatement();
			
			StringBuilder sql = new StringBuilder();
			sql.append("INSERT INTO users ");
			sql.append("( ");
			sql.append("user_name, ");
			sql.append("user_email, ");
			sql.append("user_password_md5, ");
			sql.append("user_nickname, ");
			sql.append("create_time ");
			sql.append(") ");
			sql.append("VALUES ");
			sql.append("( ");
			sql.append("'" + username + "', ");
			sql.append("'" + email + "', ");
			sql.append("'" + password_md5 + "', ");
			sql.append("'" + nickname + "', ");
			sql.append("NOW() ");
			sql.append("); ");
			
			stmt.executeUpdate(sql.toString());
		}
		catch(SQLException e) {
			e.printStackTrace();
			response.sendError(404);
		}
		finally {
			JDBC.release(conn, stmt, rs);
		}
		
	}
	else {
		response.sendRedirect("/register");
	}
	
	response.sendRedirect("/login");
}
%>