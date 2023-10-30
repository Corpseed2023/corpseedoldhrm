package company_master;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

import org.apache.log4j.Logger;

import commons.DbCon;

public class CompanyMaster_ACT {

	private static Logger log = Logger.getLogger(CompanyMaster_ACT.class);

	/* For providing uniqueid to company */
	public static String getuniquecode() {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = null;
		try {
			String queryselect = "SELECT MAX(CAST((SUBSTRING(compuid,3)) as UNSIGNED)) AS maxval FROM company_master";
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getuniquecode"+e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if(rset!=null) rset.close();
			} catch (SQLException e) {
				log.info("getuniquecode"+e.getMessage());
			}
		}
		return getinfo;
	}
// inserting data into initial_master
	public static boolean saveInitialData(String compname, String employeekey, String gstinvoice, String clientkey,
			String projectkey, String unbilledkey, String taskkey, String enquirykey, String nongstinvoicekey, String compaddedby,
			String today, String tokenno,String productskey,String estimatebillkey,
			String expensekey,String transferkey,String triggerkey,String invoicekey) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "insert into initial_master (imcompany, imemployeekey, imgstkey, imclientkey, improjectkey,imbillingkey, imtaskkey,imenquirykey, imnongstkey, imstatus, 	imaddedby, 	imlastupdatedon,imtokenno,improductskey,imestimatebillingkey,imexpensekey,imtransferkey,imtriggerkey,iminvoicekey) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			
			ps = con.prepareStatement(query);
			ps.setString(1, compname);ps.setString(2, employeekey);ps.setString(3, gstinvoice);ps.setString(4, clientkey);ps.setString(5, projectkey);ps.setString(6, unbilledkey);ps.setString(7, taskkey);
			ps.setString(8, enquirykey);ps.setString(9, nongstinvoicekey);ps.setString(10, "1");ps.setString(11, compaddedby);ps.setString(12, today);ps.setString(13, tokenno);ps.setString(14, productskey);ps.setString(15, estimatebillkey);
			ps.setString(16, expensekey);ps.setString(17, transferkey);ps.setString(18, triggerkey);ps.setString(19, invoicekey);
			int k=ps.executeUpdate();
			if(k>0)
			status = true;
		} catch (Exception e) {
			log.info("saveInitialData"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("saveInitialData"+sqle.getMessage());
			}
		}
		return status;
	}
	public static boolean saveCompanyDetail(String compuid, String compname, String compaddress, String comppan,
			String compgstin, String compstatecode, String compbankname, String compbankaccname, String compbankacc, String compbankifsc,
			String compbankaddress, String compaddedby,String mobile,String email,String tokenno) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "insert into company_master (compuid, compname, compaddress, comppan, compgstin,compstatecode, compbankname,compbankaccname, compbankacc, compbankifsc, compbankaddress, compaddedby,compstatus,compmobile,compemail,comptokenno) values ('"
					+ compuid + "', '" + compname + "', '" + compaddress + "', '" + comppan + "', '" + compgstin + "','"
					+ compstatecode + "', '" + compbankname + "', '"+compbankaccname+"' , '" + compbankacc + "', '" + compbankifsc + "', '"
					+ compbankaddress + "', '" + compaddedby + "','1','"+mobile+"','"+email+"','"+tokenno+"')";
			ps = con.prepareStatement(query);
			int k=ps.executeUpdate();
			if(k>0)
			status = true;
		} catch (Exception e) {
			log.info("saveCompanyDetail"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("saveCompanyDetail"+sqle.getMessage());
			}
		}
		return status;
	}

	public static String[][] getAllCompany(String token, String userrole, String name, String from, String to) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer query = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			if(name==null || name.equalsIgnoreCase("null") || name.length() <= 0){ name ="NA";}
			if(from==null || from.equalsIgnoreCase("null") || from.length() <= 0){ from ="NA";}
			if(to==null || to.equalsIgnoreCase("null") || to.length() <= 0){ to ="NA";}
			query = new StringBuffer("SELECT compid, compname, comppan, compgstin, compstatecode, compbankname,compbankaccname,compbankacc,compbankifsc,compstatus,compmobile,compemail,compuid FROM company_master where compstatus!='2' and compstatus!='NA'");
			if(!userrole.equalsIgnoreCase("super admin"))
				query.append(" and comptokenno='"+token+"'");
			
			
			if(name!="NA") query.append(" and compname='"+name+"'");
			if(from!="NA"&&to=="NA") query.append(" and compaddedon like '"+from+"%'");
			if(from!="NA"&&to!="NA") query.append(" and compaddedon between '"+from+"%' and '"+to+"%'");
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
			log.info("getAllCompany"+e.getMessage());
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
				log.info("getAllCompany"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	public static String[][] getKey(String tokenno) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			String query = "SELECT imemployeekey,imgstkey, imclientkey, improjectkey, imbillingkey, imtaskkey, imenquirykey, imnongstkey FROM initial_master where 	imtokenno='"
					+ tokenno + "' ";

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
			log.info("getKey"+e.getMessage());
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
				log.info("getKey"+sqle.getMessage());
			}
		}
		return newsdata;
	}
	
	
	public static String[][] getCompanyByID(String compid) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			String query = "SELECT compid, compuid, compname, compaddress, comppan, compgstin, compstatecode, compbankname, compbankacc, compbankifsc, compbankaddress,compbankaccname,	compmobile,compemail,comptokenno FROM company_master where compid='"
					+ compid + "' ";

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
			log.info("getCompanyByID"+e.getMessage());
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
				log.info("getCompanyByID"+sqle.getMessage());
			}
		}
		return newsdata;
	}

	@SuppressWarnings("resource")
	public static void deleteCompany(String uid,String status,String compuid) {
		PreparedStatement ps = null;
		
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "update company_master set compstatus='"+status+"' WHERE compid ='" + uid + "'";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
			ps = con.prepareStatement("update user_account set uastatus='"+status+"' where uaempid='"+compuid+"'");
			ps.executeUpdate();
			
		} catch (Exception e) {
			log.info("deleteCompany"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("deleteCompany"+sqle.getMessage());
			}
		}
		
	}

	public static boolean updateCompanyDetail(String compuid, String compaddress, String comppan,
			String compgstin, String compstatecode, String compbankname, String compbankacc, String compbankifsc,
			String compbankaddress, String compaddedby, String compbankaccname,String compname,String mobile,String email) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "update company_master set compname='"+compname+"',compmobile='"+mobile+"',compemail='"+email+"', compaddress ='"+compaddress+"', comppan ='"+comppan+"', compgstin ='"+compgstin+"',compstatecode ='"+compstatecode+"', compbankname ='"+compbankname+"', compbankacc ='"+compbankacc+"', compbankifsc ='"+compbankifsc+"', compbankaddress ='"+compbankaddress+"', compaddedby ='"+compaddedby+"',compbankaccname='"+compbankaccname+"' where compuid = '"+compuid+"'";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("updateCompanyDetail"+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("updateCompanyDetail"+sqle.getMessage());
			}
		}
		return status;
	}
	//checking value already existed or not
		public static boolean isExistEditValue(String val,String condcolumn,String prodrefid,String token,String servicetype) {
			PreparedStatement ps = null;
			Connection con = DbCon.getCon("", "", "");
			ResultSet rs=null;
			boolean result=false;
			String query=null;
			try {
					query="select pid from product_master where "+condcolumn+"='"+val+"' and prefid!='"+prodrefid+"' and ptokenno='"+token+"' and ptype='"+servicetype+"'";
//				System.out.println(query);
				ps=con.prepareStatement(query);
				rs=ps.executeQuery();
				if(rs.next())result=true;
					
			}catch(Exception e) {
				log.info("isExistEditValue"+e.getMessage());
			}
			finally {
				try {
				if(ps!=null)ps.close();
				if(con!=null)con.close();
				if(rs!=null)rs.close();
				}catch(Exception e) {
					log.info("isExistEditValue"+e.getMessage());
				}
			}
			
			return result;
		}
		//checking value already existed or not
		public static boolean isExistHSNValue(String value,String token) {
			PreparedStatement ps = null;
			Connection con = DbCon.getCon("", "", "");
			ResultSet rs=null;
			boolean result=false;
			String query=null;
			try {
					query="select mtid from managetaxctrl where mthsncode='"+value+"' and mttoken='"+token+"'";
//				System.out.println(query);
				ps=con.prepareStatement(query);
				rs=ps.executeQuery();
				if(rs.next())result=true;
					
			}catch(Exception e) {
				log.info("isExistHSNValue"+e.getMessage());
			}
			finally {
				try {
				if(ps!=null)ps.close();
				if(con!=null)con.close();
				if(rs!=null)rs.close();
				}catch(Exception e) {
					log.info("isExistHSNValue"+e.getMessage());
				}
			}
			
			return result;
		}		

		public static boolean isExistEditFormName(String formName,String templateKey,String token) {
			PreparedStatement ps = null;
			Connection con = DbCon.getCon("", "", "");
			ResultSet rs=null;
			boolean result=false;
			String query=null;
			try {
					query="select tid from manage_template where tname='"+formName+"' and ttype='form' and tstatus='1' and ttokenno='"+token+"' and tkey!='"+templateKey+"'";
//				System.out.println(query);
				ps=con.prepareStatement(query);
				rs=ps.executeQuery();
				if(rs.next())result=true;
					
			}catch(Exception e) {
				log.info("isExistEditFormName"+e.getMessage());
			}
			finally {
				try {
				if(ps!=null)ps.close();
				if(con!=null)con.close();
				if(rs!=null)rs.close();
				}catch(Exception e) {
					log.info("isExistEditFormName"+e.getMessage());
				}
			}
			
			return result;
		}
		
		public static boolean isExistFormName(String formName,String token) {
			PreparedStatement ps = null;
			Connection con = DbCon.getCon("", "", "");
			ResultSet rs=null;
			boolean result=false;
			String query=null;
			try {
					query="select tid from manage_template where tname='"+formName+"' and ttype='form' and tstatus='1' and ttokenno='"+token+"'";
//				System.out.println(query);
				ps=con.prepareStatement(query);
				rs=ps.executeQuery();
				if(rs.next())result=true;
					
			}catch(Exception e) {
				log.info("isExistFormName"+e.getMessage());
			}
			finally {
				try {
				if(ps!=null)ps.close();
				if(con!=null)con.close();
				if(rs!=null)rs.close();
				}catch(Exception e) {
					log.info("isExistFormName"+e.getMessage());
				}
			}
			
			return result;
		}
		
