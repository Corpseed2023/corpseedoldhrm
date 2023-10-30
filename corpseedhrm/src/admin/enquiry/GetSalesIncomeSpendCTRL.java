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
import commons.DateUtil;

public class GetSalesIncomeSpendCTRL extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			PrintWriter out=response.getWriter();
						
			HttpSession session = request.getSession();
			DecimalFormat df = new DecimalFormat("####0.00");
			String today=DateUtil.getCurrentDateIndianReverseFormat();
			String year=today.substring(0, 5);
			int month=Integer.parseInt(today.substring(5, 7));
			String token = (String)session.getAttribute("uavalidtokenno");
			String loginuaid = (String)session.getAttribute("loginuaid");
			String department=Usermaster_ACT.getUserDepartment(loginuaid,token);
			if(department.equals("Admin")||department.equals("Account")) {
			
			String monthEnd[]=new String[12];
			String monthStart[]=new String[12];
			monthStart[0]=year+"01"+"-01";
			monthEnd[0]=year+"01"+"-31";
			monthStart[1]=year+"02"+"-01";
			monthEnd[1]=year+"02"+"-28";
			monthStart[2]=year+"03"+"-01";
			monthEnd[2]=year+"03"+"-31";
			monthStart[3]=year+"04"+"-01";
			monthEnd[3]=year+"04"+"-30";
			monthStart[4]=year+"05"+"-01";
			monthEnd[4]=year+"05"+"-31";
			monthStart[5]=year+"06"+"-01";
			monthEnd[5]=year+"06"+"-30";
			monthStart[6]=year+"07"+"-01";
			monthEnd[6]=year+"07"+"-31";
			monthStart[7]=year+"08"+"-01";
			monthEnd[7]=year+"08"+"-31";
			monthStart[8]=year+"09"+"-01";
			monthEnd[8]=year+"09"+"-30";
			monthStart[9]=year+"10"+"-01";
			monthEnd[9]=year+"10"+"-31";
			monthStart[10]=year+"11"+"-01";
			monthEnd[10]=year+"11"+"-30";
			monthStart[11]=year+"12"+"-01";
			monthEnd[11]=year+"12"+"-31";
			
			double income[]=new double[12];
			double spend[]=new double[12];
			for(int i=0;i<12;i++) {
				if(i<month) {
				income[i]=TaskMaster_ACT.getSalesIncome(monthStart[i],monthEnd[i],token);
				spend[i]=TaskMaster_ACT.getExpenseSpend(monthStart[i],monthEnd[i],token);
				}else {
					income[i]=0;
					spend[i]=0;
				}
			}
			double totalRevenue=0;
			double departmentExp=0;
			double totalRevenuePer=0;
			double departmentExpPer=0;
			
			double salesAmount=Enquiry_ACT.getSalesOrderAmount(token);
			double salesDiscount=Enquiry_ACT.getTotalDiscountPrice(token);
			if(salesAmount>0) {
				double pogm=TaskMaster_ACT.sumDefaultFee(token)-salesDiscount;
				departmentExp=TaskMaster_ACT.sumDepartExpense(token);
				totalRevenue=pogm-departmentExp;
//			System.out.println(salesAmount+"/"+pogm+"/"+departmentExp+"/"+totalRevenue);
				totalRevenuePer=(100*totalRevenue)/salesAmount;
				departmentExpPer=(100*departmentExp)/salesAmount;
			}
			String inc=income[0]+"#"+income[1]+"#"+income[2]+"#"+income[3]+"#"+income[4]+"#"+income[5]+"#"+income[6]+"#"+income[7]+"#"+income[8]+"#"+income[9]+"#"+income[10]+"#"+income[11];
			String spe=spend[0]+"#"+spend[1]+"#"+spend[2]+"#"+spend[3]+"#"+spend[4]+"#"+spend[5]+"#"+spend[6]+"#"+spend[7]+"#"+spend[8]+"#"+spend[9]+"#"+spend[10]+"#"+spend[11];
			
			out.write(inc+"#"+spe+"#"+df.format(totalRevenuePer)+"#"+df.format(departmentExpPer));
			}
		}catch (Exception e) {
				e.printStackTrace();
		}

	}
}