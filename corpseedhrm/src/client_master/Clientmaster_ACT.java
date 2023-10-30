package client_master;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import org.apache.commons.lang.RandomStringUtils;
import org.apache.log4j.Logger;

import admin.task.TaskMaster_ACT;
import commons.DbCon;

public class Clientmaster_ACT  {

	private static Logger log = Logger.getLogger(Clientmaster_ACT.class);
	
	
	public static boolean isPrimaryContact(String clientKey,String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rs=null;
		boolean flag=false;
		try{
			getacces_con=DbCon.getCon("","","");				
			stmnt=getacces_con.prepareStatement("select cregcontfirstname from hrmclient_reg where cregclientrefid='"+clientKey+"' and cregtokenno='"+token+"'");
			rs=stmnt.executeQuery();
			if(rs.next()){
				String first_name=rs.getString(1);
				if(first_name!=null&&!first_name.equalsIgnoreCase("NA")&&first_name.length()>0) {
					flag=true;
				}
			}
			
		}catch(Exception e)
		{log.info("Error in Clientmaster_ACT method isPrimaryContact:\n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				log.info("Error in Clientmaster_ACT method isPrimaryContact:\n"+sqle.getMessage());
			}
		}
		return flag;
	}
	
	//checking project's payent done or not
		public static boolean isPaymentDone(String salesKey,String token) {
			Connection getacces_con = null;
			PreparedStatement stmnt=null;
			ResultSet rs=null;
			
			boolean flag=false;
			try{
				getacces_con=DbCon.getCon("","","");				
				stmnt=getacces_con.prepareStatement("select smworderamount,smwpricedispersed from salesmainworkpricectrl where smwsaleskey='"+salesKey+"' and smwtokenno='"+token+"'");
				rs=stmnt.executeQuery();
				if(rs.next()){
					double orderAmount=Double.parseDouble(rs.getString(1));
					double dispersedAmount=Double.parseDouble(rs.getString(2));
					if(orderAmount==dispersedAmount) {
						flag=true;
					}
				}
				
			}catch(Exception e)
			{log.info("Error in Clientmaster_ACT method isPaymentDone:\n"+e.getMessage());}
			finally{
				try{
					if(stmnt!=null) {stmnt.close();}
					if(getacces_con!=null) {getacces_con.close();}
					if(rs!=null) {rs.close();}
				}catch(SQLException sqle){
					log.info("Error in Clientmaster_ACT method isPaymentDone:\n"+sqle.getMessage());
				}
			}
			return flag;
		}
	
		//delete virtual clearSalesContactCart
		public static void clearSalesContactCart(String token,String addedby) {
			Connection getacces_con = null;
			PreparedStatement stmnt=null;
			try{
				getacces_con=DbCon.getCon("","","");
				stmnt=getacces_con.prepareStatement("delete from salescontactboxvirtual WHERE scvaddedby='"+addedby+"' and scvtokenno='"+token+"'");
				stmnt.execute();
			}catch(Exception e)
			{log.info("Error in Clientmaster_ACT method clearSalesContactCart:\n"+e.getMessage());}
			finally{
				try{
					if(stmnt!=null) {stmnt.close();}
					if(getacces_con!=null) {getacces_con.close();}
				}catch(SQLException sqle){
					log.info("Error in Clientmaster_ACT method clearSalesContactCart:\n"+sqle.getMessage());
				}
			}
		}
		
		//delete virtual clearProductPriceCart
		public static void clearProductPaymentCartFinal(String token,String addedby) {
			Connection getacces_con = null;
			PreparedStatement stmnt=null;
			ResultSet rs=null;
			try{
				getacces_con=DbCon.getCon("","","");				
				stmnt=getacces_con.prepareStatement("delete from pymtsalesvirtual WHERE psvaddedby='"+addedby+"' and psvtokenno='"+token+"'");
				stmnt.execute();
			}catch(Exception e)
			{log.info("Error in Clientmaster_ACT method clearProductPaymentCartFinal:\n"+e.getMessage());}
			finally{
				try{
					if(stmnt!=null) {stmnt.close();}
					if(rs!=null) {rs.close();}
					if(getacces_con!=null) {getacces_con.close();}
				}catch(SQLException sqle){
					log.info("Error in Clientmaster_ACT method clearProductPaymentCartFinal:\n"+sqle.getMessage());
				}
			}
		}
		
		//delete virtual clearProductPriceCart
		@SuppressWarnings("resource")
		public static void clearProductPaymentCart(String token,String addedby) {
			Connection getacces_con = null;
			PreparedStatement stmnt=null;
			ResultSet rs=null;
			try{
				getacces_con=DbCon.getCon("","","");
				stmnt=getacces_con.prepareStatement("select psvdocumentname,psvdocpath from pymtsalesvirtual where psvaddedby='"+addedby+"' and psvtokenno='"+token+"' and psvdocumentname!='NA' ");
				rs=stmnt.executeQuery();
				while(rs.next()){
					File file=new File(rs.getString(2));
					if(file.exists())file.delete();
				}
				stmnt=getacces_con.prepareStatement("delete from pymtsalesvirtual WHERE psvaddedby='"+addedby+"' and psvtokenno='"+token+"'");
				stmnt.execute();
			}catch(Exception e)
			{log.info("Error in Clientmaster_ACT method clearProductPaymentCart:\n"+e.getMessage());}
			finally{
				try{
					if(stmnt!=null) {stmnt.close();}
					if(rs!=null) {rs.close();}
					if(getacces_con!=null) {getacces_con.close();}
				}catch(SQLException sqle){
					log.info("Error in Clientmaster_ACT method clearProductPaymentCart:\n"+sqle.getMessage());
				}
			}
		}
		
		//delete virtual clearProductPriceCart
		public static void clearProductPricePlanCart(String token,String addedby) {
			Connection getacces_con = null;
			PreparedStatement stmnt=null;
			try{
				getacces_con=DbCon.getCon("","","");		
				stmnt=getacces_con.prepareStatement("delete from salesproductrenewalvirtualctrl WHERE spvaddedby='"+addedby+"' and spvtokenno='"+token+"'");
				stmnt.execute();
			}catch(Exception e)
			{log.info("Error in Clientmaster_ACT method clearProductPricePlanCart:\n"+e.getMessage());}
			finally{
				try{
					if(stmnt!=null) {stmnt.close();}
					if(getacces_con!=null) {getacces_con.close();}
				}catch(SQLException sqle){
					log.info("Error in Clientmaster_ACT method clearProductPricePlanCart:\n"+sqle.getMessage());
				}
			}
		}
		
		//delete virtual clearProductPriceCart
		public static void clearProductPriceCart(String token,String addedby) {
			Connection getacces_con = null;
			PreparedStatement stmnt=null;
			try{
				getacces_con=DbCon.getCon("","","");		
				stmnt=getacces_con.prepareStatement("delete from salesproductvirtual WHERE spvaddedby='"+addedby+"' and spvtokenno='"+token+"'");
				stmnt.execute();
			}catch(Exception e)
			{log.info("Error in Clientmaster_ACT method clearProductPriceCart:\n"+e.getMessage());}
			finally{
				try{
					if(stmnt!=null) {stmnt.close();}
					if(getacces_con!=null) {getacces_con.close();}
				}catch(SQLException sqle){
					log.info("Error in Clientmaster_ACT method clearProductPriceCart:\n"+sqle.getMessage());
				}
			}
		}

		public static boolean removeSalesProductPlan(String salesrefidrefid,String token) {
			Connection getacces_con = null;
			PreparedStatement stmnt=null;
			boolean status=false;
			try{
				getacces_con=DbCon.getCon("","","");								
				stmnt=getacces_con.prepareStatement("delete from estimatesalectrl WHERE esrefid='"+salesrefidrefid+"' and estoken='"+token+"'");
				stmnt.execute();
				status=true;
			}catch(Exception e)
			{log.info("Error in Clientmaster_ACT method removeSalesProductPlan:\n"+e.getMessage());}
			finally{
				try{
					if(stmnt!=null) {stmnt.close();}
					if(getacces_con!=null) {getacces_con.close();}
				}catch(SQLException sqle){
					log.info("Error in Clientmaster_ACT method removeSalesProductPlan:\n"+sqle.getMessage());
				}
			}
			return status;
		}
	
		
		//delete virtual removeProductPlan
		public static boolean removeProductPlan(String pricedivrefid,String token) {
			Connection getacces_con = null;
			PreparedStatement stmnt=null;
			boolean status=false;
			try{
				getacces_con=DbCon.getCon("","","");								
				stmnt=getacces_con.prepareStatement("delete from salesproductrenewalvirtualctrl WHERE spvprodrefid='"+pricedivrefid+"' and spvtokenno='"+token+"'");
				stmnt.execute();
				status=true;
			}catch(Exception e)
			{log.info("Error in Clientmaster_ACT method removeProductPlan:\n"+e.getMessage());}
			finally{
				try{
					if(stmnt!=null) {stmnt.close();}
					if(getacces_con!=null) {getacces_con.close();}
				}catch(SQLException sqle){
					log.info("Error in Clientmaster_ACT method removeProductPlan:\n"+sqle.getMessage());
				}
			}
			return status;
		}
		
		//delete virtual removeRegisteredPayment
		@SuppressWarnings("resource")
		public static boolean removeRegisteredPayment(String pricedivrefid,String token) {
			Connection getacces_con = null;
			PreparedStatement stmnt=null;
			ResultSet rs=null;
			boolean status=false;
			try{
				getacces_con=DbCon.getCon("","","");	
				stmnt=getacces_con.prepareStatement("select psvdocumentname,psvdocpath from pymtsalesvirtual where psvprodvirtualrefid='"+pricedivrefid+"' and psvtokenno='"+token+"' and psvdocumentname!='NA' ");
				rs=stmnt.executeQuery();
				while(rs.next()){
					File file=new File(rs.getString(2));
					if(file.exists())file.delete();
				}				
				stmnt=getacces_con.prepareStatement("delete from pymtsalesvirtual WHERE psvprodvirtualrefid='"+pricedivrefid+"' and psvtokenno='"+token+"'");
//						System.out.println(stmnt);
				stmnt.execute();
				status=true;
			}catch(Exception e)
			{log.info("Error in Clientmaster_ACT method removeRegisteredPayment:\n"+e.getMessage());}
			finally{
				try{
					if(stmnt!=null) {stmnt.close();}
					if(getacces_con!=null) {getacces_con.close();}
				}catch(SQLException sqle){
					log.info("Error in Clientmaster_ACT method removeRegisteredPayment:\n"+sqle.getMessage());
				}
			}
			return status;
		}
		
		//delete virtual removeVirtualContact
		public static boolean removeVirtualContact(String contactboxid,String salesid,String token) {
			Connection getacces_con = null;
			PreparedStatement stmnt=null;
			boolean status=false;
			try{
				getacces_con=DbCon.getCon("","","");		
				stmnt=getacces_con.prepareStatement("delete from salescontactboxvirtual WHERE scvcontactboxid='"+contactboxid+"' and scvtokenno='"+token+"' and scvsalesid='"+salesid+"'");
//				System.out.println(stmnt);
				stmnt.execute();
				status=true;
			}catch(Exception e)
			{log.info("Error in Clientmaster_ACT method removeVirtualContact:\n"+e.getMessage());}
			finally{
				try{
					if(stmnt!=null) {stmnt.close();}
					if(getacces_con!=null) {getacces_con.close();}
				}catch(SQLException sqle){
					log.info("Error in Clientmaster_ACT method removeVirtualContact:\n"+sqle.getMessage());
				}
			}
			return status;
		}
	
		//delete virtual removeProductPrice
			public static boolean removeSalesProductPrice(String salesrefidrefid,String token) {
				Connection getacces_con = null;
				PreparedStatement stmnt=null;
				boolean status=false;
				try{
					getacces_con=DbCon.getCon("","","");		
					stmnt=getacces_con.prepareStatement("delete from salesproductprice WHERE spessalerefid='"+salesrefidrefid+"' and sptokenno='"+token+"'");
//						System.out.println(stmnt);
					int k=stmnt.executeUpdate();
					if(k>0)status=true;
				}catch(Exception e)
				{log.info("Error in Clientmaster_ACT method removeSalesProductPrice:\n"+e.getMessage());}
				finally{
					try{
						if(stmnt!=null) {stmnt.close();}
						if(getacces_con!=null) {getacces_con.close();}
					}catch(SQLException sqle){
						log.info("Error in Clientmaster_ACT method removeSalesProductPrice:\n"+sqle.getMessage());
					}
				}
				return status;
			}
		
		//delete virtual removeProductPrice
		public static boolean removeProductPrice(String pricedivrefid,String token) {
			Connection getacces_con = null;
			PreparedStatement stmnt=null;
			boolean status=false;
			try{
				getacces_con=DbCon.getCon("","","");		
				stmnt=getacces_con.prepareStatement("delete from salesproductvirtual WHERE spvvirtualid='"+pricedivrefid+"' and spvtokenno='"+token+"'");
//				System.out.println(stmnt);
				stmnt.execute();
				status=true;
			}catch(Exception e)
			{log.info("Error in Clientmaster_ACT method removeProductPrice:\n"+e.getMessage());}
			finally{
				try{
					if(stmnt!=null) {stmnt.close();}
					if(getacces_con!=null) {getacces_con.close();}
				}catch(SQLException sqle){
					log.info("Error in Clientmaster_ACT method removeProductPrice:\n"+sqle.getMessage());
				}
			}
			return status;
		}
		
	//delete virtual bill details
	public static void deleteVirtualBillingDetails(String vid,String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		try{
			getacces_con=DbCon.getCon("","","");		
			stmnt=getacces_con.prepareStatement("delete from virtual_project_price WHERE vid='"+vid+"' and vtokenno='"+token+"'");
			stmnt.execute();
			
		}catch(Exception e)
		{log.info("Error in Clientmaster_ACT method deleteVirtualBillingDetails:\n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
			}catch(SQLException sqle){
				log.info("Error in Clientmaster_ACT method deleteVirtualBillingDetails:\n"+sqle.getMessage());
			}
		}
	}
	public static String getEstimateNumber(String invoiceNo,String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String newsdata = "NA";
		try{
			getacces_con=DbCon.getCon("","","");
			String query="SELECT cbestimateno FROM hrmclient_billing WHERE (cbinvoiceno='"+invoiceNo+"' or cbestimateno='"+invoiceNo+"') and cbtokenno='"+token+"'";
			stmnt=getacces_con.prepareStatement(query);
			rsGCD=stmnt.executeQuery();
			
			while(rsGCD!=null && rsGCD.next()){
				newsdata=rsGCD.getString(1);
			}
		}catch(Exception e)
		{log.info("Error in Clientmaster_ACT method getEstimateNumber:\n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				log.info("Error in Clientmaster_ACT method getEstimateNumber:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	//getting client details 
	public static String[][] getPriceDetails(String itemid,String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			String query="SELECT pricetype,price,gststatus,gst,gstprice FROM project_price WHERE id='"+itemid+"' and tokenno='"+token+"'";
			stmnt=getacces_con.prepareStatement(query);
			rsGCD=stmnt.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];
			int rr=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++)
				{
					newsdata[rr][i]=rsGCD.getString(i+1);
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("Error in Clientmaster_ACT method getPriceDetails:\n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				log.info("Error in Clientmaster_ACT method getPriceDetails:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}	

		//getting Total Virtual Price
		public static double getTotalSalesPrice(String prodrefid,String token) {
			Connection getacces_con = null;
			PreparedStatement ps=null;
			ResultSet rs=null;
			double newsdata =0;
			try{
				getacces_con=DbCon.getCon("","","");				 
				 ps=getacces_con.prepareStatement("select sum(sptotalprice) from salesproductprice where spessalerefid='"+prodrefid+"' and  sptokenno='"+token+"' ");
				rs=ps.executeQuery();				
				if(rs.next())newsdata=rs.getDouble(1);
				
			}catch(Exception e)
			{
				log.info("Error in Clientmaster_ACT method getTotalSalesPrice:\n"+e.getMessage());
			}
			finally{
				try{
					if(rs!=null) {rs.close();}
					if(ps!=null) {ps.close();}
					if(getacces_con!=null) {getacces_con.close();}
				}catch(SQLException sqle){
					log.info("Error in Clientmaster_ACT method getTotalSalesPrice:\n"+sqle.getMessage());
				}
			}
			return newsdata;
		}
	
		public static double getTotalVirtualPriceWithGst(String pricerefid,String token) {
			Connection getacces_con = null;
			PreparedStatement ps=null;
			ResultSet rs=null;
			double newsdata =0;
			try{
				getacces_con=DbCon.getCon("","","");				 
				 ps=getacces_con.prepareStatement("select spvtotalprice,spvigstpercent from salesproductvirtual where spvvirtualid='"+pricerefid+"' and  spvtokenno='"+token+"' ");
				rs=ps.executeQuery();				
				while(rs.next()) {
					newsdata+=rs.getDouble(1)+((rs.getDouble(1)*rs.getDouble(2))/100);
				}
				
				
			}catch(Exception e)
			{
				log.info("Error in Clientmaster_ACT method getTotalVirtualPriceWithGst:\n"+e.getMessage());
			}
			finally{
				try{
					if(rs!=null) {rs.close();}
					if(ps!=null) {ps.close();}
					if(getacces_con!=null) {getacces_con.close();}
				}catch(SQLException sqle){
					log.info("Error in Clientmaster_ACT method getTotalVirtualPriceWithGst:\n"+sqle.getMessage());
				}
			}
			return newsdata;
		}
		
		//getting Total Virtual Price
		public static double getTotalVirtualPrice(String pricerefid,String token) {
			Connection getacces_con = null;
			PreparedStatement ps=null;
			ResultSet rs=null;
			double newsdata =0;
			try{
				getacces_con=DbCon.getCon("","","");				 
				 ps=getacces_con.prepareStatement("select sum(spvtotalprice) from salesproductvirtual where spvvirtualid='"+pricerefid+"' and  spvtokenno='"+token+"' ");
				rs=ps.executeQuery();				
				if(rs.next())newsdata=rs.getDouble(1);
				
				
			}catch(Exception e)
			{
				log.info("Error in Clientmaster_ACT method getTotalVirtualPrice:\n"+e.getMessage());
			}
			finally{
				try{
					if(rs!=null) {rs.close();}
					if(ps!=null) {ps.close();}
					if(getacces_con!=null) {getacces_con.close();}
				}catch(SQLException sqle){
					log.info("Error in Clientmaster_ACT method getTotalVirtualPrice:\n"+sqle.getMessage());
				}
			}
			return newsdata;
		}
		
		//getting client's billing amount
		public static double getBillingAmount(String clientid,String token,String type) {
			Connection getacces_con = null;
			PreparedStatement ps=null;
			ResultSet rs=null;
			double newsdata =0;
			try{
				getacces_con=DbCon.getCon("","","");				 
				 ps=getacces_con.prepareStatement("select sum(cbfinalamount) from hrmclient_billing where cbtokenno='"+token+"' and cbcuid='"+clientid+"' and cbstatus='1' and cbtype='"+type+"'");
				rs=ps.executeQuery();				
				if(rs.next())newsdata=rs.getDouble(1);
				
				
			}catch(Exception e)
			{
				log.info("Error in Clientmaster_ACT method getBillingAmount:\n"+e.getMessage());
			}
			finally{
				try{
					if(rs!=null) {rs.close();}
					if(ps!=null) {ps.close();}
					if(getacces_con!=null) {getacces_con.close();}
				}catch(SQLException sqle){
					log.info("Error in Clientmaster_ACT method getBillingAmount:\n"+sqle.getMessage());
				}
			}
			return newsdata;
		}
		
		//getting client's total due amount
		public static double getTotalClientProjectDueAmount(String clientid,String token,String type) {
			Connection getacces_con = null;
			PreparedStatement ps=null;
			ResultSet rs=null;
			double newsdata =0;
			try{
				getacces_con=DbCon.getCon("","","");				 
				 ps=getacces_con.prepareStatement("select sum(cddueamount) from hrmclient_billing where cbtokenno='"+token+"' and cbcuid='"+clientid+"' and cbstatus='1' and cbtype='"+type+"'");
				rs=ps.executeQuery();				
				if(rs.next())newsdata=rs.getDouble(1);
				
			}catch(Exception e)
			{
				log.info("Error in Clientmaster_ACT method getTotalClientProjectDueAmount:\n"+e.getMessage());
			}
			finally{
				try{
					if(rs!=null) {rs.close();}
					if(ps!=null) {ps.close();}
					if(getacces_con!=null) {getacces_con.close();}
				}catch(SQLException sqle){
					sqle.printStackTrace();
					log.info("Error in Clientmaster_ACT method getTotalClientProjectDueAmount:\n"+sqle.getMessage());
				}
			}
			return newsdata;
		}	
		//getting delivery date
		public static String getDeliverdOnDate(String preguid,String token) {
			Connection getacces_con = null;
			PreparedStatement ps=null;
			ResultSet rs=null;
			String newsdata = "NA";
			try{
				getacces_con=DbCon.getCon("","","");				 
				 ps=getacces_con.prepareStatement("select pregdeliveredon from hrmproject_reg where preguid='"+preguid+"' and pregtokenno='"+token+"'");
				rs=ps.executeQuery();
				if(rs.next())newsdata=rs.getString(1);
			}catch(Exception e)
			{
				log.info("Error in Clientmaster_ACT method getDeliverdOnDate:\n"+e.getMessage());
			}
			finally{
				try{
					if(rs!=null) {rs.close();}
					if(ps!=null) {ps.close();}
					if(getacces_con!=null) {getacces_con.close();}
				}catch(SQLException sqle){
					log.info("Error in Clientmaster_ACT method getDeliverdOnDate:\n"+sqle.getMessage());
				}
			}
			return newsdata;
		}
		
		//getting account id
		public static String getClientId(String clientno,String token) {
			Connection getacces_con = null;
			PreparedStatement ps=null;
			ResultSet rs=null;
			String newsdata = "NA";
			try{
				getacces_con=DbCon.getCon("","","");				 
				 ps=getacces_con.prepareStatement("select creguid from hrmclient_reg where cregucid='"+clientno+"' and cregtokenno='"+token+"'");
				rs=ps.executeQuery();
//								System.out.println("select pp.totalprice from project_price pp join hrmproject_reg hr on hr.preguid=pp.preguid where hr.pregtokenno='"+token+"' and hr.pregcuid='"+clientid+"' and hr.pregrunningstatus!='Delivered' and pp.tokenno='"+token+"'");
				if(rs.next())newsdata=rs.getString(1);
			}catch(Exception e)
			{
				log.info("Error in Clientmaster_ACT method getClientId:\n"+e.getMessage());
			}
			finally{
				try{
					if(rs!=null) {rs.close();}
					if(ps!=null) {ps.close();}
					if(getacces_con!=null) {getacces_con.close();}
				}catch(SQLException sqle){
					log.info("Error in Clientmaster_ACT method getClientId:\n"+sqle.getMessage());
				}
			}
			return newsdata;
		}	
		
		//getting account id
		public static String getAccountId(String clientid,String token) {
			Connection getacces_con = null;
			PreparedStatement ps=null;
			ResultSet rs=null;
			String newsdata = "NA";
			try{
				getacces_con=DbCon.getCon("","","");				 
				 ps=getacces_con.prepareStatement("select caid from client_accounts where catokenno='"+token+"' and cacid='"+clientid+"'");
				rs=ps.executeQuery();
//						System.out.println("select pp.totalprice from project_price pp join hrmproject_reg hr on hr.preguid=pp.preguid where hr.pregtokenno='"+token+"' and hr.pregcuid='"+clientid+"' and hr.pregrunningstatus!='Delivered' and pp.tokenno='"+token+"'");
				if(rs.next())newsdata=rs.getString(1);
			}catch(Exception e)
			{
				log.info("Error in Clientmaster_ACT method getAccountId:\n"+e.getMessage());
			}
			finally{
				try{
					if(rs!=null) {rs.close();}
					if(ps!=null) {ps.close();}
					if(getacces_con!=null) {getacces_con.close();}
				}catch(SQLException sqle){
					log.info("Error in Clientmaster_ACT method getAccountId:\n"+sqle.getMessage());
				}
			}
			return newsdata;
		}
		
		public static double getTotalConvertedSalesAmount(String userRole,String loginuaid,
				String estDoAction,String token,String ClientName,String estimateNo,
				String dateRange,String contactName,String department) {
			Connection getacces_con = null;
			PreparedStatement ps=null;
			ResultSet rs=null;
			double newsdata = 0;
			String fromDate="NA";
			String toDate="NA";
			try{
				
				if(!dateRange.equalsIgnoreCase("NA")){
					fromDate=dateRange.substring(0,10).trim();
					fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.substring(0,2);
					toDate=dateRange.substring(13).trim();
					toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2);
				}
				getacces_con=DbCon.getCon("","","");				 
				 StringBuffer VCQUERY=new StringBuffer("select sp.sptotalprice from salesproductprice sp "
				 		+ "inner join estimatesalectrl es on sp.spsalesid=es.essaleno "
				 		+ "INNER JOIN contactboxctrl c on es.escontactrefid=c.cbrefid where sp.sptokenno='"+token+"' and es.estoken='"+token+"' and es.esstatus='Invoiced' and sp.spstatus='1'"); 
			if(department.equalsIgnoreCase("Sales")||department.equalsIgnoreCase("Admin")) {		
				 	if(!userRole.equalsIgnoreCase("NA")&&!loginuaid.equalsIgnoreCase("NA")&&userRole.equalsIgnoreCase("Executive")){
						VCQUERY.append(" and es.essoldbyid = '"+loginuaid+"'");
					}else if(!userRole.equalsIgnoreCase("NA")&&!loginuaid.equalsIgnoreCase("NA")&&(userRole.equalsIgnoreCase("Assistant")||userRole.equalsIgnoreCase("Manager")))
						VCQUERY.append(" and exists(select t.mtid from manageteamctrl t join manageteammemberctrl m on t.mtrefid=m.tmteamrefid where t.mtadminid='"+loginuaid+"' and m.tmuseruid=es.essoldbyid or es.essoldbyid='"+loginuaid+"')");
					
			}else VCQUERY.append(" and es.essoldbyid = '"+loginuaid+"' ");
				 	
					if(!estDoAction.equalsIgnoreCase("NA")){
						if(estDoAction.equalsIgnoreCase("Draft"))VCQUERY.append(" and es.esstatus='"+estDoAction+"'");
						if(estDoAction.equalsIgnoreCase("Pending for approval")){
							VCQUERY.append(" and exists(select sid from salesestimatepayment where sestsaleno=es.essaleno and stransactionstatus='2' and stokenno='"+token+"')");
						}
					}else VCQUERY.append(" and e.esstatus!='Cancelled'");
					
					if(!ClientName.equalsIgnoreCase("NA"))VCQUERY.append(" and es.escompany='"+ClientName+"'");
					if(!contactName.equalsIgnoreCase("NA"))VCQUERY.append(" and c.cbname='"+contactName+"'");
					if(!estimateNo.equalsIgnoreCase("NA"))VCQUERY.append(" and es.essaleno='"+estimateNo+"'");
					if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA")){
						VCQUERY.append(" and str_to_date(es.esregdate,'%d-%m-%Y')<='"+toDate+"' and str_to_date(es.esregdate,'%d-%m-%Y')>='"+fromDate+"'");
					}
					VCQUERY.append(" group by sp.spid");
//					System.out.println(VCQUERY);
				 ps=getacces_con.prepareStatement(VCQUERY.toString());
				 rs=ps.executeQuery();
				while(rs!=null&&rs.next())newsdata+=rs.getDouble(1);
			}catch(Exception e)
			{
				log.info("Error in Clientmaster_ACT method getTotalConvertedSalesAmount:\n"+e.getMessage());
			}
			finally{
				try{
					if(rs!=null) {rs.close();}
					if(ps!=null) {ps.close();}
					if(getacces_con!=null) {getacces_con.close();}
				}catch(SQLException sqle){
					log.info("Error in Clientmaster_ACT method getTotalConvertedSalesAmount:\n"+sqle.getMessage());
				}
			}
			return newsdata;
		}
		
		public static int countTotalConvertedSale(String userRole,String loginuaid,
				String estDoAction,String token,String ClientName,String estimateNo,
				String dateRange,String contactName,String department) {
			Connection getacces_con = null;
			PreparedStatement ps=null;
			ResultSet rs=null;
			int newsdata = 0;
			String fromDate="NA";
			String toDate="NA";
			try{
				
				if(!dateRange.equalsIgnoreCase("NA")){
					fromDate=dateRange.substring(0,10).trim();
					fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.substring(0,2);
					toDate=dateRange.substring(13).trim();
					toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2);
				}
				getacces_con=DbCon.getCon("","","");				 
				StringBuffer VCQUERY=new StringBuffer("select es.esid from estimatesalectrl es "
						+ "INNER JOIN contactboxctrl c on es.escontactrefid=c.cbrefid where es.estoken='"+token+"' and es.esstatus='Invoiced'"); 
			if(department.equalsIgnoreCase("Sales")||department.equalsIgnoreCase("Admin")) {				
				if(!userRole.equalsIgnoreCase("NA")&&!loginuaid.equalsIgnoreCase("NA")&&userRole.equalsIgnoreCase("Executive")){
					VCQUERY.append(" and es.essoldbyid = '"+loginuaid+"'");
				}else if(!userRole.equalsIgnoreCase("NA")&&!loginuaid.equalsIgnoreCase("NA")&&(userRole.equalsIgnoreCase("Assistant")||userRole.equalsIgnoreCase("Manager")))
					VCQUERY.append(" and exists(select t.mtid from manageteamctrl t join manageteammemberctrl m on t.mtrefid=m.tmteamrefid where t.mtadminid='"+loginuaid+"' and m.tmuseruid=es.essoldbyid or es.essoldbyid='"+loginuaid+"')");
			}else VCQUERY.append(" and es.essoldbyid = '"+loginuaid+"' ");
				
				if(!estDoAction.equalsIgnoreCase("NA")){
//					if(estDoAction.equalsIgnoreCase("Invoiced")||estDoAction.equalsIgnoreCase("Draft"))VCQUERY.append(" and es.esstatus='"+estDoAction+"'");
					if(estDoAction.equalsIgnoreCase("Pending for approval")){
						VCQUERY.append(" and exists(select se.sid from salesestimatepayment se where se.sestsaleno=es.essaleno and se.stransactionstatus='2' and se.stokenno='"+token+"')");
					}
				}else VCQUERY.append(" and e.esstatus!='Cancelled'");		
				if(!ClientName.equalsIgnoreCase("NA"))VCQUERY.append(" and es.escompany='"+ClientName+"'");
				if(!contactName.equalsIgnoreCase("NA"))VCQUERY.append(" and c.cbname='"+contactName+"'");
				if(!estimateNo.equalsIgnoreCase("NA"))VCQUERY.append(" and es.essaleno='"+estimateNo+"'");
				if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA")){
					VCQUERY.append(" and str_to_date(es.esregdate,'%d-%m-%Y')<='"+toDate+"' and str_to_date(es.esregdate,'%d-%m-%Y')>='"+fromDate+"'");
				}
				VCQUERY.append(" group by es.essaleno");
//				System.out.println(VCQUERY);
				
				ps=getacces_con.prepareStatement(VCQUERY.toString());
				rs=ps.executeQuery();
				while(rs!=null&&rs.next())newsdata+=1;
			}catch(Exception e)
			{
				log.info("Error in Clientmaster_ACT method getTotalSalesDueAmount:\n"+e.getMessage());
			}
			finally{
				try{
					if(rs!=null) {rs.close();}
					if(ps!=null) {ps.close();}
					if(getacces_con!=null) {getacces_con.close();}
				}catch(SQLException sqle){
					log.info("Error in Clientmaster_ACT method getTotalSalesDueAmount:\n"+sqle.getMessage());
				}
			}
			return newsdata;
		}
		
		public static double getTotalSalesPaidAmount(String ClientName,String InvoiceNo,String dateRange,String doAction,String token) {
			Connection getacces_con = null;
			PreparedStatement ps=null;
			ResultSet rs=null;
			double newsdata = 0;
			String fromDate="NA";
			String toDate="NA";
			try{
				
				if(!dateRange.equalsIgnoreCase("NA")){
					fromDate=dateRange.substring(0,10).trim();
					fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.substring(0,2);
					toDate=dateRange.substring(13).trim();
					toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2);
				}
				getacces_con=DbCon.getCon("","","");		 
				 
				 StringBuffer queryselect=new StringBuffer("select cb.cbpaidamount from hrmclient_billing cb inner join managesalesctrl ms on cb.cbinvoiceno=ms.msinvoiceno where cb.cbinvoiceno!='NA' and cb.cbtokenno='"+token+"' and ms.msstatus='1' and ms.mstoken='"+token+"'");
				 if(!InvoiceNo.equalsIgnoreCase("NA"))queryselect.append(" and cb.cbinvoiceno='"+InvoiceNo+"'");
					if(!ClientName.equalsIgnoreCase("NA"))queryselect.append(" and cb.cbcompanyname='"+ClientName+"'");
					if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA")){
						queryselect.append(" and str_to_date(cb.cbdate,'%d-%m-%Y')<='"+toDate+"' and str_to_date(cb.cbdate,'%d-%m-%Y')>='"+fromDate+"'");
					}
					if(!doAction.equalsIgnoreCase("NA")){
						if(doAction.equalsIgnoreCase("Paid"))queryselect.append(" and cb.cbdueamount='0'");
						else if(doAction.equalsIgnoreCase("Current"))queryselect.append(" and ms.msworkpercent!='100'");						
						else if(doAction.equalsIgnoreCase("Past due"))queryselect.append(" and ms.msworkpercent='100' and cb.cbdueamount!='0'");
					}
					queryselect.append(" group by cb.cbuid");
//					System.out.println(queryselect);
				ps=getacces_con.prepareStatement(queryselect.toString());
				 rs=ps.executeQuery();
				while(rs!=null&&rs.next())newsdata+=rs.getDouble(1);
			}catch(Exception e)
			{
				log.info("Error in Clientmaster_ACT method getTotalSalesPaidAmount:\n"+e.getMessage());
			}
			finally{
				try{
					if(rs!=null) {rs.close();}
					if(ps!=null) {ps.close();}
					if(getacces_con!=null) {getacces_con.close();}
				}catch(SQLException sqle){
					log.info("Error in Clientmaster_ACT method getTotalSalesPaidAmount:\n"+sqle.getMessage());
				}
			}
			return newsdata;
		}
		
		public static double getTotalSalesPaidAmount(String userRole,String loginuaid,
				String InvoiceNo,String PhoneKey,String ProductName,String ClientName,
				String SoldByUid,String dateRange,String token,String contactName,
				String department,String salesFilter) {
			Connection getacces_con = null;
			PreparedStatement ps=null;
			ResultSet rs=null;
			double newsdata = 0;
			String fromDate="NA";
			String toDate="NA";
			try{
				
				if(!dateRange.equalsIgnoreCase("NA")){
					fromDate=dateRange.substring(0,10).trim();
					fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.substring(0,2);
					toDate=dateRange.substring(13).trim();
					toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2);
				}
				getacces_con=DbCon.getCon("","","");		 
				 
				 StringBuffer queryselect=new StringBuffer("select cb.cbpaidamount from hrmclient_billing cb "
				 		+ "INNER JOIN managesalesctrl ms on cb.cbinvoiceno=ms.msinvoiceno INNER JOIN contactboxctrl "
				 		+ "c on ms.mscontactrefid=c.cbrefid where cb.cbtokenno='"+token+"' and ms.msstatus='1' "
				 				+ "and ms.mstoken='"+token+"'");
				 
				 if(salesFilter.equalsIgnoreCase("All"))
						queryselect.append(" and ms.mscancelstatus='2'");
					else if(salesFilter.equalsIgnoreCase("Cancelled"))
						queryselect.append(" and ms.mscancelstatus='1'");
					else if(salesFilter.equalsIgnoreCase("In-Progress"))
						queryselect.append(" and ms.mscancelstatus='2' and ms.msprojectstatus='3'");
					else if(salesFilter.equalsIgnoreCase("Completed"))
						queryselect.append(" and ms.mscancelstatus='2' and ms.msprojectstatus='2'");
					else if(salesFilter.equalsIgnoreCase("Past-Due"))
						queryselect.append(" and ms.mscancelstatus='2' and cb.cbdueamount>0");
			
				 if(department.equalsIgnoreCase("Sales")||department.equalsIgnoreCase("Admin")) {	 
				 if(!userRole.equalsIgnoreCase("NA")&&userRole.equalsIgnoreCase("Executive")) queryselect.append(" and ms.mssoldbyuid = '"+loginuaid+"'");
					if(!userRole.equalsIgnoreCase("NA")&&!loginuaid.equalsIgnoreCase("NA")&&(userRole.equalsIgnoreCase("Assistant")||userRole.equalsIgnoreCase("Manager")))
						queryselect.append(" and exists(select t.mtid from manageteamctrl t join manageteammemberctrl m on t.mtrefid=m.tmteamrefid where t.mtadminid='"+loginuaid+"' and m.tmuseruid=ms.mssoldbyuid or ms.mssoldbyuid='"+loginuaid+"')");
			
				 }else queryselect.append(" and (ms.mssoldbyuid = '"+loginuaid+"' or exists(select id from consulting_sale c where c.sales_key=ms.msrefid and c.consultant_uaid='"+loginuaid+"'))");
					if(!InvoiceNo.equalsIgnoreCase("NA"))queryselect.append(" and ms.msinvoiceno='"+InvoiceNo+"'");
					if(!PhoneKey.equalsIgnoreCase("NA"))queryselect.append(" and ms.mscontactrefid='"+PhoneKey+"'");
					if(!contactName.equalsIgnoreCase("NA"))queryselect.append(" and c.cbname='"+contactName+"'");
					if(!ProductName.equalsIgnoreCase("NA"))queryselect.append(" and ms.msproductname='"+ProductName+"'");
					if(!ClientName.equalsIgnoreCase("NA"))queryselect.append(" and ms.mscompany='"+ClientName+"'");
					if(!SoldByUid.equalsIgnoreCase("NA"))queryselect.append(" and ms.mssoldbyuid='"+SoldByUid+"'");
					if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA")){
						queryselect.append(" and str_to_date(ms.mssolddate,'%d-%m-%Y')<='"+toDate+"' and str_to_date(ms.mssolddate,'%d-%m-%Y')>='"+fromDate+"'");
					}
					queryselect.append(" group by cb.cbuid");
