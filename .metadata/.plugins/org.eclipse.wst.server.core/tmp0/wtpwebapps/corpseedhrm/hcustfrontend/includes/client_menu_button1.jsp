<nav class="navbar navbar-expand-lg">
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#basicExampleNav"
    aria-controls="basicExampleNav" aria-expanded="false" aria-label="Toggle navigation">
    <span><i class="fas fa-bars text-white"></i></span>
  </button>
<div class="collapse navbar-collapse menu" id="basicExampleNav">
<%
String url = request.getParameter("uid");
%>

<ul>
  <li <%if(url.equalsIgnoreCase("client_dashboard.html")){ %> class="active"<%} %>><a href="<%=request.getContextPath() %>/client_dashboard.html">Dashboard</a></li>
  <li <%if(url.equalsIgnoreCase("client_inbox.html")){ %> class="active"<%} %>><a href="<%=request.getContextPath() %>/client_inbox.html">Inbox</a></li>
  <li <%if(url.equalsIgnoreCase("client_orders.html")){ %> class="active"<%} %>><a href="<%=request.getContextPath() %>/client_orders.html">Orders</a></li>
  <li <%if(url.equalsIgnoreCase("client_documents.html")){ %> class="active"<%} %>><a href="<%=request.getContextPath() %>/client_documents.html">Documents</a></li>
  <li <%if(url.equalsIgnoreCase("client_payments.html")){ %> class="active"<%} %>><a href="<%=request.getContextPath() %>/client_payments.html">Payments</a></li>
</ul>
</div>
</nav>