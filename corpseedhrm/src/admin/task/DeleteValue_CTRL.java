package admin.task;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import client_master.Clientmaster_ACT;

public class DeleteValue_CTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try
		{
			String pid=null;
			String psdate=null;
			String Enq=null;
			String Enqprice=null;
			String[] preguid=null;
			HttpSession session=request.getSession();
			String token=(String)session.getAttribute("uavalidtokenno");
			String id=request.getParameter("id").trim();
			String attribute=request.getParameter("attribute").trim();
			String attributetoken=request.getParameter("attributetoken").trim();
			String table=request.getParameter("table").trim();
			
			if(table.equalsIgnoreCase("project_price")){
				Enqprice=request.getParameter("Enqprice");
				if(Enqprice.equalsIgnoreCase("NA"))
					preguid=TaskMaster_ACT.getProjectpreguid(id,token);		
			}
			
			if(table.equalsIgnoreCase("product_milestone")){
				pid=TaskMaster_ACT.getProductId(id,token);				
			}
			if(table.equalsIgnoreCase("project_milestone")){
				Enq=request.getParameter("Enq");
				pid=TaskMaster_ACT.getProjectId(id,token);			
				if(Enq.equalsIgnoreCase("NA"))
				psdate=TaskMaster_ACT.getProjectSDate(pid,token);		
			}
			
			TaskMaster_ACT.deleteRecord(id,attribute,attributetoken,table,token);
			if(table.equalsIgnoreCase("product_milestone")){				
				TaskMaster_ACT.updateProductTimeline(pid,token);				
			}
			if(table.equalsIgnoreCase("project_milestone")){				
				Clientmaster_ACT.updateProjectTimeline(pid,token,Enq);
				if(Enq.equalsIgnoreCase("NA"))
				Clientmaster_ACT.updateDeliveryDate(psdate,pid,token);
			}
			if(table.equalsIgnoreCase("project_price")){				
				if(Enqprice.equalsIgnoreCase("NA"))
					Clientmaster_ACT.updateAccountStatement(preguid[0],preguid[1],token,preguid[2]);			
			}
		}catch (Exception e) {

		}

	}
}
