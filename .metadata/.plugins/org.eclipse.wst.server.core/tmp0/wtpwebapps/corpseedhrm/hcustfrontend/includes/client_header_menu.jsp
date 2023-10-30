<%@page import="hcustbackend.ClientACT"%>
<% 
String urlpage=request.getParameter("uid");
if(urlpage==null||urlpage.length()<=0)urlpage="NA";
if(!urlpage.equalsIgnoreCase("client_orders.html")){
	//removing client order action
	session.removeAttribute("ClientOrderDoAction");
	session.removeAttribute("ClientOrderSearchDoAction");
	session.removeAttribute("searchFromToDate");
	session.removeAttribute("searchOrderSorting");
	session.removeAttribute("orderPageLimit");
	session.removeAttribute("orderPageStart");
	session.removeAttribute("orderPageEnd");
}if(!urlpage.equalsIgnoreCase("client_inbox.html")){
	//removing client order action
	session.removeAttribute("ClientInboxDoAction");	
}
if(!urlpage.equalsIgnoreCase("client_documents.html")&&!urlpage.contains("viewalldocuments-")){
	//removing client doc action
	session.removeAttribute("doActionDocuments");
	session.removeAttribute("searchFolderDocuments");
	session.removeAttribute("searchFromToDocDate");
	session.removeAttribute("searchDocumentSorting");
	session.removeAttribute("clientDocumentPageLimit");
	session.removeAttribute("clientDocumentPageStart");
	session.removeAttribute("clientDocumentPageEnd");
}
if(!urlpage.contains("viewalldocuments-")){
	//removing client doc action
	session.removeAttribute("documentPageLimit");
	session.removeAttribute("documentPageStart");
	session.removeAttribute("documentPageEnd");
	session.removeAttribute("DocOfClientAgent");
}if(!urlpage.equalsIgnoreCase("all-notifications.html")){
	//removing client order action
	session.removeAttribute("notisearchFromToDate");
}if(!urlpage.equalsIgnoreCase("client_payments.html")){
	//removing client order action
	session.removeAttribute("ClientOrderSearchInvoice");
	session.removeAttribute("PaymentSearchFromToDate");
	session.removeAttribute("PaymentSearchOrderSorting");
	session.removeAttribute("paymentPageLimit");
	session.removeAttribute("paymentPageStart");
	session.removeAttribute("paymentPageEnd");
}
String userRole=(String)session.getAttribute("userRole");
if(userRole==null||userRole.length()<=0)userRole="NA";
String userName=(String)session.getAttribute("loginclname");
if(userName==null||userName.length()<=0)userName="NA";

String profileName=userName.substring(0,1);
if(userName.contains(" "))profileName+=userName.substring(userName.indexOf(" ")+1,userName.indexOf(" ")+2);
else profileName+=userName.substring(1,2); 
%>
<header class="header"> 
    <div class="container-fluid"> 
    <div class="container">
      <div class="row">
        <div class="col-sm-3 col-12"> 
        <div class="logo"> 
            <a href="<%=request.getContextPath() %>/client_dashboard.html" style="display: inline-block;"><img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/logo.png" alt=""></a>
        </div>       
        </div>          
        <div class="col-sm-9 col-12"> 
         <div class="top_menu text-right">
          <ul>		  
		  <li<%if(urlpage.equalsIgnoreCase("client_orders.html")){ %> class="active"<%}%>>            
            <a class="" href="<%=request.getContextPath() %>/client_orders.html"><i class="fa fa-archive menu_icon"></i><span>Your Orders</span></a>
          </li>
		  <li<%if(urlpage.equalsIgnoreCase("client_inbox.html")){ %> class="active"<%}%>>            
            <a class="" href="<%=request.getContextPath() %>/client_inbox.html"><i class="fas fa-comment-dots menu_icon" aria-hidden="true"></i><span>Chat</span></a>
          </li>
		  <li<%if(urlpage.equalsIgnoreCase("client_documents.html")||urlpage.contains("viewalldocuments-")){ %> class="active"<%}%>>            
            <a class="" href="<%=request.getContextPath() %>/client_documents.html"><i class="fa fa-file-alt menu_icon" aria-hidden="true"></i><span>Doc Wallet</span></a>
          </li>
		  <li<%if(urlpage.equalsIgnoreCase("client_payments.html")){ %> class="active"<%}%>>            
            <a class="" href="<%=request.getContextPath() %>/client_payments.html"><i class="fas fa-money-check menu_icon" aria-hidden="true"></i><span>Payments</span></a>
          </li>
		  <li<%if(urlpage.equalsIgnoreCase("my_profile.html")){ %> class="active"<%}%>>
          <a class="setting"  href="javascript:void(0)"><i class="fas fa-user menu_icon" aria-hidden="true"></i><span>Profile</span></a>  
        <ul class="sub-menu">
			<li><a href="<%=request.getContextPath() %>/client_dashboard.html">Dashboard</a></li>
			<li><a href="<%=request.getContextPath() %>/my_profile.html">My Profile</a></li>
