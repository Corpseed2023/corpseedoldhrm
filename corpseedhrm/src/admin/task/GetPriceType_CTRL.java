package admin.task;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.enquiry.Enquiry_ACT;

public class GetPriceType_CTRL extends HttpServlet {

	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			
			PrintWriter pw=response.getWriter();
			
			HttpSession session = request.getSession(); 

			String token = (String)session.getAttribute("uavalidtokenno");
			
			String estKey=request.getParameter("estKey").trim();
						
			List<String> priceType=Enquiry_ACT.getEstimatePriceType(estKey,token);
			List<String> allList=new ArrayList<>(4);
			allList.add("Professional fees");
			allList.add("Government fees");
			allList.add("Miscellaneous fees");
			allList.add("Other fees");
			
			allList.removeAll(priceType);
						
			String payTypes="<option value=''>Select Price Type</option>";
			for (String s : allList)
				payTypes+="<option value='"+s+"'>"+s+"</option>";
				
					
		pw.write(payTypes);
			
		}catch (Exception e) {
			e.printStackTrace();
		}

	}

}