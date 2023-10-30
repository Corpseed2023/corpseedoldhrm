package admin.report;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@SuppressWarnings("serial")
public class UpdateReportCTRL extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String type=request.getParameter("type").trim();
		String id=request.getParameter("id").trim();
		String newvalue=request.getParameter("newvalue").trim();

		if(type.equals("keyword")) type="rkkey";
		else if(type.equals("targeturl")) type="rktarget";

		Report_ACT.updateReport(type, newvalue, id);

	}

}