//					System.out.println(queryselect);
				ps=getacces_con.prepareStatement(queryselect.toString());
				 rs=ps.executeQuery();
				while(rs!=null&&rs.next())newsdata+=rs.getDouble(1);
			}catch(Exception e)
			{
				log.info("Error in Clientmaster_ACT method getTotalSalesPaidAmount:\n"+e.getMessage());
			}
			finally{
				try{
					if(rs!=null) {rs.close();}
					if(ps!=null) {ps.close();}
					if(getacces_con!=null) {getacces_con.close();}
				}catch(SQLException sqle){
					log.info("Error in Clientmaster_ACT method getTotalSalesPaidAmount:\n"+sqle.getMessage());
				}
			}
			return newsdata;
		}
		
		public static double getSalesPastDue(String ClientName,String InvoiceNo,String dateRange,String doAction,String token) {
			Connection getacces_con = null;
			PreparedStatement ps=null;
			ResultSet rs=null;
			double newsdata = 0;
			String fromDate="NA";
			String toDate="NA";
			try{
				
				if(!dateRange.equalsIgnoreCase("NA")){
					fromDate=dateRange.substring(0,10).trim();
					fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.substring(0,2);
					toDate=dateRange.substring(13).trim();
					toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2);
				}
				getacces_con=DbCon.getCon("","","");
				StringBuffer queryselect=new StringBuffer("select cb.cbdueamount from hrmclient_billing cb inner join managesalesctrl ms on cb.cbinvoiceno=ms.msinvoiceno where cb.cbtokenno='"+token+"' and ms.msstatus='1' and ms.msworkpercent='100' and ms.mstoken='"+token+"'");
				 if(!InvoiceNo.equalsIgnoreCase("NA"))queryselect.append(" and cb.cbinvoiceno='"+InvoiceNo+"'");
					if(!ClientName.equalsIgnoreCase("NA"))queryselect.append(" and cb.cbcompanyname='"+ClientName+"'");
					if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA")){
						queryselect.append(" and str_to_date(cb.cbdate,'%d-%m-%Y')<='"+toDate+"' and str_to_date(cb.cbdate,'%d-%m-%Y')>='"+fromDate+"'");
					}
					if(!doAction.equalsIgnoreCase("NA")){
						if(doAction.equalsIgnoreCase("Paid"))queryselect.append(" and cb.cbdueamount='0'");
						else if(doAction.equalsIgnoreCase("Current"))queryselect.append(" and ms.msworkpercent!='100'");						
						else if(doAction.equalsIgnoreCase("Past due"))queryselect.append(" and cb.cbdueamount!='0'");
					}
				queryselect.append(" group by cb.cbuid");
//				System.out.println(queryselect);
//					"select sum(cbdueamount) from hrmclient_billing WHERE not exists(select msid from managesalesctrl where msworkpercent!='100' AND msinvoiceno=cbinvoiceno and msstatus='1' and mstoken='"+token+"') and cbtokenno='"+token+"'"
				 ps=getacces_con.prepareStatement(queryselect.toString());
				
				 rs=ps.executeQuery();
				while(rs!=null&&rs.next())newsdata+=rs.getDouble(1);
			}catch(Exception e)
			{
				log.info("Error in Clientmaster_ACT method getSalesPastDue:\n"+e.getMessage());
			}
			finally{
				try{
					if(rs!=null) {rs.close();}
					if(ps!=null) {ps.close();}
					if(getacces_con!=null) {getacces_con.close();}
				}catch(SQLException sqle){
					log.info("Error in Clientmaster_ACT method getSalesPastDue:\n"+sqle.getMessage());
				}
			}
			return newsdata;
		}
		
		public static int countSalesPastDue(String ClientName,String InvoiceNo,String dateRange,String doAction,String token) {
			Connection getacces_con = null;
			PreparedStatement ps=null;
			ResultSet rs=null;
			int newsdata = 0;
			String fromDate="NA";
			String toDate="NA";
			try{
				
				if(!dateRange.equalsIgnoreCase("NA")){
					fromDate=dateRange.substring(0,10).trim();
					fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.substring(0,2);
					toDate=dateRange.substring(13).trim();
					toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2);
				}
				getacces_con=DbCon.getCon("","","");
				StringBuffer queryselect=new StringBuffer("select cbuid from hrmclient_billing cb inner join managesalesctrl ms on cb.cbinvoiceno=ms.msinvoiceno where cb.cbtokenno='"+token+"' and ms.msstatus='1' and ms.msworkpercent='100' and ms.mstoken='"+token+"'");
				 if(!InvoiceNo.equalsIgnoreCase("NA"))queryselect.append(" and cb.cbinvoiceno='"+InvoiceNo+"'");
					if(!ClientName.equalsIgnoreCase("NA"))queryselect.append(" and cb.cbcompanyname='"+ClientName+"'");
					if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA")){
						queryselect.append(" and str_to_date(cb.cbdate,'%d-%m-%Y')<='"+toDate+"' and str_to_date(cb.cbdate,'%d-%m-%Y')>='"+fromDate+"'");
					}
					if(!doAction.equalsIgnoreCase("NA")){
						if(doAction.equalsIgnoreCase("Paid"))queryselect.append(" and cb.cbdueamount='0'");
						else if(doAction.equalsIgnoreCase("Current"))queryselect.append(" and ms.msworkpercent!='100'");						
						else if(doAction.equalsIgnoreCase("Past due"))queryselect.append(" and cb.cbdueamount!='0'");
					}
				queryselect.append(" group by cb.cbuid");
//				System.out.println(queryselect);
//					"select sum(cbdueamount) from hrmclient_billing WHERE not exists(select msid from managesalesctrl where msworkpercent!='100' AND msinvoiceno=cbinvoiceno and msstatus='1' and mstoken='"+token+"') and cbtokenno='"+token+"'"
				 ps=getacces_con.prepareStatement(queryselect.toString());
				
				 rs=ps.executeQuery();
				while(rs!=null&&rs.next())newsdata+=1;
			}catch(Exception e)
			{
				log.info("Error in Clientmaster_ACT method getSalesPastDue:\n"+e.getMessage());
			}
			finally{
				try{
					if(rs!=null) {rs.close();}
					if(ps!=null) {ps.close();}
					if(getacces_con!=null) {getacces_con.close();}
				}catch(SQLException sqle){
					log.info("Error in Clientmaster_ACT method getSalesPastDue:\n"+sqle.getMessage());
				}
			}
			return newsdata;
		}
		
		public static double getSalesPastDue(String userRole,String loginuaid,String InvoiceNo,
				String PhoneKey,String ProductName,String ClientName,String SoldByUid,
				String dateRange,String token,String contactName,String department,String salesFilter) {
			Connection getacces_con = null;
			PreparedStatement ps=null;
			ResultSet rs=null;
			double newsdata = 0;
			String fromDate="NA";
			String toDate="NA";
			try{
				
				if(!dateRange.equalsIgnoreCase("NA")){
					fromDate=dateRange.substring(0,10).trim();
					fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.substring(0,2);
					toDate=dateRange.substring(13).trim();
					toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2);
				}
				getacces_con=DbCon.getCon("","","");
				StringBuffer queryselect=new StringBuffer("select cb.cbdueamount from hrmclient_billing cb "
						+ "join managesalesctrl ms on cb.cbinvoiceno=ms.msinvoiceno INNER JOIN contactboxctrl c "
						+ "on ms.mscontactrefid=c.cbrefid where cb.cbtokenno='"+token+"' and ms.msstatus='1' "
								+ "and ms.msworkpercent='100' and ms.mstoken='"+token+"'");
				
				if(salesFilter.equalsIgnoreCase("All"))
					queryselect.append(" and ms.mscancelstatus='2'");
				else if(salesFilter.equalsIgnoreCase("Cancelled"))
					queryselect.append(" and ms.mscancelstatus='1'");
				else if(salesFilter.equalsIgnoreCase("In-Progress"))
					queryselect.append(" and ms.mscancelstatus='2' and ms.msprojectstatus='3'");
				else if(salesFilter.equalsIgnoreCase("Completed"))
					queryselect.append(" and ms.mscancelstatus='2' and ms.msprojectstatus='2'");
				else if(salesFilter.equalsIgnoreCase("Past-Due"))
					queryselect.append(" and ms.mscancelstatus='2' and cb.cbdueamount>0");
				
			if(department.equalsIgnoreCase("Sales")||department.equalsIgnoreCase("Admin")) {					
				if(!userRole.equalsIgnoreCase("NA")&&userRole.equalsIgnoreCase("Executive")) queryselect.append(" and ms.mssoldbyuid = '"+loginuaid+"'");
				if(!userRole.equalsIgnoreCase("NA")&&!loginuaid.equalsIgnoreCase("NA")&&(userRole.equalsIgnoreCase("Assistant")||userRole.equalsIgnoreCase("Manager")))
					queryselect.append(" and exists(select t.mtid from manageteamctrl t join manageteammemberctrl m on t.mtrefid=m.tmteamrefid where t.mtadminid='"+loginuaid+"' and m.tmuseruid=ms.mssoldbyuid or ms.mssoldbyuid='"+loginuaid+"')"); 
			}else queryselect.append(" and (ms.mssoldbyuid = '"+loginuaid+"' or exists(select id from consulting_sale c where c.sales_key=ms.msrefid and c.consultant_uaid='"+loginuaid+"'))");
				
				if(!InvoiceNo.equalsIgnoreCase("NA"))queryselect.append(" and ms.msinvoiceno='"+InvoiceNo+"'");
				if(!PhoneKey.equalsIgnoreCase("NA"))queryselect.append(" and ms.mscontactrefid='"+PhoneKey+"'");
				if(!contactName.equalsIgnoreCase("NA"))queryselect.append(" and c.cbname='"+contactName+"'");
				if(!ProductName.equalsIgnoreCase("NA"))queryselect.append(" and ms.msproductname='"+ProductName+"'");
				if(!ClientName.equalsIgnoreCase("NA"))queryselect.append(" and ms.mscompany='"+ClientName+"'");
				if(!SoldByUid.equalsIgnoreCase("NA"))queryselect.append(" and ms.mssoldbyuid='"+SoldByUid+"'");
				if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA")){
					queryselect.append(" and str_to_date(ms.mssolddate,'%d-%m-%Y')<='"+toDate+"' and str_to_date(ms.mssolddate,'%d-%m-%Y')>='"+fromDate+"'");
				}
				queryselect.append(" group by cb.cbuid");
//				System.out.println(queryselect);
//					"select sum(cbdueamount) from hrmclient_billing WHERE not exists(select msid from managesalesctrl where msworkpercent!='100' AND msinvoiceno=cbinvoiceno and msstatus='1' and mstoken='"+token+"') and cbtokenno='"+token+"'"
				 ps=getacces_con.prepareStatement(queryselect.toString());
				
				 rs=ps.executeQuery();
				while(rs!=null&&rs.next())newsdata+=rs.getDouble(1);
			}catch(Exception e)
			{
				log.info("Error in Clientmaster_ACT method getSalesPastDue:\n"+e.getMessage());
			}
			finally{
				try{
					if(rs!=null) {rs.close();}
					if(ps!=null) {ps.close();}
					if(getacces_con!=null) {getacces_con.close();}
				}catch(SQLException sqle){
					log.info("Error in Clientmaster_ACT method getSalesPastDue:\n"+sqle.getMessage());
				}
			}
			return newsdata;
		}
		
		public static double getSalesDueAmount(String ClientName,String InvoiceNo,String dateRange,String doAction,String token) {
			Connection getacces_con = null;
			PreparedStatement ps=null;
			ResultSet rs=null;
			double newsdata = 0;
			String fromDate="NA";
			String toDate="NA";
			try{
				
				if(!dateRange.equalsIgnoreCase("NA")){
					fromDate=dateRange.substring(0,10).trim();
					fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.substring(0,2);
					toDate=dateRange.substring(13).trim();
					toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2);
				}			
				getacces_con=DbCon.getCon("","","");				 
				StringBuffer queryselect=new StringBuffer("select cb.cbdueamount from hrmclient_billing cb inner join managesalesctrl ms on cb.cbinvoiceno=ms.msinvoiceno where cb.cbtokenno='"+token+"' and ms.msstatus='1' and ms.mstoken='"+token+"'");
				 if(!InvoiceNo.equalsIgnoreCase("NA"))queryselect.append(" and cb.cbinvoiceno='"+InvoiceNo+"'");
					if(!ClientName.equalsIgnoreCase("NA"))queryselect.append(" and cb.cbcompanyname='"+ClientName+"'");
					if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA")){
						queryselect.append(" and str_to_date(cb.cbdate,'%d-%m-%Y')<='"+toDate+"' and str_to_date(cb.cbdate,'%d-%m-%Y')>='"+fromDate+"'");
					}
					if(!doAction.equalsIgnoreCase("NA")){
						if(doAction.equalsIgnoreCase("Paid"))queryselect.append(" and cb.cbdueamount='0'");
						else if(doAction.equalsIgnoreCase("Current"))queryselect.append(" and ms.msworkpercent!='100'");						
						else if(doAction.equalsIgnoreCase("Past due"))queryselect.append(" and ms.msworkpercent='100' and cb.cbdueamount!='0'");
					}
					queryselect.append(" group by cb.cbuid");
//				System.out.println(VCQUERY);
				ps=getacces_con.prepareStatement(queryselect.toString());
				rs=ps.executeQuery();
				while(rs!=null&&rs.next())newsdata+=rs.getDouble(1);
			}catch(Exception e)
			{
				log.info("Error in Clientmaster_ACT method getTotalSalesDueAmount:\n"+e.getMessage());
			}
			finally{
				try{
					if(rs!=null) {rs.close();}
					if(ps!=null) {ps.close();}
					if(getacces_con!=null) {getacces_con.close();}
				}catch(SQLException sqle){
					log.info("Error in Clientmaster_ACT method getTotalSalesDueAmount:\n"+sqle.getMessage());
				}
			}
			return newsdata;
		}
		public static double getSalesDueAmount(String InvoiceNo,String token) {
			Connection getacces_con = null;
			PreparedStatement ps=null;
			ResultSet rs=null;
			double newsdata = 0;
			try{			
				getacces_con=DbCon.getCon("","","");				 
				StringBuffer queryselect=new StringBuffer("select cbdueamount from hrmclient_billing where cbinvoiceno='"+InvoiceNo+"' and cbtokenno='"+token+"'");
//				System.out.println(queryselect);
				ps=getacces_con.prepareStatement(queryselect.toString());
				rs=ps.executeQuery();
				if(rs!=null&&rs.next())newsdata=rs.getDouble(1);
			}catch(Exception e){
				e.printStackTrace();
				log.info("Error in Clientmaster_ACT method getSalesDueAmount:\n"+e.getMessage());
			}
			finally{
				try{
					if(rs!=null) {rs.close();}
					if(ps!=null) {ps.close();}
					if(getacces_con!=null) {getacces_con.close();}
				}catch(SQLException sqle){
					log.info("Error in Clientmaster_ACT method getSalesDueAmount:\n"+sqle.getMessage());
				}
			}
			return newsdata;
		}
		
		public static double getSalesOrderAmount(String InvoiceNo,String token) {
			Connection getacces_con = null;
			PreparedStatement ps=null;
			ResultSet rs=null;
			double newsdata = 0;
			try{			
				getacces_con=DbCon.getCon("","","");				 
				StringBuffer queryselect=new StringBuffer("select cborderamount from hrmclient_billing where cbinvoiceno='"+InvoiceNo+"' and cbtokenno='"+token+"'");
//				System.out.println(queryselect);
				ps=getacces_con.prepareStatement(queryselect.toString());
				rs=ps.executeQuery();
				if(rs!=null&&rs.next())newsdata=rs.getDouble(1);
			}catch(Exception e){
				e.printStackTrace();
				log.info("Error in Clientmaster_ACT method getSalesOrderAmount:\n"+e.getMessage());
			}
			finally{
				try{
					if(rs!=null) {rs.close();}
					if(ps!=null) {ps.close();}
					if(getacces_con!=null) {getacces_con.close();}
				}catch(SQLException sqle){
					log.info("Error in Clientmaster_ACT method getSalesOrderAmount:\n"+sqle.getMessage());
				}
			}
			return newsdata;
		}
		
		public static double getSalesDueAmount(String userRole,String loginuaid,String InvoiceNo,
				String PhoneKey,String ProductName,String ClientName,String SoldByUid,
				String dateRange,String token,String contactName,String department,String salesFilter) {
			Connection getacces_con = null;
			PreparedStatement ps=null;
			ResultSet rs=null;
			double newsdata = 0;
			String fromDate="NA";
			String toDate="NA";
			try{
				
				if(!dateRange.equalsIgnoreCase("NA")){
					fromDate=dateRange.substring(0,10).trim();
					fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.substring(0,2);
					toDate=dateRange.substring(13).trim();
					toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2);
				}			
				getacces_con=DbCon.getCon("","","");				 
				StringBuffer queryselect=new StringBuffer("select cb.cbdueamount from hrmclient_billing cb INNER JOIN managesalesctrl ms on "
						+ "cb.cbinvoiceno=ms.msinvoiceno INNER JOIN contactboxctrl c on ms.mscontactrefid=c.cbrefid where "
						+ "cb.cbtokenno='"+token+"' and ms.msstatus='1' and ms.mstoken='"+token+"'");
				if(salesFilter.equalsIgnoreCase("All"))
					queryselect.append(" and ms.mscancelstatus='2'");
				else if(salesFilter.equalsIgnoreCase("Cancelled"))
					queryselect.append(" and ms.mscancelstatus='1'");
				else if(salesFilter.equalsIgnoreCase("In-Progress"))
					queryselect.append(" and ms.mscancelstatus='2' and ms.msprojectstatus='3'");
				else if(salesFilter.equalsIgnoreCase("Completed"))
					queryselect.append(" and ms.mscancelstatus='2' and ms.msprojectstatus='2'");
				else if(salesFilter.equalsIgnoreCase("Past-Due"))
					queryselect.append(" and ms.mscancelstatus='2' and cb.cbdueamount>0");
				
			if(department.equalsIgnoreCase("Sales")||department.equalsIgnoreCase("Admin")) {	
				if(!userRole.equalsIgnoreCase("NA")&&userRole.equalsIgnoreCase("Executive")) queryselect.append(" and ms.mssoldbyuid = '"+loginuaid+"'");
				if(!userRole.equalsIgnoreCase("NA")&&!loginuaid.equalsIgnoreCase("NA")&&(userRole.equalsIgnoreCase("Assistant")||userRole.equalsIgnoreCase("Manager")))
					queryselect.append(" and exists(select t.mtid from manageteamctrl t join manageteammemberctrl m on t.mtrefid=m.tmteamrefid where t.mtadminid='"+loginuaid+"' and m.tmuseruid=ms.mssoldbyuid or ms.mssoldbyuid='"+loginuaid+"')"); 
			}else queryselect.append(" and (ms.mssoldbyuid = '"+loginuaid+"' or exists(select id from consulting_sale c where c.sales_key=ms.msrefid and c.consultant_uaid='"+loginuaid+"'))");
				if(!InvoiceNo.equalsIgnoreCase("NA"))queryselect.append(" and ms.msinvoiceno='"+InvoiceNo+"'");
					if(!PhoneKey.equalsIgnoreCase("NA"))queryselect.append(" and ms.mscontactrefid='"+PhoneKey+"'");
					if(!contactName.equalsIgnoreCase("NA"))queryselect.append(" and c.cbname='"+contactName+"'");
					if(!ProductName.equalsIgnoreCase("NA"))queryselect.append(" and ms.msproductname='"+ProductName+"'");
					if(!ClientName.equalsIgnoreCase("NA"))queryselect.append(" and ms.mscompany='"+ClientName+"'");
					if(!SoldByUid.equalsIgnoreCase("NA"))queryselect.append(" and ms.mssoldbyuid='"+SoldByUid+"'");
					if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA")){
						queryselect.append(" and str_to_date(ms.mssolddate,'%d-%m-%Y')<='"+toDate+"' and str_to_date(ms.mssolddate,'%d-%m-%Y')>='"+fromDate+"'");
					}
					queryselect.append(" group by cb.cbuid");
//				System.out.println(VCQUERY);
				ps=getacces_con.prepareStatement(queryselect.toString());
				rs=ps.executeQuery();
				while(rs!=null&&rs.next())newsdata+=rs.getDouble(1);
			}catch(Exception e)
			{
				log.info("Error in Clientmaster_ACT method getTotalSalesDueAmount:\n"+e.getMessage());
			}
			finally{
				try{
					if(rs!=null) {rs.close();}
					if(ps!=null) {ps.close();}
					if(getacces_con!=null) {getacces_con.close();}
				}catch(SQLException sqle){
					log.info("Error in Clientmaster_ACT method getTotalSalesDueAmount:\n"+sqle.getMessage());
				}
			}
			return newsdata;
		}
		
		public static double getTotalSalesDueAmount(String userRole,String loginuaid,
				String estDoAction,String token,String ClientName,String estimateNo,
				String dateRange,String contactName,String department) {
			Connection getacces_con = null;
			PreparedStatement ps=null;
			ResultSet rs=null;
			double newsdata = 0;
			String fromDate="NA";
			String toDate="NA";
			try{
				
				if(!dateRange.equalsIgnoreCase("NA")){
					fromDate=dateRange.substring(0,10).trim();
					fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.substring(0,2);
					toDate=dateRange.substring(13).trim();
					toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2);
				}
				getacces_con=DbCon.getCon("","","");				 
				StringBuffer VCQUERY=new StringBuffer("select cbdueamount from hrmclient_billing hb "
						+ "inner join estimatesalectrl es on hb.cbestimateno=es.essaleno "
						+ "INNER JOIN contactboxctrl c on es.escontactrefid=c.cbrefid where hb.cbtokenno='"+token+"' and es.estoken='"+token+"' and es.esstatus='Invoiced'"); 
			if(department.equalsIgnoreCase("Sales")||department.equalsIgnoreCase("Admin")) {	
				if(!userRole.equalsIgnoreCase("NA")&&!loginuaid.equalsIgnoreCase("NA")&&userRole.equalsIgnoreCase("Executive")){
					VCQUERY.append(" and es.essoldbyid = '"+loginuaid+"'");
				}else if(!userRole.equalsIgnoreCase("NA")&&!loginuaid.equalsIgnoreCase("NA")&&(userRole.equalsIgnoreCase("Assistant")||userRole.equalsIgnoreCase("Manager")))
					VCQUERY.append(" and exists(select t.mtid from manageteamctrl t join manageteammemberctrl m on t.mtrefid=m.tmteamrefid where t.mtadminid='"+loginuaid+"' and m.tmuseruid=es.essoldbyid or es.essoldbyid='"+loginuaid+"')");
				
			}else VCQUERY.append(" and es.essoldbyid = '"+loginuaid+"' ");
				
				if(!estDoAction.equalsIgnoreCase("NA")){
					if(estDoAction.equalsIgnoreCase("Draft"))VCQUERY.append(" and es.esstatus='"+estDoAction+"'");
					if(estDoAction.equalsIgnoreCase("Pending for approval")){
						VCQUERY.append(" and exists(select sid from salesestimatepayment where sestsaleno=es.essaleno and stransactionstatus='2' and stokenno='"+token+"')");
					}
				}else VCQUERY.append(" and e.esstatus!='Cancelled'");		
				if(!ClientName.equalsIgnoreCase("NA"))VCQUERY.append(" and es.escompany='"+ClientName+"'");
				if(!contactName.equalsIgnoreCase("NA"))VCQUERY.append(" and c.cbname='"+contactName+"'");
				if(!estimateNo.equalsIgnoreCase("NA"))VCQUERY.append(" and es.essaleno='"+estimateNo+"'");
				if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA")){
					VCQUERY.append(" and str_to_date(es.esregdate,'%d-%m-%Y')<='"+toDate+"' and str_to_date(es.esregdate,'%d-%m-%Y')>='"+fromDate+"'");
				}
				VCQUERY.append(" group by hb.cbuid");
//				System.out.println(VCQUERY);
				ps=getacces_con.prepareStatement(VCQUERY.toString());
				rs=ps.executeQuery();
				while(rs!=null&&rs.next())newsdata+=rs.getDouble(1);
			}catch(Exception e){e.printStackTrace();
				log.info("Error in Clientmaster_ACT method getTotalSalesDueAmount:\n"+e.getMessage());
			}
			finally{
				try{
					if(rs!=null) {rs.close();}
					if(ps!=null) {ps.close();}
					if(getacces_con!=null) {getacces_con.close();}
				}catch(SQLException sqle){
					log.info("Error in Clientmaster_ACT method getTotalSalesDueAmount:\n"+sqle.getMessage());
				}
			}
			return newsdata;
		}
		
		public static double getTotalSalesAmount(String userRole,String loginuaid,
				String estDoAction,String token,String ClientName,String estimateNo,
				String dateRange,String contactName,String department) {
			Connection getacces_con = null;
			PreparedStatement ps=null;
			ResultSet rs=null;
			double newsdata = 0;
			String fromDate="NA";
			String toDate="NA";
			try{
				
				if(!dateRange.equalsIgnoreCase("NA")){
					fromDate=dateRange.substring(0,10).trim();
					fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.substring(0,2);
					toDate=dateRange.substring(13).trim();
					toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2);
				}
				getacces_con=DbCon.getCon("","","");				 
				StringBuffer VCQUERY=new StringBuffer("select sp.sptotalprice from salesproductprice sp inner join "
						+ "estimatesalectrl es on sp.spsalesid=es.essaleno "
						+ "INNER JOIN contactboxctrl c on es.escontactrefid=c.cbrefid where sp.sptokenno='"+token+"' "
								+ "and es.estoken='"+token+"' and sp.spstatus='1'"); 
			if(department.equalsIgnoreCase("Sales")||department.equalsIgnoreCase("Admin")) {	
				if(!userRole.equalsIgnoreCase("NA")&&!loginuaid.equalsIgnoreCase("NA")&&userRole.equalsIgnoreCase("Executive")){
					VCQUERY.append(" and es.essoldbyid = '"+loginuaid+"'");
				}else if(!userRole.equalsIgnoreCase("NA")&&!loginuaid.equalsIgnoreCase("NA")&&(userRole.equalsIgnoreCase("Assistant")||userRole.equalsIgnoreCase("Manager")))
					VCQUERY.append(" and exists(select t.mtid from manageteamctrl t join manageteammemberctrl m on t.mtrefid=m.tmteamrefid where t.mtadminid='"+loginuaid+"' and m.tmuseruid=es.essoldbyid or es.essoldbyid='"+loginuaid+"')");
			}else VCQUERY.append(" and es.essoldbyid = '"+loginuaid+"' ");
				
				if(!estDoAction.equalsIgnoreCase("NA")){
					if(estDoAction.equalsIgnoreCase("Invoiced")||estDoAction.equalsIgnoreCase("Draft")||estDoAction.equalsIgnoreCase("Cancelled"))VCQUERY.append(" and es.esstatus='"+estDoAction+"'");
					else if(estDoAction.equalsIgnoreCase("Pending for approval")){
						VCQUERY.append(" and exists(select sid from salesestimatepayment where sestsaleno=es.essaleno and stransactionstatus='2' and stokenno='"+token+"')");
					}
				}else VCQUERY.append(" and e.esstatus!='Cancelled'");
				if(!ClientName.equalsIgnoreCase("NA"))VCQUERY.append(" and es.escompany='"+ClientName+"'");
				if(!contactName.equalsIgnoreCase("NA"))VCQUERY.append(" and c.cbname='"+contactName+"'");
				if(!estimateNo.equalsIgnoreCase("NA"))VCQUERY.append(" and es.essaleno='"+estimateNo+"'");
				if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA")){
					VCQUERY.append(" and str_to_date(es.esregdate,'%d-%m-%Y')<='"+toDate+"' and str_to_date(es.esregdate,'%d-%m-%Y')>='"+fromDate+"'");
				}
				VCQUERY.append(" group by sp.spid");
