<%@page import="util.JDBC"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 
if("GET".equals(request.getMethod())) {
	
	String str = request.getRequestURI();
	String[] strs = str.split("/");
	int topic_id = 0;
	String topic_name = "";

	try {
		topic_id = Integer.valueOf(strs[3]);
		System.out.println(topic_id);
	}
	catch(Exception e) {
		e.printStackTrace();
		response.sendError(404);
	}
	
	
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	
	try {
		conn = JDBC.getConnection();
		
		StringBuilder sql = new StringBuilder();
		sql.append("SELECT topic_name ");
		sql.append("FROM topics ");
		sql.append("WHERE ");
		sql.append("topic_id =? ;");
		
		stmt = conn.prepareStatement(sql.toString());
		stmt.setInt(1, topic_id);
		rs = stmt.executeQuery();

		if(rs.next()) {
			topic_name = rs.getString("topic_name");
		}
		else{
			response.sendError(404);
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
<!DOCTYPE html>
<html>
<head>
    <title>Chat[topic]:<%=topic_name %></title>
</head>
<body>
<jsp:include page="/WEB-INF/head.jsp"></jsp:include>
<%
boolean isLogin = (boolean)request.getAttribute("isLogin");
if(!isLogin) {
	out.println("<script>alert('请先登录');</script>");
	out.println("<a href='/login'>登陆</a>");
	//response.sendRedirect("/login");
	//return;
}
else {
%>
<a href="/topic/<%=topic_id %>"><h3><%=topic_name %></h3></a>
	<textarea rows="10" id="message" class="form-control"  readonly autofocus>
    </textarea>
    <input type="hidden" id="user_id" value="<%=request.getAttribute("user_id") %>">
	<input type="hidden" id="verify" value="<%=request.getAttribute("verify") %>">
    <input type="text" class="form-control" id="text" onkeypress="EnterPress()" placeholder="回车回复"/>
    <button type="button" class="btn btn-default" onclick="send()">发送消息</button>
    <button type="button" class="btn btn-danger" onclick="closeWebSocket()">关闭WebSocket连接</button>
</body>

<script type="text/javascript">
	var host = window.location.host;
    var websocket = null;
    //判断当前浏览器是否支持WebSocket
    if ('WebSocket' in window) {
        websocket = new WebSocket("ws://" + host + "/chattopic/" + <%=topic_id%>);
    }
    else {
        alert('当前浏览器 Not support websocket')
    }
    

    //连接发生错误的回调方法
    websocket.onerror = function () {
        setMessageInnerHTML("Chat[topic]:<%=topic_name %>  连接发生错误");
    };

    //连接成功建立的回调方法
    websocket.onopen = function () {
        setMessageInnerHTML("Chat[topic]:<%=topic_name %>  连接成功");
    }

    //接收到消息的回调方法
    websocket.onmessage = function (event) {
        setMessageInnerHTML(event.data);
    }

    //连接关闭的回调方法
    websocket.onclose = function () {
        setMessageInnerHTML("Chat[topic]:<%=topic_name %>  连接关闭");
    }

    //监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
    window.onbeforeunload = function () {
        closeWebSocket();
    }

    //将消息显示在网页上
    function setMessageInnerHTML(innerHTML) {
        document.getElementById('message').innerHTML += innerHTML + '\n';
    }

    //关闭WebSocket连接
    function closeWebSocket() {
        websocket.close();
    }

    //发送消息
    function send() {
    	//var nickname = document.getElementById('nickname').value;
    	var user_id = document.getElementById('user_id').value;
    	var verify = document.getElementById('verify').value;
        var message = document.getElementById('text').value;
        if(message=="") {
        	return;
        }
        websocket.send(user_id + ">" + verify + ">" + message);
        document.getElementById('text').value = "";
    }
    
    function EnterPress() {
    	if(event.keyCode == 13){ 
    		send();
    	} 
    }
</script>
<%} %>
</html>
<%
}
%>