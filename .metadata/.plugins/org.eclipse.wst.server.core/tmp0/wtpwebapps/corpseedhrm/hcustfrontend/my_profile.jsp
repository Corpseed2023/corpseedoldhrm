<!doctype html>

<%@page import="admin.task.TaskMaster_ACT"%>
<%@page import="admin.master.Usermaster_ACT"%>
<%@page import="client_master.Clientmaster_ACT"%>
<%@page import="hcustbackend.ClientACT"%> 
<html lang="en">
<head>  
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<!-- for fakeloading -->
<%@ include file="includes/client-header-css.jsp" %>   
        
<title>Profile</title>
</head>
<body id="mySite">
<!-- main content starts -->
<%@ include file="includes/checkvalid_client.jsp" %>
<%
//get token no from session 
String token=(String)session.getAttribute("uavalidtokenno");
//String uaempid=(String)session.getAttribute("cluaempid");
String loginuaid = (String) session.getAttribute("loginuaid");
// String userRole=(String)session.getAttribute("userRole");
// if(userRole==null||userRole.length()<=0)userRole="NA";
int contactId=Usermaster_ACT.findContactIdByUaid(loginuaid,token);
		
String contact[][]=ClientACT.findContactById(contactId,token);

String country[][]=TaskMaster_ACT.getAllCountries();
String states[][]=TaskMaster_ACT.getStatesByCountryCode("IN");

%>
<section class="main clearfix">
  <%@ include file="includes/client_header_menu.jsp" %>   