<%-- 			<%if(userRole.equalsIgnoreCase("SUPER_USER")){ %><li><a href="<%=request.getContextPath() %>/permission.html">Permissions</a></li><%} %> --%>
			<li><a href="<%=request.getContextPath() %>/logout.html">LogOut</a></li> 
		  </ul> 
          </li>
          <%
          String clientloginuaid = (String) session.getAttribute("loginClintUaid");  
          
          String notificationtoken=(String)session.getAttribute("uavalidtokenno");          
          int notification=ClientACT.getTotalUnseenNotification(notificationtoken,clientloginuaid); 
          String notifications[][]=ClientACT.getAllClientNotification(notificationtoken,clientloginuaid);
          %>
          <li> 
          
            <a href="javascript:void(0)" class="notification" onclick="markAllAsReadNotification('<%=notification%>')"><i class="far fa-bell "><%if(notification>0){ %><span id="totalNotification"><%=notification%></span><%} %></i></a>
             <a href="<%=request.getContextPath() %>/all-notifications.html" class="notification_mobile" onclick="markAllAsReadNotification('<%=notification%>')"><i class="fa fa-bell "><%if(notification>0){ %><small><%=notification%></small><%} %></i><span  id="totalNotification_mobile">Notification</span></a>
            <div class="notification_box pullDown">                            
			  <ul>
			  <%if(notifications!=null&&notifications.length>0){
				  for(int i=0;i<notifications.length;i++){
				  %>             
              <li class="clearfix">
                <a href="javascript:void(0)" onclick="markAsReadNotification('<%=notifications[i][2] %>')">                
                <div class="clearfix pro_box text-left">
                    <div class="clearfix icon_box">
                     <i class="<%=notifications[i][4] %> icon-circle" aria-hidden="true"></i>
                    </div> 
                    <div class="clearfix pro_info"> 
                    <h6><%=notifications[i][3] %></h6>
                    <div class="clearfix date_box"><%=notifications[i][1] %></div>
                    </div>
                 </div>                 
                </a>
              </li>
              <%}}else{ %>
              <div class="text-center text-muted">No data found !!</div>
              <%} %>
			  </ul> 
			  <div class="text-center"><a href="<%=request.getContextPath() %>/all-notifications.html">View All &nbsp;<i class="fa fa-angle-right"></i></a></div>             
            </div>
          </li>
          </ul>
          </div>
        </div>
      </div>
    </div>
    </div>
</header>

<div class="sidebar">
<a href="#" class="backbtnn"><i class="fa fa-arrow-left"></i>
</a>
<div class="user_prof">
<div class="user_thumb"> 
<h3><%=userName %></h3>
<figure> <span class="prof_name"><%=profileName %></span> </figure>
</div>
<div class="user_detail">
<div class="clearfix"> 
<a href="#" data-toggle="modal" data-target="#updatepass">Update Password</a>
<!--  <span>Noida, India</span>   -->
  </div>
</div>
</div>
<div class="top_menu menu_notification">
 <ul>
<span>Settings</span>
<li><a href="<%=request.getContextPath() %>/my_profile.html"><img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/profile.svg" alt="">My Profile</a></li>
<%-- <li><a href="<%=request.getContextPath() %>/permission.html"><img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/permission2.png" alt="">Permissions</a></li> --%>
<li id="client_payments">           
  <a href="<%=request.getContextPath() %>/client_payments.html"><img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/payment.svg" alt="">Payments</a>
</li>
<li><a href="<%=request.getContextPath() %>/all-notifications.html"><img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/bell.svg" alt="">Notification</a></li>
 </ul></div>
<a href="<%=request.getContextPath() %>/logout.html" class="logoutbtnn"> Logout</a>
</div>