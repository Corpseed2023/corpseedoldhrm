package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class GetPayType_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			PrintWriter out=response.getWriter();
						
			HttpSession session = request.getSession(); 
			String token = (String)session.getAttribute("uavalidtokenno");
			
			String estimateno=request.getParameter("estimateno");
			String show=Enquiry_ACT.isPaymentApproved(estimateno,token); 
//			System.out.println("show="+show);
			
			StringBuffer tData=new StringBuffer();
			String estimate[][]=Enquiry_ACT.getEstimatesByNo(estimateno,token);
			if(estimate!=null&&estimate.length>0) {
				for(int i=0;i<estimate.length;i++) {
					String esPayType=Enquiry_ACT.getEstimateSalesPayType(estimate[i][0], token);
					String full_pay="";
					String partial_pay="";
					String milestone_pay="";
					String readonly="";
					String prodName=estimate[i][1];
					String consultationReadonly="";
					if(estimate[i][3].equals("2")) {prodName="Consultation Service";esPayType="Full Pay";consultationReadonly="disabled='disabled'";}
					
					if(show.equalsIgnoreCase("Yes"))readonly="disabled='disabled'";
//					System.out.println("pay type====="+esPayType);
					if(esPayType.equalsIgnoreCase("Full Pay"))full_pay="checked='checked'";
					else if(esPayType.equalsIgnoreCase("Partial Pay"))partial_pay="checked='checked'";
					else if(esPayType.equalsIgnoreCase("Milestone Pay"))milestone_pay="checked='checked'";
					
					tData.append("<tr>\n"
							+ "      <td>"+prodName+"</td>\n"
							+ "      <td>\n"
							+ "         <span>\n"
							+ "         <input type=\"radio\" name=\"payType"+i+"\" "+full_pay+" "+readonly+" "+consultationReadonly+" class=\"closem\" onclick=\"updatePayType('Full Pay','"+estimate[i][0]+"');hideTaskDetails('pay_box"+i+"')\">\n"
							+ "         <label for=\"Full_PayId\" title=\"In Full Pay Option Client have to pay full payment to start work !!\">Full Pay</label>\n"
							+ "         </span>\n"
							+ "         <span style=\"margin-left: 35px;\">\n"
							+ "         <input type=\"radio\" name=\"payType"+i+"\" "+partial_pay+" "+readonly+" "+consultationReadonly+" class=\"closem\" onclick=\"updatePayType('Partial Pay','"+estimate[i][0]+"');hideTaskDetails('pay_box"+i+"')\">\n"
							+ "         <label for=\"Partial_PayId\" title=\"In Partial Pay Option Client have to pay 50 % of total payment to start work !!\">Partial Pay</label>\n"
							+ "         </span>\n"
							+ "         <span style=\"margin-left: 35px;\">\n"
							+ "         <input type=\"radio\" name=\"payType"+i+"\" "+milestone_pay+" "+readonly+" "+consultationReadonly+" class=\"expand\" onclick=\"updatePayType('Milestone Pay','"+estimate[i][0]+"');showTaskDetails('pay_box"+i+"')\">\n"
							+ "         <label for=\"Milestone_PayId\" title=\"In Milestone Pay Option Client have to pay according to milestone percentage to start work !!\">Milestone Pay</label>\n"
							+ "         </span>\n"
							+ "      </td>\n"
							+ "   </tr>\n");
					String payType[][]=Enquiry_ACT.getPayType(estimate[i][0], token);
					if(payType!=null&&payType.length>0){
						
						String display="display:none";
						if(esPayType.equalsIgnoreCase("Milestone Pay"))display="display:block";
						tData.append("<tr>"
								+ "      <td colspan=\"3\" style=\"padding:0\">\n"
								+ "         <div class=\"clearfix milestone_pay_box  pay_box"+i+"\" style=\""+display+"\">");
						for(int j=0;j<payType.length;j++){
							tData.append("<div class=\"row mb10 payTypeRemove\">\n"
									+ "               <div class=\"col-md-8 col-sm-8 col-xs-12\">\n"
									+ "                  <p>"+payType[j][1]+"</p>\n"
									+ "               </div>\n"
									+ "               <div class=\"col-md-3 col-sm-3 col-xs-12\">\n"
									+ "                  <p>\n"
									+ "                     <input type=\"text\" title=\"To Start Work (Percentage of Total Price)\" onchange=\"validateNumber(this.value,'pricePercent"+i+"');updatePricePercentage('"+payType[j][0]+"',this.value)\" value=\""+payType[j][3]+"\" id=\"pricePercent"+i+"\" class=\"form-control text-center\" onkeypress=\"return isNumber(event)\" "+readonly+">\n"
									+ "                  </p>\n"
									+ "               </div>\n"
									+ "               <div class=\"col-md-1 col-sm-1 col-xs-12\">\n"
									+ "                  <p><i class=\"fa fa-percent\"></i></p>\n"
									+ "               </div>\n"
									+ "            </div>");
						}
						tData.append("</div></td></tr>");
					}
					
				}
				out.write(tData.toString());
			}
		}

		catch (Exception e) {
				e.printStackTrace();
		}

	}
}