//				System.out.println(VCQUERY);
				ps=getacces_con.prepareStatement(VCQUERY.toString());
				
				 rs=ps.executeQuery();
				while(rs!=null&&rs.next())newsdata+=rs.getDouble(1);
			}catch(Exception e)
			{
				log.info("Error in Clientmaster_ACT method getTotalSalesAmount:\n"+e.getMessage());
			}
			finally{
				try{
					if(rs!=null) {rs.close();}
					if(ps!=null) {ps.close();}
					if(getacces_con!=null) {getacces_con.close();}
				}catch(SQLException sqle){
					log.info("Error in Clientmaster_ACT method getTotalSalesAmount:\n"+sqle.getMessage());
				}
			}
			return newsdata;
		}
		
		//getting client's total project
		public static double getTotalClientProjectAmount(String salesno,String token) {
			Connection getacces_con = null;
			PreparedStatement ps=null;
			ResultSet rs=null;
			double newsdata = 0;
			try{
				getacces_con=DbCon.getCon("","","");				 
				 ps=getacces_con.prepareStatement("select sum(sptotalprice) from salesproductprice where sptokenno='"+token+"' and spsalesid='"+salesno+"'");
				rs=ps.executeQuery();
//				System.out.println("select pp.totalprice from project_price pp join hrmproject_reg hr on hr.preguid=pp.preguid where hr.pregtokenno='"+token+"' and hr.pregcuid='"+clientid+"' and hr.pregrunningstatus!='Delivered' and pp.tokenno='"+token+"'");
				if(rs.next())newsdata=rs.getDouble(1);
			}catch(Exception e)
			{
				log.info("Error in Clientmaster_ACT method getTotalClientProjectAmount:\n"+e.getMessage());
			}
			finally{
				try{
					if(rs!=null) {rs.close();}
					if(ps!=null) {ps.close();}
					if(getacces_con!=null) {getacces_con.close();}
				}catch(SQLException sqle){
					log.info("Error in Clientmaster_ACT method getTotalClientProjectAmount:\n"+sqle.getMessage());
				}
			}
			return newsdata;
		}
		
		public static int countContactBySuperUser(String superUserId,String token) {
			Connection getacces_con = null;
			PreparedStatement stmnt=null;
			ResultSet rsGCD=null;
			int newsdata = 0;
			try{
				getacces_con=DbCon.getCon("","","");
				String query="SELECT count(ccbid) FROM clientcontactbox where super_user_id='"+superUserId +"' and cctokenno='"+token+"'";
				stmnt=getacces_con.prepareStatement(query);
				rsGCD=stmnt.executeQuery();
				if(rsGCD.next()) newsdata=rsGCD.getInt(1);
			}catch(Exception e)
			{
				log.info("Error in Clientmaster_ACT method countContactBySuperUser:\n"+e.getMessage());
			}
			finally{
				try{
					if(stmnt!=null) {stmnt.close();}
					if(getacces_con!=null) {getacces_con.close();}
					if(rsGCD!=null) rsGCD.close();
				}catch(SQLException sqle){
					sqle.printStackTrace();
					log.info("Error Closing SQL Objects countContactBySuperUser:\n"+sqle.getMessage());
				}
			}
			return newsdata;
		}
		
		public static int countClientsBySuperUser(String superUserId,String token) {
			Connection getacces_con = null;
			PreparedStatement stmnt=null;
			ResultSet rsGCD=null;
			int newsdata = 0;
			try{
				getacces_con=DbCon.getCon("","","");
				String query="SELECT count(creguid) FROM hrmclient_reg where super_user_uaid='"+superUserId +"' and cregtokenno='"+token+"'";
				stmnt=getacces_con.prepareStatement(query);
				rsGCD=stmnt.executeQuery();
				if(rsGCD.next()) newsdata=rsGCD.getInt(1);
			}catch(Exception e)
			{
				log.info("Error in Clientmaster_ACT method countClientsBySuperUser:\n"+e.getMessage());
			}
			finally{
				try{
					if(stmnt!=null) {stmnt.close();}
					if(getacces_con!=null) {getacces_con.close();}
					if(rsGCD!=null) rsGCD.close();
				}catch(SQLException sqle){
					sqle.printStackTrace();
					log.info("Error Closing SQL Objects countClientsBySuperUser:\n"+sqle.getMessage());
				}
			}
			return newsdata;
		}
		
		//counting all project price type
		public static int getCurrentProductQty(String prodrefid,String token) {
			Connection getacces_con = null;
			PreparedStatement stmnt=null;
			ResultSet rsGCD=null;
			int newsdata = 0;
			try{
				getacces_con=DbCon.getCon("","","");
				String query="SELECT esprodqty FROM estimatesalectrl where esrefid='"+prodrefid +"' and estoken='"+token+"'";
				stmnt=getacces_con.prepareStatement(query);
				rsGCD=stmnt.executeQuery();
				if(rsGCD.next()) newsdata=rsGCD.getInt(1);
			}catch(Exception e)
			{
				log.info("Error in Clientmaster_ACT method getCurrentProductQty:\n"+e.getMessage());
			}
			finally{
				try{
					if(stmnt!=null) {stmnt.close();}
					if(getacces_con!=null) {getacces_con.close();}
					if(rsGCD!=null) rsGCD.close();
				}catch(SQLException sqle){
					sqle.printStackTrace();
					log.info("Error Closing SQL Objects getCurrentProductQty:\n"+sqle.getMessage());
				}
			}
			return newsdata;
		}
		
		//counting all project price type
		public static int getCountAllPriceItemsPaid(String preguid,String token,String typefrom) {
			Connection getacces_con = null;
			PreparedStatement stmnt=null;
			ResultSet rsGCD=null;
			int newsdata = 0;
			try{
				getacces_con=DbCon.getCon("","","");
				String query="SELECT count(cbmid) FROM clientbillingmapping where cbmpreguid='"+preguid+"' and cbmtoken='"+token+"' and cbmstatus='1' and cbmpaymentstatus='1' and cbmcategory='"+typefrom+"'";
				stmnt=getacces_con.prepareStatement(query);
				rsGCD=stmnt.executeQuery();
				if(rsGCD.next()) newsdata=rsGCD.getInt(1);
			}catch(Exception e)
			{
				log.info("Error in Clientmaster_ACT method getCountAllPriceItemsPaid:\n"+e.getMessage());
			}
			finally{
				try{
					if(stmnt!=null) {stmnt.close();}
					if(getacces_con!=null) {getacces_con.close();}
					if(rsGCD!=null) rsGCD.close();
				}catch(SQLException sqle){
					sqle.printStackTrace();
					log.info("Error Closing SQL Objects getCountAllPriceItemsPaid:\n"+sqle.getMessage());
				}
			}
			return newsdata;
		}
		
		//adding all project price amount
		public static double getTotalRenewalAmount(String preguid,String token) {
			Connection getacces_con = null;
			PreparedStatement stmnt=null;
			ResultSet rsGCD=null;
			double newsdata = 0;
			try{
				getacces_con=DbCon.getCon("","","");
				String query="SELECT sum(totalprice) FROM project_price where preguid='"+preguid+"' and tokenno='"+token+"' and status='1' and enq='NA' and servicetype='Renewal'";
				stmnt=getacces_con.prepareStatement(query);
				rsGCD=stmnt.executeQuery();
				if(rsGCD.next()) newsdata=rsGCD.getDouble(1);
			}catch(Exception e)
			{
				log.info("Error in Clientmaster_ACT method getTotalRenewalAmount:\n"+e.getMessage());
			}
			finally{
				try{
					if(stmnt!=null) {stmnt.close();}
					if(getacces_con!=null) {getacces_con.close();}
					if(rsGCD!=null) rsGCD.close();
				}catch(SQLException sqle){
					sqle.printStackTrace();
					log.info("Error Closing SQL Objects getTotalRenewalAmount:\n"+sqle.getMessage());
				}
			}
			return newsdata;
		}
		
		//counting all project price type of amc
		public static int getCountAllAMCPriceItems(String preguid,String token) {
			Connection getacces_con = null;
			PreparedStatement stmnt=null;
			ResultSet rsGCD=null;
			int newsdata = 0;
			try{
				getacces_con=DbCon.getCon("","","");
				String query="SELECT count(id) FROM project_price where preguid='"+preguid+"' and tokenno='"+token+"' and status='1' and enq='NA' and servicetype='Renewal'";
				stmnt=getacces_con.prepareStatement(query);
				rsGCD=stmnt.executeQuery();
				if(rsGCD.next()) newsdata=rsGCD.getInt(1);
			}catch(Exception e)
			{
				log.info("Error in Clientmaster_ACT method getCountAllAMCPriceItems:\n"+e.getMessage());
			}
			finally{
				try{
					if(stmnt!=null) {stmnt.close();}
					if(getacces_con!=null) {getacces_con.close();}
					if(rsGCD!=null) rsGCD.close();
				}catch(SQLException sqle){
					sqle.printStackTrace();
					log.info("Error Closing SQL Objects getCountAllAMCPriceItems:\n"+sqle.getMessage());
				}
			}
			return newsdata;
		}
		
		//counting all project price type
		public static int getCountAllPriceItems(String preguid,String token) {
			Connection getacces_con = null;
			PreparedStatement stmnt=null;
			ResultSet rsGCD=null;
			int newsdata = 0;
			try{
				getacces_con=DbCon.getCon("","","");
				String query="SELECT count(id) FROM project_price where preguid='"+preguid+"' and tokenno='"+token+"' and status='1' and enq='NA'";
				stmnt=getacces_con.prepareStatement(query);
				rsGCD=stmnt.executeQuery();
				if(rsGCD.next()) newsdata=rsGCD.getInt(1);
			}catch(Exception e)
			{
				log.info("Error in Clientmaster_ACT method getCountAllPriceItems:\n"+e.getMessage());
			}
			finally{
				try{
					if(stmnt!=null) {stmnt.close();}
					if(getacces_con!=null) {getacces_con.close();}
					if(rsGCD!=null) rsGCD.close();
				}catch(SQLException sqle){
					sqle.printStackTrace();
					log.info("Error Closing SQL Objects getCountAllPriceItems:\n"+sqle.getMessage());
				}
			}
			return newsdata;
		}
		
		//getting client's total project
		public static int getTotalDeliveredProject(String cid,String token) {
			Connection getacces_con = null;
			PreparedStatement stmnt=null;
			ResultSet rsGCD=null;
			int newsdata = 0;
			try{
				getacces_con=DbCon.getCon("","","");
				String query="SELECT count(preguid) FROM hrmproject_reg WHERE EXISTS(select id from project_price where project_price.preguid=hrmproject_reg.preguid and project_price.servicetype='Renewal') and pregcuid='"+cid+"' and pregtokenno='"+token+"' and pregrunningstatus='Delivered'";
				stmnt=getacces_con.prepareStatement(query);
				rsGCD=stmnt.executeQuery();
				if(rsGCD.next()) newsdata=rsGCD.getInt(1);
			}catch(Exception e)
			{
				log.info("Error in Clientmaster_ACT method getTotalDeliveredProject:\n"+e.getMessage());
			}
			finally{
				try{
					if(stmnt!=null) {stmnt.close();}
					if(getacces_con!=null) {getacces_con.close();}
					if(rsGCD!=null) rsGCD.close();
				}catch(SQLException sqle){
					sqle.printStackTrace();
					log.info("Error Closing SQL Objects getTotalDeliveredProject:\n"+sqle.getMessage());
				}
			}
			return newsdata;
		}	
		
		//getting client's total project
				public static int getTotalClientProject(String cid,String token) {
					Connection getacces_con = null;
					PreparedStatement stmnt=null;
					ResultSet rsGCD=null;
					int newsdata = 0;
					try{
						getacces_con=DbCon.getCon("","","");
						String query="SELECT count(preguid) FROM hrmproject_reg WHERE pregcuid='"+cid+"' and pregtokenno='"+token+"' and pregrunningstatus!='Delivered'";
						stmnt=getacces_con.prepareStatement(query);
						rsGCD=stmnt.executeQuery();
						if(rsGCD.next()) newsdata=rsGCD.getInt(1);
					}catch(Exception e)
					{
						log.info("Error in Clientmaster_ACT method getTotalClientProject:\n"+e.getMessage());
					}
					finally{
						try{
							if(stmnt!=null) {stmnt.close();}
							if(getacces_con!=null) {getacces_con.close();}
							if(rsGCD!=null) rsGCD.close();
						}catch(SQLException sqle){
							sqle.printStackTrace();
							log.info("Error Closing SQL Objects getTotalClientProject:\n"+sqle.getMessage());
						}
					}
					return newsdata;
				}	
		//getting total amount
		public static double getTotalAmount(String cid,String token,String from) {
			Connection getacces_con = null;
			PreparedStatement stmnt=null;
			ResultSet rsGCD=null;
			double newsdata = 0;
			try{
				getacces_con=DbCon.getCon("","","");
				String query="SELECT sum(vfinalamount) FROM virtual_project_price WHERE vclientid='"+cid+"' and vtokenno='"+token+"' and vpricefrom='"+from+"'";
				stmnt=getacces_con.prepareStatement(query);
				rsGCD=stmnt.executeQuery();
				if(rsGCD.next()) newsdata=rsGCD.getDouble(1);
			}catch(Exception e)
			{
				log.info("Error in Clientmaster_ACT method getTotalAmount:\n"+e.getMessage());
			}
			finally{
				try{
					if(stmnt!=null) {stmnt.close();}
					if(getacces_con!=null) {getacces_con.close();}
					if(rsGCD!=null) rsGCD.close();
				}catch(SQLException sqle){
					sqle.printStackTrace();
					log.info("Error Closing SQL Objects getTotalAmount:\n"+sqle.getMessage());
				}
			}
			return newsdata;
		}	
		
	//getting client details 
	public static String[][] getItemDetails(String cid,String token,String from) {
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			String query="SELECT vid,vpriceid,vpreguid,vcoupon,vdiscount,vfinalamount,vduedate FROM virtual_project_price WHERE vclientid='"+cid+"' and vtokenno='"+token+"' and vpricefrom='"+from+"'";
			stmnt=getacces_con.prepareStatement(query);
			rsGCD=stmnt.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];
			int rr=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++)
				{
					newsdata[rr][i]=rsGCD.getString(i+1);
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("Error in Clientmaster_ACT method getItemDetails:\n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getItemDetails:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}	
	
	//getting billing items 
	public static String[][] getAllBillingItems(String billno,String token,String type) {
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			String query="SELECT pricetype,price,gst,gstprice,totalprice,gststatus FROM project_price join clientbillingmapping on clientbillingmapping.cbmppid=project_price.id WHERE project_price.tokenno='"+token+"' and project_price.status='1' and clientbillingmapping.cbmstatus='1' and clientbillingmapping.cbmbillno='"+billno+"' and clientbillingmapping.cbmcategory='"+type+"'";
			stmnt=getacces_con.prepareStatement(query);
//			System.out.println(query);
			rsGCD=stmnt.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];
			int rr=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++)
				{
					newsdata[rr][i]=rsGCD.getString(i+1);
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("Error in Clientmaster_ACT method getAllBillingItems:\n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllBillingItems:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] getContactDetails(String conrefid,String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			String query="SELECT cccontactfirstname,cccontactlastname,ccemailfirst,ccworkphone,cccity,ccstate,ccaddress FROM clientcontactbox WHERE ccbrefid='"+conrefid+"' and cctokenno='"+token+"'";
//			System.out.println(query);
			stmnt=getacces_con.prepareStatement(query);
			rsGCD=stmnt.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];
			int rr=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++)
				{
					newsdata[rr][i]=rsGCD.getString(i+1);
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("Error in Clientmaster_ACT method getContactDetails:\n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getContactDetails:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}	
	
	//getting client details 
	public static String[][] getClientDetails(int clientId,String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			String query="SELECT cregname,cregucid,cregmob,cregemailid,cregaddress,cregindustry,cregcountry,cregstate,"
					+ "creglocation,cregpan,creggstin,cregcompanyage,cregstatecode FROM hrmclient_reg WHERE creguid='"+clientId+"' and cregtokenno='"+token+"'";
			stmnt=getacces_con.prepareStatement(query);
			rsGCD=stmnt.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];
			int rr=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++)
				{
					newsdata[rr][i]=rsGCD.getString(i+1);
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("Error in Clientmaster_ACT method getClientDetails:\n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getClientDetails:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}	
	
	//getting billing details 
	public static String[] getBillingDetails(String refid) {
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[] newsdata =new String[7];
		try{
			getacces_con=DbCon.getCon("","","");
			String query="SELECT cbcuid,cbinvno,cbtokenno,cbdate,cbtype,cbfinalamount,cddueamount FROM hrmclient_billing WHERE cbrefid='"+refid+"' and cbstatus='1'";
			stmnt=getacces_con.prepareStatement(query);
			rsGCD=stmnt.executeQuery();			
			while(rsGCD!=null && rsGCD.next()){
				newsdata[0]=rsGCD.getString(1);
				newsdata[1]=rsGCD.getString(2);
				newsdata[2]=rsGCD.getString(3);
				newsdata[3]=rsGCD.getString(4);
				newsdata[4]=rsGCD.getString(5);
				newsdata[5]=rsGCD.getString(6);
				newsdata[6]=rsGCD.getString(7);
			}
		}catch(Exception e)
		{log.info("Error in Clientmaster_ACT method getBillingDetails:\n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getBillingDetails:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	
	//getting billing details 
	public static String[][] getReceiptBillingDetails(String cid,String token,String type) {
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			String query="SELECT cbuid,cbrefid,cbinvno,cbcuid,cbdate,cbfinalamount,cbprojectid FROM hrmclient_billing WHERE cbcuid='"+cid+"' and cbtokenno='"+token+"' and cbtype='"+type+"' order by cbuid desc";
			stmnt=getacces_con.prepareStatement(query);
			rsGCD=stmnt.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];
			int rr=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++)
				{
					newsdata[rr][i]=rsGCD.getString(i+1);
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("Error in Clientmaster_ACT method getReceiptBillingDetails:\n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getReceiptBillingDetails:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}	
	
	//getting project details 
		public static String[][] getBillingProjectDetails(String cid,String token) {
			Connection getacces_con = null;
			PreparedStatement stmnt=null;
			ResultSet rsGCD=null;
			String[][] newsdata = null;
			try{
				getacces_con=DbCon.getCon("","","");
				String query="SELECT preguid,pregpuno,pregcuid,pregtype,pregpname,pregsdate,pregremarks,pregddate FROM hrmproject_reg WHERE pregcuid='"+cid+"' and pregtokenno='"+token+"' and pregrunningstatus!='Delivered'";
				stmnt=getacces_con.prepareStatement(query);
				rsGCD=stmnt.executeQuery();
				rsGCD.last();
				int row=rsGCD.getRow();
				rsGCD.beforeFirst();
				ResultSetMetaData rsmd=rsGCD.getMetaData();
				int col=rsmd.getColumnCount();
				newsdata=new String[row][col];
				int rr=0;
				while(rsGCD!=null && rsGCD.next()){
					for(int i=0;i<col;i++)
					{
						newsdata[rr][i]=rsGCD.getString(i+1);
					}
					rr++;
				}
			}catch(Exception e)
			{log.info("Error in Clientmaster_ACT method getBillingProjectDetails:\n"+e.getMessage());}
			finally{
				try{
					if(stmnt!=null) {stmnt.close();}
					if(getacces_con!=null) {getacces_con.close();}
					if(rsGCD!=null) rsGCD.close();
				}catch(SQLException sqle){
					sqle.printStackTrace();
					log.info("Error Closing SQL Objects getBillingProjectDetails:\n"+sqle.getMessage());
				}
			}
			return newsdata;
		}	
	//getting delivered project details 
	public static String[][] getProjectDetails(String cid,String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			String query="SELECT hp.preguid,hp.pregpuno,hp.pregcuid,hp.pregtype,hp.pregpname,hp.pregsdate,hp.pregremarks,hp.pregddate FROM hrmproject_reg hp left join project_price pp on pp.preguid=hp.preguid WHERE hp.pregcuid='"+cid+"' and hp.pregtokenno='"+token+"' and hp.pregrunningstatus='Delivered' and pp.servicetype='Renewal' group by hp.preguid";
			stmnt=getacces_con.prepareStatement(query);
//			System.out.println(query);
			rsGCD=stmnt.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];
			int rr=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++)
				{
					newsdata[rr][i]=rsGCD.getString(i+1);
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("Error in Clientmaster_ACT method getProjectDetails:\n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getProjectDetails:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}	
	//getting renewal product_price details 
	public static String[][] getRenewalProjectPrice(String id) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			String query="SELECT id,pricetype,price,servicetype,term,termtime,	gststatus,gst,gstprice,totalprice FROM project_price WHERE preguid='"+id+"' and servicetype='Renewal' order by id desc";
			stmnt=getacces_con.prepareStatement(query);
			rsGCD=stmnt.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];
			int rr=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++)
				{
					newsdata[rr][i]=rsGCD.getString(i+1);
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("Error in Clientmaster_ACT method getRenewalProjectPrice:\n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getRenewalProjectPrice:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	//getting renewal product_price details 
	public static String[][] getBillingProjectPrice(String id) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			String query="SELECT id,pricetype,price,servicetype,term,termtime,gststatus,gst,gstprice,totalprice FROM project_price WHERE preguid='"+id+"' and enq='NA' order by id desc";
			stmnt=getacces_con.prepareStatement(query);
			rsGCD=stmnt.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];
			int rr=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++)
				{
					newsdata[rr][i]=rsGCD.getString(i+1);
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("Error in Clientmaster_ACT method getBillingProjectPrice:\n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getBillingProjectPrice:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	//getting project price on manage project
	public static String[][] getManageProjectPrice(String id) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			String query="SELECT id,pricetype,price,servicetype,term,termtime,gststatus,gst,gstprice,totalprice,renewal_date FROM project_price WHERE preguid='"+id+"' order by id desc";
			stmnt=getacces_con.prepareStatement(query);
			rsGCD=stmnt.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];
			int rr=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++)
				{
					newsdata[rr][i]=rsGCD.getString(i+1);
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("Error in Clientmaster_ACT method getManageProjectPrice:\n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getManageProjectPrice:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	
	//getting renewal product_price details 
	public static String[][] getProjectPrice(String id) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			String query="SELECT id,pricetype,price,servicetype,term,termtime,gststatus,gst,gstprice,totalprice,renewal_date FROM project_price WHERE preguid='"+id+"' and servicetype='Renewal' order by id desc";
			stmnt=getacces_con.prepareStatement(query);
			rsGCD=stmnt.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];
			int rr=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++)
				{
					newsdata[rr][i]=rsGCD.getString(i+1);
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("Error in Clientmaster_ACT method getProjectPrice:\n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getProjectPrice:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	
	//getting Login User Name
		public static String getLoginUserName(String uaid) {			
			PreparedStatement ps = null;	
			ResultSet rs=null;
			String data="NA";
			Connection con = DbCon.getCon("","","");
			try{
			    ps=con.prepareStatement("select uaname from user_account where uaid='"+uaid+"'");
			    rs=ps.executeQuery();
			    if(rs.next())data=rs.getString(1);
			  
				}
			catch (Exception e) {
				log.info("Error in Clientmaster_ACT method getLoginUserName:\n"+e.getMessage());
			}
			finally{
				try{
					if(ps!=null) {ps.close();}
					if(con!=null) {con.close();}
					if(rs!=null) {rs.close();}
				}catch(SQLException sqle){
					sqle.printStackTrace();
					log.info("Error Closing SQL Objects getLoginUserName:\n"+sqle.getMessage());
				}
			}
			return data;
		}
	
	//getting renewal status of a client's project
	public static String getRenewalStatus(String clientid,String token) {			
		PreparedStatement ps = null;	
		ResultSet rs=null;
		String data="NO";
		Connection con = DbCon.getCon("","","");
		try{
		    ps=con.prepareStatement("select hr.preguid from hrmproject_reg hr join project_price pp on pp.preguid=hr.preguid where hr.pregtokenno='"+token+"' and hr.pregrunningstatus!='Delivered' and hr.pregcuid='"+clientid+"' and pp.servicetype='Renewal' and pp.tokenno='"+token+"'");
		    rs=ps.executeQuery();
		  if(rs.next())data="YES";
			}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method getRenewalStatus:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getRenewalStatus:\n"+sqle.getMessage());
			}
		}
		return data;
	}
	
	public static boolean makePrimaryExceptThis(String clientKey,String conKey,String token){
		boolean status=false;
		PreparedStatement ps = null;	
		Connection con = DbCon.getCon("","","");
		try{		    
			  ps=con.prepareStatement("update clientcontactbox set ccprimarystatus=?  where ccbrefid!=? and ccbclientrefid=? and cctokenno=?");
			  ps.setString(1, "2");
			  ps.setString(2, conKey);
			  ps.setString(3, clientKey);
			  ps.setString(4, token);
			 
			  
			  int k=ps.executeUpdate();
			  if(k>0) status=true;
			}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method makePrimaryExceptThis:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects makePrimaryExceptThis:\n"+sqle.getMessage());
			}
		}	
		return status;
		
	}
	
	public static boolean makeThisPrimary(String conKey,String token){
		boolean status=false;
		PreparedStatement ps = null;	
		Connection con = DbCon.getCon("","","");
		try{		    
			  ps=con.prepareStatement("update clientcontactbox set ccprimarystatus=?  where ccbrefid=? and cctokenno=?");
			  ps.setString(1, "1");
			  ps.setString(2, conKey);
			  ps.setString(3, token);
			 
			  
			  int k=ps.executeUpdate();
			  if(k>0) status=true;
			}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method makeThisPrimary:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects makeThisPrimary:\n"+sqle.getMessage());
			}
		}	
		return status;
		
	}
	
	public static boolean updateClientPersonalData(String clientKey,String firstName,String lastName,String email,String phone,String city,String state,String address,String token){
		boolean status=false;
		PreparedStatement ps = null;	
		Connection con = DbCon.getCon("","","");
		try{		    
			  ps=con.prepareStatement("update hrmclient_reg set cregcontfirstname=?,cregcontlastname=?,cregcontemailid=?,cregcontmobile=?,cregcontcity=?,cregcontstate=?,cregcontaddress=? where cregclientrefid=? and cregtokenno=?");
			  ps.setString(1, firstName);
			  ps.setString(2, lastName);
			  ps.setString(3, email);
			  ps.setString(4, phone);
			  ps.setString(5, city);
			  ps.setString(6, state);
			  ps.setString(7, address);
			  ps.setString(8, clientKey);
			  ps.setString(9, token);
			  
			  int k=ps.executeUpdate();
			  if(k>0) status=true;
			}
		catch (Exception e) {
			e.printStackTrace();
			log.info("Error in Clientmaster_ACT method updateClientPersonalData:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateClientPersonalData:\n"+sqle.getMessage());
			}
		}	
		return status;
		
	}
	
	public static boolean updateCompanyDetail(String industrytype,String pan,String gstin,
			String city,String state,String country,String address,String companykey,
			String token,String companyAge,String stateCode,int superUserUaid){
		boolean status=false;
		PreparedStatement ps = null;	
		Connection con = DbCon.getCon("","","");
		try{		    
			  ps=con.prepareStatement("update hrmclient_reg set cregindustry=?,cregpan=?,creggstin=?,"
			  		+ "creglocation=?,cregstate=?,cregcountry=?,cregaddress=?,cregcompanyage=?,"
			  		+ "cregstatecode=?,super_user_uaid=? "
			  		+ "where cregclientrefid=? and cregtokenno=?");
			  ps.setString(1, industrytype);
			  ps.setString(2, pan);
			  ps.setString(3, gstin);
			  ps.setString(4, city);
			  ps.setString(5, state);
			  ps.setString(6, country);
			  ps.setString(7, address);
			  ps.setString(8, companyAge);
			  ps.setString(9, stateCode);
			  ps.setInt(10, superUserUaid);
			  ps.setString(11, companykey);
			  ps.setString(12, token);
			  
			  ps.execute(); 
			  status=true;
			}
		catch (Exception e) {e.printStackTrace();
			log.info("Error in Clientmaster_ACT method updateCompanyDetail:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateCompanyDetail:\n"+sqle.getMessage());
			}
		}	
		return status;
		
	}
	
	public static boolean updateCompanyDetail(String industrytype,String pan,String gstin,
			String city,String state,String country,String address,String companykey,
			String token,String companyAge,String stateCode,String companyName,int superUserUaid){
		boolean status=false;
		PreparedStatement ps = null;	
		Connection con = DbCon.getCon("","","");
		try{		    
			  ps=con.prepareStatement("update hrmclient_reg set cregindustry=?,cregpan=?,"
			  		+ "creggstin=?,creglocation=?,cregstate=?,cregcountry=?,cregaddress=?,"
			  		+ "cregcompanyage=?,cregstatecode=?,cregname=?,super_user_uaid=? "
			  		+ "where cregclientrefid=? and cregtokenno=?");
			  ps.setString(1, industrytype);
			  ps.setString(2, pan);
			  ps.setString(3, gstin);
			  ps.setString(4, city);
			  ps.setString(5, state);
			  ps.setString(6, country);
			  ps.setString(7, address);
			  ps.setString(8, companyAge);
			  ps.setString(9, stateCode);
			  ps.setString(10, companyName);
			  ps.setInt(11, superUserUaid);
			  ps.setString(12, companykey);
			  ps.setString(13, token);
			  
			  ps.execute(); 
			  status=true;
			}
		catch (Exception e) {e.printStackTrace();
			log.info("Error in Clientmaster_ACT method updateCompanyDetail:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateCompanyDetail:\n"+sqle.getMessage());
			}
		}	
		return status;
		
	}
	
	//updating updateProductPlan
	public static boolean updateSalesProductPlan(String colname,String colvalue,String prodrefid,String token) {
		boolean status=false;
		PreparedStatement ps = null;	
		Connection con = DbCon.getCon("","","");
		try{		   
			if(!colvalue.equalsIgnoreCase("OneTime"))
			  ps=con.prepareStatement("update estimatesalectrl set "+colname+"=? where esrefid=? and estoken=?");
			else
				ps=con.prepareStatement("update estimatesalectrl set "+colname+"=?,esplanperiod='NA',esplantime='NA' where esrefid=? and estoken=?");
			  ps.setString(1, colvalue);
			  ps.setString(2, prodrefid);
			  ps.setString(3, token);
			  int k=ps.executeUpdate();
			  if(k>0)  status=true;
			}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method updateSalesProductPlan:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateSalesProductPlan:\n"+sqle.getMessage());
			}
		}	
		return status;
	}
	
	//updating updateProductPlan
	public static boolean updateProductPlan(String key,String colvalue,String token) {
		boolean status=false;
		PreparedStatement ps = null;	
		Connection con = DbCon.getCon("","","");
		try{		    
			  ps=con.prepareStatement("update salesproductrenewalvirtualctrl set spvprodplan=?,spvplanperiod=?,spvplantime=? where spvprodrefid=? and spvtokenno=?");
			  ps.setString(1, colvalue);
			  ps.setString(2, "NA");
			  ps.setString(3, "NA");
			  ps.setString(4, key);
			  ps.setString(5, token);
			  ps.execute(); 
			  status=true;
			}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method updateProductPlan:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateProductPlan:\n"+sqle.getMessage());
			}
		}	
		return status;
	}
	
	//updating updateProductPlan
	public static boolean updateProductPlan(String key,String column,String colvalue,String token) {
		boolean status=false;
		PreparedStatement ps = null;	
		Connection con = DbCon.getCon("","","");
		try{		    
			  ps=con.prepareStatement("update salesproductrenewalvirtualctrl set "+column+"=? where spvprodrefid=? and spvtokenno=?");
			  ps.setString(1, colvalue);			
			  ps.setString(2, key);
			  ps.setString(3, token);
			  ps.execute(); 
			  status=true;
			}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method updateProductPlan:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateProductPlan:\n"+sqle.getMessage());
			}
		}	
		return status;
	}
	
	//updating updatePriceOfProduct
	public static String getProductQuantity(String virtualid,String prodqty,String token,String addedby) {
		PreparedStatement ps = null;	
		ResultSet rs=null;
		String sql="NA";
		String qty="1";
		Connection con = DbCon.getCon("","","");
		try{		 
			sql="select spvqty from salesproductvirtual where spvvirtualid='"+virtualid+"' and spvtokenno='"+token+"' and spvaddedby='"+addedby+"' order by spvid desc limit 1";
			
			  ps=con.prepareStatement(sql);			 
			 rs=ps.executeQuery();
			 if(rs.next())qty=rs.getString(1);
			}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method getProductQuantity:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getProductQuantity:\n"+sqle.getMessage());
			}
		}	
		return qty;
	}
	
	//updating updatePriceOfProduct
	public static boolean updateQtyOfProductDirect(String virtualid,String prodqty,String token,String addedby) {
		boolean status=false;
		PreparedStatement ps = null;	
		ResultSet rs=null;
		String sql="NA";
		Connection con = DbCon.getCon("","","");
		try{		 
			sql="update salesproductvirtual set spvqty='"+prodqty+"' where spvvirtualid='"+virtualid+"' and spvtokenno='"+token+"' and spvaddedby='"+addedby+"'";
			
			  ps=con.prepareStatement(sql);			 
			  int k=ps.executeUpdate();
			  if(k>0) status=true;
			}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method updateQtyOfProductDirect:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateQtyOfProductDirect:\n"+sqle.getMessage());
			}
		}	
		return status;
	}

	//updating updatePriceOfProduct
		public static boolean updateSalesQtyOfProduct(String prodrefid,String action,String token) {
			boolean status=false;
			PreparedStatement ps = null;	
			ResultSet rs=null;
			String sql="NA";
			Connection con = DbCon.getCon("","","");
			try{		 
				if(action.equalsIgnoreCase("minus"))	{
					sql="update estimatesalectrl set esprodqty=esprodqty-"+1+" where esrefid='"+prodrefid+"' and estoken='"+token+"'";
				}else if(action.equalsIgnoreCase("plus")){
					sql="update estimatesalectrl set esprodqty=esprodqty+"+1+" where esrefid='"+prodrefid+"' and estoken='"+token+"'";
				}else{
					sql="update estimatesalectrl set esprodqty="+action+" where esrefid='"+prodrefid+"' and estoken='"+token+"'";
				}
				  ps=con.prepareStatement(sql);			 
				  int k=ps.executeUpdate();
				  if(k>0) status=true;
				}
			catch (Exception e) {
				log.info("Error in Clientmaster_ACT method updateSalesQtyOfProduct:\n"+e.getMessage());
			}
			finally{
				try{
					if(ps!=null) {ps.close();}
					if(con!=null) {con.close();}
					if(rs!=null) {rs.close();}
				}catch(SQLException sqle){
					sqle.printStackTrace();
					log.info("Error Closing SQL Objects updateSalesQtyOfProduct:\n"+sqle.getMessage());
				}
			}	
			return status;
		}
	
	//updating updatePriceOfProduct
	public static boolean updateQtyOfProduct(String prodvirtualid,String action,String token,String addedby) {
		boolean status=false;
		PreparedStatement ps = null;	
		ResultSet rs=null;
		String sql="NA";
		Connection con = DbCon.getCon("","","");
		try{		 
			if(action.equalsIgnoreCase("minus"))	{
				sql="update salesproductvirtual set spvqty=spvqty-"+1+" where spvvirtualid='"+prodvirtualid+"' and spvtokenno='"+token+"' and spvaddedby='"+addedby+"'";
			}else if(action.equalsIgnoreCase("plus")){
				sql="update salesproductvirtual set spvqty=spvqty+"+1+" where spvvirtualid='"+prodvirtualid+"' and spvtokenno='"+token+"' and spvaddedby='"+addedby+"'";
			}
			  ps=con.prepareStatement(sql);			 
			  int k=ps.executeUpdate();
			  if(k>0) status=true;
			}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method updateQtyOfProduct:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateQtyOfProduct:\n"+sqle.getMessage());
			}
		}	
		return status;
	}
	//updating updatePriceOfProduct
		public static boolean updatePriceOfSalesProduct(String price,String pricerefid,String cgstprice,String sgstprice,String igstprice,String token) {
			boolean status=false;
			PreparedStatement ps = null;	
			ResultSet rs=null;
			Connection con = DbCon.getCon("","","");
			try{		    
				double total=Double.parseDouble(price)+Double.parseDouble(cgstprice)+Double.parseDouble(sgstprice)+Double.parseDouble(igstprice);
				
				  ps=con.prepareStatement("update salesproductprice set spprice=?,spcgstprice=?,spsgstprice=?,spigstprice=?,sptotalprice=? where sprefid=? and sptokenno=?");
				  ps.setString(1, price);
				  ps.setString(2, cgstprice);
				  ps.setString(3, sgstprice);
				  ps.setString(4, igstprice);
				  ps.setDouble(5, Math.round(total));
				  ps.setString(6, pricerefid);
				  ps.setString(7, token);
				  int k=ps.executeUpdate();
				  if(k>0) status=true;
				}
			catch (Exception e) {
				log.info("Error in Clientmaster_ACT method updatePriceOfSalesProduct:\n"+e.getMessage());
			}
			finally{
				try{
					if(ps!=null) {ps.close();}
					if(con!=null) {con.close();}
					if(rs!=null) {rs.close();}
				}catch(SQLException sqle){
					sqle.printStackTrace();
					log.info("Error Closing SQL Objects updatePriceOfSalesProduct:\n"+sqle.getMessage());
				}
			}	
			return status;
		}
	//updating updatePriceOfProduct
	public static boolean updatePriceOfProduct(String price,String vrefid,String token) {
		boolean status=false;
		PreparedStatement ps = null;	
		ResultSet rs=null;
		Connection con = DbCon.getCon("","","");
		try{		    
			  ps=con.prepareStatement("update salesproductvirtual set spvprice=?,spvtotalprice=? where spvrefid=? and spvtokenno=?");
			  ps.setString(1, price);
			  ps.setString(2, price);
			  ps.setString(3, vrefid);
			  ps.setString(4, token);
			  int k=ps.executeUpdate();
			  if(k>0) status=true;
			}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method updatePriceOfProduct:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updatePriceOfProduct:\n"+sqle.getMessage());
			}
		}	
		return status;
	}
	
	//updating project status delivered
	public static void updateProjectStatusDate(String preguid,String today,String token) {
		
		PreparedStatement ps = null;	
		ResultSet rs=null;
		Connection con = DbCon.getCon("","","");
		try{		    
			  ps=con.prepareStatement("update hrmproject_reg set pregrunningstatus=?,pregdeliveredon=? where preguid=? and pregtokenno=?");
			  ps.setString(1, "Completed");
			  ps.setString(2, today);
			  ps.setString(3, preguid);
			  ps.setString(4, token);
			  ps.execute(); 
		 
			}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method updateProjectStatusDate:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateProjectStatusDate:\n"+sqle.getMessage());
			}
		}	
	}	
	//updating project status delivered
	public static void updateProjectStatusDelivered(String projectid,String token) {
		
		PreparedStatement ps = null;	
		ResultSet rs=null;
		Connection con = DbCon.getCon("","","");
		try{
		    
			  ps=con.prepareStatement("update hrmproject_reg set pregrunningstatus=? where preguid=? and pregtokenno=?");
			  ps.setString(1, "Delivered");
			  ps.setString(2, projectid);
			  ps.setString(3, token);
			  ps.execute(); 
		 
			}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method updateProjectStatusDelivered:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateProjectStatusDelivered:\n"+sqle.getMessage());
			}
		}	
	}
	
	//updating project status delivered
	public static void updateProjectStatusDelivered(String projectid,String cid,String token) {
		
		PreparedStatement ps = null;	
		ResultSet rs=null;
		Connection con = DbCon.getCon("","","");
		try{
		    
			  ps=con.prepareStatement("update hrmproject_reg set pregrunningstatus=? where preguid=? and pregtokenno=? and pregcuid=?");
			  ps.setString(1, "Delivered");
			  ps.setString(2, projectid);
			  ps.setString(3, token);
			  ps.setString(4, cid);
			  ps.execute(); 
		 
			}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method updateProjectStatusDelivered:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateProjectStatusDelivered:\n"+sqle.getMessage());
			}
		}	
	}
	
	//updating re-renewal date
	public static void updateReRenewalDate(String projectid,String token) {	
		PreparedStatement ps = null;	
		PreparedStatement ps1 = null;	
		ResultSet rs=null;
		Connection con = DbCon.getCon("","","");
		try{
		    ps=con.prepareStatement("select id,term,termtime,renewal_date from project_price where enq='NA' and preguid='"+projectid+"' and servicetype='Renewal' and tokenno='"+token+"' ");
		    rs=ps.executeQuery();
		  while(rs.next()){
			  String redate=getDate(rs.getString(4),rs.getString(2),rs.getString(3));
			  ps1=con.prepareStatement("update project_price set renewal_date='"+redate+"' where id='"+rs.getString(1)+"' and servicetype='Renewal' and tokenno='"+token+"'");
			   ps1.execute(); 
		  }
			}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method updateReRenewalDate:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}	
				if(ps1!=null) {ps1.close();}
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateReRenewalDate:\n"+sqle.getMessage());
			}
		}	
	}
	
	//getting project status
	public static String getProjectStatus(String projectid,String token) {
		
		PreparedStatement ps = null;	
		ResultSet rs=null;
		String data="NA";
		Connection con = DbCon.getCon("","","");
		try{
		    ps=con.prepareStatement("select pregrunningstatus from hrmproject_reg where preguid='"+projectid+"' and pregtokenno='"+token+"' ");
		    rs=ps.executeQuery();
		    if(rs.next())data=rs.getString(1);
		}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method getProjectStatus:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getProjectStatus:\n"+sqle.getMessage());
			}
		}
		return data;
	}
	
	//updating renewal date
	public static void updateRenewalDate(String projectid,String deliverydate,String token) {		
		PreparedStatement ps = null;	
		PreparedStatement ps1 = null;	
		ResultSet rs=null;
		Connection con = DbCon.getCon("","","");
		try{
		    ps=con.prepareStatement("select id,term,termtime from project_price where enq='NA' and preguid='"+projectid+"' and servicetype='Renewal' and tokenno='"+token+"' ");
		    rs=ps.executeQuery();
		  while(rs.next()){
			  String redate=getDate(deliverydate,rs.getString(2),rs.getString(3));
			  ps1=con.prepareStatement("update project_price set renewal_date='"+redate+"' where id='"+rs.getString(1)+"' and servicetype='Renewal' and tokenno='"+token+"'");
			   ps1.execute(); 
		  }
			}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method updateRenewalDate:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}	
				if(ps1!=null) {ps1.close();}
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateRenewalDate:\n"+sqle.getMessage());
			}
		}	
	}
	public static String[] getFolderDetails(String projectno,String token){
		PreparedStatement ps = null;			
		ResultSet rs=null;
		Connection con = DbCon.getCon("","","");   
		    String result[]=new String[2];
		try{
			ps=con.prepareStatement("select fsfrefid,fname from folder_master where fprojectno='"+projectno+"' and ftokenno='"+token+"' and ffcategory='folsubcategory'");
		    rs=ps.executeQuery();
		    if(rs.next()){
		    	result[0]=rs.getString(1);
		    	result[1]=rs.getString(2);
		    }
		}catch(Exception e){
			log.info("Error in Clientmaster_ACT method getFolderDetails:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}				
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getFolderDetails:\n"+sqle.getMessage());
			}
		}
		return result;
	}
	
	public static String getDate(String sdate,String term,String termtime){
		 int dyy=0;
		    int dmm=0;		    
		    String deliveryDate="NA";
		try{
			if(term.equalsIgnoreCase("Monthly")) dmm=Integer.parseInt(termtime);
			if(term.equalsIgnoreCase("Yearly")) dyy=Integer.parseInt(termtime);
			
			SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
		    Calendar c1 = Calendar.getInstance();
		    	
		    String x[]=sdate.split("-");
		    int syy=Integer.parseInt(x[2]);
		    int smm=Integer.parseInt(x[1]);
		    int sdd=Integer.parseInt(x[0]);
				    
			    c1.set((syy+dyy), (smm+dmm)-1 , sdd); 		    
			    deliveryDate=sdf.format(c1.getTime());
			
		}catch(Exception e){
			log.info("Error in Clientmaster_ACT method getDate:\n"+e.getMessage());
		}
		return deliveryDate;
	}
	//getting renewal amount	
		public static double getRenewalAmount(String clientid,String token) {
			PreparedStatement ps = null;		
			ResultSet rs=null;			
			double ramt=0;		
			Connection con = DbCon.getCon("","","");
			try{			
				StringBuffer sb=new StringBuffer("SELECT sum(pp.totalprice) FROM project_price pp join hrmproject_reg hr on hr.preguid=pp.preguid WHERE hr.pregcuid='"+clientid+"' and hr.pregtokenno='"+token+"' and pp.servicetype='Renewal' and hr.pregrunningstatus='Delivered' and pp.tokenno='"+token+"'");
//			System.out.println(sb);
				ps=con.prepareStatement(sb.toString());
				rs=ps.executeQuery();
				if(rs.next())ramt=rs.getDouble(1);
				}
			catch (Exception e) {
				log.info("Error in Clientmaster_ACT method getRenewalAmount:\n"+e.getMessage());
			}
			finally{
				try{
					if(ps!=null) {ps.close();}				
					if(con!=null) {con.close();}
					if(rs!=null) {rs.close();}
				}catch(SQLException sqle){
					sqle.printStackTrace();
					log.info("Error Closing SQL Objects getRenewalAmount:\n"+sqle.getMessage());
				}
			}
		return ramt;	
		}
	
	//getting renewal date	
	public static String getRenewalDate(String clientid,String token) {
		PreparedStatement ps = null;		
		ResultSet rs=null;			
		String rdate=null;		
		Connection con = DbCon.getCon("","","");
		try{			
			StringBuffer sb=new StringBuffer("SELECT pp.renewal_date FROM project_price pp join hrmproject_reg hr on hr.preguid=pp.preguid WHERE hr.pregcuid='"+clientid+"' and hr.pregtokenno='"+token+"' and hr.pregrunningstatus='Delivered' and pp.servicetype='Renewal' and pp.tokenno='"+token+"' order by CONCAT_WS('-', SUBSTRING(`renewal_date`, 7, 4), SUBSTRING(`renewal_date`, 4, 2), SUBSTRING(`renewal_date`, 1, 2)) limit 1");
//		System.out.println(sb);
			ps=con.prepareStatement(sb.toString());
			rs=ps.executeQuery();
			if(rs.next()){
				rdate=rs.getString(1);
			}
			}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method getRenewalDate:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}				
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getRenewalDate:\n"+sqle.getMessage());
			}
		}
	return rdate;	
	}
	/*getting project assign status*/
	public static boolean isAssignedTask(String uid,String taskid,String projectno,String token) {
		PreparedStatement ps = null;		
		ResultSet rs=null;			
		boolean status=false;
		
		Connection con = DbCon.getCon("","","");
		try{
			String task[]=taskid.split(",");
			StringBuffer sb=new StringBuffer("select aid from assigntask where aprojectid='"+projectno+"' and aassignedtoid='"+uid+"' and atokenno='"+token+"'");
			for(int i=0;i<task.length;i++){
				if(i==0)
				sb.append(" and (amilestoneid='"+task[i]+"'");
				else
					sb.append(" or amilestoneid='"+task[i]+"'");
				
			}
			sb.append(")");
		
			ps=con.prepareStatement(sb.toString());
			rs=ps.executeQuery();
			if(rs.next()){
				status=true;
			}
			}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method isAssignedTask:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}				
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects isAssignedTask:\n"+sqle.getMessage());
			}
		}
	return status;	
	}
	
	public static boolean isInvoiceGenerated(String invoiceType,String invoiceNo,String token) {
		PreparedStatement ps = null;		
		ResultSet rs=null;			
		boolean info=false;
		
		Connection con = DbCon.getCon("","","");
		try{
			StringBuffer sb=new StringBuffer("select id from manage_invoice where type='"+invoiceType+"' and ref_invoice='"+invoiceNo+"' and active_status=true and token='"+token+"'");
					
			ps=con.prepareStatement(sb.toString());
			rs=ps.executeQuery();
			if(rs.next()){
				info=true;
			}
			}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method sumGeneratedInvoice:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}				
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects sumGeneratedInvoice:\n"+sqle.getMessage());
			}
		}
	return info;	
	}
	
	/*deleting sub-folder and their files*/
	@SuppressWarnings("resource")
	public static void deleteSubFolder(String cid,String pregpuno,String token,String docmentpath) {
		PreparedStatement ps = null;		
		ResultSet rs=null;	
		Connection con = DbCon.getCon("","","");
		try{
			String frefno="NA";
			String sfrefid="NA";
			ps=con.prepareStatement("select frefid from folder_master where fclientid='"+cid+"' and ftokenno='"+token+"' and ffcategory='folcategory'");
			rs=ps.executeQuery();
			if(rs.next())frefno=rs.getString(1);				
			ps=con.prepareStatement("select fsfrefid from folder_master where frefid='"+frefno+"' and ftokenno='"+token+"' and fprojectno='"+pregpuno+"' and ffcategory='folsubcategory'");
			rs=ps.executeQuery();
			if(rs.next())sfrefid=rs.getString(1);
			ps=con.prepareStatement("select dmdocument_name from document_master where dmrefno='"+sfrefid+"' and dmtokenno='"+token+"' ");
			rs=ps.executeQuery();
			while(rs.next()){
				File file=new File(docmentpath+rs.getString(1));
				if(file.exists())file.delete();
			}
			ps=con.prepareStatement("delete from document_master where dmrefno='"+sfrefid+"' and dmtokenno='"+token+"'");
			ps.execute();
			ps=con.prepareStatement("delete from folder_master where frefid='"+frefno+"' and ftokenno='"+token+"' and fprojectno='"+pregpuno+"' and fsfrefid='"+sfrefid+"' and ffcategory='folsubcategory'");
			ps.execute();
//			ps=con.prepareStatement("delete from folder_permission where fp_frefid='"+frefno+"' and fptoken='"+token+"'");
//			ps.execute();	
		
		}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method deleteSubFolder:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}				
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects deleteSubFolder:\n"+sqle.getMessage());
			}
		}		
	}
	
	/*deleting project and their related tables*/
	@SuppressWarnings("resource")
	public static void deleteClientProject(String pid,String token,String pregpuno,String cid) {
		PreparedStatement ps = null;		
		ResultSet rs=null;			
		String followup=null;
		String mytask=null;
		Connection con = DbCon.getCon("","","");
		try{
			ps=con.prepareStatement("select pfuid from hrmproject_followup where pfupid='"+pid+"' and pftokenno='"+token+"'");
			rs=ps.executeQuery();
			if(rs.next()) followup=rs.getString(1);	
		
			ps=con.prepareStatement("select ptluid from projecttask_list where ptlpuid='"+pid+"' and ptltokenno='"+token+"'");
			rs=ps.executeQuery();
			if(rs.next()) mytask=rs.getString(1);	
			
			if(followup==null&&mytask==null){
				String clienaccid=null;
				ps=con.prepareStatement("select caid from client_accounts where cacid='"+cid+"' and catokenno='"+token+"'");
				rs=ps.executeQuery();
				if(rs.next()) clienaccid=rs.getString(1);	
				
				ps=con.prepareStatement("delete from project_milestone where preguid='"+pid+"' and tokenno='"+token+"'");
				ps.execute();
				ps=con.prepareStatement("delete from project_price where preguid='"+pid+"' and tokenno='"+token+"'");
				ps.execute();
				ps=con.prepareStatement("delete from hrmproject_reg where preguid='"+pid+"' and pregtokenno='"+token+"'");
				ps.execute();
				if(clienaccid!=null){
				ps=con.prepareStatement("delete from client_accounts_statement where accbmuid='"+clienaccid+"' and accprojectId='"+pregpuno+"' ");
				ps.execute();				
				}				
			}
			}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method deleteClientProject:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}				
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects deleteClientProject:\n"+sqle.getMessage());
			}
		}		
	}
	@SuppressWarnings("resource")
	public static void deleteDocument(String imgname,String pregno,String token) {
		PreparedStatement ps = null;		
		ResultSet rs=null;		
		String imgid=null;
		Connection con = DbCon.getCon("","","");
		try{
			ps=con.prepareStatement("select aid from assigntask where aimageurl='"+imgname+"'");
			rs=ps.executeQuery();
			if(rs.next()) imgid=rs.getString(1);	
			if(imgid==null){
				File f= new File("D:\\nwjavawrkspce\\itswshrm\\WebContent\\documents\\"+imgname); 
				f.delete();
			}
			ps=con.prepareStatement("select frefid from folder_master where fprojectno='"+pregno+"' and ftokenno='"+token+"'");
			rs=ps.executeQuery();
			if(rs.next()){
			ps=con.prepareStatement("delete from document_master where dmrefno='"+rs.getString(1)+"' and dmdocument_name='"+imgname+"' and dmtokenno='"+token+"'");
//			System.out.println("delete from document_master where dmrefno='"+rs.getString(1)+"' and dmdocument_name='"+imgname+"' and dmtokenno='"+token+"'");
			ps.execute();
			}
		}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method deleteDocument:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}				
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects deleteDocument:\n"+sqle.getMessage());
			}
		}
	}
	//getting all completed task of a project
		public static int getAllCompletedTask(String pno,String token) {
			PreparedStatement ps = null;		
			ResultSet rs=null;		
			int count=0;
			Connection con = DbCon.getCon("","","");
			try{
				ps=con.prepareStatement("select aid from assigntask where aprojectid='"+pno+"' and atokenno='"+token+"' and ataskstatus='Completed' group by amilestoneid");
				rs=ps.executeQuery();
				while(rs.next()) {
					count++;	
				}
				
				}
			catch (Exception e) {
				log.info("Error in Clientmaster_ACT method getAllCompletedTask:\n"+e.getMessage());
			}
			finally{
				try{
					if(ps!=null) {ps.close();}				
					if(con!=null) {con.close();}
					if(rs!=null) {rs.close();}
				}catch(SQLException sqle){
					sqle.printStackTrace();
					log.info("Error Closing SQL Objects getAllCompletedTask:\n"+sqle.getMessage());
				}
			}
			return count;
		}
	//counting number of milestones
	public static int getAllMileStone(String pid,String token) {
		PreparedStatement ps = null;		
		ResultSet rs=null;		
		int count=0;
		Connection con = DbCon.getCon("","","");
		try{
			ps=con.prepareStatement("select count(preguid) from project_milestone where preguid='"+pid+"' and tokenno='"+token+"'");
			rs=ps.executeQuery();
			if(rs.next()) count=rs.getInt(1);	
			
			}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method getAllMileStone:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}				
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllMileStone:\n"+sqle.getMessage());
			}
		}
		return count;
	}
	
	public static String getProjectNo(String preguid,String token) {
		PreparedStatement ps = null;		
		ResultSet rs=null;		
		String data=null;
		Connection con = DbCon.getCon("","","");
		try{
			ps=con.prepareStatement("select pregpuno from hrmproject_reg where preguid='"+preguid+"' and pregtokenno='"+token+"'");
			rs=ps.executeQuery();
			if(rs.next()) data=rs.getString(1);	
			
			}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method getProjectNo:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}				
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getProjectNo:\n"+sqle.getMessage());
			}
		}
		return data;
	}
	
	public static String getProjectName(String pno,String token) {
		PreparedStatement ps = null;		
		ResultSet rs=null;		
		String name=null;
		Connection con = DbCon.getCon("","","");
		try{
			ps=con.prepareStatement("select pregpname from hrmproject_reg where pregpuno='"+pno+"' and pregtokenno='"+token+"'");
			rs=ps.executeQuery();
			if(rs.next()) name=rs.getString(1);	
			
			}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method getProjectName:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}				
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getProjectName:\n"+sqle.getMessage());
			}
		}
		return name;
	}
	public static String getDocument(String aid,String token) {
		PreparedStatement ps = null;		
		ResultSet rs=null;		
		String imgname=null;
		Connection con = DbCon.getCon("","","");
		try{
			ps=con.prepareStatement("select aimageurl from assigntask where aid='"+aid+"' and atokenno='"+token+"'");
			rs=ps.executeQuery();
			if(rs.next()) imgname=rs.getString(1);	
			
			}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method getDocument:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}				
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getDocument:\n"+sqle.getMessage());
			}
		}
		return imgname;
	}
	/*getting project assign status*/
	@SuppressWarnings("resource")
	public static void deleteAssignedTask(String aid,String taskid,String asstoid,String taskno,String token) {
		PreparedStatement ps = null;		
		ResultSet rs=null;			
		int count=0;
		Connection con = DbCon.getCon("","","");
		try{
			ps=con.prepareStatement("select count(aid) from assigntask where ataskid='"+taskid+"' and aassignedtoid='"+asstoid+"' and atokenno='"+token+"'");
			rs=ps.executeQuery();
			if(rs.next()) count=Integer.parseInt(rs.getString(1));	
			if(count==1){
				ps=con.prepareStatement("delete from assigntask where aid='"+aid+"' and atokenno='"+token+"'");
				ps.execute();	
				ps=con.prepareStatement("delete from assignedtaskid where attaskno='"+taskno+"' and atassignedid='"+asstoid+"' and attokenno='"+token+"'");
				ps.execute();	
				ps=con.prepareStatement("select ptluid from projecttask_list where ptltuid='"+taskno+"' and ptltokenno='"+token+"'");
				rs=ps.executeQuery();
				if(rs.next()){
				ps=con.prepareStatement("delete from projecttask_status where ptstid='"+rs.getString(1)+"' and ptstokenno='"+token+"'");
				ps.execute();	
				ps=con.prepareStatement("delete from projecttask_list where ptltuid='"+taskno+"' and ptltokenno='"+token+"'");
				ps.execute();
				}
			}else{
				ps=con.prepareStatement("delete from assigntask where aid='"+aid+"' and atokenno='"+token+"'");
				ps.execute();
			}
			}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method deleteAssignedTask:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}				
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects deleteAssignedTask:\n"+sqle.getMessage());
			}
		}
		
	}
	
	
	/*getting project assign status*/
	public static String getTaskNumber(String id,String token) {
		PreparedStatement ps = null;		
		ResultSet rs=null;			
		String result=null;
		Connection con = DbCon.getCon("","","");
		try{
			ps=con.prepareStatement("select ptltuid from projecttask_list where ptluid='"+id+"' and ptltokenno='"+token+"'");
			rs=ps.executeQuery();
			if(rs.next()) result=rs.getString(1);			
			}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method getTaskNumber:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}				
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getTaskNumber:\n"+sqle.getMessage());
			}
		}	
		return result;
	}
	
	/*getting project assign status*/
	public static boolean getAssignedStatus(String projectid,String token) {
		PreparedStatement ps = null;		
		ResultSet rs=null;		
		boolean status=false;
		String pno=null;
		Connection con = DbCon.getCon("","","");
		try{
			ps=con.prepareStatement("select aprojectid from assigntask where aprojectid='"+projectid+"' and atokenno='"+token+"'");
			rs=ps.executeQuery();
			if(rs.next()){ 
				pno=rs.getString(1);	
			if(pno.equalsIgnoreCase(projectid))	
				status=true;		
			}
		}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method getAssignedStatus:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}				
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAssignedStatus:\n"+sqle.getMessage());
			}
		}	
		return status;
	}
	
	/*getting product type*/
	@SuppressWarnings("resource")
	public static String[] getNameTask(String assid,String taskid) {
		PreparedStatement ps = null;		
		ResultSet rs=null;		
		String result[]=new String[2];
		Connection con = DbCon.getCon("","","");
		try{
			ps=con.prepareStatement("select uaname from user_account where uaid='"+assid+"'");
			rs=ps.executeQuery();
			if(rs.next())result[0]=rs.getString(1);			
				
			ps=con.prepareStatement("select worktype from project_milestone where id='"+taskid+"'");
			rs=ps.executeQuery();
			if(rs.next())result[1]=rs.getString(1);	
		}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method getNameTask:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}				
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getNameTask:\n"+sqle.getMessage());
			}
		}	
		return result;
	}
	
	/*getting product type*/
	public static String[][] getAssignTo(String prno,String token) {
		PreparedStatement ps = null;		
		ResultSet rs=null;
		PreparedStatement ps1 = null;		
		ResultSet rs1=null;
		String result[][]=null;
		Connection con = DbCon.getCon("","","");
		try{
			ps=con.prepareStatement("select aassignedtoid from assigntask where aprojectid='"+prno+"' and atokenno='"+token+"' and astatus='1' and ataskstatus!='Completed' group by aassignedtoid order by aid");
			rs=ps.executeQuery();
			rs.last();
			int row=rs.getRow();
			rs.beforeFirst();			
			result=new String[row][1];
			int rr=0;
			while(rs!=null && rs.next()){
				ps1=con.prepareStatement("select uaname from user_account where uaid='"+rs.getString(1)+"' and uavalidtokenno='"+token+"'");
				rs1=ps1.executeQuery();
				if(rs1.next()){
					result[rr][0]=rs1.getString(1);
					rr++;
				}
			}		
			
		}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method getAssignTo:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(ps1!=null) {ps1.close();}
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
				if(rs1!=null) {rs1.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAssignTo:\n"+sqle.getMessage());
			}
		}	
		return result;
	}
	
	/*getting product type*/
	@SuppressWarnings("resource")
	public static String getProductBuildingTime(String name,String uid,String token) {
		PreparedStatement ps = null;		
		ResultSet rs=null;
		String pname=null;
		String btime="0:0:0:0";
		Connection con = DbCon.getCon("","","");
		try{
			ps=con.prepareStatement("select pregtype,pregbuildingtime from hrmproject_reg where preguid='"+uid+"' and pregtokenno='"+token+"'");
			rs=ps.executeQuery();
			if(rs.next()) {
				pname=rs.getString(1);			
				btime=rs.getString(2);	
			}
			if(!pname.equalsIgnoreCase(name)){
				ps=con.prepareStatement("select pbuldingtime from product_master where pname='"+name+"' and ptokenno='"+token+"'");
				rs=ps.executeQuery();
				if(rs.next()) btime=rs.getString(1);
			}
		}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method getProductBuildingTime:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}				
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getProductBuildingTime:\n"+sqle.getMessage());
			}
		}	
		return btime;
	}
	
	/*getting product type*/
	public static String[] getTaskId(String pid,String token) {
		PreparedStatement ps = null;		
		ResultSet rs=null;
		String result[]=new String[2];
		Connection con = DbCon.getCon("","","");
		try{
			ps=con.prepareStatement("select ptluid,ptltuid from projecttask_list where ptlto='"+pid+"' and ptltokenno='"+token+"'");
			rs=ps.executeQuery();
			if(rs.next()){
				result[0]=rs.getString(1);	
				result[1]=rs.getString(2);		
			}
			
		}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method getTaskId:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}				
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getTaskId:\n"+sqle.getMessage());
			}
		}	
		return result;
	}
	
	/*getting product type*/
	public static String getProjectType(String uid,String token) {
		PreparedStatement ps = null;		
		ResultSet rs=null;
		String result="NA";
		Connection con = DbCon.getCon("","","");
		try{
			ps=con.prepareStatement("select pregtype from hrmproject_reg where preguid='"+uid+"' and pregtokenno='"+token+"'");
			rs=ps.executeQuery();
			if(rs.next()) result=rs.getString(1);			
			
		}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method getProjectType:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}				
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getProjectType:\n"+sqle);
			}
		}	
		return result;
	}
	
	public static void updateBillGenerate(String refid,String priceid,String invoice,String token,String category,String billrefid,String addeduser,String preguid) {
		PreparedStatement ps = null;		
		ResultSet rs=null;				
		Connection con = DbCon.getCon("","","");		
		
		try{
			
			ps = con.prepareStatement("insert into clientbillingmapping(cbmrefid,cbmppid,cbmbillno,cbmtoken,cbmcategory,cbmbillrefid,cbmstatus,cbmaddedby,cbmpreguid) values(?,?,?,?,?,?,?,?,?)");
			ps.setString(1,refid );
			ps.setString(2,priceid );
			ps.setString(3,invoice );
			ps.setString(4,token );
			ps.setString(5,category );
			ps.setString(6,billrefid );
			ps.setString(7,"1");
			ps.setString(8,addeduser );
			ps.setString(9,preguid );
			ps.execute();	
			
		}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method updateBillGenerate:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}						
				if(rs!=null) {rs.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateBillGenerate:\n"+sqle);
			}
		}
		
	}
	
	//updating account' debited balance
	@SuppressWarnings("resource")
	public static void updateAccountStatement(String id,String pid,String token,String pregpname) {
		PreparedStatement ps = null;		
		ResultSet rs=null;				
		Connection con = DbCon.getCon("","","");
		String total=null;
		double balance=0;
		double debit=0;
		try{
			String query = "select sum(totalprice) from project_price where preguid='"+id+"' and tokenno='"+token+"' and enq='NA'";
			ps = con.prepareStatement(query);
			rs=ps.executeQuery();
			if(rs.next()) total=rs.getString(1);
			if(total==null) total="0";
			ps = con.prepareStatement("select accbrbalance,accbdebit from client_accounts_statement where accprojectId='"+pid+"'");
			rs=ps.executeQuery();
			if(rs.next()) {
				balance=Double.parseDouble(rs.getString(1));
				debit=Double.parseDouble(rs.getString(2));
			}
			String remarks=pid+"#"+pregpname;
			balance=(balance+debit)-Double.parseDouble(total);
			ps = con.prepareStatement("update client_accounts_statement set accbdebit=?,accbrbalance=?,accbdescription=? where accprojectId=?");
			ps.setString(1,total );
			ps.setDouble(2,balance );
			ps.setString(3,remarks );
			ps.setString(4,pid );
			ps.execute();			
		}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method updateAccountStatement:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}						
				if(rs!=null) {rs.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateAccountStatement:\n"+sqle.getMessage());
			}
		}		
	}
	
	public static void updateCashFlowStatus(String refid,String transtatus,String token) {
			PreparedStatement ps = null;		
			ResultSet rs=null;
			Connection con = DbCon.getCon("","","");
			
			try{
				String query = "update managetransactionctrl set mtincludeincashflow='"+transtatus+"' where  mtrefid='"+refid+"' and mttokenno='"+token+"'";
				ps = con.prepareStatement(query);
				ps.execute();
			}
			catch (Exception e) {
				log.info("Error in Clientmaster_ACT method updateCashFlowStatus:\n"+e.getMessage());
			}
			finally{
				try{
					if(ps!=null) {ps.close();}
					if(con!=null) {con.close();}
					if(rs!=null) {rs.close();}
				}catch(SQLException sqle){
					log.info("Error Closing SQL Objects updateCashFlowStatus:\n"+sqle.getMessage());
				}
			}
			
		}
	
	//updating product timeline 
		@SuppressWarnings("resource")
		public static void updateProjectTimeline(String pid,String token,String Enq) {
			PreparedStatement ps = null;		
			ResultSet rs=null;
			Connection con = DbCon.getCon("","","");
			int yy=0;
			int mm=0;
			int dd=0;
			int hh=0;
			
			try{
				String query = "select unittime,duration from project_milestone where status='1' and preguid='"+pid+"' and tokenno='"+token+"' and enq='"+Enq+"'";
				ps = con.prepareStatement(query);
				rs=ps.executeQuery();
				while(rs.next()){
					if(rs.getString(1).equalsIgnoreCase("Year")) yy+=Integer.parseInt(rs.getString(2));
					if(rs.getString(1).equalsIgnoreCase("Month")) mm+=Integer.parseInt(rs.getString(2));
					if(rs.getString(1).equalsIgnoreCase("Day")) dd+=Integer.parseInt(rs.getString(2));
					if(rs.getString(1).equalsIgnoreCase("Hour")) hh+=Integer.parseInt(rs.getString(2));
				}
				String time=yy+":"+mm+":"+dd+":"+hh;
				String sql="";
				if(Enq.equalsIgnoreCase("NA"))
					sql="update hrmproject_reg set pregbuildingtime='"+time+"' where preguid='"+pid+"' and pregtokenno='"+token+"'";
				else
					sql="update userenquiry set enqpro_build_time='"+time+"' where enqid='"+pid+"' and enqTokenNo='"+token+"'";
				ps = con.prepareStatement(sql);
				ps.execute();
			}
			catch (Exception e) {
				log.info("Error in Clientmaster_ACT method updateProjectTimeline:\n"+e.getMessage());
			}
			finally{
				try{
					if(ps!=null) {ps.close();}
					if(con!=null) {con.close();}
					if(rs!=null) {rs.close();}
				}catch(SQLException sqle){
					sqle.printStackTrace();
					log.info("Error Closing SQL Objects updateProjectTimeline:\n"+sqle.getMessage());
				}
			}
			
		}
	
		//updating project's delivery date
		@SuppressWarnings("resource")
		public static void updateDeliveryDate(String str_date,String pid,String uavalidtokenno) {
			PreparedStatement ps = null;	
			ResultSet rs=null;
			Connection con = DbCon.getCon("","","");
			String deliveryDate="";
			String delivery_time=null;
			try{		
				ps=con.prepareStatement("select pregbuildingtime from  hrmproject_reg where preguid='"+pid+"' and pregtokenno='"+uavalidtokenno+"'  ");
				rs=ps.executeQuery();
				if(rs.next()) delivery_time=rs.getString(1);
				
				SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
			    Calendar c1 = Calendar.getInstance();
			    
			    if(delivery_time!=null&&!delivery_time.equalsIgnoreCase("NA")){
			    	
			    String x[]=str_date.split("-");
			    int syy=Integer.parseInt(x[2]);
			    int smm=Integer.parseInt(x[1]);
			    int sdd=Integer.parseInt(x[0]);
			    
			    String y[]=delivery_time.split(":");
			    int dyy=Integer.parseInt(y[0]);
			    int dmm=Integer.parseInt(y[1]);
			    int ddd=Integer.parseInt(y[2]);
			    int dhh=Integer.parseInt(y[3]);
			    
			    if(dhh>7){
			    	int h=dhh/8;
			    	dhh=dhh-(h*8);
			    	ddd+=h;
			    }		    
			    c1.set((syy+dyy), (smm+dmm)-1 , (sdd+ddd)); 		    
			    deliveryDate=sdf.format(c1.getTime());
			    int sunday=TaskMaster_ACT.getSunday(str_date,deliveryDate);
			    		    
			    c1.set((syy+dyy), (smm+dmm)-1 , (sdd+ddd+sunday)); 		    
			    deliveryDate=sdf.format(c1.getTime());
			    
			    boolean flag=TaskMaster_ACT.isSunday(deliveryDate);
			    if(flag){
			    	c1.set((syy+dyy), (smm+dmm)-1 , (sdd+ddd+sunday+1)); 		    
				    deliveryDate=sdf.format(c1.getTime());
			    }
			    
			    String tt=null;
			    int time=9+dhh;
			    if(time>=12){
			    	int t=time-12;
			    	int z=t-10;
			    	if(z<0)
			    	tt="0"+t+":"+"30 pm";
			    	else
			    		tt=t+":"+"30 pm";	
			    }else{
			    	int z=time-10;
			    	if(z<0)
			    	tt="0"+time+":"+"30 am";
			    	else
			    		tt=time+":"+"30 am";
			    }
			    deliveryDate=deliveryDate+"  "+tt;
			    }else deliveryDate="Set Milestone !";		
			    ps=con.prepareStatement("update hrmproject_reg set pregddate='"+deliveryDate+"' where preguid='"+pid+"' and pregtokenno='"+uavalidtokenno+"'");
				ps.execute();
			    
			}
			catch (Exception e) {
				log.info("Error in Clientmaster_ACT method updateDeliveryDate:\n"+e.getMessage());
			}	
			finally{
				try{
					if(ps!=null) {ps.close();}
					if(con!=null) {con.close();}	
					if(rs!=null) {rs.close();}
				}catch(SQLException sqle){
					sqle.printStackTrace();
					log.info("Error Closing SQL Objects updateDeliveryDate:\n"+sqle.getMessage());
				}
			}	
		}			
		//inserting into virtual rice table
				@SuppressWarnings("resource")
				public static void addBillingPrice(String projectid,String itemid,String loginuID,String uavalidtokenno,String from,String clientid) {
					PreparedStatement ps = null;					
					ResultSet rs=null;
					Connection con = DbCon.getCon("","","");
					try{			
						String price="0";
						String item[]=itemid.split(",");
						String duedate="NA";
						if(projectid!=null||projectid!="NA"){
						if(!from.equalsIgnoreCase("amc")){
						String x[]=projectid.split("#");
						projectid=x[0];
						duedate=x[1];
						}else if(from.equalsIgnoreCase("amc")){
							duedate="00-00-0000";
						}}
						String query = "insert into virtual_project_price(vpriceid,vpreguid,vtokenno,vaddedby,vpricefrom,vclientid,vfinalamount,vduedate) values(?,?,?,?,?,?,?,?)";
						for(int i=0;i<item.length;i++){
							ps = con.prepareStatement("select totalprice from project_price where id='"+item[i] +"' and tokenno='"+uavalidtokenno+"'");			
							rs=ps.executeQuery();
							if(rs.next()) price=rs.getString(1);
						ps = con.prepareStatement(query);						
						ps.setString(1,item[i] );
						ps.setString(2,projectid);
						ps.setString(3,uavalidtokenno );
						ps.setString(4,loginuID );
						ps.setString(5,from );
						ps.setString(6,clientid );
						ps.setString(7,price );
						ps.setString(8,duedate );
						ps.execute();	
						}
					}
					catch (Exception e) {
						log.info("Error in Clientmaster_ACT method addBillingPrice:\n"+e.getMessage());
					}
					finally{
						try{
							if(rs!=null) {rs.close();}		
							if(ps!=null) {ps.close();}				
							if(con!=null) {con.close();}			
						}catch(SQLException sqle){
							sqle.printStackTrace();
							log.info("Error Closing SQL Objects addBillingPrice:\n"+sqle.getMessage());
						}
					}	
				}
