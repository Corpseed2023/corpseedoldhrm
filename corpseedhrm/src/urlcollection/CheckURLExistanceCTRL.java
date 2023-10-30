package urlcollection;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class CheckURLExistanceCTRL extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 375304994375008349L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		int start = Integer.parseInt(request.getParameter("start"));
		int end = Integer.parseInt(request.getParameter("end"));
		PrintWriter pw = response.getWriter();
		try {
			for(int i=start;i<end+1;i++) {
				String urlString = CollectionACT.getURL(i);

				int responseCode = 0;
				try {
					// for HTTP
					URL url = new URL("http://"+urlString);
					HttpURLConnection httpURLConnection = (HttpURLConnection) url.openConnection();
					httpURLConnection.setConnectTimeout(5000);
					httpURLConnection.setRequestMethod("HEAD");
					httpURLConnection.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2 (.NET CLR 3.5.30729)");
					responseCode = httpURLConnection.getResponseCode();
					Thread.sleep(3000);
				} catch (Exception e) {
				}

				// for HTTPS
				int responseCode2 = 0;
				try {
					URL url2 = new URL("https://"+urlString);
					HttpURLConnection httpURLConnection2 = (HttpURLConnection) url2.openConnection();
					httpURLConnection2.setConnectTimeout(5000);
					httpURLConnection2.setRequestMethod("HEAD");
					httpURLConnection2.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2 (.NET CLR 3.5.30729)");
					responseCode2 = httpURLConnection2.getResponseCode();
					Thread.sleep(3000);
				} catch (Exception e) {
				}

				if(responseCode==200||responseCode2==200) CollectionACT.updateURLStatus(i, "Alive");
				else CollectionACT.updateURLStatus(i, "Dead");
			}
			pw.write("success");
		}
		catch (Exception e) {
			pw.write(e.getMessage());
		}

	}

}
