package admin.enquiry;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang.RandomStringUtils;
import org.apache.log4j.Logger;

import admin.master.Usermaster_ACT;
import admin.task.TaskMaster_ACT;
import commons.DateUtil;
import commons.DbCon;

public class Enquiry_ACT {

	private static Logger log = Logger.getLogger(Enquiry_ACT.class);

	static DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	static Date date = new Date();

	// getting client's total project
	public static int getTotalEstimateQty(String salesno, String token) {
		Connection getacces_con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		int newsdata = 0;
		try {
			getacces_con = DbCon.getCon("", "", "");
			ps = getacces_con.prepareStatement("select count(esid) from estimatesalectrl where estoken='" + token
					+ "' and essaleno='" + salesno + "' group by esrefid");
			rs = ps.executeQuery();
			if (rs.next())
				newsdata = rs.getInt(1);
		} catch (Exception e) {
			log.info("Error in Clientmaster_ACT method getTotalEstimateQty:\n" + e.getMessage());
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error in Clientmaster_ACT method getTotalEstimateQty:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static long findConsultingPercentage(String salesKey, String token, String today) {
		Connection getacces_con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		long newsdata = 0;
		try {
			getacces_con = DbCon.getCon("", "", "");
			ps = getacces_con.prepareStatement(
					"select renewal_value,renewal_type,renewal_end_date,str_to_date(post_date,'%d-%m-%Y') from consulting_sale where sales_key='"
							+ salesKey + "' and token='" + token + "'");
			rs = ps.executeQuery();
			if (rs.next()) {
				int renewal_value = rs.getInt(1);
				String renewal_type = rs.getString(2);
				String renewal_end_date = rs.getString(3);
				String postDate = rs.getString(4);
//				System.out.println(renewal_value+"#"+renewal_type+"#"+renewal_end_date+"#"+postDate);
				if (renewal_end_date == null || renewal_end_date.equalsIgnoreCase("NA"))
					newsdata = 0;
				else {
					long daysBetweenTwoDates = DateUtil.daysBetweenTwoDates(today, renewal_end_date);
//					System.out.println("daysBetweenTwoDates="+daysBetweenTwoDates);
					if (daysBetweenTwoDates < 0)
						newsdata = 100;
					else {
						long daysTwoDates = DateUtil.daysBetweenTwoDates(postDate, renewal_end_date);
//						System.out.println("daysTwoDates="+daysTwoDates);
						long d = 0;
						long a = 0;
						if (renewal_type.equalsIgnoreCase("Day")) {
							d = daysTwoDates / renewal_value;
							a = (daysTwoDates - daysBetweenTwoDates) / renewal_value;
//							System.out.println("Day=="+d+"#"+a);
						} else if (renewal_type.equalsIgnoreCase("Month")) {
							d = (daysTwoDates / 30) / renewal_value;
							a = ((daysTwoDates - daysBetweenTwoDates) / 30) / renewal_value;
//							System.out.println("Month=="+d+"#"+a);
						} else if (renewal_type.equalsIgnoreCase("Year")) {
							d = (daysTwoDates / 365) / renewal_value;
							a = ((daysTwoDates - daysBetweenTwoDates) / 365) / renewal_value;
//							System.out.println("Year=="+d+"#"+a);
						}
						d++;
						a++;
						newsdata = (100 / d) * a;
						if (newsdata > 98)
							newsdata = 100;
					}
				}

			}
		} catch (Exception e) {
			e.printStackTrace();
			log.info("Error in Clientmaster_ACT method findConsultingPercentage:\n" + e.getMessage());
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error in Clientmaster_ACT method findConsultingPercentage:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static long getTotalSalesQty(String role, String uaid, String teamKey, String token) {
		Connection getacces_con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		long newsdata = 0;
		String query = "";
		try {
			getacces_con = DbCon.getCon("", "", "");
			if (role.equals("Admin") || role.equals("Manager"))
				query = "select count(msid) from managesalesctrl where mstoken='" + token + "'";
			else if (role.equals("Assistant") && !teamKey.equals("NA")) {
				query = "select count(msid) from managesalesctrl where mstoken='" + token
						+ "' and exists(select tmid from manageteammemberctrl where tmteamrefid='" + teamKey
						+ "' and tmuseruid=mssoldbyuid) or mssoldbyuid='" + uaid + "'";
			} else {
				query = "select count(msid) from managesalesctrl where mstoken='" + token + "' and mssoldbyuid='" + uaid
						+ "'";
			}
//			System.out.println(query);
			ps = getacces_con.prepareStatement(query);
			rs = ps.executeQuery();
			if (rs.next())
				newsdata = rs.getLong(1);
		} catch (Exception e) {
			log.info("Error in Clientmaster_ACT method getTotalSalesQty:\n" + e.getMessage());
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error in Clientmaster_ACT method getTotalSalesQty:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static long getTotalEstimateQty(String role, String uaid, String teamKey, String token) {
		Connection getacces_con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		long newsdata = 0;
		String query = "";
		try {
			getacces_con = DbCon.getCon("", "", "");
			if (role.equals("Admin") || role.equals("Manager"))
				query = "select count(esid) from estimatesalectrl where estoken='" + token + "'";
			else if (role.equals("Assistant") && !teamKey.equals("NA")) {
				query = "select count(esid) from estimatesalectrl where estoken='" + token
						+ "' and exists(select tmid from manageteammemberctrl where tmteamrefid='" + teamKey
						+ "' and tmuseruid=essoldbyid) or essoldbyid='" + uaid + "'";
			} else {
				query = "select count(esid) from estimatesalectrl where estoken='" + token + "' and essoldbyid='" + uaid
						+ "'";
			}
//			System.out.println(query);
			ps = getacces_con.prepareStatement(query);
			rs = ps.executeQuery();
			if (rs.next())
				newsdata = rs.getLong(1);
		} catch (Exception e) {
			log.info("Error in Clientmaster_ACT method getTotalEstimateQty:\n" + e.getMessage());
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error in Clientmaster_ACT method getTotalEstimateQty:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static boolean updateClientKeyInEstimate(String estKey, String clientkey, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "update estimatesalectrl SET esclientrefid=? WHERE esrefid=? and estoken=?";
			ps = con.prepareStatement(query);
			ps.setString(1, clientkey);
			ps.setString(2, estKey);
			ps.setString(3, token);

			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.updateClientKeyInEstimate " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.updateClientKeyInEstimate " + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean updateClientKeyInContact(String contKey, String clientkey, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "UPDATE clientcontactbox SET ccbclientrefid=? WHERE ccbrefid=? and cctokenno=?";
			ps = con.prepareStatement(query);
			ps.setString(1, clientkey);
			ps.setString(2, contKey);
			ps.setString(3, token);

			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.updateClientKeyInContact " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.updateClientKeyInContact " + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean updateDocumentReUploadStatus(String docrefid, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "UPDATE salesdocumentctrl SET reupload_status=? WHERE sdrefid=? and sdtokenno=?";
			ps = con.prepareStatement(query);
			ps.setString(1, "2");
			ps.setString(2, docrefid);
			ps.setString(3, token);

			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.updateDocumentReUploadStatus " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.updateDocumentReUploadStatus " + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean updateDocumentName(String docrefid, String imgname, String loginuid, String date,
			String token, String assignKey, String workStartPrice) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "UPDATE salesdocumentctrl SET sddocname=?,sduploadedby=?,sduploaddate=?,sdmilestoneuuid=?,sdmilestoneworkpercentage=? WHERE sdrefid=? and sdtokenno=?";
			ps = con.prepareStatement(query);
			ps.setString(1, imgname);
			ps.setString(2, loginuid);
			ps.setString(3, date);
			ps.setString(4, assignKey);
			ps.setString(5, workStartPrice);
			ps.setString(6, docrefid);
			ps.setString(7, token);

			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.updateDocumentName " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.updateDocumentName " + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean updateEstimateToInvoiced(String invoiceno, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "UPDATE estimatesalectrl SET esstatus='Invoiced' WHERE essaleno='" + invoiceno
					+ "' and estoken='" + token + "'";
			ps = con.prepareStatement(query);
			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.updateEstimateToInvoiced " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.updateEstimateToInvoiced " + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean updateBillingInvoice(String invoice, String estinvoice, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "UPDATE hrmclient_billing SET cbinvoiceno='" + invoice
					+ "',cbinvoice_status='3' WHERE cbestimateno='" + estinvoice + "' and cbtokenno='" + token + "'";
			ps = con.prepareStatement(query);
			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.updateBillingInvoice " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.updateBillingInvoice " + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean updateHoldBillingDeclineAmount(String invoiceno, double amount, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "UPDATE hrmclient_billing SET cbholdamount=cbholdamount-" + amount
					+ ",cbholdnotification=cbholdnotification-" + 1 + " WHERE (cbestimateno='" + invoiceno
					+ "' or cbinvoiceno='" + invoiceno + "') and cbtokenno='" + token + "'";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.updateHoldBillingDeclineAmount " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.updateHoldBillingDeclineAmount " + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean updateBillingDeclineAmount(String invoiceno, double amount, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "UPDATE hrmclient_billing SET cbtransactionamount=cbtransactionamount-" + amount
					+ ",cdnotificationcount=cdnotificationcount-" + 1 + " WHERE (cbestimateno='" + invoiceno
					+ "' or cbinvoiceno='" + invoiceno + "') and cbtokenno='" + token + "'";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.updateBillingDeclineAmount " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.updateBillingDeclineAmount " + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean updateBillingHoldAmount(String invoiceno, double amount, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "UPDATE hrmclient_billing SET cbtransactionamount=cbtransactionamount-" + amount
					+ ",cbholdamount=cbholdamount+" + amount + ",cdnotificationcount=cdnotificationcount-" + 1
					+ ",cbholdnotification=cbholdnotification+" + 1 + " WHERE (cbestimateno='" + invoiceno
					+ "' or cbinvoiceno='" + invoiceno + "') and cbtokenno='" + token + "'";
//			System.out.println(query);
			ps = con.prepareStatement(query);
			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.updateBillingHoldAmount " + e.getMessage());
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
				log.info("EnquiryACT.updateBillingHoldAmount " + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean updateBillingRegisterAmount(String invoiceno, double amount, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "UPDATE hrmclient_billing SET cbpaidamount=cbpaidamount+" + amount
					+ ",cbdueamount=cbdueamount-" + amount + " WHERE cbinvoiceno='" + invoiceno + "' and cbtokenno='"
					+ token + "'";
			ps = con.prepareStatement(query);
			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.updateBillingRegisterAmount " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.updateBillingRegisterAmount " + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean updateClientKeyInBilling(String invoiceno, String clientrefkey, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "UPDATE hrmclient_billing SET cbclientrefid='" + clientrefkey + "' WHERE (cbestimateno='"
					+ invoiceno + "' or cbinvoiceno='" + invoiceno + "') and cbtokenno='" + token + "'";
			ps = con.prepareStatement(query);
			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.updateClientKeyInBilling " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.updateClientKeyInBilling " + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean updateHoldBillingAmount(String invoiceno, double amount, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "UPDATE hrmclient_billing SET cbholdamount=cbholdamount-" + amount
					+ ",cbpaidamount=cbpaidamount+" + amount + ",cbdueamount=cbdueamount-" + amount
					+ ",cbholdnotification=cbholdnotification-" + 1 + " WHERE cbdueamount>0 and (cbestimateno='"
					+ invoiceno + "' or cbinvoiceno='" + invoiceno + "') and cbtokenno='" + token + "'";
			ps = con.prepareStatement(query);
			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.updateHoldBillingAmount " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.updateHoldBillingAmount " + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean updateHoldBillingAmountPo(String invoiceno, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "UPDATE hrmclient_billing SET cbholdnotification=cbholdnotification-" + 1
					+ " WHERE (cbestimateno='" + invoiceno + "' or cbinvoiceno='" + invoiceno + "') and cbtokenno='"
					+ token + "'";
			ps = con.prepareStatement(query);
			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.updateHoldBillingAmountPo " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.updateHoldBillingAmountPo " + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean updateInvoiceTaxAmount(int invoiceId, double amount, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "UPDATE manage_invoice SET due_amount=due_amount-" + amount + " WHERE id='" + invoiceId
					+ "' and token='" + token + "'";
			ps = con.prepareStatement(query);
			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.updateInvoiceTaxAmount " + e.getMessage());
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
				log.info("EnquiryACT.updateInvoiceTaxAmount " + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean updateBillingAmount(String invoiceno, double amount, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "UPDATE hrmclient_billing SET cbtransactionamount=cbtransactionamount-" + amount
					+ ",cbpaidamount=cbpaidamount+" + amount + ",cbdueamount=cbdueamount-" + amount
					+ ",cdnotificationcount=cdnotificationcount-" + 1 + " WHERE cbdueamount>0 and (cbestimateno='"
					+ invoiceno + "' or cbinvoiceno='" + invoiceno + "') and cbtokenno='" + token + "'";
			ps = con.prepareStatement(query);
			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.updateBillingAmount " + e.getMessage());
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
				log.info("EnquiryACT.updateBillingAmount " + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean updateBillingAmountPo(String invoiceno, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "UPDATE hrmclient_billing SET cdnotificationcount=cdnotificationcount-" + 1
					+ " WHERE (cbestimateno='" + invoiceno + "' or cbinvoiceno='" + invoiceno + "') and cbtokenno='"
					+ token + "'";
			ps = con.prepareStatement(query);
			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.updateBillingAmountPo " + e.getMessage());
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
				log.info("EnquiryACT.updateBillingAmountPo " + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean updateConsultingBillingAmount(String invoiceno, double amount, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "UPDATE hrmclient_billing SET cborderamount=cborderamount+" + amount
					+ ",cbdueamount=cbdueamount+" + amount + " WHERE cbinvoiceno='" + invoiceno + "' and cbtokenno='"
					+ token + "'";
			ps = con.prepareStatement(query);
			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			e.printStackTrace();
			log.info("EnquiryACT.updateConsultingBillingAmount " + e.getMessage());
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
				log.info("EnquiryACT.updateConsultingBillingAmount " + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean updateBillingDetails(String invoiceno, double amount, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "UPDATE hrmclient_billing SET cbtransactionamount=cbtransactionamount+" + amount
					+ " WHERE (cbestimateno='" + invoiceno + "' or cbinvoiceno='" + invoiceno + "') and cbtokenno='"
					+ token + "'";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.updateBillingDetails " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.updateBillingDetails " + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean updateContactDetails(String salesid, String contactid, String colname, String colvalue,
			String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "UPDATE salescontactboxvirtual SET " + colname
					+ "=? WHERE scvcontactboxid=? and scvtokenno=? and scvsalesid=?";
			ps = con.prepareStatement(query);
			ps.setString(1, colvalue);
			ps.setString(2, contactid);
			ps.setString(3, token);
			ps.setString(4, salesid);

			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.updateContactDetails " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.updateContactDetails " + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean EditEnquiry(String enquid, String enqType, String company, String industry, String enqName,
			String enqMob, String enqEmail, String country, String state, String city, String enqStatus, String enqAdd,
			String enqRemarks, String altermob, String addedby, String token, String productType, String product_name) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "UPDATE userenquiry SET enqType=?, enqName=?,enqMob=?,enqalterMobNo=?, enqEmail = ?,enqCity=?, enqAdd=?,enqStatus=?,enqIndustry=?, enqRemarks = ?,enqAddedby=?,enqCountry=?,enqState=?,enqCompanyName=?,enqproduct_type=?,enqproduct_name=? WHERE enquid=? and enqTokenNo=?";
			ps = con.prepareStatement(query);
			ps.setString(1, enqType);
			ps.setString(2, enqName);
			ps.setString(3, enqMob);
			ps.setString(4, altermob);
			ps.setString(5, enqEmail);
			ps.setString(6, city);
			ps.setString(7, enqAdd);
			ps.setString(8, enqStatus);
			ps.setString(9, industry);
			ps.setString(10, enqRemarks);
			ps.setString(11, addedby);
			ps.setString(12, country);
			ps.setString(13, state);
			ps.setString(14, company);
			ps.setString(15, productType);
			ps.setString(16, product_name);
			ps.setString(17, enquid);
			ps.setString(18, token);
			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.EditEnquiry " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.EditEnquiry " + sqle.getMessage());
			}
		}
		return status;
	}

	public static String[][] getAllPlaceholders(String module) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String queryselect = "SELECT id,value,description FROM placeholders where type='" + module + "'";
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
			log.info("getAllPlaceholders" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getAllPlaceholders" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] findSalesUserPermission(String uaid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String queryselect = "SELECT m.msid,m.msrefid,m.msprojectnumber,m.msinvoiceno,m.msproductname,"
					+ "m.mssolddate FROM managesalesctrl m join user_sales_info u on m.msid=u.sales_id where u.user_id='"
					+ uaid + "'" + " and u.token='" + token + "'";
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
			log.info("findSalesUserPermission in Enquiry_ACT" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("findSalesUserPermission in Enquiry_ACT" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] findEstimateSaleBySaleNo(String saleNo, String mobile, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String queryselect = "SELECT e.esrefid,e.escompany,e.esprodqty,e.esprodname,e.esprodname,e.esregdate,e.esstatus FROM "
					+ "estimatesalectrl e where e.essaleno ='" + saleNo + "' and e.estoken='" + token + "'"
					+ " and exists(select c.cbid from contactboxctrl c where c.cbrefid=e.escontactrefid "
					+ "and (c.cbmobile1st='" + mobile + "' or c.cbmobile2nd='" + mobile + "'))";
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
			log.info("findEstimateSaleBySaleNo in Enquiry_ACT" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("findEstimateSaleBySaleNo in Enquiry_ACT" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getEstimateSaleData(String estimateKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String queryselect = "SELECT essaleno,escontactrefid,esclientrefid,esprodtype,esprodname FROM estimatesalectrl where esrefid ='"
					+ estimateKey + "' and estoken='" + token + "' limit 1";
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
			log.info("getEstimateSaleData in Enquiry_ACT" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getEstimateSaleData in Enquiry_ACT" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getApproveTask(String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String queryselect = "SELECT marefid,masalesrefid,mamilestonerefid,mamilestonename,mamemberassigndate,maassignedbyuid,mateammemberid,machildteamrefid,maapprovalstatus FROM manage_assignctrl where maapprovalstatus!='1' and matokenno='"
					+ token + "'";
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
			log.info("getApproveTask" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getApproveTask" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getSalesCreditHistory(String token, String dateRange, int page, int rows, String sort,
			String order) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		String fromDate = "NA";
		String toDate = "NA";
		try {
			if (!dateRange.equalsIgnoreCase("NA")) {
				fromDate = dateRange.substring(0, 10).trim();
				fromDate = fromDate.substring(6) + "-" + fromDate.substring(3, 5) + "-" + fromDate.substring(0, 2);
				toDate = dateRange.substring(13).trim();
				toDate = toDate.substring(6) + "-" + toDate.substring(3, 5) + "-" + toDate.substring(0, 2);
			}

			StringBuffer queryselect = new StringBuffer(
					"SELECT swkey,swsaleskey,swprojectno,swinvoiceno,swprojectname,swcreditdate,swdepositamt,swremarks FROM salesworkpricectrl where swtokenno='"
							+ token + "'");
			if (!fromDate.equalsIgnoreCase("NA") && !toDate.equalsIgnoreCase("NA")) {
				queryselect.append(" and str_to_date(swaddedon,'%Y-%m-%d')<='" + toDate
						+ "' and str_to_date(swaddedon,'%Y-%m-%d')>='" + fromDate + "'");
			}
			if (sort.length() <= 0)
				queryselect.append("order by swid desc limit " + ((page - 1) * rows) + "," + rows);
			else if (sort.equals("date"))
				queryselect.append("order by swaddedon " + order + " limit " + ((page - 1) * rows) + "," + rows);
			else if (sort.equals("invoice"))
				queryselect.append("order by swinvoiceno " + order + " limit " + ((page - 1) * rows) + "," + rows);
			else if (sort.equals("product"))
				queryselect.append("order by swprojectname " + order + " limit " + ((page - 1) * rows) + "," + rows);
			else if (sort.equals("description"))
				queryselect.append("order by swremarks " + order + " limit " + ((page - 1) * rows) + "," + rows);
			else if (sort.equals("amount"))
				queryselect.append("order by swdepositamt " + order + " limit " + ((page - 1) * rows) + "," + rows);
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect.toString());
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
			log.info("getSalesCreditHistory" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getSalesCreditHistory" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static int countSalesCreditHistory(String token, String dateRange) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		int newsdata = 0;
		String fromDate = "NA";
		String toDate = "NA";
		try {
			if (!dateRange.equalsIgnoreCase("NA")) {
				fromDate = dateRange.substring(0, 10).trim();
				fromDate = fromDate.substring(6) + "-" + fromDate.substring(3, 5) + "-" + fromDate.substring(0, 2);
				toDate = dateRange.substring(13).trim();
				toDate = toDate.substring(6) + "-" + toDate.substring(3, 5) + "-" + toDate.substring(0, 2);
			}

			StringBuffer queryselect = new StringBuffer(
					"SELECT count(swid) FROM salesworkpricectrl where swtokenno='" + token + "'");
			if (!fromDate.equalsIgnoreCase("NA") && !toDate.equalsIgnoreCase("NA")) {
				queryselect.append(" and str_to_date(swaddedon,'%Y-%m-%d')<='" + toDate
						+ "' and str_to_date(swaddedon,'%Y-%m-%d')>='" + fromDate + "'");
			}
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect.toString());
			rsGCD = ps.executeQuery();

			if (rsGCD != null && rsGCD.next()) {
				newsdata = rsGCD.getInt(1);
			}
		} catch (Exception e) {
			log.info("countSalesCreditHistory" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("countSalesCreditHistory" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getSalesByRefId(String srefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String queryselect = "SELECT msrefid,msclientrefid,mscontactrefid,msinvoiceno,msestimateno,mscompany,msproducttype,msproductname,msproductplan,msplanperiod,msplantime,mssoldbyuid,mssolddate,msworkstatus,msassignedtorefid,msworkpriority,msprojectnumber FROM managesalesctrl where msstatus='1' and mstoken='"
					+ token + "' and msrefid='" + srefid + "'";
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
			log.info("getSalesByRefId" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getSalesByRefId" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllDeliveryManager(String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String queryselect = "SELECT uaid,uaname FROM user_account where uadepartment='Delivery' and uarole='Manager' and uastatus='1' and uavalidtokenno='"
					+ token + "'";
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
			log.info("getAllDeliveryManager" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getAllDeliveryManager" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllTeams(String token, String loginUaid, String userRole) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			StringBuffer queryselect = new StringBuffer(
					"SELECT mtid,mtrefid,mtteamname FROM manageteamctrl where mtstatus='1' and mtdepartment='Delivery'");
			if (!userRole.equalsIgnoreCase("Admin"))
				queryselect.append(" and mtadminid='" + loginUaid + "'");
			queryselect.append(" and mttoken='" + token + "'");
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect.toString());
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
			log.info("getAllTeams" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getAllTeams" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static int countAllTaskReport(String token, String projectNo, String assigneeUid) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		int newsdata = 0;
		StringBuffer queryselect = null;
		try {

			queryselect = new StringBuffer("SELECT count(t.id) FROM task_progress t inner join managesalesctrl m"
					+ " on t.sales_key=m.msrefid where t.token='" + token + "'");

			if (!projectNo.equalsIgnoreCase("NA"))
				queryselect.append(" and m.msprojectnumber='" + projectNo + "' ");
			if (!assigneeUid.equalsIgnoreCase("NA"))
				queryselect.append(" and t.assignee_uid='" + assigneeUid + "' ");
//				System.out.println(queryselect);
			ps = con.prepareStatement(queryselect.toString());
			rsGCD = ps.executeQuery();

			if (rsGCD.next())
				newsdata = rsGCD.getInt(1);

		} catch (Exception e) {
			e.printStackTrace();
			log.info("countAllTaskReport" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				e.printStackTrace();
				log.info("countAllTaskReport" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllTaskReport(String token, String projectNo, String assigneeUid, int page, int rows,
			String sort, String order) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer queryselect = null;
		try {

			queryselect = new StringBuffer("SELECT m.msprojectnumber,m.msinvoiceno,m.msproductname,t.* FROM "
					+ "task_progress t inner join managesalesctrl m on t.sales_key=m.msrefid where t.token='" + token
					+ "'");

			if (!projectNo.equalsIgnoreCase("NA"))
				queryselect.append(" and m.msprojectnumber='" + projectNo + "' ");
			if (!assigneeUid.equalsIgnoreCase("NA"))
				queryselect.append(" and t.assignee_uid='" + assigneeUid + "' ");
			if (sort.length() <= 0)
				queryselect.append(" order by t.id desc limit " + ((page - 1) * rows) + "," + rows);
			else if (sort.equals("id"))
				queryselect.append(" order by t.id " + order + " limit " + ((page - 1) * rows) + "," + rows);
			else if (sort.equals("project"))
				queryselect.append(" order by m.msproductname " + order + " limit " + ((page - 1) * rows) + "," + rows);
			else if (sort.equals("milestone"))
				queryselect.append(" order by t.task_name " + order + " limit " + ((page - 1) * rows) + "," + rows);
			else if (sort.equals("assignee"))
				queryselect.append(" order by t.assignee_name " + order + " limit " + ((page - 1) * rows) + "," + rows);

//						System.out.println(queryselect);
			ps = con.prepareStatement(queryselect.toString());
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
			log.info("getAllTaskReport" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getAllTaskReport" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllDeliverySales(String userRole, String loginuaid, String token,
			String deliveryDoAction, String deliveryInvoice, String dateRange, String clientName, String contactName,
			int page, int rows, String sort, String order) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer queryselect = null;
		String fromDate = "NA";
		String toDate = "NA";
		try {

			if (!dateRange.equalsIgnoreCase("NA")) {
				fromDate = dateRange.substring(0, 10).trim();
				fromDate = fromDate.substring(6) + "-" + fromDate.substring(3, 5) + "-" + fromDate.substring(0, 2);
				toDate = dateRange.substring(13).trim();
				toDate = toDate.substring(6) + "-" + toDate.substring(3, 5) + "-" + toDate.substring(0, 2);
			}
			if (userRole == null || userRole.equalsIgnoreCase("NA") || userRole.length() <= 0)
				userRole = "NA";

			queryselect = new StringBuffer("SELECT ms.msrefid,ms.msclientrefid,ms.mscontactrefid,ms.msinvoiceno,"
					+ "ms.msestimateno,ms.mscompany,ms.msproducttype,ms.msproductname,ms.msproductplan,"
					+ "ms.msplanperiod,ms.msplantime,ms.mssoldbyuid,ms.mssolddate,ms.msprojectnumber,"
					+ "ms.msworkpercent,ms.msworktags,ms.msworkstatus,ms.msworkpriority,ms.msassignedtoname,"
					+ "ms.msassignedtorefid,ms.msunseenchatadmin,c.cbname FROM managesalesctrl ms "
					+ "INNER JOIN contactboxctrl c on ms.mscontactrefid=c.cbrefid"
					+ " where ms.msstatus='1' and ms.sales_type='1' and ms.mstoken='" + token + "' ");

			if (!userRole.equalsIgnoreCase("Admin") && !userRole.equalsIgnoreCase("Super Admin"))
				queryselect.append("and ms.delivery_person_uid='" + loginuaid + "' ");

			if (!userRole.equalsIgnoreCase("NA") && userRole.equalsIgnoreCase("Assistant")) {
				queryselect.append(
						" and exists(select t.mtid from manageteamctrl t where ms.msassignedtorefid=t.mtrefid and t.mtadminid='"
								+ loginuaid + "' and t.mttoken='" + token + "') ");
			}
			if (!deliveryDoAction.equalsIgnoreCase("NA") && !deliveryDoAction.equalsIgnoreCase("All")) {
				if (deliveryDoAction.equalsIgnoreCase("Cancelled"))
					queryselect.append(" and ms.mscancelstatus='1' ");
				else
					queryselect.append(" and ms.msworkstatus='" + deliveryDoAction + "' and ms.mscancelstatus='2' ");
			} else
				queryselect.append(" and ms.mscancelstatus='2' ");
			if (!deliveryInvoice.equalsIgnoreCase("NA"))
				queryselect.append(" and ms.msinvoiceno='" + deliveryInvoice + "' ");
			if (!clientName.equalsIgnoreCase("NA"))
				queryselect.append(" and ms.mscompany='" + clientName + "' ");
			if (!contactName.equalsIgnoreCase("NA"))
				queryselect.append(" and c.cbname='" + contactName + "' ");
			if (!fromDate.equalsIgnoreCase("NA") && !toDate.equalsIgnoreCase("NA")) {
				queryselect.append(" and str_to_date(ms.mssolddate,'%d-%m-%Y')<='" + toDate
						+ "' and str_to_date(ms.mssolddate,'%d-%m-%Y')>='" + fromDate + "' ");
			}
			queryselect.append("group by ms.msid ");
			if (sort.length() <= 0)
				queryselect.append("order by ms.msid desc limit " + ((page - 1) * rows) + "," + rows);
			else if (sort.equals("date"))
				queryselect.append("order by ms.mssolddate " + order + " limit " + ((page - 1) * rows) + "," + rows);
			else if (sort.equals("invoice"))
				queryselect.append("order by ms.msinvoiceno " + order + " limit " + ((page - 1) * rows) + "," + rows);
			else if (sort.equals("client"))
				queryselect.append("order by ms.mscompany " + order + " limit " + ((page - 1) * rows) + "," + rows);
			else if (sort.equals("project"))
				queryselect.append("order by ms.msproductname " + order + " limit " + ((page - 1) * rows) + "," + rows);
			else if (sort.equals("progress"))
				queryselect.append("order by ms.msworkpercent " + order + " limit " + ((page - 1) * rows) + "," + rows);
			else if (sort.equals("tags"))
				queryselect.append("order by ms.msworktags " + order + " limit " + ((page - 1) * rows) + "," + rows);
			else if (sort.equals("status"))
				queryselect.append("order by ms.msworkstatus " + order + " limit " + ((page - 1) * rows) + "," + rows);
			else if (sort.equals("assigned_to"))
				queryselect
						.append("order by ms.msassignedtoname " + order + " limit " + ((page - 1) * rows) + "," + rows);
			else if (sort.equals("priority"))
				queryselect
						.append("order by ms.msworkpriority " + order + " limit " + ((page - 1) * rows) + "," + rows);
			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect.toString());
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
			log.info("getAllDeliverySales" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getAllDeliverySales" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static int countAllDeliverySales(String userRole, String loginuaid, String token, String deliveryDoAction,
			String deliveryInvoice, String dateRange, String clientName, String contactName) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		int newsdata = 0;
		StringBuffer queryselect = null;
		String fromDate = "NA";
		String toDate = "NA";
		try {

			if (!dateRange.equalsIgnoreCase("NA")) {
				fromDate = dateRange.substring(0, 10).trim();
				fromDate = fromDate.substring(6) + "-" + fromDate.substring(3, 5) + "-" + fromDate.substring(0, 2);
				toDate = dateRange.substring(13).trim();
				toDate = toDate.substring(6) + "-" + toDate.substring(3, 5) + "-" + toDate.substring(0, 2);
			}
			if (userRole == null || userRole.equalsIgnoreCase("NA") || userRole.length() <= 0)
				userRole = "NA";
			queryselect = new StringBuffer("SELECT ms.msid FROM managesalesctrl ms INNER JOIN "
					+ "contactboxctrl c on ms.mscontactrefid=c.cbrefid where ms.msstatus='1' and ms.sales_type='1' "
					+ "and ms.mstoken='" + token + "' ");
			if (!userRole.equalsIgnoreCase("Admin") && !userRole.equalsIgnoreCase("Super Admin"))
				queryselect.append("and delivery_person_uid='" + loginuaid + "' ");

			if (!userRole.equalsIgnoreCase("NA") && userRole.equalsIgnoreCase("Assistant")) {
				queryselect.append(
						" and exists(select t.mtid from manageteamctrl t where ms.msassignedtorefid=t.mtrefid and t.mtadminid='"
								+ loginuaid + "' and t.mttoken='" + token + "')");
			}
			if (!deliveryDoAction.equalsIgnoreCase("NA") && !deliveryDoAction.equalsIgnoreCase("All")) {
				if (deliveryDoAction.equalsIgnoreCase("Cancelled"))
					queryselect.append(" and mscancelstatus='1' ");
				else
					queryselect.append(" and ms.msworkstatus='" + deliveryDoAction + "' and ms.mscancelstatus='2' ");
			} else
				queryselect.append(" and ms.mscancelstatus='2' ");
			if (!deliveryInvoice.equalsIgnoreCase("NA"))
				queryselect.append(" and ms.msinvoiceno='" + deliveryInvoice + "'");
			if (!clientName.equalsIgnoreCase("NA"))
				queryselect.append(" and ms.mscompany='" + clientName + "'");
			if (!contactName.equalsIgnoreCase("NA"))
				queryselect.append(" and c.cbname='" + contactName + "'");
			if (!fromDate.equalsIgnoreCase("NA") && !toDate.equalsIgnoreCase("NA")) {
				queryselect.append(" and str_to_date(ms.mssolddate,'%d-%m-%Y')<='" + toDate
						+ "' and str_to_date(ms.mssolddate,'%d-%m-%Y')>='" + fromDate + "'");
			}
			queryselect.append("group by ms.msid");
//						System.out.println(queryselect);
			ps = con.prepareStatement(queryselect.toString());
			rsGCD = ps.executeQuery();

			while (rsGCD != null && rsGCD.next()) {
				newsdata += 1;
			}
		} catch (Exception e) {
			log.info("countAllDeliverySales" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("countAllDeliverySales" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllCollectionSales(String token, String collectionDoAction, String collectionInvoice,
			String dateRange, String clientName, String contactName, int page, int rows, String sort, String order,
			String userRole, String loginuaid, String collectionUserUaid) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer queryselect = null;
		String fromDate = "NA";
		String toDate = "NA";
		try {

			if (!dateRange.equalsIgnoreCase("NA")) {
				fromDate = dateRange.substring(0, 10).trim();
				fromDate = fromDate.substring(6) + "-" + fromDate.substring(3, 5) + "-" + fromDate.substring(0, 2);
				toDate = dateRange.substring(13).trim();
				toDate = toDate.substring(6) + "-" + toDate.substring(3, 5) + "-" + toDate.substring(0, 2);
			}
			queryselect = new StringBuffer("SELECT ms.msrefid,ms.msclientrefid,ms.mscontactrefid,ms.msinvoiceno,"
					+ "ms.msestimateno,ms.mscompany,ms.msproducttype,ms.msproductname,ms.msproductplan,"
					+ "ms.msplanperiod,ms.msplantime,ms.mssoldbyuid,ms.mssolddate,ms.msprojectnumber,"
					+ "ms.msworkpercent,ms.msworktags,ms.msworkstatus,ms.msworkpriority,ms.msassignedtoname,"
					+ "ms.msassignedtorefid,ms.msunseenchatadmin,c.cbname,ms.delivery_assign_status,"
					+ "ms.delivery_person_name,ms.doc_re_upload,ms.document_assign_name,ms.document_status,ms.tat_value,"
					+ "ms.tat_type,ms.document_assign_date,ms.document_assign_time FROM managesalesctrl ms INNER JOIN contactboxctrl c on ms.mscontactrefid=c.cbrefid"
					+ " where ms.msstatus='1' and ms.sales_type='1' and ms.mstoken='" + token + "' ");

			if (!userRole.equalsIgnoreCase("Admin") && !userRole.equalsIgnoreCase("Super Admin")
					&& !userRole.equalsIgnoreCase("Manager"))
				queryselect.append("and ms.document_assign_uaid='" + loginuaid + "' ");

			if (!collectionUserUaid.equalsIgnoreCase("NA"))
				queryselect.append("and ms.document_assign_uaid='" + collectionUserUaid + "' ");

			if (!collectionDoAction.equalsIgnoreCase("NA") && !collectionDoAction.equalsIgnoreCase("All")) {
				if (collectionDoAction.equalsIgnoreCase("Cancelled"))
					queryselect.append(" and ms.mscancelstatus='1' ");
				else if (collectionDoAction.equalsIgnoreCase("Assigned"))
					queryselect.append(" and ms.delivery_assign_status='1' and ms.mscancelstatus='2' ");
				else if (collectionDoAction.equalsIgnoreCase("Unassigned"))
					queryselect.append(" and ms.delivery_assign_status='2' and ms.mscancelstatus='2' ");
				else if (collectionDoAction.equalsIgnoreCase("DocumentAssigned"))
					queryselect.append(" and ms.document_assign_uaid>0 ");
				else if (collectionDoAction.equalsIgnoreCase("DocumentUnassigned"))
					queryselect.append(" and ms.document_assign_uaid=0 ");
				else if (collectionDoAction.equalsIgnoreCase("Uploaded"))
					queryselect.append(" and ms.doc_uploaded='1' and ms.mscancelstatus='2' ");
				else if (collectionDoAction.equalsIgnoreCase("Unuploaded"))
					queryselect.append(" and ms.doc_uploaded='2' and ms.mscancelstatus='2' ");
				else if (collectionDoAction.equalsIgnoreCase("ReUpload"))
					queryselect.append(" and ms.doc_re_upload='1' and ms.mscancelstatus='2' ");
				else if (collectionDoAction.equalsIgnoreCase("Active"))
					queryselect.append(" and ms.document_status='1' and ms.mscancelstatus='2' ");
				else if (collectionDoAction.equalsIgnoreCase("Inactive"))
					queryselect.append(" and ms.document_status='2' and ms.mscancelstatus='2' ");
				else if (collectionDoAction.equalsIgnoreCase("Expired"))
					queryselect.append(" and ms.document_status='3' and ms.mscancelstatus='2' ");
//					else queryselect.append(" and ms.msworkstatus='"+collectionDoAction+"' and ms.mscancelstatus='2' ");
			} else
				queryselect.append(" and ms.mscancelstatus='2' ");
			if (!collectionInvoice.equalsIgnoreCase("NA"))
				queryselect.append(" and ms.msinvoiceno='" + collectionInvoice + "' ");
			if (!clientName.equalsIgnoreCase("NA"))
				queryselect.append(" and ms.mscompany='" + clientName + "' ");
			if (!contactName.equalsIgnoreCase("NA"))
				queryselect.append(" and c.cbname='" + contactName + "' ");
			if (!fromDate.equalsIgnoreCase("NA") && !toDate.equalsIgnoreCase("NA")) {
				queryselect.append(" and str_to_date(ms.mssolddate,'%d-%m-%Y')<='" + toDate
						+ "' and str_to_date(ms.mssolddate,'%d-%m-%Y')>='" + fromDate + "' ");
			}
			queryselect.append("group by ms.msid ");
			if (sort.length() <= 0)
				queryselect.append("order by ms.msid desc limit " + ((page - 1) * rows) + "," + rows);
			else if (sort.equals("date"))
				queryselect.append("order by ms.mssolddate " + order + " limit " + ((page - 1) * rows) + "," + rows);
			else if (sort.equals("invoice"))
				queryselect.append("order by ms.msinvoiceno " + order + " limit " + ((page - 1) * rows) + "," + rows);
			else if (sort.equals("client"))
				queryselect.append("order by ms.mscompany " + order + " limit " + ((page - 1) * rows) + "," + rows);
			else if (sort.equals("project"))
				queryselect.append("order by ms.msproductname " + order + " limit " + ((page - 1) * rows) + "," + rows);
			else if (sort.equals("assigned_to"))
				queryselect
						.append("order by ms.msassignedtoname " + order + " limit " + ((page - 1) * rows) + "," + rows);
			else if (sort.equals("document_assign"))
				queryselect.append(
						"order by ms.document_assign_name " + order + " limit " + ((page - 1) * rows) + "," + rows);
			else if (sort.equals("priority"))
				queryselect
						.append("order by ms.msworkpriority " + order + " limit " + ((page - 1) * rows) + "," + rows);

//				System.out.println(queryselect);
			ps = con.prepareStatement(queryselect.toString());
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
			e.printStackTrace();
			log.info("getAllCollectionSales" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getAllCollectionSales" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static int countAllAssignedSalesDocument(String token, String collectionDoAction, String collectionInvoice,
			String dateRange, String clientName, String contactName, String userRole, String loginuaid,
			String collectionUserUaid) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		int newsdata = 0;
		StringBuffer queryselect = null;
		String fromDate = "NA";
		String toDate = "NA";
		try {

			if (!collectionDoAction.equalsIgnoreCase("DocumentUnassigned")) {

				if (!dateRange.equalsIgnoreCase("NA")) {
					fromDate = dateRange.substring(0, 10).trim();
					fromDate = fromDate.substring(6) + "-" + fromDate.substring(3, 5) + "-" + fromDate.substring(0, 2);
					toDate = dateRange.substring(13).trim();
					toDate = toDate.substring(6) + "-" + toDate.substring(3, 5) + "-" + toDate.substring(0, 2);
				}
				queryselect = new StringBuffer("SELECT ms.msid FROM managesalesctrl ms INNER JOIN "
						+ "contactboxctrl c on ms.mscontactrefid=c.cbrefid where ms.msstatus='1' and ms.sales_type='1' "
						+ "and ms.mstoken='" + token + "' and ms.document_assign_uaid>0 ");

				if (!userRole.equalsIgnoreCase("Admin") && !userRole.equalsIgnoreCase("Super Admin")
						&& !userRole.equalsIgnoreCase("Manager"))
					queryselect.append("and ms.document_assign_uaid='" + loginuaid + "' ");

				if (!collectionUserUaid.equalsIgnoreCase("NA"))
					queryselect.append("and ms.document_assign_uaid='" + collectionUserUaid + "' ");

				if (!collectionDoAction.equalsIgnoreCase("NA") && !collectionDoAction.equalsIgnoreCase("All")
						&& !collectionDoAction.equalsIgnoreCase("DocumentAssigned")
						&& !collectionDoAction.equalsIgnoreCase("DocumentUnassigned")) {
					if (collectionDoAction.equalsIgnoreCase("Cancelled"))
						queryselect.append(" and ms.mscancelstatus='1' ");
					else if (collectionDoAction.equalsIgnoreCase("Assigned"))
						queryselect.append(" and ms.delivery_assign_status='1' and ms.mscancelstatus='2' ");
					else if (collectionDoAction.equalsIgnoreCase("Unassigned"))
						queryselect.append(" and ms.delivery_assign_status='2' and ms.mscancelstatus='2' ");
					else if (collectionDoAction.equalsIgnoreCase("Uploaded"))
						queryselect.append(" and ms.doc_uploaded='1' and ms.mscancelstatus='2' ");
					else if (collectionDoAction.equalsIgnoreCase("Unuploaded"))
						queryselect.append(" and ms.doc_uploaded='2' and ms.mscancelstatus='2' ");
					else if (collectionDoAction.equalsIgnoreCase("ReUpload"))
						queryselect.append(" and ms.doc_re_upload='1' and ms.mscancelstatus='2' ");
					else if (collectionDoAction.equalsIgnoreCase("Active"))
						queryselect.append(" and ms.document_status='1' and ms.mscancelstatus='2' ");
					else if (collectionDoAction.equalsIgnoreCase("Inactive"))
						queryselect.append(" and ms.document_status='2' and ms.mscancelstatus='2' ");
					else if (collectionDoAction.equalsIgnoreCase("Expired"))
						queryselect.append(" and ms.document_status='3' and ms.mscancelstatus='2' ");

				} else
					queryselect.append(" and ms.mscancelstatus='2' ");

				if (!collectionInvoice.equalsIgnoreCase("NA"))
					queryselect.append(" and ms.msinvoiceno='" + collectionInvoice + "'");
				if (!clientName.equalsIgnoreCase("NA"))
					queryselect.append(" and ms.mscompany='" + clientName + "'");
				if (!contactName.equalsIgnoreCase("NA"))
					queryselect.append(" and c.cbname='" + contactName + "'");
				if (!fromDate.equalsIgnoreCase("NA") && !toDate.equalsIgnoreCase("NA")) {
					queryselect.append(" and str_to_date(ms.mssolddate,'%d-%m-%Y')<='" + toDate
							+ "' and str_to_date(ms.mssolddate,'%d-%m-%Y')>='" + fromDate + "'");
				}
				queryselect.append("group by ms.msid");
				ps = con.prepareStatement(queryselect.toString());
				rsGCD = ps.executeQuery();

				while (rsGCD != null && rsGCD.next()) {
					newsdata += 1;
				}
			}
		} catch (Exception e) {
			log.info("countAllAssignedSalesDocument" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("countAllAssignedSalesDocument" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static int countAllCompletedSalesDocument(String token, String collectionDoAction, String collectionInvoice,
			String dateRange, String clientName, String contactName, String userRole, String loginuaid,
			String collectionUserUaid) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		int newsdata = 0;
		StringBuffer queryselect = null;
		String fromDate = "NA";
		String toDate = "NA";
		try {

			if (!collectionDoAction.equalsIgnoreCase("Unuploaded")) {

				if (!dateRange.equalsIgnoreCase("NA")) {
					fromDate = dateRange.substring(0, 10).trim();
					fromDate = fromDate.substring(6) + "-" + fromDate.substring(3, 5) + "-" + fromDate.substring(0, 2);
					toDate = dateRange.substring(13).trim();
					toDate = toDate.substring(6) + "-" + toDate.substring(3, 5) + "-" + toDate.substring(0, 2);
				}
				queryselect = new StringBuffer("SELECT ms.msid FROM managesalesctrl ms INNER JOIN "
						+ "contactboxctrl c on ms.mscontactrefid=c.cbrefid where ms.msstatus='1' and ms.sales_type='1' "
						+ "and ms.mstoken='" + token + "' and ms.doc_uploaded='1' ");

				if (!userRole.equalsIgnoreCase("Admin") && !userRole.equalsIgnoreCase("Super Admin")
						&& !userRole.equalsIgnoreCase("Manager"))
					queryselect.append("and ms.document_assign_uaid='" + loginuaid + "' ");

				if (!collectionUserUaid.equalsIgnoreCase("NA"))
					queryselect.append("and ms.document_assign_uaid='" + collectionUserUaid + "' ");

				if (!collectionDoAction.equalsIgnoreCase("NA") && !collectionDoAction.equalsIgnoreCase("All")
						&& !collectionDoAction.equalsIgnoreCase("Uploaded")
						&& !collectionDoAction.equalsIgnoreCase("Unuploaded")) {
					if (collectionDoAction.equalsIgnoreCase("Cancelled"))
						queryselect.append(" and ms.mscancelstatus='1' ");
					else if (collectionDoAction.equalsIgnoreCase("Assigned"))
						queryselect.append(" and ms.delivery_assign_status='1' and ms.mscancelstatus='2' ");
					else if (collectionDoAction.equalsIgnoreCase("Unassigned"))
						queryselect.append(" and ms.delivery_assign_status='2' and ms.mscancelstatus='2' ");
					else if (collectionDoAction.equalsIgnoreCase("DocumentAssigned"))
						queryselect.append(" and ms.document_assign_uaid>0 ");
					else if (collectionDoAction.equalsIgnoreCase("DocumentUnassigned"))
						queryselect.append(" and ms.document_assign_uaid=0 ");
					else if (collectionDoAction.equalsIgnoreCase("ReUpload"))
						queryselect.append(" and ms.doc_re_upload='1' and ms.mscancelstatus='2' ");
					else if (collectionDoAction.equalsIgnoreCase("Active"))
						queryselect.append(" and ms.document_status='1' and ms.mscancelstatus='2' ");
					else if (collectionDoAction.equalsIgnoreCase("Inactive"))
						queryselect.append(" and ms.document_status='2' and ms.mscancelstatus='2' ");
					else if (collectionDoAction.equalsIgnoreCase("Expired"))
						queryselect.append(" and ms.document_status='3' and ms.mscancelstatus='2' ");

				} else
					queryselect.append(" and ms.mscancelstatus='2' ");

				if (!collectionInvoice.equalsIgnoreCase("NA"))
					queryselect.append(" and ms.msinvoiceno='" + collectionInvoice + "'");
				if (!clientName.equalsIgnoreCase("NA"))
					queryselect.append(" and ms.mscompany='" + clientName + "'");
				if (!contactName.equalsIgnoreCase("NA"))
					queryselect.append(" and c.cbname='" + contactName + "'");
				if (!fromDate.equalsIgnoreCase("NA") && !toDate.equalsIgnoreCase("NA")) {
					queryselect.append(" and str_to_date(ms.mssolddate,'%d-%m-%Y')<='" + toDate
							+ "' and str_to_date(ms.mssolddate,'%d-%m-%Y')>='" + fromDate + "'");
				}
				queryselect.append("group by ms.msid");
				ps = con.prepareStatement(queryselect.toString());
				rsGCD = ps.executeQuery();

				while (rsGCD != null && rsGCD.next()) {
					newsdata += 1;
				}
			}
		} catch (Exception e) {
			log.info("countAllCompletedSalesDocument" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("countAllCompletedSalesDocument" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static int countAllExpiredSalesDocument(String token, String collectionDoAction, String collectionInvoice,
			String dateRange, String clientName, String contactName, String userRole, String loginuaid,
			String collectionUserUaid) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		int newsdata = 0;
		StringBuffer queryselect = null;
		String fromDate = "NA";
		String toDate = "NA";
		try {

			if (!collectionDoAction.equalsIgnoreCase("Active") && !collectionDoAction.equalsIgnoreCase("Inactive")) {

				if (!dateRange.equalsIgnoreCase("NA")) {
					fromDate = dateRange.substring(0, 10).trim();
					fromDate = fromDate.substring(6) + "-" + fromDate.substring(3, 5) + "-" + fromDate.substring(0, 2);
					toDate = dateRange.substring(13).trim();
					toDate = toDate.substring(6) + "-" + toDate.substring(3, 5) + "-" + toDate.substring(0, 2);
				}
				queryselect = new StringBuffer("SELECT ms.msid FROM managesalesctrl ms INNER JOIN "
						+ "contactboxctrl c on ms.mscontactrefid=c.cbrefid where ms.msstatus='1' and ms.sales_type='1' "
						+ "and ms.mstoken='" + token + "' and ms.document_status='3' ");

				if (!userRole.equalsIgnoreCase("Admin") && !userRole.equalsIgnoreCase("Super Admin")
						&& !userRole.equalsIgnoreCase("Manager"))
					queryselect.append("and ms.document_assign_uaid='" + loginuaid + "' ");

				if (!collectionUserUaid.equalsIgnoreCase("NA"))
					queryselect.append("and ms.document_assign_uaid='" + collectionUserUaid + "' ");

				if (!collectionDoAction.equalsIgnoreCase("NA") && !collectionDoAction.equalsIgnoreCase("All")
						&& !collectionDoAction.equalsIgnoreCase("Expired")) {
					if (collectionDoAction.equalsIgnoreCase("Cancelled"))
						queryselect.append(" and ms.mscancelstatus='1' ");
					else if (collectionDoAction.equalsIgnoreCase("Assigned"))
						queryselect.append(" and ms.delivery_assign_status='1' and ms.mscancelstatus='2' ");
					else if (collectionDoAction.equalsIgnoreCase("Unassigned"))
						queryselect.append(" and ms.delivery_assign_status='2' and ms.mscancelstatus='2' ");
					else if (collectionDoAction.equalsIgnoreCase("DocumentAssigned"))
						queryselect.append(" and ms.document_assign_uaid>0 ");
					else if (collectionDoAction.equalsIgnoreCase("DocumentUnassigned"))
						queryselect.append(" and ms.document_assign_uaid=0 ");
					else if (collectionDoAction.equalsIgnoreCase("ReUpload"))
						queryselect.append(" and ms.doc_re_upload='1' and ms.mscancelstatus='2' ");
				} else
					queryselect.append(" and ms.mscancelstatus='2' ");

				if (!collectionInvoice.equalsIgnoreCase("NA"))
					queryselect.append(" and ms.msinvoiceno='" + collectionInvoice + "'");
				if (!clientName.equalsIgnoreCase("NA"))
					queryselect.append(" and ms.mscompany='" + clientName + "'");
				if (!contactName.equalsIgnoreCase("NA"))
					queryselect.append(" and c.cbname='" + contactName + "'");
				if (!fromDate.equalsIgnoreCase("NA") && !toDate.equalsIgnoreCase("NA")) {
					queryselect.append(" and str_to_date(ms.mssolddate,'%d-%m-%Y')<='" + toDate
							+ "' and str_to_date(ms.mssolddate,'%d-%m-%Y')>='" + fromDate + "'");
				}
				queryselect.append("group by ms.msid");
				ps = con.prepareStatement(queryselect.toString());
				rsGCD = ps.executeQuery();

				while (rsGCD != null && rsGCD.next()) {
					newsdata += 1;
				}
			}
		} catch (Exception e) {
			log.info("countAllExpiredSalesDocument" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("countAllExpiredSalesDocument" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static int countAllCollectionSales(String token, String collectionDoAction, String collectionInvoice,
			String dateRange, String clientName, String contactName, String userRole, String loginuaid,
			String collectionUserUaid) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		int newsdata = 0;
		StringBuffer queryselect = null;
		String fromDate = "NA";
		String toDate = "NA";
		try {

			if (!dateRange.equalsIgnoreCase("NA")) {
				fromDate = dateRange.substring(0, 10).trim();
				fromDate = fromDate.substring(6) + "-" + fromDate.substring(3, 5) + "-" + fromDate.substring(0, 2);
				toDate = dateRange.substring(13).trim();
				toDate = toDate.substring(6) + "-" + toDate.substring(3, 5) + "-" + toDate.substring(0, 2);
			}
			queryselect = new StringBuffer("SELECT ms.msid FROM managesalesctrl ms INNER JOIN "
					+ "contactboxctrl c on ms.mscontactrefid=c.cbrefid where ms.msstatus='1' and ms.sales_type='1' "
					+ "and ms.mstoken='" + token + "' ");

			if (!userRole.equalsIgnoreCase("Admin") && !userRole.equalsIgnoreCase("Super Admin")
					&& !userRole.equalsIgnoreCase("Manager"))
				queryselect.append("and ms.document_assign_uaid='" + loginuaid + "' ");

			if (!collectionUserUaid.equalsIgnoreCase("NA"))
				queryselect.append("and ms.document_assign_uaid='" + collectionUserUaid + "' ");

			if (!collectionDoAction.equalsIgnoreCase("NA") && !collectionDoAction.equalsIgnoreCase("All")) {
				if (collectionDoAction.equalsIgnoreCase("Cancelled"))
					queryselect.append(" and ms.mscancelstatus='1' ");
				else if (collectionDoAction.equalsIgnoreCase("Assigned"))
					queryselect.append(" and ms.delivery_assign_status='1' and ms.mscancelstatus='2' ");
				else if (collectionDoAction.equalsIgnoreCase("Unassigned"))
					queryselect.append(" and ms.delivery_assign_status='2' and ms.mscancelstatus='2' ");
				else if (collectionDoAction.equalsIgnoreCase("DocumentAssigned"))
					queryselect.append(" and ms.document_assign_uaid>0 ");
				else if (collectionDoAction.equalsIgnoreCase("DocumentUnassigned"))
					queryselect.append(" and ms.document_assign_uaid=0 ");
				else if (collectionDoAction.equalsIgnoreCase("Uploaded"))
					queryselect.append(" and ms.doc_uploaded='1' and ms.mscancelstatus='2' ");
				else if (collectionDoAction.equalsIgnoreCase("Unuploaded"))
					queryselect.append(" and ms.doc_uploaded='2' and ms.mscancelstatus='2' ");
				else if (collectionDoAction.equalsIgnoreCase("ReUpload"))
					queryselect.append(" and ms.doc_re_upload='1' and ms.mscancelstatus='2' ");
				else if (collectionDoAction.equalsIgnoreCase("Active"))
					queryselect.append(" and ms.document_status='1' and ms.mscancelstatus='2' ");
				else if (collectionDoAction.equalsIgnoreCase("Inactive"))
					queryselect.append(" and ms.document_status='2' and ms.mscancelstatus='2' ");
				else if (collectionDoAction.equalsIgnoreCase("Expired"))
					queryselect.append(" and ms.document_status='3' and ms.mscancelstatus='2' ");
//					else queryselect.append(" and ms.msworkstatus='"+collectionDoAction+"' and ms.mscancelstatus='2' ");
			} else
				queryselect.append(" and ms.mscancelstatus='2' ");

			if (!collectionInvoice.equalsIgnoreCase("NA"))
				queryselect.append(" and ms.msinvoiceno='" + collectionInvoice + "'");
			if (!clientName.equalsIgnoreCase("NA"))
				queryselect.append(" and ms.mscompany='" + clientName + "'");
			if (!contactName.equalsIgnoreCase("NA"))
				queryselect.append(" and c.cbname='" + contactName + "'");
			if (!fromDate.equalsIgnoreCase("NA") && !toDate.equalsIgnoreCase("NA")) {
				queryselect.append(" and str_to_date(ms.mssolddate,'%d-%m-%Y')<='" + toDate
						+ "' and str_to_date(ms.mssolddate,'%d-%m-%Y')>='" + fromDate + "'");
			}
			queryselect.append("group by ms.msid");
//						System.out.println(queryselect);
			ps = con.prepareStatement(queryselect.toString());
			rsGCD = ps.executeQuery();

			while (rsGCD != null && rsGCD.next()) {
				newsdata += 1;
			}
		} catch (Exception e) {
			log.info("countAllCollectionSales" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("countAllCollectionSales" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static int countAllSales(String userRole, String loginuaid, String token, String InvoiceNo, String PhoneKey,
			String ProductName, String ClientName, String SoldByUid, String dateRange, String contactName,
			String department, String salesFilter) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		int newsdata = 0;
		String fromDate = "NA";
		String toDate = "NA";
		try {
			if (!dateRange.equalsIgnoreCase("NA")) {
				fromDate = dateRange.substring(0, 10).trim();
				fromDate = fromDate.substring(6) + "-" + fromDate.substring(3, 5) + "-" + fromDate.substring(0, 2);
				toDate = dateRange.substring(13).trim();
				toDate = toDate.substring(6) + "-" + toDate.substring(3, 5) + "-" + toDate.substring(0, 2);
			}
			if (loginuaid == null || loginuaid.equalsIgnoreCase("NA") || loginuaid.length() <= 0)
				loginuaid = "NA";
			StringBuffer queryselect = new StringBuffer("SELECT ms.msid FROM managesalesctrl ms INNER "
					+ "JOIN contactboxctrl c on ms.mscontactrefid=c.cbrefid where ms.msstatus='1' and " + "ms.mstoken='"
					+ token + "'");

			if (salesFilter.equalsIgnoreCase("All"))
				queryselect.append(" and ms.mscancelstatus='2'");
			else if (salesFilter.equalsIgnoreCase("Cancelled"))
				queryselect.append(" and ms.mscancelstatus='1'");
			else if (salesFilter.equalsIgnoreCase("In-Progress"))
				queryselect.append(" and ms.mscancelstatus='2' and ms.msprojectstatus='3'");
			else if (salesFilter.equalsIgnoreCase("Completed"))
				queryselect.append(" and ms.mscancelstatus='2' and ms.msprojectstatus='2'");
			else if (salesFilter.equalsIgnoreCase("Past-Due"))
				queryselect.append(
						" and ms.mscancelstatus='2' and exists(select h.cbuid from hrmclient_billing h where h.cbinvoiceno=ms.msinvoiceno and h.cbdueamount>0)");

			if (department.equalsIgnoreCase("Sales") || department.equalsIgnoreCase("Admin")) {
				if (!userRole.equalsIgnoreCase("NA") && userRole.equalsIgnoreCase("Executive"))
					queryselect.append(" and ms.mssoldbyuid = '" + loginuaid + "'");
				if (!userRole.equalsIgnoreCase("NA") && !loginuaid.equalsIgnoreCase("NA")
						&& (userRole.equalsIgnoreCase("Assistant") || userRole.equalsIgnoreCase("Manager")))
					queryselect.append(
							" and exists(select t.mtid from manageteamctrl t join manageteammemberctrl m on t.mtrefid=m.tmteamrefid where t.mtadminid='"
									+ loginuaid + "' and m.tmuseruid=ms.mssoldbyuid or ms.mssoldbyuid='" + loginuaid
									+ "')");

			} else
				queryselect.append(" and (ms.mssoldbyuid = '" + loginuaid
						+ "' or exists(select id from consulting_sale c where c.sales_key=ms.msrefid and c.consultant_uaid='"
						+ loginuaid + "'))");

			if (!InvoiceNo.equalsIgnoreCase("NA"))
				queryselect.append(" and ms.msinvoiceno='" + InvoiceNo + "'");
			if (!PhoneKey.equalsIgnoreCase("NA"))
				queryselect.append(" and ms.mscontactrefid='" + PhoneKey + "'");
			if (!contactName.equalsIgnoreCase("NA"))
				queryselect.append(" and c.cbname='" + contactName + "'");
			if (!ProductName.equalsIgnoreCase("NA"))
				queryselect.append(" and ms.msproductname='" + ProductName + "'");
			if (!ClientName.equalsIgnoreCase("NA"))
				queryselect.append(" and ms.mscompany='" + ClientName + "'");
			if (!SoldByUid.equalsIgnoreCase("NA"))
				queryselect.append(" and ms.mssoldbyuid='" + SoldByUid + "'");
			if (!fromDate.equalsIgnoreCase("NA") && !toDate.equalsIgnoreCase("NA")) {
				queryselect.append(" and str_to_date(ms.mssolddate,'%d-%m-%Y')<='" + toDate
						+ "' and str_to_date(ms.mssolddate,'%d-%m-%Y')>='" + fromDate + "' ");
			}

			queryselect.append(" group by ms.msid");
			ps = con.prepareStatement(queryselect.toString());
			rsGCD = ps.executeQuery();

			while (rsGCD != null && rsGCD.next()) {
				newsdata += 1;
			}
		} catch (Exception e) {
			log.info("countAllSales" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("countAllSales" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllSales(String userRole, String loginuaid, String token, String InvoiceNo,
			String PhoneKey, String ProductName, String ClientName, String SoldByUid, String dateRange,
			String contactName, int page, int rows, String sort, String order, String department, String salesFilter) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		String fromDate = "NA";
		String toDate = "NA";
		try {
			if (!dateRange.equalsIgnoreCase("NA")) {
				fromDate = dateRange.substring(0, 10).trim();
				fromDate = fromDate.substring(6) + "-" + fromDate.substring(3, 5) + "-" + fromDate.substring(0, 2);
				toDate = dateRange.substring(13).trim();
				toDate = toDate.substring(6) + "-" + toDate.substring(3, 5) + "-" + toDate.substring(0, 2);
			}
			if (loginuaid == null || loginuaid.equalsIgnoreCase("NA") || loginuaid.length() <= 0)
				loginuaid = "NA";
			StringBuffer queryselect = new StringBuffer("SELECT ms.msrefid,ms.msclientrefid,ms.mscontactrefid,"
					+ "ms.msinvoiceno,ms.msestimateno,ms.mscompany,ms.msproducttype,ms.msproductname,ms.msproductplan,"
					+ "ms.msplanperiod,ms.msplantime,ms.mssoldbyuid,ms.mssolddate,ms.msprojectnumber,ms.msworkpercent,"
					+ "ms.msinvoicenotes,ms.msprojectstatus,ms.msordernumber,ms.mspurchasedate,ms.sales_type FROM managesalesctrl ms "
					+ "INNER JOIN contactboxctrl c on ms.mscontactrefid=c.cbrefid where ms.msstatus='1' and ms.mstoken='"
					+ token + "'");

			if (salesFilter.equalsIgnoreCase("All"))
				queryselect.append(" and ms.mscancelstatus='2'");
			else if (salesFilter.equalsIgnoreCase("Cancelled"))
				queryselect.append(" and ms.mscancelstatus='1'");
			else if (salesFilter.equalsIgnoreCase("In-Progress"))
				queryselect.append(" and ms.mscancelstatus='2' and ms.msprojectstatus='3'");
			else if (salesFilter.equalsIgnoreCase("Completed"))
				queryselect.append(" and ms.mscancelstatus='2' and ms.msprojectstatus='2'");
			else if (salesFilter.equalsIgnoreCase("Past-Due"))
				queryselect.append(
						" and ms.mscancelstatus='2' and exists(select h.cbuid from hrmclient_billing h where h.cbinvoiceno=ms.msinvoiceno and h.cbdueamount>0)");

			if (department.equalsIgnoreCase("Sales") || department.equalsIgnoreCase("Admin")) {
				if (!userRole.equalsIgnoreCase("NA") && userRole.equalsIgnoreCase("Executive"))
					queryselect.append(" and ms.mssoldbyuid = '" + loginuaid + "' ");
				if (!userRole.equalsIgnoreCase("NA") && !loginuaid.equalsIgnoreCase("NA")
						&& (userRole.equalsIgnoreCase("Assistant") || userRole.equalsIgnoreCase("Manager")))
					queryselect.append(
							" and exists(select t.mtid from manageteamctrl t join manageteammemberctrl m on t.mtrefid=m.tmteamrefid where t.mtadminid='"
									+ loginuaid + "' and m.tmuseruid=ms.mssoldbyuid or ms.mssoldbyuid='" + loginuaid
									+ "') ");
			} else
				queryselect.append(" and (ms.mssoldbyuid = '" + loginuaid
						+ "' or exists(select id from consulting_sale c where c.sales_key=ms.msrefid and c.consultant_uaid='"
						+ loginuaid + "'))");

			if (!InvoiceNo.equalsIgnoreCase("NA"))
				queryselect.append(" and ms.msinvoiceno='" + InvoiceNo + "' ");
			if (!PhoneKey.equalsIgnoreCase("NA"))
				queryselect.append(" and ms.mscontactrefid='" + PhoneKey + "' ");
			if (!contactName.equalsIgnoreCase("NA"))
				queryselect.append(" and c.cbname='" + contactName + "' ");
			if (!ProductName.equalsIgnoreCase("NA"))
				queryselect.append(" and ms.msproductname='" + ProductName + "' ");
			if (!ClientName.equalsIgnoreCase("NA"))
				queryselect.append(" and ms.mscompany='" + ClientName + "' ");
			if (!SoldByUid.equalsIgnoreCase("NA"))
				queryselect.append(" and ms.mssoldbyuid='" + SoldByUid + "' ");
			if (!fromDate.equalsIgnoreCase("NA") && !toDate.equalsIgnoreCase("NA")) {
				queryselect.append(" and str_to_date(ms.mssolddate,'%d-%m-%Y')<='" + toDate
						+ "' and str_to_date(ms.mssolddate,'%d-%m-%Y')>='" + fromDate + "' ");
			}
			queryselect.append("group by ms.msid ");
			if (sort.length() <= 0)
				queryselect.append("order by ms.msid desc limit " + ((page - 1) * rows) + "," + rows);
			else if (sort.equals("date"))
				queryselect.append("order by str_to_date(ms.mssolddate,'%d-%m-%Y') " + order + " limit "
						+ ((page - 1) * rows) + "," + rows);
			else if (sort.equals("estimate"))
				queryselect.append("order by cast(SUBSTRING(ms.msestimateno,6) as unsigned) " + order + " limit "
						+ ((page - 1) * rows) + "," + rows);
			else if (sort.equals("project"))
				queryselect.append("order by cast(SUBSTRING(ms.msprojectnumber,6) as unsigned)" + order + " limit "
						+ ((page - 1) * rows) + "," + rows);
			else if (sort.equals("product"))
				queryselect.append("order by ms.msproductname " + order + " limit " + ((page - 1) * rows) + "," + rows);
			else if (sort.equals("company"))
				queryselect.append("order by ms.mscompany " + order + " limit " + ((page - 1) * rows) + "," + rows);
			else if (sort.equals("progress"))
				queryselect.append("order by cast(ms.msworkpercent as unsigned) " + order + " limit "
						+ ((page - 1) * rows) + "," + rows);

//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect.toString());
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
			e.printStackTrace();
			log.info("getAllSales" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getAllSales" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllSales(String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			StringBuffer queryselect = new StringBuffer(
					"SELECT msrefid,msinvoiceno,msworkpercent FROM managesalesctrl where msstatus='1' and mstoken='"
							+ token + "' ");

			ps = con.prepareStatement(queryselect.toString());
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
			log.info("getAllSales" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getAllSales" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllSales(String invoice, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			StringBuffer queryselect = new StringBuffer(
					"SELECT msrefid,msproductname FROM managesalesctrl where msstatus='1' and msinvoiceno='" + invoice
							+ "' and mstoken='" + token + "'");
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect.toString());
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
			log.info("getAllSales" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getAllSales" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String getSalesKey(String invoiceNo, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String newsdata = "NA";
		try {
			String queryselect = "SELECT msrefid FROM managesalesctrl where (msinvoiceno ='" + invoiceNo
					+ "' or msestimateno='" + invoiceNo + "') and mstoken='" + token + "' limit 1";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rsGCD = ps.executeQuery();

			while (rsGCD != null && rsGCD.next()) {
				newsdata = rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("getSalesKey" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getSalesKey" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String getTokenByInvoiceKey(String invoiceKey) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String newsdata = "NA";
		try {
			String queryselect = "SELECT token FROM manage_invoice where refkey ='" + invoiceKey + "' limit 1";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rsGCD = ps.executeQuery();

			while (rsGCD != null && rsGCD.next()) {
				newsdata = rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("getTokenByInvoiceKey" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getTokenByInvoiceKey" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String getEstimateKey(String estimateNo, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String newsdata = "NA";
		try {
			String queryselect = "SELECT esrefid FROM estimatesalectrl where essaleno ='" + estimateNo
					+ "' and estoken='" + token + "' limit 1";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rsGCD = ps.executeQuery();

			while (rsGCD != null && rsGCD.next()) {
				newsdata = rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("getEstimateKey" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getEstimateKey" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String getSalesPayType(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String newsdata = "NA";
		try {
			String queryselect = "SELECT smpaytype FROM salesmilestonectrl where smsalesrefid ='" + salesKey
					+ "' and smtoken='" + token + "' limit 1";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rsGCD = ps.executeQuery();

			while (rsGCD != null && rsGCD.next()) {
				newsdata = rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("getSalesPayType" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getSalesPayType" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String getToken(String estKey) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String newsdata = "NA";
		try {
			String queryselect = "SELECT estoken FROM estimatesalectrl where esrefid ='" + estKey + "' limit 1";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rsGCD = ps.executeQuery();

			while (rsGCD != null && rsGCD.next()) {
				newsdata = rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("getToken" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getToken" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static int countHoldPayment(String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		int newsdata = 0;
		try {
			String queryselect = "SELECT count(sid) FROM salesestimatepayment where stransactionstatus='4' and stokenno ='"
					+ token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rsGCD = ps.executeQuery();

			if (rsGCD != null && rsGCD.next()) {
				newsdata = rsGCD.getInt(1);
			}
		} catch (Exception e) {
			log.info("countHoldPayment" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("countHoldPayment" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String getPaymentToken(String salesKey) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String newsdata = "NA";
		try {
			String queryselect = "SELECT stokenno FROM salesestimatepayment where srefid ='" + salesKey + "' limit 1";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rsGCD = ps.executeQuery();

			while (rsGCD != null && rsGCD.next()) {
				newsdata = rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("getPaymentToken" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getPaymentToken" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String getSalesToken(String salesKey) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String newsdata = "NA";
		try {
			String queryselect = "SELECT mstoken FROM managesalesctrl where msrefid ='" + salesKey + "' limit 1";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rsGCD = ps.executeQuery();

			while (rsGCD != null && rsGCD.next()) {
				newsdata = rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("getSalesToken" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getSalesToken" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String getSalesClientKey(String invoice, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String newsdata = "NA";
		try {
			String queryselect = "SELECT msclientrefid FROM managesalesctrl where msinvoiceno='" + invoice
					+ "' and mstoken='" + token + "' limit 1";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rsGCD = ps.executeQuery();

			while (rsGCD != null && rsGCD.next()) {
				newsdata = rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("getSalesClientKey" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getSalesClientKey" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String getEstimateClientKeyBySalesNo(String salesNo) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String newsdata = "NA";
		try {
			String queryselect = "SELECT esclientrefid FROM estimatesalectrl where essaleno='" + salesNo + "' limit 1";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rsGCD = ps.executeQuery();

			while (rsGCD != null && rsGCD.next()) {
				newsdata = rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("getEstimateClientKeyBySalesNo" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getEstimateClientKeyBySalesNo" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String getEstimateClientKey(String estKey) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String newsdata = "NA";
		try {
			String queryselect = "SELECT esclientrefid FROM estimatesalectrl where esrefid='" + estKey + "' limit 1";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rsGCD = ps.executeQuery();

			while (rsGCD != null && rsGCD.next()) {
				newsdata = rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("getEstimateClientKey" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getEstimateClientKey" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String getClientKey(String contKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String newsdata = "NA";
		try {
			String queryselect = "SELECT ccbclientrefid FROM clientcontactbox where ccbrefid='" + contKey
					+ "' and cctokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rsGCD = ps.executeQuery();

			while (rsGCD != null && rsGCD.next()) {
				newsdata = rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("getClientKey" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getClientKey" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String getEstimateSalesSoldByUaid(String estimateNo, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String newsdata = "NA";
		try {
			String queryselect = "SELECT essoldbyid FROM estimatesalectrl where essaleno='" + estimateNo
					+ "' and estoken='" + token + "' order by esid limit 1";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rsGCD = ps.executeQuery();

			while (rsGCD != null && rsGCD.next()) {
				newsdata = rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("getEstimateSalesSoldByUaid" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getEstimateSalesSoldByUaid" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String getSalesSoldByUaid(String invoice, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String newsdata = "NA";
		try {
			String queryselect = "SELECT mssoldbyuid FROM managesalesctrl where (msinvoiceno='" + invoice
					+ "' or msestimateno='" + invoice + "') and mstoken='" + token + "' order by msid limit 1";
			ps = con.prepareStatement(queryselect);
			rsGCD = ps.executeQuery();

			while (rsGCD != null && rsGCD.next()) {
				newsdata = rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("getSalesSoldByUaid" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getSalesSoldByUaid" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String getSalesUuidByInvoice(String invoice, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String newsdata = "NA";
		try {
			String queryselect = "SELECT msrefid FROM managesalesctrl where msinvoiceno='" + invoice + "' and mstoken='"
					+ token + "' limit 1";
			ps = con.prepareStatement(queryselect);
			rsGCD = ps.executeQuery();

			while (rsGCD != null && rsGCD.next()) {
				newsdata = rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("getSalesUuidByInvoice" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getSalesUuidByInvoice" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String getSalesContactKeyByInvoice(String invoice, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String newsdata = "NA";
		try {
			String queryselect = "SELECT mscontactrefid FROM managesalesctrl where msinvoiceno='" + invoice
					+ "' and mstoken='" + token + "' limit 1";
			ps = con.prepareStatement(queryselect);
			rsGCD = ps.executeQuery();

			while (rsGCD != null && rsGCD.next()) {
				newsdata = rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("getSalesContactKeyByInvoice" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getSalesContactKeyByInvoice" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String getEstimateContactKey(String estimateKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String newsdata = "NA";
		try {
			String queryselect = "SELECT escontactrefid FROM estimatesalectrl where esrefid='" + estimateKey
					+ "' and estoken='" + token + "'";
			ps = con.prepareStatement(queryselect);
			rsGCD = ps.executeQuery();

			while (rsGCD != null && rsGCD.next()) {
				newsdata = rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("getEstimateContactKey" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getEstimateContactKey" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String getSalesContactKey(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String newsdata = "NA";
		try {
			String queryselect = "SELECT mscontactrefid FROM managesalesctrl where msrefid='" + salesKey
					+ "' and mstoken='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rsGCD = ps.executeQuery();

			while (rsGCD != null && rsGCD.next()) {
				newsdata = rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("getSalesContactKey" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getSalesContactKey" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getContactKey(String contactKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String queryselect = "SELECT cbcontactrefid FROM contactboxctrl where cbrefid='" + contactKey
					+ "' and cbtokenno='" + token + "'";
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
			log.info("getContactKey" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getContactKey" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getEstimateProducts(String estimateno, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String queryselect = "SELECT esrefid,escompany,esprodtype,esprodqty,esprodname,esprodplan,esplanperiod,esplantime"
					+ ",esregdate,essoldbyid,escontactrefid,esclientrefid,esremarks,esinvoicenotes,esjurisdiction,esordernumber"
					+ ",espurchasedate,tat_value,tat_type,sales_type FROM estimatesalectrl where essaleno='"
					+ estimateno + "' " + "and estoken='" + token + "' order by esid";
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
			log.info("getEstimateProducts" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getEstimateProducts" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getProductMilestone(String prodrefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String queryselect = "SELECT pm_prodrefid,pm_milestonename,pm_timelinevalue,pm_timelineunit,pmsteps,pm_assign,pm_pricepercent,pmid FROM product_milestone where pm_prodrefid='"
					+ prodrefid + "' and pm_tokeno='" + token + "'";
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
			log.info("getProductMilestone" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getProductMilestone" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getSalesDocumentList(String prodrefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String queryselect = "SELECT pd_docname,pd_description,pd_uploadby,pd_visibility FROM product_documents where pd_prodrefid='"
					+ prodrefid + "' and pd_token='" + token + "'";
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
			log.info("getSalesDocumentList" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getSalesDocumentList" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getEstimateSalesPrice(String esrefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
//			String queryselect = "SELECT spprodrefid,sppricetype,spminpriceofone,sphsncode,spcgstpercent,spsgstpercent,spigstpercent FROM salesproductprice where spessalerefid='"+esrefid+"' and sptokenno='"+token+"'";
			String queryselect = "SELECT spprodrefid,sppricetype,spprice,sphsncode,spcgstpercent,spsgstpercent,spigstpercent FROM salesproductprice where spessalerefid='"
					+ esrefid + "' and sptokenno='" + token + "'";
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
			log.info("getEstimateSalesPrice" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getEstimateSalesPrice" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getProductsRefid(String invoiceno, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String queryselect = "SELECT spprodrefid FROM salesproductprice where spsalesid='" + invoiceno
					+ "' and sptokenno='" + token + "' group by spprodrefid order by spid";
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
			log.info("getProductsRefid" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getProductsRefid" + e.getMessage());
			}
		}
		return newsdata;
	}

	/* For providing uniqueid to estimate invoice */
	public static String[][] getClientDetails(String contactref, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String queryselect = "SELECT cbname,cbmobile1st,cbid,cbcontactrefid,cbmobile2nd,cbemail1st,cbemail2nd FROM contactboxctrl where cbrefid='"
					+ contactref + "' and cbtokenno='" + token + "' order by cbid";
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
			log.info("getClientDetails" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getClientDetails" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getInvoiceClientDetails(String contactref, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String queryselect = "SELECT c.cbname,cb.ccpan,cb.cccountry,cb.ccstate,cb.cccity,cb.ccaddress,cb.ccstatecode FROM contactboxctrl c INNER JOIN clientcontactbox cb on c.cbcontactrefid=cb.ccbrefid where c.cbrefid='"
					+ contactref + "' and c.cbtokenno='" + token + "' order by c.cbid";
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
			log.info("getInvoiceClientDetails" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getInvoiceClientDetails" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String findInvoicedSalesType(String salesNo, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT sales_type FROM managesalesctrl where msinvoiceno='" + salesNo
					+ "' and mstoken='" + token + "' limit 1";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("findInvoicedSalesType" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("findInvoicedSalesType" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String findSalesType(String salesNo, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT sales_type FROM estimatesalectrl where essaleno='" + salesNo
					+ "' and estoken='" + token + "' limit 1";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("findSalesType" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("findSalesType" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getSalesPricePercentage(String estrefid, String mid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT epworkpaytype,epworkpricepercentage FROM estimateconvert_pricepercentage where epsalesrefid='"
					+ estrefid + "' and epmilestoneid='" + mid + "' and eptokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getString(1);
				if (getinfo.equalsIgnoreCase("Full Pay")) {
					getinfo = "100";
				} else if (getinfo.equalsIgnoreCase("Partial Pay")) {
					getinfo = "50";
				} else if (getinfo.equalsIgnoreCase("Milestone Pay")) {
					getinfo = rset.getString(2);
				}
				getinfo = getinfo + "#" + rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getSalesPricePercentage" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getSalesPricePercentage" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String[] getSalesNumber(String estimateKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo[] = new String[6];
		try {
			String queryselect = "SELECT essaleno,esclientrefid,esregdate,escontactrefid,esordernumber,espurchasedate FROM estimatesalectrl where esrefid='"
					+ estimateKey + "' and estoken='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo[0] = rset.getString(1);
				getinfo[1] = rset.getString(2);
				getinfo[2] = rset.getString(3);
				getinfo[3] = rset.getString(4);
				getinfo[4] = rset.getString(5);
				getinfo[5] = rset.getString(6);
			}
		} catch (Exception e) {
			log.info("getSalesNumber" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getSalesNumber" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String[] getPaymentData(String srefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo[] = new String[9];
		try {
			String queryselect = "SELECT saddeddate,sestsaleno,sinvoiceno,sapproveddate,stransactionamount,stransactionstatus,service_name,payment_invoice,sunbill_no FROM salesestimatepayment where srefid='"
					+ srefid + "' and stokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo[0] = rset.getString(1);
				getinfo[1] = rset.getString(2);
				getinfo[2] = rset.getString(3);
				getinfo[3] = rset.getString(4);
				getinfo[4] = rset.getString(5);
				getinfo[5] = rset.getString(6);
				getinfo[6] = rset.getString(7);
				getinfo[7] = rset.getString(8);
				getinfo[8] = rset.getString(9);
			}
		} catch (Exception e) {
			log.info("getPaymentData" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getPaymentData" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String[] getInvoiceSalesNumber(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo[] = new String[6];
		try {
			String queryselect = "SELECT msinvoiceno,msclientrefid,mssolddate,mscontactrefid,msordernumber,mspurchasedate FROM managesalesctrl where msrefid='"
					+ salesKey + "' and mstoken='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo[0] = rset.getString(1);
				getinfo[1] = rset.getString(2);
				getinfo[2] = rset.getString(3);
				getinfo[3] = rset.getString(4);
				getinfo[4] = rset.getString(5);
				getinfo[5] = rset.getString(6);
			}
		} catch (Exception e) {
			log.info("getInvoiceSalesNumber" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getInvoiceSalesNumber" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String[] getSalesDataByUnbill(String msrefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo[] = new String[2];
		try {
			String queryselect = "SELECT mscontactrefid,msproductname FROM managesalesctrl where msrefid='" + msrefid
					+ "' and mstoken='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo[0] = rset.getString(1);
				getinfo[1] = rset.getString(2);
			}
		} catch (Exception e) {
			log.info("getSalesDataByUnbill" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getSalesDataByUnbill" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String[] getSalesDataForInvoice(String invoice, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo[] = new String[3];
		try {
			String queryselect = "SELECT msclientrefid,mssolddate FROM managesalesctrl where msinvoiceno='" + invoice
					+ "' and mstoken='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo[0] = rset.getString(1);
				getinfo[1] = rset.getString(2);
			}
		} catch (Exception e) {
			log.info("DownloadSalesInvoice.getSalesDataForInvoice" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("DownloadSalesInvoice.getSalesDataForInvoice" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getCompanyAddress(String compname, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT cregaddress FROM hrmclient_reg where cregname='" + compname
					+ "' and cregtokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getCompanyAddress" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getCompanyAddress" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getFileName(String docrefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT sddocname FROM salesdocumentctrl where sdrefid='" + docrefid
					+ "' and sdtokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getFileName" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getFileName" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getBillingInvoiceNumber(String invoiceno, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT cbinvoiceno FROM hrmclient_billing where (cbestimateno='" + invoiceno
					+ "' or cbinvoiceno='" + invoiceno + "') and cbtokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getBillingInvoiceNumber" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getBillingInvoiceNumber" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getProductName(String salesno, String productName) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT esprodname FROM estimatesalectrl where essaleno='" + salesno
					+ "' and esprodname='" + productName + "'";
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getInvoiceNumber" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getInvoiceNumber" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getInvoiceNumber(String salesno, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT cbinvoiceno FROM hrmclient_billing where cbestimateno='" + salesno
					+ "' and cbtokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getInvoiceNumber" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getInvoiceNumber" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String[] getProductJurisdiction(String prodrefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo[] = new String[3];
		try {
			String queryselect = "SELECT pcentral,pstate,pglobal FROM product_master where prefid='" + prodrefid
					+ "' and ptokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo[0] = rset.getString(1);
				getinfo[1] = rset.getString(2);
				getinfo[2] = rset.getString(3);
			}
		} catch (Exception e) {
			log.info("getProductRefId" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getProductRefId" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String[] getProductRefId(String prodtype, String prodname, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo[] = new String[4];
		try {
			String queryselect = "SELECT prefid,pcentral,pstate,pglobal FROM product_master where ptype='" + prodtype
					+ "' and pname='" + prodname + "' and ptokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo[0] = rset.getString(1);
				getinfo[1] = rset.getString(2);
				getinfo[2] = rset.getString(3);
				getinfo[3] = rset.getString(4);
			}
		} catch (Exception e) {
			log.info("getProductRefId" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getProductRefId" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static boolean isPaymentInvoiceExist(String invoice, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		boolean getinfo = false;
		try {
			String queryselect = "SELECT sid FROM salesestimatepayment where payment_invoice='" + invoice
					+ "' and stokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = true;
			}
		} catch (Exception e) {
			log.info("isPaymentInvoiceExist" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("isPaymentInvoiceExist" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static boolean isPaymentInvoiceReminderExist(int paymentId) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		boolean getinfo = false;
		try {
			String queryselect = "SELECT id FROM po_reminder where payment_id='" + paymentId + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = true;
			}
		} catch (Exception e) {
			log.info("isPaymentInvoiceReminderExist" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("isPaymentInvoiceReminderExist" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static boolean isInvoiceExist(String saleno, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		boolean getinfo = false;
		try {
			String queryselect = "SELECT cbuid FROM hrmclient_billing where cbinvoiceno='" + saleno
					+ "' and cbtokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = true;
			}
		} catch (Exception e) {
			log.info("isInvoiceExist" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("isInvoiceExist" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static boolean isEstimateExist(String saleno, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		boolean getinfo = false;
		try {
			String queryselect = "SELECT cbuid FROM hrmclient_billing where cbestimateno='" + saleno
					+ "' and cbtokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = true;
			}
		} catch (Exception e) {
			log.info("isEstimateExist" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("isEstimateExist" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double getSalesPaidAmount(String estimateNo, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT sum(stransactionamount) FROM salesestimatepayment where sestsaleno='"
					+ estimateNo + "' and stokenno='" + token + "' and stransactionstatus!='3'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getSalesPaidAmount" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getSalesPaidAmount" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double getProductAmount(String salesrefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT sum(sptotalprice) FROM salespricectrl where spsalesrefid='" + salesrefid
					+ "' and sptokenno='" + token + "' and spstatus='1'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getProductAmount" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getProductAmount" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double getBillingOrderAmount(String invoiceno, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT cborderamount FROM hrmclient_billing where (cbestimateno='" + invoiceno
					+ "' or cbinvoiceno='" + invoiceno + "') and cbtokenno='" + token + "'";
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getBillingOrderAmount" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getBillingOrderAmount" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double getTotalDiscountPrice(String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT sum(cbdiscount) FROM hrmclient_billing where cbinvoiceno!='NA' and cbtokenno='"
					+ token + "'";
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getTotalDiscountPrice" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getTotalDiscountPrice" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double getSalesOrderAmount(String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT sum(cborderamount) FROM hrmclient_billing where cbinvoiceno!='NA' and cbtokenno='"
					+ token + "'";
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getSalesOrderAmount" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getSalesOrderAmount" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getPONumber(String refid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT stransactionid FROM salesestimatepayment where srefid='" + refid
					+ "' and stokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getPONumber" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getPONumber" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getPaymentModeByInvoice(String invoice, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT spaymtmode FROM salesestimatepayment where sinvoiceno='" + invoice + "'"
					+ " and stransactionstatus='1' and stokenno='" + token + "' order by sid limit 1";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getPaymentMode" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getPaymentMode" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getPaymentMode(String refid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT spaymtmode FROM salesestimatepayment where srefid='" + refid
					+ "' and stokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getPaymentMode" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getPaymentMode" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double getTransactionAmount(String refid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT stransactionamount FROM salesestimatepayment where srefid='" + refid
					+ "' and stokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getTransactionAmount" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getTransactionAmount" + e.getMessage());
			}
		}
		return getinfo;
	}

	/* For providing uniqueid to estimate invoice */
	public static double getProductPrice(String saleno, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT sum(sptotalprice) FROM salesproductprice where spsalesid='" + saleno
					+ "' and sptokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getProductPrice" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getProductPrice" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double getPaidAmount(String salesno, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT sum(stransactionamount) FROM salesestimatepayment where sestsaleno='" + salesno
					+ "' and stransactionstatus='1' and stokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getPaidAmount" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getPaidAmount" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double getOrderAmount(String salesno, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT sum(sptotalprice) FROM salesproductprice where spsalesid='" + salesno
					+ "' and sptokenno='" + token + "'";

			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);

			}
		} catch (Exception e) {
			log.info("getOrderAmount" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getOrderAmount" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double getEstimateFirstMilestonePercent(String saleskey, String productKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 1;
		try {
			String queryselect = "SELECT e.epworkpricepercentage FROM estimateconvert_pricepercentage e left join product_milestone p "
					+ "on e.epmilestoneid=p.pmid where e.epsalesrefid='" + saleskey + "' and " + "p.pm_prodrefid='"
					+ productKey + "' and " + "p.pm_tokeno='" + token + "' and p.pmsteps='1' limit 1";
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);

			}
		} catch (Exception e) {
			log.info("getEstimateFirstMilestonePercent" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getEstimateFirstMilestonePercent" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getSalesProductKey(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT spprodrefid FROM salesproductprice where spessalerefid='" + salesKey
					+ "' and sptokenno='" + token + "' limit 1";

			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getString(1);

			}
		} catch (Exception e) {
			log.info("getSalesProductKey" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getSalesProductKey" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double getEstimateSaleOrderAmount(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT sum(sptotalprice) FROM salesproductprice where spessalerefid='" + salesKey
					+ "' and sptokenno='" + token + "'";

			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);

			}
		} catch (Exception e) {
			log.info("getEstimateSaleOrderAmount" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getEstimateSaleOrderAmount" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double getSalesTax(double orderamt, String salesno, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT * FROM salesproductprice where spsalesid='" + salesno + "' and sptokenno='"
					+ token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getDouble(1) + rset.getDouble(2) + rset.getDouble(3);
			}
		} catch (Exception e) {
			log.info("getSalesTax" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getSalesTax" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getClientKeyBySalesKey(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT msclientrefid FROM managesalesctrl where msrefid='" + salesKey
					+ "' and mstoken='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getClientKeyBySalesKey" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getClientKeyBySalesKey" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getSalesCloseDate(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT project_close_date FROM managesalesctrl where msrefid='" + salesKey
					+ "' and mstoken='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getSalesCloseDate" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getSalesCloseDate" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getSalesRegDate(String unbillNo) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT mssolddate FROM managesalesctrl where msinvoiceno='" + unbillNo + "' limit 1";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getSalesRegDate" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getSalesRegDate" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double getSalesWorkProgress(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT msworkpercent FROM managesalesctrl where msrefid='" + salesKey
					+ "' and mstoken='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getSalesWorkProgress" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getSalesWorkProgress" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double getOrderAmountWithoutTax(String salesno, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT sum(spprice) FROM salesproductprice where spsalesid='" + salesno
					+ "' and sptokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getOrderAmountWithoutTax" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getOrderAmountWithoutTax" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String[] getCompanyDetail(String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String[] getinfo = new String[2];
		try {
			String queryselect = "SELECT compstatecode,compgstin FROM company_master where  comptokenno='" + token
					+ "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo[0] = rset.getString(1);
				getinfo[1] = rset.getString(2);
			}
		} catch (Exception e) {
			log.info("getCompanyDetail" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getCompanyDetail" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String[] getClientCompanyDetail(String compname, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String[] getinfo = new String[2];
		try {
			String queryselect = "SELECT cregstatecode,creggstin FROM hrmclient_reg where cregname='" + compname
					+ "' and cregtokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo[0] = rset.getString(1);
				getinfo[1] = rset.getString(2);
			}
		} catch (Exception e) {
			log.info("getClientCompanyDetail" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getClientCompanyDetail" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String[] getContactDetail(String contactrefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String[] getinfo = new String[7];
		try {
			String queryselect = "SELECT c.cbname,cc.ccaddress,cc.ccstate,cc.ccstatecode,cc.ccpan,"
					+ "cc.cccity,cc.cccountry FROM contactboxctrl c INNER JOIN "
					+ "clientcontactbox cc on c.cbcontactrefid=cc.ccbrefid where c.cbrefid='" + contactrefid
					+ "' and c.cbtokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo[0] = rset.getString(1);
				getinfo[1] = rset.getString(2);
				getinfo[2] = rset.getString(3);
				getinfo[3] = rset.getString(4);
				getinfo[4] = rset.getString(5);
				getinfo[5] = rset.getString(6);
				getinfo[6] = rset.getString(7);
			}
		} catch (Exception e) {
			log.info("getContactDetail" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getContactDetail" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String[] getClientsDetail(String clientrefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String[] getinfo = new String[5];
		try {
			String queryselect = "SELECT cregname,cregaddress,cregstate,cregstatecode,creggstin FROM hrmclient_reg where cregclientrefid='"
					+ clientrefid + "' and cregtokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo[0] = rset.getString(1);
				getinfo[1] = rset.getString(2);
				getinfo[2] = rset.getString(3);
				getinfo[3] = rset.getString(4);
				getinfo[4] = rset.getString(5);
			}
		} catch (Exception e) {
			log.info("getClientsDetail" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getClientsDetail" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String[] getClientsDetail(String clientrefid) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String[] getinfo = new String[5];
		try {
			String queryselect = "SELECT cregname,cregaddress,cregstate,cregstatecode,creggstin FROM hrmclient_reg where cregclientrefid='"
					+ clientrefid + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo[0] = rset.getString(1);
				getinfo[1] = rset.getString(2);
				getinfo[2] = rset.getString(3);
				getinfo[3] = rset.getString(4);
				getinfo[4] = rset.getString(5);
			}
		} catch (Exception e) {
			log.info("getClientsDetail" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getClientsDetail" + e.getMessage());
			}
		}
		return getinfo;
	}

	/* For providing uniqueid to estimate invoice */
	public static String[] getFolderDetails(String salesrefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String[] getinfo = new String[2];
		try {
			String queryselect = "SELECT frefid,fname FROM folder_master where fsalesrefid='" + salesrefid
					+ "' and ftokenno='" + token + "'";
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo[0] = rset.getString(1);
				getinfo[1] = rset.getString(2);
			}
		} catch (Exception e) {
			log.info("getFolderDetails" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getFolderDetails" + e.getMessage());
			}
		}
		return getinfo;
	}

	/* getting last follow-up status */
	public static String getLastStatus(String enqid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT enqfstatus FROM userenquiryfollowup where enqfeuid='" + enqid
					+ "' and enqftokenno='" + token + "' order by enqfuid desc limit 1";
			ps = con.prepareStatement(queryselect);
//			System.out.println(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getSalesClientName" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getSalesClientName" + e.getMessage());
			}
		}
		return getinfo;
	}

	/* getting client name */
	public static int getProductNumber(String salesid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		int getinfo = 0;
		try {
			String queryselect = "SELECT spvsalesno FROM salesproductvirtual where spvsalesid='" + salesid
					+ "' and spvtokenno='" + token + "' order by spvid desc limit 1";
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getInt(1);
			}
		} catch (Exception e) {
			log.info("getProductNumber" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getProductNumber" + e.getMessage());
			}
		}
		return getinfo;
	}

	/* getting client name */
	public static String getSalesClientName(String salesrefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = null;
		try {
			String queryselect = "SELECT enqCompanyName FROM userenquiry where enqrefid='" + salesrefid
					+ "' and enqTokenNo='" + token + "'";
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getSalesClientName" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getSalesClientName" + e.getMessage());
			}
		}
		return getinfo;
	}

	/* getting folder refrence id */
	public static String getFolderRefIdByClientId(String clientid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT frefid FROM folder_master where fclientid='" + clientid + "' and ftokenno='"
					+ token + "'";
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getFolderRefIdByClientId" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getFolderRefIdByClientId" + e.getMessage());
			}
		}
		return getinfo;
	}

	/* getting folder refrence id */
	public static String getFolderRefId(String salesrefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = null;
		try {
			String queryselect = "SELECT frefid FROM folder_master where fsalesrefid='" + salesrefid
					+ "' and ftokenno='" + token + "'";
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getFolderRefId" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getFolderRefId" + e.getMessage());
			}
		}
		return getinfo;
	}

	/* For providing uniqueid to estimate invoice */
	public static String getuniquecode(String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = null;
		try {
			String queryselect = "SELECT estinvoiceno FROM estimateinvoicectrl where esttokenno='" + token
					+ "' order by estid desc limit 1";
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getuniquecode" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getuniquecode" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static boolean isGstApplied(String gen_key) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			ps = con.prepareStatement("select id from generate_estimate_details where generate_key='" + gen_key
					+ "' and (cgst!='0' or sgst!='0' or igst!='0') limit 1");
//			System.out.println("select id from generate_estimate_details where generate_key='"+gen_key+"' and cgst!='0' and sgst!='0' and igst!='0' limit 1");
			rs = ps.executeQuery();
			if (rs != null && rs.next())
				flag = true;
		} catch (Exception e) {
			e.printStackTrace();
			log.info("isGstApplied()" + e.getMessage());
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
				log.info("Error Closing isGstApplied() SQL Objects \n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean isProductInOrder(String prodrefid, String salesno, String token, String addedby) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			ps = con.prepareStatement("select spid from salesproductprice where spprodrefid='" + prodrefid
					+ "' and spsalesid='" + salesno + "' and sptokenno='" + token + "'");
			rs = ps.executeQuery();
			if (rs != null && rs.next())
				flag = true;
		} catch (Exception e) {
			log.info("isProductInOrder()" + e.getMessage());
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
				log.info("Error Closing isProductInOrder() SQL Objects \n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean isProductContactExist(String estimateNo, String token, String addedby) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			ps = con.prepareStatement("select scvid from salescontactboxvirtual where " + "scvsalesid='" + estimateNo
					+ "' and scvaddedby='" + addedby + "' " + "and scvtokenno='" + token + "' "
					+ "and (scvcontactrefid=null or scvcontactrefid='' or scvcontactrefid='NA'"
					+ " or scvcontactname=null or scvcontactname='' or scvcontactemail1st=null or "
					+ "scvcontactemail1st='' or scvcontactmobile1st=null or scvcontactmobile1st='')");
			rs = ps.executeQuery();
			if (rs != null && rs.next())
				flag = true;
		} catch (Exception e) {
			e.printStackTrace();
			log.info("isProductContactExist()" + e.getMessage());
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
				log.info("Error Closing isProductContactExist() SQL Objects \n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean isProductInCart(String prodrefid, String token, String addedby) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			ps = con.prepareStatement("select spvid from salesproductvirtual where spvrefpid='" + prodrefid
					+ "' and spvaddedby='" + addedby + "' and spvtokenno='" + token + "'");
			rs = ps.executeQuery();
			if (rs != null && rs.next())
				flag = true;
		} catch (Exception e) {
			log.info("isProductInCart()" + e.getMessage());
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
				log.info("Error Closing isProductInCart() SQL Objects \n" + sqle.getMessage());
			}
		}
		return flag;
	}

	/* checking contact already added in contact virtual table or not */
	public static boolean isContactExist(String mobile, String salesid, String token, String addedby, String email) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "select scvid from salescontactboxvirtual where " + "scvsalesid='" + salesid
					+ "' and (scvcontactmobile1st='" + mobile + "' or scvcontactmobile2nd='" + mobile + "' "
					+ "or scvcontactemail1st='" + email + "' or scvcontactemail2nd='" + email + "')"
					+ " and scvtokenno='" + token + "' and scvaddedby='" + addedby + "'";
//			System.out.println(query);
			ps = con.prepareStatement(query);
			rs = ps.executeQuery();
			if (rs.next()) {
				flag = true;
			}
		} catch (Exception e) {
			log.info("isContactExist()" + e.getMessage());
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
				log.info("Error Closing isContactExist() SQL Objects \n" + sqle.getMessage());
			}
		}
		return flag;
	}

	/* checking estimate invoice send or not */
	public static boolean isEstimateInvoiceSend(String srefid) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			ps = con.prepareStatement("select estid from estimateinvoicectrl where estsalesrefid='" + srefid + "'");
			rs = ps.executeQuery();
			if (rs.next()) {
				if (rs.getString(1) != null)
					flag = true;
			}
		} catch (Exception e) {
			log.info("isEstimateInvoiceSend()" + e.getMessage());
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
				log.info("Error Closing isEstimateInvoiceSend() SQL Objects \n" + sqle.getMessage());
			}
		}
		return flag;
	}

	/* saving project milestone */
	@SuppressWarnings("resource")
	public static boolean deleteSalesDocument(String dmuid) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		String docpath = "NA";
		try {
			ps = con.prepareStatement("select dmdocumentpath from document_master where dmuid='" + dmuid + "'");
			rs = ps.executeQuery();
			if (rs.next())
				docpath = rs.getString(1);

			File file = new File(docpath);
			if (file.exists())
				file.delete();

			ps = con.prepareStatement("delete from document_master where dmuid='" + dmuid + "'");
			ps.execute();
			flag = true;
		} catch (Exception e) {
			log.info("deleteSalesDocument()" + e.getMessage());
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
				log.info("Error Closing deleteSalesDocument() SQL Objects \n" + sqle.getMessage());
			}
		}
		return flag;
	}

	public static boolean deleteSalesDocumentHistory(String id) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			ps = con.prepareStatement("update salesdochistory set document_name='NA' where id='" + id + "'");
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			e.printStackTrace();
			log.info("deleteSalesDocumentHistory()" + e.getMessage());
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
				log.info("Error Closing deleteSalesDocumentHistory() SQL Objects \n" + sqle.getMessage());
			}
		}
		return flag;
	}

	/* saving project milestone */
	@SuppressWarnings("resource")
	public static boolean deleteSalesPayment(String srefid) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			ps = con.prepareStatement("delete from salesestimatepayment where srefid='" + srefid + "'");
			ps.execute();
			flag = true;
		} catch (Exception e) {
			log.info("deleteSalesPayment()" + e.getMessage());
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
				log.info("Error Closing deleteSalesPayment() SQL Objects \n" + sqle.getMessage());
			}
		}
		return flag;
	}

	/* saving project milestone */
	@SuppressWarnings("resource")
	public static void deletePriceMilestone(String uid, String token, String enq) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement("delete from project_price where preguid='" + uid + "' and tokenno='" + token
					+ "' and enq='" + enq + "'");
			ps.execute();

			ps = con.prepareStatement("delete from project_milestone where preguid='" + uid + "' and tokenno='" + token
					+ "' and enq='" + enq + "'");
			ps.execute();
		} catch (Exception e) {
			log.info("deletePriceMilestone()" + e.getMessage());
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
				log.info("Error Closing deletePriceMilestone() SQL Objects \n" + sqle.getMessage());
			}
		}

	}

	public static int[] getTotalTime(String prodrefid, String token) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		int[] data = new int[4];
		Connection con = DbCon.getCon("", "", "");
		try {
			int day = 0;
			int week = 0;
			int month = 0;
			int year = 0;
			ps = con.prepareStatement(
					"select pm_timelineunit,pm_timelinevalue from product_milestone where pm_prodrefid='" + prodrefid
							+ "' and pm_tokeno='" + token + "'");
			rs = ps.executeQuery();
			while (rs.next()) {
				if (rs.getString(1).equalsIgnoreCase("Day")) {
					day += rs.getInt(2);
				} else if (rs.getString(1).equalsIgnoreCase("Week")) {
					week += rs.getInt(2);
				} else if (rs.getString(1).equalsIgnoreCase("Month")) {
					month += rs.getInt(2);
				} else if (rs.getString(1).equalsIgnoreCase("Year")) {
					year += rs.getInt(2);
				}
			}
			data[0] = day;
			data[1] = week;
			data[2] = month;
			data[3] = year;
		} catch (Exception e) {
			log.info("getTotalTime()" + e.getMessage());
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
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getTotalTime\n" + sqle.getMessage());
			}
		}
		return data;
	}

	/* getting product type */
//	public static double[] getEstimateApprovedPayment(String enqid,String token) {
//		PreparedStatement ps = null;		
//		ResultSet rs=null;
//		double[] data=new double[2];
//		Connection con = DbCon.getCon("","","");
//		try{
//			ps=con.prepareStatement("select enqproduct_type from userenquiry where enqid='"+enqid+"' and enqTokenNo='"+token+"'");
//			rs=ps.executeQuery();
//			if(rs.next()) result=rs.getString(1);			
//			
//		}
//		catch (Exception e) {
//			log.info("getProductType()"+e.getMessage());
//		}
//		finally{
//			try{
//				if(ps!=null) {ps.close();}				
//				if(con!=null) {con.close();}
//				if(rs!=null) {rs.close();}
//			}catch(SQLException sqle){
//				sqle.printStackTrace();
//				log.info("Error Closing SQL Objects \n"+sqle.getMessage());
//			}
//		}	
//		return data;
//	}

	/* getting product type */
	public static String getProductType(String enqid, String token) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		String result = "NA";
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement("select enqproduct_type from userenquiry where enqid='" + enqid
					+ "' and enqTokenNo='" + token + "'");
			rs = ps.executeQuery();
			if (rs.next())
				result = rs.getString(1);

		} catch (Exception e) {
			log.info("getProductType()" + e.getMessage());
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
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects \n" + sqle.getMessage());
			}
		}
		return result;
	}

	/* saving project milestone */
	public static String getEnqStatus(String enqid, String token) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		String result = "fail";
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement("select enqfstatus from userenquiryfollowup where enqfeuid='" + enqid
					+ "' and enqftokenno='" + token + "'");
			rs = ps.executeQuery();
			while (rs.next()) {
				if (rs.getString(1).equalsIgnoreCase("Final")) {
					result = rs.getString(1);
					break;
				}
			}
		} catch (Exception e) {
			log.info("getEnqStatus()" + e.getMessage());
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
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects \n" + sqle.getMessage());
			}
		}
		return result;
	}

	/* saving project milestone */
	public static void addProjectMilestone(String pid, String enqid, String token, String addedby, String datetime,
			String Enq) {
		PreparedStatement ps = null;
		PreparedStatement ps1 = null;
		ResultSet rs = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement(
					"select pm_worktype,pm_unittime,pm_duration,pm_smsid,pm_emailid from product_milestone where pm_pid='"
							+ pid + "' and pm_tokeno='" + token + "'");
			rs = ps.executeQuery();
//			System.out.println("select pm_worktype,pm_unittime,pm_duration,pm_smsid,pm_emailid from product_milestone where pm_pid='"+pid+"' and pm_tokeno='"+token+"'");
			while (rs.next()) {
				ps1 = con.prepareStatement(
						"insert into project_milestone(preguid,worktype,unittime,duration,smsid,emailid,status,tokenno,addedby,addedon,enq)values(?,?,?,?,?,?,?,?,?,?,?)");
				ps1.setString(1, enqid);
				ps1.setString(2, rs.getString(1));
				ps1.setString(3, rs.getString(2));
				ps1.setString(4, rs.getString(3));
				ps1.setString(5, rs.getString(4));
				ps1.setString(6, rs.getString(5));
				ps1.setString(7, "1");
				ps1.setString(8, token);
				ps1.setString(9, addedby);
				ps1.setString(10, datetime);
				ps1.setString(11, Enq);

				ps1.execute();
			}

		} catch (Exception e) {
			log.info("addProjectMilestone()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (ps1 != null) {
					ps1.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing addProjectMilestone() SQL Objects \n" + sqle.getMessage());
			}
		}
	}

	public static boolean saveForExpenseApproval(String expkey, String expname, String today, String expNumber,
			String expAmount, String expCategory, String expHSN, String expDepartment, String expAccount,
			String expNote, String token, String addedby, String loginuaid, String salesKey, String approvalStatus,
			String approveBy, String approveDate, String assignKey) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement("insert into expense_approval_ctrl(expkey,expdate,expclientname,"
					+ "expclientmobile,expamount,expcategory,exphsn,expdepartment,expaccount,expnotes,"
					+ "exptoken,expaddedby,expaddedbyuid,expsaleskey,expapprovalstatus,expapprovebyuid,"
					+ "expapproveddate,exptaskkey) " + "values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");

			ps.setString(1, expkey);
			ps.setString(2, today);
			ps.setString(3, expname);
			ps.setString(4, expNumber);
			ps.setString(5, expAmount);
			ps.setString(6, expCategory);
			ps.setString(7, expHSN);
			ps.setString(8, expDepartment);
			ps.setString(9, expAccount);
			ps.setString(10, expNote);
			ps.setString(11, token);
			ps.setString(12, addedby);
			ps.setString(13, loginuaid);
			ps.setString(14, salesKey);
			ps.setString(15, approvalStatus);
			ps.setString(16, approveBy);
			ps.setString(17, approveDate);
			ps.setString(18, assignKey);

			int k = ps.executeUpdate();
			if (k > 0)
				status = true;

		} catch (Exception e) {
			e.printStackTrace();
			log.info("saveForExpenseApproval()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error Closing SQL saveForExpenseApproval() Objects \n" + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean saveInTransactionHistory(String laserkey, String invoice, String today, String contactname,
			String contactmobile, String clientname, String category, double withdraw, double deposit, String token,
			String addedby, String description, String type, String department, String hsn, String refunddate) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement(
					"insert into managetransactionctrl(mtrefid,mtinvoice,mtdate,mtclientname,mtclientmobile,mtaccounts,mtcategory,mtwithdraw,mtdeposit,mtaddedby,mttokenno,mtremarks,mttype,mtdepartment,mthsncode,mtrefunddate) "
							+ "values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");

			ps.setString(1, laserkey);
			ps.setString(2, invoice);
			ps.setString(3, today);
			ps.setString(4, contactname);
			ps.setString(5, contactmobile);
			ps.setString(6, clientname);
			ps.setString(7, category);
			ps.setDouble(8, withdraw);
			ps.setDouble(9, deposit);
			ps.setString(10, addedby);
			ps.setString(11, token);
			ps.setString(12, description);
			ps.setString(13, type);
			ps.setString(14, department);
			ps.setString(15, hsn);
			ps.setString(16, refunddate);

			int k = ps.executeUpdate();
			if (k > 0)
				status = true;

		} catch (Exception e) {
			e.printStackTrace();
			log.info("saveInTransactionHistory()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error Closing SQL saveInTransactionHistory() Objects \n" + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean saveMilestoneToSale(String milestonekey, String saleskey, String prodrefid,
			String milestonename, String timelinevalue, String timelineunit, String steps, String assign,
			String pricePercent, String addedby, String token, String payType) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement(
					"insert into salesmilestonectrl(smrefid,smsalesrefid,smprodrefid,smmilestonename,smtimelinevalue,smtimelineperiod,smstep,smnextassignpercentage,smtoken,smaddedby,smpricepercentage,smpaytype) "
							+ "values(?,?,?,?,?,?,?,?,?,?,?,?)");

			ps.setString(1, milestonekey);
			ps.setString(2, saleskey);
			ps.setString(3, prodrefid);
			ps.setString(4, milestonename);
			ps.setString(5, timelinevalue);
			ps.setString(6, timelineunit);
			ps.setString(7, steps);
			ps.setString(8, assign);
			ps.setString(9, token);
			ps.setString(10, addedby);
			ps.setString(11, pricePercent);
			ps.setString(12, payType);

			int k = ps.executeUpdate();
			if (k > 0)
				status = true;

		} catch (Exception e) {
			log.info("saveMilestoneToSale()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error Closing SQL saveMilestoneToSale() Objects \n" + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean isAllDocumentUploaded(String estkey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		boolean getinfo = true;
		try {
			String queryselect = "SELECT sdid FROM salesdocumentctrl where sdestkey='" + estkey + "' and sdtokenno='"
					+ token + "' and sddocname='NA' limit 1";
//		System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = false;
			}
		} catch (Exception e) {
			log.info("isAllDocumentUploaded" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("isAllDocumentUploaded" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static boolean updateSalesDocHistory(String estkey, String saleskey, String token) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement("update salesdochistory set salesKey=? where estsalekey=? and token=?");

			ps.setString(1, saleskey);
			ps.setString(2, estkey);
			ps.setString(3, token);
			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			log.info("updateSalesDocHistory()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error Closing SQL updateSalesDocHistory() Objects \n" + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean updateDocumentList(String estkey, String saleskey, String token) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement("update salesdocumentctrl set sdsalesrefid=? where sdestkey=? and sdtokenno=?");

			ps.setString(1, saleskey);
			ps.setString(2, estkey);
			ps.setString(3, token);
			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			log.info("updateDocumentList()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error Closing SQL updateDocumentList() Objects \n" + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean addDocumentList(String dockey, String saleskey, String docname, String description,
			String uploadby, String addedby, String token, String visibiltiy, String estimateKey) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement(
					"insert into salesdocumentctrl(sdrefid,sdsalesrefid,sduploaddocname,sddescription,sduploadby,adaddedby,sdtokenno,sdvisibility,sdestkey) "
							+ "values(?,?,?,?,?,?,?,?,?)");

			ps.setString(1, dockey);
			ps.setString(2, saleskey);
			ps.setString(3, docname);
			ps.setString(4, description);
			ps.setString(5, uploadby);
			ps.setString(6, addedby);
			ps.setString(7, token);
			ps.setString(8, visibiltiy);
			ps.setString(9, estimateKey);

			int k = ps.executeUpdate();
			if (k > 0)
				status = true;

		} catch (Exception e) {
			log.info("addDocumentList()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error Closing SQL addDocumentList() Objects \n" + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean convertEstimatePriceToSale(String pricekey, String saleskey, String prodrefid,
			String pricetype, double price, String hsncode, double cgstpercent, double sgstpercent, double igstpercent,
			double cgstprice, double sgstprice, double igstprice, double total, String token, String addedby) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement(
					"insert into salespricectrl(sprefid,spsalesrefid,spprodrefid,sppricetype,spprice,sphsncode,spcgstpercent,spsgstpercent,spigstpercent,spcgstprice,spsgstprice,spigstprice,sptotalprice,sptokenno,spaddedby) "
							+ "values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");

			ps.setString(1, pricekey);
			ps.setString(2, saleskey);
			ps.setString(3, prodrefid);
			ps.setString(4, pricetype);
			ps.setDouble(5, price);
			ps.setString(6, hsncode);
			ps.setDouble(7, cgstpercent);
			ps.setDouble(8, sgstpercent);
			ps.setDouble(9, igstpercent);
			ps.setDouble(10, cgstprice);
			ps.setDouble(11, sgstprice);
			ps.setDouble(12, igstprice);
			ps.setDouble(13, total);
			ps.setString(14, token);
			ps.setString(15, addedby);

			int k = ps.executeUpdate();
			if (k > 0)
				status = true;

		} catch (Exception e) {
			log.info("addDefaultPlanOrder()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error Closing SQL addDefaultPlanOrder() Objects \n" + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean saveGeneratedInvoice(String uuid, String invoice, String uid, String token, String date,
			String type) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement(
					"insert into invoice_generator(uuid,invoice,user_uid,token,date,type) " + "values(?,?,?,?,?,?)");

			ps.setString(1, uuid);
			ps.setString(2, invoice);
			ps.setString(3, uid);
			ps.setString(4, token);
			ps.setString(5, date);
			ps.setString(6, type);

			int k = ps.executeUpdate();
			if (k > 0)
				status = true;

		} catch (Exception e) {
			log.info("saveGeneratedInvoice()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error Closing SQL saveGeneratedInvoice() Objects \n" + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean saveNewInvoice(String invoice, String addedby, String token) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement("insert into salesinvoicectrl(siinvoice,siaddedby,sitokenno) " + "values(?,?,?)");

			ps.setString(1, invoice);
			ps.setString(2, addedby);
			ps.setString(3, token);

			int k = ps.executeUpdate();
			if (k > 0)
				status = true;

		} catch (Exception e) {
			log.info("saveNewInvoice()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error Closing SQL saveNewInvoice() Objects \n" + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean convertEstimateToSale(String key, String company, String prodtype, String prodname,
			String prodplan, String planperiod, String plantime, String today, String soldbyid, String contactrefid,
			String clientrefid, String remarks, String token, String addedby, String invoice, String estno,
			String projectno, String invoiceNotes, String jurisdiction, String estKey, String orderNumber,
			String purchaseDate, int tatValue, String tatType, int salesType) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement("insert into managesalesctrl(msrefid,msclientrefid,"
					+ "mscontactrefid,msinvoiceno,msestimateno,mscompany,msproducttype,"
					+ "msproductname,msproductplan,msplanperiod,msplantime,msremarks,"
					+ "mssoldbyuid,mssolddate,msaddedby,mstoken,msprojectnumber,"
					+ "msinvoicenotes,msjurisdiction,msestkey,msordernumber,mspurchasedate"
					+ ",tat_value,tat_type,sales_type) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");

			ps.setString(1, key);
			ps.setString(2, clientrefid);
			ps.setString(3, contactrefid);
			ps.setString(4, invoice);
			ps.setString(5, estno);
			ps.setString(6, company);
			ps.setString(7, prodtype);
			ps.setString(8, prodname);
			ps.setString(9, prodplan);
			ps.setString(10, planperiod);
			ps.setString(11, plantime);
			ps.setString(12, remarks);
			ps.setString(13, soldbyid);
			ps.setString(14, today);
			ps.setString(15, addedby);
			ps.setString(16, token);
			ps.setString(17, projectno);
			ps.setString(18, invoiceNotes);
			ps.setString(19, jurisdiction);
			ps.setString(20, estKey);
			ps.setString(21, orderNumber);
			ps.setString(22, purchaseDate);
			ps.setInt(23, tatValue);
			ps.setString(24, tatType);
			ps.setInt(25, salesType);

			int k = ps.executeUpdate();
			if (k > 0)
				status = true;

		} catch (Exception e) {
			log.info("addDefaultPlanOrder()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error Closing SQL addDefaultPlanOrder() Objects \n" + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean addDefaultPlanOrder(String key, String servicetype, String prodname, String salesno,
			String company, String contactrefid, String clientrefid, String loginuaid, String token, String addedby,
			String today, String notes, String orderNumber, String purchaseDate) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			if (company.equalsIgnoreCase("...."))
				clientrefid = "NA";
			ps = con.prepareStatement("insert into estimatesalectrl(esrefid,essaleno,escompany,esprodtype,esprodqty,"
					+ "esprodname,esprodplan,esplanperiod,esplantime,esregdate,essoldbyid,escontactrefid,"
					+ "esclientrefid,esremarks,esaddedby,estoken,essalesstatus,esinvoicenotes,esaddedbyuid,esordernumber"
					+ ",espurchasedate) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");

			ps.setString(1, key);
			ps.setString(2, salesno);
			ps.setString(3, company);
			ps.setString(4, servicetype);
			ps.setString(5, "1");
			ps.setString(6, prodname);
			ps.setString(7, "OneTime");
			ps.setString(8, "NA");
			ps.setString(9, "NA");
			ps.setString(10, today);
			ps.setString(11, loginuaid);
			ps.setString(12, contactrefid);
			ps.setString(13, clientrefid);
			ps.setString(14, prodname);
			ps.setString(15, addedby);
			ps.setString(16, token);
			ps.setString(17, "edit");
			ps.setString(18, notes);
			ps.setString(19, loginuaid);
			ps.setString(20, orderNumber);
			ps.setString(21, purchaseDate);

			int k = ps.executeUpdate();
			if (k > 0)
				status = true;

		} catch (Exception e) {
			e.printStackTrace();
			log.info("addDefaultPlanOrder()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error Closing SQL addDefaultPlanOrder() Objects \n" + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean addDefaultPlan(String key, String token, String addedby) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement(
					"insert into salesproductrenewalvirtualctrl(spvprodrefid,spvprodplan,spvplanperiod,spvplantime,spvtokenno,spvaddedby) "
							+ "values(?,?,?,?,?,?)");

			ps.setString(1, key);
			ps.setString(2, "OneTime");
			ps.setString(3, "NA");
			ps.setString(4, "NA");
			ps.setString(5, token);
			ps.setString(6, addedby);

			ps.execute();

			status = true;

		} catch (Exception e) {
			log.info("addDefaultPlan()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error Closing SQL addDefaultPlan() Objects \n" + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean addSalesContactToVirtual(String key, String contactid, String name, String email,
			String workMobile, String mobile, String salesid, String token, String addedby, String ckey) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement(
					"insert into salescontactboxvirtual(scvrefid,scvsalesid,scvcontactname,scvcontactemail1st,scvcontactmobile1st,scvcontactmobile2nd,scvtokenno,scvaddedby,scvcontactboxid,scvcontactrefid) "
							+ "values(?,?,?,?,?,?,?,?,?,?)");

			ps.setString(1, key);
			ps.setString(2, salesid);
			ps.setString(3, name);
			ps.setString(4, email);
			ps.setString(5, workMobile);
			ps.setString(6, mobile);
			ps.setString(7, token);
			ps.setString(8, addedby);
			ps.setString(9, contactid);
			ps.setString(10, ckey);

			int k = ps.executeUpdate();

			if (k > 0)
				status = true;

		} catch (Exception e) {
			log.info("addSalesContactToVirtual()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error Closing SQL addSalesContactToVirtual() Objects \n" + sqle);
			}
		}
		return status;
	}

	/* uploadSalesProductManage */
	public static boolean uploadSalesProductManage(String key, String invoice, String estimate, String paymentmode,
			String pymtdate, String transactionid, String amount, String imgname, String imgpath, String token,
			String addedby, String serviceName, String pinvoice, String remarks, String loginuaid, int serviceQty) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement("insert into salesestimatepayment(srefid,spaymtmode,saddeddate,"
					+ "stransactionid,stransactionamount,sdocumentname,stokenno,saddedby,sestsaleno,"
					+ "sinvoiceno,service_name,payment_invoice,scomment,spayment_remarks,saddedbyuid,service_qty) "
					+ "values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");

			ps.setString(1, key);
			ps.setString(2, paymentmode);
			ps.setString(3, pymtdate);
			ps.setString(4, transactionid);
			ps.setString(5, amount);
			ps.setString(6, imgname);
			ps.setString(7, token);
			ps.setString(8, addedby);
			ps.setString(9, estimate);
			ps.setString(10, invoice);
			ps.setString(11, serviceName);
			ps.setString(12, pinvoice);
			ps.setString(13, "NA");
			ps.setString(14, remarks);
			ps.setString(15, loginuaid);
			ps.setInt(16, serviceQty);

			int k = ps.executeUpdate();
			if (k > 0)
				status = true;

		} catch (Exception e) {
			e.printStackTrace();
			log.info("uploadSalesProductManage()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error Closing SQL uploadSalesProductManage() Objects \n" + sqle);
			}
		}
		return status;
	}

	public static boolean addPaymentDetails(String billrefid, String today, String salesno, String company,
			String clientrefid, String contactrefid, String amount, double orderamt, double paidamt, double dueamt,
			String token, String coupon, String type, String value, double discount) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement(
					"insert into hrmclient_billing(cbrefid,cbestimateno,cbclientrefid,cbcompanyname,cbcontactrefid,cborderamount,cbpaidamount,cbdueamount,cbtransactionamount,cdnotificationcount,cbdate,cbtokenno,cbcoupon,cbtype,cbvalue,cbdiscount) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
			ps.setString(1, billrefid);
			ps.setString(2, salesno);
			ps.setString(3, clientrefid);
			ps.setString(4, company);
			ps.setString(5, contactrefid);
			ps.setDouble(6, orderamt);
			ps.setDouble(7, paidamt);
			ps.setDouble(8, dueamt);
			ps.setString(9, amount);
			ps.setString(10, "1");
			ps.setString(11, today);
			ps.setString(12, token);
			ps.setString(13, coupon);
			ps.setString(14, type);
			ps.setString(15, value);
			ps.setDouble(16, discount);

			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			log.info("addPaymentDetails()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error Closing SQL addPaymentDetails() Objects \n" + sqle);
			}
		}
		return status;
	}

	public static boolean approveThisExpense(String expKey, String today, String loginuaid, String token,
			String approveStatus) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement(
					"update expense_approval_ctrl set expapprovalstatus=?,expapprovebyuid=?,expapproveddate=? where expkey=? and exptoken=?");
			ps.setString(1, approveStatus);
			ps.setString(2, loginuaid);
			ps.setString(3, today);
			ps.setString(4, expKey);
			ps.setString(5, token);
			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			e.printStackTrace();
			log.info("approveThisExpense()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error Closing SQL approveThisExpense() Objects \n" + sqle);
			}
		}
		return status;
	}

	public static boolean updateSalesProductPrice(String prodrefid, String invoice, String token) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement("update salesproductprice set spinvoiceno=? where spprodrefid=? and sptokenno=?");
			ps.setString(1, invoice);
			ps.setString(2, prodrefid);
			ps.setString(3, token);
			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			log.info("updateSalesProductPrice()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error Closing SQL updateSalesProductPrice() Objects \n" + sqle);
			}
		}
		return status;
	}

	public static boolean updatePaymentsInvoice(String invoice, String estimateno, String token) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement("update salesestimatepayment set sinvoiceno=? where sestsaleno=? and stokenno=?");
			ps.setString(1, invoice);
			ps.setString(2, estimateno);
			ps.setString(3, token);
			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			log.info("updatePaymentsInvoice()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error Closing SQL updatePaymentsInvoice() Objects \n" + sqle);
			}
		}
		return status;
	}

	public static boolean updateBillingInvoice(String invoice, String estimateno, String duedate, String token) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement(
					"update hrmclient_billing set cbinvoiceno=?,cbduedate=?,cbnextduedate=? where cbestimateno=? and cbtokenno=?");
			ps.setString(1, invoice);
			ps.setString(2, duedate);
			ps.setString(3, duedate);
			ps.setString(4, estimateno);
			ps.setString(5, token);
			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			log.info("updateBillingInvoice()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error Closing SQL updateBillingInvoice() Objects \n" + sqle);
			}
		}
		return status;
	}

	public static boolean updateInvoicePaymentDetails(String salesno, String amount, String token) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement("update hrmclient_billing set cbtransactionamount=cbtransactionamount+" + amount
					+ ",cdnotificationcount=cdnotificationcount+" + 1 + " where cbinvoiceno='" + salesno
					+ "' and cbtokenno='" + token + "'");

			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			log.info("updateInvoicePaymentDetails()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error Closing SQL updateInvoicePaymentDetails() Objects \n" + sqle);
			}
		}
		return status;
	}

	public static boolean updatePaymentDetails(String salesno, String amount, String token) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement("update hrmclient_billing set cbtransactionamount=cbtransactionamount+" + amount
					+ ",cdnotificationcount=cdnotificationcount+" + 1 + " where cbestimateno='" + salesno
					+ "' and cbtokenno='" + token + "'");

			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			log.info("uploadSalesProductPayment()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error Closing SQL uploadSalesProductPayment() Objects \n" + sqle);
			}
		}
		return status;
	}

	public static boolean addSalesPayment(String key, String today, String estinvoice, String invoiceno,
			String loginuaid, String paymentmode, String transactionid, String amount, String token, String addedby,
			String imgname, String imgpath, String service_name, String pinvoice, String remarks, String unbillNo,
			int serviceQty) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement("insert into salesestimatepayment(srefid,saddeddate,"
					+ "sestsaleno,sinvoiceno,sapproveddate,sapprovedby,spaymtmode,"
					+ "stransactionid,stransactionamount,stransactionstatus,saddedby,"
					+ "stokenno,sdocumentname,sdocpath,service_name,payment_invoice,"
					+ "scomment,spayment_remarks,saddedbyuid,sunbill_no,service_qty) "
					+ "values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");

			ps.setString(1, key);
			ps.setString(2, today);
			ps.setString(3, estinvoice);
			ps.setString(4, invoiceno);
			ps.setString(5, today);
			ps.setString(6, loginuaid);
			ps.setString(7, paymentmode);
			ps.setString(8, transactionid);
			ps.setString(9, amount);
			ps.setString(10, "1");
			ps.setString(11, addedby);
			ps.setString(12, token);
			ps.setString(13, imgname);
			ps.setString(14, imgpath);
			ps.setString(15, service_name);
			ps.setString(16, pinvoice);
			ps.setString(17, remarks);
			ps.setString(18, "NA");
			ps.setString(19, loginuaid);
			ps.setString(20, unbillNo);
			ps.setInt(21, serviceQty);

			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			log.info("addSalesPayment()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error Closing SQL addSalesPayment() Objects \n" + sqle);
			}
		}
		return status;
	}

	public static boolean uploadSalesProductPayment(String key, String paymentmode, String pymtdate,
			String transactionid, String amount, String salesno, String imgname, String imgpath, String token,
			String addedby, String invoiceno, String service_Name, String pinvoice, String remarks, String loginuaid,
			int serviceQty, String fromYear, String toYear, String portalNumber, String piboCategory, String creditType,
			String productCategory, int quantity, String comment) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement("insert into salesestimatepayment(srefid,saddeddate,"
					+ "sestsaleno,spaymtmode,stransactionid,stransactionamount,"
					+ "sdocumentname,sdocpath,stokenno,saddedby,stransactionstatus,"
					+ "sinvoiceno,service_name,payment_invoice,scomment,spayment_remarks,saddedbyuid,service_qty,"
					+ "from_year,to_year,portal_number,pibo_category,credit_type,product_category,quantity,comment) "
					+ "values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");

			ps.setString(1, key);
			ps.setString(2, pymtdate);
			ps.setString(3, salesno);
			ps.setString(4, paymentmode);
			ps.setString(5, transactionid);
			ps.setString(6, amount);
			ps.setString(7, imgname);
			ps.setString(8, imgpath);
			ps.setString(9, token);
			ps.setString(10, addedby);
			ps.setString(11, "2");
			ps.setString(12, invoiceno);
			ps.setString(13, service_Name);
			ps.setString(14, pinvoice);
			ps.setString(15, "NA");
			ps.setString(16, remarks);
			ps.setString(17, loginuaid);
			ps.setInt(18, serviceQty);

			ps.setString(19, fromYear);
			ps.setString(20, toYear);
			ps.setString(21, portalNumber);
			ps.setString(22, piboCategory);
			ps.setString(23, creditType);
			ps.setString(24, productCategory);
			ps.setInt(25, quantity);
			ps.setString(26, comment);

			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			log.info("uploadSalesProductPayment()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error Closing SQL uploadSalesProductPayment() Objects \n" + sqle);
			}
		}
		return status;
	}

	/* creating sales virtual order */
	public static boolean addPriceInCart(String key, String salesid, int prodno, String prodrefid, String pricetype,
			String price, String hsn, String cgst, String sgst, String igst, String total_price, String key1,
			String token, String addedby) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement(
					"insert into salesproductvirtual(spvvirtualid,spvrefpid,spvpricetype,spvprice,spvhsncode,spvcgstpercent,spvsgstpercent,spvigstpercent,spvtotalprice,spvtokenno,spvaddedby,spvrefid,spvsalesid,spvsalesno,spvminprice) "
							+ "values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");

			ps.setString(1, key);
			ps.setString(2, prodrefid);
			ps.setString(3, pricetype);
			ps.setString(4, price);
			ps.setString(5, hsn);
			ps.setString(6, cgst);
			ps.setString(7, sgst);
			ps.setString(8, igst);
			ps.setString(9, total_price);
			ps.setString(10, token);
			ps.setString(11, addedby);
			ps.setString(12, key1);
			ps.setString(13, salesid);
			ps.setInt(14, prodno);
			ps.setString(15, price);
			int k = ps.executeUpdate();
			if (k > 0) {
				status = true;
			}

		} catch (Exception e) {
			log.info("addPriceInCart()" + e.getMessage());
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
				log.info("Error Closing SQL addPriceInCart() Objects \n" + sqle);
			}
		}
		return status;
	}

	public static void createProjectFolder(String folderrefid, String projectno, String addedby, String token,
			String folcategory, String foldertype, String saleskey, String clientid, String subfolkey) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement(
					"insert into folder_master(frefid,fname,fstatus,faddedby,ftokenno,fprojectno,fclientid,fsfrefid,ffcategory,ftype,fsalesrefid) values(?,?,?,?,?,?,?,?,?,?,?)");

			ps.setString(1, folderrefid);
			ps.setString(2, projectno);
			ps.setString(3, "1");
			ps.setString(4, addedby);
			ps.setString(5, token);
			ps.setString(6, projectno);
			ps.setString(7, clientid);
			ps.setString(8, subfolkey);
			ps.setString(9, folcategory);
			ps.setString(10, foldertype);
			ps.setString(11, saleskey);
			ps.execute();
		} catch (Exception e) {
			log.info("createProjectFolder()" + e.getMessage());
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
				log.info("Error Closing SQL createProjectFolder() Objects \n" + sqle);
			}
		}
	}

	/* creating client's folder */
	public static boolean createClientFolder(String key, String foldername, String addedby, String token,
			String folcategory, String foldertype, String salesrefid, String clientid) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			ps = con.prepareStatement(
					"insert into folder_master(frefid,fname,fstatus,faddedby,ftokenno,fprojectno,fclientid,fsfrefid,ffcategory,ftype,fsalesrefid) values(?,?,?,?,?,?,?,?,?,?,?)");

			ps.setString(1, key);
			ps.setString(2, foldername);
			ps.setString(3, "1");
			ps.setString(4, addedby);
			ps.setString(5, token);
			ps.setString(6, "NA");
			ps.setString(7, clientid);
			ps.setString(8, "NA");
			ps.setString(9, folcategory);
			ps.setString(10, foldertype);
			ps.setString(11, salesrefid);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("createClientFolder()" + e.getMessage());
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
				log.info("Error Closing SQL createClientFolder() Objects \n" + sqle);
			}
		}
		return flag;
	}

	/* creating sales folder */
	public static void createSalesFolder(String key, String enquid, String addedby, String token, String folcategory,
			String ftype, String salesrefid) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement(
					"insert into folder_master(frefid,fname,fstatus,faddedby,ftokenno,fprojectno,fclientid,fsfrefid,ffcategory,ftype,fsalesrefid) values(?,?,?,?,?,?,?,?,?,?,?)");

			ps.setString(1, key);
			ps.setString(2, enquid);
			ps.setString(3, "1");
			ps.setString(4, addedby);
			ps.setString(5, token);
			ps.setString(6, enquid);
			ps.setString(7, "NA");
			ps.setString(8, "NA");
			ps.setString(9, folcategory);
			ps.setString(10, ftype);
			ps.setString(11, salesrefid);
			ps.execute();

		} catch (Exception e) {
			log.info("addEstimatedInvoice()" + e.getMessage());
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
				log.info("Error Closing SQL addEstimatedInvoice() Objects \n" + sqle);
			}
		}
	}

	/* adding estimate invoice details */
	public static void addEstimatedInvoice(String key, String refid, String today, String uarefid, String token,
			String status, String estinvoiceno) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement(
					"insert into estimateinvoicectrl(estuuid,estsalesrefid,estcreateddate,estcreatedbyrefid,esttokenno,eststatus,estinvoiceno) values(?,?,?,?,?,?,?)");

			ps.setString(1, key);
			ps.setString(2, refid);
			ps.setString(3, today);
			ps.setString(4, uarefid);
			ps.setString(5, token);
			ps.setString(6, status);
			ps.setString(7, estinvoiceno);
			ps.execute();

		} catch (Exception e) {
			log.info("addEstimatedInvoice()" + e.getMessage());
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
				log.info("Error Closing SQL addEstimatedInvoice() Objects \n" + sqle);
			}
		}
	}

	public static boolean declinePayment(String refid, String loginuaid, String today, String token, String comment) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean flag = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement(
					"update salesestimatepayment set sapproveddate=?,sapprovedby=?,stransactionstatus=?,scomment=? where srefid=? and stokenno=?");

			ps.setString(1, today);
			ps.setString(2, loginuaid);
			ps.setString(3, "3");
			ps.setString(4, comment);
			ps.setString(5, refid);
			ps.setString(6, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("declinePayment()" + e.getMessage());
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
				log.info("Error Closing SQL declinePayment() Objects \n" + sqle);
			}
		}
		return flag;
	}

	public static boolean holdPayment(String refid, String loginuaid, String today, String token, String comment) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean flag = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement(
					"update salesestimatepayment set sapproveddate=?,sapprovedby=?,stransactionstatus=?,hold_comment=? where srefid=? and stokenno=?");

			ps.setString(1, today);
			ps.setString(2, loginuaid);
			ps.setString(3, "4");
			ps.setString(4, comment);
			ps.setString(5, refid);
			ps.setString(6, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("holdPayment()" + e.getMessage());
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
				log.info("Error Closing SQL holdPayment() Objects \n" + sqle);
			}
		}
		return flag;
	}

	public static boolean updatePaymentInvoice(String invoice, String estimateno, String token) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean flag = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement("update salesestimatepayment set sinvoiceno=? where sestsaleno=? and stokenno=?");

			ps.setString(1, invoice);
			ps.setString(2, estimateno);
			ps.setString(3, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("updatePaymentInvoice()" + e.getMessage());
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
				log.info("Error Closing SQL updatePaymentInvoice() Objects \n" + sqle);
			}
		}
		return flag;
	}

	public static boolean updateUnbillNumber(String refid, String token, String unbillno) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean flag = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement("update salesestimatepayment set sunbill_no=? where srefid=? and stokenno=?");

			ps.setString(1, unbillno);
			ps.setString(2, refid);
			ps.setString(3, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("updateUnbillNumber()" + e.getMessage());
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
				log.info("Error Closing SQL updateUnbillNumber() Objects \n" + sqle);
			}
		}
		return flag;
	}

	public static boolean approvePaymentDetails(String refid, String token, String date, String loginuid,
			String comment) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean flag = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement("update salesestimatepayment set stransactionstatus=?,"
					+ "sapproveddate=?,sapprovedby=?,scomment=? where srefid=? and stokenno=?");

			ps.setString(1, "1");
			ps.setString(2, date);
			ps.setString(3, loginuid);
			ps.setString(4, comment);
			ps.setString(5, refid);
			ps.setString(6, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("approvePaymentDetails()" + e.getMessage());
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
				log.info("Error Closing SQL approvePaymentDetails() Objects \n" + sqle);
			}
		}
		return flag;
	}

	public static boolean updatePaymentDetails(String unbillNo, String token) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean flag = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement(
					"update salesestimatepayment set sinvoice_status=? " + "where sunbill_no=? and stokenno=?");

			ps.setString(1, "1");
			ps.setString(2, unbillNo);
			ps.setString(3, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("updatePaymentDetails()" + e.getMessage());
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
				log.info("Error Closing SQL updatePaymentDetails() Objects \n" + sqle);
			}
		}
		return flag;
	}

	public static boolean updatePoValidity(String refid, String value, String token) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean flag = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement("update salesestimatepayment set po_validity=? where srefid=? and stokenno=?");

			ps.setString(1, value);
			ps.setString(2, refid);
			ps.setString(3, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("updatePoValidity()" + e.getMessage());
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
				log.info("Error Closing SQL updatePoValidity() Objects \n" + sqle);
			}
		}
		return flag;
	}

	public static boolean updatePaymentAmounts(String refid, String value, String token) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean flag = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement(
					"update salesestimatepayment set stransactionamount=? where srefid=? and stokenno=?");

			ps.setString(1, value);
			ps.setString(2, refid);
			ps.setString(3, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("updatePaymentAmounts()" + e.getMessage());
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
				log.info("Error Closing SQL updatePaymentAmounts() Objects \n" + sqle);
			}
		}
		return flag;
	}

	public static boolean updatePricePercent(String refKey, String value, String token) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean flag = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement(
					"update estimateconvert_pricepercentage set epworkpricepercentage=? where eprefid=? and eptokenno=?");

			ps.setString(1, value);
			ps.setString(2, refKey);
			ps.setString(3, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("updatePricePercent()" + e.getMessage());
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
				log.info("Error Closing SQL updatePricePercent() Objects \n" + sqle);
			}
		}
		return flag;
	}

	public static boolean updatePayTypeStatus(String salesKey, String payType, String token) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean flag = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement(
					"update estimateconvert_pricepercentage set epworkpaytype=? where epsalesrefid=? and eptokenno=?");

			ps.setString(1, payType);
			ps.setString(2, salesKey);
			ps.setString(3, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("updatePayTypeStatus()" + e.getMessage());
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
				log.info("Error Closing SQL updatePayTypeStatus() Objects \n" + sqle);
			}
		}
		return flag;
	}

	public static boolean updatePayments(String refid, String value, String token) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean flag = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement("update salesestimatepayment set stransactionid=? where srefid=? and stokenno=?");

			ps.setString(1, value);
			ps.setString(2, refid);
			ps.setString(3, token);

			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("updatePayments()" + e.getMessage());
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
				log.info("Error Closing SQL updatePayments() Objects \n" + sqle);
			}
		}
		return flag;
	}

	/* adding estimate invoice details */
	public static void uploadSalesPaymentDoc(String key, String today, String sref, String paystatus, String addedby,
			String token, String imgname) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement(
					"insert into salesestimatepayment(srefid,saddeddate,senqrefid,spaymtmode,stransactionid,stransactionamount,stransactionstatus,saddedby,sstatus,stokenno,sdocumentname) values(?,?,?,?,?,?,?,?,?,?,?)");

			ps.setString(1, key);
			ps.setString(2, today);
			ps.setString(3, sref);
			ps.setString(4, "NA");
			ps.setString(5, "NA");
			ps.setString(6, "0");
			ps.setString(7, paystatus);
			ps.setString(8, addedby);
			ps.setString(9, "1");
			ps.setString(10, token);
			ps.setString(11, imgname);

			ps.execute();

		} catch (Exception e) {
			log.info("addEstimatePaymentDetails()" + e.getMessage());
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
				log.info("Error Closing SQL addEstimatePaymentDetails() Objects \n" + sqle);
			}
		}
	}

	/* adding estimate invoice details */
	public static boolean addEstimatePaymentDetails(String key, String pdate, String sref, String payoption,
			String transid, String transamt, String pymtstatus, String addedby, String status, String token) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			ps = con.prepareStatement(
					"insert into salesestimatepayment(srefid,saddeddate,senqrefid,spaymtmode,stransactionid,stransactionamount,stransactionstatus,saddedby,sstatus,stokenno) values(?,?,?,?,?,?,?,?,?,?)");

			ps.setString(1, key);
			ps.setString(2, pdate);
			ps.setString(3, sref);
			ps.setString(4, payoption);
			ps.setString(5, transid);
			ps.setString(6, transamt);
			ps.setString(7, pymtstatus);
			ps.setString(8, addedby);
			ps.setString(9, status);
			ps.setString(10, token);
			ps.execute();

			flag = true;
		} catch (Exception e) {
			log.info("addEstimatePaymentDetails()" + e.getMessage());
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
				log.info("Error Closing SQL addEstimatePaymentDetails() Objects \n" + sqle);
			}
		}
		return flag;
	}

	/* saving project price */
	public static void addProjectPrice(String pid, String enqid, String token, String addedby, String datetime,
			String Enq) {
		PreparedStatement ps = null;
		PreparedStatement ps1 = null;
		ResultSet rs = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement(
					"select pp_pricetype,pp_price,pp_service_type,pp_term,pp_term_time,pp_gst_status,pp_gst,pp_gst_price,pp_total_price from product_price where pp_pid='"
							+ pid + "' and pp_tokenno='" + token + "'");
			rs = ps.executeQuery();
//			System.out.println("select pp_pricetype,pp_price,pp_service_type,pp_term,pp_term_time,pp_gst_status,pp_gst,pp_gst_price,pp_total_price from product_price where pp_pid='"+pid+"' and pp_tokenno='"+token+"'");
			while (rs.next()) {
				ps1 = con.prepareStatement(
						"insert into project_price(preguid,pricetype,price,servicetype,term,termtime,gststatus,gst,gstprice,totalprice,status,tokenno,addedby,addedon,enq,penqsale) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");

				ps1.setString(1, enqid);
				ps1.setString(2, rs.getString(1));
				ps1.setString(3, rs.getString(2));
				ps1.setString(4, rs.getString(3));
				ps1.setString(5, rs.getString(4));
				ps1.setString(6, rs.getString(5));
				ps1.setString(7, rs.getString(6));
				ps1.setString(8, rs.getString(7));
				ps1.setString(9, rs.getString(8));
				ps1.setString(10, rs.getString(9));
				ps1.setString(11, "1");
				ps1.setString(12, token);
				ps1.setString(13, addedby);
				ps1.setString(14, datetime);
				ps1.setString(15, Enq);
				ps1.setString(16, "1");

				ps1.execute();
			}

		} catch (Exception e) {
			log.info("addProjectPrice()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (ps1 != null) {
					ps1.close();
				}
				if (con != null) {
					con.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL addProjectPrice() Objects \n" + sqle);
			}
		}
	}

	/* checking with enquiry mobile client exist or not */
//	@SuppressWarnings("resource")
//	public static void registerClientAndAssign(String eid,String token,String addeduser,String today) {
//		Connection con = DbCon.getCon("", "", "");
//		PreparedStatement ps = null;
//		ResultSet rset = null;
//		
//		String enqCompanyName=null;
//		String enqMob=null;
//		String enqalterMobNo=null;
//		String enqEmail=null;
//		String enqTokenNo=null;		
//		String enqproduct_type=null;
//		String enqproduct_name=null;
//		String enqName=null;		
//		String enqCity=null;
//		String enqAdd=null;
//		String enqRemarks=null;
//		String buildingtime=null;
//		String enqtype=null;
//		double total_price1=0;
//		double total_price2=0;
//		String remarks1="";
//		String remarks2="";
//		
//		String clientid="NA";
//		String creguid=null;
//		String cregtokenno=null;
//		boolean status=false;
//		
//		try {
//			String queryselect="SELECT enqCompanyName,enqMob,enqalterMobNo,enqEmail,enqTokenNo,enqproduct_type,enqproduct_name,enqName,enqCity,enqAdd,enqRemarks,enqpro_build_time,enqType FROM userenquiry where enqid='"+eid+"' and enqTokenNo='"+token+"' ";
//			ps = con.prepareStatement(queryselect);
//			rset = ps.executeQuery();
//			if(rset.next()){
//				enqCompanyName=rset.getString(1);
//				enqMob=rset.getString(2);
//				enqalterMobNo=rset.getString(3);
//				enqEmail=rset.getString(4);
//				enqTokenNo=rset.getString(5);
//				enqproduct_type=rset.getString(6);
//				enqproduct_name=rset.getString(7);				
//				enqName=rset.getString(8);
//				enqCity=rset.getString(9);
//				enqAdd=rset.getString(10);
//				enqRemarks=rset.getString(11);
//				buildingtime=rset.getString(12);
//				enqtype=rset.getString(13);
//			}
//			ps = con.prepareStatement("select creguid,cregtokenno from hrmclient_reg where cregmob='"+enqMob+"' or (cregcontmobile='"+enqMob+"' and cregcontmobile!='NA') or cregname='"+enqCompanyName+"' or (cregemailid='"+enqEmail+"' and cregemailid!='NA') or (cregcontemailid='"+enqEmail+"' and cregcontemailid!='NA') ");
//			rset = ps.executeQuery();
//			if(rset.next()){
//				creguid=rset.getString(1);
//				cregtokenno=rset.getString(2);
//			}
//			//project no.
//			String start = Usermaster_ACT.getStartingCode(token,"improjectkey");
//			String pregpuno=Clientmaster_ACT.getmanifetocode(token);
//			if (pregpuno==null) {
//			pregpuno=start+"1";
//			}
//			else {	
//				String c=pregpuno.substring(start.length());	
//				int j=Integer.parseInt(c)+1;
//				pregpuno=start+Integer.toString(j);
//			}			
//			
//			if(creguid!=null&&cregtokenno!=null){
//				if(cregtokenno.equalsIgnoreCase(token)){
//					clientid=creguid;
//					//check project is assigned or not , if not then assign
//					status=Clientmaster_ACT.saveProjectDetail(pregpuno,creguid,enqproduct_type,enqproduct_name,"NA","NA",addeduser,"1",enqRemarks, token,enqtype,"1");
//				if(status){
//						String projectid=updatePriceMilestone(pregpuno,creguid,token,eid,buildingtime);
//						remarks1=pregpuno+"#"+enqproduct_type;
//						total_price1=Clientmaster_ACT.projectTotalPrice(projectid,token);
//						Clientmaster_ACT.addPrice(creguid,total_price1,remarks1,today,addeduser,pregpuno);
//					}
//				}				
//			}else{
//				String pregcuid="";
//				String cregucid=Clientmaster_ACT.getetocode(token);
//				String initial = Usermaster_ACT.getStartingCode(token,"imclientkey");
//				if (cregucid==null) {
//					cregucid=initial+"1";
//				}
//				else {
//					String c=cregucid.substring(initial.length());
//					
//						int j=Integer.parseInt(c)+1;
//						cregucid=initial+Integer.toString(j);
//					}
//				clientid=cregucid;
//				status=Clientmaster_ACT.saveClientDetail(cregucid,enqMob,enqCompanyName,enqEmail,enqAdd,enqCity,enqName,"Owner","NA",enqalterMobNo,"NA","NA","NA",addeduser,token);
//				if(status){
//				Clientmaster_ACT.openAccount(cregucid,enqCompanyName, addeduser,token);
//				//assign project and debit amount				
//				pregcuid=getClientId(cregucid,token);
//				status=Clientmaster_ACT.saveProjectDetail(pregpuno,pregcuid,enqproduct_type,enqproduct_name,"NA","NA",addeduser,"1",enqRemarks, token,enqtype,"1");
//				
//				if(status){
//					String projectid=updatePriceMilestone(pregpuno,pregcuid,token,eid,buildingtime);
//					remarks2=pregpuno+"#"+enqproduct_type;
//					total_price2=Clientmaster_ACT.projectTotalPrice(projectid,token);
//					Clientmaster_ACT.addPrice(pregcuid,total_price2,remarks2,today,addeduser,pregpuno);
//				}
//				}
//			}
//			//getting client id
//			String cid=Clientmaster_ACT.getClientId(clientid,token);
//			//creating client's folder and sub-folder
//			Clientmaster_ACT.createProjectFolder(pregpuno,enqproduct_name,addeduser,token,cid);
//
//		} catch (Exception e) {
//			log.info("EnquiryACT.getClientId " + e.getMessage());
//		} finally {
//			try {
//				// closing sql objects
//				if (ps != null) {
//					ps.close();
//				}
//				if (con != null) {
//					con.close();
//				}
//				if (rset != null) {
//					rset.close();
//				}
//			} catch (SQLException e) {
//				log.info("EnquiryACT.getClientId " + e.getMessage());
//			}
//		}		
//	}
	/* getting client id through project number */
	@SuppressWarnings("resource")
	public static String updatePriceMilestone(String pregpuno, String pregcuid, String token, String enqid,
			String buildingtime) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = null;
		try {
			String queryselect = "SELECT preguid FROM hrmproject_reg where 	pregpuno='" + pregpuno + "' and pregcuid='"
					+ pregcuid + "' and pregtokenno='" + token + "'";
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
			// updating project price id of enquiry
			if (getinfo != null)
				ps = con.prepareStatement(
						"update project_price set preguid=?,enq=? where preguid=? and enq=? and tokenno=?");
			ps.setString(1, getinfo);
			ps.setString(2, "NA");
			ps.setString(3, enqid);
			ps.setString(4, "enquiry");
			ps.setString(5, token);
			ps.execute();
			ps = con.prepareStatement(
					"update project_milestone set preguid=?,enq=? where preguid=? and enq=? and tokenno=?");
			ps.setString(1, getinfo);
			ps.setString(2, "NA");
			ps.setString(3, enqid);
			ps.setString(4, "enquiry");
			ps.setString(5, token);
			ps.execute();
			ps = con.prepareStatement("update hrmproject_reg set pregbuildingtime=? where preguid=? and pregtokenno=?");
			ps.setString(1, buildingtime);
			ps.setString(2, getinfo);
			ps.setString(3, token);

			ps.execute();
		} catch (Exception e) {
			log.info("EnquiryACT.updatePriceMilestone " + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null) {
					rset.close();
				}
			} catch (SQLException e) {
				log.info("EnquiryACT.updatePriceMilestone " + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getSalesDueAmount(String salesNo, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT cbdueamount FROM hrmclient_billing where cbestimateno='" + salesNo
					+ "' and cbtokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}

		} catch (Exception e) {
			log.info("EnquiryACT.getSalesDueAmount " + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null) {
					rset.close();
				}
			} catch (SQLException e) {
				log.info("EnquiryACT.getSalesDueAmount " + e.getMessage());
			}
		}
		return getinfo;
	}

	public static double findSalesDueAmount(String invoiceNo, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT cbdueamount FROM hrmclient_billing where cbinvoiceno='" + invoiceNo
					+ "' and cbtokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}

		} catch (Exception e) {
			log.info("EnquiryACT.findSalesDueAmount " + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null) {
					rset.close();
				}
			} catch (SQLException e) {
				log.info("EnquiryACT.findSalesDueAmount " + e.getMessage());
			}
		}
		return getinfo;
	}

	/* getting enquiry id */
	public static String getEnquiryId(String enquid, String company, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = null;
		try {
			String queryselect = "SELECT enqid FROM userenquiry where enquid='" + enquid + "' and enqCompanyName='"
					+ company + "' and 	enqTokenNo='" + token + "'";
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}

		} catch (Exception e) {
			log.info("EnquiryACT.getEnquiryId " + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null) {
					rset.close();
				}
			} catch (SQLException e) {
				log.info("EnquiryACT.getEnquiryId " + e.getMessage());
			}
		}
		return getinfo;
	}

	/* getting product id */
	public static String getProductId(String productType, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = null;
		try {
			String queryselect = "SELECT pid FROM product_master where pname='" + productType + "' and 	ptokenno='"
					+ token + "'";
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}

		} catch (Exception e) {
			log.info("EnquiryACT.getProductId " + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null) {
					rset.close();
				}
			} catch (SQLException e) {
				log.info("EnquiryACT.getProductId " + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getClientsAccountid(String clientid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT caid FROM client_accounts where cacid='" + clientid + "' and catokenno='"
					+ token + "'";
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}

		} catch (Exception e) {
			log.info("EnquiryACT.getClientsAccountid " + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null) {
					rset.close();
				}
			} catch (SQLException e) {
				log.info("EnquiryACT.getClientsAccountid " + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getClientIdByRefid(String clientrefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT creguid FROM hrmclient_reg where cregclientrefid='" + clientrefid
					+ "' and cregtokenno='" + token + "'";
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}

		} catch (Exception e) {
			log.info("EnquiryACT.getClientIdByRefid " + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null) {
					rset.close();
				}
			} catch (SQLException e) {
				log.info("EnquiryACT.getClientIdByRefid " + e.getMessage());
			}
		}
		return getinfo;
	}

	/* getting client id through project number */
	public static String getClientId(String client_no, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = null;
		try {
			String queryselect = "SELECT creguid FROM hrmclient_reg where cregucid='" + client_no
					+ "' and cregtokenno='" + token + "'";
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}

		} catch (Exception e) {
			log.info("EnquiryACT.getClientId " + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null) {
					rset.close();
				}
			} catch (SQLException e) {
				log.info("EnquiryACT.getClientId " + e.getMessage());
			}
		}
		return getinfo;
	}

	/* For providing uniqueid to enquiry */
	public static String getEstimateEnqUID(String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = null;
		try {
//			String queryselect = "SELECT CAST((SUBSTRING(enquid,4)) as UNSIGNED) AS maxval FROM userenquiry where enqcompany='"+company+"' order by enqid desc limit 1";
			String queryselect = "SELECT essaleno FROM estimatesalectrl where estoken='" + token
					+ "' and essalesstatus='new' order by esid desc limit 1";

			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}

		} catch (Exception e) {
			log.info("EnquiryACT.getEstimateEnqUID " + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null) {
					rset.close();
				}
			} catch (SQLException e) {
				log.info("EnquiryACT.getEstimateEnqUID " + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getSalesProductName(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = null;
		try {
			String queryselect = "SELECT msproductname FROM managesalesctrl where msrefid='" + salesKey
					+ "' and  mstoken='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}

		} catch (Exception e) {
			log.info("EnquiryACT.getSalesProductName " + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null) {
					rset.close();
				}
			} catch (SQLException e) {
				log.info("EnquiryACT.getSalesProductName " + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getCompanyName(String invoice, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = null;
		try {
			String queryselect = "SELECT mscompany FROM managesalesctrl where msinvoiceno='" + invoice
					+ "' and  mstoken='" + token + "' order by msid limit 1";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}

		} catch (Exception e) {
			log.info("EnquiryACT.getCompanyName " + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null) {
					rset.close();
				}
			} catch (SQLException e) {
				log.info("EnquiryACT.getCompanyName " + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getProjectNumber(String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = null;
		try {
			String queryselect = "SELECT msprojectnumber FROM managesalesctrl where msstatus='1' and  mstoken='" + token
					+ "' order by msid desc limit 1";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}

		} catch (Exception e) {
			log.info("EnquiryACT.getProjectNumber " + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null) {
					rset.close();
				}
			} catch (SQLException e) {
				log.info("EnquiryACT.getProjectNumber " + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getExpenseNumber(String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = null;
		try {
			String queryselect = "SELECT mtinvoice FROM managetransactionctrl where mttokenno='" + token
					+ "' and mttype='Expense' order by mtid desc limit 1";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}

		} catch (Exception e) {
			log.info("EnquiryACT.getExpenseNumber " + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null) {
					rset.close();
				}
			} catch (SQLException e) {
				log.info("EnquiryACT.getExpenseNumber " + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String generateInvoice(String token, String date, String type) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "select invoice from invoice_generator where type='" + type + "' and token='" + token
					+ "' and date='" + date + "' order by id desc limit 1";

			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}

		} catch (Exception e) {
			log.info("EnquiryACT.generateInvoice " + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null) {
					rset.close();
				}
			} catch (SQLException e) {
				log.info("EnquiryACT.generateInvoice " + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getInvoiceNumber(String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = null;
		try {
			String queryselect = "SELECT siinvoice FROM salesinvoicectrl where sitokenno='" + token
					+ "' order by siid desc limit 1";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}

		} catch (Exception e) {
			log.info("EnquiryACT.getInvoiceNumber " + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null) {
					rset.close();
				}
			} catch (SQLException e) {
				log.info("EnquiryACT.getInvoiceNumber " + e.getMessage());
			}
		}
		return getinfo;
	}

	/* For providing uniqueid to enquiry */
	public static String getEnqUID(String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = null;
		try {
//			String queryselect = "SELECT CAST((SUBSTRING(enquid,4)) as UNSIGNED) AS maxval FROM userenquiry where enqcompany='"+company+"' order by enqid desc limit 1";
			String queryselect = "SELECT enquid FROM userenquiry where enqTokenNo='" + token
					+ "' order by enqid desc limit 1";
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}

		} catch (Exception e) {
			log.info("EnquiryACT.getEnqUID " + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null) {
					rset.close();
				}
			} catch (SQLException e) {
				log.info("EnquiryACT.getEnqUID " + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getEnqUInitial(String company) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = null;
		try {
			String queryselect = "SELECT SUBSTRING(enquid,1,3) FROM userenquiry where enqcompany='" + company
					+ "' order by enqid desc limit 1";
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			while (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}

		} catch (Exception e) {
			log.info("EnquiryACT.getEnqUID " + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null) {
					rset.close();
				}
			} catch (SQLException e) {
				log.info("EnquiryACT.getEnqUID " + e.getMessage());
			}
		}
		return getinfo;
	}

	public static boolean addPricePercentage(String pricePercKey, String saleskey, String milestoneid,
			String milestoneName, String payType, String pricePercent, String token, String addedby,
			String newsalesid) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "insert into estimateconvert_pricepercentage (eprefid,epsalesrefid,epmilestoneid,epworkpaytype,epworkpricepercentage,eptokenno,epaddedby,epmilestonename,epsaleno) values (?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, pricePercKey);
			ps.setString(2, saleskey);
			ps.setString(3, milestoneid);
			ps.setString(4, payType);
			ps.setString(5, pricePercent);
			ps.setString(6, token);
			ps.setString(7, addedby);
			ps.setString(8, milestoneName);
			ps.setString(9, newsalesid);

			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.addPricePercentage " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.addPricePercentage " + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean AddEstimateSale(String saleno, String prodtype, String company, String Remarks,
			String addedby, String token, String product_name, String key, String today, String loginuaid,
			String contactrefid, String clientrefid, String plan, String planperiod, String plantime, String qty,
			String coupon, String couponType, double discount, String value, String addedByUid, String notes,
			String jurisdiction, String orderNo, String purchaseDate, int tatValue, String tatType, String salesType) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			if (plan.equalsIgnoreCase("Renewal")) {
				if (planperiod.equalsIgnoreCase("NA") || plantime.equalsIgnoreCase("NA")) {
					plan = "OneTime";
					planperiod = "NA";
					plantime = "NA";
				}
			}
			if (company.equalsIgnoreCase("....")
					&& (clientrefid == null || clientrefid.length() <= 0 || clientrefid.equalsIgnoreCase("NA")))
				clientrefid = "NA";

			String query = "insert into estimatesalectrl (esrefid,essaleno,escompany,esprodtype,esprodname,esregdate,"
					+ "essoldbyid,escontactrefid,esclientrefid,esremarks,esaddedby,estoken,esprodplan,esplanperiod,"
					+ "esplantime,esprodqty,escoupon,estype,esdiscount,esvalue,esaddedbyuid,esinvoicenotes,esjurisdiction,"
					+ "esordernumber,espurchasedate,tat_value,tat_type,sales_type) values "
					+ "(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, key);
			ps.setString(2, saleno);
			ps.setString(3, company);
			ps.setString(4, prodtype);
			ps.setString(5, product_name);
			ps.setString(6, today);
			ps.setString(7, loginuaid);
			ps.setString(8, contactrefid);
			ps.setString(9, clientrefid);
			ps.setString(10, Remarks);
			ps.setString(11, addedby);
			ps.setString(12, token);
			ps.setString(13, plan);
			ps.setString(14, planperiod);
			ps.setString(15, plantime);
			ps.setString(16, qty);
			ps.setString(17, coupon);
			ps.setString(18, couponType);
			ps.setDouble(19, discount);
			ps.setString(20, value);
			ps.setString(21, addedByUid);
			ps.setString(22, notes);
			ps.setString(23, jurisdiction);
			ps.setString(24, orderNo);
			ps.setString(25, purchaseDate);
			ps.setInt(26, tatValue);
			ps.setString(27, tatType);
			ps.setString(28, salesType);

			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.AddEstimateSale " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.AddEstimateSale " + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean AddEnquiry(String enquid, String enqType, String company, String enqRemarks, String addedby,
			String token, String product_name, String key, String today, String loginuaid, String contactrefid,
			String clientrefid) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "insert into userenquiry (enquid, enqType,enqRemarks,enqAddedby,enqCompanyName,enqTokenNo,enqproduct_name,enqrefid,enqdate,enqaddedbyid,enqcontactrefid,enqclientrefid) values (?,?,?,?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, enquid);
			ps.setString(2, enqType);
			ps.setString(3, enqRemarks);
			ps.setString(4, addedby);
			ps.setString(5, company);
			ps.setString(6, token);
			ps.setString(7, product_name);
			ps.setString(8, key);
			ps.setString(9, today);
			ps.setString(10, loginuaid);
			ps.setString(11, contactrefid);
			ps.setString(12, clientrefid);

			ps.execute();
			status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.AddEnquiry " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.AddEnquiry " + sqle.getMessage());
			}
		}
		return status;
	}

	public static String[] getSalesProductType(String prodrefid, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String newsdata[] = new String[5];
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");

			VCQUERY = new StringBuffer("SELECT ptype,pname,prefid,tat_value,tat_type FROM product_master where prefid='"
					+ prodrefid + "' and ptokenno='" + token + "'");

			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
			rsGCD = stmnt.executeQuery();

			if (rsGCD != null && rsGCD.next()) {
				newsdata[0] = rsGCD.getString(1);
				newsdata[1] = rsGCD.getString(2);
				newsdata[2] = rsGCD.getString(3);
				newsdata[3] = rsGCD.getString(4);
				newsdata[4] = rsGCD.getString(5);
			}
		} catch (Exception e) {
			log.info("EnquiryACT.getSalesProductType " + e.getMessage());
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
				log.info("EnquiryACT.getSalesProductType " + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[] getProductPlan(String groupkey, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[] newsdata = new String[4];
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");

			VCQUERY = new StringBuffer(
					"SELECT spvprodplan,spvplanperiod,spvplantime,spvjurisdiction FROM salesproductrenewalvirtualctrl where spvprodrefid='"
							+ groupkey + "' and spvtokenno='" + token + "' ");

			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
			rsGCD = stmnt.executeQuery();

			while (rsGCD != null && rsGCD.next()) {
				newsdata[0] = rsGCD.getString(1);
				newsdata[1] = rsGCD.getString(2);
				newsdata[2] = rsGCD.getString(3);
				newsdata[3] = rsGCD.getString(4);
			}
		} catch (Exception e) {
			log.info("EnquiryACT.getProductPlan " + e.getMessage());
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
				log.info("EnquiryACT.getProductPlan " + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllProductsPayment(String groupkey, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");

			VCQUERY = new StringBuffer(
					"SELECT psvrefid,psvmode,psvdate,psvtransactionid,psvtransactionamount,psvdocumentname,psvdocpath FROM pymtsalesvirtual where psvprodvirtualrefid='"
							+ groupkey + "' and psvtokenno='" + token + "' ");

			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getAllProductsPayment " + e.getMessage());
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
				log.info("EnquiryACT.getAllProductsPayment " + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getEachProductsPriceDetails(String groupkey, String token, String username) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");

			VCQUERY = new StringBuffer(
					"SELECT spvrefpid,spvpricetype,spvprice,spvhsncode,spvcgstpercent,spvsgstpercent,spvigstpercent,spvtotalprice,spvrefid,spvqty,"
							+ "spvminprice FROM salesproductvirtual where spvprice!='0' and spvvirtualid='" + groupkey
							+ "' and spvaddedby='" + username + "' and spvtokenno='" + token + "' ");

//			System.out.println(VCQUERY);

			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getEachProductsPriceDetails " + e.getMessage());
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
				log.info("EnquiryACT.getEachProductsPriceDetails " + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getProductPriceList(String prodkey, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");

			VCQUERY = new StringBuffer(
					"SELECT * FROM product_price where pp_prodrefid='" + prodkey + "' and pp_tokenno='" + token + "' ");
//			System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getProductPriceList " + e.getMessage());
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
				log.info("EnquiryACT.getProductPriceList " + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getSalesProductList(String salesid, String token, String addedby) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");

			VCQUERY = new StringBuffer(
					"SELECT spvvirtualid,spvsalesno,spvrefpid,spvqty FROM salesproductvirtual where spvsalesid='"
							+ salesid + "' and spvtokenno='" + token + "' and spvaddedby='" + addedby
							+ "' group by spvsalesno order by spvsalesno ");

			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getSalesProductList " + e.getMessage());
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
				log.info("EnquiryACT.getSalesProductList " + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getSalesProductList(String prodKey, String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");

			VCQUERY = new StringBuffer(
					"SELECT * FROM product_price where pp_prodrefid='" + prodKey + "' and pp_tokenno='" + token + "'");

			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getSalesProductList " + e.getMessage());
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
				log.info("EnquiryACT.getSalesProductList " + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getSalesContactList(String salesid, String token, String addedby) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");

			VCQUERY = new StringBuffer(
					"SELECT scvcontactname,scvcontactemail1st,scvcontactemail2nd,scvcontactmobile1st,scvcontactmobile2nd,scvcontactrefid FROM "
							+ "salescontactboxvirtual where scvsalesid='" + salesid + "' and scvtokenno='" + token
							+ "' and scvaddedby='" + addedby + "' order by scvid ");
//			System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getSalesContactList " + e.getMessage());
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
				log.info("EnquiryACT.getSalesContactList " + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllSalesDocument(String folrefid, String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");

			VCQUERY = new StringBuffer(
					"SELECT dmuid,dmdate,dmdoctype,dmdocument_name FROM document_master where dmrefno='" + folrefid
							+ "' and dmtokenno='" + token + "' ");

			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getAllSalesDocument " + e.getMessage());
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
				log.info("EnquiryACT.getAllSalesDocument " + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getFolderAccessUser(String fKey, String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");

			VCQUERY = new StringBuffer(
					"SELECT fp.fpid,ua.uaname FROM user_account ua join folder_permission fp on fp.fp_uid=ua.uaid where fp.fp_frefid='"
							+ fKey + "' and fp.fptoken='" + token + "' and ua.uavalidtokenno='" + token
							+ "' group by fp.fp_uid order by fpid desc");
//				System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getFolderAccessUser " + e.getMessage());
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
				log.info("EnquiryACT.getFolderAccessUser " + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getEstimateProduct(String salesNo, String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");

			VCQUERY = new StringBuffer("SELECT esprodname,sales_type FROM estimatesalectrl where essaleno='" + salesNo
					+ "' and estoken='" + token + "' group by esprodname");
//				System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getEstimateProduct " + e.getMessage());
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
				log.info("EnquiryACT.getEstimateProduct " + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getCancelledInvoice(String invoice, String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");

			VCQUERY = new StringBuffer("SELECT uuid,invoice_no,date,total_amount FROM invoice where invoice_no='"
					+ invoice + "' and token='" + token + "' and status='2'");
//				System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getCancelledInvoice " + e.getMessage());
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
				log.info("EnquiryACT.getCancelledInvoice " + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getGeneratedEstimate(String estKey, String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");

			VCQUERY = new StringBuffer("SELECT date,uuid,amount,invoice FROM generate_estimate where estimate_key='"
					+ estKey + "' and token='" + token + "'");
//				System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getGeneratedEstimate " + e.getMessage());
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
				log.info("EnquiryACT.getGeneratedEstimate " + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getGeneratedEstimateData(String estKey) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");

			VCQUERY = new StringBuffer("SELECT * FROM generate_estimate where uuid='" + estKey + "'");
//				System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getGeneratedEstimateData " + e.getMessage());
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
				log.info("EnquiryACT.getGeneratedEstimateData " + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getEstimateTaxList(String salesNo, String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");

			VCQUERY = new StringBuffer(
					"SELECT sphsncode,spcgstpercent,spsgstpercent,spigstpercent FROM salesproductprice where spsalesid='"
							+ salesNo + "' and sptokenno='" + token
							+ "' and sphsncode!='NA' and sphsncode!='' group by sphsncode");
//				System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getEstimateTaxList " + e.getMessage());
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
				log.info("EnquiryACT.getEstimateTaxList " + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getSalesInvoiceTaxList(String invoice, String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");

			VCQUERY = new StringBuffer(
					"SELECT sphsncode,spcgstpercent,spsgstpercent,spigstpercent FROM salespricectrl where exists(select msid from managesalesctrl where msinvoiceno='"
							+ invoice + "' and msrefid=spsalesrefid) and sptokenno='" + token
							+ "' and sphsncode!='NA' and sphsncode!='' group by sphsncode");
//				System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getSalesInvoiceTaxList " + e.getMessage());
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
				log.info("EnquiryACT.getSalesInvoiceTaxList " + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getInvoiceTaxList(String invoice, String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");

			VCQUERY = new StringBuffer("SELECT hsn,cgst,sgst,igst FROM invoice_items where invoice_no='" + invoice
					+ "' and token='" + token + "' and hsn!='NA' and hsn!='' group by hsn");
//				System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getInvoiceTaxList " + e.getMessage());
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
				log.info("EnquiryACT.getInvoiceTaxList " + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getGenerateInvoiceTaxList(String invoiceKey) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");

			VCQUERY = new StringBuffer(
					"SELECT i.hsn,i.cgst_percent,i.sgst_percent,i.igst_percent FROM invoice_product_items i inner join invoice_product p "
							+ "on i.invoice_product_key=p.refkey where p.invoice_key='" + invoiceKey
							+ "' and i.hsn!='NA' and i.hsn!='' group by i.hsn");
//				System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getGenerateInvoiceTaxList " + e.getMessage());
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
				log.info("EnquiryACT.getGenerateInvoiceTaxList " + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getSalesTaxList(String invoice, String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");

			VCQUERY = new StringBuffer(
					"SELECT sphsncode,spcgstpercent,spsgstpercent,spigstpercent FROM salespricectrl WHERE exists(select msid from managesalesctrl where msinvoiceno='"
							+ invoice + "' and msrefid=spsalesrefid) and sptokenno='" + token
							+ "' and sphsncode!='NA' and sphsncode!='' group by sphsncode");
//				System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getSalesTaxList " + e.getMessage());
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
				log.info("EnquiryACT.getSalesTaxList " + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static double[] getEstimatePrice(String salesno, String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		double[] newsdata = new double[3];

		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");

			VCQUERY = new StringBuffer(
					"SELECT sum(spprice),sum(spcgstprice),sum(spsgstprice),sum(spigstprice),sum(sptotalprice) FROM salesproductprice where spsalesid='"
							+ salesno + "' and sptokenno='" + token + "'");
//				System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
			rsGCD = stmnt.executeQuery();

			if (rsGCD != null && rsGCD.next()) {
				newsdata[0] = rsGCD.getDouble(1);
				newsdata[1] = rsGCD.getDouble(2) + rsGCD.getDouble(3) + rsGCD.getDouble(4);
				newsdata[2] = rsGCD.getDouble(5);
			}
		} catch (Exception e) {
			log.info("EnquiryACT.getEstimatePrice " + e.getMessage());
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
				log.info("EnquiryACT.getEstimatePrice " + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getEstimatePriceList(String refid, String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");

			VCQUERY = new StringBuffer(
					"SELECT sprefid,sppricetype,spprice,sphsncode,spcgstpercent,spsgstpercent,spigstpercent,"
							+ "spcgstprice,spsgstprice,spigstprice,sptotalprice,spaddedon FROM salesproductprice where spessalerefid='"
							+ refid + "' and sptokenno='" + token + "'");
//				System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getEstimatePriceList " + e.getMessage());
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
				log.info("EnquiryACT.getEstimatePriceList " + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getSalesInvoicePriceList(String refid, String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");

			VCQUERY = new StringBuffer(
					"SELECT sprefid,sppricetype,spprice,sphsncode,spcgstpercent,spsgstpercent,spigstpercent,"
							+ "spcgstprice,spsgstprice,spigstprice,sptotalprice,spaddedon FROM salespricectrl where "
							+ "spsalesrefid='" + refid + "' and sptokenno='" + token + "'");
//				System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getSalesInvoicePriceList " + e.getMessage());
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
				log.info("EnquiryACT.getSalesInvoicePriceList " + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getInvoicePaymentList(String invoice, String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");

			VCQUERY = new StringBuffer("SELECT type,hsn,amount,cgst,sgst,igst FROM invoice_items where invoice_no='"
					+ invoice + "' and token='" + token + "'");
//				System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getInvoicePaymentList " + e.getMessage());
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
				log.info("EnquiryACT.getInvoicePaymentList " + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getPaymentList(String refid, String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");

			VCQUERY = new StringBuffer(
					"SELECT * FROM estimatepaymentdetails where payment_uid='" + refid + "' and token='" + token + "'");
//				System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getPaymentList " + e.getMessage());
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
				log.info("EnquiryACT.getPaymentList " + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getGeneratedEstimateDetails(String refid) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");

			VCQUERY = new StringBuffer("SELECT * FROM generate_estimate_details where generate_key='" + refid + "'");
//				System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getGeneratedEstimateDetails " + e.getMessage());
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
				log.info("EnquiryACT.getGeneratedEstimateDetails " + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getSalesPriceList(String refid, String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");

			VCQUERY = new StringBuffer(
					"SELECT sprefid,sppricetype,spprice,sphsncode,spcgstpercent,spsgstpercent,spigstpercent,spcgstprice,spsgstprice,spigstprice,sptotalprice,spaddedon FROM salespricectrl where spsalesrefid='"
							+ refid + "' and sptokenno='" + token + "'");
//				System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getSalesPriceList " + e.getMessage());
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
				log.info("EnquiryACT.getSalesPriceList " + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getEstimateProductList(String salesno, String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");

			VCQUERY = new StringBuffer("SELECT esrefid,esprodname,esprodqty,esregdate,esclientrefid,esprodtype,"
					+ "esdiscount,esinvoicenotes,escontactrefid,esjurisdiction,esordernumber,espurchasedate,sales_type "
					+ "FROM estimatesalectrl where essaleno='" + salesno + "' and estoken='" + token + "'");
//			System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getEstimateProductList " + e.getMessage());
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
				log.info("EnquiryACT.getEstimateProductList " + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getSalesInvoiceProductList(String invoice, String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");

			VCQUERY = new StringBuffer(
					"SELECT msrefid,msproductname,msinvoicenotes,sales_type FROM managesalesctrl where msinvoiceno='"
							+ invoice + "' and mstoken='" + token + "'");
//				System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getSalesProductList " + e.getMessage());
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
				log.info("EnquiryACT.getEstimateProductList " + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getSoldSalesProductList(String invoice, String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");

			VCQUERY = new StringBuffer(
					"SELECT msrefid,msproductname,mssolddate,msclientrefid,msproducttype FROM managesalesctrl where msinvoiceno='"
							+ invoice + "' and mstoken='" + token + "'");
//				System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getSoldSalesProductList " + e.getMessage());
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
				log.info("EnquiryACT.getSoldSalesProductList " + sqle.getMessage());
			}
		}
		return newsdata;
	}

	 public static String[][] getSalesPaymentAllocation(String salesKey,String  token) { // Initialing variables
		 Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try	{
			getacces_con = DbCon.getCon("", "", "");

			VCQUERY = new StringBuffer("SELECT p.from_year,p.to_year,p.portal_number,p.pibo_category,p.credit_type,p.product_category,p.quantity,p.comment FROM salesestimatepayment p "
					+ "JOIN managesalesctrl s on s.msestimateno=p.sestsaleno where s.msrefid='"+salesKey+"' and s.mstoken='"+token+"';");
//			System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
		}catch(	Exception e){
			log.info("EnquiryACT.getSalesPaymentAllocation " + e.getMessage());
		}finally{
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
				log.info("EnquiryACT.getSalesPaymentAllocation " + sqle.getMessage());
			}
		}
		return newsdata;
	}
	
	 public static String[][] getSalesPayment(String invoiceno,String  token,String status) { // Initialing variables
	 Connection getacces_con = null;
	PreparedStatement stmnt = null;
	ResultSet rsGCD = null;
	String[][] newsdata = null;
	StringBuffer VCQUERY = null;try
	{
		getacces_con = DbCon.getCon("", "", "");

		VCQUERY = new StringBuffer("SELECT p.srefid,p.saddeddate,p.spaymtmode,p.stransactionid,"
				+ "p.stransactionamount,p.sdocumentname,p.sdocpath,p.spayment_remarks,u.uaname,"
				+ "p.service_name,p.hold_comment,p.po_validity,p.from_year,p.to_year,p.portal_number,p.pibo_category,p.credit_type,p.product_category,p.quantity,p.comment FROM "
				+ "salesestimatepayment p INNER JOIN user_account u on p.saddedbyuid=u.uaid " + "where (p.sestsaleno='"
				+ invoiceno + "' or p.sinvoiceno='" + invoiceno + "') and p.stokenno='" + token + "' "
				+ "and p.stransactionstatus='" + status + "'");
//		System.out.println(VCQUERY);
		stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
	}catch(	Exception e){
		log.info("EnquiryACT.getSalesPayment " + e.getMessage());
	}finally{
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
			log.info("EnquiryACT.getSalesPayment " + sqle.getMessage());
		}
	}
	return newsdata;
}

public static String[][] fetchSalesEstimatePayment(String srefid) {
	// Initialing variables
	Connection getacces_con = null;
	PreparedStatement stmnt = null;
	ResultSet rsGCD = null;
	String[][] newsdata = null;
	StringBuffer VCQUERY = null;
	try {
		getacces_con = DbCon.getCon("", "", "");
		
		VCQUERY = new StringBuffer("SELECT saddeddate,sestsaleno,spaymtmode,stransactionid,stransactionamount,"
				+ "service_name,stokenno,spayment_remarks from salesestimatepayment "
				+ "where srefid='"+srefid+"'");
					
//		System.out.println(VCQUERY);
		stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
		log.info("EnquiryACT.fetchSalesEstimatePayment "+e.getMessage());
	} finally {
		try {
			if (stmnt != null) {
				stmnt.close();
			}
			if (getacces_con != null) {
				getacces_con.close();
			}
			if (rsGCD != null) { rsGCD.close();}
		} catch (SQLException sqle) {
			log.info("EnquiryACT.fetchSalesEstimatePayment "+sqle.getMessage());
		}
	}
	return newsdata;
}

public static String[][] getDocumentListByKey(String salesrefid,String token) {
	// Initialing variables
	Connection getacces_con = null;
	PreparedStatement stmnt = null;
	ResultSet rsGCD = null;
	String[][] newsdata = null;
	StringBuffer VCQUERY = null;
	try {
		getacces_con = DbCon.getCon("", "", "");
		
		VCQUERY = new StringBuffer("SELECT sdrefid,sduploaddocname,sddescription,sduploadby,sddocname,sduploaddate,reupload_status FROM salesdocumentctrl where sdsalesrefid='"+salesrefid+"' and sdtokenno='"+token+"' and sduploadby='Client'");
//		System.out.println(VCQUERY);
		stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
		log.info("EnquiryACT.getDocumentListByKey "+e.getMessage());
	} finally {
		try {
			if (stmnt != null) {
				stmnt.close();
			}
			if (getacces_con != null) {
				getacces_con.close();
			}
			if (rsGCD != null) { rsGCD.close();}
		} catch (SQLException sqle) {
			log.info("EnquiryACT.getDocumentListByKey "+sqle.getMessage());
		}
	}
	return newsdata;
}

public static String[][] getCompanyByKey(String clientkey,String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			
			VCQUERY = new StringBuffer("SELECT cregclientrefid,cregname,cregindustry,cregpan,creggstin,creglocation,"
					+ "cregstate,cregcountry,cregaddress,cregcompanyage,cregstatecode,super_user_uaid FROM hrmclient_reg "
					+ "where cregclientrefid='"+clientkey+"' and cregtokenno='"+token+"' limit 1");
//			System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getCompanyByKey "+e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null) { rsGCD.close();}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.getCompanyByKey "+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[] getClientContactByKey(String contkey,String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[] newsdata = new String[3];
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			
			VCQUERY = new StringBuffer("SELECT cbname,cbmobile1st,cbemail1st FROM contactboxctrl where cbrefid='"+contkey+"' and cbtokenno='"+token+"' limit 1");
//			System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
			rsGCD = stmnt.executeQuery();			
			while (rsGCD != null && rsGCD.next()) {
				newsdata[0]=rsGCD.getString(1);
				newsdata[1]=rsGCD.getString(2);
				newsdata[2]=rsGCD.getString(3);
			}
		} catch (Exception e) {
			log.info("EnquiryACT.getClientContactByKey "+e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null) { rsGCD.close();}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.getClientContactByKey "+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] findSalesContactsByKey(String contkey,String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			
			VCQUERY = new StringBuffer("SELECT cbname,cbmobile1st,cbemail1st,cbcontactrefid FROM contactboxctrl where cbrefid='"+contkey+"' and cbtokenno='"+token+"'");
			System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.findSalesContactsByKey "+e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null) { rsGCD.close();}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.findSalesContactsByKey "+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getSalesContactByKey(String contkey,String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			
			VCQUERY = new StringBuffer("SELECT cbemail1st FROM contactboxctrl where cbrefid='"+contkey+"' and cbtokenno='"+token+"'");
//			System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getSalesContactByKey "+e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null) { rsGCD.close();}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.getSalesContactByKey "+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getManageInvoice(String refKey,String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			
			VCQUERY = new StringBuffer("SELECT type,ref_invoice,bill_to,gstin,"
					+ "ship_to,place_supply,invoice_no,substring(post_date,1,10) as post_date,due_amount "
					+ "FROM manage_invoice where "
					+ "refkey='"+refKey+"' and token='"+token+"'");
			
//			System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
		} catch (Exception e) {e.printStackTrace();
			log.info("EnquiryACT.getManageInvoice "+e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null) { rsGCD.close();}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.getManageInvoice "+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getInvoicedPayments(String invoice,String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			
			VCQUERY = new StringBuffer("SELECT srefid,saddeddate,sapproveddate,sapprovedby,"
					+ "spaymtmode,stransactionid,stransactionamount,sdocumentname,"
					+ "stransactionstatus,sinvoice_status,sunbill_no FROM salesestimatepayment where "
					+ "(sinvoiceno='"+invoice+"' or sestsaleno='"+invoice+"') and "
							+ "stokenno='"+token+"' and sinvoice_status='1' ");
			VCQUERY.append("and stransactionstatus!='2'");
//			System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
		} catch (Exception e) {e.printStackTrace();
			log.info("EnquiryACT.getPayments "+e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null) { rsGCD.close();}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.getPayments "+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getPayments(String invoice,String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			
			VCQUERY = new StringBuffer("SELECT srefid,saddeddate,sapproveddate,sapprovedby,"
					+ "spaymtmode,stransactionid,stransactionamount,sdocumentname,"
					+ "stransactionstatus,sinvoice_status,sunbill_no FROM salesestimatepayment where "
					+ "(sinvoiceno='"+invoice+"' or sestsaleno='"+invoice+"') and "
							+ "stokenno='"+token+"' ");
			VCQUERY.append("and stransactionstatus!='2'");
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getPayments "+e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null) { rsGCD.close();}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.getPayments "+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getContactByKey(String contkey,String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			
			VCQUERY = new StringBuffer("SELECT ccbrefid,cccontactfirstname,cccontactlastname,ccemailfirst,ccemailsecond,ccworkphone,ccmobilephone,ccaddresstype,cccity,ccstate,ccaddress,cccompanyname,ccbclientrefid,cccountry,ccpan,ccstatecode FROM clientcontactbox where ccbrefid='"+contkey+"' and cctokenno='"+token+"'");
//			System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getContactByKey "+e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null) { rsGCD.close();}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.getContactByKey "+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getSoldProducts(String estimateno,String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			
			VCQUERY = new StringBuffer("SELECT esrefid,esprodname,sales_type FROM estimatesalectrl where essaleno='"+estimateno+"' and estoken='"+token+"'");
//			System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getSoldProducts "+e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null) { rsGCD.close();}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.getSoldProducts "+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getEstimatesByNo(String estimateNo,String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			
			VCQUERY = new StringBuffer("SELECT esrefid,esprodname,esstatus,sales_type FROM estimatesalectrl where essaleno='"+estimateNo+"' and estoken='"+token+"'");
//			System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getEstimatesByNo "+e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null) { rsGCD.close();}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.getEstimatesByNo "+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getPayType(String estimateKey,String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			
			VCQUERY = new StringBuffer("SELECT eprefid,epmilestonename,epworkpaytype,epworkpricepercentage FROM estimateconvert_pricepercentage where epsalesrefid='"+estimateKey+"' and eptokenno='"+token+"'");
//			System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getPayType "+e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null) { rsGCD.close();}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.getPayType "+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getRegisteredPayment(String estimateno,String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			
			VCQUERY = new StringBuffer("SELECT srefid,saddeddate,sestsaleno,spaymtmode,stransactionid,stransactionamount,stransactionstatus,sdocumentname,scomment,hold_comment FROM salesestimatepayment where sestsaleno='"+estimateno+"' and stokenno='"+token+"'");
//			System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getRegisteredPayment "+e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null) { rsGCD.close();}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.getRegisteredPayment "+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getEstimateSalesSummary(String saleNo,int pageNo,String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			
			VCQUERY = new StringBuffer("SELECT endate,enremarks FROM estimatesales_notification where ensalesno='"+saleNo+"' and entoken='"+token+"' limit "+pageNo+",3");
//			System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getEstimateSalesSummary "+e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null) { rsGCD.close();}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.getEstimateSalesSummary "+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getSalesProductTimePlan(String salerefid,String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			
			VCQUERY = new StringBuffer("SELECT esprodqty,esprodplan,esplanperiod,esplantime,esjurisdiction FROM estimatesalectrl where esrefid='"+salerefid+"' and estoken='"+token+"'");
//			System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getSalesProductTimePlan "+e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null) { rsGCD.close();}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.getSalesProductTimePlan "+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getSalesProductPrice(String pricerefid,String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			
			VCQUERY = new StringBuffer("SELECT sprefid,sppricetype,spprice,sphsncode,spigstpercent,spcgstprice,spsgstprice,spigstprice,sptotalprice,spcgstpercent,spsgstpercent,spminpriceofone FROM salesproductprice where spessalerefid='"+pricerefid+"' and sptokenno='"+token+"'");
//			System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getSalesProductPrice "+e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null) { rsGCD.close();}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.getSalesProductPrice "+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getProductPriceById(String prodrefid,String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			
			VCQUERY = new StringBuffer("SELECT pp_service_type,pp_price,pp_hsncode,pp_cgstpercent,pp_total_price,pp_sgstpercent,pp_igstpercent FROM product_price where pp_prodrefid='"+prodrefid+"' and pp_tokenno='"+token+"'");
//			System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getProductPriceById "+e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null) { rsGCD.close();}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.getProductPriceById "+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getEstimateInvoice(String refid) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			
			VCQUERY = new StringBuffer("SELECT estid,estuuid,estinvoiceno,estcreateddate,estcreatedbyrefid FROM estimateinvoicectrl where estsalesrefid='"+refid+"' ");
			
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getRelatedTransaction "+e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null) { rsGCD.close();}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.getRelatedTransaction "+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getRelatedTransaction(String refid) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");
			
			VCQUERY = new StringBuffer("SELECT saddeddate,spaymtmode,stransactionid,stransactionamount,stransactionstatus,srefid FROM salesestimatepayment where senqrefid='"+refid+"' ");
			
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("EnquiryACT.getRelatedTransaction "+e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null) { rsGCD.close();}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.getRelatedTransaction "+sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static void saveProductsPayment(String salesrefid,String refid,String mode,String date,String transactionid,String transactionamount,String documentname,String docpath,String token,String addedby){
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "insert into salesestimatepayment(srefid,saddeddate,senqrefid,spaymtmode,stransactionid,stransactionamount,stransactionstatus,saddedby,stokenno,sdocumentname) values (?,?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1,refid);
			ps.setString(2,date );
			ps.setString(3,salesrefid );
			ps.setString(4,mode );
			ps.setString(5,transactionid );
			ps.setString(6,transactionamount);
			ps.setString(7,"Not Approved");
			ps.setString(8, addedby);
			ps.setString(9, token);
			ps.setString(10, documentname);
			
			ps.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
			log.info("EnquiryACT.saveProductsPayment "+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.saveProductsPayment "+sqle.getMessage());
			}
		}
	}

	public static boolean saveSalesProductPrice(String salesid,String prodrefid,String pricetype,
			double price,String hsn,double cgst,double sgst,double igst,double cgstprice,
			double sgstprice,double igstprice,double totalprice,String refid,String token,
			String addedby,String eskey,String minprice){
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag=false;
		try {
			String query = "insert into salesproductprice(sprefid,spsalesid,spprodrefid,sppricetype,spprice,sphsncode,spcgstpercent,spsgstpercent,spigstpercent,spcgstprice,spsgstprice,spigstprice,sptotalprice,sptokenno,spaddedby,spessalerefid,spminpriceofone) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1,refid);
			ps.setString(2,salesid );
			ps.setString(3,prodrefid );
			ps.setString(4,pricetype );
			ps.setDouble(5,price );
			ps.setString(6, hsn);
			ps.setDouble(7, cgst);
			ps.setDouble(8, sgst);
			ps.setDouble(9, igst);
			ps.setDouble(10, cgstprice);
			ps.setDouble(11, sgstprice);
			ps.setDouble(12, igstprice);
			ps.setDouble(13, totalprice);
			ps.setString(14, token);
			ps.setString(15, addedby);
			ps.setString(16, eskey);
			ps.setString(17, minprice);
			
			int k=ps.executeUpdate();
			if(k>0)flag=true;
		} catch (Exception e) {
			e.printStackTrace();
			log.info("EnquiryACT.saveSalesProductPrice "+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.saveSalesProductPrice "+sqle.getMessage());
			}
		}
		return flag;
	}

	public static void saveSalesContact(String contrefid,String name,String email1,String email2,String mobile1,
			String mobil2,String crefid,String token,String addedby,int super_user_id){
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "insert into contactboxctrl(cbrefid,cbname,cbemail1st,cbemail2nd,cbmobile1st,"
					+ "cbmobile2nd,cbtokenno,cbaddedby,cbcontactrefid,super_user_id) values (?,?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1,contrefid);
			ps.setString(2,name );
			ps.setString(3,email1 );
			ps.setString(4,email2 );
			ps.setString(5,mobile1 );
			ps.setString(6,mobil2);
			ps.setString(7,token);
			ps.setString(8, addedby);
			ps.setString(9, crefid);
			ps.setInt(10, super_user_id);
			
			ps.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
			log.info("EnquiryACT.saveSalesContact "+e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.saveSalesContact "+sqle.getMessage());
			}
		}
	}

	public static boolean HistoryAdd(String uid, String loginid, String ipaddress, String click) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "insert into userenquiryhistory (loginid, ipaddress, clickedon, addedon, enqid) values (?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, loginid);
			ps.setString(2, ipaddress);
			ps.setString(3, click);
			ps.setString(4, dateFormat.format(date));
			ps.setString(5, uid);
			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			e.printStackTrace();
			log.info("EnquiryACT.HistoryAdd " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.HistoryAdd " + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean updateSaleProductPrice(String sprefid, double price, double cgstprice, double sgstprice,
			double igstprice, double totalprice, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "update salesproductprice set spprice=?,spcgstprice=?,spsgstprice=?,spigstprice=?,sptotalprice=? WHERE sprefid=? and sptokenno=?";
			ps = con.prepareStatement(query);
			ps.setDouble(1, price);
			ps.setDouble(2, cgstprice);
			ps.setDouble(3, sgstprice);
			ps.setDouble(4, igstprice);
			ps.setDouble(5, totalprice);
			ps.setString(6, sprefid);
			ps.setString(7, token);
			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.updateSaleProductPrice " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.updateSaleProductPrice " + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean deleteSaleTemprorey(String uid, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "update userenquiry set enqStatus='0' WHERE enqrefid='" + uid + "' and enqTokenNo='" + token
					+ "'";
//			System.out.println(query);
			ps = con.prepareStatement(query);
			ps.execute();
			status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.deleteSaleTemprorey " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.deleteSaleTemprorey " + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean deleteManageInvoice(String refKey, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "update manage_invoice set active_status=false WHERE refkey='" + refKey + "' and token='"
					+ token + "'";
//			System.out.println(query);
			ps = con.prepareStatement(query);
			ps.execute();
			status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.deleteManageInvoice " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.deleteManageInvoice " + sqle.getMessage());
			}
		}
		return status;
	}

	@SuppressWarnings("resource")
	public static boolean enquiryDelete(String uid, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			ps = con.prepareStatement("DELETE FROM project_price WHERE preguid='" + uid
					+ "' and enq='enquiry' and tokenno='" + token + "'");
			ps.execute();
			ps = con.prepareStatement("DELETE FROM project_milestone WHERE preguid='" + uid
					+ "' and enq='enquiry' and tokenno='" + token + "'");
			ps.execute();
			String query = "DELETE FROM userenquiry WHERE enqid='" + uid + "' and enqTokenNo='" + token + "'";
			ps = con.prepareStatement(query);
			ps.execute();
			status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.EnquiryDelete " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.EnquiryDelete " + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean updateSalesContactToVirtual(String contactid, String name, String email, String workMobile,
			String mobile, String salesid, String token, String addedby) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "UPDATE salescontactboxvirtual SET scvcontactname=?, scvcontactemail1st=?,scvcontactmobile1st=?,scvcontactmobile2nd=? "
					+ "WHERE scvcontactboxid=? and scvtokenno=? and scvsalesid=? and scvaddedby=?";
			ps = con.prepareStatement(query);
			ps.setString(1, name);
			ps.setString(2, email);
			ps.setString(3, workMobile);
			ps.setString(4, mobile);
			ps.setString(5, contactid);
			ps.setString(6, token);
			ps.setString(7, salesid);
			ps.setString(8, addedby);

			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			e.printStackTrace();
			log.info("EnquiryACT.updateSalesContactToVirtual " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.updateSalesContactToVirtual " + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean saveFollowUp(String enqfeuid, String enqfstatus, String enqdate, String enqfremark,
			String loginid, String enqfdate, String token, String uarefid, String showdelivery) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "insert into userenquiryfollowup (enqfeuid, enqfstatus, enqfremark, enqfdate, enqfaddedby, enqfaddedon,enqfnextfollowupdate,enqftokenno,enqfuserrefid,enqshowtodelivery) values (?,?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, enqfeuid);
			ps.setString(2, enqfstatus);
			ps.setString(3, enqfremark);
			ps.setString(4, enqdate);
			ps.setString(5, loginid);
			ps.setString(6, dateFormat.format(date));
			ps.setString(7, enqfdate);
			ps.setString(8, token);
			ps.setString(9, uarefid);
			ps.setString(10, showdelivery);

			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.saveFollowUp " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.saveFollowUp " + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean saveFollowUpStatus(String enqfeuid, String enqfstatus, String enqdate, String enqfdate,
			String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "UPDATE userenquiry SET enqStatus=?,	enqFollowUpDate=?,enqNextFollowUpDate=? WHERE enqid=? and enqTokenNo=?";
			ps = con.prepareStatement(query);
			ps.setString(1, enqfstatus);
			ps.setString(2, enqdate);
			ps.setString(3, enqfdate);
			ps.setString(4, enqfeuid);
			ps.setString(5, token);
			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.saveFollowUpStatus " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.saveFollowUpStatus " + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean FollowUpDelete(String uid) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "DELETE FROM userenquiryfollowup WHERE enqfuid='" + uid + "'";
			ps = con.prepareStatement(query);
			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.FollowUpDelete " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.FollowUpDelete " + sqle.getMessage());
			}
		}
		return status;
	}

	public static String[] getSalesData(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo[] = new String[3];
		try {
			String queryselect = "SELECT msinvoiceno,msestimateno,msproductname FROM managesalesctrl where (msrefid='"
					+ salesKey + "' or msinvoiceno='" + salesKey + "') and mstoken='" + token + "' limit 1";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo[0] = rset.getString(1);
				getinfo[1] = rset.getString(2);
				getinfo[2] = rset.getString(3);
			}
		} catch (Exception e) {
			log.info("getSalesData" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getSalesData" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String findEstimateSalesPayType(String estimateNo, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT epworkpaytype FROM estimateconvert_pricepercentage where epsaleno='"
					+ estimateNo + "' and eptokenno='" + token + "' limit 1";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getEstimateSalesPayType" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getEstimateSalesPayType" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getEstimateSalesPayType(String estimateKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT epworkpaytype FROM estimateconvert_pricepercentage where epsalesrefid='"
					+ estimateKey + "' and eptokenno='" + token + "' limit 1";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getEstimateSalesPayType" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getEstimateSalesPayType" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getProductKeyByNo(String productNo, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT prefid FROM product_master where pprodid='" + productNo + "' and ptokenno='"
					+ token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getProductKeyByNo" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getProductKeyByNo" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static boolean isTransactionExist(String transactionId, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		boolean getinfo = false;
		try {
			String queryselect = "SELECT sid FROM salesestimatepayment where stransactionid='" + transactionId
					+ "' and stokenno='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = true;
			}
		} catch (Exception e) {
			log.info("getProductKeyByNo" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getProductKeyByNo" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String[][] getVirtualProductList(String enquid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String queryselect = "SELECT spvrefpid,spvqty FROM salesproductvirtual where spvsalesid='" + enquid
					+ "' and spvtokenno='" + token + "' group by spvsalesid";
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
			log.info("getVirtualProductList" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getVirtualProductList" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static double getEstimateDiscount(String essaleno, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		double getinfo = 0;
		try {
			String queryselect = "SELECT esdiscount FROM estimatesalectrl where essaleno ='" + essaleno
					+ "' and estoken='" + token + "' limit 1";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getDouble(1);
			}
		} catch (Exception e) {
			log.info("getEstimateDiscount" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getEstimateDiscount" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String[] getAppliedCoupon(String salesno, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo[] = new String[3];
		try {
			String queryselect = "SELECT escoupon,estype,esvalue FROM estimatesalectrl where essaleno='" + salesno
					+ "' and estoken='" + token + "'";
//			System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo[0] = rset.getString(1);
				getinfo[1] = rset.getString(2);
				getinfo[2] = rset.getString(3);
			}
		} catch (Exception e) {
			log.info("getAppliedCoupon" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getAppliedCoupon" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String getContactEmail(String contactKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String newsdata = "NA";
		try {
			String queryselect = "SELECT cbemail1st FROM contactboxctrl where cbrefid ='" + contactKey
					+ "' and cbtokenno='" + token + "' limit 1";

			ps = con.prepareStatement(queryselect);
			rsGCD = ps.executeQuery();

			while (rsGCD != null && rsGCD.next()) {
				newsdata = rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("getContactEmail" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getContactEmail" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String getPdfFileName(int inv) {
		DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd_HH-mm-ss");
		String dateTimeInfo = dateFormat.format(new Date());
		return String.format("invoices_%s.pdf", dateTimeInfo + inv);
	}

	public static boolean addDownloadHistory(String key, String type, String download_key, String from_to_date,
			String today, String time, String uaid, String page, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "insert into download_export_history (uuid, type, invoice, export_from_to, date, time,uaid,page,token) values (?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, key);
			ps.setString(2, type);
			ps.setString(3, download_key);
			ps.setString(4, from_to_date);
			ps.setString(5, today);
			ps.setString(6, time);
			ps.setString(7, uaid);
			ps.setString(8, page);
			ps.setString(9, token);

			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.addDownloadHistory " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.addDownloadHistory " + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean updateSalesWorkStatus(String status, String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		StringBuffer queryselect = null;
		boolean flag = false;
		try {
			queryselect = new StringBuffer(
					"update managesalesctrl set msworkstatus=?" + " where msrefid=? and mstoken=?");

			ps = con.prepareStatement(queryselect.toString());
			ps.setString(1, status);
			ps.setString(2, salesKey);
			ps.setString(3, token);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;

		} catch (Exception e) {
			log.info("updateSalesWorkStatus" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException e) {
				log.info("updateSalesWorkStatus" + e.getMessage());
			}
		}
		return flag;
	}

	public static boolean saveEmail(String email, String cc, String subject, String message, int estatus,
			String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "insert into email_scheduler (email_to, email_cc, subject, message,status,token) values (?,?,?,?,?,?)";
			ps = con.prepareStatement(query);
			ps.setString(1, email);
			ps.setString(2, cc);
			ps.setString(3, subject);
			ps.setString(4, message);
			ps.setInt(5, estatus);
			ps.setString(6, token);

			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			e.printStackTrace();
			log.info("EnquiryACT.saveEmail " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.saveEmail " + sqle.getMessage());
			}
		}
		return status;
	}

	public static String[][] getAllPendingEmails() {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String queryselect = "SELECT email_to, email_cc, subject, message,id FROM email_scheduler where status='2' and email_to!='NA'";
//		System.out.println(queryselect);
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
			log.info("getAllPendingEmails" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getAllPendingEmails" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static boolean removeSendedEmail(String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "delete from email_scheduler where token=? and status=?";
			ps = con.prepareStatement(query);
			ps.setString(1, token);
			ps.setInt(2, 1);
			ps.executeUpdate();
			status = true;
		} catch (Exception e) {
			e.printStackTrace();
			log.info("EnquiryACT.removeSendedEmail " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.removeSendedEmail " + sqle.getMessage());
			}
		}
		return status;
	}

	public static boolean updateEmailScheduler(String id, int status) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "update email_scheduler set status=? where id=?";
			ps = con.prepareStatement(query);
			ps.setInt(1, status);
			ps.setString(2, id);
			ps.executeUpdate();
			flag = true;
		} catch (Exception e) {
			e.printStackTrace();
			log.info("EnquiryACT.updateEmailScheduler " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.updateEmailScheduler " + sqle.getMessage());
			}
		}
		return flag;
	}

	public static double[] getFees(String estimateno, String token, String type) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		double[] data = new double[2];
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement(
					"select sum(sptotalprice),sum(spcgstprice),sum(spsgstprice),sum(spigstprice) from salesproductprice where spsalesid='"
							+ estimateno + "' and sppricetype='" + type + "' and sptokenno='" + token + "'");
			rs = ps.executeQuery();
			if (rs.next()) {
				data[0] = rs.getDouble(1);
				data[1] = (rs.getDouble(2) + rs.getDouble(3) + rs.getDouble(4));
			}

		} catch (Exception e) {
			log.info("getFees()" + e.getMessage());
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
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getFees()\n" + sqle.getMessage());
			}
		}
		return data;
	}

	public static int[] getMaxTax(String estimateno, String token, String type) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		int[] data = new int[3];
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement(
					"select spcgstpercent,spsgstpercent,spigstpercent from salesproductprice where spsalesid='"
							+ estimateno + "' and sppricetype='" + type + "' and sptokenno='" + token
							+ "' order by (spcgstpercent+spsgstpercent+spigstpercent) desc limit 1");
//		System.out.println("select spcgstpercent,spsgstpercent,spigstpercent from salesproductprice where spsalesid='"+estimateno+"' and sppricetype='"+type+"' and sptokenno='"+token+"' order by (spcgstpercent+spsgstpercent+spigstpercent) desc limit 1");
			rs = ps.executeQuery();
			if (rs != null && rs.next()) {
				data[0] = rs.getInt(1);
				data[1] = rs.getInt(2);
				data[2] = rs.getInt(3);
			}

		} catch (Exception e) {
			e.printStackTrace();
			log.info("getMaxTax()" + e.getMessage());
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
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getMaxTax()\n" + sqle.getMessage());
			}
		}
		return data;
	}

	public static boolean savePaymentDetails(String dkey, String payment_uid, String type, int cgst, int sgst, int igst,
			String token, String date, String typeAmount) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement(
					"insert into estimatepaymentdetails(uid,payment_uid,type,cgst,sgst,igst,token,date,amount) "
							+ "values(?,?,?,?,?,?,?,?,?)");

			ps.setString(1, dkey);
			ps.setString(2, payment_uid);
			ps.setString(3, type);
			ps.setInt(4, cgst);
			ps.setInt(5, sgst);
			ps.setInt(6, igst);
			ps.setString(7, token);
			ps.setString(8, date);
			ps.setString(9, typeAmount);

			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			log.info("savePaymentDetails()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error Closing SQL savePaymentDetails() Objects \n" + sqle);
			}
		}
		return status;
	}

	public static boolean isComplianceExist(String ckey, String data, String token) {
		PreparedStatement ps = null;
		boolean status = false;
		ResultSet rs = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement("select id from compliance where product_name='" + data + "' and uuid!='" + ckey
					+ "' and token='" + token + "' limit 1");
//			System.out.println("select id from compliance where product_name='"+data+"' and uuid!='"+ckey+"' and token='"+token+"' limit 1");
			rs = ps.executeQuery();
			if (rs.next())
				status = true;
		} catch (Exception e) {
			e.printStackTrace();
			log.info("isComplianceExist()" + e.getMessage());
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
				log.info("Error Closing SQL isComplianceExist() Objects \n" + sqle);
			}
		}
		return status;
	}

	public static boolean isComplianceExist(String data, String token) {
		PreparedStatement ps = null;
		boolean status = false;
		ResultSet rs = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement(
					"select id from compliance where product_name='" + data + "' and token='" + token + "' limit 1");
			rs = ps.executeQuery();
			if (rs.next())
				status = true;
		} catch (Exception e) {
			log.info("isComplianceExist()" + e.getMessage());
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
				log.info("Error Closing SQL isComplianceExist() Objects \n" + sqle);
			}
		}
		return status;
	}

	public static boolean isInvoiceConverted(String salesno, String token) {
		PreparedStatement ps = null;
		boolean status = false;
		ResultSet rs = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement("select esid from estimatesalectrl where essaleno='" + salesno + "' and estoken='"
					+ token + "' and esstatus='Invoiced' limit 1");
			rs = ps.executeQuery();
			if (rs.next())
				status = true;
		} catch (Exception e) {
			log.info("isInvoiceConverted()" + e.getMessage());
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
				log.info("Error Closing SQL isInvoiceConverted() Objects \n" + sqle);
			}
		}
		return status;
	}

	public static boolean saveGenerateEstimate(String uuid, String estKey, String products, String pymtamount,
			String date, String time, String token, String invoice, String estimateNotes) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement("insert into generate_estimate(uuid,estimate_key,product_name,"
					+ "amount,date,time,token,invoice,invoice_notes) values(?,?,?,?,?,?,?,?,?)");

			ps.setString(1, uuid);
			ps.setString(2, estKey);
			ps.setString(3, products);
			ps.setString(4, pymtamount);
			ps.setString(5, date);
			ps.setString(6, time);
			ps.setString(7, token);
			ps.setString(8, invoice);
			ps.setString(9, estimateNotes);

			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			log.info("saveGenerateEstimate()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error Closing SQL saveGenerateEstimate() Objects \n" + sqle);
			}
		}
		return status;
	}

	public static void saveGeneratePymtDetails(String gkey, String uuid, String type, int professionalCgst,
			int professionalSgst, int professionalIgst, String token, String date, String amount) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement(
					"insert into generate_estimate_details(uuid,generate_key,type,amount,cgst,sgst,igst,token) "
							+ "values(?,?,?,?,?,?,?,?)");

			ps.setString(1, gkey);
			ps.setString(2, uuid);
			ps.setString(3, type);
			ps.setString(4, amount);
			ps.setInt(5, professionalCgst);
			ps.setInt(6, professionalSgst);
			ps.setInt(7, professionalIgst);
			ps.setString(8, token);

			ps.execute();
		} catch (Exception e) {
			log.info("saveGenerateEstimate()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error Closing SQL saveGenerateEstimate() Objects \n" + sqle);
			}
		}
	}

	public static String getSalesInvoiceNumber(String unbillno, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String newsdata = "NA";
		try {
			String queryselect = "SELECT sinvoiceno FROM salesestimatepayment where sunbill_no='" + unbillno
					+ "' and stokenno='" + token + "' limit 1";
//		System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rsGCD = ps.executeQuery();

			while (rsGCD != null && rsGCD.next()) {
				newsdata = rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("getSalesInvoiceNumber" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getSalesInvoiceNumber" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getInvoiceDetails(String uuid) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String queryselect = "SELECT uuid,invoice_no,date,company,gstin,address,service_name,"
					+ "total_amount,country,state,city,state_code,status,invoice_type,"
					+ "contact_name,contact_pan,contact_country,contact_state,contact_city,"
					+ "contact_address,contact_state_code,token,service_qty" + " FROM invoice where uuid='" + uuid
					+ "'";

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
			log.info("getInvoiceDetails" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getInvoiceDetails" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getInvoiceDetails(String invoice, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String queryselect = "SELECT uuid,invoice_no,date,company,gstin,address,service_name,"
					+ "total_amount,country,state,city,state_code,status,invoice_type,"
					+ "contact_name,contact_pan,contact_country,contact_state,contact_city,"
					+ "contact_address,contact_state_code" + " FROM invoice where invoice_no='" + invoice
					+ "' and token='" + token + "' and status='1'";

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
			log.info("getInvoiceDetails" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getInvoiceDetails" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getCancelledInvoiceDetails(String invoice, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String queryselect = "SELECT unbill_no,invoice_no,company,gstin,address,service_name,"
					+ "total_amount,country,state,city,state_code,client_uuid,contact_uuid,"
					+ "contact_name,contact_pan,contact_country,contact_state,contact_city,"
					+ "contact_address,contact_state_code,service_qty" + " FROM invoice where invoice_no='" + invoice
					+ "' and token='" + token + "' limit 1";
//		System.out.println(queryselect);
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
			log.info("getCancelledInvoiceDetails" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getCancelledInvoiceDetails" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static boolean updateEstimateCompany(String companykey, String companyName, String token) {
		// TODO Auto-generated method stub
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "UPDATE estimatesalectrl SET escompany=? WHERE esclientrefid=? and estoken=?";
			ps = con.prepareStatement(query);
			ps.setString(1, companyName);
			ps.setString(2, companykey);
			ps.setString(3, token);

			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.updateEstimateCompany " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.updateEstimateCompany " + sqle.getMessage());
			}
		}
		return status;
	}

	public static String[][] getEstimateDocument(String estKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String queryselect = "SELECT sdrefid,sduploaddocname,sddocname,sduploaddate FROM salesdocumentctrl where sdestkey='"
					+ estKey + "' and sduploadby='Client' and sdtokenno='" + token + "' order by sdid desc";
//		System.out.println(queryselect);
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
			log.info("getEstimateDocument" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getEstimateDocument" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String getSalesKeyByEstimateKey(String estKey, String uavalidtokenno) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT msrefid FROM managesalesctrl where msestkey='" + estKey + "' and mstoken='"
					+ uavalidtokenno + "'";
//		System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getSalesKeyByEstimateKey" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getSalesKeyByEstimateKey" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String isPaymentApproved(String estimateno, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "No";
		try {
			String queryselect = "SELECT sid FROM salesestimatepayment where sestsaleno='" + estimateno
					+ "' and stransactionstatus='1' and stokenno='" + token + "' limit 1";
//		System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = "Yes";
			}
		} catch (Exception e) {
			log.info("isPaymentApproved" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("isPaymentApproved" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static boolean isEstimateInvoiced(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		boolean getinfo = false;
		try {
			String queryselect = "SELECT esstatus FROM estimatesalectrl where esrefid='" + salesKey + "' and estoken='"
					+ token + "'";
//		System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				if (rset.getString(1).equalsIgnoreCase("Invoiced"))
					getinfo = true;
			}
		} catch (Exception e) {
			log.info("isEstimateInvoiced" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("isEstimateInvoiced" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static List<String> getEstimatePriceType(String estKey, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		List<String> newsdata = null;
		StringBuffer VCQUERY = null;
		try {
			getacces_con = DbCon.getCon("", "", "");

			VCQUERY = new StringBuffer("SELECT sppricetype FROM salesproductprice where spessalerefid='" + estKey
					+ "' and sptokenno='" + token + "'");
//			System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
			rsGCD = stmnt.executeQuery();
			rsGCD.last();
			int row = rsGCD.getRow();
//		System.out.println("total row==="+row);
			rsGCD.beforeFirst();
			newsdata = new ArrayList<>(row);
			while (rsGCD != null && rsGCD.next()) {
				newsdata.add(rsGCD.getString(1));
			}
		} catch (Exception e) {
			log.info("EnquiryACT.getEstimatePriceType " + e.getMessage());
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
				log.info("EnquiryACT.getEstimatePriceType " + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String getProductKeyByTypeAndName(String category, String name, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo = "NA";
		try {
			String queryselect = "SELECT prefid FROM product_master where ptype='" + category + "' and pname='" + name
					+ "' and ptokenno='" + token + "'";
//		System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getString(1);
			}
		} catch (Exception e) {
			log.info("getProductKeyByTypeAndName" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getProductKeyByTypeAndName" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static boolean saveCompliance(String key, String productName, String serviceName, String intendedUse,
			String testingFee, String governmentFee, String token, String uaid) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement("insert into compliance(uuid,product_name,service_name,"
					+ "indended_use,testing_fee,government_fee,created_date,created_by_uid,"
					+ "token) values(?,?,?,?,?,?,?,?,?)");

			ps.setString(1, key);
			ps.setString(2, productName);
			ps.setString(3, serviceName);
			ps.setString(4, intendedUse);
			ps.setString(5, testingFee);
			ps.setString(6, governmentFee);
			ps.setDate(7, new java.sql.Date(System.currentTimeMillis()));
			ps.setString(8, uaid);
			ps.setString(9, token);

			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			e.printStackTrace();
			log.info("saveCompliance()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error Closing SQL saveCompliance() Objects \n" + sqle.getMessage());
			}
		}
		return status;

	}

	public static int countCompliance(String product, String service, String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		int newsdata = 0;

		try {
			getacces_con = DbCon.getCon("", "", "");

			StringBuffer VCQUERY = new StringBuffer("SELECT count(id) FROM compliance where token= '" + token + "'");

			if (!product.equalsIgnoreCase("NA"))
				VCQUERY.append("and product_name like '%" + product + "%' or indended_use like '%" + product + "%' ");
			if (!service.equalsIgnoreCase("NA"))
				VCQUERY.append("and service_name like '%" + service + "%' ");

//		System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
			rsGCD = stmnt.executeQuery();

			if (rsGCD != null && rsGCD.next()) {
				newsdata = rsGCD.getInt(1);
			}
		} catch (Exception e) {
			log.info("Error in countCompliance method \n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects countCompliance:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getCompliance(String product, String service, int page, int rows, String token) {
		// Initialing variables
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;

		try {
			getacces_con = DbCon.getCon("", "", "");

			StringBuffer VCQUERY = new StringBuffer("SELECT * FROM compliance where token= '" + token + "'");

			if (!product.equalsIgnoreCase("NA"))
				VCQUERY.append("and product_name like '%" + product + "%' or indended_use like '%" + product + "%' ");
			if (!service.equalsIgnoreCase("NA"))
				VCQUERY.append("and service_name like '%" + service + "%' ");

			VCQUERY.append(" order by id limit " + ((page - 1) * rows) + "," + rows);

//		System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("Error in getCompliance method \n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getCompliance:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static boolean updateCompliance(String ckey, String productName, String serviceName, String intendedUse,
			String testingFee, String governmentFee, String token, String uaid) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "UPDATE compliance SET product_name=?,service_name=?,indended_use=?,"
					+ "testing_fee=?,government_fee=?,created_by_uid=? where uuid=? and token=?";
			ps = con.prepareStatement(query);
			ps.setString(1, productName);
			ps.setString(2, serviceName);
			ps.setString(3, intendedUse);
			ps.setString(4, testingFee);
			ps.setString(5, governmentFee);
			ps.setString(6, uaid);
			ps.setString(7, ckey);
			ps.setString(8, token);

			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.updateCompliance " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.updateCompliance " + sqle.getMessage());
			}
		}
		return status;
	}

	public static String[][] getComplianceByKey(String ckey, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;

		try {
			getacces_con = DbCon.getCon("", "", "");

			StringBuffer VCQUERY = new StringBuffer(
					"SELECT * FROM compliance where uuid='" + ckey + "' and token='" + token + "'");

			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("Error in getCompliance method \n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getCompliance:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String getPaymentPersonName(String unbillno, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String newsdata = "NA";
		try {
			String queryselect = "select u.uaname from user_account u where "
					+ "exists(select s.sid from salesestimatepayment s where u.uaid=s.saddedbyuid and "
					+ "exists(select i.id from invoice i where s.sunbill_no=i.unbill_no and i.unbill_no='" + unbillno
					+ "')) and u.uavalidtokenno='" + token + "'";
//		System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rsGCD = ps.executeQuery();

			while (rsGCD != null && rsGCD.next()) {
				newsdata = rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("getSalesKey" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getSalesKey" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static void saveEstimateNotes(String estNKey, String estimateKey, String notes, String userInChat,
			String userUid, String addedby, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement("insert into estimate_notes(uuid,estimate_key,notes,"
					+ "users_uaid,login_uaid,addedby,token) values(?,?,?,?,?,?,?)");

			ps.setString(1, estNKey);
			ps.setString(2, estimateKey);
			ps.setString(3, notes);
			ps.setString(4, userInChat);
			ps.setString(5, userUid);
			ps.setString(6, addedby);
			ps.setString(7, token);

			ps.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
			log.info("saveEstimateNotes()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error Closing SQL saveEstimateNotes() Objects \n" + sqle.getMessage());
			}
		}
	}

	public static void sendEstimateNotes(String notes, String userInChat, String userUid, String addedby,
			String salesKey, String estimateKey, String token) {
		// TODO Auto-generated method stub
		try {

			String conName = "NA";
			String conMobile = "NA";
			String conEmail = "NA";
			String email = "NA";
			String uaid = "NA";
			String contactKey = getEstimateContactKey(estimateKey, token);

			if (contactKey != null) {
				String contact[][] = TaskMaster_ACT.getAllSalesContacts(contactKey, token);
				if (contact != null && contact.length > 0) {
					conName = contact[0][0];
					conMobile = contact[0][2];
					conEmail = contact[0][1];
				}
			}
//	System.out.println(conName+"/"+conMobile+"/"+conEmail);
			String today = DateUtil.getCurrentDateIndianFormat1();
			// getting current time
			String Time = DateUtil.getCurrentTime();

			String salesData[] = TaskMaster_ACT.getSalesData(salesKey, token);

			uaid = salesData[6];
			String sellerName = Usermaster_ACT.getLoginUserName(uaid, token);
			email = Usermaster_ACT.getUserEmail(uaid, token);
			// add chat thread
			String taskKey = RandomStringUtils.random(40, true, true);
			String subject = "Notes Written";
			String userName = Usermaster_ACT.getLoginUserName(userUid, token);
			String salesTaskKey = TaskMaster_ACT.getSalesTaskKey(salesKey, estimateKey, token);
			// set notification task
			TaskMaster_ACT.setTaskNotification(taskKey, salesKey, salesData[0], salesData[1], salesData[2], "Notes",
					"notes.png", conName, conMobile, conEmail, userUid, userName, today + " " + Time, subject, notes,
					addedby, token, "NA", "NA", "NA", "NA", salesTaskKey);

			// adding notification
			String nKey = RandomStringUtils.random(40, true, true);
			String message = "You have new note on unbill : " + salesData[2] + " by " + userName + " for "
					+ salesData[0] + "";
//	System.out.println(uaid+"  "+userUid);
			if (!uaid.equalsIgnoreCase("NA") && !userUid.equalsIgnoreCase(uaid))
				TaskMaster_ACT.addNotification(nKey, today, uaid, "2", "manage-sales.html?uuid=" + salesKey + "",
						message, token, userUid, "fas fa-tasks");

			if (userInChat != null && userInChat.length() > 0) {
				// add notification

				String message1 = "You have new note on unbill : " + salesData[2] + " by " + userName + " for "
						+ salesData[0] + "";
//		System.out.println(uaid+"  "+userUid);
				String x[] = userInChat.split(",");
				for (String uaid1 : x) {
					String nKey1 = RandomStringUtils.random(40, true, true);
					TaskMaster_ACT.addNotification(nKey1, today, uaid1, "2", "manage-sales.html?uuid=" + salesKey + "",
							message1, token, userUid, "fas fa-tasks");

					String user[] = Usermaster_ACT.findUserByUaid(Integer.parseInt(uaid1), token);

					String messageSender = "<table border=\"0\" style=\"margin:0 auto; min-width:700px;font-size:20px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">\r\n"
							+ "        <tbody><tr><td style=\"text-align: left ;background-color: #fff; padding: 15px 0; width: 50px\">\r\n"
							+ "                <a href=\"#\" target=\"_blank\">\r\n"
							+ "                <img src=\"https://www.corpseed.com/assets/img/logo.png\"></a>\r\n"
							+ "            </td></tr>\r\n" + "            <tr>\r\n"
							+ "              <td style=\"text-align: center;\">\r\n"
							+ "                <h1 style=\"font-size: 28px;line-height: 38px;\">Note From " + userName
							+ " On " + salesData[0] + "(" + salesData[2] + ")</h1>\r\n" + "              </td></tr>\r\n"
							+ "        <tr>\r\n" + "          <td style=\"padding:70px 0 20px;color: #353637;\">\r\n"
							+ "            Hi " + user[0] + ",</td></tr>" + "             <tr>"
							+ "                    <td style=\"padding: 10px 0;color: #353637;\"> \r\n"
							+ "                     <p>You have received an internal note from " + userName + " for "
							+ salesData[0] + " is as follow :</p>\r\n" + "                     <p>" + notes
							+ "</p><p>Please do the needful.</p>\r\n" + "                    </td></tr>  \r\n"
							+ "             <tr><td style=\"text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;\">\r\n"
							+ "                <p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>\r\n"
							+ "    </td></tr> \r\n" + "    </tbody></table>";
					if (!user[1].equalsIgnoreCase("NA"))
						Enquiry_ACT.saveEmail(user[1], "empty",
								"Note From " + userName + " On " + salesData[0] + "(" + salesData[2] + ")",
								messageSender, 2, token);
				}

			}

			String message1 = "<table border=\"0\" style=\"margin:0 auto; min-width:700px;font-size:20px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">\r\n"
					+ "        <tbody><tr><td style=\"text-align: left ;background-color: #fff; padding: 15px 0; width: 50px\">\r\n"
					+ "                <a href=\"#\" target=\"_blank\">\r\n"
					+ "                <img src=\"https://www.corpseed.com/assets/img/logo.png\"></a>\r\n"
					+ "            </td></tr>\r\n" + "            <tr>\r\n"
					+ "              <td style=\"text-align: center;\">\r\n"
					+ "                <h1 style=\"font-size: 28px;line-height: 38px;\">Note From " + userName + " On "
					+ salesData[0] + "(" + salesData[2] + ")</h1>\r\n" + "              </td></tr>\r\n"
					+ "        <tr>\r\n" + "          <td style=\"padding:70px 0 20px;color: #353637;\">\r\n"
					+ "            Hi " + sellerName + ",</td></tr>" + "             <tr>"
					+ "                    <td style=\"padding: 10px 0;color: #353637;\"> \r\n"
					+ "                     <p>You have received an internal note from " + userName + " for "
					+ salesData[0] + " is as follow :</p>\r\n" + "                     <p>" + notes
					+ "</p><p>Please do the needful.</p>\r\n" + "                    </td></tr>  \r\n"
					+ "             <tr><td style=\"text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;\">\r\n"
					+ "                <p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>\r\n"
					+ "    </td></tr> \r\n" + "    </tbody></table>";
			if (!email.equalsIgnoreCase("NA") && !userUid.equalsIgnoreCase(uaid))
				Enquiry_ACT.saveEmail(email, "empty",
						"Note From " + userName + " On " + salesData[0] + "(" + salesData[2] + ")", message1, 2, token);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static String[][] getEstimateNotesByEstimateKey(String estimate_key, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;

		try {
			getacces_con = DbCon.getCon("", "", "");

			StringBuffer VCQUERY = new StringBuffer(
					"SELECT notes,users_uaid,login_uaid,addedby,uuid FROM estimate_notes where estimate_key='"
							+ estimate_key + "' and token='" + token + "' and status='2'");
//		System.out.println(VCQUERY);
			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("Error in getEstimateNotesByEstimateKey method \n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getEstimateNotesByEstimateKey:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static boolean updateEstimateNotesStatus(String uuid, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "UPDATE estimate_notes SET status=? WHERE uuid=? and token=?";
			ps = con.prepareStatement(query);
			ps.setInt(1, 1);
			ps.setString(2, uuid);
			ps.setString(3, token);

			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			e.printStackTrace();
			log.info("EnquiryACT.updateEstimateNotesStatus " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.updateEstimateNotesStatus " + sqle.getMessage());
			}
		}
		return status;
	}

	public static String getEstimateNoFromPayment(String estpaymentKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String newsdata = "NA";
		try {
			String queryselect = "select sestsaleno from salesestimatepayment where srefid='" + estpaymentKey
					+ "' and stokenno='" + token + "'";
//		System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rsGCD = ps.executeQuery();

			while (rsGCD != null && rsGCD.next()) {
				newsdata = rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("getEstimateNoFromPayment" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getEstimateNoFromPayment" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static boolean updateEstimateStatus(String action, String estSaleNo, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean flag = false;
		try {
			String query = "UPDATE estimatesalectrl SET esstatus='" + action + "' WHERE essaleno='" + estSaleNo
					+ "' and esstatus!='Invoiced' and estoken='" + token + "'";
			ps = con.prepareStatement(query);
			int k = ps.executeUpdate();
			if (k > 0)
				flag = true;
		} catch (Exception e) {
			log.info("EnquiryACT.updateEstimateStatus " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.updateEstimateStatus " + sqle.getMessage());
			}
		}

		return flag;
	}

	public static void updateUnbilledStatus(String action, String unbillKey, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "UPDATE salesestimatepayment SET sarchivestatus='" + action + "' WHERE srefid='" + unbillKey
					+ "' and stokenno='" + token + "'";
//		System.out.println(query);
			ps = con.prepareStatement(query);
			ps.execute();
		} catch (Exception e) {
			log.info("EnquiryACT.updateUnbilledStatus " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.updateUnbilledStatus " + sqle.getMessage());
			}
		}
	}

	public static String[][] getAllDraftSaleByDate(String date7Daybefore, String salesPersonId) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;

		try {
			getacces_con = DbCon.getCon("", "", "");

			StringBuffer VCQUERY = new StringBuffer(
					"SELECT esregdate,essaleno,esprodname,esprodqty,escontactrefid,escompany,essoldbyid,estoken,sales_type FROM estimatesalectrl "
							+ "where esstatus='Draft' and str_to_date(esregdate,'%d-%m-%Y')<'" + date7Daybefore + "'");
			if (!salesPersonId.equalsIgnoreCase("NA"))
				VCQUERY.append(" and essoldbyid='" + salesPersonId + "'");

			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("Error in getAllDraftSaleByDate method \n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllDraftSaleByDate:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllDraftSalePersonByDate(String date7Daybefore) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;

		try {
			getacces_con = DbCon.getCon("", "", "");

			StringBuffer VCQUERY = new StringBuffer(
					"SELECT essoldbyid,estoken FROM estimatesalectrl where esstatus='Draft' and str_to_date(esregdate,'%d-%m-%Y')<='"
							+ date7Daybefore + "' group by essoldbyid");

			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("Error in getAllDraftSalePersonByDate method \n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllDraftSalePersonByDate:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getAllDraftSaleByDateForManager(String date7Daybefore, String teamKey,
			String TeamLeaderUid) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;

		try {
			getacces_con = DbCon.getCon("", "", "");

			StringBuffer VCQUERY = new StringBuffer("select esregdate,essaleno,esprodname,esprodqty,"
					+ "escontactrefid,escompany,essoldbyid,estoken from estimatesalectrl where exists("
					+ "SELECT tmid FROM manageteammemberctrl where tmteamrefid='" + teamKey + "' "
					+ "and tmuseruid=essoldbyid or essoldbyid='" + TeamLeaderUid + "')"
					+ "and esstatus='Draft' and str_to_date(esregdate,'%d-%m-%Y')<='" + date7Daybefore + "'");

			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("Error in getAllDraftSaleByDate method \n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getAllDraftSaleByDate:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] fetchAllCancelReport(String invoice, String type, String token) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;

		try {
			getacces_con = DbCon.getCon("", "", "");

			StringBuffer VCQUERY = new StringBuffer("select * from cancel_sale where ");
			if (type.equalsIgnoreCase("estimate"))
				VCQUERY.append("estimate_invoice='" + invoice + "' ");
			else if (type.equalsIgnoreCase("sales"))
				VCQUERY.append("sales_invoice='" + invoice + "' ");
			VCQUERY.append(" and token='" + token + "'");

			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("Error in fetchAllCancelReport method \n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects fetchAllCancelReport:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String getSalesInvoiceHeading(String invoice, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String newsdata = "";
		try {
			String queryselect = "SELECT msproductname FROM managesalesctrl where msinvoiceno='" + invoice
					+ "' and mstoken='" + token + "'";
//		System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rsGCD = ps.executeQuery();
			int i = 0;
			while (rsGCD != null && rsGCD.next()) {
				if (i == 0)
					newsdata = rsGCD.getString(1);
				else
					newsdata += " + " + rsGCD.getString(1);
				i++;
			}
		} catch (Exception e) {
			log.info("getSalesInvoiceHeading" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getSalesInvoiceHeading" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String getEstimateInvoiceHeading(String invoice, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String newsdata = "";
		try {
			String queryselect = "SELECT esprodname FROM estimatesalectrl where essaleno='" + invoice
					+ "' and estoken='" + token + "'";
//		System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rsGCD = ps.executeQuery();
			int i = 0;
			while (rsGCD != null && rsGCD.next()) {
				if (i == 0)
					newsdata = rsGCD.getString(1);
				else
					newsdata += " + " + rsGCD.getString(1);
				i++;
			}
		} catch (Exception e) {
			log.info("getEstimateInvoiceHeading" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("getEstimateInvoiceHeading" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static int findSalesIdByKey(String saleskey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		int newsdata = 0;
		try {
			String queryselect = "SELECT msid FROM managesalesctrl where msrefid='" + saleskey + "' and mstoken='"
					+ token + "'";
//		System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rsGCD = ps.executeQuery();
			if (rsGCD.next())
				newsdata = rsGCD.getInt(1);

		} catch (Exception e) {
			log.info("findSalesIdByKey" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("findSalesIdByKey" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static boolean isContactRefUsed(String crefid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		boolean getinfo = false;
		try {
			String queryselect = "SELECT cbid FROM contactboxctrl where cbcontactrefid='" + crefid + "' and cbtokenno='"
					+ token + "'";
//		System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = true;
			}
		} catch (Exception e) {
			log.info("isContactRefUsed" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("isContactRefUsed" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static boolean findSalesUserMapping(String salesId, String uaid, String uavalidtokenno) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		boolean getinfo = false;
		try {
			String queryselect = "SELECT id FROM user_sales_info where user_id='" + uaid + "' and sales_id='" + salesId
					+ "' and token='" + uavalidtokenno + "' limit 1";
//		System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = true;
			}
		} catch (Exception e) {
			log.info("findSalesUserMapping" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("findSalesUserMapping" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static boolean findCompanyUserMapping(String companyId, String uaid, String uavalidtokenno) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		boolean getinfo = false;
		try {
			String queryselect = "SELECT id FROM client_user_info where user_id='" + uaid + "' and client_id='"
					+ companyId + "' and token='" + uavalidtokenno + "' limit 1";
//		System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = true;
			}
		} catch (Exception e) {
			log.info("findCompanyUserMapping" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("findCompanyUserMapping" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String findTeamKeyByUaid(String token, String department) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String newsdata = "NA";
		try {
			String queryselect = "SELECT mtrefid FROM manageteamctrl where mtdepartment='" + department
					+ "' and mttoken='" + token + "' limit 1";
//		System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rsGCD = ps.executeQuery();

			while (rsGCD != null && rsGCD.next()) {
				newsdata = rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("findTeamKeyByUaid" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("findTeamKeyByUaid" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] findTeamMembers(String teamKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String queryselect = "SELECT tmuseruid,tmusername FROM manageteammemberctrl where tmteamrefid='" + teamKey
					+ "' and tmtoken='" + token + "' and tmstatus='1'";
//		System.out.println(queryselect);
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
			log.info("findTeamMembers" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("findTeamMembers" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[] findSalesDocumentUser(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo[] = new String[2];
		try {
			String queryselect = "SELECT document_assign_uaid,document_assign_name FROM managesalesctrl where msrefid='"
					+ salesKey + "'" + " and mstoken='" + token + "' limit 1";
//		System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo[0] = rset.getString(1);
				getinfo[1] = rset.getString(2);
			}
		} catch (Exception e) {
			log.info("findSalesDocumentUser" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("findSalesDocumentUser" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String[] findConsultingSaleDetails(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo[] = new String[5];
		try {
			String queryselect = "SELECT c.consultation_type,c.renewal_value,c.renewal_type,c.renewal_end_date,u.uaname FROM consulting_sale c "
					+ "join user_account u on c.consultant_uaid=u.uaid where c.sales_key='" + salesKey
					+ "' and c.token='" + token + "' limit 1";
//		System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo[0] = rset.getString(1);
				getinfo[1] = rset.getString(2);
				getinfo[2] = rset.getString(3);
				getinfo[3] = rset.getString(4);
				getinfo[4] = rset.getString(5);
			}
		} catch (Exception e) {
			log.info("findConsultingSaleDetails" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("findConsultingSaleDetails" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static String[] findSalesTat(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		String getinfo[] = new String[2];
		try {
			String queryselect = "SELECT tat_value,tat_type FROM managesalesctrl where msrefid='" + salesKey + "'"
					+ " and mstoken='" + token + "' limit 1";
//		System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo[0] = rset.getString(1);
				getinfo[1] = rset.getString(2);
			}
		} catch (Exception e) {
			log.info("findSalesTat" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("findSalesTat" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static boolean saveConsultingSale(String estimateKey, String consultationType,
			String consultationRenewalValue, String consultationRenewalType, String consultationEndDate,
			String consultationFeeType, double price, String consultationHsn, double cgst, double sgst, double igst,
			double cgstprice, double sgstprice, double igstprice, double totalprice, String token, String today,
			String paymentDate, String consultantUaid) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement("insert into consulting_sale(estimate_key,consultation_type,renewal_value,"
					+ "renewal_type,renewal_end_date,fee_type,fee,hsn,cgst_percent,sgst_percent,"
					+ "igst_percent,cgst_amount,sgst_amount,igst_amount,total_amount,token,"
					+ "post_date,payment_date,consultant_uaid) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");

			ps.setString(1, estimateKey);
			ps.setString(2, consultationType);
			ps.setString(3, consultationRenewalValue);
			ps.setString(4, consultationRenewalType);
			ps.setString(5, consultationEndDate);
			ps.setString(6, consultationFeeType);
			ps.setDouble(7, price);
			ps.setString(8, consultationHsn);
			ps.setDouble(9, cgst);
			ps.setDouble(10, sgst);
			ps.setDouble(11, igst);
			ps.setDouble(12, cgstprice);
			ps.setDouble(13, sgstprice);
			ps.setDouble(14, igstprice);
			ps.setDouble(15, totalprice);
			ps.setString(16, token);
			ps.setString(17, today);
			ps.setString(18, paymentDate);
			ps.setString(19, consultantUaid);

			int k = ps.executeUpdate();
			if (k > 0)
				status = true;

		} catch (Exception e) {
			e.printStackTrace();
			log.info("saveConsultingSale()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error Closing SQL saveConsultingSale() Objects \n" + sqle.getMessage());
			}
		}
		return status;

	}

	public static String findSalesTypeBySalesKey(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String newsdata = "NA";
		try {
			String queryselect = "SELECT sales_type FROM managesalesctrl where msrefid='" + salesKey + "' and mstoken='"
					+ token + "'";
//		System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rsGCD = ps.executeQuery();

			while (rsGCD != null && rsGCD.next()) {
				newsdata = rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("findSalesTypeBySalesKey" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("findSalesTypeBySalesKey" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String findSalesTypeByKey(String refid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String newsdata = "NA";
		try {
			String queryselect = "SELECT sales_type FROM estimatesalectrl where esrefid='" + refid + "' and estoken='"
					+ token + "'";
//		System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rsGCD = ps.executeQuery();

			while (rsGCD != null && rsGCD.next()) {
				newsdata = rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("findSalesTypeByKey" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("findSalesTypeByKey" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static boolean updateSalesKeyInConsultingSale(String saleskey, String estKey, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "UPDATE consulting_sale SET sales_key=? WHERE estimate_key=? and token=?";
			ps = con.prepareStatement(query);
			ps.setString(1, saleskey);
			ps.setString(2, estKey);
			ps.setString(3, token);

			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.updateSalesKeyInConsultingSale " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.updateSalesKeyInConsultingSale " + sqle.getMessage());
			}
		}
		return status;
	}

	public static String[][] fetchConsultingService(String today) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			String queryselect = "SELECT c.id,c.estimate_key,c.renewal_value,c.renewal_type,c.fee_type,c.fee,c.hsn,c.cgst_percent,"
					+ "c.sgst_percent,c.igst_percent,c.cgst_amount,c.sgst_amount,c.igst_amount,c.total_amount,c.token,c.sales_key,"
					+ "c.post_date FROM consulting_sale c join estimatesalectrl e on "
					+ "c.estimate_key=e.esrefid where c.payment_date='" + today + "' and "
					+ "c.consultation_type='Renewal' and e.esstatus='Invoiced' and "
					+ "(c.renewal_end_date='NA' or c.renewal_end_date>='" + today + "')";
//		System.out.println(queryselect);
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
			log.info("fetchConsultingService" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("fetchConsultingService" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static boolean updatePaymentDate(String paymentDate, String id, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "UPDATE consulting_sale SET payment_date=? WHERE id=? and token=?";
			ps = con.prepareStatement(query);
			ps.setString(1, paymentDate);
			ps.setString(2, id);
			ps.setString(3, token);

			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.updatePaymentDate " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.updatePaymentDate " + sqle.getMessage());
			}
		}
		return status;
	}

	public static String[][] fetchEstimatePrice(String estKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			StringBuffer queryselect = new StringBuffer("SELECT spsalesid,sppricetype,spaddedby FROM salesproductprice "
					+ "where spessalerefid='" + estKey + "' and sptokenno='" + token + "' limit 1");

			ps = con.prepareStatement(queryselect.toString());
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
			log.info("fetchEstimatePrice" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("fetchEstimatePrice" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] fetchSalesPrice(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			StringBuffer queryselect = new StringBuffer("SELECT sppricetype,spaddedby FROM salespricectrl "
					+ "where spsalesrefid='" + salesKey + "' and sptokenno='" + token + "' limit 1");

			ps = con.prepareStatement(queryselect.toString());
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
			log.info("fetchSalesPrice" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("fetchSalesPrice" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] fetchAllSalesPriceDetails(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			StringBuffer queryselect = new StringBuffer("SELECT sppricetype,sphsncode,spprice,"
					+ "spcgstpercent,spsgstpercent,spigstpercent,spcgstprice,spsgstprice,spigstprice,"
					+ "(spcgstprice+spsgstprice+spigstprice+spprice) as total_amount FROM salespricectrl "
					+ "where spsalesrefid='" + salesKey + "' and sptokenno='" + token + "'");
//		System.out.println(queryselect);

			ps = con.prepareStatement(queryselect.toString());
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
			log.info("fetchAllSalesPrice" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("fetchAllSalesPrice" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] fetchAllSalesPrice(String salesKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;
		try {
			StringBuffer queryselect = new StringBuffer("SELECT sppricetype,sphsncode,spprice,"
					+ "(spcgstpercent+spsgstpercent+spigstpercent) as gst_percent,"
					+ "(spcgstprice+spsgstprice+spigstprice) as gst_price,"
					+ "(spcgstprice+spsgstprice+spigstprice+spprice) as total_amount FROM salespricectrl "
					+ "where spsalesrefid='" + salesKey + "' and sptokenno='" + token + "'");
//		System.out.println(queryselect);

			ps = con.prepareStatement(queryselect.toString());
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
			log.info("fetchAllSalesPrice" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("fetchAllSalesPrice" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static boolean updateConsultingSale(String estimateKey, String price, String cgstprice, String sgstprice,
			String igstprice, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			double totalAmount = Double.parseDouble(price) + Double.parseDouble(cgstprice)
					+ Double.parseDouble(sgstprice) + Double.parseDouble(igstprice);

			String query = "UPDATE consulting_sale SET fee=?,cgst_amount=?,sgst_amount=?,igst_amount=?,total_amount=? "
					+ "WHERE estimate_key=? and token=?";
			ps = con.prepareStatement(query);
			ps.setString(1, price);
			ps.setString(2, cgstprice);
			ps.setString(3, sgstprice);
			ps.setString(4, igstprice);
			ps.setDouble(5, totalAmount);
			ps.setString(6, estimateKey);
			ps.setString(7, token);

			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.updateConsultingSale " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.updateConsultingSale " + sqle.getMessage());
			}
		}
		return status;
	}

	public static String findConsultationFeeType(String estimateno, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String newsdata = "Consultation Fee";
		try {
			String queryselect = "SELECT fee_type FROM corpseedhrmdmng.consulting_sale c join estimatesalectrl e on "
					+ "c.estimate_key=e.esrefid where e.essaleno='" + estimateno + "' and e.estoken='" + token
					+ "' limit 1";
//		System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rsGCD = ps.executeQuery();

			while (rsGCD != null && rsGCD.next()) {
				newsdata = rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("findConsultationFeeType" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("findConsultationFeeType" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static boolean updateSalesEndDate(String salesKey, String token, String today) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "UPDATE consulting_sale SET renewal_end_date=? WHERE sales_key=? and token=?";
			ps = con.prepareStatement(query);
			ps.setString(1, today);
			ps.setString(2, salesKey);
			ps.setString(3, token);

			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			e.printStackTrace();
			log.info("EnquiryACT.updateSalesEndDate " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.updateSalesEndDate " + sqle.getMessage());
			}
		}
		return status;
	}

	public static String findConsultantUaid(String estimateKey, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String newsdata = "NA";
		try {
			String queryselect = "SELECT consultant_uaid FROM consulting_sale where estimate_key ='" + estimateKey
					+ "' and token='" + token + "' limit 1";
//		System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rsGCD = ps.executeQuery();

			while (rsGCD != null && rsGCD.next()) {
				newsdata = rsGCD.getString(1);
			}
		} catch (Exception e) {
			log.info("findConsultantUaid" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("findConsultantUaid" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static boolean updateSalesPayType(String estimateKey, String token) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
//		String queryselect = "SELECT epworkpaytype FROM estimateconvert_pricepercentage where "
//				+ "epsalesrefid='"+estimateKey+"' and eptokenno='"+token+"' limit 1";
			String query = "UPDATE estimateconvert_pricepercentage SET epworkpaytype=?,epworkpricepercentage='0' "
					+ "WHERE epsalesrefid=? and eptokenno=?";
			ps = con.prepareStatement(query);
			ps.setString(1, "Milestone Pay");
			ps.setString(2, estimateKey);
			ps.setString(3, token);

			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			e.printStackTrace();
			log.info("EnquiryACT.updateSalesPayType " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.updateSalesPayType " + sqle.getMessage());
			}
		}
		return status;
	}

	public static String[][] getInvoiceProductList(String invoiceKey) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;

		try {
			getacces_con = DbCon.getCon("", "", "");

			StringBuffer VCQUERY = new StringBuffer(
					"select refkey,service_name from invoice_product where invoice_key='" + invoiceKey + "'");

			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("Error in getInvoiceProductList method \n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getInvoiceProductList:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static String[][] getInvoiceProductPaymentList(String invoiceProductKey) {
		Connection getacces_con = null;
		PreparedStatement stmnt = null;
		ResultSet rsGCD = null;
		String[][] newsdata = null;

		try {
			getacces_con = DbCon.getCon("", "", "");

			StringBuffer VCQUERY = new StringBuffer(
					"select fee_type,price,hsn,(cgst_percent+sgst_percent+igst_percent) as gst_percent,(cgst_price+sgst_price+igst_price) as gst_price,total_price from invoice_product_items where invoice_product_key='"
							+ invoiceProductKey + "'");

			stmnt = getacces_con.prepareStatement(VCQUERY.toString());
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
			log.info("Error in getInvoiceProductPaymentList method \n" + e.getMessage());
		} finally {
			try {
				if (stmnt != null) {
					stmnt.close();
				}
				if (getacces_con != null) {
					getacces_con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException sqle) {
				sqle.printStackTrace();
				log.info("Error Closing SQL Objects getInvoiceProductPaymentList:\n" + sqle.getMessage());
			}
		}
		return newsdata;
	}

	public static boolean isEstimateHavePo(String salesno, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		boolean getinfo = false;
		try {
			String queryselect = "SELECT sid FROM salesestimatepayment where spaymtmode='PO' and sestsaleno='" + salesno
					+ "' and stransactionstatus!='3' and stokenno='" + token + "'";
//		System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = true;
			}
		} catch (Exception e) {
			log.info("isEstimateHavePo" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("isEstimateHavePo" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static int getPaymentIdByKey(String refid, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		int getinfo = 0;
		try {
			String queryselect = "SELECT sid FROM salesestimatepayment where spaymtmode='PO' and srefid='" + refid
					+ "' and stokenno='" + token + "'";
//		System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getInt(1);
			}
		} catch (Exception e) {
			log.info("getPaymentIdByKey" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getPaymentIdByKey" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static boolean saveTaxInvoiceReminder(int paymentId, boolean activeStatus) {
		PreparedStatement ps = null;
		boolean status = false;
		Connection con = DbCon.getCon("", "", "");
		try {
			ps = con.prepareStatement("insert into po_reminder(payment_id,active_status) values(?,?)");

			ps.setInt(1, paymentId);
			ps.setBoolean(2, activeStatus);

			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			e.printStackTrace();
			log.info("saveTaxInvoiceReminder()" + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("Error Closing SQL saveTaxInvoiceReminder() Objects \n" + sqle.getMessage());
			}
		}
		return status;
	}

	public static String[] fetchPaymentDetails(String refInvoice, String uavalidtokenno) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rsGCD = null;
		String[] newsdata = new String[4];
		try {
			String queryselect = "SELECT sid,po_validity,stransactionid,sapprovedby FROM salesestimatepayment where sinvoiceno='"
					+ refInvoice + "' and spaymtmode='PO' and stokenno='" + uavalidtokenno + "' limit 1";
//		System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rsGCD = ps.executeQuery();
			if (rsGCD != null && rsGCD.next()) {
				newsdata[0] = rsGCD.getString(1);
				newsdata[1] = rsGCD.getString(2);
				newsdata[2] = rsGCD.getString(3);
				newsdata[3] = rsGCD.getString(4);
			}

		} catch (Exception e) {
			log.info("fetchPaymentDetails" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rsGCD != null)
					rsGCD.close();
			} catch (SQLException e) {
				log.info("fetchPaymentDetails" + e.getMessage());
			}
		}
		return newsdata;
	}

	public static int getClientKeyByInvoiceNo(String invoiceNo) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		int getinfo = 0;
		try {
			String queryselect = "select h.super_user_uaid from hrmclient_reg h "
					+ "INNER JOIN managesalesctrl m on m.msclientrefid=h.cregclientrefid " + "where m.msinvoiceno='"
					+ invoiceNo + "' group by h.super_user_uaid";
//		System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getInt(1);
			}
		} catch (Exception e) {
			log.info("getClientKeyByInvoiceNo" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("getClientKeyByInvoiceNo" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static boolean updateNextReminderDate(int id, String reminderDate) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		boolean status = false;
		try {
			String query = "update po_reminder SET reminder_date=? WHERE id=?";
			ps = con.prepareStatement(query);
			ps.setString(1, reminderDate);
			ps.setInt(2, id);

			int k = ps.executeUpdate();
			if (k > 0)
				status = true;
		} catch (Exception e) {
			log.info("EnquiryACT.updateNextReminderDate " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.updateNextReminderDate " + sqle.getMessage());
			}
		}
		return status;
	}

	public static int findManageInvoiceId(String invoiceno, String token) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		int getinfo = 0;
		try {
			String queryselect = "SELECT id FROM manage_invoice where type='TAX' and ref_invoice='" + invoiceno
					+ "' and token='" + token + "'";
//		System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				getinfo = rset.getInt(1);
			}
		} catch (Exception e) {
			log.info("findManageInvoiceId" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("findManageInvoiceId" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static boolean isManageInvoiceDue(int manageInvoiceId) {
		Connection con = DbCon.getCon("", "", "");
		PreparedStatement ps = null;
		ResultSet rset = null;
		boolean getinfo = true;
		try {
			String queryselect = "SELECT due_amount FROM manage_invoice where id='" + manageInvoiceId + "'";
//		System.out.println(queryselect);
			ps = con.prepareStatement(queryselect);
			rset = ps.executeQuery();
			if (rset != null && rset.next()) {
				if (rset.getDouble(1) <= 1)
					getinfo = false;
			}
		} catch (Exception e) {
			log.info("isManageInvoiceDue" + e.getMessage());
		} finally {
			try {
				// closing sql objects
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
				if (rset != null)
					rset.close();
			} catch (SQLException e) {
				log.info("isManageInvoiceDue" + e.getMessage());
			}
		}
		return getinfo;
	}

	public static void disablePoReminder(int manageInvoiceId) {
		PreparedStatement ps = null;
		Connection con = DbCon.getCon("", "", "");
		try {
			String query = "update po_reminder SET active_status=? WHERE invoice_id=?";
			ps = con.prepareStatement(query);
			ps.setBoolean(1, false);
			ps.setInt(2, manageInvoiceId);
			ps.execute();

		} catch (Exception e) {
			log.info("EnquiryACT.disablePoReminder " + e.getMessage());
		} finally {
			try {
				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (SQLException sqle) {
				log.info("EnquiryACT.disablePoReminder " + sqle.getMessage());
			}
		}
	}

	public static boolean isMoreDetailsRequired(String moreDetailsServiceName, String salesno, String fromYear,
			String toYear, String portalNumber, String piboCategory, String creditType, String productCategory,
			String quantity, String comment) {
		String productName = Enquiry_ACT.getProductName(salesno, moreDetailsServiceName);
		if (moreDetailsServiceName.equalsIgnoreCase(productName)) {
			return isNullOrBlank(fromYear) || isNullOrBlank(toYear) || isNullOrBlank(portalNumber)
					|| isNullOrBlank(piboCategory) || isNullOrBlank(creditType) || isNullOrBlank(productCategory)
					|| isNullOrBlank(quantity) || isNullOrBlank(comment);
		}
		return false;
	}

	private static boolean isNullOrBlank(String str) {
		return str == null || str.trim().isEmpty();
	}

}