//checking value already existed or not
	public static boolean isExistValue(String tablename,String tableid,String val,String condcolumn,String servicecol,String servicetype,String tokencol,String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		ResultSet rs=null;
		boolean result=false;
		String query=null;
		try {
				query="select "+tableid+" from "+tablename+" where "+condcolumn+"='"+val+"' and "+servicecol+"='"+servicetype+"' and "+tokencol+"='"+token+"'";
//			System.out.println(query);
			ps=con.prepareStatement(query);
			rs=ps.executeQuery();
			if(rs.next())result=true;
				
		}catch(Exception e) {
			log.info("isExistValue"+e.getMessage());
		}
		finally {
			try {
			if(ps!=null)ps.close();
			if(con!=null)con.close();
			if(rs!=null)rs.close();
			}catch(Exception e) {
				log.info("isExistValue"+e.getMessage());
			}
		}
		
		return result;
	}
	
	
//checking value already existed or not
	public static boolean existValue(String field,String val,String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		ResultSet rs=null;
		boolean result=false;
		String query=null;
		try {
			if(field.equalsIgnoreCase("addcontactmobilephone"))
				query="select ccbid from clientcontactbox where ccmobilephone='"+val+"' or ccworkphone='"+val+"'";
									
			if(field.equalsIgnoreCase("addcontactemail1"))
				query="select c.ccbid from clientcontactbox c JOIN employee_master e where c.ccemailfirst='"+val+"' or (c.ccemailsecond='"+val+"' and c.ccemailsecond!='NA') or e.ememail='"+val+"' or e.emememail='"+val+"'";
			
			if(field.equalsIgnoreCase("name"))
			query="select compid from company_master where compname='"+val+"'";
			
			if(field.equalsIgnoreCase("all")) 
				query="select compid from company_master c join employee_master e join hrmclient_reg h where e.emmobile='"+val+"' or (e.emaltmobile='"+val+"'and e.emaltmobile!='NA') or e.ememmobile='"+val+"' or e.ememail='"+val+"' or (e.emaltemail='"+val+"' and e.emaltemail!='NA') or (e.emememail='"+val+"' and e.emememail='"+val+"') or e.empan='"+val+"' or e.embankaccno='"+val+"' or c.compmobile='"+val+"' or c.compemail='"+val+"' or c.comppan='"+val+"' or c.compgstin='"+val+"' or c.compbankacc='"+val+"' or h.cregmob='"+val+"' or h.cregemailid='"+val+"' or h.cregcontemailid='"+val+"' or h.cregcontmobile='"+val+"' or h.cregpan='"+val+"' or h.creggstin='"+val+"' or e.emaadhar='"+val+"'";
		
			if(field.equalsIgnoreCase("ualoginid"))
				query="select uaid from user_account where ualoginid='"+val+"'";
			
			if(field.equalsIgnoreCase("sms_email"))
				query="select tid from manage_template where tname='"+val+"' and ttokenno='"+token+"'";
			
			if(field.equalsIgnoreCase("servicetype"))
				query="select sid from service_type where stypename='"+val+"' and stokenno='"+token+"'";	
				
			if(field.equalsIgnoreCase("product"))
				query="select pid from product_master where pname='"+val+"' and ptokenno='"+token+"'";	
				
			if(field.equalsIgnoreCase("client"))
				query="select creguid from hrmclient_reg where cregmob='"+val+"' or cregcontmobile='"+val+"' or cregname='"+val+"' or (cregemailid='"+val+"' and cregemailid!='NA') or (cregcontemailid='"+val+"' and cregcontemailid!='NA') or (cregpan='"+val+"' and cregpan!='NA') or (creggstin='"+val+"' and creggstin!='NA')";	 
			
			if(field.equalsIgnoreCase("isPan"))	
				query="select h.creguid from hrmclient_reg h INNER JOIN clientcontactbox c on h.cregclientrefid=c.ccbclientrefid where h.cregpan='"+val+"' or c.ccpan='"+val+"'";	
			
			if(field.equalsIgnoreCase("isGST"))	
				query="select creguid from hrmclient_reg where creggstin='"+val+"' and creggstin!='NA'";
			
			if(field.equalsIgnoreCase("isCompany"))	
				query="select creguid from hrmclient_reg where cregname='"+val+"'";	
//				query="select enqid from userenquiry join hrmclient_reg where enqMob='"+val+"' or cregmob='"+val+"' or (enqalterMobNo='"+val+"' and enqalterMobNo!='NA') or (cregcontmobile='"+val+"' and cregcontmobile!='NA') or (enqEmail='"+val+"' and enqEmail!='NA') or (cregemailid='"+val+"' and cregemailid!='NA') or (cregcontemailid='"+val+"' and cregcontemailid!='NA') or enqCompanyName='"+val+"' or cregname='"+val+"' ";	
			
			if(field.equalsIgnoreCase("folder"))																																																																																
				query="select fid from folder_master where fname='"+val+"' and ftokenno='"+token+"'";	
			
			if(field.equalsIgnoreCase("pymttransid"))
				query="select psvid from pymtsalesvirtual where psvtransactionid='"+val+"' and psvtransactionid!='NA'";
			System.out.println(query);
			if(query!=null) {
				ps=con.prepareStatement(query);
				rs=ps.executeQuery();
				if(rs!=null&&rs.next())result=true;
			}	
		}catch(Exception e) {
			log.info("existValue"+e.getMessage());
		}
		finally {
			try {
			if(ps!=null)ps.close();
			if(con!=null)con.close();
			if(rs!=null)rs.close();
			}catch(Exception e) {
				log.info("existValue"+e.getMessage());
			}
		}
		
		return result;
	}

	public static boolean existUserValue(String data,String column) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		ResultSet rs=null;
		boolean result=false;
		String query=null;
		try {
			query="select uaid from user_account where "+column+"='"+data+"'";
//			System.out.println(query);
			ps=con.prepareStatement(query);
			rs=ps.executeQuery();
			if(rs!=null&&rs.next())result=true;
				
		}catch(Exception e) {
			log.info("existUserValue"+e.getMessage());
		}
		finally {
			try {
			if(ps!=null)ps.close();
			if(con!=null)con.close();
			if(rs!=null)rs.close();
			}catch(Exception e) {
				log.info("existUserValue"+e.getMessage());
			}
		}
		
		return result;
	}
	
	//checking value already existed or not except one value
		public static boolean existEditValue(String field,String val,String id,String token) {
			PreparedStatement ps = null;
			Connection con = DbCon.getCon("", "", "");
			ResultSet rs=null;
			boolean result=false;
			String query=null;
			try {
				if(field.equalsIgnoreCase("isEditGST"))
					query="select creguid from hrmclient_reg where creggstin='"+val+"' and cregclientrefid!='"+id+"'";
				
				if(field.equalsIgnoreCase("isEditPan"))
					query="select h.creguid from hrmclient_reg h INNER JOIN clientcontactbox c where (h.cregpan='"+val+"' and cregclientrefid!='"+id+"') or c.ccpan='"+val+"'";
				
				if(field.equalsIgnoreCase("isEditPanContact"))
					query="select c.ccbid from clientcontactbox c INNER JOIN hrmclient_reg h on c.ccbclientrefid=h.cregclientrefid  where h.cregpan='"+val+"' or (c.ccpan='"+val+"' and c.ccbrefid!='"+id+"')";
								
				if(field.equalsIgnoreCase("updatecontactmobilephone"))
					query="select ccbid from clientcontactbox where (ccmobilephone='"+val+"' and ccbrefid!='"+id+"') or (ccworkphone='"+val+"' and ccbrefid!='"+id+"')";
								
				if(field.equalsIgnoreCase("updatecontactemail"))
					query="select ccbid from clientcontactbox where (ccemailfirst='"+val+"' and ccbrefid!='"+id+"') or (ccemailsecond='"+val+"' and ccemailsecond!='NA' and ccbrefid!='"+id+"')";
				
				if(field.equalsIgnoreCase("name"))
				query="select compid from company_master where compname='"+val+"' and compid!='"+id+"'";
				
				if(field.equalsIgnoreCase("all")) 
				query="select compid from company_master c join employee_master e join hrmclient_reg h where e.emmobile='"+val+"' or (e.emaltmobile='"+val+"'and e.emaltmobile!='NA') or e.ememmobile='"+val+"' or e.ememail='"+val+"' or (e.emaltemail='"+val+"' and e.emaltemail!='NA') or e.emememail='"+val+"' or e.empan='"+val+"' or e.embankaccno='"+val+"' or (c.compmobile='"+val+"' and compid!='"+id+"') or (c.compemail='"+val+"' and compid!='"+id+"') or (c.comppan='"+val+"' and compid!='"+id+"') or (c.compgstin='"+val+"' and compid!='"+id+"') or (c.compbankacc='"+val+"' and compid!='"+id+"') or h.cregmob='"+val+"' or h.cregemailid='"+val+"' or h.cregcontemailid='"+val+"' or h.cregcontmobile='"+val+"' or h.cregpan='"+val+"' or h.creggstin='"+val+"'";
				
				if(field.equalsIgnoreCase("employeeall")) 
					query="select compid from company_master c join employee_master e join hrmclient_reg h where (e.emmobile='"+val+"' and e.emid!='"+id+"') or (e.emaadhar='"+val+"' and e.emid!='"+id+"') or (e.emaltmobile='"+val+"' and e.emaltmobile!='NA' and e.emid!='"+id+"') or (e.ememmobile='"+val+"' and e.emid!='"+id+"') or (e.ememail='"+val+"' and e.emid!='"+id+"') or (e.emaltemail='"+val+"' and e.emaltemail!='NA' and e.emid!='"+id+"') or (e.emememail='"+val+"' and e.emid!='"+id+"' ) or (e.empan='"+val+"' and e.emid!='"+id+"') or (e.embankaccno='"+val+"' and emid!='"+id+"') or c.compmobile='"+val+"' or c.compemail='"+val+"' or c.comppan='"+val+"' or c.compgstin='"+val+"' or c.compbankacc='"+val+"' or h.cregmob='"+val+"' or h.cregemailid='"+val+"' or h.cregcontemailid='"+val+"' or h.cregcontmobile='"+val+"' or h.cregpan='"+val+"' or h.creggstin='"+val+"'";
					
				
				if(field.equalsIgnoreCase("ualoginid"))
					query="select uaid from user_account where ualoginid='"+val+"' and uaid!='"+id+"'";
					
				if(field.equalsIgnoreCase("product"))
					query="select pid from product_master where (pname='"+val+"' and pid!='"+id+"') and ptokenno='"+token+"'";
					
					if(field.equalsIgnoreCase("sms_email"))
						query="select tid from manage_template where (tname='"+val+"' and tid!='"+id+"') and ttokenno='"+token+"'";
						
					if(field.equalsIgnoreCase("client"))
						query="select creguid from hrmclient_reg where (cregmob='"+val+"' and creguid!='"+id+"') or (cregcontmobile='"+val+"' and creguid!='"+id+"') or (cregname='"+val+"' and creguid!='"+id+"') or (cregemailid='"+val+"' and cregemailid!='NA' and creguid!='"+id+"') or (cregcontemailid='"+val+"' and cregcontemailid!='NA' and creguid!='"+id+"') or (cregpan='"+val+"' and cregpan!='NA' and creguid!='"+id+"') or (creggstin='"+val+"' and creggstin!='NA' and creguid!='"+id+"')";	
					
					if(field.equalsIgnoreCase("addEnquiry"))																																																																																
						query="select enqid from userenquiry join hrmclient_reg where (enqMob='"+val+"' and enqid!='"+id+"') or cregmob='"+val+"' or (enqalterMobNo='"+val+"' and enqalterMobNo!='NA'  and enqid!='"+id+"') or (cregcontmobile='"+val+"' and cregcontmobile!='NA') or (enqEmail='"+val+"' and enqEmail!='NA' and enqid!='"+id+"') or (cregemailid='"+val+"' and cregemailid!='NA') or (cregcontemailid='"+val+"' and cregcontemailid!='NA') or (enqCompanyName='"+val+"'  and enqid!='"+id+"') or cregname='"+val+"' ";	
										
					
				ps=con.prepareStatement(query);
				rs=ps.executeQuery();
				if(rs.next())result=true;
					
			}catch(Exception e) {
				log.info("existEditValue"+e.getMessage());
			}
			finally {
				try {
				if(ps!=null)ps.close();
				if(con!=null)con.close();
				if(rs!=null)rs.close();
				}catch(Exception e) {
					log.info("existEditValue"+e.getMessage());
				}
			}
			
			return result;
		}
		//checking userid existed in user_account table or not
		public static boolean existUser(String id) {
			PreparedStatement ps = null;
			Connection con = DbCon.getCon("", "", "");
			ResultSet rs=null;
			boolean result=false;
			String query=null;
			try {
				query="select uaempid from user_account where uaempid='"+id+"'";
				
				ps=con.prepareStatement(query);
				rs=ps.executeQuery();
				if(rs.next())result=true;
				
			}catch(Exception e) {
				log.info("existUser"+e.getMessage());
			}
			finally {
				try {
				if(ps!=null)ps.close();
				if(con!=null)con.close();
				if(rs!=null)rs.close();
				}catch(Exception e) {
					log.info("existUser"+e.getMessage());
				}
			}
			
			return result;
		}
		//updating user_account
		public static void updateUserAccount(String compname,String mobile,String email,String compuid) {
			PreparedStatement ps = null;
			Connection con = DbCon.getCon("", "", "");
					
			String query=null;
			try {
				query="update user_account set uaname='"+compname+"',uamobileno='"+mobile+"',uaemailid='"+email+"' where uaempid='"+compuid+"'";
				
				ps=con.prepareStatement(query);
				ps.execute();
				
					
			}catch(Exception e) {
				log.info("updateUserAccount"+e.getMessage());
			}
			finally {
				try {
				if(ps!=null)ps.close();
				if(con!=null)con.close();
				
				}catch(Exception e) {
					log.info("updateUserAccount"+e.getMessage());
				}
			}
		
		}
		public static boolean icClientExists(String clientkey, String val, String token) {
			PreparedStatement ps = null;
			Connection con = DbCon.getCon("", "", "");
			ResultSet rs=null;
			boolean result=false;
			String query=null;
			try {				
				query="select creguid from hrmclient_reg where cregname='"+val+"' and cregtokenno='"+token+"'and cregclientrefid!='"+clientkey+"'";	
				ps=con.prepareStatement(query);
				rs=ps.executeQuery();
				if(rs!=null&&rs.next())result=true;
				
			}catch(Exception e) {
				log.info("icClientExists"+e.getMessage());
			}
			finally {
				try {
				if(ps!=null)ps.close();
				if(con!=null)con.close();
				if(rs!=null)rs.close();
				}catch(Exception e) {
					log.info("icClientExists"+e.getMessage());
				}
			}
			
			return result;
		}		
}
