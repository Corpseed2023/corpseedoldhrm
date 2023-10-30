package admin.coupon;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.enquiry.Enquiry_ACT;
import admin.task.TaskMaster_ACT;
import commons.DateUtil;

public class ApplyCouon_CTRL extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			double orderAmount=0;
			double discount=0;
			PrintWriter pw=response.getWriter();
			HttpSession session=request.getSession();
			String coupon=request.getParameter("coupon");
			if(coupon!=null)coupon=coupon.trim();
			
			String enquid=request.getParameter("enquid");
			if(enquid!=null)enquid=enquid.trim();
			
			String today=DateUtil.getCurrentDateIndianReverseFormat();
			String token = (String)session.getAttribute("uavalidtokenno");
			String couponData[][]=Coupon_ACT.getCouponByTitle(coupon,today,token);
			if(couponData!=null&&couponData.length>0) {
				String services[][]=Enquiry_ACT.getVirtualProductList(enquid,token);
				if(services!=null&&services.length>0) {
					for(int i=0;i<services.length;i++) {
						double serviceAmount=TaskMaster_ACT.getProductPrice(services[i][0], token);
						if(couponData[0][13].equals("selected")) {
							String productNo=TaskMaster_ACT.getProductNo(services[i][0], token);
							boolean flag=Coupon_ACT.isCouponServiceExist(productNo, couponData[i][1]);
							if(flag) {
								orderAmount+=(serviceAmount*Integer.parseInt(services[i][1]));
							}
						}else if(couponData[0][13].equals("all")){
							orderAmount+=serviceAmount;
						}
					}
				
				if(orderAmount<=0) {
					pw.write("not");
				}else { 
					if(couponData[0][4].equals("percentage")) {
					discount=(orderAmount*Double.parseDouble(couponData[0][3]))/100;
					//check max discount
					double maxDiscount=Double.parseDouble(couponData[0][11]);
					if(discount>maxDiscount)discount=maxDiscount;
					}else {
						discount=Double.parseDouble(couponData[0][3]);
					}
					pw.write(discount+"");
				}}
			}else {
				pw.write("invalid");
			}			
		}
		catch (Exception e) {
			e.printStackTrace();
		}

	}
}