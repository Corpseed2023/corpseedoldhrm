package admin.coupon;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class ExistCouponTitle_CTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			HttpSession session=request.getSession();
			String title=request.getParameter("title");
			if(title!=null)title=title.trim();
			
			String id=request.getParameter("id");
			if(id!=null)id=id.trim();
			
			String token = (String)session.getAttribute("uavalidtokenno");
			boolean flag=false;
			PrintWriter pw=response.getWriter();
			if(id.equals("0")) {
				flag=Coupon_ACT.isCouponTitleExist(title,token);
			}else {
				flag=Coupon_ACT.isCouponTitleExist(title,id,token);
			}
			if(flag)pw.write("pass");
			else pw.write("fail");
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
	}
}