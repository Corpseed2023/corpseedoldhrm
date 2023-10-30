package admin.task;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;


@SuppressWarnings("serial")
public class SalesHierarchyVirtual_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		 
		PrintWriter pw=response.getWriter();
		 boolean flag=false; 
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		String loginuID = (String) session.getAttribute("loginuID");	
		
		String salesrefid = request.getParameter("salesrefid").trim();
		String type = request.getParameter("type").trim();
		String numbering = request.getParameter("numbering").trim();				
		String salesinvoice = request.getParameter("salesinvoice").trim();		
	
		String  refid=TaskMaster_ACT.isHierarchyExist(salesrefid,uavalidtokenno,loginuID);
	
		if(refid!=null&&!refid.equalsIgnoreCase("NA")){
			//update hierarchy
			flag=TaskMaster_ACT.updateSalesVirtualHierarchy(refid,salesrefid,type,numbering,salesinvoice,uavalidtokenno,loginuID);
		}else{
			//insert new hierarchy
			String virtualkey=RandomStringUtils.random(40,true,true);
			flag=TaskMaster_ACT.saveSalesHierarchy(virtualkey,salesrefid,type,numbering,salesinvoice,uavalidtokenno,loginuID);
		}
		
		if(flag)pw.write("pass");
		else pw.write("fail");
	}

}