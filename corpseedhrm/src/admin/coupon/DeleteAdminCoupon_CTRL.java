package admin.coupon;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class DeleteAdminCoupon_CTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			HttpSession session=request.getSession();
			String token = (String)session.getAttribute("uavalidtokenno");
			String uuid=request.getParameter("uuid");
			if(uuid!=null)uuid=uuid.trim();
			
			Coupon_ACT.removeAllCouponServices(uuid);
			Coupon_ACT.deleteCoupon(uuid, token);
			
		}
		catch (Exception e) {
			e.printStackTrace();
		}

	}
}