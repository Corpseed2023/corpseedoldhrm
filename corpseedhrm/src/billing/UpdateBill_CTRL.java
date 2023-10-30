package billing;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import client_master.Clientmaster_ACT;


public class UpdateBill_CTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{

		try
		{
			boolean status =false;
			HttpSession session = request.getSession();
			
			String uid = request.getParameter("uid").trim();
			String cbcuid = request.getParameter("cid").trim();
			String cbype = request.getParameter("BillingType").trim();
			String cbquotationvalue = request.getParameter("QuotationValue").trim();
			String cbfvalue = request.getParameter("FinalValue").trim();
			String cbdisvalue = request.getParameter("Discount").trim();
			String cbremark = request.getParameter("shortdescription").trim();
		

		status=Clientmaster_ACT.updateBill(uid,cbcuid,cbquotationvalue, cbype, cbdisvalue, cbremark, cbfvalue);
		if(status)
		{
			session.setAttribute("ErrorMessage", "Billing is Successfully updated!.");
			response.sendRedirect(request.getContextPath()+"/notification.html");
		}
		else {
			session.setAttribute("ErrorMessage", "Billing is not updated!.");
			response.sendRedirect(request.getContextPath()+"/notification.html");
		}
	}
		
		catch(Exception e)
		{
				
		}
		
	
	}
		
	}


