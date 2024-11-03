package admin.export;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.RandomStringUtils;

import admin.enquiry.Enquiry_ACT;
import commons.DateUtil;

public class ExportData_CTRL extends HttpServlet {

	/**
	 * Ajay
	 */
	private static final long serialVersionUID = 8387178096181326861L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			HttpSession session = request.getSession(); 
			PrintWriter pw=response.getWriter();
			
			String from = request.getParameter("from");			
			String to = request.getParameter("to");
			if(from!=null&&from.length()>0)
				from=from.substring(6)+from.substring(2,6)+from.substring(0,2);
			if(to!=null&&to.length()>0)
				to=to.substring(6)+to.substring(2,6)+to.substring(0,2);
			
			String columns = request.getParameter("columns");
			if(columns!=null)columns=columns.trim();
			
			String formate = request.getParameter("formate");
			if(formate!=null)formate=formate.trim();
			
//			String filePassword = request.getParameter("filePassword").trim();
			
			String token = (String)session.getAttribute("uavalidtokenno");
			String loginuaid = (String)session.getAttribute("loginuaid");
			String userRole= (String)session.getAttribute("userRole");
			
//			System.out.println(loginuaid+"\t"+userRole);
			
			String today=DateUtil.getCurrentDateIndianReverseFormat();
			String time=DateUtil.getCurrentTime();
			
			Properties properties = new Properties();
			properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
			String path=properties.getProperty("path")+"exported";
			
//			System.out.println("path=="+path);
			FileUtils.cleanDirectory(new File(path+File.separator)); 
			
//			from=from.substring(6)+from.substring(2,6)+from.substring(0,2);
//			to=to.substring(6)+to.substring(2,6)+to.substring(0,2);
			StringBuffer sql=null;
			String type=request.getParameter("type");
			String pageName="";
						
			if(type.equalsIgnoreCase("estimate")) {	
				String estDoAction=(String)session.getAttribute("estDoAction");
				if(estDoAction==null||estDoAction.length()<=0)estDoAction="All";
				pageName="Estimate";
				sql=new StringBuffer("select "+columns+" from estimatesalectrl where str_to_date(esregdate,'%d-%m-%Y')>='"+from+"' and str_to_date(esregdate,'%d-%m-%Y')<='"+to+"' and estoken='"+token+"'");
				if(!userRole.equalsIgnoreCase("Admin"))
					sql.append(" and essoldbyid='"+loginuaid+"'");
				
				if(!estDoAction.equalsIgnoreCase("NA")&&!estDoAction.equalsIgnoreCase("All")){
					if(estDoAction.equalsIgnoreCase("Invoiced")||estDoAction.equalsIgnoreCase("Draft"))sql.append(" and esstatus='"+estDoAction+"'");
					else if(estDoAction.equalsIgnoreCase("Pending for approval")){
						sql.append(" and exists(select sid from salesestimatepayment where sestsaleno=essaleno and stransactionstatus='2' and stokenno='"+token+"')");
					}
				}
				
			}else if(type.equalsIgnoreCase("Collection")) {
				pageName="Document_Collection";
				sql=new StringBuffer("select "+columns+" from managesalesctrl where str_to_date(document_assign_date,'%d-%m-%Y')>='"+from+"' and str_to_date(document_assign_date,'%d-%m-%Y')<='"+to+"' and mstoken='"+token+"'");				
			}else if(type.equalsIgnoreCase("sales")) {
				
				String salesFilter=(String)session.getAttribute("salesFilter");
				if(salesFilter==null||salesFilter.length()<=0)salesFilter="All";

				String salesInvoiceAction=(String)session.getAttribute("salesInvoiceAction");
				if(salesInvoiceAction==null||salesInvoiceAction.length()<=0)salesInvoiceAction="NA";
				
				String salesPhoneKeyAction=(String)session.getAttribute("salesPhoneKeyAction");
				if(salesPhoneKeyAction==null||salesPhoneKeyAction.length()<=0)salesPhoneKeyAction="NA";

				String salesProductAction=(String)session.getAttribute("salesProductAction");
				if(salesProductAction==null||salesProductAction.length()<=0)salesProductAction="NA";

				String salesClientAction=(String)session.getAttribute("salesClientAction");
				if(salesClientAction==null||salesClientAction.length()<=0)salesClientAction="NA";

				String salesContactAction=(String)session.getAttribute("salesContactAction");
				if(salesContactAction==null||salesContactAction.length()<=0)salesContactAction="NA";

				String salesSoldByUidAction=(String)session.getAttribute("salesSoldByUidAction");
				if(salesSoldByUidAction==null||salesSoldByUidAction.length()<=0)salesSoldByUidAction="NA";

				String salesDateRangeAction=(String)session.getAttribute("salesDateRangeAction");
				if(salesDateRangeAction==null||salesDateRangeAction.length()<=0)salesDateRangeAction="NA";
															
				pageName="Sales";
				
				sql =new StringBuffer("SELECT "+columns+" FROM managesalesctrl ms "
						+ "INNER JOIN contactboxctrl c on ms.mscontactrefid=c.cbrefid "
						+ "INNER JOIN user_account u on ms.mssoldbyuid=u.uaid "
						+ "INNER JOIN hrmclient_billing h on ms.msinvoiceno=h.cbinvoiceno "
						+ "where ms.msstatus='1' and ms.mstoken='"+token+"'");
			
				if(!salesDateRangeAction.equalsIgnoreCase("NA")){
					String fromDate="";
					String toDate="";
					fromDate=salesDateRangeAction.substring(0,10).trim();
					fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.substring(0,2);
					toDate=salesDateRangeAction.substring(13).trim();
					toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2);
					sql.append(" and str_to_date(ms.mssolddate,'%d-%m-%Y')>='"+fromDate+"' "
							+ "and str_to_date(ms.mssolddate,'%d-%m-%Y')<='"+toDate+"'");	
					from=fromDate;to=toDate;
				}
				
