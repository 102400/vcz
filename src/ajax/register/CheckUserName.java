package ajax.register;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.UserDAO;
import rule.Email;
import rule.Username;
import vo.User;

@WebServlet("/checkusername")
public class CheckUserName extends HttpServlet {
	
	@Override
	protected void doGet(HttpServletRequest requset, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.sendError(404);
	}
	
	@Override
	protected void doPost(HttpServletRequest requset, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		requset.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter out = response.getWriter();
		
		String username = requset.getParameter("username");
		User user = new User();
		user.setUserName(username);
		
		String s = "";
		boolean legal = new Username(username).isLegal();
		boolean exists = new UserDAO().isUserNameExists(user);
		if(legal) {
			s = s + "legal,";
		}
		if(exists) {
			s = s + "exists";
		}
		out.print(s);
		
	}

}