<%String[][] company=Clientmaster_ACT.findAllAssignedCompany(loginuaid,token,userRole); %>
  <section class="main-order clearfix">
  <div class="container-fluid">
    <div class="container">
      <div class="row">
        <div class="col-12 p-0">
         
		<div class="box_bg box_minht box-orders">		
		<div class="row sticky_top">
		<div class="col-sm-12 profile mx-3">		
		<div class="pageheading py-2">
          <h2>Your Profile</h2>
          </div>
          <div class="info-dashboard mobile_menuu pb-0">
          <ul class="clearfix"><%if(!userRole.equalsIgnoreCase("SUPER_USER")){ %>
			<li class="bg_wht box_shadow" id="mobilepersonal1">
			<input type="radio" name="profile_details" id="mobilePersonal" value="1">
			<a>
			<div class="clearfix box_width80"> 
			<h3>Personal Details</h3>
			<p>Provide as much as little information as you'd like.</p> 
			</div>
			<div class="clearfix img_thumb">
			<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/personal_icon.png" alt=""> 
			</div>
			</a>
			</li><%} %>
			<li class="bg_wht box_shadow" id="mobilebusiness1">
			<input type="radio" name="profile_details" id="mobileBusiness" value="2" checked>
			<a class="active">
			<div class="clearfix box_width80">
			<h3>Business Details</h3>
			<p>Information we use for all of your corpseed products.</p>
			</div>
			<div class="clearfix img_thumb">
			<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/business_icon.png" alt="">
			</div>
			</a>
			</li> 
			</ul>
          </div>
          </div>
          </div>
          <div class="clearfix profile_page document_page"> 
           
		    <div class="row"> 
                <div class="center_box col-md-8 col-sm-10 col-12">  
                  
				  <div class="info-dashboard">
					<div class="profile_detail"> 
                    <div class="profile_thumb">
                      <figure> <span class="prof_name"><%=profileName %></span> </figure>
                    </div>
                    <div class="profile_info">
					<div class="clearfix">
                    <h3>Name</h3>
                  
					<p><%=userName %></p>
					  <a href="#" data-toggle="modal" data-target="#updatepass">Update Password</a>
                    </div>
					<div class="clearfix address">
					<i class="fas fa-map-marker-alt" aria-hidden="true" style="color: #eabb51;"></i>
					<span id="clientStateId"></span>  
					</div>
					</div>
                  </div> 
				    
				  <form method="post" onsubmit="return false;"> 		
					<div class="mt-4 profile clearfix">
					<div class="sys_menu">
					<ul class="clearfix"><%if(!userRole.equalsIgnoreCase("SUPER_USER")){ %>
					<li class="bg_wht box_shadow" id="personal1">
					<input type="radio" name="profile_details" id="Personal" value="1">
					<a class="active">
					<div class="clearfix box_width80"> 
					<h3>Personal Details</h3>
					<p>Provide as much as little information as you'd like.</p> 
					</div>
					<div class="clearfix img_thumb">
					<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/personal_icon.png" alt="personal"> 
					</div>
					</a>
					</li><%} %>
					<li class="bg_wht box_shadow" id="business1" <%if(userRole.equalsIgnoreCase("SUPER_USER")){ %>style="width:100%"<%} %>>
					<%if(!userRole.equalsIgnoreCase("SUPER_USER")){ %><input type="radio" name="profile_details" id="Business" value="2" checked><%} %>
					<a>
					<div class="clearfix box_width80">
					<h3>Business Details</h3>
					<p>Information we use for all of your corpseed products.</p>
					</div>
					<div class="clearfix img_thumb">
					<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/business_icon.png" alt="">
					</div>
					</a>
					</li> 
					</ul>
					</div>
					 <div class="row">
            <div class="col-sm-12 bg_whitee"><%if(!userRole.equalsIgnoreCase("SUPER_USER")){ %>
			<div class="clearfix mt-3 mb-3 personal_details" style="display:none"> 
			<div class="row">
			<div class="form-group-payment col-md-12 col-sm-12 col-12">
			<label>Organization Name</label>
            <input type="text" autocomplete="off" <%if(contact!=null&&contact.length>0&&!contact[0][4].equalsIgnoreCase("NA")){ %>value="<%=contact[0][4]%>"<%} %> class="form-control" name="organisationname" id="Profile_Organisation_Name" placeholder="Organisation name !!" required readonly="readonly"> 
            </div>
			</div>
            <div class="row">
            <div class="form-group-payment col-md-6 col-sm-6 col-12">
			<label>First Name</label>
            <input type="text" autocomplete="off" onblur="validateNamePopup('Profile_First_Name');validateValuePopup('Profile_First_Name');" <%if(contact!=null&&contact.length>0&&!contact[0][1].equalsIgnoreCase("NA")){ %>value="<%=contact[0][1]%>"<%} %> class="form-control" name="firstname" id="Profile_First_Name" placeholder="First name !!" required>
            </div>
            <div class="form-group-payment col-md-6 col-sm-6 col-12">
			<label>Last Name</label>
            <input type="text" autocomplete="off" onblur="validateNamePopup('Profile_Last_Name');validateValuePopup('Profile_Last_Name');" <%if(contact!=null&&contact.length>0&&!contact[0][2].equalsIgnoreCase("NA")){ %>value="<%=contact[0][2]%>"<%} %> class="form-control" name="lastname" id="Profile_Last_Name" placeholder="Last name !!" required>
            </div>
			</div>
			<div class="row">
            <div class="form-group-payment col-md-6 col-sm-6 col-12">
			<label>Email Id</label>
            <input type="email" onblur="verifyEmailIdPopup('Profile_Email_Id1')" onchange="isDuplicateClientDetails('profileemail','Profile_Email_Id1')" autocomplete="off" <%if(contact!=null&&contact.length>0&&!contact[0][3].equalsIgnoreCase("NA")){ %>value="<%=contact[0][3]%>"<%} %> class="form-control" name="emailid1" id="Profile_Email_Id1" placeholder="Email !!" required>
            </div>
            <div class="form-group-payment col-md-6 col-sm-6 col-12">
			<label>Email Second<small> (Optional)</small></label>
            <input type="email" onblur="verifyEmailIdPopup('Profile_Email_Id2')" onchange="isDuplicateClientDetails('profileemail','Profile_Email_Id2')" autocomplete="off" <%if(contact!=null&&contact.length>0&&!contact[0][5].equalsIgnoreCase("NA")){ %>value="<%=contact[0][5]%>"<%} %> class="form-control" name="emailid2" id="Profile_Email_Id2" placeholder="Email Second !!">
            </div>
			</div>
			<div class="row">			
            <div class="form-group-payment col-md-6 col-sm-6 col-12">
			<label>Mobile No.</label>
            <input type="text" maxlength="10" onchange="isDuplicateClientDetails('profilemobile','Profile_Mobile_No1')" onblur="validateMobilePopup('Profile_Mobile_No1')" autocomplete="off" <%if(contact!=null&&contact.length>0&&!contact[0][6].equalsIgnoreCase("NA")){ %>value="<%=contact[0][6]%>"<%} %> class="form-control" name="mobileno1" id="Profile_Mobile_No1" placeholder="Mobile !!" required onkeypress="return isNumber(event)">
            </div>
            <div class="form-group-payment col-md-6 col-sm-6 col-12">
			<label>Mobile Second<small> (Optional)</small></label>
            <input type="text" maxlength="10" onchange="isDuplicateClientDetails('profilemobile','Profile_Mobile_No2')" onblur="validateMobilePopup('Profile_Mobile_No2')" autocomplete="off" <%if(contact!=null&&contact.length>0&&!contact[0][7].equalsIgnoreCase("NA")){ %>value="<%=contact[0][7]%>"<%} %> class="form-control" name="mobileno2" id="Profile_Mobile_No2" placeholder="Mobile Second !!" onkeypress="return isNumber(event)">
            </div>
			</div>
			<div class="row">
			<div class="form-group-payment col-md-6 col-sm-6 col-12">
			<label>Pan</label>
            <input type="text" autocomplete="off" onchange="isDuplicateClientDetails('profilepan','Pan')" <%if(contact!=null&&contact.length>0&&!contact[0][13].equalsIgnoreCase("NA")){ %>value="<%=contact[0][13]%>"<%} %> class="form-control" name="pan" id="Pan" placeholder="Pan !!">
            </div>
            <div class="form-group-payment col-md-6 col-sm-6 col-12">
			<label>Country</label>
            <select name="country" id="Country" class="form-control bdrd4" onchange="updateState(this.value,'State')">
			    <option value="">Select Country</option>
			   <%if(country!=null&&country.length>0){for(int i=0;i<country.length;i++){%>	  
			   <option value="<%=country[i][1]%>#<%=country[i][0]%>" <%if(contact.length>0&&contact[0][12].equalsIgnoreCase(country[i][0])){%>selected="selected"<%} %>><%=country[i][0]%></option>
			   <%}} %>
		    </select>
            </div>                        
            </div>
            <div class="row">	
            <div class="form-group-payment col-md-6 col-sm-6 col-12">
			<label>State</label>
            <select name="state" id="State" class="form-control bdrd4" onchange="updateCity(this.value,'City')">
			  <option value="">Select State</option>
			    <%if(states!=null&&states.length>0){for(int i=0;i<states.length;i++){%>	   
			   <option value="<%=states[i][1]%>#<%=states[i][2]%>#<%=states[i][0]%>" <%if(contact.length>0&&contact[0][10].equalsIgnoreCase(states[i][0])){%>selected="selected"<%} %>><%=states[i][0]%></option>
			   <%}} %>
			</select>
            </div>		
            <div class="form-group-payment col-md-6 col-sm-6 col-12">
			<label>City</label>
            <select name="city" id="City" class="form-control bdrd4">
			  <option value="">Select City</option>		
			  <%if(contact.length>0&&contact[0][9]!=null&&!contact[0][9].equalsIgnoreCase("NA")){ %> 
			  <option value="<%=contact[0][9]%>" selected="selected"><%=contact[0][9]%></option><%} %>
			</select>
            </div>            
            </div>
			<div class="row">            
            <div class="form-group-payment col-md-12 col-sm-12 col-12">
			<label>Address</label>
            <textarea rows="3" onblur="validateLocationPopup('Profile_Address');validateValuePopup('Profile_Address');" autocomplete="off" class="form-control" name="address" id="Profile_Address" placeholder="Address !!" required><%if(contact!=null&&contact.length>0&&!contact[0][11].equalsIgnoreCase("NA")){ %><%=contact[0][11]%><%} %></textarea>
            </div>
			</div>
			<div class="row">
            <div class="form-group-payment col-md-12 col-sm-12 col-12 mt-4 mb-3 text-right">
            <button type="submit" class="btn btn-success" id="ValidatePersonalProfile" onclick="return validatePersonalProfile()">Save Changes</button>
            <button type="button" class="ml-3 btn btn-default cancel_btn">Cancel</button>
            </div>
            </div>
			</div><%} %>
			<div class="clearfix mb-3 business_details">
			<div class="row">
            <div class="form-group-payment col-md-12 col-sm-12 col-12">
			<label>Company</label>
            <select class="form-control" name="companyname" id="Company_Name" onchange="fillCompanyDetails(this.value)">
            <%int companyId=0;
            if(company!=null&&company.length>0){
            	for(int i=0;i<company.length;i++){if(i==0)companyId=Integer.parseInt(company[i][0]);%>
            <option value="<%=company[i][0]%>"><%=company[i][1]%></option>
            <%}} %>
			</select>
			<%
			String companyData[][]=Clientmaster_ACT.getClientDetails(companyId, token); 
			%>
            </div>            
			</div>
			<div class="row">
            <div class="form-group-payment col-md-6 col-sm-6 col-12">
			<label>Business Name</label>
            <input type="text"  onchange="isDuplicateClientDetails('cregname','Business_Name')" onblur="validateCompanyNamePopup('Business_Name');validateValuePopup('Business_Name');" autocomplete="off" class="form-control" <%if(companyData!=null&&companyData.length>0){ %>value="<%=companyData[0][0]%>"<%} %> name="businessname" id="Business_Name" placeholder="Business Name !!" required>
            </div>
            <div class="form-group-payment col-md-6 col-sm-6 col-12">
			<label>Business Phone</label>
            <input type="text" onchange="isDuplicateClientDetails('cregcontmobile','Business_Phone')" autocomplete="off" maxlength="10" class="form-control" <%if(companyData!=null&&companyData.length>0&&!companyData[0][2].equalsIgnoreCase("NA")){ %>value="<%=companyData[0][2]%>"<%} %> name="businessphone" id="Business_Phone" placeholder="Business Phone !!" required onkeypress="return isNumber(event)">
            </div>
			</div>
			<div class="row">
            <div class="form-group-payment col-md-6 col-sm-6 col-12">
			<label>Business Email<small> (optional)</small></label> 
            <input type="email" autocomplete="off" onchange="isDuplicateClientDetails('cregcontemailid','BusinessEmail')" onblur="verifyEmailIdPopup('BusinessEmail')" class="form-control" <%if(companyData!=null&&companyData.length>0&&!companyData[0][3].equalsIgnoreCase("NA")){ %>value="<%=companyData[0][3]%>"<%} %> name="businessemail" id="BusinessEmail" placeholder="Business Email !!">
            </div>			
            <div class="form-group-payment col-md-6 col-sm-6 col-12">
			<label>Industry<small> (optional)</small></label>
            <input type="text" autocomplete="off" onblur="validateLocationPopup('IndustyType');validateValuePopup('IndustyType');" class="form-control" <%if(companyData!=null&&companyData.length>0&&!companyData[0][5].equalsIgnoreCase("NA")){ %>value="<%=companyData[0][5]%>"<%} %> name="industy" id="IndustyType" list="IndustySuggestion" placeholder="Industry !!">
	            <datalist id="IndustySuggestion">
				  <option value="Food">
				  <option value="Aerospace">
				  <option value="Transport">
				  <option value="Computer">
				  <option value="Telecommunication">
				  <option value="Agriculture">
				  <option value="Construction">
				  <option value="Education">
				  <option value="Pharmaceutical">
				  <option value="Health care">
				  <option value="Hospitality">
				  <option value="Entertainment">
				  <option value="News Media">
				  <option value="Energy">
				  <option value="Music">
				  <option value="Mining">
				  <option value="Electronics">				  
				</datalist>
            </div>
            </div>
            <div class="row">
            <div class="form-group-payment col-md-6 col-sm-6 col-12">
			<label>Pan<small> (optional)</small></label>
            <input type="text" autocomplete="off" class="form-control" onchange="isDuplicateClientDetails('cregpan','businessPan')" <%if(companyData!=null&&companyData.length>0&&!companyData[0][9].equalsIgnoreCase("NA")){ %>value="<%=companyData[0][9]%>"<%} %> name="businessPan" id="businessPan" placeholder="Pan !!">
            </div>
            <div class="form-group-payment col-md-6 col-sm-6 col-12">
			<label>GSTIN<small> (optional)</small></label>
            <input type="text" autocomplete="off" class="form-control" onchange="isDuplicateClientDetails('creggstin','businessGst')" <%if(companyData!=null&&companyData.length>0&&!companyData[0][10].equalsIgnoreCase("NA")){ %>value="<%=companyData[0][10]%>"<%} %> name="businessGst" id="businessGst" placeholder="GSTIN !!">
            </div>
			</div>
			<div class="row">
			<div class="form-group-payment col-md-6 col-sm-6 col-12">
			<label>Company Age<small> (optional)</small></label>
            <select name="company_age" id="Company_age" class="form-control bdrd4">
			  <option value="">Select Age</option>
			  <%if(companyData!=null&&companyData.length>0&&!companyData[0][11].equalsIgnoreCase("NA")){ %><option value="<%=companyData[0][11]%>" selected="selected"><%=companyData[0][11]%> Years</option><%} %>
			  <option value="0">0 Year</option>
			  <option value="1">1 Year</option>
			  <option value="2">2 Years</option>
			  <option value="3">3 Years</option>
			  <option value="4">4 Years</option>
			  <option value="5">5 Years</option>
			  <option value="6">6 Years</option>
			  <option value="7">7 Years</option>
			  <option value="8">8 Years</option>
			  <option value="9">9 Years</option>
			  <option value="10">10 Years</option>
			  <option value="11">11 Years</option>
			  <option value="12">12 Years</option>
			  <option value="13">13 Years</option>
			  <option value="14">14 Years</option>
			  <option value="15">15 Years</option>
			  <option value="16">16 Years</option>
			  <option value="17">17 Years</option>
			  <option value="18">18 Years</option>
			  <option value="19">19 Years</option>
			  <option value="20">20+ Years</option>
			</select>
            </div>
			<div class="form-group-payment col-md-6 col-sm-6 col-12">
			<label>Country</label>
            <select name="businessCountry" id="BusinessCountry" class="form-control bdrd4" onchange="updateState(this.value,'businessState')">
			    <option value="">Select Country</option>
			   <%if(country!=null&&country.length>0){for(int i=0;i<country.length;i++){%>	   
			   <option value="<%=country[i][1]%>#<%=country[i][0]%>" <%if(companyData[0][6].equalsIgnoreCase(country[i][0])){%>selected="selected"<%} %>><%=country[i][0]%></option>
			   <%}} %>
		    </select>
            </div>
			</div>
			<div class="row">			
			<div class="form-group-payment col-md-6 col-sm-6 col-12">
			<label>State</label>
            <select name="businessState" id="businessState" class="form-control bdrd4" onchange="updateCity(this.value,'businessCity')">
			  <option value="">Select State</option>
			    <%if(states!=null&&states.length>0){for(int i=0;i<states.length;i++){%>	   
			   <option value="<%=states[i][1]%>#<%=states[i][2]%>#<%=states[i][0]%>" <%if(companyData[0][7].equalsIgnoreCase(states[i][0])){%>selected="selected"<%} %>><%=states[i][0]%></option>
			   <%}} %>
			</select>
            </div>
            <div class="form-group-payment col-md-6 col-sm-6 col-12">
			<label>City</label>
            <select name="businessCity" id="businessCity" class="form-control bdrd4">
			  <option value="">Select City</option>		
			  <%if(companyData[0][8]!=null&&!companyData[0][8].equalsIgnoreCase("NA")){ %> 
			  <option value="<%=companyData[0][8]%>" selected="selected"><%=companyData[0][8]%></option><%} %>
			</select>
            </div>            
            </div> 
			<div class="row">
            <div class="form-group-payment col-md-12 col-sm-12 col-12">
			<label>Address</label>
            <textarea rows="3" onblur="validateLocationPopup('BusinessAddress');validateValuePopup('BusinessAddress');" autocomplete="off" class="form-control" name="address" id="BusinessAddress" placeholder="Address !!" required><%if(companyData!=null&&companyData.length>0&&!companyData[0][4].equalsIgnoreCase("NA")){ %><%=companyData[0][4]%><%} %></textarea>
            </div>
			</div>
			<div class="row">
            <div class="form-group-payment col-md-12 col-sm-12 col-12 mt-4 mb-3 text-right">
            <button type="submit" class="btn btn-success" id="ValidateBusinessProfile" onclick="return validateBusinessProfile()">Save Changes</button>			
            </div>
            </div>
			</div>
			</div>
			</div>
			</div>
            </form>
				  </div>
				  
                </div>				
              </div>
		   
		  </div>
		</div>
        </div>
      </div>
     </div>
    </div>
  </section>
 