				if(salesFilter.equalsIgnoreCase("All"))
					sql.append(" and ms.mscancelstatus='2'");
				else if(salesFilter.equalsIgnoreCase("Cancelled"))
					sql.append(" and ms.mscancelstatus='1'");
				else if(salesFilter.equalsIgnoreCase("In-Progress"))
					sql.append(" and ms.mscancelstatus='2' and ms.msprojectstatus='3'");
				else if(salesFilter.equalsIgnoreCase("Completed"))
					sql.append(" and ms.mscancelstatus='2' and ms.msprojectstatus='2'");
				else if(salesFilter.equalsIgnoreCase("Past-Due"))
					sql.append(" and ms.mscancelstatus='2' and exists(select h.cbuid from hrmclient_billing h where h.cbinvoiceno=ms.msinvoiceno and h.cbdueamount>0)");
				
				if(!salesInvoiceAction.equalsIgnoreCase("NA"))sql.append(" and ms.msinvoiceno='"+salesInvoiceAction+"' ");
				if(!salesPhoneKeyAction.equalsIgnoreCase("NA"))sql.append(" and ms.mscontactrefid='"+salesPhoneKeyAction+"' ");
				if(!salesContactAction.equalsIgnoreCase("NA"))sql.append(" and c.cbname='"+salesContactAction+"' ");
				if(!salesProductAction.equalsIgnoreCase("NA"))sql.append(" and ms.msproductname='"+salesProductAction+"' ");
				if(!salesClientAction.equalsIgnoreCase("NA"))sql.append(" and ms.mscompany='"+salesClientAction+"' ");
				if(!salesSoldByUidAction.equalsIgnoreCase("NA"))sql.append(" and ms.mssoldbyuid='"+salesSoldByUidAction+"' ");
				
