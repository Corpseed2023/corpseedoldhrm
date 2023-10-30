package hcustbackend;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import client_master.Clientmaster_ACT;
import commons.EmailVerifier;

@SuppressWarnings("serial")
public class UpdateBusinessDetailsCTRL extends HttpServlet {
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		   		
		try {
			HttpSession session=request.getSession();
			
			String company_id=request.getParameter("company_Name");
			if(company_id!=null)company_id=company_id.trim();
			
			String bussName=request.getParameter("bussName");
			if(bussName!=null)bussName=bussName.trim();
			
			String bussPhone =request.getParameter("bussPhone");
			if(bussPhone!=null)bussPhone=bussPhone.trim();
			
			String bussEmail =request.getParameter("bussEmail");
			if(bussEmail!=null)bussEmail=bussEmail.trim();
			
			String industryType=request.getParameter("industryType");
			if(industryType!=null)industryType=industryType.trim();
			
			String bussPan=request.getParameter("bussPan");
			if(bussPan!=null)bussPan=bussPan.trim();
			
			String bussGst=request.getParameter("bussGst");
			if(bussGst!=null)bussGst=bussGst.trim();
			
			String company_age=request.getParameter("company_age");
			if(company_age!=null)company_age=company_age.trim();
			
			String bussCountry=request.getParameter("bussCountry");
			if(bussCountry!=null)bussCountry=bussCountry.trim();
			
			String bussCity=request.getParameter("bussCity");
			if(bussCity!=null)bussCity=bussCity.trim();
			
			String bussState =request.getParameter("bussState");
			if(bussState!=null)bussState=bussState.trim();
			
			String stateCode =request.getParameter("stateCode");
			if(stateCode!=null)stateCode=stateCode.trim();
			
			String bussAddress =request.getParameter("bussAddress");
			if(bussAddress!=null)bussAddress=bussAddress.trim();
						
			String token=(String)session.getAttribute("uavalidtokenno");
			
			String clientrefid=Clientmaster_ACT.findClientKeyById(company_id, token);
			
			boolean flag=false;
			String client[][]=ClientACT.getClientByNo(clientrefid, token);
			PrintWriter pw=response.getWriter();
			//checking entered email is valid or not
			boolean addressValid=true;
			if(bussEmail!=null&&!bussEmail.equalsIgnoreCase("NA"))
			addressValid= EmailVerifier.isAddressValid(bussEmail);
			if(addressValid) {
			if(client!=null&&client.length>0){
			 //update client details
				flag=ClientACT.updateClientDetails(clientrefid,bussName,bussPhone,bussEmail,industryType,bussCity,bussState,bussAddress,token,bussCountry,stateCode,bussPan,bussGst,company_age);
				//update user_account table with client's name,mobile and email
				if(!client[0][4].equalsIgnoreCase(bussName)){
					//updating manage sale client's name
					if(flag)flag=ClientACT.updateManageSale(clientrefid,bussName,token);
					//updating client's name in ClientContext box
					if(flag)flag=ClientACT.updateClientContactBox(clientrefid,bussName,token);
					//updating client's name in estimate Sale
					if(flag)flag=ClientACT.updateEstimateSale(clientrefid,bussName,token);
					//updateing client's name in folder master only in Main folder
					if(flag)flag=ClientACT.updateFolder(company_id,bussName,token);
					//updating client's name in billing table
					if(flag)flag=ClientACT.updateBillingData(clientrefid,bussName,token);					
					//updating client's name in in laser table(managetransactionsctrl)
					if(flag){
					String ledger[][]=ClientACT.getLedgerData(client[0][3],token);
					if(ledger!=null&&ledger.length>0){
						for(int i=0;i<ledger.length;i++)
						flag=ClientACT.updateLedgerStatement(ledger[i][0],ledger[i][1],bussName,token);
					}
					}
				}
				if(flag)pw.write("pass");
				else pw.write("fail");
			}}else {
				pw.write("invalid");				
			}
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
