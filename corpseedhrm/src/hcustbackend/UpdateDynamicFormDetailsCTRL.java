package hcustbackend;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class UpdateDynamicFormDetailsCTRL extends HttpServlet {
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		   		
		try {
			HttpSession session=request.getSession();
			String fKey=request.getParameter("fKey").trim();
			String formDataJson =(String)request.getParameter("formDataJson");
//			System.out.println(formDataJson+"/"+fKey);
			String token=(String)session.getAttribute("uavalidtokenno");
			boolean flag=false;
			if(formDataJson!=null&&formDataJson.length()>0&&fKey!=null&&fKey.length()>0){
			 
				flag=ClientACT.updateDynamicFormData(fKey,formDataJson,token);
							
			}
			PrintWriter pw=response.getWriter();
			if(flag)pw.write("pass");
			else pw.write("fail");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