				if(!userRole.equalsIgnoreCase("NA")&&userRole.equalsIgnoreCase("Executive")) sql.append(" and ms.mssoldbyuid = '"+loginuaid+"' ");
				else if(!userRole.equalsIgnoreCase("NA")&&(userRole.equalsIgnoreCase("Assistant")||userRole.equalsIgnoreCase("Manager")))
					sql.append(" and exists(select t.mtid from manageteamctrl t join manageteammemberctrl m on t.mtrefid=m.tmteamrefid where t.mtadminid='"+loginuaid+"'"
							+ " and m.tmuseruid=ms.mssoldbyuid or ms.mssoldbyuid='"+loginuaid+"') ");				
					
				
				sql.append("group by ms.msid ");
								
				
			}else if(type.equalsIgnoreCase("milestone_report")) {
				pageName="milestone_report";
				sql=new StringBuffer("select "+columns+" FROM task_progress t \n"
						+ "inner join managesalesctrl m on t.sales_key=m.msrefid inner join manage_assignctrl ma \n"
						+ "on t.task_key=ma.marefid where ma.maworkstarteddate!='00-00-0000' and "
						+ "str_to_date(ma.maworkstarteddate,'%d-%m-%Y')>='"+from+"' "
						+ "and str_to_date(ma.maworkstarteddate,'%d-%m-%Y')<='"+to+"' "
						+ "and t.token='"+token+"' group by t.id "
						+ "order by t.id desc");
		
			}else if(type.equalsIgnoreCase("mytask")) {
				String myTaskDoAction = (String) session.getAttribute("myTaskDoAction");
				if(myTaskDoAction==null||myTaskDoAction.length()<=0)myTaskDoAction="NA";
				pageName="Mytask";
				sql=new StringBuffer("select "+columns+" from manage_assignctrl where str_to_date(maassignDate,'%d-%m-%Y')>='"+from+"' and str_to_date(maassignDate,'%d-%m-%Y')<='"+to+"' and matokenno='"+token+"'");
				if(!myTaskDoAction.equalsIgnoreCase("NA")&&!myTaskDoAction.equalsIgnoreCase("All")){
					sql.append(" and maworkstatus='"+myTaskDoAction+"'");
				}
				if(!userRole.equalsIgnoreCase("Admin"))
					sql.append(" and mateammemberid='"+loginuaid+"'");
				
			}else if(type.equalsIgnoreCase("Delivery")) {
				String deliveryDoAction=(String)session.getAttribute("deliveryDoAction");
				if(deliveryDoAction==null||deliveryDoAction.length()<=0)deliveryDoAction="All";
				pageName="Delivery";
//				sql=new StringBuffer("select "+columns+" from managesalesctrl where str_to_date(mssolddate,'%d-%m-%Y')>='"+from+"' and str_to_date(mssolddate,'%d-%m-%Y')<='"+to+"' and mstoken='"+token+"'");
				sql =new StringBuffer("SELECT "+columns+" FROM managesalesctrl ms "
						+ "INNER JOIN contactboxctrl c on ms.mscontactrefid=c.cbrefid "
						+ "INNER JOIN user_account u on ms.mssoldbyuid=u.uaid "
						+ "INNER JOIN hrmclient_billing h on ms.msinvoiceno=h.cbinvoiceno "
						+ "where str_to_date(ms.mssolddate,'%d-%m-%Y')>='"+from+"' "
								+ "and str_to_date(ms.mssolddate,'%d-%m-%Y')<='"+to+"' "
										+ " and ms.msstatus='1' and ms.mstoken='"+token+"'");
				
				if(!deliveryDoAction.equalsIgnoreCase("NA")&&!deliveryDoAction.equalsIgnoreCase("All")){
					sql.append(" and ms.msworkstatus='"+deliveryDoAction+"'");
				}
			}else if(type.equalsIgnoreCase("Account")) {
				pageName="Account";
				sql=new StringBuffer("select "+columns+" from `client_accounts` a join hrmclient_reg c on c.creguid=a.cacid where SUBSTRING(caaddedon, 1, 10)>='"+from+"' and SUBSTRING(caaddedon, 1, 10)<='"+to+"' and catokenno='"+token+"'");
			
			}else if(type.equalsIgnoreCase("Billing")) {
				pageName="Billing";
				String billingDoAction=(String)session.getAttribute("billingDoAction");
				if(billingDoAction==null||billingDoAction.length()<=0)billingDoAction="All";
				
				sql=new StringBuffer("select "+columns+" from hrmclient_billing where cbtokenno= '"+token+"' and str_to_date(cbdate,'%d-%m-%Y')>='"+from+"' and str_to_date(cbdate,'%d-%m-%Y')<='"+to+"'");
				if(!billingDoAction.equalsIgnoreCase("NA")){
					if(billingDoAction.equalsIgnoreCase("Paid"))sql.append(" and cbdueamount='0'");
					else if(billingDoAction.equalsIgnoreCase("Current")){
						sql.append(" and exists(select msid from managesalesctrl where msworkpercent!='100' and msestimateno=cbestimateno and mstoken='"+token+"')");
					}
					else if(billingDoAction.equalsIgnoreCase("Past due")){
						sql.append(" and exists(select msid from managesalesctrl where msworkpercent='100' and msestimateno=cbestimateno and mstoken='"+token+"') and cbdueamount!='0'");
					} 
				}
		
			}else if(type.equalsIgnoreCase("Transaction")) {
				pageName="Transaction";
				String transactionDoAction = (String) session.getAttribute("transactionDoAction");
				if(transactionDoAction==null||transactionDoAction.length()<=0)transactionDoAction="All";
				
				sql=new StringBuffer("select "+columns+" from managetransactionctrl where mtstatus='1' and mttokenno= '"+token+"' and str_to_date(mtdate,'%d-%m-%Y')>='"+from+"' and str_to_date(mtdate,'%d-%m-%Y')<='"+to+"'");
				if(!transactionDoAction.equalsIgnoreCase("NA")&&!transactionDoAction.equalsIgnoreCase("All"))sql.append(" and mttype='"+transactionDoAction+"'");
	
			}else if(type.equalsIgnoreCase("Approve_Expense")) {
				pageName="Approve_Expense";				
				sql=new StringBuffer("select "+columns+" from expense_approval_ctrl where expapprovalstatus='2' and exptoken= '"+token+"' and str_to_date(expdate,'%d-%m-%Y')>='"+from+"' and str_to_date(expdate,'%d-%m-%Y')<='"+to+"'");
			}else if(type.equalsIgnoreCase("Credit-history")) {
				pageName="Credit-history";				
				sql=new StringBuffer("select "+columns+" from salesworkpricectrl where swtokenno= '"+token+"' and str_to_date(swcreditdate,'%d-%m-%Y')>='"+from+"' and str_to_date(swcreditdate,'%d-%m-%Y')<='"+to+"'");
			}else if(type.equalsIgnoreCase("Product")) {
				pageName="Product";				
				sql=new StringBuffer("select "+columns+" from `product_master` p join product_price pp  on p.prefid=pp.pp_prodrefid where ptokenno= '"+token+"' and SUBSTRING(paddedon, 1, 10)>='"+from+"' and SUBSTRING(paddedon, 1, 10)<='"+to+"' group by p.pid");
			}else if(type.equalsIgnoreCase("Template")) {
				String templateDoAction=(String)session.getAttribute("templateDoAction");
				if(templateDoAction==null||templateDoAction.length()<=0)templateDoAction="All";
				pageName="Template";				
				sql=new StringBuffer("select "+columns+" from manage_template WHERE tstatus='1' and ttokenno='"+token+"' and str_to_date(tdate,'%d-%m-%Y')>='"+from+"' and str_to_date(tdate,'%d-%m-%Y')<='"+to+"'");
				if(!templateDoAction.equalsIgnoreCase("NA")&&!templateDoAction.equalsIgnoreCase("All"))sql.append(" and ttype='"+templateDoAction+"'");
			}else if(type.equalsIgnoreCase("Guide")) {
				pageName="Guide";				
				sql=new StringBuffer("select "+columns+" from step_guide where sgststus='1' and sgtoken='"+token+"' and str_to_date(sgdate,'%d-%m-%Y')>='"+from+"' and str_to_date(sgdate,'%d-%m-%Y')<='"+to+"'");
			}else if(type.equalsIgnoreCase("Trigger")) {
				pageName="Trigger";				
				sql=new StringBuffer("select "+columns+" from triggers where tToken='"+token+"' and str_to_date(tDate,'%d-%m-%Y')>='"+from+"' and str_to_date(tDate,'%d-%m-%Y')<='"+to+"'");
			}else if(type.equalsIgnoreCase("Tax")) {
				pageName="Tax";				
				sql=new StringBuffer("select "+columns+" from managetaxctrl where mttoken='"+token+"' and SUBSTRING(mtaddedon,'1,10')>='"+from+"' and SUBSTRING(mtaddedon,'1,10')<='"+to+"'");
			}else if(type.equalsIgnoreCase("Team")) {
				String teamDoAction=(String)session.getAttribute("teamDoAction");
				if(teamDoAction==null||teamDoAction.length()<=0)teamDoAction="NA";
				pageName="Team";				
				sql=new StringBuffer("select "+columns+" from manageteamctrl where mttoken='"+token+"' and SUBSTRING(mtaddedon,'1,10')>='"+from+"' and SUBSTRING(mtaddedon,'1,10')<='"+to+"'");
				if(!teamDoAction.equalsIgnoreCase("NA"))sql.append(" and mtdepartment='"+teamDoAction+"'");
			}else if(type.equalsIgnoreCase("Contact")) {
				pageName="Contact";				
				sql=new StringBuffer("select "+columns+" from clientcontactbox where cctokenno='"+token+"' and SUBSTRING(ccaddedon,'1,10')>='"+from+"' and SUBSTRING(ccaddedon,'1,10')<='"+to+"'");
			}else if(type.equalsIgnoreCase("Coupon")) {
				pageName="Coupon";				
				sql=new StringBuffer("select "+columns+" from manage_coupon where token='"+token+"' and postDate>='"+from+"' and postDate<='"+to+"'");
			}else if(type.equalsIgnoreCase("Client")) {
				pageName="Client";				
				sql=new StringBuffer("select "+columns+" from hrmclient_reg where cregtokenno='"+token+"' and SUBSTRING(cregaddedon,'1,10')>='"+from+"' and SUBSTRING(cregaddedon,'1,10')<='"+to+"'");
			}else if(type.equalsIgnoreCase("unbilled")) {
				pageName="unbilled";				
				sql=new StringBuffer("select "+columns+" FROM salesestimatepayment s INNER JOIN estimatesalectrl e on"
						+ " s.sestsaleno=e.essaleno inner join estimatepaymentdetails es on s.srefid=es.payment_uid INNER JOIN contactboxctrl cb on e.escontactrefid=cb.cbrefid "
						+ "where s.stransactionstatus='1' and s.stokenno='"+token+"' and s.sinvoice_status='2' and "
								+ "s.sarchivestatus='2' and SUBSTRING(s.saddedon,'1,10')>='"+from+"' and "
										+ "SUBSTRING(s.saddedon,'1,10')<='"+to+"' group by s.sid");
				
			}else if(type.equalsIgnoreCase("invoiced")) {
				pageName="invoiced";				
				sql=new StringBuffer("select "+columns+" from invoice i inner join salesestimatepayment s on i.unbill_no=s.sunbill_no "
						+ "inner join estimatepaymentdetails e on s.srefid=e.payment_uid "
						+ "where i.token='"+token+"' and i.status='1' and i.date>='"+from+"' and i.date<='"+to+"' group by i.id");
				
			}	
			
			
//			System.out.println(sql);
			ExportData expData=new ExportData();
			String export = expData.export(pageName, sql.toString(),path,token,formate);
						
			pw.write(export);
			//inserting invoice download history
		    String key=RandomStringUtils.random(40,true,true);
		    Enquiry_ACT.addDownloadHistory(key,"Exported","NA",from+" - "+to,today,time,loginuaid,pageName,token);
		    
//			System.out.println(from+"/"+toDate+"/"+columns+"/"+formate+"/"+filePassword);
			
		}

		catch (Exception e) {
			e.printStackTrace();
		}

	}
}