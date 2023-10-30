<%@ include file="../../madministrator/checkvalid_user.jsp"%>
<%
	boolean CD00 = false;
	boolean PL00 = false;
	boolean CB00 = false;
	boolean CSR00 = false;
	boolean MA00 = false;

	if (euaValidForAccess != null) {
		String[] getempaccessesL = euaValidForAccess.split("#");
		for (int ur = 0; ur < getempaccessesL.length; ur++) {
			if (getempaccessesL[ur].equalsIgnoreCase("CD00")) {
				CD00 = true;
			}
			else if (getempaccessesL[ur].equalsIgnoreCase("PL00")) {
				PL00 = true;
			}
			else if (getempaccessesL[ur].equalsIgnoreCase("CB00")) {
				CB00 = true;
			}
			else if (getempaccessesL[ur].equalsIgnoreCase("CSR00")) {
				CSR00 = true;
			}
			else if (getempaccessesL[ur].equalsIgnoreCase("MA00")) {
				MA00 = true;
			}
		}
	}

	String login = (String) session.getAttribute("loginuID");
%>
<div id="header">
	<div class="header">
		<div class="row">
			<div class="col-md-12 col-sm-12 col-xs-12">
				<div class="top-header">&nbsp;</div>
			</div>
		</div>
		<div class="row">
			<div class="col-md-3 col-sm-3 col-xs-12">
				<div class="logo1">
					<a href=""><img	src="https://software.redexweb.co.uk/erpcrmhrm/staticresources/images/corpseed-logo.png"></a>
				</div>
			</div>
			<div class="col-md-9 col-sm-9 col-xs-12">
				<div class="col-md-12 col-sm-12 col-xs-12">
					<div class="row">
						<div class="header-nav">
							<nav class="main-nav main-nav3">
								<ul class="main-menu">
									<li><a
										href="<%=request.getContextPath()%>/client-dashboard.html">Dashboard</a></li>
									<% if(CD00){ %><li><a
										href="<%=request.getContextPath()%>/company-details.html">Company
											Details</a></li>
											<% } %>
											<% if (PL00){ %>
									<li><a
										href="<%=request.getContextPath()%>/project-list.html">Project
											List</a></li><% } %>
											<% if (CB00){ %>
									<li><a
										href="<%=request.getContextPath()%>/client-billing.html">Billings</a></li>
										<% } %>
									<%
										if (CSR00) {
									%><li><a
										href="<%=request.getContextPath()%>/client-seo-report.html">Report</a></li>
									<%
										}
									%>
									<%
										if (MA00) {
									%>
									<li><a href="<%=request.getContextPath()%>/logout.html">Logout</a></li>
									<%
										}
									%>
								</ul>
								<div class="mobile-menu">
									<a href="#" class="show-menu"><span
										class="lnr lnr-indent-decrease"></span></a> <a href="#"
										class="hide-menu"><span class="lnr lnr-indent-increase"></span></a>
								</div>
							</nav>
							<!-- End Main Nav -->
						</div>
					</div>
					<!-- End Main Nav -->
				</div>
			</div>
		</div>
	</div>
</div>