public static void saveEstimateNotification(String estKey,String newsalesid,String loginuaid,String estremarks,String today,String token){
	PreparedStatement ps = null;	
	ResultSet rs=null;			
	Connection con = DbCon.getCon("","","");
	try{							
		String query = "insert into estimatesales_notification(enkey,ensalesno,endate,entoken,enaddedbyuid,enremarks) values(?,?,?,?,?,?)";
		ps = con.prepareStatement(query);						
		ps.setString(1,estKey );
		ps.setString(2,newsalesid );
		ps.setString(3,today );
		ps.setString(4,token );
		ps.setString(5,loginuaid );
		ps.setString(6,estremarks );
		ps.execute();	
		
	}
	catch (Exception e) {e.printStackTrace();
		log.info("Error in Clientmaster_ACT method saveEstimateNotification:\n"+e.getMessage());
	}
	finally{
		try{
			if(ps!=null) {ps.close();}
			if(rs!=null) {rs.close();}	
			if(con!=null) {con.close();}			
		}catch(SQLException sqle){
			sqle.printStackTrace();
			log.info("Error Closing SQL Objects saveEstimateNotification:\n"+sqle.getMessage());
		}
	}	
}
		//save bill 
		public static void generateBiling(String key,String billno,String clid,String type,double finalamount,double discount,String addeduser,String today,String token,String preguid,String duedate) {
			PreparedStatement ps = null;	
			ResultSet rs=null;			
			Connection con = DbCon.getCon("","","");
			try{							
				String query = "insert into hrmclient_billing(cbrefid,cbinvno,cbcuid,cbtype,cbamount,cbdiscount,cbfinalamount,addedby,cbstatus,cbdate,cbtokenno,cddueamount,cbprojectid,cbduedate) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
				ps = con.prepareStatement(query);						
				ps.setString(1,key );
				ps.setString(2,billno );
				ps.setString(3,clid );
				ps.setString(4,type );
				ps.setDouble(5,finalamount );		
				ps.setDouble(6,discount );
				ps.setDouble(7,(finalamount-discount));
				ps.setString(8,addeduser );
				ps.setString(9,"1" );
				ps.setString(10,today );
				ps.setString(11,token );
				ps.setDouble(12,(finalamount-discount) );
				ps.setString(13,preguid );
				ps.setString(14,duedate );
//				System.out.println(query);
				ps.execute();	
				
			}
			catch (Exception e) {
				log.info("Error in Clientmaster_ACT method generateBiling:\n"+e.getMessage());
			}
			finally{
				try{
					if(ps!=null) {ps.close();}
					if(rs!=null) {rs.close();}	
					if(con!=null) {con.close();}			
				}catch(SQLException sqle){
					sqle.printStackTrace();
					log.info("Error Closing SQL Objects generateBiling:\n"+sqle.getMessage());
				}
			}	
		}
				
		//createProjectFolder
		@SuppressWarnings("resource")
		public static void createProjectFolder(String pregpuno,String pregpname,String addeduser,String token,String cid) {
			PreparedStatement ps = null;	
			PreparedStatement ps1 = null;	
			ResultSet rs=null;			
			Connection con = DbCon.getCon("","","");
			String clientName="";
			try{
				String key =RandomStringUtils.random(30, true, true);				
				ps = con.prepareStatement("select cregname from hrmclient_reg where creguid='"+cid+"' and cregtokenno='"+token+"'");			
				rs=ps.executeQuery();
				if(rs.next())clientName=rs.getString(1);
				
				ps = con.prepareStatement("select fname,frefid,fclientid from folder_master where fname='"+clientName+"' and ftokenno='"+token+"' and ffcategory='folcategory'");			
				rs=ps.executeQuery();
				if(rs.next()){
					//insert sub-folder
					ps1 = con.prepareStatement("insert into folder_master(frefid,fname,fstatus,faddedby,ftokenno,fprojectno,fclientid,fsfrefid,ffcategory) values(?,?,?,?,?,?,?,?,?)");						
					ps1.setString(1,rs.getString(2) );
					ps1.setString(2,pregpuno );
					ps1.setString(3,"1" );
					ps1.setString(4,addeduser );
					ps1.setString(5,token );		
					ps1.setString(6,pregpuno);
					ps1.setString(7,rs.getString(3) );
					ps1.setString(8, key);
					ps1.setString(9, "folsubcategory");
					ps1.execute();	
				}else{
					//creating folder				
				String query = "insert into folder_master(frefid,fname,fstatus,faddedby,ftokenno,fprojectno,fclientid,ffcategory) values(?,?,?,?,?,?,?,?)";
				ps = con.prepareStatement(query);						
				ps.setString(1,key );
				ps.setString(2,clientName );
				ps.setString(3,"1" );
				ps.setString(4,addeduser );
				ps.setString(5,token );		
				ps.setString(6,pregpuno );
				ps.setString(7,cid );
				ps.setString(8,"folcategory" );
				ps.execute();	
				//creating sub-folder
				String key1 =RandomStringUtils.random(30, true, true);
				ps = con.prepareStatement("insert into folder_master(frefid,fname,fstatus,faddedby,ftokenno,fprojectno,fclientid,fsfrefid,ffcategory) values(?,?,?,?,?,?,?,?,?)");						
				ps.setString(1,key);
				ps.setString(2,pregpuno );
				ps.setString(3,"1" );
				ps.setString(4,addeduser );
				ps.setString(5,token );		
				ps.setString(6,pregpuno);
				ps.setString(7,cid );
				ps.setString(8, key1);
				ps.setString(9, "folsubcategory");
				ps.execute();	
				
				}
			}
			catch (Exception e) {
				log.info("Error in Clientmaster_ACT method createProjectFolder:\n"+e.getMessage());
			}
			finally{
				try{
					if(ps!=null) {ps.close();}
					if(ps1!=null) {ps1.close();}
					if(rs!=null) {rs.close();}	
					if(con!=null) {con.close();}			
				}catch(SQLException sqle){
					sqle.printStackTrace();
					log.info("Error Closing SQL Objects createProjectFolder:\n"+sqle.getMessage());
				}
			}	
		}
		
		public static boolean creditSalesAmountOfClient(String accountid,String description,double amount,String invoice,String today,String addedby) {
			PreparedStatement ps = null;	
			ResultSet rs=null;
			Connection con = DbCon.getCon("","","");
			boolean status=false;
			try{
				String query = "insert into client_accounts_statement(accbmuid,accbdescription,accbdate,accbdebit,accbcredit,accbaddedby,accbinvoiceno) values(?,?,?,?,?,?,?)";
				ps = con.prepareStatement(query);						
				ps.setString(1,accountid );
				ps.setString(2,description );
				ps.setString(3,today );
				ps.setString(4,"0" );
				ps.setDouble(5,amount);
				ps.setString(6, addedby);
				ps.setString(7, invoice);
				int k=ps.executeUpdate();
				if(k>0)status=true;
			}
			catch (Exception e) {
				log.info("Error in Clientmaster_ACT method creditSalesAmountOfClient:\n"+e.getMessage());
			}
			finally{
				try{
					if(ps!=null) {ps.close();}
					if(rs!=null) {rs.close();}	
					if(con!=null) {con.close();}			
				}catch(SQLException sqle){
					sqle.printStackTrace();
					log.info("Error Closing SQL Objects creditSalesAmountOfClient:\n"+sqle.getMessage());
				}
			}	
			return status;
		}
		
		public static boolean debitSalesAmountOfClient(String accountid,String description,double orderamount,String invoice,String today,String addedby) {
			PreparedStatement ps = null;	
			ResultSet rs=null;
			boolean flag=false;
			Connection con = DbCon.getCon("","","");
			try{
				String query = "insert into client_accounts_statement(accbmuid,accbdescription,accbdate,accbdebit,accbcredit,accbaddedby,accbinvoiceno) values(?,?,?,?,?,?,?)";
				ps = con.prepareStatement(query);						
				ps.setString(1,accountid );
				ps.setString(2,description );
				ps.setString(3,today );
				ps.setDouble(4,orderamount );
				ps.setString(5,"0");
				ps.setString(6, addedby);
				ps.setString(7, invoice);
				int k=ps.executeUpdate();	
				if(k>0)flag=true;
			}
			catch (Exception e) {
				log.info("Error in Clientmaster_ACT method debitSalesAmountOfClient:\n"+e.getMessage());
			}
			finally{
				try{
					if(ps!=null) {ps.close();}
					if(rs!=null) {rs.close();}	
					if(con!=null) {con.close();}			
				}catch(SQLException sqle){
					sqle.printStackTrace();
					log.info("Error Closing SQL Objects debitSalesAmountOfClient:\n"+sqle.getMessage());
				}
			}
			return flag;
		}
		@SuppressWarnings("resource")
		public static void debitBalance(String accbmuid,double price,String remarks,String date,String addedby,String invoice,String prjno) {
			PreparedStatement ps = null;	
			ResultSet rs=null;
			double balance=0;
			Connection con = DbCon.getCon("","","");
			try{
				ps = con.prepareStatement("select accbrbalance from client_accounts_statement where accbmuid='"+accbmuid+"' order by accbuid desc limit 1");
				rs=ps.executeQuery();
				if(rs.next()) balance=rs.getDouble(1);
				double  rem_balance=balance-price;
				String query = "insert into client_accounts_statement(accbmuid,accbdescription,accbdate,accbdebit,accbcredit,accbrbalance,accbaddedby,accprojectId,accbinvoiceno) values(?,?,?,?,?,?,?,?,?)";
				ps = con.prepareStatement(query);						
				ps.setString(1,accbmuid );
				ps.setString(2,remarks );
				ps.setString(3,date );
				ps.setDouble(4,price );
				ps.setString(5,"0");
				ps.setDouble(6,rem_balance );
				ps.setString(7,addedby );
				ps.setString(8,prjno );
				ps.setString(9, invoice);
				ps.execute();			
			}
			catch (Exception e) {
				log.info("Error in Clientmaster_ACT method debitBalance:\n"+e.getMessage());
			}
			finally{
				try{
					if(ps!=null) {ps.close();}
					if(rs!=null) {rs.close();}	
					if(con!=null) {con.close();}			
				}catch(SQLException sqle){
					sqle.printStackTrace();
					log.info("Error Closing SQL Objects debitBalance:\n"+sqle.getMessage());
				}
			}	
		}
		
		@SuppressWarnings("resource")
		public static void creditBalance(String accbmuid,String price,String remarks,String date,String addedby,String invoice,String prjno) {
			PreparedStatement ps = null;	
			ResultSet rs=null;
			double balance=0;
			Connection con = DbCon.getCon("","","");
			try{
				ps = con.prepareStatement("select accbrbalance from client_accounts_statement where accbmuid='"+accbmuid+"' order by accbuid desc limit 1");
				rs=ps.executeQuery();
				if(rs.next()) balance=rs.getDouble(1);
				double  rem_balance=balance+Double.parseDouble(price);
				String query = "insert into client_accounts_statement(accbmuid,accbdescription,accbdate,accbdebit,accbcredit,accbrbalance,accbaddedby,accprojectId,accbinvoiceno) values(?,?,?,?,?,?,?,?,?)";
				ps = con.prepareStatement(query);						
				ps.setString(1,accbmuid );
				ps.setString(2,remarks );
				ps.setString(3,date );
				ps.setString(4,"0" );
				ps.setString(5,price);
				ps.setDouble(6,rem_balance );
				ps.setString(7,addedby );
				ps.setString(8,prjno );
				ps.setString(9, invoice);
				ps.execute();			
			}
			catch (Exception e) {
				log.info("Error in Clientmaster_ACT method creditBalance:\n"+e.getMessage());
			}
			finally{
				try{
					if(ps!=null) {ps.close();}
					if(rs!=null) {rs.close();}	
					if(con!=null) {con.close();}			
				}catch(SQLException sqle){
					sqle.printStackTrace();
					log.info("Error Closing SQL Objects creditBalance:\n"+sqle.getMessage());
				}
			}	
		}
		
		//inserting product price into client's account
		@SuppressWarnings("resource")
		public static void addPrice(String accbmuid,double price,String remarks,String date,String addedby,String pregpuno) {
			PreparedStatement ps = null;	
			ResultSet rs=null;
			double balance=0;
			Connection con = DbCon.getCon("","","");
			try{
				ps = con.prepareStatement("select accbrbalance from client_accounts_statement where accbmuid='"+accbmuid+"' order by accbuid desc limit 1");
				rs=ps.executeQuery();
				if(rs.next()) balance=Double.parseDouble(rs.getString(1));
				double  rem_balance=balance-price;
				String query = "insert into client_accounts_statement(accbmuid,accbdescription,accbdate,accbdebit,accbcredit,accbrbalance,accbaddedby,accprojectId) values(?,?,?,?,?,?,?,?)";
				ps = con.prepareStatement(query);						
				ps.setString(1,accbmuid );
				ps.setString(2,remarks );
				ps.setString(3,date );
				ps.setDouble(4,price );
				ps.setString(5,"0" );
				ps.setDouble(6,rem_balance );
				ps.setString(7,addedby );
				ps.setString(8,pregpuno );						
				ps.execute();			
			}
			catch (Exception e) {
				log.info("Error in Clientmaster_ACT method addPrice:\n"+e.getMessage());
			}
			finally{
				try{
					if(ps!=null) {ps.close();}
					if(rs!=null) {rs.close();}	
					if(con!=null) {con.close();}			
				}catch(SQLException sqle){
					sqle.printStackTrace();
					log.info("Error Closing SQL Objects addPrice:\n"+sqle.getMessage());
				}
			}	
		}
		
				//inserting assigntaskid
		@SuppressWarnings("resource")
		public static void saveAssignedId(String taskid,String pfuatoid,String status,String  loginid,String  token) {
			PreparedStatement ps = null;			
			Connection con = DbCon.getCon("","","");
			ResultSet rs=null;
			String attaskno=null;
			String atassignedid=null;
			try{
				ps = con.prepareStatement("SELECT attaskno,atassignedid from assignedtaskid where attaskno='"+taskid+"' and atassignedid='"+pfuatoid+"' and attokenno='"+token+"'");
				rs=ps.executeQuery();
				if(rs.next()){
					attaskno=rs.getString(1);
					atassignedid=rs.getString(2);
				}
				if(attaskno==null&&atassignedid==null){
				String query = "insert into assignedtaskid(attaskno,atassignedid,atstatus,ataddedby,attokenno)" +
						"values(?,?,?,?,?)";
				ps = con.prepareStatement(query);
				ps.setString(1,taskid );
				ps.setString(2,pfuatoid );
				ps.setString(3,status );
				ps.setString(4,loginid );
				ps.setString(5,token );	
				ps.execute();	
				}
			}
			catch (Exception e) {
				log.info("Error in Clientmaster_ACT method saveAssignedId:\n"+e.getMessage());
			}
			finally{
				try{
					if(ps!=null) {ps.close();}
					if(con!=null) {con.close();}			
					if(rs!=null) {rs.close();}			
				}catch(SQLException sqle){
					sqle.printStackTrace();
					log.info("Error Closing SQL Objects saveAssignedId:\n"+sqle.getMessage());
				}
			}	
		}
				
				//inserting assign task
		public static void assignTask(String taskid,String projectid,String task,String pfuatoid,String assdate,String pfuddate,String  imgurl,String  status,String  loginid,String  token,String remarks) {
			PreparedStatement ps = null;			
			Connection con = DbCon.getCon("","","");
			try{
				String query = "insert into assigntask(ataskid,aprojectid,amilestoneid,aassignedtoid,aassigndate,adeliverydate,aimageurl,astatus,aaddedby,atokenno,aremarks)" +
						"values(?,?,?,?,?,?,?,?,?,?,?)";
				ps = con.prepareStatement(query);
				ps.setString(1, taskid);
				ps.setString(2,projectid );
				ps.setString(3,task );
				ps.setString(4,pfuatoid );
				ps.setString(5, assdate);
				ps.setString(6, pfuddate);
				ps.setString(7,imgurl );
				ps.setString(8,status );
				ps.setString(9,loginid );
				ps.setString(10, token);
				ps.setString(11, remarks);
				ps.execute();			
			}
			catch (Exception e) {
				log.info("Error in assignTask method \n"+e.getMessage());
			}
			finally{
				try{
					if(ps!=null) {ps.close();}
					if(con!=null) {con.close();}			
				}catch(SQLException sqle){
					sqle.printStackTrace();
					log.info("Error Closing SQL Objects assignTask:\n"+sqle.getMessage());
				}
			}	
		}
				
	//getting product name and description 
		public static void addProjectMilestone(String pid,String work_type,String Unit_Time,String Duration,String SMSID,String EmailId,String uavalidtokenno,String loginuID,String dateTime,String enq) {
			PreparedStatement ps = null;			
			Connection con = DbCon.getCon("","","");
			try{
				String query = "insert into project_milestone(preguid,worktype,unittime,duration,smsid,emailid,addedby,status,	tokenno,addedon,enq)" +
						"values(?,?,?,?,?,?,?,?,?,?,?)";
				ps = con.prepareStatement(query);
				ps.setString(1,pid );
				ps.setString(2, work_type);
				ps.setString(3,Unit_Time );
				ps.setString(4,Duration );
				ps.setString(5, SMSID);
				ps.setString(6,EmailId );
				ps.setString(7, loginuID);
				ps.setString(8,"1" );
				ps.setString(9,uavalidtokenno );
				ps.setString(10,dateTime );
				ps.setString(11,enq );
				ps.execute();			
			}
			catch (Exception e) {
				log.info("Error in addProjectMilestone method \n"+e.getMessage());
			}
			finally{
				try{
					if(ps!=null) {ps.close();}
					if(con!=null) {con.close();}			
				}catch(SQLException sqle){
					sqle.printStackTrace();
					log.info("Error Closing SQL Objects addProjectMilestone:\n"+sqle);
				}
			}	
		}
	
	//inserting product's price
		public static void addProductPrice(String pid,String price_type,String Price,String Service_Type,String Term_Status,String Term_Time,String GST_Status,String Gst_Percent,String Gst_Price,String Total_Price,String uavalidtokenno,String loginuID,String dateTime,String enq ) {
			PreparedStatement ps = null;		
			Connection con = DbCon.getCon("","","");
			try{
				String query = "insert into project_price(preguid,pricetype,price,servicetype,term,termtime,gststatus,gst,gstprice,totalprice,status,addedby,tokenno,addedon,enq,penqsale) " +
						"values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
				ps = con.prepareStatement(query);
				ps.setString(1,pid );
				ps.setString(2,price_type );
				ps.setString(3,Price );
				ps.setString(4,Service_Type );
				ps.setString(5,Term_Status );
				ps.setString(6,Term_Time );
				ps.setString(7, GST_Status);
				ps.setString(8,Gst_Percent );
				ps.setString(9, Gst_Price);
				ps.setString(10,Total_Price );
				ps.setString(11, "1");
				ps.setString(12, loginuID);
				ps.setString(13,uavalidtokenno );
				ps.setString(14, dateTime);
				ps.setString(15, enq);
				ps.setString(16, "1");
				
				ps.execute();			
			}
			catch (Exception e) {
				log.info("Error in addProductPrice method \n"+e.getMessage());
			}
			finally{
				try{
					if(ps!=null) {ps.close();}
					if(con!=null) {con.close();}
				}catch(SQLException sqle){
					sqle.printStackTrace();
					log.info("Error Closing SQL Objects addProductPrice:\n"+sqle);
				}
			}
			
		}
		//getting client's name by id	
		@SuppressWarnings("resource")
		public static String[] getBillingDetails(String projectid,String token) {
			PreparedStatement ps = null;
			String result[] =new String[2];
			ResultSet rs=null;
			Connection con = DbCon.getCon("","","");
			try{
				result[0]="No";
				ps = con.prepareStatement("select servicetype from project_price where preguid='"+projectid+"' and tokenno='"+token+"'");			
				rs=ps.executeQuery();
				while(rs.next()){
					if(rs.getString(1).equalsIgnoreCase("Renewal")){
						result[0]="Yes";
						break;
					}
				}
				String query = "select sum(totalprice) from project_price where preguid='"+projectid+"' and tokenno='"+token+"'";
				ps = con.prepareStatement(query);			
				rs=ps.executeQuery();
				if(rs.next())
					result[1]=rs.getString(1);
			}
			catch (Exception e) {
				log.info("Error in getBillingDetails method \n"+e.getMessage());
			}
			finally{
				try{
					if(ps!=null) {ps.close();}
					if(con!=null) {con.close();}
					if(rs!=null) rs.close();
				}catch(SQLException sqle){
					sqle.printStackTrace();
					log.info("Error Closing SQL Objects getBillingDetails:\n"+sqle);
				}
			}
			return result;
		}		
		
		
		//getting client's address  by refid	
		public static String[] getClientAddressByRefid(String crefid,String token) {
			PreparedStatement ps = null;
			String data[] =new String[3];
			ResultSet rs=null;
			Connection con = DbCon.getCon("","","");
			try{
				String query = "select cregaddress,cregstate,cregstatecode from hrmclient_reg where cregclientrefid='"+crefid+"' and cregtokenno='"+token+"'";
				ps = con.prepareStatement(query);	
				rs=ps.executeQuery();
				if(rs.next()) {
					data[0]=rs.getString(1);
					data[1]=rs.getString(2);
					data[2]=rs.getString(3);
				}
			}
			catch (Exception e) {
				log.info("Error in getClientAddress method \n"+e.getMessage());
			}
			finally{
				try{
					if(ps!=null) {ps.close();}
					if(con!=null) {con.close();}
					if(rs!=null) rs.close();
				}catch(SQLException sqle){
					sqle.printStackTrace();
					log.info("Error Closing SQL Objects getClientAddress:\n"+sqle.getMessage());
				}
			}
			return data;
		}		
		//getting client's address and location by id	
		public static String[] getClientAddress(String cid,String token) {
			PreparedStatement ps = null;
			String[] address =new String[2];
			ResultSet rs=null;
			Connection con = DbCon.getCon("","","");
			try{
				String query = "select cregaddress,creglocation from hrmclient_reg where creguid='"+cid+"' and cregtokenno='"+token+"'";
				ps = con.prepareStatement(query);	
				rs=ps.executeQuery();
				if(rs.next())
					address[0]=rs.getString(1);
					address[1]=rs.getString(2);
			}
			catch (Exception e) {
				log.info("Error in getClientAddress method \n"+e.getMessage());
			}
			finally{
				try{
					if(ps!=null) {ps.close();}
					if(con!=null) {con.close();}
					if(rs!=null) rs.close();
				}catch(SQLException sqle){
					sqle.printStackTrace();
					log.info("Error Closing SQL Objects getClientAddress:\n"+sqle.getMessage());
				}
			}
			return address;
		}		
		public static String getClientNo(String cid,String token) {
			PreparedStatement ps = null;
			String name = "NA";
			ResultSet rs=null;
			Connection con = DbCon.getCon("","","");
			try{
				String query = "select cregucid from hrmclient_reg where creguid='"+cid+"' and cregtokenno='"+token+"'";
//				System.out.println(query);
				ps = con.prepareStatement(query);			
				rs=ps.executeQuery();
				if(rs.next())
					name=rs.getString(1);
			}
			catch (Exception e) {
				log.info("Error in getClientNo method \n"+e.getMessage());
			}
			finally{
				try{
					if(ps!=null) {ps.close();}
					if(con!=null) {con.close();}
					if(rs!=null) rs.close();
				}catch(SQLException sqle){
					sqle.printStackTrace();
					log.info("Error Closing SQL Objects getClientNo:\n"+sqle.getMessage());
				}
			}
			return name;
		}	
		public static String getClientNameByNo(String clientNo,String token) {
			PreparedStatement ps = null;
			String name = "NA";
			ResultSet rs=null;
			Connection con = DbCon.getCon("","","");
			try{
				String query = "select cregname from hrmclient_reg where cregucid='"+clientNo+"' and cregtokenno='"+token+"'";
//				System.out.println(query);
				ps = con.prepareStatement(query);			
				rs=ps.executeQuery();
				if(rs.next())
					name=rs.getString(1);
			}
			catch (Exception e) {
				log.info("Error in getClientNameByNo method \n"+e.getMessage());
			}
			finally{
				try{
					if(ps!=null) {ps.close();}
					if(con!=null) {con.close();}
					if(rs!=null) rs.close();
				}catch(SQLException sqle){
					sqle.printStackTrace();
					log.info("Error Closing SQL Objects getClientNameByNo:\n"+sqle.getMessage());
				}
			}
			return name;
		}
		public static String getClientEmail(String cid,String token) {
			PreparedStatement ps = null;
			String name = "NA";
			ResultSet rs=null;
			Connection con = DbCon.getCon("","","");
			try{
				String query = "select cregcontemailid from hrmclient_reg where creguid='"+cid+"' and cregtokenno='"+token+"'";
//				System.out.println(query);
				ps = con.prepareStatement(query);			
				rs=ps.executeQuery();
				if(rs.next())
					name=rs.getString(1);
			}
			catch (Exception e) {
				log.info("Error in getClientName method \n"+e.getMessage());
			}
			finally{
				try{
					if(ps!=null) {ps.close();}
					if(con!=null) {con.close();}
					if(rs!=null) rs.close();
				}catch(SQLException sqle){
					sqle.printStackTrace();
					log.info("Error Closing SQL Objects getClientName:\n"+sqle.getMessage());
				}
			}
			return name;
		}		
	//getting client's name by id	
	public static String getClientName(String cid,String token) {
		PreparedStatement ps = null;
		String name = "NA";
		ResultSet rs=null;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "select cregname from hrmclient_reg where creguid='"+cid+"' and cregtokenno='"+token+"'";
//			System.out.println(query);
			ps = con.prepareStatement(query);			
			rs=ps.executeQuery();
			if(rs.next())
				name=rs.getString(1);
		}
		catch (Exception e) {
			log.info("Error in getClientName method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rs!=null) rs.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getClientName:\n"+sqle.getMessage());
			}
		}
		return name;
	}
	
	public static String getClientGST(String clientKey,String token) {
		PreparedStatement ps = null;
		String data = "NA";
		ResultSet rs=null;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "select creggstin from hrmclient_reg where cregclientrefid='"+clientKey+"' and cregtokenno='"+token+"'";
//			System.out.println(query);
			ps = con.prepareStatement(query);			
			rs=ps.executeQuery();
			if(rs.next())
				data=rs.getString(1);
		}
		catch (Exception e) {
			log.info("Error in getClientGST method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rs!=null) rs.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getClientGST:\n"+sqle.getMessage());
			}
		}
		return data;
	}
	
	public static String getClientGSTIN(String cid,String token) {
		PreparedStatement ps = null;
		String data = "NA";
		ResultSet rs=null;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "select creggstin from hrmclient_reg where creguid='"+cid+"' and cregtokenno='"+token+"'";
//			System.out.println(query);
			ps = con.prepareStatement(query);			
			rs=ps.executeQuery();
			if(rs.next())
				data=rs.getString(1);
		}
		catch (Exception e) {
			log.info("Error in getClientGSTIN method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rs!=null) rs.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getClientGSTIN:\n"+sqle.getMessage());
			}
		}
		return data;
	}
	//getting product's remarks   
	public static String getProductRemarks(String pname,String token) {
		PreparedStatement ps = null;
		String remarks = "NA";
		ResultSet rs=null;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "select pdescription,pid from product_master where pname='"+pname+"' and ptokenno='"+token+"'";
			ps = con.prepareStatement(query);			
			rs=ps.executeQuery();
			if(rs.next())
				remarks=rs.getString(1)+"#"+rs.getString(2);
		}
		catch (Exception e) {
			log.info("Error in getProductRemarks method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rs!=null) rs.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getProductRemarks:\n"+sqle.getMessage());
			}
		}
		return remarks;
	}
	//getting project id
	public static String getProjectId(String pregpuno,String pregcuid,String pregtype,String token) {
		PreparedStatement ps = null;
		String id = null;
		ResultSet rs=null;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "select preguid from hrmproject_reg where pregpuno='"+pregpuno+"'and pregcuid='"+pregcuid+"' and pregtype='"+pregtype+"' and pregtokenno='"+token+"'";
			ps = con.prepareStatement(query);			
			rs=ps.executeQuery();
			if(rs.next())
				id=rs.getString(1);
		}
		catch (Exception e) {
			log.info("Error in getProjectId method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rs!=null) rs.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getProjectId:\n"+sqle.getMessage());
			}
		}
		return id;
	}	
	/*saving project price*/
	public static void saveProjectMilestone(String pid,String id, String token,String addedby,String datetime) {
		PreparedStatement ps = null;
		PreparedStatement ps1 = null;		
		ResultSet rs=null;
		Connection con = DbCon.getCon("","","");
		try{
			ps=con.prepareStatement("select pm_worktype,pm_unittime,pm_duration,pm_smsid,pm_emailid,pmsteps,pmprevworkpercent from product_milestone where pm_pid='"+pid+"' and pm_tokeno='"+token+"'");
			rs=ps.executeQuery();
			while(rs.next()){
				ps1=con.prepareStatement("insert into project_milestone(preguid,worktype,unittime,duration,smsid,emailid,status,tokenno,addedby,addedon,steps,prevworkpercent)" +
						"values(?,?,?,?,?,?,?,?,?,?,?,?)");
				ps1.setString(1,id );
				ps1.setString(2,rs.getString(1) );
				ps1.setString(3,rs.getString(2) );
				ps1.setString(4,rs.getString(3) );
				ps1.setString(5,rs.getString(4) );
				ps1.setString(6,rs.getString(5) );
				ps1.setString(7,"1" );
				ps1.setString(8,token );
				ps1.setString(9,addedby );
				ps1.setString(10,datetime );
				ps1.setString(11,rs.getString(6) );
				ps1.setString(12,rs.getString(7) );
				
				ps1.execute();	
			}
				
		}
		catch (Exception e) {
			log.info("Error in saveProjectMilestone method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(ps1!=null) {ps1.close();}
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects saveProjectMilestone:\n"+sqle.getMessage());
			}
		}		
	}
	/*getting total price of project*/
	public static double projectTotalPrice(String pid,String token) {
		PreparedStatement ps = null;		
		ResultSet rs=null;
		double total_price=0;
		Connection con = DbCon.getCon("","","");
		try{
			ps=con.prepareStatement("select sum(totalprice) from project_price where preguid='"+pid+"' and tokenno='"+token+"'");
			rs=ps.executeQuery();
			if(rs.next()) total_price=Double.parseDouble(rs.getString(1));			
		}
		catch (Exception e) {
			log.info("Error in projectTotalPrice method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}				
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects projectTotalPrice:\n"+sqle.getMessage());
			}
		}	
		return total_price;
	}
	
	/*getting total price of product*/
	public static double getTotalPrice(String pid,String token) {
		PreparedStatement ps = null;		
		ResultSet rs=null;
		double total_price=0;
		Connection con = DbCon.getCon("","","");
		try{
			ps=con.prepareStatement("select sum(pp_total_price) from product_price where pp_pid='"+pid+"' and pp_tokenno='"+token+"'");
			rs=ps.executeQuery();
			if(rs.next()) total_price=Double.parseDouble(rs.getString(1));			
		}
		catch (Exception e) {
			log.info("Error in getTotalPrice method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}				
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getTotalPrice:\n"+sqle.getMessage());
			}
		}	
		return total_price;
	}
	/*saving project price*/
	public static void saveProjectPrice(String pid,String id, String token,String addedby,String datetime) {
		PreparedStatement ps = null;
		PreparedStatement ps1 = null;		
		ResultSet rs=null;
		Connection con = DbCon.getCon("","","");
		try{
			ps=con.prepareStatement("select pp_pricetype,pp_price,pp_service_type,pp_term,pp_term_time,pp_gst_status,pp_gst,pp_gst_price,pp_total_price from product_price where pp_pid='"+pid+"' and pp_tokenno='"+token+"'");
			rs=ps.executeQuery();
			while(rs.next()){
				ps1=con.prepareStatement("insert into project_price(preguid,pricetype,price,servicetype,term,termtime,gststatus,gst,gstprice,totalprice,status,tokenno,addedby,addedon)" +
						"values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
				ps1.setString(1,id );
				ps1.setString(2,rs.getString(1) );
				ps1.setString(3,rs.getString(2) );
				ps1.setString(4,rs.getString(3) );
				ps1.setString(5,rs.getString(4) );
				ps1.setString(6,rs.getString(5) );
				ps1.setString(7,rs.getString(6) );
				ps1.setString(8,rs.getString(7) );
				ps1.setString(9,rs.getString(8) );
				ps1.setString(10,rs.getString(9) );
				ps1.setString(11,"1" );
				ps1.setString(12,token );
				ps1.setString(13,addedby );
				ps1.setString(14,datetime );
				ps1.execute();		
			}
			
		}
		catch (Exception e) {
			log.info("Error in saveProjectPrice method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(ps1!=null) {ps1.close();}
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects saveProjectPrice:\n"+sqle.getMessage());
			}
		}		
	}
	public static boolean updateSalesContactDetail(String id,String firstname,String lastname,String email,String email2,String workphone,String mobile,String token){
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "update contactboxctrl set cbname=?,cbemail1st=?,cbemail2nd=?,cbmobile1st=?,cbmobile2nd=? where cbid=? and cbtokenno=?";
					
			ps = con.prepareStatement(query);
			ps.setString(1,firstname+" "+lastname );
			ps.setString(2,email );
			ps.setString(3,email2 );
			ps.setString(4,workphone );
			ps.setString(5,mobile );
			ps.setString(6,id);
			ps.setString(7,token );
			
			int k=ps.executeUpdate();
			if(k>0)
			status = true;
		}
		catch (Exception e) {
			log.info("Error in updateSalesContactDetail method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateSalesContactDetail:\n"+sqle.getMessage());
			}
		}
		return status;
	}
	
	public static boolean updateSalesContactDetailByKey(String contactKey,String firstname,String lastname,String email,String email2,String workphone,String mobile,String token){
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "update contactboxctrl set cbname=?,cbemail1st=?,cbemail2nd=?,cbmobile1st=?,cbmobile2nd=? where cbcontactrefid=? and cbtokenno=?";
					
			ps = con.prepareStatement(query);
			ps.setString(1,firstname+" "+lastname );
			ps.setString(2,email );
			ps.setString(3,email2 );
			ps.setString(4,workphone );
			ps.setString(5,mobile );
			ps.setString(6,contactKey);
			ps.setString(7,token );
			
			int k=ps.executeUpdate();
			if(k>0)
			status = true;
		}
		catch (Exception e) {
			log.info("Error in updateSalesContactDetailByKey method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateSalesContactDetailByKey:\n"+sqle.getMessage());
			}
		}
		return status;
	}
	
	public static boolean updateContactDetails1(int contactId,String firstName,String lastName,String email_id1,
			String email_id2,String mobile1,String mobile2,String pan,String country,String city,String state,
			String stateCode,String address,String token,String addressType) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "update clientcontactbox set cccontactfirstname=?,cccontactlastname=?,"
					+ "ccemailfirst=?,ccemailsecond=?,ccworkphone=?,ccmobilephone=?,ccpan=?"
					+ ",ccaddresstype=?,cccountry=?,cccity=?,ccstate=?,ccstatecode=?,ccaddress=?"
					+ " where ccbid=? and cctokenno=?";
