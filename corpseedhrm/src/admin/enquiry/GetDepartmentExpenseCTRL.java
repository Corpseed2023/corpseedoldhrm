package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.DecimalFormat;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.master.Usermaster_ACT;
import admin.task.TaskMaster_ACT;

public class GetDepartmentExpenseCTRL extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			PrintWriter out=response.getWriter();
						
			HttpSession session = request.getSession();
			DecimalFormat df = new DecimalFormat("####0.00");
			String token = (String)session.getAttribute("uavalidtokenno");
			String loginuaid = (String)session.getAttribute("loginuaid");
			String department=Usermaster_ACT.getUserDepartment(loginuaid,token);
			if(department.equals("Admin")||department.equals("Account")) {
			double sales=TaskMaster_ACT.getExpenseByDepartment("Sales",token);
			double marketing=TaskMaster_ACT.getExpenseByDepartment("Marketing",token);
			double it=TaskMaster_ACT.getExpenseByDepartment("IT",token);
			double hr=TaskMaster_ACT.getExpenseByDepartment("HR",token);
			double accounts=TaskMaster_ACT.getExpenseByDepartment("Account",token);			
//			System.out.println("department="+department);
			out.write(df.format(sales)+"#"+df.format(marketing)+"#"+df.format(it)+"#"+df.format(hr)+"#"+df.format(accounts));
			}
		}catch (Exception e) {
				e.printStackTrace();
		}

	}
}