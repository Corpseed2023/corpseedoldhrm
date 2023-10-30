package admin.task;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class DeleteProduct_CTRL extends HttpServlet {
	
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try
		{
			HttpSession session=request.getSession();
			String token=(String)session.getAttribute("uavalidtokenno");
			String prodKey=request.getParameter("prodKey");		
					
			if(prodKey!=null&&!prodKey.equalsIgnoreCase("NA")) {
				prodKey=prodKey.trim();
				//deleting products document
				TaskMaster_ACT.deleteProductDocument(prodKey,token);
				//deleting product's milestones
				TaskMaster_ACT.deleteProductMilestones(prodKey,token);
				//deleting product's price
				TaskMaster_ACT.deleteProductPrice(prodKey,token);
				//deleting product
				TaskMaster_ACT.deleleProduct(prodKey,token);
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}

	}
}