//			System.out.println(query+"#"+mobile1+"#"+mobile2);		
			ps = con.prepareStatement(query);
			ps.setString(1,firstName );
			ps.setString(2,lastName );
			ps.setString(3,email_id1 );
			ps.setString(4,email_id2 );
			ps.setString(5,mobile1 );
			ps.setString(6,mobile2 );
			ps.setString(7,pan);
			ps.setString(8,addressType );
			ps.setString(9,country );
			ps.setString(10,city );
			ps.setString(11,state );
			ps.setString(12,stateCode );
			ps.setString(13,address );
			ps.setInt(14,contactId );
			ps.setString(15,token );
			
			int k=ps.executeUpdate();
			if(k>0)
			status = true;
		}
		catch (Exception e) {
			log.info("Error in updateContactDetails method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateContactDetails:\n"+sqle.getMessage());
			}
		}
		return status;
	}
	
	public static boolean updateContactData(String compName,String clientkey,String contkey,
			String firstname,String lastname,String email,String email2,String workphone,
			String mobile,String city,String state,String addresstype,String address,
			String token,String country,String pan) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "update clientcontactbox set cccontactfirstname=?,cccontactlastname=?,"
					+ "ccemailfirst=?,ccemailsecond=?,ccworkphone=?,ccmobilephone=?,"
					+ "ccaddresstype=?,cccity=?,ccstate=?,ccaddress=?,cccompanyname=?,"
					+ "ccbclientrefid=?,cccountry=?,ccpan=? where ccbrefid=? and cctokenno=?";
					
			ps = con.prepareStatement(query);
			ps.setString(1,firstname );
			ps.setString(2,lastname );
			ps.setString(3,email );
			ps.setString(4,email2 );
			ps.setString(5,workphone );
			ps.setString(6,mobile );
			ps.setString(7,addresstype);
			ps.setString(8,city );
			ps.setString(9,state );
			ps.setString(10,address );
			ps.setString(11,compName );
			ps.setString(12,clientkey );
			ps.setString(13,country );
			ps.setString(14,pan );
			ps.setString(15,contkey );
			ps.setString(16,token );
			
			int k=ps.executeUpdate();
			if(k>0)
			status = true;
		}
		catch (Exception e) {
			log.info("Error in updateContactData method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateContactData:\n"+sqle.getMessage());
			}
		}
		return status;
	}
	
	public static String getContactWorkPhone(String contkey,String token) {
		PreparedStatement ps = null;
		String data = "NA";
		Connection con = DbCon.getCon("","","");
		ResultSet rs=null;
		try{
			String query = "select ccworkphone from clientcontactbox where ccbrefid=? and cctokenno=?";
					
			ps = con.prepareStatement(query);
			ps.setString(1,contkey );
			ps.setString(2,token );
			rs=ps.executeQuery();
			if(rs!=null&&rs.next())data=rs.getString(1);
		}
		catch (Exception e) {e.printStackTrace();
			log.info("Error in getContactWorkPhone method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getContactWorkPhone:\n"+sqle.getMessage());
			}
		}
		return data;
	}
	
	/*For Client contact saved*/
	public static boolean updateContactDetail(String contkey,String firstname,String lastname,
			String email,String email2,String workphone,String mobile,String city,String state,
			String addresstype,String address,String token,String country,String pan,String stateCode) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "update clientcontactbox set cccontactfirstname=?,cccontactlastname=?,"
					+ "ccemailfirst=?,ccemailsecond=?,ccworkphone=?,ccmobilephone=?,"
					+ "ccaddresstype=?,cccity=?,ccstate=?,ccaddress=?,cccountry=?,ccpan=?,ccstatecode=? "
					+ "where ccbrefid=? and cctokenno=?";
					
			ps = con.prepareStatement(query);
			ps.setString(1,firstname );
			ps.setString(2,lastname );
			ps.setString(3,email );
			ps.setString(4,email2 );
			ps.setString(5,workphone );
			ps.setString(6,mobile );
			ps.setString(7,addresstype);
			ps.setString(8,city );
			ps.setString(9,state );
			ps.setString(10,address );
			ps.setString(11,country );
			ps.setString(12,pan );
			ps.setString(13,stateCode );
			ps.setString(14,contkey );
			ps.setString(15,token );
			
			int k=ps.executeUpdate();
			if(k>0)
			status = true;
		}
		catch (Exception e) {e.printStackTrace();
			log.info("Error in updateContactDetail method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateContactDetail:\n"+sqle.getMessage());
			}
		}
		return status;
	}
	
	public static boolean addContactToSalesBox(String contactkey,String name,String email,String email2,String workphone,String mobile,String token,String addeduser,String key){
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "insert into contactboxctrl(cbrefid,cbname,cbemail1st,cbemail2nd,cbmobile1st,cbmobile2nd,cbtokenno,cbaddedby,cbcontactrefid)" +
					"values(?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);			
			ps.setString(1,contactkey );
			ps.setString(2,name );
			ps.setString(3,email );
			ps.setString(4,email2 );
			ps.setString(5,workphone );
			ps.setString(6,mobile );
			ps.setString(7,token);
			ps.setString(8,addeduser );
			ps.setString(9,key );
			
			int k=ps.executeUpdate();
			if(k>0)
			status = true;
		}
		catch (Exception e) {
			log.info("Error in addContactToSalesBox method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects addContactToSalesBox:\n"+sqle.getMessage());
			}
		}
		return status;
	}
	
	/*For Client contact saved*/
	public static boolean saveContactDetail(String clientKey,String key,String compname,String firstname,String lastname,
			String email,String email2,String workphone,String mobile,String city,String state,String addresstype,
			String address,String addeduser,String token,String primaryStatus,String country,String pan,String stateCode,
			int super_user_id) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "insert into clientcontactbox(ccbrefid,cccompanyname,cccontactfirstname,cccontactlastname,"
					+ "ccemailfirst,ccemailsecond,ccworkphone,ccmobilephone,ccaddresstype,cccity,"
					+ "ccstate,ccaddress,ccstatus,ccaddedby,cctokenno,ccbclientrefid,ccprimarystatus,"
					+ "cccountry,ccpan,ccstatecode,super_user_id)" +
					"values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);			
			ps.setString(1,key );
			ps.setString(2,compname );
			ps.setString(3,firstname );
			ps.setString(4,lastname );
			ps.setString(5,email );
			ps.setString(6,email2 );
			ps.setString(7,workphone );
			ps.setString(8,mobile );
			ps.setString(9,addresstype);
			ps.setString(10,city );
			ps.setString(11,state );
			ps.setString(12,address );
			ps.setString(13,"1" );
			ps.setString(14,addeduser );
			ps.setString(15,token );
			ps.setString(16,clientKey );
			ps.setString(17,primaryStatus );
			ps.setString(18,country );
			ps.setString(19,pan );
			ps.setString(20,stateCode );
			ps.setInt(21,super_user_id );
			
			int k=ps.executeUpdate();
			if(k>0)
			status = true;
		}
		catch (Exception e) {
			e.printStackTrace();
			log.info("Error in saveContactDetail method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects saveContactDetail:\n"+sqle.getMessage());
			}
		}
		return status;
	}
	
	/*For ClientRegistation saved in hrmclient_reg*/
	public static boolean saveCompanyDetail(String cregucid,String cregname,String cregaddress,String creglocation,
			String cregpan, String creggstin,String addeduser, String token,String industry,String state,String country
			,String clientkey,String compAge,String stateCode,int superUserUaid) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "insert into hrmclient_reg(cregucid,cregname,cregaddress,creglocation,addedby,cregpan,"
					+ "creggstin,cregtokenno,cregstatus,cregindustry,cregstate,cregcountry,cregclientrefid,"
					+ "cregcompanyage,cregstatecode,super_user_uaid)" +
					"values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);			
			ps.setString(1,cregucid );
			ps.setString(2,cregname );
			ps.setString(3,cregaddress );
			ps.setString(4,creglocation );
			ps.setString(5,addeduser );
			ps.setString(6,cregpan );
			ps.setString(7,creggstin );
			ps.setString(8,token );
			ps.setString(9,"1" );
			ps.setString(10,industry );
			ps.setString(11,state );
			ps.setString(12,country );
			ps.setString(13, clientkey);
			ps.setString(14, compAge);
			ps.setString(15, stateCode);
			ps.setInt(16, superUserUaid);
			int k=ps.executeUpdate();
			if(k>0)
			status = true;
		}
		catch (Exception e) {
			log.info("Error in saveCompanyDetail method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects saveCompanyDetail:\n"+sqle.getMessage());
			}
		}
		return status;
	}
	
	/*For ClientRegistation saved in hrmclient_reg*/
	public static boolean saveClientDetail(String cregucid,String addeduser, String token,String clientkey,String contactname,String contactemail,String contactmobile) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String firstName="NA";
			String lastName="NA";
			firstName=contactname.substring(0,contactname.indexOf(" "));
			lastName=contactname.substring(contactname.indexOf(" ")+1);
			String query = "insert into hrmclient_reg(cregucid,addedby,cregtokenno,cregstatus,cregclientrefid,cregemailid,cregcontemailid,cregcontmobile,cregcontfirstname,cregcontlastname)" +
					"values(?,?,?,?,?,?,?,?,?,?)";
//			System.out.println(query);
			ps = con.prepareStatement(query);			
			ps.setString(1,cregucid );			
			ps.setString(2,addeduser );			
			ps.setString(3,token );
			ps.setString(4,"1" );
			ps.setString(5,clientkey );
			ps.setString(6,contactemail );
			ps.setString(7,contactemail );
			ps.setString(8,contactmobile);
			ps.setString(9,firstName );
			ps.setString(10,lastName );
			
			int k=ps.executeUpdate();
			if(k>0)status = true;
		}
		catch (Exception e) {
			e.printStackTrace();
			log.info("Error in saveClientDetail method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects saveClientDetail:\n"+sqle.getMessage());
			}
		}
		return status;
	}

	/*For ProjectRegistation saved in hrmproject_reg*/
	public static boolean saveProjectDetail(String pregpuno,String pregcuid,String pregtype,String pregpname,String pregsdate,String pregddate,String addeduser, String pregstatus, String pregremarks, String token,String serviceType,String paymentbased) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "insert into hrmproject_reg(pregpuno,pregcuid,pregtype,pregpname,pregsdate,pregddate,addedby,pregstatus,pregremarks, pregtokenno,pregservicetype,pregbasedonpayment)" +
					"values(?,?,?,?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1,pregpuno );
			ps.setString(2,pregcuid );
			ps.setString(3,pregtype );
			ps.setString(4,pregpname );
			ps.setString(5,pregsdate );
			ps.setString(6,pregddate );
			ps.setString(7,addeduser );
			ps.setString(8,pregstatus );
			ps.setString(9,pregremarks );
			ps.setString(10,token );
			ps.setString(11,serviceType );
			ps.setString(12,paymentbased );
			ps.executeUpdate();
			status = true;
		}
		catch (Exception e) {
			log.info("Error in saveProjectDetail method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects saveProjectDetail:\n"+sqle.getMessage());
			}
		}
		return status;
	}
	//getting unique tax 	
		public static String[][] getTaxDetails(String hsn,String token) {
			//Initialing variables
			Connection getacces_con = null;
			PreparedStatement stmnt=null;
			ResultSet rsGCD=null;
			String[][] newsdata = null;
			try{
				getacces_con=DbCon.getCon("","","");
				String query="SELECT mtrefid,mtsgstpercent,mtcgstpercent,mtigstpercent,mttaxnotes FROM managetaxctrl where mttoken='"+token+"' and mtstatus='1' and mthsncode='"+hsn+"'";
				stmnt=getacces_con.prepareStatement(query);
				rsGCD=stmnt.executeQuery();
				rsGCD.last();
				int row=rsGCD.getRow();
				rsGCD.beforeFirst();
				ResultSetMetaData rsmd=rsGCD.getMetaData();
				int col=rsmd.getColumnCount();
				newsdata=new String[row][col];
				int rr=0;
				while(rsGCD!=null && rsGCD.next()){
					for(int i=0;i<col;i++)
					{
						newsdata[rr][i]=rsGCD.getString(i+1);
					}
					rr++;
				}
			}catch(Exception e)
			{log.info("Error in getTaxDetails method \n"+e.getMessage());}
			finally{

				try{
					if(stmnt!=null) {stmnt.close();}
					if(getacces_con!=null) {getacces_con.close();}
					if(rsGCD!=null) rsGCD.close();
				}catch(SQLException sqle){
					sqle.printStackTrace();
					log.info("Error Closing SQL Objects getTaxDetails:\n"+sqle.getMessage());
				}
			}
			return newsdata;
		}

//getting all products getProjects	
	public static String[][] getProjects(String ptype,String token) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			String query="SELECT prefid,pname FROM product_master where ptokenno='"+token+"' and pstatus='1' and ptype='"+ptype+"' order by pname";
			stmnt=getacces_con.prepareStatement(query);
			rsGCD=stmnt.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];
			int rr=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++)
				{
					newsdata[rr][i]=rsGCD.getString(i+1);
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("Error in getProjects method \n"+e.getMessage());}
		finally{

			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getProjects:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	
	/*For edit-client jsp to fetch the data*/
	public static String[][] getClientByID(String uid) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			String query="SELECT creguid, cregucid, cregmob, cregname, cregemailid, cregaddress, creglocation, cregcontfirstname, cregcontemailid,cregcontmobile , cregcontrole,cregpan,creggstin,cregstatecode FROM hrmclient_reg where creguid='"+uid+"' ";
			stmnt=getacces_con.prepareStatement(query);
			rsGCD=stmnt.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];
			int rr=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++)
				{
					newsdata[rr][i]=rsGCD.getString(i+1);
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("Error in getClientByID method \n"+e.getMessage());}
		finally{

			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getClientByID:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	/*For updtae-client Ctrl to update the data*/
	public static boolean updateClient(String uid,String cregucid,String cregmob,String cregname,String cregemailid,String cregaddress,String creglocation,String cregcontname,String cregcontemailid,String cregcontmobile ,String cregcontrole, String cregpan, String creggstin, String cregstatecode) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE hrmclient_reg SET cregucid=?, cregmob=?,cregname=?,cregemailid=?,cregaddress=?,creglocation=?,cregcontname=?,cregcontemailid=?,cregcontmobile=?,cregcontrole=?,cregpan=?,creggstin=?,cregstatecode=? WHERE creguid=?";
			ps = con.prepareStatement(query);
			ps.setString(1,cregucid );
			ps.setString(2,cregmob );
			ps.setString(3,cregname );
			ps.setString(4,cregemailid );
			ps.setString(5,cregaddress );
			ps.setString(6,creglocation );
			ps.setString(7,cregcontname );
			ps.setString(8,cregcontemailid );
			ps.setString(9, cregcontmobile);
			ps.setString(10,cregcontrole );
			ps.setString(11,cregpan );
			ps.setString(12,creggstin );
			ps.setString(13,cregstatecode );
			ps.setString(14,uid );
			ps.executeUpdate();
			status = true;
		}catch (Exception e) {
			log.info("Error in updateClient method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateClient:\n"+sqle.getMessage());
			}
		}
		return status;
	}

	/*For updateBill Ctrl to update the data*/
	public static boolean updateBill(String uid,String cbcuid,String cbquotationvalue, String cbype, String cbdisvalue, String cbremark, String cbfvalue) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE hrmclient_billing SET cbcuid=?, cbype=?,cbquotationvalue=?,cbfvalue=?,cbdisvalue=?,cbremark=? WHERE cbuid=?";
			ps = con.prepareStatement(query);
			ps.setString(1,cbcuid );
			ps.setString(2,cbype );
			ps.setString(3,cbquotationvalue );
			ps.setString(4,cbfvalue );
			ps.setString(5,cbdisvalue );
			ps.setString(6,cbremark );
			ps.setString(7,uid );
			ps.executeUpdate();
			status = true;
		}catch (Exception e) {
			log.info("Error in updateBill method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateBill:\n"+sqle.getMessage());
			}
		}
		return status;
	}
