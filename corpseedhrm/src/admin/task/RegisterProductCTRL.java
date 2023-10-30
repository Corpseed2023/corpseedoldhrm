package admin.task;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@SuppressWarnings("serial")
public class RegisterProductCTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		 		   
		String token = (String) session.getAttribute("uavalidtokenno");
		String loginuID = (String) session.getAttribute("loginuID");	
		
		String prodrefid = request.getParameter("productregrefid").trim();
		String remarks = request.getParameter("productRemarks").trim();
		String centralType = request.getParameter("centralType");
		String stateType = request.getParameter("stateType");
		String globalType = request.getParameter("globalType");
		String productTatValue=request.getParameter("productTat");
		if(productTatValue==null||productTatValue.length()<=0)productTatValue="0";
		String tatType=request.getParameter("tatType");
		if(tatType==null||tatType.length()<=0)tatType="NA";
		
		if(centralType==null)centralType="0";
		else centralType=centralType.trim();
		
		if(stateType==null)stateType="0";
		else stateType=stateType.trim();
		
		if(globalType==null)globalType="0";
		else globalType=globalType.trim();
				
		if(!prodrefid.equalsIgnoreCase("NA")&&prodrefid!=""&&prodrefid!=null){			
				//adding remarks in product master table
				TaskMaster_ACT.updateDescription(prodrefid,token,remarks,centralType,stateType,globalType,Integer.parseInt(productTatValue),tatType);
				//getting all virtual price details
				String price[][]=TaskMaster_ACT.getAllPriceDetailsFromVirtual(prodrefid,token,loginuID);
				//saving into product_price table
				if(price!=null&&price.length>0){
					for(int i=0;i<price.length;i++){		
//						System.out.println("Price Type="+price[i][0]);
						TaskMaster_ACT.saveProductPriceDetails(prodrefid,price[i][0],price[i][1],price[i][2],price[i][3],price[i][4],price[i][5],price[i][6],token,loginuID);
					}
				}
				//getting all virtual milestone details
				String milestone[][]=TaskMaster_ACT.getAllMilestoneDetailsFromVirtual(prodrefid,token,loginuID);
				//saving into product_milestone table
				if(milestone!=null&&milestone.length>0){
					for(int i=0;i<milestone.length;i++){
						int stepNo=Integer.parseInt(milestone[i][3]);
						String assign=milestone[i][4];
						String workPercent=milestone[i][5];
												
						if(stepNo==0||stepNo>milestone.length)stepNo=1;
						if(assign==null||assign=="")assign="0";
						if(workPercent==null||workPercent=="")workPercent="0";
						
						TaskMaster_ACT.saveProductMilestoneDetails(prodrefid,milestone[i][0],milestone[i][1],milestone[i][2],stepNo,assign,workPercent,token,loginuID);
					}
				}else {
					boolean isExist=TaskMaster_ACT.isProductMilestoneExist(prodrefid, token);
					if(!isExist) {
					//add default milestones 
						TaskMaster_ACT.saveDefaultMilestones(prodrefid,loginuID,token);
					}
				}
				//getting all virtual document details
				String documents[][]=TaskMaster_ACT.getAllDocumentDetailsFromVirtual(prodrefid,token,loginuID);
				//saving into product_document table
				if(documents!=null&&documents.length>0){
					for(int i=0;i<documents.length;i++){
						TaskMaster_ACT.saveProductDocumentDetails(prodrefid,documents[i][0],documents[i][1],documents[i][2],token,loginuID,documents[i][3]);
					}
				}else {
					boolean isExist=TaskMaster_ACT.isProductDocumentExist(prodrefid, token);
					if(!isExist) {
						//add default documents
							TaskMaster_ACT.saveDefaultDocuments(prodrefid,loginuID,token);
						}
				}
				
				//empty virtual price table
				TaskMaster_ACT.clearPriceVirtualTable(prodrefid,token,loginuID); 
			//empty virtual milestone table
				TaskMaster_ACT.clearMilestoneVirtualTable(prodrefid,token,loginuID);  
			//empty virtual milestone table
				TaskMaster_ACT.clearDocumentVirtualTable(prodrefid,token,loginuID);  
		}
		RequestDispatcher RD = request.getRequestDispatcher("/manage-product.html");
		RD.forward(request, response);
		
	}

}