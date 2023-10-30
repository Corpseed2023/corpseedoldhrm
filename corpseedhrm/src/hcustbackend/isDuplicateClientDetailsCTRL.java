package hcustbackend;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class isDuplicateClientDetailsCTRL extends HttpServlet {
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		   		
		try {
			HttpSession session=request.getSession();
			String loginuaid = (String) session.getAttribute("loginuaid");
			String colname=request.getParameter("colname");
			if(colname!=null)colname=colname.trim();
			
			String value =request.getParameter("value");	
			if(value!=null)value=value.trim();
			
			String clientId =request.getParameter("clientId");
			if(clientId!=null)clientId=clientId.trim();
			
			String token=(String)session.getAttribute("uavalidtokenno");		 	
			
			boolean flag=ClientACT.isColumnValueExist(colname,value,clientId,token,loginuaid);
			
			PrintWriter pw=response.getWriter();
			if(flag)pw.write("pass");
			else pw.write("fail");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