//updating project's delivery date  ( id, ddate, token)
	public static void updateProjectDeliveryDate(String id,String ddate,String token) {
		PreparedStatement ps = null;		
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE hrmproject_reg SET pregddate=?  WHERE preguid=? and pregtokenno=?";
			ps = con.prepareStatement(query);
			ps.setString(1,ddate );
			ps.setString(2,id );
			ps.setString(3,token );
			ps.execute();
			
		}catch (Exception e) {
			log.info("Error in updateProjectDeliveryDate method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateProjectDeliveryDate:\n"+sqle.getMessage());
			}
		}		
	}
	/*For updateproject Ctrl to update the data*/
	public static boolean updateProject(String uid,String pregpuno,String pregpname,String pregtype, String pregcuid,String pregsdate,String pregddate, String pregstatus, String pregremarks,String serviceType,String paymentbased) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE hrmproject_reg SET pregcuid=?, pregpuno=?,pregpname=?,pregtype=?, pregcuid=?,pregsdate=?,pregddate=?,pregstatus=?,pregremarks=?,pregservicetype=?,pregbasedonpayment=? WHERE preguid=?";
			ps = con.prepareStatement(query);
			ps.setString(1,pregcuid );
			ps.setString(2,pregpuno );
			ps.setString(3,pregpname );
			ps.setString(4,pregtype );
			ps.setString(5,pregcuid );
			ps.setString(6,pregsdate );
			ps.setString(7,pregddate );
			ps.setString(8,pregstatus );
			ps.setString(9,pregremarks );
			ps.setString(10,serviceType );
			ps.setString(11, paymentbased);
			ps.setString(12,uid );
			ps.executeUpdate();
			status = true;
		}catch (Exception e) {
			log.info("Error in updateProject method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateProject:\n"+sqle.getMessage());
			}
		}
		return status;
	}

	/*For edit-project jsp to fetch the data*/
	public static String[][] getProjectByID(String uid,String token) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");

			String query="SELECT preguid,cregname,pregpname, pregtype, pregsdate, pregddate, pregpuno,pregcuid,pregstatus,pregremarks,pregbuildingtime,pregservicetype,pregrunningstatus,pregbasedonpayment FROM hrmproject_reg LEFT JOIN hrmclient_reg ON hrmclient_reg.creguid = hrmproject_reg.pregcuid where preguid='"+uid+"' and pregtokenno='"+token+"' ";
			stmnt=getacces_con.prepareStatement(query);
			rsGCD=stmnt.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];
			int rr=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++)
				{
					newsdata[rr][i]=rsGCD.getString(i+1);
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("Error in getProjectByID method \n"+e.getMessage());}
		finally{

			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getProjectByID:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}


	
	/*For manage-bill to view the data*/
	public static String[][] getAllAmc(String clientname,String limit, String token,String userroll) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			
			if(clientname==null || clientname.equalsIgnoreCase("null") || clientname.length() <= 0){ clientname ="NA";}

			StringBuffer VCQUERY=new StringBuffer("SELECT creguid,cregname,cregtokenno,cregstatus FROM hrmclient_reg where exists(select preguid from hrmproject_reg where pregcuid=creguid and pregtokenno=cregtokenno and pregrunningstatus='Delivered') and cregtokenno= '"+token+"'");
			if(!userroll.equalsIgnoreCase("super admin"))
			{
				VCQUERY.append(" and cregtokenno = '"+token+"'");
			}

			if(clientname!="NA")
			{
				VCQUERY.append(" and cregname = '"+clientname+"'");
			}
			VCQUERY.append(" order by creguid desc limit "+limit);
			stmnt=getacces_con.prepareStatement(VCQUERY.toString());
			rsGCD=stmnt.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];
			int rr=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++)
				{
					newsdata[rr][i]=rsGCD.getString(i+1);
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("Error in getAllAmc method \n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllAmc:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	
	/*For manage-bill to view the data*/
	public static String[][] getAllEstimate(String userRole,String loginuaid,String token,String estDoAction,
			String ClientName,String estimateNo,String dateRange,int page,int rows,String sort,
			String order,String contactName,String department) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		String fromDate="NA";
		String toDate="NA";
		try{
			
			if(!dateRange.equalsIgnoreCase("NA")){
				fromDate=dateRange.substring(0,10).trim();
				fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.substring(0,2);
				toDate=dateRange.substring(13).trim();
				toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2);
			}
			getacces_con=DbCon.getCon("","","");
			if(loginuaid==null||loginuaid.equalsIgnoreCase("NA")||loginuaid.length()<=0)loginuaid="NA";
			StringBuffer VCQUERY=new StringBuffer("SELECT e.esid,e.esrefid,e.essaleno,e.escompany,"
					+ "e.esprodtype,e.esprodname,e.esprodplan,e.esplanperiod,e.esplantime,e.esregdate,"
					+ "e.essoldbyid,e.escontactrefid,e.esclientrefid,e.esremarks,e.esstatus,e.esdiscount,e.sales_type "
					+ "FROM estimatesalectrl e INNER JOIN contactboxctrl c on e.escontactrefid=c.cbrefid "
					+ "where e.estoken= '"+token+"'");
			if(department.equalsIgnoreCase("Sales")||department.equalsIgnoreCase("Admin")) {
				if(!userRole.equalsIgnoreCase("NA")&&!loginuaid.equalsIgnoreCase("NA")&&userRole.equalsIgnoreCase("Executive")) VCQUERY.append(" and e.essoldbyid = '"+loginuaid+"' ");
				if(!userRole.equalsIgnoreCase("NA")&&!loginuaid.equalsIgnoreCase("NA")&&(userRole.equalsIgnoreCase("Assistant")||userRole.equalsIgnoreCase("Manager")))
					VCQUERY.append("and exists(select t.mtid from manageteamctrl t join manageteammemberctrl m on t.mtrefid=m.tmteamrefid where t.mtadminid='"+loginuaid+"' and m.tmuseruid=e.essoldbyid or e.essoldbyid='"+loginuaid+"') ");
			}else VCQUERY.append(" and e.essoldbyid = '"+loginuaid+"' ");
				
			if(!estDoAction.equalsIgnoreCase("NA")&&!estDoAction.equalsIgnoreCase("All")){
				if(estDoAction.equalsIgnoreCase("Invoiced")||estDoAction.equalsIgnoreCase("Draft")||estDoAction.equalsIgnoreCase("Cancelled"))VCQUERY.append(" and e.esstatus='"+estDoAction+"'");
				else if(estDoAction.equalsIgnoreCase("Pending for approval")){
					VCQUERY.append("and exists(select se.sid from salesestimatepayment se where se.sestsaleno=e.essaleno and se.stransactionstatus='2' and se.stokenno='"+token+"') ");
				}
			}else VCQUERY.append(" and e.esstatus!='Cancelled'");
			if(!ClientName.equalsIgnoreCase("NA"))VCQUERY.append("and e.escompany='"+ClientName+"' ");
			if(!contactName.equalsIgnoreCase("NA"))VCQUERY.append("and c.cbname='"+contactName+"' ");
			if(!estimateNo.equalsIgnoreCase("NA"))VCQUERY.append("and e.essaleno='"+estimateNo+"' ");
			if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA")){
				VCQUERY.append("and str_to_date(e.esregdate,'%d-%m-%Y')<='"+toDate+"' and str_to_date(e.esregdate,'%d-%m-%Y')>='"+fromDate+"' ");
			}
		
			if(sort.length()<=0)			
				VCQUERY.append("group by e.essaleno order by e.esid desc limit "+((page-1)*rows)+","+rows);
			else if(sort.equals("date"))VCQUERY.append("group by e.essaleno order by str_to_date(e.esregdate,'%d-%m-%Y') "+order+" limit "+((page-1)*rows)+","+rows);
			else if(sort.equals("estimate"))VCQUERY.append("group by e.essaleno order by cast(SUBSTRING(e.essaleno,6) as unsigned) "+order+" limit "+((page-1)*rows)+","+rows);
			else if(sort.equals("company"))VCQUERY.append("group by e.essaleno order by e.escompany "+order+" limit "+((page-1)*rows)+","+rows);
			else if(sort.equals("status"))VCQUERY.append("group by e.essaleno order by e.esstatus "+order+" limit "+((page-1)*rows)+","+rows);
			
//			System.out.println(VCQUERY);
			stmnt=getacces_con.prepareStatement(VCQUERY.toString());
			rsGCD=stmnt.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];
			int rr=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++)
				{
					newsdata[rr][i]=rsGCD.getString(i+1);
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("Error in getAllEstimate method \n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllEstimate:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	/*For manage-bill to view the data*/
	public static int countAllEstimate(String userRole,String loginuaid,String token,
			String estDoAction,String ClientName,String estimateNo,String dateRange,
			String contactName,String department) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		int newsdata = 0;
		String fromDate="NA";
		String toDate="NA";
		try{
			
			if(!dateRange.equalsIgnoreCase("NA")){
				fromDate=dateRange.substring(0,10).trim();
				fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.substring(0,2);
				toDate=dateRange.substring(13).trim();
				toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2);
			}
			getacces_con=DbCon.getCon("","","");
			if(loginuaid==null||loginuaid.equalsIgnoreCase("NA")||loginuaid.length()<=0)loginuaid="NA";
			StringBuffer VCQUERY=new StringBuffer("SELECT e.esid FROM estimatesalectrl e "
					+ "INNER JOIN contactboxctrl c on e.escontactrefid=c.cbrefid where e.estoken= '"+token+"'");
			if(department.equalsIgnoreCase("Sales")||department.equalsIgnoreCase("Admin")) {
				if(!userRole.equalsIgnoreCase("NA")&&!loginuaid.equalsIgnoreCase("NA")&&userRole.equalsIgnoreCase("Executive")) VCQUERY.append(" and e.essoldbyid = '"+loginuaid+"'");
				if(!userRole.equalsIgnoreCase("NA")&&!loginuaid.equalsIgnoreCase("NA")&&(userRole.equalsIgnoreCase("Assistant")||userRole.equalsIgnoreCase("Manager")))
					VCQUERY.append(" and exists(select t.mtid from manageteamctrl t join manageteammemberctrl m on t.mtrefid=m.tmteamrefid where t.mtadminid='"+loginuaid+"' and m.tmuseruid=e.essoldbyid or e.essoldbyid='"+loginuaid+"')");
			}else VCQUERY.append(" and e.essoldbyid = '"+loginuaid+"' ");
			if(!estDoAction.equalsIgnoreCase("NA")&&!estDoAction.equalsIgnoreCase("All")){
				if(estDoAction.equalsIgnoreCase("Invoiced")||estDoAction.equalsIgnoreCase("Draft")||estDoAction.equalsIgnoreCase("Cancelled"))VCQUERY.append(" and e.esstatus='"+estDoAction+"'");
				else if(estDoAction.equalsIgnoreCase("Pending for approval")){
					VCQUERY.append(" and exists(select se.sid from salesestimatepayment se where se.sestsaleno=e.essaleno and se.stransactionstatus='2' and se.stokenno='"+token+"')");
				}
			}else VCQUERY.append(" and e.esstatus!='Cancelled'");
				
			if(!ClientName.equalsIgnoreCase("NA"))VCQUERY.append(" and e.escompany='"+ClientName+"'");
			if(!contactName.equalsIgnoreCase("NA"))VCQUERY.append("and c.cbname='"+contactName+"' ");
			if(!estimateNo.equalsIgnoreCase("NA"))VCQUERY.append(" and e.essaleno='"+estimateNo+"'");
			if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA")){
				VCQUERY.append(" and str_to_date(e.esregdate,'%d-%m-%Y')<='"+toDate+"' and str_to_date(e.esregdate,'%d-%m-%Y')>='"+fromDate+"'");
			}
			VCQUERY.append(" group by e.essaleno");
//			System.out.println(VCQUERY);
			stmnt=getacces_con.prepareStatement(VCQUERY.toString());
			rsGCD=stmnt.executeQuery();
			
			while(rsGCD!=null && rsGCD.next()){
				newsdata+=1;
			}
		}catch(Exception e)
		{log.info("Error in countAllEstimate method \n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects countAllEstimate:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	public static int countAllPayment(String contactName,String unbill_no,String company,String dateRange,
			String token,String archiveFilter) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		int newsdata = 0;
		String fromDate="NA";
		String toDate="NA";
		try{
			
			if(!dateRange.equalsIgnoreCase("NA")){
				fromDate=dateRange.substring(0,10).trim();
				fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.substring(0,2);
				toDate=dateRange.substring(13).trim();
				toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2);
			}
			getacces_con=DbCon.getCon("","","");
			
			StringBuffer VCQUERY=new StringBuffer("SELECT s.sid FROM salesestimatepayment s "
					+ "INNER JOIN estimatesalectrl e on s.sestsaleno=e.essaleno "
					+ "INNER JOIN contactboxctrl cb on e.escontactrefid=cb.cbrefid "
					+ "where not exists(select id from manage_invoice where ref_invoice=s.sinvoiceno and type='TAX') and"
					+ " s.stransactionstatus='1' and s.stokenno= '"+token+"' and "
							+ "s.sinvoice_status='2' and sarchivestatus='"+archiveFilter+"'");
			if(!unbill_no.equalsIgnoreCase("NA"))VCQUERY.append(" and s.sunbill_no='"+unbill_no+"'");
			if(!company.equalsIgnoreCase("NA"))VCQUERY.append(" and e.escompany='"+company+"'");
			if(!contactName.equalsIgnoreCase("NA"))VCQUERY.append(" and cb.cbname='"+contactName+"'");
			if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA")){
				VCQUERY.append(" and str_to_date(s.saddeddate,'%d-%m-%Y')<='"+toDate+"' and str_to_date(s.saddeddate,'%d-%m-%Y')>='"+fromDate+"'");
			}
			VCQUERY.append(" group by s.sid");
			stmnt=getacces_con.prepareStatement(VCQUERY.toString());
			rsGCD=stmnt.executeQuery();
			
			while(rsGCD!=null && rsGCD.next()){
				newsdata+=1;
			}
		}catch(Exception e)
		{log.info("Error in countAllPayment method \n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects countAllPayment:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	
	public static int countAllInvoice(String contactName,String invoice,String company,
			String dateRange,String token,String b2bb2c) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		int newsdata = 0;
		String fromDate="NA";
		String toDate="NA";
		try{			
			getacces_con=DbCon.getCon("","","");
			if(!dateRange.equalsIgnoreCase("NA")){
				fromDate=dateRange.substring(0,10).trim();
				fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.substring(0,2);
				toDate=dateRange.substring(13).trim();
				toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2);
			}
			StringBuffer VCQUERY=new StringBuffer("SELECT count(id) from invoice where token='"+token+"' and status='1'");
			if(!invoice.equalsIgnoreCase("NA"))VCQUERY.append(" and invoice_no='"+invoice+"'");
			if(!b2bb2c.equalsIgnoreCase("NA")&&b2bb2c.equalsIgnoreCase("B2B"))VCQUERY.append(" and gstin!='NA'");
			if(!b2bb2c.equalsIgnoreCase("NA")&&b2bb2c.equalsIgnoreCase("B2C"))VCQUERY.append(" and gstin='NA'");
			if(!company.equalsIgnoreCase("NA"))VCQUERY.append(" and company='"+company+"'");
			if(!contactName.equalsIgnoreCase("NA"))VCQUERY.append(" and contact_name='"+contactName+"'");
			if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA")){
				VCQUERY.append(" and date<='"+toDate+"' and date>='"+fromDate+"'");
			}
			stmnt=getacces_con.prepareStatement(VCQUERY.toString());
			rsGCD=stmnt.executeQuery();
			
			if(rsGCD!=null && rsGCD.next()){
				newsdata=rsGCD.getInt(1);
			}
		}catch(Exception e)
		{log.info("Error in countAllInvoice method \n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects countAllInvoice:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] getAllInvoice(String contactName,String invoice,String company,
			String dateRange,String token,int page,int rows,String sort,String order,String b2bb2c) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		String fromDate="NA";
		String toDate="NA";
		try{
			if(!dateRange.equalsIgnoreCase("NA")){
				fromDate=dateRange.substring(0,10).trim();
				fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.substring(0,2);
				toDate=dateRange.substring(13).trim();
				toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2);
			}
			getacces_con=DbCon.getCon("","","");
			
			StringBuffer VCQUERY=new StringBuffer("SELECT date,uuid,invoice_no,service_name,total_amount,company,contact_uuid,status,unbill_no"
					+ " from invoice where token='"+token+"' and status='1'");
			if(!invoice.equalsIgnoreCase("NA"))VCQUERY.append(" and invoice_no='"+invoice+"'");
			if(!b2bb2c.equalsIgnoreCase("NA")&&b2bb2c.equalsIgnoreCase("B2B"))VCQUERY.append(" and gstin!='NA'");
			if(!b2bb2c.equalsIgnoreCase("NA")&&b2bb2c.equalsIgnoreCase("B2C"))VCQUERY.append(" and gstin='NA'");
			if(!company.equalsIgnoreCase("NA"))VCQUERY.append(" and company='"+company+"'");
			if(!contactName.equalsIgnoreCase("NA"))VCQUERY.append(" and contact_name='"+contactName+"'");
			if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA")){
				VCQUERY.append(" and date<='"+toDate+"' and date>='"+fromDate+"'");
			}

			if(sort.length()<=0)			
				VCQUERY.append(" order by id desc limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("date"))VCQUERY.append("order by date "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("id"))VCQUERY.append("order by id "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("invoice"))VCQUERY.append("order by invoice_no "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("service_name"))VCQUERY.append("order by service_name "+order+" limit "+((page-1)*rows)+","+rows);	
				else if(sort.equals("client"))VCQUERY.append("order by contact_name "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("company"))VCQUERY.append("order by company "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("amount"))VCQUERY.append("order by total_amount "+order+" limit "+((page-1)*rows)+","+rows);
			
			stmnt=getacces_con.prepareStatement(VCQUERY.toString());
			rsGCD=stmnt.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];
			int rr=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++)
				{
					newsdata[rr][i]=rsGCD.getString(i+1);
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("Error in getAllInvoice method \n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllInvoice:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] getAllPayment(String contactName,String unbill_no,String company,String dateRange,
			String token,int page,int rows,String sort,String order,String archiveFilter) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		String fromDate="NA";
		String toDate="NA";
		try{
			
			if(!dateRange.equalsIgnoreCase("NA")){
				fromDate=dateRange.substring(0,10).trim();
				fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.substring(0,2);
				toDate=dateRange.substring(13).trim();
				toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2);
			}
			getacces_con=DbCon.getCon("","","");
			
			StringBuffer VCQUERY=new StringBuffer("SELECT s.srefid,s.sunbill_no,s.sestsaleno,s.service_name,"
					+ "e.escontactrefid,e.esclientrefid,s.stransactionamount,e.escompany,s.sinvoiceno,"
					+ "e.esinvoicenotes,s.saddeddate,s.saddedbyuid FROM salesestimatepayment s INNER JOIN estimatesalectrl e on "
					+ "s.sestsaleno=e.essaleno INNER JOIN contactboxctrl cb on e.escontactrefid=cb.cbrefid "
					+ "where not exists(select id from manage_invoice where ref_invoice=s.sinvoiceno and type='TAX') and"
					+ " s.stransactionstatus='1' and s.stokenno= '"+token+"' "
							+ "and s.sinvoice_status='2' and sarchivestatus='"+archiveFilter+"'");
			if(!unbill_no.equalsIgnoreCase("NA"))VCQUERY.append(" and s.sunbill_no='"+unbill_no+"'");
			if(!company.equalsIgnoreCase("NA"))VCQUERY.append(" and e.escompany='"+company+"'");
			if(!contactName.equalsIgnoreCase("NA"))VCQUERY.append(" and cb.cbname='"+contactName+"'");
			if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA")){
				VCQUERY.append(" and str_to_date(s.saddeddate,'%d-%m-%Y')<='"+toDate+"' and str_to_date(s.saddeddate,'%d-%m-%Y')>='"+fromDate+"'");
			}
			VCQUERY.append(" group by s.sid");
			if(sort.length()<=0)			
				VCQUERY.append(" order by s.sid desc limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("id"))VCQUERY.append(" order by s.sid "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("date"))VCQUERY.append(" order by str_to_date(s.saddeddate,'%d-%m-%Y') "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("service_name"))VCQUERY.append(" order by s.service_name "+order+" limit "+((page-1)*rows)+","+rows);	
				else if(sort.equals("company"))VCQUERY.append(" order by e.escompany "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("txn_amount"))VCQUERY.append(" order by s.stransactionamount "+order+" limit "+((page-1)*rows)+","+rows);
			
			stmnt=getacces_con.prepareStatement(VCQUERY.toString());
			rsGCD=stmnt.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];
			int rr=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++)
				{
					newsdata[rr][i]=rsGCD.getString(i+1);
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("Error in getAllPayment method \n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllPayment:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] getAllEstimatePayment(String ClientName,String InvoiceNo,String dateRange,String doAction,
			String token,int page,int rows,String sort,String order,String contactName) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		String fromDate="NA";
		String toDate="NA";
		try{
			
			if(!dateRange.equalsIgnoreCase("NA")){
				fromDate=dateRange.substring(0,10).trim();
				fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.substring(0,2);
				toDate=dateRange.substring(13).trim();
				toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2);
			}
			getacces_con=DbCon.getCon("","","");
			
			StringBuffer VCQUERY=new StringBuffer("SELECT b.cbrefid,b.cbestimateno,b.cbinvoiceno,b.cbclientrefid,b.cbcompanyname,"
					+ "b.cbcontactrefid,b.cborderamount,b.cbpaidamount,b.cbdueamount,b.cbtransactionamount,"
					+ "b.cdnotificationcount,b.cbdate,b.cbduedate,b.cbnextduedate,b.cbinvoice_status,b.cbholdnotification,b.cbholdamount FROM hrmclient_billing b "
					+ "INNER JOIN contactboxctrl c on b.cbcontactrefid=c.cbrefid where b.cbtokenno= '"+token+"'");
			if(!ClientName.equalsIgnoreCase("NA"))VCQUERY.append(" and b.cbcompanyname='"+ClientName+"'");
			if(!contactName.equalsIgnoreCase("NA"))VCQUERY.append(" and c.cbname='"+contactName+"'");
			if(!InvoiceNo.equalsIgnoreCase("NA"))VCQUERY.append(" and b.cbinvoiceno='"+InvoiceNo+"'");
			if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA")){
				VCQUERY.append(" and str_to_date(b.cbdate,'%d-%m-%Y')<='"+toDate+"' and str_to_date(b.cbdate,'%d-%m-%Y')>='"+fromDate+"'");
			}
			if(!doAction.equalsIgnoreCase("NA")){
				if(doAction.equalsIgnoreCase("Paid"))VCQUERY.append(" and b.cbdueamount='0'");
				
				else if(doAction.equalsIgnoreCase("Current"))
					VCQUERY.append(" and exists(select m.msid from managesalesctrl m where m.msworkpercent!='100' and m.msestimateno=b.cbestimateno and m.mstoken='"+token+"')");
				
				else if(doAction.equalsIgnoreCase("Past due"))
					VCQUERY.append(" and exists(select m.msid from managesalesctrl m where m.msworkpercent='100' and m.msestimateno=b.cbestimateno and m.mstoken='"+token+"') and b.cbdueamount>0");
				
				else if(doAction.equalsIgnoreCase("Hold"))
					VCQUERY.append(" and exists(select se.sid from salesestimatepayment se where b.cbestimateno=se.sestsaleno and se.stokenno='"+token+"' and se.stransactionstatus='4')");
			}
			
			if(sort.length()<=0)			
				VCQUERY.append(" group by b.cbuid order by b.cdnotificationcount desc limit "+((page-1)*rows)+","+rows);
			else if(sort.equals("date"))VCQUERY.append(" group by b.cbuid order by str_to_date(b.cbdate,'%d-%m-%Y') "+order+" limit "+((page-1)*rows)+","+rows);	
			else if(sort.equals("invoice"))VCQUERY.append(" group by b.cbuid order by b.cbinvoiceno "+order+" limit "+((page-1)*rows)+","+rows);
			else if(sort.equals("client"))VCQUERY.append("  group by b.cbuid order by b.cbcompanyname "+order+" limit "+((page-1)*rows)+","+rows);
			else if(sort.equals("txn_amt"))VCQUERY.append(" group by b.cbuid order by b.cbtransactionamount "+order+" limit "+((page-1)*rows)+","+rows);	
			else if(sort.equals("ord_amount"))VCQUERY.append(" group by b.cbuid order by b.cborderamount "+order+" limit "+((page-1)*rows)+","+rows);
			else if(sort.equals("due"))VCQUERY.append(" group by b.cbuid order by b.cbdueamount "+order+" limit "+((page-1)*rows)+","+rows);
			else if(sort.equals("paid"))VCQUERY.append(" group by b.cbuid order by b.cbpaidamount "+order+" limit "+((page-1)*rows)+","+rows);
			else VCQUERY.append(" group by b.cbuid order by b.cdnotificationcount desc limit "+((page-1)*rows)+","+rows);
//			System.out.println(VCQUERY);
			stmnt=getacces_con.prepareStatement(VCQUERY.toString());
			rsGCD=stmnt.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];
			int rr=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++)
				{
					newsdata[rr][i]=rsGCD.getString(i+1);
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("Error in getAllEstimatePayment method \n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllEstimatePayment:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	public static int countAllEstimatePayment(String ClientName,String InvoiceNo,String dateRange,
			String doAction,String token,String contactName) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		int newsdata = 0;
		String fromDate="NA";
		String toDate="NA";
		try{			
			if(!dateRange.equalsIgnoreCase("NA")){
				fromDate=dateRange.substring(0,10).trim();
				fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.substring(0,2);
				toDate=dateRange.substring(13).trim();
				toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2);
			}
			getacces_con=DbCon.getCon("","","");
			
			StringBuffer VCQUERY=new StringBuffer("SELECT b.cbuid FROM hrmclient_billing b "
					+ "INNER JOIN contactboxctrl c on b.cbcontactrefid=c.cbrefid where b.cbtokenno= '"+token+"'");
			if(!ClientName.equalsIgnoreCase("NA"))VCQUERY.append(" and b.cbcompanyname='"+ClientName+"'");
			if(!contactName.equalsIgnoreCase("NA"))VCQUERY.append(" and c.cbname='"+contactName+"'");
			if(!InvoiceNo.equalsIgnoreCase("NA"))VCQUERY.append(" and b.cbinvoiceno='"+InvoiceNo+"'");
			if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA")){
				VCQUERY.append(" and str_to_date(b.cbdate,'%d-%m-%Y')<='"+toDate+"' and str_to_date(b.cbdate,'%d-%m-%Y')>='"+fromDate+"'");
			}
			if(!doAction.equalsIgnoreCase("NA")){
				if(doAction.equalsIgnoreCase("Paid"))VCQUERY.append(" and b.cbdueamount='0'");
				else if(doAction.equalsIgnoreCase("Current")){
					VCQUERY.append(" and exists(select m.msid from managesalesctrl m where m.msworkpercent!='100' and m.msestimateno=b.cbestimateno and m.mstoken='"+token+"')");
				}
				else if(doAction.equalsIgnoreCase("Past due")){
					VCQUERY.append(" and exists(select m.msid from managesalesctrl m where m.msworkpercent='100' and m.msestimateno=b.cbestimateno and m.mstoken='"+token+"') and b.cbdueamount>0");
				}else if(doAction.equalsIgnoreCase("Hold"))
					VCQUERY.append(" and exists(select se.sid from salesestimatepayment se where b.cbestimateno=se.sestsaleno and se.stokenno='"+token+"' and se.stransactionstatus='4')"); 
			}
			VCQUERY.append(" group by b.cbuid order by b.cdnotificationcount desc");