</section>

<%@ include file="includes/client-footer-js.jsp" %> 

<script type="text/javascript">
function validatePassword(){
	var crpass=$("#Current_password").val();
	var nwpass=$("#New_Password").val();
	var cfpass=$("#Confirm_Password").val();
	
	
	 if(crpass==null||crpass==""){
			document.getElementById('errorMsg').innerHTML ="Please enter current password !!";
			$('.alert-show').show().delay(2000).fadeOut();
			return false;
		}	
	if(nwpass==null||nwpass==""){
		document.getElementById("errorMsg").innerHTML="Please enter new password !!";			
		$('.alert-show').show().delay(2000).fadeOut();
		return false;
	}
	if(cfpass==null||cfpass==""){
		document.getElementById("errorMsg").innerHTML="Please enter confirm password !!";			
		$('.alert-show').show().delay(2000).fadeOut();
		return false;
	}
	if(nwpass!=cfpass){
		document.getElementById("errorMsg").innerHTML="New Password and Confirm password didn't match !!";			
		$('.alert-show').show().delay(2000).fadeOut();
		return false;
	}
	$("#Update_Password").attr("disabled","disabled"); 	 
	 //update client's personal details
		$.ajax({
			type : "POST",
			url : "updatepasswordByClient111",
			dataType : "HTML",
			data : {
				crpass:crpass,
				nwpass : nwpass
				},
			success : function(data){
				$("#Update_Password").removeAttr("disabled");
			
				if(data=="pass"){
					$("#updatepass").modal("hide");
					$("#errorMsg1").html("Password successfully updated.");				
					$('.alert-show1').show().delay(4000).fadeOut();
					setTimeout(() => {
						location.reload();
					}, 4000);				
				}else{
					$("#errorMsg").html("Please enter correct current password.");				
					$('.alert-show').show().delay(4000).fadeOut();
				}
				
			}
		});
	
}
function isDuplicateClientDetails(colname,boxId){
	var value=$("#"+boxId).val();
	var clientId=$("#Company_Name").val();
	if(value!=null&&value!="NA")
	$.ajax({
		type : "POST",
		url : "isDuplicateClientDetails999",
		dataType : "HTML",
		data : {
			colname : colname,
			value : value,
			clientId : clientId,
			},
		success : function(data){
			if(data=="pass"){			
				document.getElementById("errorMsg").innerHTML=value+" already exist.";			
				$("#"+boxId).val("");
				$('.alert-show').show().delay(2000).fadeOut();
			}
			
		}
	});	
}

