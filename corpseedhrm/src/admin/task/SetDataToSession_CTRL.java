package admin.task;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class SetDataToSession_CTRL extends HttpServlet {	
	
	private static final long serialVersionUID = 7047865640006721870L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
			
		String data = request.getParameter("data").trim();	
		String name = request.getParameter("name").trim();	
		
		if(data!=null&&name!=null){
			session.setAttribute(name, data);
		}
		
	}

}