//			System.out.println(VCQUERY);
			stmnt=getacces_con.prepareStatement(VCQUERY.toString());
			rsGCD=stmnt.executeQuery();
			
			while(rsGCD!=null && rsGCD.next()){
				newsdata+=1;
			}
		}catch(Exception e)
		{log.info("Error in countAllEstimatePayment method \n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects countAllEstimatePayment:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	public static String[][] getAllTransactions(String doAction,String invoiceNo,String clientName,String dateRange,
			String token,int page,int rows,String sort,String order) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		String fromDate="NA";
		String toDate="NA";
		try{			
			if(!dateRange.equalsIgnoreCase("NA")){
				fromDate=dateRange.substring(0,10).trim();
				fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.substring(0,2);
				toDate=dateRange.substring(13).trim();
				toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2);
			}
			getacces_con=DbCon.getCon("","","");
			
			StringBuffer VCQUERY=new StringBuffer("SELECT mtrefid,mtinvoice,mtdate,mtremarks,mtclientname,mtclientmobile,mtaccounts,mtcategory,mtwithdraw,mtdeposit,mtincludeincashflow FROM managetransactionctrl where mtstatus='1' and mttokenno= '"+token+"'");
			if(!invoiceNo.equalsIgnoreCase("NA"))VCQUERY.append(" and mtinvoice='"+invoiceNo+"'");
			if(!clientName.equalsIgnoreCase("NA"))VCQUERY.append(" and mtaccounts='"+clientName+"'");
			if(!doAction.equalsIgnoreCase("NA")&&!doAction.equalsIgnoreCase("All"))VCQUERY.append(" and mttype='"+doAction+"'");
			if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA")){
				VCQUERY.append(" and str_to_date(mtaddedon,'%Y-%m-%d')<='"+toDate+"' and str_to_date(mtaddedon,'%Y-%m-%d')>='"+fromDate+"'");
			}
			
			if(sort.length()<=0)			
				VCQUERY.append(" order by mtid desc limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("date"))VCQUERY.append("order by str_to_date(mtdate,'%d-%m-%Y') "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("description"))VCQUERY.append("order by mtremarks "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("client"))VCQUERY.append("order by mtclientname "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("account"))VCQUERY.append("order by mtaccounts "+order+" limit "+((page-1)*rows)+","+rows);	
				else if(sort.equals("category"))VCQUERY.append("order by mtcategory "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("withdrawl"))VCQUERY.append("order by mtwithdraw "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("deposit"))VCQUERY.append("order by mtdeposit "+order+" limit "+((page-1)*rows)+","+rows);	
				else if(sort.equals("cash_flow"))VCQUERY.append("order by mtincludeincashflow "+order+" limit "+((page-1)*rows)+","+rows);
//			System.out.println(VCQUERY);
			stmnt=getacces_con.prepareStatement(VCQUERY.toString());
			rsGCD=stmnt.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];
			int rr=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++)
				{
					newsdata[rr][i]=rsGCD.getString(i+1);
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("Error in getAllTransactions method \n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllTransactions:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	public static int countAllTransactions(String doAction,String invoiceNo,String clientName,String dateRange,String token) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		int newsdata = 0;
		String fromDate="NA";
		String toDate="NA";
		try{			
			if(!dateRange.equalsIgnoreCase("NA")){
				fromDate=dateRange.substring(0,10).trim();
				fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.substring(0,2);
				toDate=dateRange.substring(13).trim();
				toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2);
			}
			getacces_con=DbCon.getCon("","","");
			
			StringBuffer VCQUERY=new StringBuffer("SELECT count(mtid) FROM managetransactionctrl where mtstatus='1' and mttokenno= '"+token+"'");
			if(!invoiceNo.equalsIgnoreCase("NA"))VCQUERY.append(" and mtinvoice='"+invoiceNo+"'");
			if(!clientName.equalsIgnoreCase("NA"))VCQUERY.append(" and mtaccounts='"+clientName+"'");
			if(!doAction.equalsIgnoreCase("NA")&&!doAction.equalsIgnoreCase("All"))VCQUERY.append(" and mttype='"+doAction+"'");
			if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA")){
				VCQUERY.append(" and str_to_date(mtaddedon,'%Y-%m-%d')<='"+toDate+"' and str_to_date(mtaddedon,'%Y-%m-%d')>='"+fromDate+"'");
			}
//			System.out.println(VCQUERY);
			stmnt=getacces_con.prepareStatement(VCQUERY.toString());
			rsGCD=stmnt.executeQuery();
			
			if(rsGCD!=null && rsGCD.next()){
				newsdata=rsGCD.getInt(1);
			}
		}catch(Exception e)
		{log.info("Error in countAllTransactions method \n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects countAllTransactions:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	/*For delete billing item*/	
	public static void deleteAmcDetails(String itemid,String token) {
		PreparedStatement ps = null;	
		Connection con = DbCon.getCon("","","");		
		try{
				ps = con.prepareStatement("delete from virtual_project_price where vid='"+itemid+"' and vtokenno='"+token+"' and vpricefrom='amc'");				
				ps.execute();
				
		}catch (Exception e) {
			log.info("Error in deleteAmcDetails method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects deleteAmcDetails:\n"+sqle.getMessage());
			}
		}	
	}
	
	/*For delete billing item*/	
	public static void deleteBillingDetails(String itemid,String token) {
		PreparedStatement ps = null;	
		Connection con = DbCon.getCon("","","");		
		try{
				ps = con.prepareStatement("delete from virtual_project_price where vid='"+itemid+"' and vtokenno='"+token+"' and vpricefrom='billing'");
				ps.execute();
				
		}catch (Exception e) {
			log.info("Error in deleteBillingDetails method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects deleteBillingDetails:\n"+sqle.getMessage());
			}
		}	
	}
	/*For delete in client*/	
	@SuppressWarnings("resource")
	public static void deleteClientDetails(String uid,String token) {
		PreparedStatement ps = null;	
		ResultSet rs=null;
		Connection con = DbCon.getCon("","","");
		String hrmproject=null;
		String billing=null;
		String uaccount=null;
		String clientno=null;
		try{			
			ps = con.prepareStatement("select preguid from hrmproject_reg where pregcuid='"+uid+"' and pregtokenno='"+token+"'");
			rs=ps.executeQuery();
			if(rs.next()) hrmproject=rs.getString(1);
			
			ps = con.prepareStatement("select cbuid from hrmclient_billing where cbcuid='"+uid+"' and cbtokenno='"+token+"'");
			rs=ps.executeQuery();
			if(rs.next()) billing=rs.getString(1);
			
			
			ps = con.prepareStatement("select cregucid from hrmclient_reg where creguid='"+uid+"' and cregtokenno='"+token+"'");
			rs=ps.executeQuery();
			if(rs.next()) clientno=rs.getString(1);
			
			ps = con.prepareStatement("select uaid from user_account where uaempid='"+clientno+"' and uavalidtokenno='"+token+"'");
			rs=ps.executeQuery();
			if(rs.next()) uaccount=rs.getString(1);
			
			if(hrmproject==null&&billing==null&&uaccount==null){
				ps = con.prepareStatement("delete from client_accounts where cacid='"+uid+"' and catokenno='"+token+"'");
				ps.execute();
				ps = con.prepareStatement("delete from hrmclient_reg where creguid='"+uid+"' and cregtokenno='"+token+"'");
				ps.execute();
			}
			
		}catch (Exception e) {
			log.info("Error in deleteClientDetails method \n"+e.getMessage());
		}
		finally{
			try{
				if(rs!=null) {rs.close();}
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects deleteClientDetails:\n"+sqle.getMessage());
			}
		}	
	}
	public static boolean deleteContact(String crefid,String token) {
		PreparedStatement ps = null;		
		Connection con = DbCon.getCon("","","");
		boolean flag=false;
		try{
			String query = "delete from clientcontactbox WHERE ccbrefid='"+crefid+"' and cctokenno='"+token+"'";
			ps = con.prepareStatement(query);
			int k=ps.executeUpdate();
			if(k>0)flag=true;
		}catch (Exception e) {
			log.info("Error in deleteContact method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects deleteContact:\n"+sqle.getMessage());
			}
		}	
		return flag;
	}	
	
	public static boolean saveClientUserInfo(int clientId,int userUaid,String today,String token) {
		PreparedStatement ps = null;		
		Connection con = DbCon.getCon("","","");
		boolean flag=false;
		try{
			String query = "insert into client_user_info(client_id,user_id,date,token) values(?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setInt(1, clientId);
			ps.setInt(2, userUaid);
			ps.setString(3, today);
			ps.setString(4, token);
			int k=ps.executeUpdate();
			if(k>0)flag=true;
			
		}catch (Exception e) {
			log.info("Error in saveClientUserInfo method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects saveClientUserInfo:\n"+sqle.getMessage());
			}
		}	
		return flag;
	}
	
	public static boolean saveClientUserSalesInfo(int salesId,int userUaid,String today,String token) {
		PreparedStatement ps = null;		
		Connection con = DbCon.getCon("","","");
		boolean flag=false;
		try{
			String query = "insert into user_sales_info(sales_id,user_id,date,token) values(?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setInt(1, salesId);
			ps.setInt(2, userUaid);
			ps.setString(3, today);
			ps.setString(4, token);
			int k = ps.executeUpdate();
			if(k>0)flag=true;
			
		}catch (Exception e) {
			log.info("Error in saveClientUserSalesInfo method \n"+e.getMessage());
		}finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects saveClientUserSalesInfo:\n"+sqle.getMessage());
			}
		}	
		return flag;
	}
	
	/*For delete in manage-client*/
	public static void deleteClient(String uid,String status) {
		PreparedStatement ps = null;		
		Connection con = DbCon.getCon("","","");
		try{
			String query = "update hrmclient_reg set cregstatus='"+status+"' WHERE creguid='"+uid+"'";
			ps = con.prepareStatement(query);
			ps.execute();
			
		}catch (Exception e) {
			log.info("Error in deleteClient method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects deleteClient:\n"+sqle.getMessage());
			}
		}	
	}

	/*For delete in billpaymenthistory*/
	public static boolean deleteFraudTransaction(String pymtrefid) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "DELETE FROM billpaymenthistory WHERE bpmrefid='"+pymtrefid+"'";

			ps = con.prepareStatement(query);
			ps.executeUpdate();
			status = true;
		}catch (Exception e) {
			log.info("Error in deleteFraudTransaction method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects deleteFraudTransaction:\n"+sqle.getMessage());
			}
		}
		return status;
	}
	
	/*For delete in manage-bill*/
	public static boolean deleteBill(String uid) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "DELETE FROM hrmclient_billing  WHERE cbuid='"+uid+"'";

			ps = con.prepareStatement(query);
			ps.executeUpdate();
			status = true;
		}catch (Exception e) {
			log.info("Error in deleteBill method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects deleteBill:\n"+sqle.getMessage());
			}
		}
		return status;
	}

	/*For delete in manage-project*/
	public static void deleteProject(String uid,String status) {
		PreparedStatement ps = null;		
		Connection con = DbCon.getCon("","","");
		try{
			String query = "update hrmproject_reg set pregstatus='"+status+"' where preguid='"+uid+"' ";
			ps = con.prepareStatement(query);
			ps.execute();		
		}catch (Exception e) {
			log.info("Error in deleteProject method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects deleteProject:\n"+sqle.getMessage());
			}
		}		
	}
	/*For providing uniqueid to project*/
	public static String getbillingcode(String token) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo=null;
		try{
			String queryselect="SELECT cbinvno FROM hrmclient_billing where cbtokenno='"+token+"' order by cbuid desc limit 1";
			ps=con.prepareStatement(queryselect);
			rset=ps.executeQuery();
			while(rset!=null && rset.next()){
				getinfo=rset.getString(1);
			}
		}catch (Exception e) {
			log.info("Error in getbillingcode method \n"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) rset.close();
			} catch (SQLException e)
			{
				log.info("Error in getbillingcode method \n"+e.getMessage());
			}}
		return getinfo;
	}
	/*For providing uniqueid to project*/
	public static String getmanifetocode(String token) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo=null;
		try{
			String queryselect="SELECT pregpuno FROM hrmproject_reg where pregtokenno='"+token+"' order by preguid desc limit 1";
			ps=con.prepareStatement(queryselect);
			rset=ps.executeQuery();
			while(rset!=null && rset.next()){
				getinfo=rset.getString(1);
			}
		}catch (Exception e) {
			log.info("Error in getmanifetocode method \n"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) rset.close();
			} catch (SQLException e)
			{
				log.info("Error in getmanifetocode method \n"+e.getMessage());
			}}
		return getinfo;
	}

	/*For providing uniqueid to project*/
	public static String getmanifetocodeinitial(String token) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo=null;
		try{
			String queryselect="SELECT pregpuno FROM hrmproject_reg where pregtokenno='"+token+"' order by preguid desc limit 1";
			ps=con.prepareStatement(queryselect);
			rset=ps.executeQuery();
			while(rset!=null && rset.next()){
				getinfo=rset.getString(1);
			}
		}catch (Exception e) {
			log.info("Error in getmanifetocodeinitial method \n"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) rset.close();
			} catch (SQLException e)
			{
				log.info("Error in getmanifetocodeinitial method \n"+e.getMessage());
			}}
		return getinfo;
	}

	/*For providing uniqueid to client*/
	public static String getetocode(String token) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo=null;
		try{
			String queryselect="SELECT cregucid FROM hrmclient_reg where cregtokenno='"+token+"' order by creguid desc limit 1";
			ps=con.prepareStatement(queryselect);
			rset=ps.executeQuery();
			while(rset!=null && rset.next()){
				getinfo=rset.getString(1);
			}
		}catch (Exception e) {
			log.info("Error in getetocode method \n"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) rset.close();
			} catch (SQLException e)
			{
				log.info("Error in getetocode method \n"+e.getMessage());
			}}
		return getinfo;
	}

	public static String getetocodeinitial(String company) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo=null;
		try{
			String queryselect="SELECT SUBSTRING(cregucid,1,4) FROM hrmclient_reg where cregcompany='"+company+"' order by creguid desc limit 1";
			ps=con.prepareStatement(queryselect);
			rset=ps.executeQuery();
			while(rset!=null && rset.next()){
				getinfo=rset.getString(1);
			}
		}catch (Exception e) {
			log.info("Error in getetocodeinitial method \n"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) rset.close();
			} catch (SQLException e)
			{
				log.info("Error in getetocodeinitial method \n"+e.getMessage());
			}}
		return getinfo;
	}

	/*For providing uniqueid to bill*/
	public static String getmanifestocode(String token) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo=null;
		try{
			String queryselect="SELECT cbinvno FROM hrmclient_billing where cbtokenno='"+token+"' order by cbuid desc limit 1";
			ps=con.prepareStatement(queryselect);
			rset=ps.executeQuery();
			while(rset!=null && rset.next()){
				getinfo=rset.getString(1);
			}
		}catch (Exception e) {
			log.info("Error in getmanifestocode method \n"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) rset.close();
			} catch (SQLException e)
			{
				log.info("Error in getmanifestocode method \n"+e.getMessage());
			}}
		return getinfo;
	}

	/*For providing uniqueid to bill*/
	public static String getmanifestocodeinitial(String company) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo=null;
		try{
			String queryselect="SELECT SUBSTRING(cbinvno,1,4) FROM hrmclient_billing where cbcompany='"+company+"' order by cbuid desc limit 1";
			ps=con.prepareStatement(queryselect);
			rset=ps.executeQuery();
			while(rset!=null && rset.next()){
				getinfo=rset.getString(1);
			}
		}catch (Exception e) {
			log.info("Error in getmanifestocodeinitial method \n"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) rset.close();
			} catch (SQLException e)
			{
				log.info("Error in getmanifestocodeinitial method \n"+e.getMessage());
			}}
		return getinfo;
	}

	/*For providing uniqueid to invoice*/
	public static String getinvoicecode(String sequence, String company) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo=null;
		try{
			String queryselect="SELECT CAST((SUBSTRING(giinvno,5)) as UNSIGNED) AS maxval FROM generate_invoice where giinvno like '"+sequence+"%' and gicompany='"+company+"' order by giuid desc limit 1";
			ps=con.prepareStatement(queryselect);
			rset=ps.executeQuery();
			while(rset!=null && rset.next()){
				getinfo=rset.getString(1);
			}
		}catch (Exception e) {
			log.info("Error in getinvoicecode method \n"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) rset.close();
			} catch (SQLException e)
			{
				log.info("Error in getinvoicecode method \n"+e.getMessage());
			}}
		return getinfo;
	}

	/*For providing uniqueid to invoice*/
	public static String getinvoicecodeinitial(String sequence, String company) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo=null;
		try{
			String queryselect="SELECT SUBSTRING(giinvno,1,4) FROM generate_invoice where giinvno like '"+sequence+"%' and gicompany='"+company+"' order by giuid desc limit 1";
			ps=con.prepareStatement(queryselect);
			rset=ps.executeQuery();
			while(rset!=null && rset.next()){
				getinfo=rset.getString(1);
			}
		}catch (Exception e) {
			log.info("Error in getinvoicecodeinitial method \n"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) rset.close();
			} catch (SQLException e)
			{
				log.info("Error in getinvoicecodeinitial method \n"+e.getMessage());
			}}
		return getinfo;
	}	

	public static boolean saveGeneratedInvoice(String giinvno, String gicuid, String gipuid, String giinvamt,
			String gigst, String gigstamt, String gitotal, String gibmonth, String gibdate, String giremark,String giservicecode,String gicategory, String billingamount, Double dueamount, String uacompany) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "insert into generate_invoice (giinvno,gicuid,gipuid,giinvamt,gigst,gigstamt,gitotal,gibmonth,gibdate,giremark,giservicecode,gicategory,gibillamt, gidueamt, gicompany) " +
					"values (?,?,?,?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1,giinvno );
			ps.setString(2,gicuid );
			ps.setString(3,gipuid );
			ps.setString(4,giinvamt );
			ps.setString(5,gigst );
			ps.setString(6,gigstamt );
			ps.setString(7,gitotal );
			ps.setString(8,gibmonth );
			ps.setString(9,gibdate );
			ps.setString(10,giremark );
			ps.setString(11,giservicecode );
			ps.setString(12,gicategory );
			ps.setString(10,billingamount );
			ps.setDouble(11,dueamount );
			ps.setString(12,uacompany );
			ps.executeUpdate();
			status = true;
		}
		catch (Exception e) {
			log.info("Error in saveGeneratedInvoice method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				log.info("Error Closing SQL Objects saveGeneratedInvoice:\n"+sqle.getMessage());
			}
		}
		return status;
	}

	public static String[][] getAllInvoiceDetails(String clientid,String projectid, String invoiceno, String month, String pstatus, String token, String from, String to) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		StringBuffer VCQUERY=null;
		try{
			getacces_con=DbCon.getCon("","","");
			if(clientid==null || clientid.equalsIgnoreCase("Any") || clientid.length() <= 0){ clientid ="NA";}
			if(projectid==null || projectid.equalsIgnoreCase("Any") || projectid.length() <= 0){ projectid ="NA";}
			if(invoiceno==null || invoiceno.equalsIgnoreCase("Any") || invoiceno.length() <= 0){ invoiceno ="NA";}
			if(month==null || month.equalsIgnoreCase("Any") || month.length() <= 0){ month ="NA";}
			if(pstatus==null || pstatus.equalsIgnoreCase("Any") || pstatus.length() <= 0){ pstatus ="NA";}
			if(from==null || from.equalsIgnoreCase("Any") || from.length() <= 0){ from ="NA";}
			if(to==null || to.equalsIgnoreCase("Any") || to.length() <= 0){ to ="NA";}
			VCQUERY= new StringBuffer("SELECT giuid, giinvno, gicuid, gipuid, giinvamt, gibmonth, gibdate, gibillamt, girdate, gipaystatus, gidueamt FROM generate_invoice where gitokenno='"+token+"' ");
			if(clientid!="NA")
			{
				VCQUERY.append(" and gicuid = '"+clientid+"'");
			}
			if(projectid!="NA")
			{
				VCQUERY.append(" and gipuid = '"+projectid+"'");
			}
			if(invoiceno!="NA")
			{
				VCQUERY.append(" and giinvno = '"+invoiceno+"'");
			}
			if(month!="NA")
			{
				VCQUERY.append(" and gibmonth = '"+month+"'");
			}
			if(pstatus!="NA")
			{
				VCQUERY.append(" and gipaystatus = '"+pstatus+"'");
			}
			if(from!="NA"&&to=="NA") VCQUERY.append(" and giaddedon like '"+from+"%'");
			if(from!="NA"&&to!="NA") VCQUERY.append(" and giaddedon between '"+from+"%' and '"+to+"%'");
			stmnt=getacces_con.prepareStatement(VCQUERY.toString());
			rsGCD=stmnt.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];
			int rr=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++)
				{
					newsdata[rr][i]=rsGCD.getString(i+1);
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("Error in getAllInvoiceDetails method \n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllInvoiceDetails:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static boolean deleteInvoice(String uid) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "DELETE FROM generate_invoice WHERE giuid='"+uid+"'";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
			status = true;
		}catch (Exception e) {
			log.info("Error in deleteInvoice method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {
					ps.close();
				}
				if(con!=null) {
					con.close();
				}
			}
			catch(SQLException sqle){
				log.info("Error Closing SQL Objects deleteInvoice:\n"+sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean UpdateGeneratedInvoice(String uid, String giinvno, String gicuid, String gipuid, String giinvamt,
			String gigst, String gigstamt, String gitotal, String gibmonth, String gibdate, String giremark,String giservicecode,String gicategory, String billingamount, double dueamount) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE generate_invoice SET giinvno=?, gicuid=?,gipuid=?,giinvamt=?,gigst=?,gigstamt=?,gitotal=?,gibmonth=?,gibdate=?,giremark=?,giservicecode=?,gicategory=?,gibillamt=?, gidueamt=? WHERE giuid=?";
			ps = con.prepareStatement(query);
			ps.setString(1,giinvno );
			ps.setString(2,gicuid );
			ps.setString(3,gipuid );
			ps.setString(4,giinvamt );
			ps.setString(5,gigst );
			ps.setString(6,gigstamt );
			ps.setString(7,gitotal );
			ps.setString(8,gibmonth );
			ps.setString(9,gibdate );
			ps.setString(10,giremark );
			ps.setString(11,giservicecode );
			ps.setString(12,gicategory );
			ps.setString(13,billingamount );
			ps.setDouble(14,dueamount );
			ps.setString(15,uid );
			ps.executeUpdate();
			status = true;
		}catch (Exception e) {
			log.info("Error in UpdateGeneratedInvoice method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects UpdateGeneratedInvoice:\n"+sqle.getMessage());
			}
		}
		return status;
	}

	public static String[][] getInvoiceData(String pid) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			String query="select giinvno,gitotal from generate_invoice where gipuid='"+pid+"'";
			stmnt=getacces_con.prepareStatement(query);
			rsGCD=stmnt.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];
			int rr=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++)
				{
					newsdata[rr][i]=rsGCD.getString(i+1);
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("Error in getInvoiceData method \n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getInvoiceData:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static boolean saveGeneratedPayment(String pscuid, String pspuid, String psinvno, String psinvamt,
			String psprcvd, String pspstatus, String psrcvddate, String psremark) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "insert into payment_status (pscuid,pspuid, psinvno,psinvamt,psprcvd,pspstatus,psrcvddate,psremark) values ('"+pscuid+"','"+pspuid+"','"+psinvno+"','"+psinvamt+"','"+psprcvd+"','"+pspstatus+"','"+psrcvddate+"','"+psremark+"')";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
			status = true;
		}
		catch (Exception e) {
			log.info("Error in saveGeneratedPayment method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects saveGeneratedPayment:\n"+sqle.getMessage());
			}
		}
		return status;
	}

	public static String[][] getAllPaymentDetails(String token, String from, String to){
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			if(from==null || from.equalsIgnoreCase("Any") || from.length() <= 0){ from ="NA";}
			if(to==null || to.equalsIgnoreCase("Any") || to.length() <= 0){ to ="NA";}
			StringBuffer query= new StringBuffer("SELECT psuid,psinvno, psrcvddate, pspstatus ,pregpname,cregname FROM payment_status join hrmproject_reg on pspuid = preguid join hrmclient_reg on pscuid = creguid where 	cregtokenno='"+token+"'");
			if(from!="NA"&&to=="NA") query.append(" and psaddedon like '"+from+"%'");
			if(from!="NA"&&to!="NA") query.append(" and psaddedon between '"+from+"%' and '"+to+"%'");
			stmnt=getacces_con.prepareStatement(query.toString());
			rsGCD=stmnt.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];
			int rr=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++)
				{
					newsdata[rr][i]=rsGCD.getString(i+1);
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("Error in getAllPaymentDetails method \n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllPaymentDetails:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static boolean deletePayment(String uid) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "DELETE FROM payment_status WHERE psuid='"+uid+"'";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
			status = true;
		}catch (Exception e) {
			log.info("Error in deletePayment method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {
					ps.close();
				}
				if(con!=null) {
					con.close();
				}
			}
			catch(SQLException sqle){
				log.info("Error Closing SQL Objects deletePayment\n"+sqle.getMessage());
			}
		}
		return status;
	}

	/*
	 * public static String[][] getPaymentById(String uid) { // Initialing variables
	 * Connection getacces_con = null; PreparedStatement stmnt = null; ResultSet
	 * rsGCD = null; String[][] newsdata = null; try { getacces_con =
	 * DbCon.getCon("", "", ""); // String query =
	 * "SELECT psuid, pscuid, pspuid, psinvno, psinvamt, psprcvd, pspstatus, psrcvddate, psremark, pregpname, cregname,cbstatus,cbdate FROM payment_status JOIN hrmproject_reg ON pspuid = preguid JOIN hrmclient_reg ON pscuid = creguid join hrmclient_billing on pspuid=cbpuid WHERE psuid = '"
	 * +uid+"';"; // stmnt = getacces_con.prepareStatement(query); rsGCD =
	 * stmnt.executeQuery(); rsGCD.last(); int row = rsGCD.getRow();
	 * rsGCD.beforeFirst(); ResultSetMetaData rsmd = rsGCD.getMetaData(); int col =
	 * rsmd.getColumnCount(); newsdata = new String[row][col]; int rr = 0; while
	 * (rsGCD != null && rsGCD.next()) { for (int i = 0; i < col; i++) {
	 * newsdata[rr][i] = rsGCD.getString(i + 1); } rr++; } } catch (Exception e) {
	 * log.info("Error in getPaymentById method \n"+e.getMessage()); } finally {
	 * 
	 * try { if (stmnt != null) { stmnt.close(); } if (getacces_con != null) {
	 * getacces_con.close(); } if(rsGCD!=null) rsGCD.close(); } catch (SQLException
	 * sqle) { log.info("Error in getPaymentById method \n"+sqle.getMessage()); } }
	 * return newsdata; }
	 */

	public static boolean updateGeneratedPayment(String psuid, String pscuid, String pspuid, String psinvno, String psinvamt,
			String psprcvd, String pspstatus, String psrcvddate, String psremark) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "UPDATE payment_status SET psuid='"+psuid+"', pscuid='"+pscuid+"',pspuid='"+pspuid+"'"
					+ ",psinvno='"+psinvno+"',psinvamt='"+psinvamt+"',psprcvd='"+psprcvd+"',pspstatus='"+pspstatus+"'"
					+ ",psrcvddate='"+psrcvddate+"',psremark='"+psremark+"' WHERE psuid='"+psuid+"'";
			ps = con.prepareStatement(query);

			ps.executeUpdate();
			status = true;
		}catch (Exception e) {
			log.info("Error in updateGeneratedPayment method \n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateGeneratedPayment:\n"+sqle.getMessage());
			}
		}
		return status;
	}

	public static String getClientIDByLoginName(String LoginName) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String alap = null;
		try {
			//Creating Connection
			getacces_con = DbCon.getCon("","","");
			String query = "select creguid from hrmclient_reg where cregname = '"+LoginName+"'";
			stmnt = getacces_con.prepareStatement(query);
			rsGCD = stmnt.executeQuery();
			while(rsGCD!=null && rsGCD.next()){
				alap=rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("Error in getClientIDByLoginName method \n"+e.getMessage());
		}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(rsGCD!=null) {rsGCD.close();}
				if(getacces_con!=null) {getacces_con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Inside finally block of getClientIDByLoginName() method of UserData Class \n"+sqle.getMessage());
			}
		}
		return alap;
	}
	public static int getTotalClient(String role,String uaid,String teamKey,String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		int data = 0;
		String queryselect="";
		try {
			//Creating Connection
			getacces_con = DbCon.getCon("","","");
			
			if(role.equals("Admin")||role.equals("Manager"))
				queryselect = "select count(msid) from managesalesctrl where mstoken='"+token+"' group by msclientrefid";
			else if(role.equals("Assistant")&&!teamKey.equals("NA")) {
				queryselect = "select count(msid) from managesalesctrl where mstoken='"+token+"' and exists(select tmid from manageteammemberctrl where tmteamrefid='"+teamKey+"' and tmuseruid=mssoldbyuid) or mssoldbyuid='"+uaid+"' group by msclientrefid";
			}else {
				queryselect = "select count(msid) from managesalesctrl where mstoken='"+token+"' and mssoldbyuid='"+uaid+"' group by msclientrefid";
			}
			stmnt = getacces_con.prepareStatement(queryselect);
			rsGCD = stmnt.executeQuery();
			while(rsGCD!=null && rsGCD.next()){
				data=rsGCD.getInt(1);
			}
		} catch (Exception e) {
			log.info("Error in getTotalClient method \n"+e.getMessage());
		}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(rsGCD!=null) {rsGCD.close();}
				if(getacces_con!=null) {getacces_con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Inside finally block of getTotalClient() method of UserData Class \n"+sqle.getMessage());
			}
		}
		return data;
	}
	public static String[][] getProjectByClient(String clientID) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			String query = "SELECT preguid,pregpname, pregtype, pregsdate, pregddate, pregpuno,pregcuid FROM hrmproject_reg WHERE pregcuid = '"+clientID+"'";
			stmnt = getacces_con.prepareStatement(query);
			rsGCD = stmnt.executeQuery();
			rsGCD.last();
			int row = rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd = rsGCD.getMetaData();
			int col = rsmd.getColumnCount();
			newsdata = new String[row][col];
			int rr = 0;
			while (rsGCD != null && rsGCD.next()) {
				for (int i = 0; i < col; i++) {
					newsdata[rr][i] = rsGCD.getString(i + 1);
				}
				rr++;
			}
		} catch (Exception e) {
			log.info("Error in getProjectByClient method \n"+e.getMessage());
		} finally {

			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error in getProjectByClient method \n"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAlluser(String clientname,String token, String dateRange,int page,int rows,String sort,String order)
	{
		ResultSet rsGCD=null;
		PreparedStatement psGCD=null;
		String[][] newsdata = null;
		StringBuffer VCQUERY=null;
		Connection con = DbCon.getCon("","","");
		String fromDate="NA";
		String toDate="NA";
		try{			
			if(!dateRange.equalsIgnoreCase("NA")){
				fromDate=dateRange.substring(0,10).trim();
				fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.substring(0,2);
				toDate=dateRange.substring(13).trim();
				toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2);
			}
			VCQUERY=new StringBuffer("SELECT creguid,cregname,cregmob,cregcontemailid,cregaddress,creglocation,cregcontfirstname,cregcontmobile,cregstatus,cregucid,cregcompanyage,cregclientrefid FROM hrmclient_reg where cregtokenno = '"+token+"' ");
			if(clientname!="NAA"){VCQUERY.append(" and cregname = '"+clientname+"'");}			
			if(!dateRange.equalsIgnoreCase("NA")) VCQUERY.append(" and SUBSTRING(cregaddedon,1,10) between '"+fromDate+"' and '"+toDate+"' ");
			
			if(sort.length()<=0)			
				VCQUERY.append(" ORDER BY creguid desc limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("client_no"))VCQUERY.append("order by creguid "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("company_type"))VCQUERY.append("order by cregcompanyage "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("client"))VCQUERY.append("order by cregname "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("mobile"))VCQUERY.append("order by cregmob "+order+" limit "+((page-1)*rows)+","+rows);	
				else if(sort.equals("email"))VCQUERY.append("order by cregcontemailid "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("location"))VCQUERY.append("order by creglocation "+order+" limit "+((page-1)*rows)+","+rows);	
				else if(sort.equals("cname"))VCQUERY.append("order by cregcontfirstname "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("cphone"))VCQUERY.append("order by cregcontmobile "+order+" limit "+((page-1)*rows)+","+rows);
			
			psGCD=con.prepareStatement(VCQUERY.toString());
			rsGCD=psGCD.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];
			int r=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++){
					newsdata[r][i]=rsGCD.getString(i+1);
				}
				r++;
			}
		}catch(Exception e)
		{	log.info("Error in getAlluser method \n"+e.getMessage());
		}
		finally {
			try {
				//closing sql objects
				if(psGCD!=null) {psGCD.close();}
				if(rsGCD!=null) {rsGCD.close();}
				if(con!=null) {con.close();}
			} catch (SQLException e)
			{
				log.info("Error in getAlluser method \n"+e.getMessage());
			}
		}
		return newsdata;
	}

	public static int countAllClient(String clientname,String token, String dateRange)
	{
		ResultSet rsGCD=null;
		PreparedStatement psGCD=null;
		int newsdata = 0;
		StringBuffer VCQUERY=null;
		Connection con = DbCon.getCon("","","");
		String fromDate="NA";
		String toDate="NA";
		try{			
			if(!dateRange.equalsIgnoreCase("NA")){
				fromDate=dateRange.substring(0,10).trim();
				fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.substring(0,2);
				toDate=dateRange.substring(13).trim();
				toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2);
			}
			VCQUERY=new StringBuffer("SELECT count(creguid) FROM hrmclient_reg where cregtokenno = '"+token+"' ");
			if(clientname!="NAA"){VCQUERY.append(" and cregname = '"+clientname+"'");}			
			if(!dateRange.equalsIgnoreCase("NA")) VCQUERY.append(" and SUBSTRING(cregaddedon,1,10) between '"+fromDate+"' and '"+toDate+"'");
			
			VCQUERY.append(" ORDER BY creguid DESC");
			psGCD=con.prepareStatement(VCQUERY.toString());
			rsGCD=psGCD.executeQuery();
			
			while(rsGCD!=null && rsGCD.next()){
				newsdata=rsGCD.getInt(1);
			}
		}catch(Exception e)
		{	log.info("Error in countAllClient method \n"+e.getMessage());
		}
		finally {
			try {
				//closing sql objects
				if(psGCD!=null) {psGCD.close();}
				if(rsGCD!=null) {rsGCD.close();}
				if(con!=null) {con.close();}
			} catch (SQLException e)
			{
				log.info("Error in countAllClient method \n"+e.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] getAssignedTaskById(String projectno,String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			String query = "select aid,ataskid,aprojectid,amilestoneid,aassignedtoid,aremarks,aassigndate,adeliverydate,aimageurl,astatus from assigntask where aprojectid = '"+projectno+"' and atokenno='"+token+"' order by aid desc";
			stmnt = getacces_con.prepareStatement(query);
			rsGCD = stmnt.executeQuery();
			rsGCD.last();
			int row = rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd = rsGCD.getMetaData();
			int col = rsmd.getColumnCount();
			newsdata = new String[row][col];
			int rr = 0;
			while (rsGCD != null && rsGCD.next()) {
				for (int i = 0; i < col; i++) {
					newsdata[rr][i] = rsGCD.getString(i + 1);
				}
				rr++;
			}
		} catch (Exception e) {
			log.info("Error in getAssignedTaskById method \n"+e.getMessage());
		} finally {

			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null) {
					rsGCD.close();
				}
			} catch (SQLException sqle) {
				log.info("Error in sql getAssignedTaskById method \n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] getFollowUpById(String projectid,String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		String query="";
		try {
			getacces_con = DbCon.getCon("", "", "");
			
			query = "select pfuid,pfupid,pfustatus,pfudate,deliverydate,pfuremark,followupby,pfimgurl,pfmsgfor,pftaskname,pfuuserrefid from hrmproject_followup where pfupid = '"+projectid+"' and pftokenno='"+token+"' order by pfuid";
			stmnt = getacces_con.prepareStatement(query);
			rsGCD = stmnt.executeQuery();
			rsGCD.last();
			int row = rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd = rsGCD.getMetaData();
			int col = rsmd.getColumnCount();
			newsdata = new String[row][col];
			int rr = 0;
			while (rsGCD != null && rsGCD.next()) {
				for (int i = 0; i < col; i++) {
					newsdata[rr][i] = rsGCD.getString(i + 1);
				}
				rr++;
			}
		} catch (Exception e) {
			log.info("Error in getFollowUpById method \n"+e.getMessage());
		} finally {

			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null) {
					rsGCD.close();
				}
			} catch (SQLException sqle) {
				log.info("Error in getFollowUpById method \n"+sqle.getMessage());
			}
		}
		return newsdata;
	}

//	public static String getDocumentNameForProjectFollowUp(String pfuid,String token) {
//		Connection con = DbCon.getCon("", "", "");
//		PreparedStatement ps = null;
//		ResultSet rset = null;
//		String getinfo = "";
//		try {
//			String queryselect = "SELECT dmdocumentpath FROM document_master WHERE dmfileid = '"+pfuid+"' and dmtype='projectfollowup' and dmstatus='1' and dmtokenno='"+token+"'";
//			ps = con.prepareStatement(queryselect);
//			rset = ps.executeQuery();
//			while (rset != null && rset.next()) {
//				getinfo = rset.getString(1);
//			}
//
//		} catch (Exception e) {
//			log.info("getprojectname"+e.getMessage());
//		} finally {
//			try {
//				// closing sql objects
//				if (ps != null) {
//					ps.close();
//				}
//				if (con != null) {
//					con.close();
//				}
//				if(rset!=null) rset.close();
//			} catch (SQLException e) {
//				log.info("getprojectname"+e.getMessage());
//			}
//		}
//		return getinfo;
//	}

	public static boolean saveFollowUp(String msgfor,String pfupid, String pfustatus, String pfudate, String pfuremark,
			String loginid, String pfuatoid,String followupby, String pfuddate, String showclient,String token,String fromfollowup,String imgname,String uarefid) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		String query = "";
		try {
			query = "insert into hrmproject_followup (pfupid,pfustatus,pfudate,pfuremark,pfuaddedby, pfuatoid,followupby, deliverydate, showclient,pftokenno,pffromstatus,pfimgurl,pfmsgfor,pfuuserrefid) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, pfupid);
			ps.setString(2, pfustatus);
			ps.setString(3, pfudate);
			ps.setString(4, pfuremark);
			ps.setString(5, loginid);
			ps.setString(6, pfuatoid);
			ps.setString(7, followupby);
			ps.setString(8, pfuddate);
			ps.setString(9, showclient);
			ps.setString(10, token);
			ps.setString(11, fromfollowup);
			ps.setString(12, imgname);
			ps.setString(13, msgfor);
			ps.setString(14, uarefid);
			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("Error in saveFollowUpsaveFollowUp method \n"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error in saveFollowUp method \n"+sqle.getMessage());
			}
		}
		return status;
	}

	public static void FollowUpDelete(String uid) {
		PreparedStatement ps = null;		
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "DELETE FROM hrmproject_followup WHERE pfuid='" + uid + "'";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
		} catch (Exception e) {
			log.info("Error in FollowUpDelete method \n"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error in FollowUpDelete method \n"+sqle.getMessage());
			}
		}
	}

//	public static boolean saveBillingDate(String pid, String cbstatus, String cbdate) {
//		PreparedStatement ps = null;
//		boolean status = false;
//		Connection con = DbCon.getCon("", "", "");
//		try {
//			String query = "update hrmclient_billing set cbstatus = '"+cbstatus+"', cbdate = '"+cbdate+"' where cbpuid = '"+pid+"'";
//			ps = con.prepareStatement(query);
//			ps.executeUpdate();
//			status = true;
//		} catch (Exception e) {
//
//		} finally {
//			try {
//				if (ps != null) {
//					ps.close();
//				}
//				if (con != null) {
//					con.close();
//				}
//			} catch (SQLException sqle) {
//				sqle.printStackTrace();
//			}
//		}
//		return status;
//	}

	public static boolean saveFollowUpinProjectMaster(String pfupid, String pfustatus, String pfudate,String pfuato, String newfollowup) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query="";
			if(pfuato.equalsIgnoreCase("delivered"))
				query = "update hrmproject_reg set pregdeliveredon = '"+pfudate+"', pregrunningstatus = '"+pfustatus+"', newfollowup='"+newfollowup+"' where preguid = '"+pfupid+"'";
			else
				query = "update hrmproject_reg set pregddate = '"+pfudate+"', pregrunningstatus = '"+pfustatus+"', pregato='"+pfuato+"', newfollowup='"+newfollowup+"' where preguid = '"+pfupid+"'";
			ps = con.prepareStatement(query);
//			System.out.println(query);
			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("Error in saveFollowUpinProjectMaster method \n"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error in sql saveFollowUpinProjectMaster method \n"+sqle.getMessage());
			}
		}
		return status;
	}

	@SuppressWarnings("resource")
	public static String saveManageTask(String ptltuid, String pfupid, String loginuaid, String pfuatoid,
			String ptlname, String pfuremark, String today, String pfudate, String loginid, String uacompany,String token) {
		PreparedStatement ps = null;
		ResultSet rs=null;
		String id=null;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "insert into projecttask_list (ptltuid, ptlpuid, ptlby, ptlto, ptlname, ptlremark, ptladate, ptlddate, ptladdedby, ptlcompany,ptltokenno,ptlstatus) values (?,?,?,?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, ptltuid);
			ps.setString(2, pfupid);
			ps.setString(3, loginuaid);
			ps.setString(4, pfuatoid);
			ps.setString(5, ptlname);
			ps.setString(6, pfuremark);
			ps.setString(7, today);
			ps.setString(8, pfudate);
			ps.setString(9, loginid);
			ps.setString(10, uacompany);
			ps.setString(11, token);
			ps.setString(12, "Open");
			ps.execute();
			ps = con.prepareStatement("select ptluid from projecttask_list where ptltuid='"+ptltuid+"' and ptltokenno='"+token+"'");
			rs=ps.executeQuery();
			if(rs.next()) id=rs.getString(1);
		} catch (Exception e) {
			log.info("Error in saveManageTask method \n"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				log.info("Error in saveManageTask method \n"+sqle.getMessage());
			}
		}
		return id;
	}

	public static String getClientByInvId(String clientid) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo=null;
		try{
			String queryselect="SELECT cregname FROM hrmclient_reg where creguid = '"+clientid+"'";
			ps=con.prepareStatement(queryselect);
			rset=ps.executeQuery();
			while(rset!=null && rset.next()){
				getinfo=rset.getString(1);
			}
		}catch (Exception e) {
			log.info("Error in getClientByInvId method \n"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) rset.close();
			} catch (SQLException e)
			{
				log.info("Error in getClientByInvId method \n"+e.getMessage());
			}}
		return getinfo;
	}


	public static String getProjectByInvId(String projectid) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo=null;
		try{
			String queryselect="SELECT pregpname from hrmproject_reg where preguid = '"+projectid+"'";
			ps=con.prepareStatement(queryselect);
			rset=ps.executeQuery();
			while(rset!=null && rset.next()){
				getinfo=rset.getString(1);
			}
		}catch (Exception e) {
			log.info("Error in getProjectByInvId method \n"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) rset.close();
			} catch (SQLException e)
			{
				log.info("Error in getProjectByInvId method \n"+e.getMessage());
			}}
		return getinfo;
	}


