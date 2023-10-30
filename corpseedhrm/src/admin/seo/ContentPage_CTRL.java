package admin.seo;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ContentPage_CTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			String amonpstuid = request.getParameter("seoid");
			
			String Assigned = "";
			String Deliver = "";
			String Remark = "";

			String view[][] = SeoOnPage_ACT.getView1(amonpstuid);
			
			Assigned = view[0][0];
			Deliver = view[0][1];
			Remark = view[0][2];

			PrintWriter pw = response.getWriter();
			pw.write(Assigned + "#" + Deliver + "#" + Remark);

		} catch (Exception e) {
			
		}

	}

}
