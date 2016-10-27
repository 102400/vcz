<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>login</title>
<script type="text/javascript">
	function changeimg(){
		
		document.getElementById("img").src="CAPTCHA?" + new Date().getMilliseconds();
	}
</script>
</head>
<body>
<jsp:include page="WEB-INF/head.jsp"></jsp:include>
<!-- 如果已登陆则跳转首页 -->
<%
boolean isLogin = (boolean)request.getAttribute("isLogin");
if(isLogin) {
	response.sendRedirect("/");
}
%>
 <form action="Login" method="post" class="form-horizontal" role="form">
    <div class="form-group">
	    <div class="col-sm-10">
	    	<input type="text" name="username" class="form-control" placeholder="Username or email address" />
	    </div>
	</div>
	<div class="form-group">
	    <div class="col-sm-10">
	    	<input type="password" name="password" class="form-control" placeholder="Password" />
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
    	<div class="checkbox">
        <label>
        	<input type="checkbox" name="remember_me"> Remember me(42 days)
        </label>
      	</div>
    </div>
  	</div>
    <div class="form-group">
    <div class="col-sm-10">
    	<button type="submit" class="btn btn-default">login</button>
	</div>
	</div>
</form>
</body>
</html>