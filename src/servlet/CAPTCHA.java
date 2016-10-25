package servlet;

import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.PrintWriter;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class CAPTCHA extends HttpServlet {
	
	private static final int WIDTH = 100;
	private static final int HEIGHT = 25;

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		String s = "abcdefg";

		BufferedImage bi = new BufferedImage(WIDTH, HEIGHT, BufferedImage.TYPE_INT_RGB);
		Graphics2D g = (Graphics2D)bi.getGraphics();
		
		g.drawString(s, 10, 10);
		
		
		HttpSession session = request.getSession();
		session.setMaxInactiveInterval(60*2);
		session.setAttribute("CAPTCHA", s);
		
		Cookie cookie = new Cookie("JSESSIONID",session.getId());
		cookie.setMaxAge(60*2);
		
		response.addCookie(cookie);
		
		ImageIO.write(bi, "png", response.getOutputStream());
	}
	
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		response.sendError(404);
		
	}

}