function validatePersonalProfile(){	
	let firstName=$("#Profile_First_Name").val();
	let lastName=$("#Profile_Last_Name").val();
	let email_id1=$("#Profile_Email_Id1").val();
	let email_id2=$("#Profile_Email_Id2").val();
	let mobile1=$("#Profile_Mobile_No1").val();
	let mobile2=$("#Profile_Mobile_No2").val();
	let pan=$("#Pan").val();
	let country=$("#Country").val();
	let state=$("#State").val();
	let city=$("#City").val();	
	let address=$("#Profile_Address").val();
	
	 if(firstName==null||firstName==""){
			document.getElementById('errorMsg').innerHTML ="Please enter first name !!";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
	 if(lastName==null||lastName==""){
			document.getElementById('errorMsg').innerHTML ="Please enter last name !!";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
	 if(email_id1==null||email_id1==""){
			document.getElementById('errorMsg').innerHTML ="Please enter email id !!";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
	 if(email_id2==null||email_id2==""){
			$("#Profile_Email_Id2").val("NA");
		}
	 if(mobile1==null||mobile1==""){
			document.getElementById('errorMsg').innerHTML ="Please enter mobile no. !!";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
	 if(mobile2==null||mobile2==""){
			$("#Profile_Mobile_No2").val("NA");
		}
	 if(pan==null||pan==""){
			$("#Pan").val("NA");
		}
	 if(country==null||country==""){
			document.getElementById('errorMsg').innerHTML ="Please select country !!";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
	 if(state==null||state==""){
			document.getElementById('errorMsg').innerHTML ="Please select state !!";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
	 if(city==null||city==""){
			document.getElementById('errorMsg').innerHTML ="Please select city !!";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}	 
	 if(address==null||address==""){
			document.getElementById('errorMsg').innerHTML ="Please enter address !!";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}

	 country=country.substring(country.indexOf("#")+1);
	 let x=state.split("#");
	 let stateCode=x[1];
	 state=x[2];
	 
	 console.log(address);
	 
	 $("#ValidatePersonalProfile").attr("disabled","disabled"); 	 
	 //update client's personal details
		$.ajax({
			type : "POST",
			url : "UpdatePersonalDetails999",
			dataType : "HTML",
			data : {
				firstName : firstName,
				lastName : lastName,
				email_id1 : email_id1,
				email_id2 : email_id2,
				mobile1 : mobile1,
				mobile2 : mobile2,
				pan : pan,
				country : country,
				city : city,
				state : state,
				stateCode : stateCode,
				address : address
				},
			success : function(data){
				$("#ValidatePersonalProfile").removeAttr("disabled");
			
				if(data=="pass"){
					document.getElementById("errorMsg1").innerHTML="Profile Updated Successfully !!.";				
					$('.alert-show1').show().delay(4000).fadeOut();
				}else if(data=="invalid"){
					document.getElementById("errorMsg").innerHTML="Please enter a valid email-address !!.";				
					$('.alert-show').show().delay(4000).fadeOut();
				}else{
					document.getElementById("errorMsg").innerHTML="Something Went Wrong, Try After Sometime later.";				
					$('.alert-show').show().delay(4000).fadeOut();
				}
				
			}
		});
}
function validateBusinessProfile(){	 
	let company_Name=$("#Company_Name").val();
	let bussName=$("#Business_Name").val();
	let bussPhone=$("#Business_Phone").val();
	let bussEmail=$("#BusinessEmail").val();
	let industryType=$("#IndustyType").val();
	let bussPan=$("#businessPan").val();
	let bussGst=$("#businessGst").val();
	let company_age=$("#Company_age").val();
	let bussCountry=$("#BusinessCountry").val();	
	let bussState=$("#businessState").val();
	let bussCity=$("#businessCity").val();
	let bussAddress=$("#BusinessAddress").val();
	 
	if(company_Name==null||company_Name==""){
		document.getElementById('errorMsg').innerHTML ="Please select company name !!";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	 if(bussName==null||bussName==""){
			document.getElementById('errorMsg').innerHTML ="Please enter your business name !!";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
	 if(bussPhone==null||bussPhone==""){
			document.getElementById('errorMsg').innerHTML ="Please enter your business phone number !!";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
	 if(bussEmail==null||bussEmail==""){
		 bussEmail="NA";
		}
	 if(industryType==null||industryType==""){
		 industryType="NA";
		}
	 if(bussPan==null||bussPan==""){
		 bussPan="NA";
		}
	 if(bussGst==null||bussGst==""){
		 bussGst="NA";
		}
	 if(company_age==null||company_age==""){
			document.getElementById('errorMsg').innerHTML ="Please select company age !!";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
	 if(bussCountry==null||bussCountry==""){
			document.getElementById('errorMsg').innerHTML ="Please select country !!";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
	 if(bussState==null||bussState==""){
			document.getElementById('errorMsg').innerHTML ="Please select state !!";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
	 if(bussCity==null||bussCity==""){
			document.getElementById('errorMsg').innerHTML ="Please select city !!";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}	 
	 if(bussAddress==null||bussAddress==""){
			document.getElementById('errorMsg').innerHTML ="Please enter address !!";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
	 bussCountry=bussCountry.substring(bussCountry.indexOf("#")+1);
	 let x=bussState.split("#");
	 let stateCode=x[1];
	 bussState=x[2];
	 
	 
	 $("#ValidateBusinessProfile").attr("disabled","disabled"); 
	 //update client's business details
		$.ajax({
			type : "POST",
			url : "UpdateBusinessDetails999",
			dataType : "HTML",
			data : {
				company_Name : company_Name,
				bussName : bussName,
				bussPhone : bussPhone,
				bussEmail : bussEmail,
				industryType : industryType,
				bussPan : bussPan,
				bussGst : bussGst,
				company_age : company_age,
				bussCountry : bussCountry,
				bussCity : bussCity,
				bussState : bussState,
				stateCode : stateCode,
				bussAddress : bussAddress
				},
			success : function(data){
				$("#ValidateBusinessProfile").removeAttr("disabled");
		
				if(data=="pass"){
					document.getElementById("errorMsg1").innerHTML="Updated Successfully !!.";				
					$('.alert-show1').show().delay(4000).fadeOut();
			    }else if(data=="invalid"){
					document.getElementById("errorMsg").innerHTML="Please enter a valid email-address !!.";				
					$('.alert-show').show().delay(4000).fadeOut();
				}else{
					document.getElementById("errorMsg").innerHTML="Something Went Wrong, Try After Sometime later.";				
					$('.alert-show').show().delay(4000).fadeOut();
				}
				
			}
		});
}
</script>
<script type="text/javascript">
$("#personal1").on("click", function(){ 
$("#Personal").prop('checked','checked')
$(".personal_details").slideDown();
$(".business_details").slideUp();
$("#personal1 a").addClass("active");
$("#business1 a").removeClass("active")
});
$("#business1").on("click", function(){ 
	$("#Business").prop('checked','checked')
	$(".personal_details ").slideUp();
	$(".business_details").slideDown();
	$("#business1 a").addClass("active");
	$("#personal1 a").removeClass("active")
});
$("#mobilepersonal1").on("click", function(){ 
	$("#mobilePersonal").prop('checked','checked')
	$(".personal_details").slideDown();
	$(".business_details").slideUp();
	$("#mobilepersonal1 a").addClass("active");
	$("#mobilebusiness1 a").removeClass("active")
	});
	$("#mobilebusiness1").on("click", function(){ 
		$("#mobileBusiness").prop('checked','checked')
		$(".personal_details ").slideUp();
		$(".business_details").slideDown();
		$("#mobilebusiness1 a").addClass("active");
		$("#mobilepersonal1 a").removeClass("active")
	});
$(".cancel_btn").click(function(){
$('#Business').prop('checked', true);
$('#Personal').removeAttr('checked'); 
$(".personal_details").slideUp();
$(".business_details").slideDown();	
});
function myFunction(id) {
	  var x = document.getElementById(id);
	  if (x.type == "password") {
	    x.type = "text";
	  } else {
	    x.type = "password";
	    
	  }
	}

$('.show_psw').click(function(event){
	//event.preventDefault();
	$(this).toggleClass('active');
});

function updateState(data,stateId){
	var x=data.split("#");
	var id=x[0];
	$.ajax({
		type : "POST",
		url : "GetStateCity111",
		dataType : "HTML",
		data : {				
			id : id,
			fetch : "state"
		},
		success : function(response){	
			$("#"+stateId).empty();
			$("#"+stateId).append(response);	
		}
	});
}
function updateCity(data,cityId){
	var x=data.split("#");
	var id=x[0];
	$.ajax({
		type : "POST",
		url : "GetStateCity111",
		dataType : "HTML",
		data : {				
			id : id,
			fetch : "city"
		},
		success : function(response){	
			$("#"+cityId).empty();
			$("#"+cityId).append(response);	
		}
	});
}

function fillCompanyDetails(companyId){
	$.ajax({
		type : "GET",
		url : "GetCompanyData111",
		dataType : "HTML",
		data : {				
			companyId : companyId
		},
		success : function(response){	
			if(Object.keys(response).length!=0){
				response = JSON.parse(response);			
				 var len = response.length;		 
				 if(len>0){
					 var name=response[0]["name"];
					 var clientNo=response[0]["clientNo"];
					 var mobile=response[0]["mobile"];
					 var email=response[0]["email"];
					 var address=response[0]["address"];
					 var industry=response[0]["industry"];
					 var country=response[0]["country"];
					 var state=response[0]["state"];
					 var city=response[0]["city"];
					 var pan=response[0]["pan"];
					 var gstin=response[0]["gstin"];
					 var cage=response[0]["cage"];
					 var stateCode=response[0]["stateCode"];
					 
					 $("#Business_Name").val(name);$("#Business_Phone").val(mobile);
					 $("#BusinessEmail").val(email);$("#IndustyType").val(industry);
					 $("#businessPan").val(pan);$("#businessGst").val(gstin);
					 $("#Company_age").val(cage);$("#BusinessCountry").val(country);
					 $("#businessCity").empty();
					 $("#businessCity").append("<option value='"+city+"'>"+city+"</option>");
					 $("#businessState").empty();
					 $("#businessState").append("<option value='0#"+stateCode+"#"+state+"'>"+state+"</option>");					 
					 $("#BusinessAddress").val(address);
					 $("#clientStateId").html(state);
				 }
			}
		}
	});
}
setTimeout(() => {
	let state=$("#businessState").val();
	if(state!=null&&state!="")state=state.substring(state.lastIndexOf("#")+1);
	$("#clientStateId").html(state);
}, 500);
</script>

</body>
<!-- body ends -->
</html>