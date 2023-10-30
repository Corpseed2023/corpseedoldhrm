<footer class="clearfix">
<div class="rights">
<div class="container">
<div class="row">
<div class="col-md-12 col-sm-12 col-xs-12">
<div class="copyright">
<p>Copyright &copy;2021 Corpseed ITES Pvt Ltd - All rights reserved.</p>
</div>
</div>
</div>
</div>
</div>
</footer>
<div class="footer_menu menu_notification">
<%String urlpage1=request.getParameter("uid");
if(urlpage1==null||urlpage1.length()<=0)urlpage1="NA"; %>
<ul>
<li id="client_orders"<%if(urlpage1.equalsIgnoreCase("client_orders.html")){ %> class="active"<%}%>>
<small></small>
<a href="<%=request.getContextPath() %>/client_orders.html"><img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/all_orders.svg" alt=""><span>Your Orders</span></a>
</li>
<li id="client_inbox"<%if(urlpage1.equalsIgnoreCase("client_inbox.html")){ %> class="active"<%}%>>
<small></small>
<a href="<%=request.getContextPath() %>/client_inbox.html"><img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/chat.svg" alt=""><span>Chat</span></a>
</li>
<li>
<a href="<%=request.getContextPath() %>/client_dashboard.html" class="footer_logo"><img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/footer_logo1.png" alt=""></a>
</li>
<li id="client_documents"<%if(urlpage1.equalsIgnoreCase("client_documents.html")){ %> class="active"<%}%>>
<small></small>
<a href="<%=request.getContextPath() %>/client_documents.html"><img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/document.svg" alt=""><span>Doc Wallet</span></a>
</li>
<li id="my_profile"<%if(urlpage1.equalsIgnoreCase("my_profile.html")||urlpage1.equalsIgnoreCase("client_payments.html")||urlpage1.equalsIgnoreCase("all-notifications.html")){ %> class="active"<%}%>>
<small></small>
<a class="setting mtoggle" href="javascript:void(0)"><img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/profile.svg" alt=""><span>Profile</span></a>
</li>
</ul>
</div>
<!-- Update password Modal -->
  <div class="myModal modal fade" id="updatepass">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title"><i class="fas fa-lock"></i>Change Password</h4>  
          <button type="button" class="close" data-dismiss="modal">&times;</button>
        </div>
        <div class="modal-body">
		 <form action="javascript:void(0)">
		  <div class="row">
            <div class="form-group-pass col-md-12 col-sm-12 col-12">
			<label>Current Password</label>
            <input type="password" class="form-control" name="cpassword" id="Current_password"  placeholder="Enter Current Password*" required="required">
            </div>           
		  </div> 
		   <div class="row">
            <div class="form-group-pass col-md-12 col-sm-12 col-12">
			<label>New Password</label>
            <input type="password" class="form-control" name="npassword" id="New_Password" placeholder="Enter New Password*" required="required">
            <span class="show_psw active" onclick="myFunction('New_Password')">
									<i class="fa fa-eye-slash" style="font-size:15px;color:#006080"></i>
									</span>
            </div>
           
		  </div> 
		   <div class="row">
            <div class="form-group-pass col-md-12 col-sm-12 col-12">
			<label>Confirm Password</label>
            <input type="password" class="form-control" name="cfpassword" id="Confirm_Password" placeholder="Re-enter New Password*" required="required">
            <span class="show_psw active" onclick="myFunction('Confirm_Password')">
			<i class="fa fa-eye-slash" style="font-size:15px;color:#006080"></i>
			</span>
            </div>           
		  </div> 
		  </form>
          </div>
		 
        <div class="modal-footer justify-content-end">
          <button type="submit" class="btn btn-success" onclick="return validatePassword()" id="Update_Password">Update Password</button> 
          <button type="button" class="btn btn-outline-secondary" data-dismiss="modal">Cancel</button> 
        </div>
      </div>
    </div>
  </div>
<!-- End Update password Modal -->
<div class="alert-show" style="display: none;"><div class="alert-bg alert-striped" id="errorMsg"></div></div>
<div class="alert-show1" style="display: none;"><div class="alert-bg1 alert-striped" id="errorMsg1"></div></div>
<script src="<%=request.getContextPath() %>/hcustfrontend/fntdjs/5b8cdab0e6.js"></script>
<script src="<%=request.getContextPath() %>/hcustfrontend/fntdjs/jquery.min.js"></script>
<script src="<%=request.getContextPath() %>/hcustfrontend/fntdjs/jquery-ui.js"></script>
<script src="<%=request.getContextPath() %>/hcustfrontend/fntdjs/fakeLoader.min.js"></script>
<script src="<%=request.getContextPath() %>/hcustfrontend/fntdjs/bootstrap.min.js"></script>
<script src="<%=request.getContextPath() %>/hcustfrontend/fntdjs/wow.min.js"></script>
<script src="<%=request.getContextPath() %>/hcustfrontend/fntdjs/datepicker.js"></script>
<div class="processing_loader" style="display: none;"><div class="spin_box"></div></div>
<script src="<%=request.getContextPath() %>/hcustfrontend/fntdjs/jquery.timepicker.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/hcustfrontend/fntdjs/moment.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/hcustfrontend/fntdjs/daterangepicker.min.js"></script>
<script src="<%=request.getContextPath() %>/hcustfrontend/fntdjs/custom.js"></script>
<script src="<%=request.getContextPath() %>/hcustfrontend/fntdjs/fontawsome.js"></script>
<script src="<%=request.getContextPath() %>/hcustfrontend/fntdjs/globalscript.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/dataTables.buttons.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/jszip.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/pdfmake.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/vfs_fonts.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/buttons.html5.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/buttons.print.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/buttons.colVis.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/dataTables.select.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/dataTables.responsive.min.js"></script>
<script type="text/javascript">
if(window.history.replaceState){
window.history.replaceState( null, null, window.location.href );
}
new WOW().init();
</script>

<script type="text/javascript">
$(window).load(function() {
	  $(".processing_loader").fadeOut();
	});
function showLoader(){
   $(".processing_loader").fadeIn(); 
}
function hideLoader(){
   $(".processing_loader").fadeOut();  
}  
</script>