//	public static String getBillingStatusByInvId(String projectid) {
//		Connection con = DbCon.getCon("","","");
//		PreparedStatement ps = null;
//		ResultSet rset=null;
//		String getinfo=null;
//		try{
//			String queryselect="SELECT cbstatus FROM hrmclient_billing where cbpuid = '"+projectid+"'";
//			ps=con.prepareStatement(queryselect);
//			rset=ps.executeQuery();
//			while(rset!=null && rset.next()){
//				getinfo=rset.getString(1);
//			}
//		}catch (Exception e) {
//
//		}finally {
//			try {
//				//closing sql objects
//				if(ps!=null) {ps.close();}
//				if(con!=null) {con.close();}
//				if(rset!=null) rset.close();
//			} catch (SQLException e)
//			{
//
//			}}
//		return getinfo;
//	}

	public static boolean updateGST(String gibmonth, String gicategory, String gigst, String gigstamt,
			String gicuid, String gipuid, String billingamount, String giinvamt, String giinvno) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "update gst_history set ghmonth='"+gibmonth+"', ghcategory='"+gicategory+"', gigst='"+gigst+"', gigstamt='"+gigstamt+"', gicuid='"+gicuid+"', gipuid='"+gipuid+"', gibillamt='"+billingamount+"', giinvamt='"+giinvamt+"' where giinvno='"+giinvno+"'";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("Error in updateGST method \n"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error in updateGST method \n"+sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean saveReceivingDate(String psinvno, String psrcvddate, String pspstatus) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "update generate_invoice set girdate='"+psrcvddate+"', gipaystatus='"+pspstatus+"' where giinvno='"+psinvno+"'";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("Error in saveReceivingDate method \n"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error in saveReceivingDate method \n"+sqle.getMessage());
			}
		}
		return status;
	}

	public static String[][] getAllAccounts(String clientId, String dateRange,String token,int page,int rows,String sort,String order) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		String fromDate="NA";
		String toDate="NA";
		try{			
			if(!dateRange.equalsIgnoreCase("NA")){
				fromDate=dateRange.substring(0,10).trim();
				fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.substring(0,2);
				toDate=dateRange.substring(13).trim();
				toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2);
			}
			getacces_con = DbCon.getCon("", "", "");
			
			StringBuffer query = new StringBuffer("select hr.creguid, hr.cregname, hr.cregcontmobile, hr.cregcontemailid,ca.caid from client_accounts ca join hrmclient_reg hr on hr.creguid=ca.cacid where ca.castatus=1 and hr.cregtokenno='"+token+"' ");
			if(!clientId.equalsIgnoreCase("NA")) query.append(" and ca.cacid = '"+clientId+"' ");
			if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA")){
				query.append("and str_to_date(ca.caaddedon,'%Y-%m-%d')<='"+toDate+"' and str_to_date(ca.caaddedon,'%Y-%m-%d')>='"+fromDate+"' ");
			}
			if(sort.length()<=0)			
				query.append("group by ca.cacid order by ca.caid desc limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("name"))query.append("order by hr.cregname "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("phone"))query.append("order by hr.cregcontmobile "+order+" limit "+((page-1)*rows)+","+rows);
				else if(sort.equals("email"))query.append("order by hr.cregcontemailid "+order+" limit "+((page-1)*rows)+","+rows);
					
//			System.out.println(query);
			stmnt = getacces_con.prepareStatement(query.toString());
			rsGCD = stmnt.executeQuery();
			rsGCD.last();
			int row = rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd = rsGCD.getMetaData();
			int col = rsmd.getColumnCount();
			newsdata = new String[row][col];
			int rr = 0;
			while (rsGCD != null && rsGCD.next()) {
				for (int i = 0; i < col; i++) {
					newsdata[rr][i] = rsGCD.getString(i + 1);
				}
				rr++;
			}
		} catch (Exception e) {
			log.info("Error in getAllAccounts method \n"+e.getMessage());
		} finally {

			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if(rsGCD!=null) rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error in sql getAllAccounts method \n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	public static int countAllAccounts(String clientId, String dateRange,String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		int newsdata = 0;
		String fromDate="NA";
		String toDate="NA";
		try{			
			if(!dateRange.equalsIgnoreCase("NA")){
				fromDate=dateRange.substring(0,10).trim();
				fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.substring(0,2);
				toDate=dateRange.substring(13).trim();
				toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2);
			}
			getacces_con = DbCon.getCon("", "", "");
			
			StringBuffer query = new StringBuffer("select ca.caid from client_accounts ca join hrmclient_reg hr on hr.creguid=ca.cacid where ca.castatus=1 and hr.cregtokenno='"+token+"'");
			if(!clientId.equalsIgnoreCase("NA")) query.append(" and ca.cacid = '"+clientId+"'");
			if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA")){
				query.append(" and str_to_date(ca.caaddedon,'%Y-%m-%d')<='"+toDate+"' and str_to_date(ca.caaddedon,'%Y-%m-%d')>='"+fromDate+"'");
			}
			query.append(" group by ca.cacid");
//			System.out.println(query);
			stmnt = getacces_con.prepareStatement(query.toString());
			rsGCD = stmnt.executeQuery();
			
			while (rsGCD != null && rsGCD.next()) {
				newsdata+=1;
			}
		} catch (Exception e) {
			log.info("Error in countAllAccounts method \n"+e.getMessage());
		} finally {

			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if(rsGCD!=null) rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error in sql countAllAccounts method \n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	public static double getRunningBalance(String accountid) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		double getinfo=0;
		try{
			String queryselect="select sum(accbdebit),sum(accbcredit) from client_accounts_statement where accbmuid='"+accountid+"' order by accbaddedon desc limit 1";
//		System.out.println(queryselect);
			ps=con.prepareStatement(queryselect);
			rset=ps.executeQuery();
			while(rset!=null && rset.next()){
				getinfo=(rset.getDouble(2)-rset.getDouble(1));
			}
		}catch (Exception e) {
			log.info("Error in getRunningBalance method \n"+e.getMessage());
		}finally {
			try {
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) rset.close();
			} catch (SQLException e)
			{
				log.info("Error in getRunningBalance method \n"+e.getMessage());
			}}
		return getinfo;
	}

	public static String[][] getAccountByID(String clientid) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer("select hr.creguid, hr.cregname, hr.cregmob, hr.cregemailid, ca.cadescription,ca.caid from client_accounts ca join hrmclient_reg hr on hr.creguid=ca.cacid where ca.cacid='"+clientid+"'");
			stmnt = getacces_con.prepareStatement(query.toString());
			rsGCD = stmnt.executeQuery();
			rsGCD.last();
			int row = rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd = rsGCD.getMetaData();
			int col = rsmd.getColumnCount();
			newsdata = new String[row][col];
			int rr = 0;
			while (rsGCD != null && rsGCD.next()) {
				for (int i = 0; i < col; i++) {
					newsdata[rr][i] = rsGCD.getString(i + 1);
				}
				rr++;
			}
		} catch (Exception e) {
			log.info("Error in getAccountByID method \n"+e.getMessage());
		} finally {

			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if(rsGCD!=null) rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error in sql getAccountByID method \n"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] findAllAssignedCompany(String loginUaid,String token,String userRole) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer("select h.creguid,h.cregname from hrmclient_reg h ");
			if(userRole.equalsIgnoreCase("SUPER_USER"))query.append("where h.super_user_uaid='"+loginUaid+"'");
			else query.append("left join client_user_info c on h.creguid=c.client_id where c.user_id='"+loginUaid+"'");
			query.append(" and h.cregtokenno='"+token+"'");
			stmnt = getacces_con.prepareStatement(query.toString());
			rsGCD = stmnt.executeQuery();
			rsGCD.last();
			int row = rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd = rsGCD.getMetaData();
			int col = rsmd.getColumnCount();
			newsdata = new String[row][col];
			int rr = 0;
			while (rsGCD != null && rsGCD.next()) {
				for (int i = 0; i < col; i++) {
					newsdata[rr][i] = rsGCD.getString(i + 1);
				}
				rr++;
			}
		} catch (Exception e) {
			log.info("Error in findAllAssignedCompany method \n"+e.getMessage());
		} finally {

			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if(rsGCD!=null) rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error in findAllAssignedCompany method \n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] getAccountStatement(String accountid,int page,int rows) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer("select accbuid,accbmuid,accbdescription,accbdate,accbdebit,accbcredit,accbaddedby,accbaddedon,accprojectId,accbinvoiceno from client_accounts_statement where accbmuid='"+accountid+"' ");
			query.append("order by accbuid limit "+((page-1)*rows)+","+rows);
				
			stmnt = getacces_con.prepareStatement(query.toString());
			rsGCD = stmnt.executeQuery();
			rsGCD.last();
			int row = rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd = rsGCD.getMetaData();
			int col = rsmd.getColumnCount();
			newsdata = new String[row][col];
			int rr = 0;
			while (rsGCD != null && rsGCD.next()) {
				for (int i = 0; i < col; i++) {
					newsdata[rr][i] = rsGCD.getString(i + 1);
				}
				rr++;
			}
		} catch (Exception e) {
			log.info("Error in getAccountStatement method \n"+e.getMessage());
		} finally {

			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if(rsGCD!=null) rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error in getAccountStatement method \n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	public static int countAccountStatement(String accountid) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		int newsdata = 0;
		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer("select count(accbuid) from client_accounts_statement where accbmuid='"+accountid+"'");
			stmnt = getacces_con.prepareStatement(query.toString());
			rsGCD = stmnt.executeQuery();
			
			if (rsGCD != null && rsGCD.next()) {
				newsdata=rsGCD.getInt(1);
			}
		} catch (Exception e) {
			log.info("Error in countAccountStatement method \n"+e.getMessage());
		} finally {

			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if(rsGCD!=null) rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error in countAccountStatement method \n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	public static void saveAccountStatement(String accountid, String description, String date, String debit,
			String credit, double newrunningbalance, String addedby) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "insert into client_accounts_statement (accbmuid, accbdescription, accbdate, accbdebit, accbcredit, accbrbalance, accbaddedby) values ('"+accountid+"','"+description+"','"+date+"','"+debit+"','"+credit+"','"+newrunningbalance+"','"+addedby+"')";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
		} catch (Exception e) {
			log.info("Error in saveAccountStatement method \n"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error in saveAccountStatement method \n"+sqle.getMessage());
			}
		}
	}

	public static void deleteAccountStatementEntry(String id) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "delete from client_accounts_statement where accbuid='"+id+"'";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
		} catch (Exception e) {
			log.info("Error in deleteAccountStatementEntry method \n"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error in deleteAccountStatementEntry method \n"+sqle.getMessage());
			}
		}
	}

	@SuppressWarnings("resource")
	public static void addToAccount(String gicuid, String gitotal, String giremark, String addedby, String gibdate) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		ResultSet rs = null;
		String runbal = "0";
		try {
			String sql = "select accbrbalance from client_accounts_statement where accbmuid=(select caid from client_accounts where cacid='"+gicuid+"') order by accbaddedon desc limit 1";
			ps = con.prepareStatement(sql);
			rs = ps.executeQuery();
			if(rs.next()) runbal = rs.getString(1);
			String query = "insert into client_accounts_statement (accbmuid,accbdescription,accbdate, accbdebit, accbrbalance, accbaddedby) values ((select caid from client_accounts where cacid='"+gicuid+"'),'"+giremark+"','"+gibdate+"','"+gitotal+"','"+(Double.parseDouble(runbal)-Double.parseDouble(gitotal))+"','"+addedby+"')";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
		} catch (Exception e) {
			log.info("Error in addToAccount method \n"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if(rs!=null) rs.close();
			} catch (SQLException sqle) {
				log.info("Error in addToAccount method \n"+sqle.getMessage());
			}
		}
	}

	@SuppressWarnings("resource")
	public static void saveToAccount(String pscuid, String psprcvd, String psremark, String addedby, String psrcvddate) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		ResultSet rs = null;
		String runbal = "0";
		try {
			String sql = "select accbrbalance from client_accounts_statement where accbmuid=(select caid from client_accounts where cacid='"+pscuid+"') order by accbaddedon desc limit 1";
			ps = con.prepareStatement(sql);
			rs = ps.executeQuery();
			if(rs.next()) runbal = rs.getString(1);
			String query = "insert into client_accounts_statement (accbmuid,accbdescription,accbdate, accbdebit, accbrbalance, accbaddedby) values ((select caid from client_accounts where cacid='"+pscuid+"'),'"+psremark+"','"+psrcvddate+"','"+psprcvd+"','"+(Double.parseDouble(runbal)+Double.parseDouble(psprcvd))+"','"+addedby+"')";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
		} catch (Exception e) {
			log.info("Error in saveToAccount method \n"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if(rs!=null) rs.close();
			} catch (SQLException sqle) {
				log.info("Error in sql saveToAccount method \n"+sqle.getMessage());
			}
		}
	}

	public static boolean openClientAccount(String invoice,String clientid,String clientname,String addedby,String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag=false;
		try {
			String description="Account of "+clientname+" created against invoice "+invoice;
			String query = "insert into client_accounts (cacid, cadescription, castatus, caaddedby,catokenno) values (?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, clientid);ps.setString(2, description);ps.setString(3, "1");
			ps.setString(4, addedby);ps.setString(5, token);
			int k=ps.executeUpdate();
			if(k>0)flag=true;
		} catch (Exception e) {
			log.info("Error in openAccount method  openClientAccount\n"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error in sql openAccount method  openClientAccount\n"+sqle.getMessage());
			}
		}
		return flag;
	}
	
	public static void openAccount(String cregucid, String cregname, String addeduser,String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "insert into client_accounts (cacid, cadescription, castatus, caaddedby,catokenno) values ((select creguid from hrmclient_reg where cregucid='"+cregucid+"'),'Account of "+cregname+" created.','1','"+addeduser+"','"+token+"')";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
		} catch (Exception e) {
			log.info("Error in openAccount method \n"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error in sql openAccount method \n"+sqle.getMessage());
			}
		}
	}

	public static void markProjectRead(String uid) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "update hrmproject_reg set newfollowup='0' where preguid='"+uid+"'";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
		} catch (Exception e) {
			log.info("Error in markProjectRead method \n"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error in sql markProjectRead method \n"+sqle.getMessage());
			}
		}
	}

	public static String[][] getPendingInvoices(String token,String userroll) {
		//Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			StringBuffer VCQUERY=new StringBuffer("SELECT gibdate,cregname,gipaystatus,gitotal FROM generate_invoice JOIN hrmclient_reg ON hrmclient_reg.creguid = generate_invoice.gicuid where gitokenno!='NA'");
			if(!userroll.equalsIgnoreCase("super admin")) {
				VCQUERY.append(" and gitokenno='"+token+"'");
			}
			VCQUERY.append(" and gipaystatus!='Full' order by giaddedon desc limit 5");
			stmnt=getacces_con.prepareStatement(VCQUERY.toString());
			rsGCD=stmnt.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];
			int rr=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++)
				{
					newsdata[rr][i]=rsGCD.getString(i+1);
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("Error in getPendingInvoices method \n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getPendingInvoices:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String getLastFollowUp(String projectid) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo=null;
		try{
			String queryselect="select pfuid from hrmproject_followup where pfupid='"+projectid+"' order by pfuid desc limit 1";
			ps=con.prepareStatement(queryselect);
			rset=ps.executeQuery();
			while(rset!=null && rset.next()){
				getinfo=rset.getString(1);
			}
		}catch (Exception e) {
			log.info("Error in getLastFollowUp method \n"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) rset.close();
			} catch (SQLException e)
			{
				log.info("Error in getLastFollowUp method \n"+e.getMessage());
			}}
		return getinfo;
	}

	public static String getClientNumberByKey(String clientrefid, String token) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo=null;
		try{
			String queryselect="select cregucid from hrmclient_reg where cregclientrefid='"+clientrefid+"' and cregtokenno='"+token+"'";
			ps=con.prepareStatement(queryselect);
			rset=ps.executeQuery();
			while(rset!=null && rset.next()){
				getinfo=rset.getString(1);
			}
		}catch (Exception e) {
			log.info("Error in getClientNumberByKey method \n"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) rset.close();
			} catch (SQLException e)
			{
				log.info("Error in getClientNumberByKey method \n"+e.getMessage());
			}}
		return getinfo;
	}
		
	public static String findClientKeyById(String clientId, String token) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo=null;
		try{
			String queryselect="select cregclientrefid from hrmclient_reg where creguid='"+clientId+"' and cregtokenno='"+token+"'";
			ps=con.prepareStatement(queryselect);
			rset=ps.executeQuery();
			while(rset!=null && rset.next()){
				getinfo=rset.getString(1);
			}
		}catch (Exception e) {
			log.info("Error in findClientKeyById method \n"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) rset.close();
			} catch (SQLException e)
			{
				log.info("Error in findClientKeyById method \n"+e.getMessage());
			}}
		return getinfo;
	}
	
	public static String getClientIdByKey(String clientrefid, String token) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo=null;
		try{
			String queryselect="select creguid from hrmclient_reg where cregclientrefid='"+clientrefid+"' and cregtokenno='"+token+"'";
			ps=con.prepareStatement(queryselect);
			rset=ps.executeQuery();
			while(rset!=null && rset.next()){
				getinfo=rset.getString(1);
			}
		}catch (Exception e) {
			log.info("Error in getClientIdByKey method \n"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) rset.close();
			} catch (SQLException e)
			{
				log.info("Error in getClientIdByKey method \n"+e.getMessage());
			}}
		return getinfo;
	}

	public static String[] getClientDetailsByEmail(String email, String token) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo[]=new String[2];
		try{
			String queryselect="select cregclientrefid,cregname from hrmclient_reg where (cregemailid='"+email+"' or cregcontemailid='"+email+"') and cregtokenno='"+token+"'";
//			System.out.println(queryselect);
			ps=con.prepareStatement(queryselect);
			rset=ps.executeQuery();
			while(rset!=null && rset.next()){
				getinfo[0]=rset.getString(1);
				getinfo[1]=rset.getString(2);
			}
		}catch (Exception e) {e.printStackTrace();
			log.info("Error in getClientDetailsByEmail method \n"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) rset.close();
			} catch (SQLException e)
			{
				log.info("Error in getClientDetailsByEmail method \n"+e.getMessage());
			}}
		return getinfo;
	}

	public static String getClientKeyByEmail(String email, String token) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo="NA";
		try{
			String queryselect="select cregclientrefid from hrmclient_reg where (cregemailid='"+email+"' or cregcontemailid='"+email+"') and cregtokenno='"+token+"' limit 1";
//			System.out.println(queryselect);
			ps=con.prepareStatement(queryselect);
			rset=ps.executeQuery();
			while(rset!=null && rset.next()){
				getinfo=rset.getString(1);
			}
		}catch (Exception e) {e.printStackTrace();
			log.info("Error in getClientKeyByEmail method \n"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) rset.close();
			} catch (SQLException e)
			{
				log.info("Error in getClientKeyByEmail method \n"+e.getMessage());
			}}
		return getinfo;
	}

	public static String getContactByEmail(String email, String mobile, String token) {
		Connection con = DbCon.getCon("","","");
		PreparedStatement ps = null;
		ResultSet rset=null;
		String getinfo="NA";
		try{
			String queryselect="select ccbrefid from clientcontactbox where (ccemailfirst='"+email+"' or ccemailsecond='"+email+"' or ccworkphone='"+mobile+"' or ccmobilephone='"+mobile+"') and cctokenno='"+token+"' limit 1";
//			System.out.println(queryselect);
			ps=con.prepareStatement(queryselect);
			rset=ps.executeQuery();
			while(rset!=null && rset.next()){
				getinfo=rset.getString(1);
			}
		}catch (Exception e) {
			log.info("Error in getContactByEmail method \n"+e.getMessage());
		}finally {
			try {
				//closing sql objects
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rset!=null) rset.close();
			} catch (SQLException e)
			{
				log.info("Error in getContactByEmail method \n"+e.getMessage());
			}}
		return getinfo;
	}

	public static boolean isClientUserMapped(int clientId, int userUaid, String token) {
		PreparedStatement ps = null;		
		ResultSet rs=null;			
		boolean status=false;
		
		Connection con = DbCon.getCon("","","");
		try{
			StringBuffer sb=new StringBuffer("select id from client_user_info where client_id='"+clientId+"' and user_id='"+userUaid+"' and token='"+token+"'");
			ps=con.prepareStatement(sb.toString());
			rs=ps.executeQuery();
			if(rs.next()){
				status=true;
			}
			}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method isClientUserMapped:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}				
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects isClientUserMapped:\n"+sqle.getMessage());
			}
		}
	return status;	
	}
	
	public static int findContactId(String clientKey, String token) {
		PreparedStatement ps = null;		
		ResultSet rs=null;			
		int data=0;
		
		Connection con = DbCon.getCon("","","");
		try{
			StringBuffer sb=new StringBuffer("select ccbid from clientcontactbox where ccbrefid='"+clientKey+"' and cctokenno='"+token+"' limit 1");
			ps=con.prepareStatement(sb.toString());
			rs=ps.executeQuery();
			if(rs.next()){
				data=rs.getInt(1);
			}
			}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method findContactId:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}				
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects findContactId:\n"+sqle.getMessage());
			}
		}
	return data;	
	}

	public static int findClientSuperUserId(String clientid, String token) {
		PreparedStatement ps = null;		
		ResultSet rs=null;			
		int data=0;
		
		Connection con = DbCon.getCon("","","");
		try{
			StringBuffer sb=new StringBuffer("select super_user_uaid from hrmclient_reg where creguid='"+clientid+"' and cregtokenno='"+token+"'");
			ps=con.prepareStatement(sb.toString());
			rs=ps.executeQuery();
			if(rs.next()){
				data=rs.getInt(1);
			}
			}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method findClientSuperUserId:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}				
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects findClientSuperUserId:\n"+sqle.getMessage());
			}
		}
	return data;	
	}
	
	public static int findClientSuperUserByKey(String clientKey, String token) {
		PreparedStatement ps = null;		
		ResultSet rs=null;			
		int data=0;
		
		Connection con = DbCon.getCon("","","");
		try{
			StringBuffer sb=new StringBuffer("select super_user_uaid from hrmclient_reg where cregclientrefid='"+clientKey+"' and cregtokenno='"+token+"'");
			ps=con.prepareStatement(sb.toString());
			rs=ps.executeQuery();
			if(rs.next()){
				data=rs.getInt(1);
			}
			}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method findClientSuperUserByKey:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}				
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects findClientSuperUserByKey:\n"+sqle.getMessage());
			}
		}
	return data;	
	}
	
	public static int findClientSuperUserIdByClientNo(String clientNo, String token) {
		PreparedStatement ps = null;		
		ResultSet rs=null;			
		int data=0;
		
		Connection con = DbCon.getCon("","","");
		try{
			StringBuffer sb=new StringBuffer("select super_user_uaid from hrmclient_reg where cregucid='"+clientNo+"' and cregtokenno='"+token+"'");
			ps=con.prepareStatement(sb.toString());
			rs=ps.executeQuery();
			if(rs.next()){
				data=rs.getInt(1);
			}
			}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method findClientSuperUserIdByClientNo:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}				
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects findClientSuperUserIdByClientNo:\n"+sqle.getMessage());
			}
		}
	return data;	
	}

	public static String findContactKeyById(int contactId, String token) {
		PreparedStatement ps = null;		
		ResultSet rs=null;			
		String data="NA";
		
		Connection con = DbCon.getCon("","","");
		try{
			StringBuffer sb=new StringBuffer("select ccbrefid from clientcontactbox where ccbid='"+contactId+"' and cctokenno='"+token+"'");
			ps=con.prepareStatement(sb.toString());
			rs=ps.executeQuery();
			if(rs.next()){
				data=rs.getString(1);
			}
			}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method findContactKeyById:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}				
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects findContactKeyById:\n"+sqle.getMessage());
			}
		}
	return data;	
	}

	public static String[][] fetchAllClientsBySuperUser(String uaid,String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			StringBuffer query = new StringBuffer("select cregname,creguid from hrmclient_reg where super_user_uaid='"+uaid+"' and cregtokenno='"+token+"' ");
			
//			System.out.println(query);
			
			stmnt = getacces_con.prepareStatement(query.toString());
			rsGCD = stmnt.executeQuery();
			rsGCD.last();
			int row = rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd = rsGCD.getMetaData();
			int col = rsmd.getColumnCount();
			newsdata = new String[row][col];
			int rr = 0;
			while (rsGCD != null && rsGCD.next()) {
				for (int i = 0; i < col; i++) {
					newsdata[rr][i] = rsGCD.getString(i + 1);
				}
				rr++;
			}
		} catch (Exception e) {
			log.info("Error in fetchAllClientsBySuperUser method \n"+e.getMessage());
		} finally {

			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if(rsGCD!=null) rsGCD.close();
			} catch (SQLException sqle) {
				log.info("Error in fetchAllClientsBySuperUser method \n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	
	public static String[][] findUserCompanyPermission(String uaid,String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String queryselect = "SELECT h.creguid,h.cregclientrefid,h.cregaddedon,h.cregname FROM "
					+ "hrmclient_reg h join client_user_info c on h.creguid=c.client_id where c.user_id='"+uaid+"'"
							+ " and c.token='"+token+"'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rsGCD = ps.executeQuery();
			rsGCD.last();
			int row = rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd = rsGCD.getMetaData();
			int col = rsmd.getColumnCount();
			newsdata = new String[row][col];
			int rr = 0;
			while (rsGCD != null && rsGCD.next()) {
				for (int i = 0; i < col; i++) {
					newsdata[rr][i] = rsGCD.getString(i + 1);
				}
				rr++;
			}
		} catch (Exception e) {
			log.info("findUserCompanyPermission in Enquiry_ACT"+e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if(rsGCD!=null) rsGCD.close();
			} catch (SQLException e) {
				log.info("findUserCompanyPermission in Enquiry_ACT"+e.getMessage());
			}
		}
		return newsdata;
	}
	public static String findCompanyIndustry(String clientKey, String token) {
		PreparedStatement ps = null;
		String query = null;
		Connection con = DbCon.getCon("", "", "");
		ResultSet rs = null;
		String data = "NA";
		try {
			query = "select cregindustry from hrmclient_reg where cregclientrefid='"
					+ clientKey + "' and cregtokenno='" + token + "'";
			ps = con.prepareStatement(query);
			rs = ps.executeQuery();
			if (rs.next())
				data = rs.getString(1);

		} catch (Exception e) {
			log.info("findCompanyIndustry()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects findCompanyIndustry:\n" + sqle.getMessage());
			}
		}
		return data;
	}

	public static boolean saveManageInvoice(String key,String invoiceType, String refInvoice, String billTo, String gstin,
			String shipTo, String placeOfSupply, String loginuaid, String uavalidtokenno,String postDate,String invoice_no,
			double orderAmount,double dueAmount) {
		PreparedStatement ps = null;	
		ResultSet rs=null;
		Connection con = DbCon.getCon("","","");
		boolean status=false;
		try{
			String query = "insert into manage_invoice(refkey,type,ref_invoice,bill_to,gstin,ship_to,place_supply,"
					+ "post_date,token,user_uaid,total_price,invoice_no,due_amount) values(?,?,?,?,?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);	
			ps.setString(1,key );
			ps.setString(2,invoiceType );
			ps.setString(3,refInvoice );
			ps.setString(4,billTo );
			ps.setString(5,gstin);
			ps.setString(6,shipTo);
			ps.setString(7,placeOfSupply);
			ps.setString(8,postDate);
			ps.setString(9,uavalidtokenno);
			ps.setString(10,loginuaid);
			ps.setDouble(11, orderAmount);
			ps.setString(12, invoice_no);
			ps.setDouble(13, dueAmount);
			
			int k=ps.executeUpdate();
			if(k>0)status=true;
		}
		catch (Exception e) {
			e.printStackTrace();
			log.info("Error in Clientmaster_ACT method saveManageInvoice:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(rs!=null) {rs.close();}	
				if(con!=null) {con.close();}			
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects saveManageInvoice:\n"+sqle.getMessage());
			}
		}	
		return status;
	}


	public static boolean saveInvoiceProduct(String ipKey, String key, String serviceName) {
		PreparedStatement ps = null;	
		ResultSet rs=null;
		Connection con = DbCon.getCon("","","");
		boolean status=false;
		try{
			String query = "insert into invoice_product(refkey,invoice_key,service_name) values(?,?,?)";
			ps = con.prepareStatement(query);	
			ps.setString(1,ipKey);
			ps.setString(2,key );
			ps.setString(3,serviceName );
			int k=ps.executeUpdate();
			if(k>0)status=true;
		}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method saveInvoiceProduct:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(rs!=null) {rs.close();}	
				if(con!=null) {con.close();}			
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects saveInvoiceProduct:\n"+sqle.getMessage());
			}
		}	
		return status;
	}

	public static void saveInvoiceProductItem(String ipKey, String feeType, double price, String hsn,
			double cgstPercent, double sgstPercent, double igstPercent, double cgstPrice, double sgstPrice,
			double igstPrice, double totalAmount) {
		PreparedStatement ps = null;	
		ResultSet rs=null;
		Connection con = DbCon.getCon("","","");
		try{
			String query = "insert into invoice_product_items(invoice_product_key,fee_type,price,hsn,cgst_percent,"
					+ "sgst_percent,igst_percent,cgst_price,sgst_price,igst_price,total_price) "
					+ "values(?,?,?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);	
			ps.setString(1,ipKey);
			ps.setString(2,feeType );
			ps.setDouble(3,price );
			ps.setString(4, hsn);
			ps.setDouble(5,cgstPercent );
			ps.setDouble(6,sgstPercent );
			ps.setDouble(7,igstPercent );
			ps.setDouble(8,cgstPrice );
			ps.setDouble(9,sgstPrice );
			ps.setDouble(10,igstPrice );
			ps.setDouble(11,totalAmount );
			
			ps.execute();
			
		}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method saveInvoiceProductItem:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(rs!=null) {rs.close();}	
				if(con!=null) {con.close();}			
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects saveInvoiceProductItem:\n"+sqle.getMessage());
			}
		}	
	}

	public static boolean updateManageInvoiceBillingAmount(String key, double totalAmount, String uavalidtokenno) {
		boolean status=false;
		PreparedStatement ps = null;	
		Connection con = DbCon.getCon("","","");
		try{		    
			  ps=con.prepareStatement("update manage_invoice set total_price=? where refkey=? and token=?");
			  ps.setDouble(1, totalAmount);
			  ps.setString(2, key);
			  ps.setString(3, uavalidtokenno);
			 
			  
			  int k=ps.executeUpdate();
			  if(k>0) status=true;
			}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method updateManageInvoiceBillingAmount:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateManageInvoiceBillingAmount:\n"+sqle.getMessage());
			}
		}	
		return status;
	}
	
	public static boolean updateManageInvoiceDueAmount(String type,String refInvoice, double dueAmount, String uavalidtokenno) {
		boolean status=false;
		PreparedStatement ps = null;	
		Connection con = DbCon.getCon("","","");
		try{		    
			  ps=con.prepareStatement("update manage_invoice set due_amount=?,active_status=? where type=? and ref_invoice=? and token=?");
			  ps.setDouble(1, dueAmount);
			  ps.setBoolean(2, true);
			  ps.setString(3, type);
			  ps.setString(4, refInvoice);
			  ps.setString(5, uavalidtokenno);
			  
			  int k=ps.executeUpdate();
			  if(k>0) status=true;
			}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method updateManageInvoiceDueAmount:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateManageInvoiceDueAmount:\n"+sqle.getMessage());
			}
		}	
		return status;
	}

	public static boolean isInvoiceExist(String invoiceType, String refInvoice, String uavalidtokenno) {
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rs=null;
		boolean flag=false;
		try{
			getacces_con=DbCon.getCon("","","");				
			stmnt=getacces_con.prepareStatement("select id from manage_invoice where type='"+invoiceType+"' and ref_invoice='"+refInvoice+"' and token='"+uavalidtokenno+"'");
			rs=stmnt.executeQuery();
			if(rs.next())flag=true;			
			
		}catch(Exception e)
		{log.info("Error in Clientmaster_ACT method isInvoiceExist:\n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				log.info("Error in Clientmaster_ACT method isInvoiceExist:\n"+sqle.getMessage());
			}
		}
		return flag;
	}
	
	public static String[][] getAllManageInvoice(String invoiceTypeFilter,String refInvoiceNumber,
			String invoiceNo,String invoiceClient,String dateRange,String token,
			int page,int rows,String sort,String order) {
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		String fromDate="NA";
		String toDate="NA";
		try{
			if(!dateRange.equalsIgnoreCase("NA")){
				fromDate=dateRange.substring(0,10).trim();
				fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.substring(0,2);
				toDate=dateRange.substring(13).trim();
				toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2);
			}
			getacces_con=DbCon.getCon("","","");
			StringBuffer query=new StringBuffer("SELECT refkey,type,ref_invoice,bill_to,total_price,"
					+ "substring(post_date,1,10) as post_date,invoice_no FROM manage_invoice WHERE active_status='1' and token='"+token+"' ");
			if(!invoiceTypeFilter.equalsIgnoreCase("All")) {
				if(invoiceTypeFilter.equalsIgnoreCase("PI"))query.append("and type='PI' ");
				else if(invoiceTypeFilter.equalsIgnoreCase("Tax"))query.append("and type='TAX' ");
				else if(invoiceTypeFilter.equalsIgnoreCase("Debit"))query.append("and type='DN' ");
			}
			if(!refInvoiceNumber.equalsIgnoreCase("NA"))
				query.append("and ref_invoice='"+refInvoiceNumber+"' ");
			if(!invoiceNo.equalsIgnoreCase("NA"))
				query.append("and invoice_no='"+invoiceNo+"' ");
			if(!invoiceClient.equalsIgnoreCase("NA"))
				query.append("and bill_to='"+invoiceClient+"' ");
			if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA"))
				query.append(" and substring(post_date,1,10) between '"+fromDate+"' and '"+toDate+"'");
			
			
			if(sort.length()<=0)			
				query.append("order by id desc limit "+((page-1)*rows)+","+rows);
			else if(sort.equals("date"))query.append("order by post_date "+order+" limit "+((page-1)*rows)+","+rows);
			else if(sort.equals("invoice"))query.append("order by cast(SUBSTRING(ref_invoice,6) as invoice) "+order+" limit "+((page-1)*rows)+","+rows);
			else if(sort.equals("client"))query.append("order by bill_to "+order+" limit "+((page-1)*rows)+","+rows);
			else if(sort.equals("amount"))query.append("order by total_price "+order+" limit "+((page-1)*rows)+","+rows);
			
			stmnt=getacces_con.prepareStatement(query.toString());
//			System.out.println(query);
			rsGCD=stmnt.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];
			int rr=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++)
				{
					newsdata[rr][i]=rsGCD.getString(i+1);
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("Error in Clientmaster_ACT method getAllManageInvoice:\n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllManageInvoice:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	
	public static int countAllManageInvoice(String invoiceTypeFilter,String refInvoiceNumber,
			String invoiceNo,String invoiceClient,String dateRange,String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		int newsdata = 0;
		String fromDate="NA";
		String toDate="NA";
		try{
			if(!dateRange.equalsIgnoreCase("NA")){
				fromDate=dateRange.substring(0,10).trim();
				fromDate=fromDate.substring(6)+"-"+fromDate.substring(3,5)+"-"+fromDate.substring(0,2);
				toDate=dateRange.substring(13).trim();
				toDate=toDate.substring(6)+"-"+toDate.substring(3,5)+"-"+toDate.substring(0,2);
			}
			getacces_con=DbCon.getCon("","","");
			StringBuffer query=new StringBuffer("SELECT count(1) FROM manage_invoice WHERE active_status='1' and token='"+token+"'");
			if(!invoiceTypeFilter.equalsIgnoreCase("All")) {
				if(invoiceTypeFilter.equalsIgnoreCase("PI"))query.append("and type='PI'");
				else if(invoiceTypeFilter.equalsIgnoreCase("Tax"))query.append("and type='TAX'");
				else if(invoiceTypeFilter.equalsIgnoreCase("Debit"))query.append("and type='DN'");
			}		
			if(!refInvoiceNumber.equalsIgnoreCase("NA"))
				query.append("and ref_invoice='"+refInvoiceNumber+"' ");
			if(!invoiceNo.equalsIgnoreCase("NA"))
				query.append("and invoice_no='"+invoiceNo+"' ");
			if(!invoiceClient.equalsIgnoreCase("NA"))
				query.append("and bill_to='"+invoiceClient+"' ");
			if(!fromDate.equalsIgnoreCase("NA")&&!toDate.equalsIgnoreCase("NA"))
				query.append(" and substring(post_date,1,10) between '"+fromDate+"' and '"+toDate+"'");
//			System.out.println(query.toString());
			stmnt=getacces_con.prepareStatement(query.toString());
			rsGCD=stmnt.executeQuery();			
			if(rsGCD!=null && rsGCD.next()){
				newsdata=rsGCD.getInt(1);				
			}
		}catch(Exception e)
		{log.info("Error in Clientmaster_ACT method countAllManageInvoice:\n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects countAllManageInvoice:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String generateInvoice(String invoiceType, String uavalidtokenno) {
		PreparedStatement ps = null;
		String query = null;
		Connection con = DbCon.getCon("", "", "");
		ResultSet rs = null;
		String data = "NA";
		try {
			query = "select invoice_no from manage_invoice where type='"+invoiceType+"' and token='" + uavalidtokenno + "' order by id desc limit 1";
			ps = con.prepareStatement(query);
			rs = ps.executeQuery();
			if (rs.next())
				data = rs.getString(1);

		} catch (Exception e) {
			log.info("generateInvoice()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects generateInvoice:\n" + sqle.getMessage());
			}
		}
		return data;
	}

	public static boolean updateManageInvoiceBillingAmount(String refkey, String billTo, String gstin, String shipTo,
			String placeOfSupply, String loginuaid, String uavalidtokenno) {
		boolean status=false;
		PreparedStatement ps = null;	
		Connection con = DbCon.getCon("","","");
		try{		    
			  ps=con.prepareStatement("update manage_invoice set bill_to=?,gstin=?,ship_to=?,place_supply=?,"
			  		+ "user_uaid=? where refkey=? and token=?");
			  ps.setString(1, billTo);
			  ps.setString(2, gstin);
			  ps.setString(3, shipTo);
			  ps.setString(4, placeOfSupply);
			  ps.setString(5, loginuaid);
			  ps.setString(6, refkey);
			  ps.setString(7, uavalidtokenno);
			  
			  int k=ps.executeUpdate();
			  if(k>0) status=true;
			}
		catch (Exception e) {
			e.printStackTrace();
			log.info("Error in Clientmaster_ACT method updateManageInvoiceBillingAmount:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateManageInvoiceBillingAmount:\n"+sqle.getMessage());
			}
		}	
		return status;
	}

	public static int getManageInvoiceIdByKey(String key, String uavalidtokenno) {
		PreparedStatement ps = null;
		String query = null;
		Connection con = DbCon.getCon("", "", "");
		ResultSet rs = null;
		int data = 0;
		try {
			query = "select id from manage_invoice where refkey='"+key+"' and token='" + uavalidtokenno + "'";
			ps = con.prepareStatement(query);
			rs = ps.executeQuery();
			if (rs.next())
				data = rs.getInt(1);

		} catch (Exception e) {
			log.info("getManageInvoiceIdByKey()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getManageInvoiceIdByKey:\n" + sqle.getMessage());
			}
		}
		return data;
	}

	public static boolean updateTaxInvoiceReminder(int paymentId,int manageInvoiceId, boolean activeStatus, String startDate, String endDate,
			String reminderDate) {
		boolean status=false;
		PreparedStatement ps = null;	
		Connection con = DbCon.getCon("","","");
		try{		    
			  ps=con.prepareStatement("update po_reminder set invoice_id=?,active_status=?,start_date=?,end_date=?,"
			  		+ "reminder_date=? where payment_id=?");
			  ps.setInt(1, manageInvoiceId);
			  ps.setBoolean(2, activeStatus);
			  ps.setString(3, startDate);
			  ps.setString(4, endDate);
			  ps.setString(5, reminderDate);
			  ps.setInt(6, paymentId);
			  
			  int k=ps.executeUpdate();
			  if(k>0) status=true;
			}
		catch (Exception e) {
			e.printStackTrace();
			log.info("Error in Clientmaster_ACT method updateTaxInvoiceReminder:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects updateTaxInvoiceReminder:\n"+sqle.getMessage());
			}
		}	
		return status;
	}

	public static String[][] fetchPurchasePayment(String today) {
		Connection getacces_con = null;
		PreparedStatement stmnt=null;
		ResultSet rsGCD=null;
		String[][] newsdata = null;
		try{
			getacces_con=DbCon.getCon("","","");
			String query="select p.id,p.payment_id,p.invoice_id,p.start_date,p.end_date,m.bill_to,"
					+ "sp.po_validity,sp.stransactionid,m.invoice_no,m.due_amount,sp.sapprovedby"
					+ ",sp.saddedbyuid,m.refkey,m.ref_invoice from po_reminder p "
					+ "INNER JOIN manage_invoice m on p.invoice_id=m.id "
					+ "INNER JOIN salesestimatepayment sp on p.payment_id=sp.sid "
					+ "where p.reminder_date='"+today+"' and p.active_status=true "
					+ "group by p.id";
			stmnt=getacces_con.prepareStatement(query);
			rsGCD=stmnt.executeQuery();
			rsGCD.last();
			int row=rsGCD.getRow();
			rsGCD.beforeFirst();
			ResultSetMetaData rsmd=rsGCD.getMetaData();
			int col=rsmd.getColumnCount();
			newsdata=new String[row][col];
			int rr=0;
			while(rsGCD!=null && rsGCD.next()){
				for(int i=0;i<col;i++)
				{
					newsdata[rr][i]=rsGCD.getString(i+1);
				}
				rr++;
			}
		}catch(Exception e)
		{log.info("Error in Clientmaster_ACT method fetchPurchasePayment:\n"+e.getMessage());}
		finally{
			try{
				if(stmnt!=null) {stmnt.close();}
				if(getacces_con!=null) {getacces_con.close();}
				if(rsGCD!=null) rsGCD.close();
			}catch(SQLException sqle){
				log.info("Error in Clientmaster_ACT method fetchPurchasePayment:\n"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String getClientCountryByKey(String compKey, String token) {
		PreparedStatement ps = null;	
		ResultSet rs=null;
		String data="NA";
		Connection con = DbCon.getCon("","","");
		try{
		    ps=con.prepareStatement("select cregcountry from hrmclient_reg where cregclientrefid='"+compKey+"' and cregtokenno='"+token+"'");
		    rs=ps.executeQuery();
		    if(rs.next())data=rs.getString(1);
		  
			}
		catch (Exception e) {
			log.info("Error in Clientmaster_ACT method getLoginUserName:\n"+e.getMessage());
		}
		finally{
			try{
				if(ps!=null) {ps.close();}
				if(con!=null) {con.close();}
				if(rs!=null) {rs.close();}
			}catch(SQLException sqle){
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getLoginUserName:\n"+sqle.getMessage());
			}
		}
		return data;
	}


}