package admin.report;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import commons.DbCon;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@SuppressWarnings("serial")
public class getdates extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		JSONArray cellarray = new JSONArray();
		JSONObject cellobj = null;
		JSONObject jo = new JSONObject();
		String pid = request.getParameter("pid").trim();
		try {
			Connection con = DbCon.getCon("", "", "");
			Statement stmt = con.createStatement();
			ResultSet rs = stmt.executeQuery("select distinct rkdate from report_keywords where rkpuid = '"+pid+"' order by rkuid desc limit 5");

			while (rs.next()) {
				cellobj = new JSONObject();
				cellobj.put("rkdate", rs.getString(1));
				cellarray.add(cellobj);
			}
			jo.put("arrayName", cellarray);
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");
			response.getWriter().write(jo.toString());
			
			if(stmt!=null) stmt.close();
			if(con!=null) con.close();
			if(rs!=null) rs.close();
		} catch (Exception e) {
		}
	}

}
