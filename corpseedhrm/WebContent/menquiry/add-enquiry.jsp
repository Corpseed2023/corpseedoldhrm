<%@page import="client_master.Clientmaster_ACT"%>
<%@page import="admin.enquiry.Enquiry_ACT"%>
<html lang="en-US">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>New Estimate Sale</title>
<%@ include file="../staticresources/includes/itswsstyles.jsp"%>
</head>
<body class="add_enquery">
	<div class="wrap">
		<%@ include file="../staticresources/includes/itswsheader.jsp"%>
		<%	
	String addedby= (String)session.getAttribute("loginuID");
	String token= (String)session.getAttribute("uavalidtokenno");
	String loginuaid=(String)session.getAttribute("loginuaid");
	String uaname=(String)session.getAttribute("uaname");

	Clientmaster_ACT.clearProductPriceCart(token,addedby);
	Clientmaster_ACT.clearSalesContactCart(token,addedby);  
	Clientmaster_ACT.clearProductPricePlanCart(token,addedby);

String initial = Usermaster_ACT.getStartingCode(token,"imestimatebillingkey");
String enquid=Enquiry_ACT.getEstimateEnqUID(token); 
if (enquid==null||enquid.equalsIgnoreCase("0") || enquid.equalsIgnoreCase("")) {
	enquid=initial+"1";
}
else {
	   String enq=enquid.substring(initial.length());
	   int j=Integer.parseInt(enq)+1;
 	   enquid=initial+Integer.toString(j);
	}
String[][] servicetype=TaskMaster_ACT.getAllServiceType(token); 
String user[][]=Usermaster_ACT.getAllSalesEmployee(token); 
String consultant[][]=Usermaster_ACT.getAllConsultant(token); 
String country[][]=TaskMaster_ACT.getAllCountries();
String states[][]=TaskMaster_ACT.getStatesByCountryCode("IN");
if(!EST01){%><jsp:forward page="/login.html" />
<%} %>

		<div id="content">
			<div class="main-content">
				<div class="container">
					<div class="row mb10">
						<div class="col-md-6 col-sm-6 col-xs-12 sale_id">
							<label>Sales ID :</label>
							<output name="enquid" id="enquid" class="" title="<%=enquid%>"><%=enquid%></output>
						</div>
						<div class="col-md-6 col-sm-6 col-xs-12 text-right">
							<a href="<%=request.getContextPath()%>/manage-estimate.html"><button
									class="bkbtn">Back</button></a>
						</div>
					</div>
					<div class="row">
						<div class="col-xs-12">
							<div class="menuDv post-slider">
								<form action="<%=request.getContextPath()%>/enquiry-add.html"
									method="post" name="addenq" id="addenq">
									<input type="hidden" id="SalesId" name="salesid"
										value="<%=enquid%>">
									<div class="row">
										<div class="col-md-9 col-sm-10 col-xs-12">
											<div class="row">
												<div class="col-md-12 col-sm-12 col-xs-12">
													<div class="form-group">
														<div class="clearfix text-right mb10">
															<button class="addbtn pointers addnew active"
																onclick="addSuperUser('Enq_Super_User')" type="button">+
																Add Client Admin</button>
														</div>
														<div class="input-group">
															<select name="enq_super_user" id="Enq_Super_User"
																class="form-control bdrd4" required="required">
															</select>
														</div>
													</div>
												</div>
												<div class="col-md-12 col-sm-12 col-xs-12">
													<div class="form-group">
														<div class="clearfix text-right mb10">
															<button class="addbtn pointers addnewcomp active"
																type="button" data-related="add_company"
																onclick="openCompanyBox()">+ New Company</button>
														</div>
														<div class="input-group">
															<a class="updateCompany" data-related="update_company"
																onclick="UpdateCompanyBox('Comp_Name','compuniquecregrefid')">
																<input type="text" placeholder="Company" id="Comp_Name"
																name="comp_name"
																onclick="showHideChangePopUp('div_change_qty1')"
																onmouseleave="hideMouseMove('div_change_qty1')"
																class="form-control pointers">
															</a> <input type="hidden" id="CompAddress"> <input
																type="hidden" id="Company_Name" name="Company_Name"
																value="NA"> <input type="hidden"
																id="compuniquecregrefid" name="compuniquecregrefid"
																value="NA">
															<div id='div_change_qty1'
																style='display: none; width: 100%; height: 29px; position: absolute; z-index: 10; background: rgb(239, 239, 239); padding-left: 13px; padding-top: 4px; border-radius: 4px;'>
																<span style="color: #4ac4f3; font-size: 14px;">Type
																	to search company name</span>
															</div>
														</div>
														<div id="companyErrorMSGdiv" class="errormsg"></div>
														<button class="addbtn pointers new_con_add close_icon3"
															type="button" id="MainCompanyCloseBtn"
															onclick="clearMainCompany('MainCompanyCloseBtn','Comp_Name','CompAddress');"
															style="margin-right: 14px; display: none;">
															<i class="fa fa-times" style="font-size: 21px;"></i>
														</button>
													</div>
												</div>
											</div>
											<div class="row" id="AddNewContact"
												style="margin-bottom: 20px;">
												<div class="col-md-12 col-sm-12 col-xs-12">
													<div class="clearfix">
														<div class="clearfix text-right mb10">
															<button class="addbtn btnborder pointers addnew1"
																type="button" data-related="add_contact"
																onclick="openContactBox('AddContact','conEmail1','conMobile1','AddNewContact','MainSubDivCont','contactrefid')">+
																Add New</button>
															<button class="addbtn pointers contact_add" type="button"
																onclick="addNewContact()">cc</button>
														</div>
														<div class="input-group">
															<input type="hidden" id="contactrefid" /> <a
																class="updateContact" data-related="update_contact"
																onclick="reUpdateContact('AddContact','conEmail1','conMobile1','contactrefid')"><input
																type="text" placeholder="Contact" id="AddContact"
																autocomplete="off"
																onchange="addContactToCart('AddContact','conEmail1','conMobile1','contactrefid')"
																onblur="showCloseBtn('MainContactCloseBtn')"
																onkeypress="searchContact('AddContact','conEmail1','conMobile1','AddNewContact','MainSubDivCont','contactrefid')"
																onclick="showHideChangePopUp('div_change_qty')"
																onmouseleave="hideMouseMove('div_change_qty')"
																class="form-control pointers"></a>
															<div id='div_change_qty'
																style='display: none; width: 100%; height: 29px; position: absolute; z-index: 10; background: rgb(239, 239, 239); padding-left: 13px; padding-top: 4px; border-radius: 4px;'>
																<span style="color: #4ac4f3; font-size: 14px;">Type
																	to search contact name</span>
															</div>
														</div>
														<div id="altermobErrorMSGdiv" class="errormsg"></div>
														<button class="addbtn pointers new_con_add close_icon3"
															type="button" id="MainContactCloseBtn"
															onclick="clearMainContact('AddContact','conEmail1','conMobile1','conEmail2','conMobile2','MainContactCloseBtn','MainSubDivCont','AddNewContact','SecondContact');"
															style="margin-right: 14px; display: none;">
															<i class="fa fa-times" style="font-size: 21px;"></i>
														</button>
													</div>
												</div>
											</div>
											<div class="clearfix inner_box_bg showDiv"
												id="MainSubDivCont" style="display: none;">
												<div class="row">
													<div class="col-md-6 col-sm-6 col-xs-12">
														<div class="mb10">
															<div class="input-group">
																<input type="text" name="conname" id="conEmail1"
																	onchange="updateContactDetails('AddContact','scvcontactemail1st','conEmail1');"
																	onblur="verifyEmailIdPopup('conEmail1')"
																	style="border-radius: 2px;" class="form-control"
																	value="" placeholder="Email">
															</div>
															<div id="connameErrorMSGdiv" class="errormsg"></div>
														</div>
													</div>
													<div class="col-md-6 col-sm-6 col-xs-12">
														<div class="mb10">
															<div class="input-group">
																<input type="text" name="connumber" id="conMobile1"
																	onchange="updateContactDetails('AddContact','scvcontactmobile1st','conMobile1');"
																	onblur="validateMobilePopup('conMobile1')"
																	style="border-radius: 2px;" class="form-control"
																	placeholder="Mobile"
																	onkeypress="return isNumber(event)" maxlength="14">
															</div>
															<div id="connumberErrorMSGdiv" class="errormsg"></div>
														</div>
													</div>
												</div>
												<div class="row" id="SecondContact" style="display: none;">
													<div class="col-md-6 col-sm-6 col-xs-12">
														<div class="mb10">
															<div class="input-group">
																<input type="text" name="conEmail2" id="conEmail2"
																	onchange="updateContactDetails('AddContact','scvcontactemail2nd','conEmail2');"
																	onblur="verifyEmailIdPopup('conEmail2')"
																	style="border-radius: 2px;" class="form-control"
																	value="" placeholder="Email">
															</div>
															<div id="connameErrorMSGdiv" class="errormsg"></div>
														</div>
													</div>
													<div class="col-md-6 col-sm-6 col-xs-12">
														<div class="mb10">
															<div class="input-group">
																<input type="text" name="conMobile2" id="conMobile2"
																	onchange="updateContactDetails('AddContact','scvcontactmobile2nd','conMobile2');"
																	onblur="validateMobilePopup('conMobile2')"
																	style="border-radius: 2px;" class="form-control"
																	value="" placeholder="Mobile"
																	onkeypress="return isNumber(event)" maxlength="14">
															</div>
															<button class="addbtn pointers new_con_add1 close_icon2"
																type="button" onclick="$('#SecondContact').hide();">
																<i class="fa fa-times" style="font-size: 21px;"></i>
															</button>
															<div id="connumberErrorMSGdiv" class="errormsg"></div>
														</div>
													</div>
												</div>
												<div class="clearfix text-right">
													<button class="addbtn pointers" type="button"
														onclick="$('#SecondContact').css('display','block');">+
														Add</button>
												</div>
											</div>
											<!-- 	contact start -->
											<div class="clearfix NewCompanyContact"></div>
											<!-- contact end -->
											<!-- sale Type start -->
											<div class="row sale_type">
												<div class="col-md-6 col-sm-6 col-xs-6">
													<div class="form-group">
														<div class="d-flex">
															<input type="radio" class="input" name="saleType"
																checked="checked" value="1"> <span>Non-Consulting
																Sale</span>
														</div>
													</div>
												</div>
												<div class="col-md-6 col-sm-6 col-xs-6">
													<div class="form-group">
														<div class="d-flex">
															<input type="radio" class="input" name="saleType"
																value="2"> <span>Consulting Sale</span>
														</div>
													</div>
												</div>
											</div>
											<!-- sale type end -->
											<!--  START -->
											<div class="consulting-sale">
												<div class="row border-bottom">
													<div class="col-sm-4 pad-rt0">
														<div class="col-sm-6">
															<div class="row d-flex">
																<input type="radio" value="Once" name="consultationType"><span>Once</span>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="row d-flex">
																<input type="radio" value="Renewal"
																	name="consultationType" checked="checked"><span>Renewal</span>
															</div>
														</div>
													</div>
													<div class="consulting-renewal">
														<div class="col-sm-5 pl-0">
															<div class="col-sm-6">
																<input type="text" class="type"
																	name="consultationRenewalValue"
																	placeholder="Value Ex. 1,2"
																	onkeypress="return isNumber(event)">
															</div>
															<div class="col-sm-6">
																<select class="type" name="consultationRenewalType">
																	<option value="">Type</option>
																	<option value="Day">Day</option>
																	<option value="Month">Month</option>
																	<option value="Year">Year</option>
																</select>
															</div>
														</div>
														<div class="col-sm-3 pl-0">
															<div class="d-flex type">
																<small>End :</small><input type="date"
																	name="consultationEndDate" class="no-border">
															</div>
														</div>
													</div>
												</div>
												<div class="clearfix" style="margin-bottom: 3rem;">
													<select class="form-control" name="consultantUaid"
														id="consultantUaid">
														<option value="">Select Consultant</option>
														<%
														if (consultant != null && consultant.length > 0) {
															for (int i = 0; i < consultant.length; i++) {
														%>
														<option value="<%=consultant[i][0]%>"><%=consultant[i][1]%></option>
														<%
														}
														}
														%>
													</select>
												</div>
												<div class="row">
													<div class="col-sm-3">
														<input type="text" class="input-box"
															value="Consultation Fee" name="consultationFeeType">
													</div>
													<div class="col-sm-2">
														<input type="text" class="input-box"
															name="consultationFee" placeholder="Fee"
															onkeypress="return isNumberKey(event)">
													</div>
													<div class="col-sm-2">
														<input type="text" class="input-box"
															name="consultationHsn" placeholder="HSN">
													</div>

													<div class="col-sm-2">
														<input type="text" class="input-box"
															name="consultationGst" placeholder="GST %"
															readonly="readonly">
													</div>
													<div class="col-sm-3">
														<input type="text" class="input-box"
															name="consultationFeeTotal" placeholder="Total"
															readonly="readonly">
													</div>
												</div>
											</div>
											<div class="consulting_sale_box">
												<div class="row">
													<div class="col-md-12 col-sm-12 col-xs-12">
														<div class="form-group">
															<div class="input-group">
																<!--<span class="input-group-addon"><i class="form-icon fa fa-archive"></i></span>-->
																<select id="Product_Type" name="productType" class="form-control"
																	onchange="getProducts(this.value,'Product_Name')">
																	<option value="">Product Type</option>
																	<%
																	for (int i = 0; i < servicetype.length; i++) {
																	%>
																	<option value="<%=servicetype[i][1]%>"><%=servicetype[i][1]%></option>
																	<%
																	}
																	%>
																</select> <input type="hidden" name="pid" id="pid">
															</div>
															<div id="productTypeErrorMSGdiv" class="errormsg"></div>
														</div>
													</div>
													<div class="col-md-12 col-sm-12 col-xs-12">
														<div class="form-group relative_box">
															<div class="clearfix text-right">
																<button class="addbtn pointers" type="button"
																	data-related="add_contact" id="NewProductBtn"
																	onclick="addNewProduct()"
																	style="display: none; float: right; margin-bottom: 10px;">+
																	New Product</button>
															</div>
															<div class="input-group">
																<!--<span class="input-group-addon"><i class="form-icon fa fa-product-hunt"></i></span>-->
																<input type="hidden" id="ProdGroupRefid" value="NA">
																<select name="product_name" id="Product_Name"
																	onchange="setProduct('Product_Name','CloseBtn','Product_Type','productPrice','Product_Name','NewProductBtn','PriceDropBox','PriceDropBoxSubAmount','PriceGroupId','PriceProduct0','TotalPriceProduct0','ProdGroupRefid','NA','Jurisdiction')"
																	class="form-control">
																	<option value="">Product Name</option>
																</select>
															</div>
															<div id="product_nameErrorMSGdiv" class="errormsg"></div>
															<button class="addbtn pointers close_icon3 del_icon"
																id="CloseBtn" type="button" style="display: none;"
																onclick="activeDisplay('Product_Name','Product_Type','CloseBtn','productPrice','ProductPriceDiv0','NewProductBtn','PriceGroupId','PriceProduct0','TotalPriceProduct0','SaleProdQty')">
																<i class="fa fa-times" style="font-size: 21px;"></i>
															</button>

														</div>
													</div>
												</div>
												<div class="clearfix" id="ProductPriceDiv0">
													<div class="clearfix inner_box_bg form-group"
														id="productPrice" style="display: none;">
														<div class="mb10 flex_box align_center relative_box">
															<span class="input_radio bg_wht pad_box2 pad_box3 s_head">
																<select class="s_type" name="jurisdiction"
																id="Jurisdiction"
																onchange="updatePlan('spvjurisdiction','PriceGroupId',this.value);"
																required="required">
																	<option value="">Select Jurisdiction</option>
															</select>
															</span> <span
																class="mlft10 input_radio bg_wht pad_box2 pad_box3">
																<input type="radio" name="timetype" id="onetime"
																checked="checked"
																onclick="hideTime('ProductPeriod','TimelineBox','MainTimelineValue','MainTimelineUnit');updatePlan('spvprodplan','PriceGroupId','OneTime');">
																<span>One time</span>
															</span> <span
																class="mlft10 input_radio bg_wht pad_box2 pad_box3">
																<input type="radio" name="timetype" id="renewal"
																onclick="askTime('ProductPeriod');updatePlan('spvprodplan','PriceGroupId','Renewal');">
																<span>Renewal</span>
															</span> <span class="mlft10 RenBox1" id="ProductPeriod"
																style="width: 129px;"> <input type="text"
																name="addtimelinevalue" autocomplete="off"
																onclick="showTimelineBox('TimelineBox')"
																onchange="updatePlan('spvplantime','PriceGroupId',this.value);"
																id="MainTimelineValue"
																class="form-control bdrnone text-right"
																placeholder="Timeline" style="width: 58%;"> <input
																type="text" name="addtimelineunit" autocomplete="off"
																id="MainTimelineUnit"
																class="form-control bdrnone pointers"
																readonly="readonly"
																style="width: 8%; position: absolute; margin-left: 66px; margin-top: -40px;">
															</span>
															<div class="timelineproduct_box" id="TimelineBox">
																<div class="timelineproduct_inner">
																	<span id="MilestoneInputDiv"
																		onclick="addInput('TimelineBox','MainTimelineUnit','Day','MainTimelineValue','spvplanperiod','PriceGroupId')">Day</span>
																	<span id="MilestoneInputDiv1"
																		onclick="addInput('TimelineBox','MainTimelineUnit','Week','MainTimelineValue','spvplanperiod','PriceGroupId')">Week</span><span
																		id="MilestoneInputDiv2"
																		onclick="addInput('TimelineBox','MainTimelineUnit','Month','MainTimelineValue','spvplanperiod','PriceGroupId')">Month</span><span
																		id="MilestoneInputDiv3"
																		onclick="addInput('TimelineBox','MainTimelineUnit','Year','MainTimelineValue','spvplanperiod','PriceGroupId')">Year</span>
																</div>
															</div>
															<span class="bg_wht pad_box3 qtyBtn"> <span
																class="fa fa-minus pointers"
																onclick="updateProductQty('SaleProdQty','minus','ProdGroupRefid')"></span>
																<input type="text" id="SaleProdQty" min="1" value="1"
																onchange="updateProdQty('SaleProdQty','ProdGroupRefid')"
																onkeypress="return isNumber(event)"> <span
																class="fa fa-plus pointers"
																onclick="updateProductQty('SaleProdQty','plus','ProdGroupRefid')"></span>
															</span>
														</div>
														<div class="row mb10">
															<div class="col-md-12 col-sm-12 col-xs-12">
																<div class="clearfix" id="PriceDropBox"></div>
																<input type="hidden" name="PriceGroupId"
																	id="PriceGroupId" />
																<div class="clearfix" id="PriceDropBoxSubAmount"></div>
															</div>
														</div>
													</div>
												</div>
												<!-- END -->

												<div class="clearfix MultipleProduct"></div>
												<div class="input-group location_box">
													<div class="row col-md-6 apply-coupon">
														<input type="text" placeholder="Coupon.."
															name="applyCoupon" id="ApplyCoupon"
															onkeyup="showRemoveCoupon(this.value)" autocomplete="off"
															class="form-control"> <a
															href="javascript:void(0)" class="noDisplay removeCoupon"
															title="Remove coupon" onclick="removeCoupon()">&times;</a>
														<a href="javascript:void(0)" class="noDisplay applyCoupon"
															title="Apply coupon" onclick="applyCoupon()">&radic;</a>
													</div>
													<div class="col-md-6 text-center">
														<h4>
															Discount : &nbsp;&nbsp;<i class="fas fa-inr"></i>&nbsp;<span
																class="discount-value">0.0</span>
														</h4>
													</div>
												</div>
											</div>
											<div class="row">
												<div class="col-md-12 col-sm-12 col-xs-12">
													<div class="form-group">
														<div class="input-group mb-10">
															<select class="form-control" name="leadsoldby"
																id="Leadsoldby" required="required">
																<option value="">Select Sales Person</option>
																<%
																if (user != null && user.length > 0) {
																	for (int i = 0; i < user.length; i++) {
																		if (user[i][0].equals(loginuaid)) {
																	continue;
																		} else {
																%>
																<option value="<%=user[i][0]%>"><%=user[i][1]%></option>
																<%
																}
																}
																}
																%>
																<option value="<%=loginuaid%>" selected="selected"><%=uaname%></option>
															</select>
														</div>
													</div>
												</div>
											</div>
											<div class="row">
												<div class="col-md-6 col-sm-6 col-xs-6">
													<div class="form-group">
														<label>Order No. : <span style="color: #4ac4f3;">*</span></label>
														<div class="input-group">
															<span class="input-group-addon"><i
																class="fa fa-shopping-cart" style="color: #4ac4f3;"></i></span>
															<input type="text" class="form-control" name="orderNo"
																id="orderNo" placeholder="Order No. here !"
																required="required">
														</div>
														<div id="orderNoErrorMSGdiv" class="errormsg"></div>
													</div>
												</div>
												<div class="col-md-6 col-sm-6 col-xs-6">
													<div class="form-group">
														<label>Purchase Date : <span
															style="color: #4ac4f3;">*</span></label>
														<div class="input-group">
															<span class="input-group-addon"><i
																class="fa fa-calendar-o" style="color: #4ac4f3;"></i></span> <input
																type="text" class="form-control readonlyAllow"
																name="purchaseDate" id="purchaseDate"
																placeholder="Purchase date" readonly="readonly"
																required="required">
														</div>
														<div id="purchaseDateErrorMSGdiv" class="errormsg"></div>
													</div>
												</div>
											</div>
											<div class="row">
												<div class="col-md-12 col-sm-12 col-xs-12">
													<div class="form-group">
														<label>Invoice Notes : <span
															style="color: #4ac4f3;">*</span></label>
														<div class="input-group">
															<span class="input-group-addon"><i
																class="fa fa-edit" style="color: #4ac4f3;"></i></span>
															<textarea class="form-control" name="notes" id="Notes"
																rows="4" placeholder="Invoice notes here !"></textarea>
														</div>
														<div id="enqNotesErrorMSGdiv" class="errormsg"></div>
													</div>
												</div>
											</div>
											<div class="row">
												<div class="col-md-12 col-sm-12 col-xs-12">
													<div class="form-group">
														<label>Remarks For Operation : <span style="color: #4ac4f3;">*</span></label>
														<div class="input-group">
															<span class="input-group-addon"><i
																class="fa fa-comments-o" style="color: #4ac4f3;"></i></span>
															<textarea class="form-control" name="enqRemarks"
																id="Remarks"
																onblur="validateLocation('Remarks','enqRemarksErrorMSGdiv');validateValue('Remarks','enqRemarksErrorMSGdiv');"
																rows="5" placeholder="Remarks here !"></textarea>
														</div>
														<div id="enqRemarksErrorMSGdiv" class="errormsg"></div>
													</div>
												</div>
												<div class="col-md-12 col-sm-12 col-xs-12 mtop10">
													<button class="bt-link bt-radius bt-loadmore mrt10"
														type="button" onclick="location.reload(true)">Reset</button>
													<button class="bt-link bt-radius bt-loadmore" type="button"
														onclick="return validateSale();">Submit</button>
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
		<%@ include file="../staticresources/includes/itswsfooter.jsp"%>
	</div>

	<div class="fixed_right_box">
		<div class="clearfix add_inner_box pad_box4 addcompany"
			id="update_company">
			<div class="close_icon close_box">
				<i class="fa fa-times" style="font-size: 21px;"></i>
			</div>
			<div class="rttop_title">
				<h3 style="color: #42b0da;">
					<i class="fa fa-building-o"></i>Update Company
				</h3>
				<p>When someone reaches out to you, they become a contact in
					your account. You can create companies and associate contacts with
					them.
			</div>
			<form onsubmit="return false;" id="UpdateRegCompany">
				<input type="hidden" id="UpdateCompanyKey">
				<div class="row">
					<div class="col-md-6 col-sm-6 col-xs-12">
						<div class="form-group">
							<div class="input-group">
								<input type="text" name="companyname" id="UpdateCompanyName"
									placeholder="Company Name"
									onblur="validCompanyNamePopup('UpdateCompanyName');validateValuePopup('UpdateCompanyName');"
									class="form-control bdrd4" readonly="readonly">
							</div>
							<div id="cnameErrorMSGdiv" class="errormsg"></div>
						</div>
					</div>
					<div class="col-md-6 col-sm-6 col-xs-12">
						<div class="form-group">
							<div class="input-group">
								<input type="text" name="industry" id="UpdateIndustry_Type"
									placeholder="Industry"
									onblur="validateNamePopup('UpdateIndustry_Type');validateValuePopup('UpdateIndustry_Type')"
									class="form-control bdrd4">
							</div>
							<div id="industryErrorMSGdiv" class="errormsg"></div>
						</div>
					</div>
				</div>
				<div class="clearfix inner_box_bg">
					<div class="row">
						<div class="col-md-12 col-sm-12 col-xs-12">
							<div class="form-group">
								<label>Super User</label>
								<div class="input-group">
									<select name="update_super_user" id="Update_Super_User"
										class="form-control bdrd4" required="required">
									</select>
								</div>
								<div class="clearfix text-right mt-5">
									<button class="addbtn pointers addnew active"
										onclick="addSuperUser('Update_Super_User')" type="button">+
										Add Client Admin</button>
								</div>
							</div>
						</div>
						<div class="col-md-12 col-sm-12 col-xs-12">
							<div class="form-group">
								<label>Pan Number :<span style="color: #4ac4f3;">*</span></label>
								<div class="input-group">
									<!--<span class="input-group-addon"><i class="form-icon sprite location"></i></span>-->
									<input type="text" name="pannumber" id="UpdatePanNumber"
										placeholder="Pan Number"
										onblur="validatePanPopup('UpdatePanNumber');validateValuePopup('UpdatePanNumber');isExistEditPan('UpdatePanNumber');"
										class="form-control bdrd4">
								</div>
								<div id="panNoErrorMSGdiv" class="errormsg"></div>
							</div>
							<div class="text-right" style="margin-top: -8px;">
								<span class="add_new pointers">+ GST</span>
							</div>
							<div class="relative_box form-group new_field"
								id="CompanyGstDivId" style="display: block;">
								<label>GST Number :</label>
								<div class="input-group">
									<!--<span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>-->
									<input type="text" name="gstnumber" id="UpdateGSTNumber"
										onblur="isExistEditGST('UpdateGSTNumber')"
										placeholder="GST Number here !" class="form-control bdrd4">
									<button class="addbtn pointers close_icon1 del_icon"
										type="button">
										<i class="fa fa-times" style="font-size: 20px;"></i>
									</button>
								</div>
								<div id="newEmailErrorMSGdiv" class="errormsg"></div>
							</div>
						</div>
						<div class="col-md-12 col-sm-12 col-xs-12">
							<div class="form-group">
								<label>Company Age :<span style="color: #4ac4f3;">*</span></label>
								<div class="input-group">
									<select name="edit_company_age" id="Edit_Company_age"
										class="form-control bdrd4">
										<option value="">Select Age</option>
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
								<div id="companyAgeErrorMSGdiv" class="errormsg"></div>
							</div>
						</div>

						<div class="col-md-12 col-sm-12 col-xs-12">
							<div class="form-group">
								<label>Country :<span style="color: #4ac4f3;">*</span></label>
								<div class="input-group">
									<select name="country" id="UpdateCountry"
										class="form-control bdrd4"
										onchange="updateState(this.value,'UpdateState')">
										<option value="">Select Country</option>
										<%if(country!=null&&country.length>0){for(int i=0;i<country.length;i++){%>
										<option value="<%=country[i][1]%>#<%=country[i][0]%>"><%=country[i][0]%></option>
										<%}} %>
									</select>
								</div>
								<div id="countryErrorMSGdiv" class="errormsg"></div>
							</div>
						</div>
						<div class="col-md-12 col-sm-12 col-xs-12">
							<div class="form-group">
								<label>State :<span style="color: #4ac4f3;">*</span></label>
								<div class="input-group">
									<!--   <input type="text" name="state" id="UpdateState" placeholder="State" onblur="validateCityPopup('UpdateState');validateValuePopup('UpdateState')" class="form-control bdrd4"> -->
									<select name="state" id="UpdateState"
										class="form-control bdrd4"
										onchange="updateCity(this.value,'UpdateCity')">
										<option value="">Select State</option>

									</select>
								</div>
								<div id="stateErrorMSGdiv" class="errormsg"></div>
							</div>
						</div>
						<div class="col-md-12 col-sm-12 col-xs-12">
							<div class="form-group">
								<label>City :<span style="color: #4ac4f3;">*</span></label>
								<div class="input-group">
									<select name="businessCity" id="UpdateCity"
										class="form-control bdrd4">
										<option value="">Select City</option>

									</select>
								</div>
								<div id="cityErrorMSGdiv" class="errormsg"></div>
							</div>
						</div>
						<div class="col-md-12 col-sm-12 col-xs-12">
							<div class="form-group">
								<label>Address :<span style="color: #4ac4f3;">*</span></label>
								<div class="input-group">
									<!--<span class="input-group-addon"><i class="form-icon sprite page"></i></span>-->
									<textarea class="form-control bdrd4" rows="2" name="enqAdd"
										id="UpdateAddress" placeholder="Address"
										onblur="validateLocationPopup('UpdateAddress');validateValuePopup('UpdateAddress');"></textarea>
								</div>
								<div id="enqAddErrorMSGdiv" class="errormsg"></div>
							</div>
						</div>
					</div>
				</div>
				<div class="clearfix mtop10 mb10 text-right">
					<button class="bt-link bt-radius bt-gray mrt10 close_box"
						type="button">Cancel</button>
					<button class="bt-link bt-radius bt-loadmore" type="submit"
						onclick="return validateUpdateCompany();">Update</button>
				</div>
			</form>
		</div>

		<div class="clearfix add_inner_box pad_box4 addcompany"
			id="add_company">
			<div class="close_icon close_box">
				<i class="fa fa-times" style="font-size: 21px;"></i>
			</div>
			<div class="rttop_title">
				<h3 style="color: #42b0da;">
					<i class="fa fa-building-o"></i>New Company
				</h3>
				<p>When someone reaches out to you, they become a contact in
					your account. You can create companies and associate contacts with
					them.
			</div>
			<form onsubmit="return false;" id="RegCompany">

				<div class="row">
					<div class="col-md-6 col-sm-6 col-xs-12">
						<div class="form-group">
							<div class="input-group">
								<input type="text" name="companyname" id="CompanyName"
									placeholder="Company Name"
									onblur="validCompanyNamePopup('CompanyName');validateValuePopup('CompanyName');isExistValue('CompanyName')"
									class="form-control bdrd4">
							</div>
							<div id="cnameErrorMSGdiv" class="errormsg"></div>
						</div>
					</div>
					<div class="col-md-6 col-sm-6 col-xs-12">
						<div class="form-group">
							<div class="input-group">
								<input type="text" name="industry" id="Industry_Type"
									placeholder="Industry"
									onblur="validateNamePopup('Industry_Type');validateValuePopup('Industry_Type')"
									class="form-control bdrd4">
							</div>
							<div id="industryErrorMSGdiv" class="errormsg"></div>
						</div>
					</div>
				</div>
				<div class="clearfix inner_box_bg">
					<div class="row">
						<div class="col-md-12 col-sm-12 col-xs-12">
							<div class="form-group">
								<label>Super User</label>
								<div class="input-group">
									<select name="super_user" id="Super_User"
										class="form-control bdrd4" required="required">
									</select>
								</div>
								<div class="clearfix text-right mt-5">
									<button class="addbtn pointers addnew active"
										onclick="addSuperUser('Super_User')" type="button">+
										Add Client Admin</button>
								</div>
							</div>
						</div>
						<div class="col-md-12 col-sm-12 col-xs-12">
							<div class="form-group">
								<label>Pan Number</label>
								<div class="input-group">
									<!--<span class="input-group-addon"><i class="form-icon sprite location"></i></span>-->
									<input type="text" name="pannumber" id="PanNumber"
										placeholder="Pan Number"
										onblur="validatePanPopup('PanNumber');validateValuePopup('PanNumber');isExistPan('PanNumber');"
										class="form-control bdrd4">
								</div>
								<div id="panNoErrorMSGdiv" class="errormsg"></div>
							</div>
							<div class="text-right" style="margin-top: -8px;">
								<span class="add_new pointers">+ GST</span>
							</div>
							<div class="relative_box form-group new_field"
								style="display: block;">
								<label>GST Number :</label>
								<div class="input-group">
									<!--<span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>-->
									<input type="text" name="gstnumber" id="GSTNumber"
										onblur="isExistGST('GSTNumber')"
										placeholder="GST Number here !" class="form-control bdrd4">
									<button class="addbtn pointers close_icon1 del_icon"
										type="button">
										<i class="fa fa-times" style="font-size: 20px;"></i>
									</button>
								</div>
								<div id="newEmailErrorMSGdiv" class="errormsg"></div>
							</div>
						</div>
						<div class="col-md-12 col-sm-12 col-xs-12">
							<div class="form-group">
								<label>Company Age :<span style="color: #4ac4f3;">*</span></label>
								<div class="input-group">
									<select name="company_age" id="Company_age"
										class="form-control bdrd4">
										<option value="">Select Age</option>
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
								<div id="companyAgeErrorMSGdiv" class="errormsg"></div>
							</div>
						</div>

						<div class="col-md-12 col-sm-12 col-xs-12">
							<div class="form-group">
								<label>Country :<span style="color: #4ac4f3;">*</span></label>
								<div class="input-group">
									<!--<span class="input-group-addon"><i class="form-icon sprite location"></i></span>-->
									<!--   <input type="text" name="country" id="Country" placeholder="Country" onblur="validateCityPopup('Country');validateValuePopup('Country')" class="form-control bdrd4"> -->
									<select name="country" id="Country" class="form-control bdrd4"
										onchange="updateState(this.value,'State')">
										<option value="">Select Country</option>
										<%if(country!=null&&country.length>0){for(int i=0;i<country.length;i++){
	   if(country[i][0].equalsIgnoreCase("India")){%>
										<option value="<%=country[i][1]%>#<%=country[i][0]%>"
											selected="selected"><%=country[i][0]%></option>
										<%}else{ %>
										<option value="<%=country[i][1]%>#<%=country[i][0]%>"><%=country[i][0]%></option>
										<%}}} %>
									</select>
								</div>
								<div id="countryErrorMSGdiv" class="errormsg"></div>
							</div>
						</div>
						<div class="col-md-12 col-sm-12 col-xs-12">
							<div class="form-group">
								<label>State :<span style="color: #4ac4f3;">*</span></label>
								<div class="input-group">
									<select name="state" id="State" class="form-control bdrd4"
										onchange="updateCity(this.value,'City')">
										<option value="">Select State</option>
										<%if(states!=null&&states.length>0){for(int i=0;i<states.length;i++){%>
										<option
											value="<%=states[i][1]%>#<%=states[i][2]%>#<%=states[i][0]%>"><%=states[i][0]%></option>
										<%}} %>
									</select>
								</div>
								<div id="stateErrorMSGdiv" class="errormsg"></div>
							</div>
						</div>
						<div class="col-md-12 col-sm-12 col-xs-12">
							<div class="form-group">
								<label>City :<span style="color: #4ac4f3;">*</span></label>
								<div class="input-group">
									<!--<span class="input-group-addon"><i class="form-icon sprite location"></i></span>-->
									<!--   <input type="text" name="city" id="City" placeholder="City" onblur="validateCityPopup('City');validateValuePopup('City')" class="form-control bdrd4"> -->
									<select name="city" id="City" class="form-control bdrd4">
										<option value="">Select City</option>

									</select>
								</div>
								<div id="cityErrorMSGdiv" class="errormsg"></div>
							</div>
						</div>
						<div class="col-md-12 col-sm-12 col-xs-12">
							<div class="form-group">
								<label>Address :<span style="color: #4ac4f3;">*</span></label>
								<div class="input-group">
									<!--<span class="input-group-addon"><i class="form-icon sprite page"></i></span>-->
									<textarea class="form-control bdrd4" rows="2" name="enqAdd"
										id="Address" placeholder="Address"
										onblur="validateLocationPopup('Address');validateValuePopup('Address');"></textarea>
								</div>
								<div id="enqAddErrorMSGdiv" class="errormsg"></div>
							</div>
						</div>
					</div>
				</div>
				<div class="clearfix mtop10 mb10 text-right">
					<button class="bt-link bt-radius bt-gray mrt10 close_box"
						type="button">Cancel</button>
					<button class="bt-link bt-radius bt-loadmore" type="submit"
						onclick="return validateCompany();">Create</button>
				</div>
			</form>
		</div>
		<div class="clearfix add_inner_box pad_box4 addcontact"
			id="add_contact">
			<div class="close_icon close_box">
				<i class="fa fa-times" style="font-size: 21px;"></i>
			</div>
			<div class="existing_client">
				<a href="javascript:void(0)" id="useAdminContact">Use Admin's
					Contact</a>
			</div>
			<div class="rttop_title">
				<h3 style="color: #42b0da;">
					<i class="fa fa-fax"></i>New Contact
				</h3>
				<p>When someone reaches out to you, they become a contact in
					your account. You can create companies and associate contacts with
					them.
			</div>

			<form onsubmit="return false;" id="FormContactBox">
				<input type="hidden" id="AddContactKeyId">
				<div class="row">
					<div class="col-md-6 col-sm-6 col-xs-12">
						<div class="form-group">
							<div class="input-group">
								<input type="text" name="firstname" id="ContactFirstName"
									placeholder="First Name"
									onblur="validateNamePopup('ContactFirstName');validateValuePopup('ContactFirstName')"
									class="form-control bdrd4">
							</div>
							<div id="fnameErrorMSGdiv" class="errormsg"></div>
						</div>
					</div>
					<div class="col-md-6 col-sm-6 col-xs-12">
						<div class="form-group">
							<div class="input-group">
								<input type="text" name="lastname" id="ContactLastName"
									placeholder="Last Name"
									onblur="validateNamePopup('ContactLastName');validateValuePopup('ContactLastName');"
									class="form-control bdrd4">
							</div>
							<div id="lnameErrorMSGdiv" class="errormsg"></div>
						</div>
					</div>
				</div>
				<div class="clearfix inner_box_bg">
					<div class="row">
						<div class="col-md-12 col-sm-12 col-xs-12">
							<div class="mb10">
								<label>Email :<span style="color: #4ac4f3;">*</span></label>
								<div class="input-group">
									<!--<span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>-->
									<input type="email" name="enqEmail" id="ContactEmail_Id"
										onblur="verifyEmailIdPopup('ContactEmail_Id');isDuplicateEmail('ContactEmail_Id');"
										placeholder="Email" class="form-control bdrd4">
								</div>
								<div id="enqEmailErrorMSGdiv" class="errormsg"></div>
							</div>
							<div class="text-right">
								<span class="add_new pointers">+ Email</span>
							</div>
							<div class="relative_box form-group new_field"
								style="display: none;">
								<label>Email 2nd :<span style="color: #4ac4f3;">*</span></label>
								<div class="input-group">
									<!--<span class="input-group-addon"><i class="form-icon sprite email-id"></i></span>-->
									<input type="email" name="enqEmail" id="ContactEmailId2"
										onblur="isDuplicateEmail('ContactEmailId2');"
										placeholder="Email" class="form-control bdrd4">
									<button class="addbtn pointers close_icon1 del_icon"
										type="button">
										<i class="fa fa-times" style="font-size: 20px;"></i>
									</button>
								</div>
								<div id="newEmailErrorMSGdiv" class="errormsg"></div>
							</div>
						</div>
						<div class="col-md-12 col-sm-12 col-xs-12">
							<div class="form-group">
								<label>Pan :</label>
								<div class="input-group">
									<!--<span class="input-group-addon"><i class="form-icon sprite location"></i></span>-->
									<input type="text" name="contPan" id="ContactPan"
										onblur="validatePanPopup('ContactPan');validateValuePopup('ContactPan');isExistPan('ContactPan');"
										placeholder="Pan" maxlength="14" class="form-control bdrd4">
								</div>
								<div id="conPanErrorMSGdiv" class="errormsg"></div>
							</div>
						</div>
						<div class="col-md-12 col-sm-12 col-xs-12">
							<div class="form-group">
								<label>Work Phone :<span style="color: #4ac4f3;">*</span></label>
								<div class="input-group">
									<!--<span class="input-group-addon"><i class="form-icon sprite location"></i></span>-->
									<input type="text" name="workphone" id="ContactWorkPhone"
										onblur="isDuplicateMobilePhone('ContactWorkPhone')"
										placeholder="Work phone" maxlength="14"
										class="form-control bdrd4" onkeypress="return isNumber(event)">
								</div>
								<div id="wphoneErrorMSGdiv" class="errormsg"></div>
							</div>
						</div>
						<div class="col-md-12 col-sm-12 col-xs-12">
							<div class="form-group">
								<label>Mobile Phone</label>
								<div class="input-group">
									<!--<span class="input-group-addon"><i class="form-icon sprite location"></i></span>-->
									<input type="text" name="mobilephone" id="ContactMobilePhone"
										placeholder="Mobile Phone" maxlength="14"
										onblur="isDuplicateMobilePhone('ContactMobilePhone');"
										class="form-control bdrd4" onkeypress="return isNumber(event)">
								</div>
								<div id="mphoneErrorMSGdiv" class="errormsg"></div>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-md-12 col-sm-12 col-xs-12">
						<div class="mb10 flex_box align_center">
							<span class="input_radio"> <input type="radio"
								name="addresstype" id="ContactperAddress" checked> <span>Personal
									Address</span>
							</span> <span class="mlft10 input_radio"> <input type="radio"
								name="addresstype" id="ContactcomAddress"
								onclick="getCompanyAddress()"> <span>Company
									Address</span>
							</span>
						</div>
					</div>
				</div>
				<div class="row address_box">
					<div class="col-md-12 col-sm-12 col-xs-12">
						<div class="form-group">
							<label>Country :<span style="color: #4ac4f3;">*</span></label>
							<div class="input-group">
								<select class="form-control" name="country" id="ContCountry"
									onchange="updateState(this.value,'ContState')">
									<option value="">Select Country</option>
									<%if(country!=null&&country.length>0){for(int i=0;i<country.length;i++){%>
									<option value="<%=country[i][1]%>#<%=country[i][0]%>"><%=country[i][0]%></option>
									<%}} %>
								</select>
							</div>
							<div id="enqCountryErrorMSGdiv" class="errormsg"></div>
						</div>
					</div>
				</div>
				<div class="row address_box">
					<div class="col-md-6 col-sm-6 col-xs-12">
						<div class="form-group">
							<label>State :<span style="color: #4ac4f3;">*</span></label>
							<div class="input-group">
								<select class="form-control bdrd4" name="state" id="ContState"
									onchange="updateCity(this.value,'ContCity')">
									<option value="">Select State</option>
								</select>
							</div>
							<div id="stateErrorMSGdiv" class="errormsg"></div>
						</div>
					</div>
					<div class="col-md-6 col-sm-6 col-xs-12">
						<div class="form-group">
							<label>City :<span style="color: #4ac4f3;">*</span></label>
							<div class="input-group">
								<select class="form-control bdrd4" name="city" id="ContCity">
									<option value="">Select City</option>
								</select>
							</div>
							<div id="cityErrorMSGdiv" class="errormsg"></div>
						</div>
					</div>
				</div>
				<div class="row address_box">
					<div class="col-md-12 col-sm-12 col-xs-12">
						<div class="form-group">
							<label>Address :<span style="color: #4ac4f3;">*</span></label>
							<div class="input-group">
								<textarea class="form-control bdrd4" rows="2" name="enqAdd"
									id="ContAddress" placeholder="Address"
									onblur="validateValuePopup('ContAddress');validateLocationPopup('ContAddress');"></textarea>
							</div>
							<div id="enqAddErrorMSGdiv" class="errormsg"></div>
						</div>
					</div>
				</div>
				<div class="row company_box" style="display: none;">
					<div class="col-md-12 col-sm-12 col-xs-12">
						<div class="form-group">
							<div class="input-group">
								<textarea class="form-control bdrd4" rows="2" name="enqCompAdd"
									id="EnqCompAddress" placeholder="Company Address"
									onblur="validateValuePopup('EnqCompAddress');validateLocationPopup('EnqCompAddress');"
									readonly="readonly"></textarea>
							</div>
							<div id="companyErrorMSGdiv" class="errormsg"></div>
						</div>
					</div>
				</div>
				<div class="clearfix mtop10 mb10 text-right">
					<button class="bt-link bt-radius bt-gray mrt10 close_box"
						type="button">Cancel</button>
					<button class="bt-link bt-radius bt-loadmore" type="submit"
						id="ValidateAddContact" onclick="return validateContact();">Create</button>
				</div>
			</form>
		</div>

		<div class="clearfix add_inner_box pad_box4 updatecontact"
			id="update_contact">
			<div class="close_icon close_box">
				<i class="fa fa-times" style="font-size: 21px;"></i>
			</div>
			<div class="rttop_title">
				<h3 style="color: #42b0da;">
					<i class="fa fa-fax"></i>Update Contact
				</h3>
				<p>When someone reaches out to you, they become a contact in
					your account. You can create companies and associate contacts with
					them.
			</div>

			<form onsubmit="return false;" id="FormUpdateContactBox">
				<input type="hidden" id="UpdateContactKey" />
				<div class="row">
					<div class="col-md-6 col-sm-6 col-xs-12">
						<div class="form-group">
							<div class="input-group">
								<input type="text" name="firstname" id="UpdateContactFirstName"
									placeholder="First Name"
									onblur="validateNamePopup('UpdateContactFirstName');validateValuePopup('UpdateContactFirstName')"
									class="form-control bdrd4">
							</div>
							<div id="fnameErrorMSGdiv" class="errormsg"></div>
						</div>
					</div>
					<div class="col-md-6 col-sm-6 col-xs-12">
						<div class="form-group">
							<div class="input-group">
								<input type="text" name="lastname" id="UpdateContactLastName"
									placeholder="Last Name"
									onblur="validateNamePopup('UpdateContactLastName');validateValuePopup('UpdateContactLastName');"
									class="form-control bdrd4">
							</div>
							<div id="lnameErrorMSGdiv" class="errormsg"></div>
						</div>
					</div>
				</div>
				<div class="clearfix inner_box_bg">
					<div class="row">
						<div class="col-md-12 col-sm-12 col-xs-12">
							<div class="mb10">
								<label>Email :<span style="color: #4ac4f3;">*</span></label>
								<div class="input-group">
									<input type="email" name="enqEmail1" id="UpdateContactEmail_Id"
										onblur="verifyEmailIdPopup('UpdateContactEmail_Id');isUpdateDuplicateEmail('UpdateContactEmail_Id');"
										placeholder="Email" class="form-control bdrd4">
								</div>
								<div id="enqEmailErrorMSGdiv" class="errormsg"></div>
							</div>
							<div class="text-right">
								<span class="add_new pointers">+ Email</span>
							</div>
							<div class="relative_box form-group new_field"
								id="UpdateContactDivId" style="display: none;">
								<label>Email 2nd :<span style="color: #4ac4f3;">*</span></label>
								<div class="input-group">
									<input type="email" name="enqEmail2" id="UpdateContactEmailId2"
										onblur="isUpdateDuplicateEmail('UpdateContactEmailId2');"
										placeholder="Email" class="form-control bdrd4">
									<button class="addbtn pointers close_icon1 del_icon"
										type="button">
										<i class="fa fa-times" style="font-size: 20px;"></i>
									</button>
								</div>
								<div id="newEmailErrorMSGdiv" class="errormsg"></div>
							</div>
						</div>
						<div class="col-md-12 col-sm-12 col-xs-12">
							<div class="form-group">
								<label>Pan :</label>
								<div class="input-group">
									<input type="text" name="contPan" id="UpdateContPan"
										onblur="validatePanPopup('UpdateContPan');validateValuePopup('UpdateContPan');isExistEditPanCon('UpdateContPan');"
										placeholder="Pan" maxlength="14" class="form-control bdrd4">
								</div>
								<div id="wphoneErrorMSGdiv" class="errormsg"></div>
							</div>
						</div>
						<div class="col-md-12 col-sm-12 col-xs-12">
							<div class="form-group">
								<label>Work Phone :<span style="color: #4ac4f3;">*</span></label>
								<div class="input-group">
									<input type="text" name="workphone" id="UpdateContactWorkPhone"
										onblur="isUpdateDuplicateMobilePhone('UpdateContactWorkPhone')"
										placeholder="Work phone" maxlength="14"
										class="form-control bdrd4" onkeypress="return isNumber(event)">
								</div>
								<div id="wphoneErrorMSGdiv" class="errormsg"></div>
							</div>
						</div>
						<div class="col-md-12 col-sm-12 col-xs-12">
							<div class="form-group">
								<label>Mobile Phone :<span style="color: #4ac4f3;">*</span></label>
								<div class="input-group">
									<input type="text" name="mobilephone"
										id="UpdateContactMobilePhone" placeholder="Mobile Phone"
										maxlength="14"
										onblur="validateMobilePopup('UpdateContactMobilePhone');isUpdateDuplicateMobilePhone('UpdateContactMobilePhone');"
										class="form-control bdrd4" onkeypress="return isNumber(event)">
								</div>
								<div id="mphoneErrorMSGdiv" class="errormsg"></div>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-md-12 col-sm-12 col-xs-12">
						<div class="mb10 flex_box align_center">
							<span class="input_radio"> <input type="radio"
								name="addresstype" id="UpdateContactperAddress" checked>
								<span>Personal Address</span>
							</span> <span class="mlft10 input_radio"> <input type="radio"
								name="addresstype" id="UpdateContactcomAddress"
								onclick="getUpdateCompanyAddress()"> <span>Company
									Address</span>
							</span>
						</div>
					</div>
				</div>
				<div class="row UpdateAddress_box">
					<div class="col-md-12 col-sm-12 col-xs-12">
						<div class="form-group">
							<label>Country :<span style="color: #4ac4f3;">*</span></label>
							<div class="input-group">
								<select class="form-control" name="country"
									id="UpdateContCountry"
									onchange="updateState(this.value,'UpdateContState')">
									<option value="">Select Country</option>
									<%if(country!=null&&country.length>0){for(int i=0;i<country.length;i++){%>
									<option value="<%=country[i][1]%>#<%=country[i][0]%>"><%=country[i][0]%></option>
									<%}} %>
								</select>
							</div>
							<div id="enqCountryErrorMSGdiv" class="errormsg"></div>
						</div>
					</div>
				</div>
				<div class="row UpdateAddress_box">
					<div class="col-md-6 col-sm-6 col-xs-12">
						<div class="form-group">
							<label>State :<span style="color: #4ac4f3;">*</span></label>
							<div class="input-group">
								<select class="form-control bdrd4" name="state"
									id="UpdateContState"
									onchange="updateCity(this.value,'UpdateContCity')">
									<option value="">Select State</option>
								</select>
							</div>
							<div id="stateErrorMSGdiv" class="errormsg"></div>
						</div>
					</div>
					<div class="col-md-6 col-sm-6 col-xs-12">
						<div class="form-group">
							<label>City :<span style="color: #4ac4f3;">*</span></label>
							<div class="input-group">
								<select class="form-control bdrd4" name="city"
									id="UpdateContCity">
									<option value="">Select City</option>
								</select>
							</div>
							<div id="cityErrorMSGdiv" class="errormsg"></div>
						</div>
					</div>
				</div>
				<div class="row UpdateAddress_box">
					<div class="col-md-12 col-sm-12 col-xs-12">
						<div class="form-group">
							<label>Address :<span style="color: #4ac4f3;">*</span></label>
							<div class="input-group">
								<!--<span class="input-group-addon"><i class="form-icon sprite page"></i></span>-->
								<textarea class="form-control bdrd4" rows="2" name="enqAdd"
									id="UpdateContAddress" placeholder="Address"
									onblur="validateValuePopup('UpdateContAddress');validateLocationPopup('UpdateContAddress');"></textarea>
							</div>
							<div id="enqAddErrorMSGdiv" class="errormsg"></div>
						</div>
					</div>
				</div>
				<div class="row UpdateCompany_box" style="display: none;">
					<div class="col-md-12 col-sm-12 col-xs-12">
						<div class="form-group">
							<div class="input-group">
								<!--<span class="input-group-addon"><i class="form-icon fa fa-bank"></i></span>-->
								<textarea class="form-control bdrd4" rows="2" name="enqCompAdd"
									id="UpdateEnqCompAddress" placeholder="Company Address"
									onblur="validateValuePopup('UpdateEnqCompAddress');validateLocationPopup('UpdateEnqCompAddress');"
									readonly="readonly"></textarea>
							</div>
							<div id="companyErrorMSGdiv" class="errormsg"></div>
						</div>
					</div>
				</div>
				<div class="clearfix mtop10 mb10 text-right">
					<button class="bt-link bt-radius bt-gray mrt10 close_box"
						type="button">Cancel</button>
					<button class="bt-link bt-radius bt-loadmore" type="submit"
						id="ValidateUpdateContact"
						onclick="return validateUpdateContact();">Update</button>
				</div>
			</form>
		</div>

		<div class="clearfix add_inner_box pad_box4 addpayment"
			id="add_payment">

			<div class="close_icon close_box">
				<i class="fa fa-times"></i>
			</div>
			<div class="rttop_title">
				<h3 style="color: #42b0da;">
					<i class="fa fa-money"></i><span id="PymtForAllId"
						class="pymtreghead"></span>
				</h3>
			</div>
			<form onsubmit="return false;" enctype="multipart/form-data"
				id="UploadFormdata">
				<input type="hidden" name="WhichPaymentFor" id="WhichPaymentFor">
				<div class="menuDv pad_box4 clearfix mb30">
					<div class="row">
						<div class="col-md-6 col-sm-6 col-xs-12">
							<div class="form-group">
								<div class="input-group">
									<select name="paymentmode" id="PaymentMode"
										class="form-control bdrd4">
										<option value="">Payment Mode</option>
										<option value="Online">Online</option>
										<option value="Cash">Cash</option>
									</select>
								</div>
								<div id="paymentmodeErrorMSGdiv" class="errormsg"></div>
							</div>
						</div>
						<div class="col-md-6 col-sm-6 col-xs-12">
							<div class="form-group">
								<div class="input-group">
									<input type="text" name="pymtdate" id="PaymentDate"
										autocomplete="off" placeholder="Date"
										class="form-control datepicker readonlyAllow bdrd4"
										readonly="readonly">
								</div>
								<div id="pdateErrorMSGdiv" class="errormsg"></div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-6 col-sm-6 col-xs-12">
							<div class="form-group">
								<div class="input-group">
									<input type="text" name="transactionid" id="TransactionId"
										autocomplete="off" placeholder="Transaction Id"
										onblur="isDuplicate('TransactionId')"
										class="form-control bdrd4">
								</div>
								<div id="transactionidErrorMSGdiv" class="errormsg"></div>
							</div>
						</div>
						<div class="col-md-6 col-sm-6 col-xs-12">
							<div class="form-group">
								<div class="input-group">
									<input type="text" name="amount" id="Amount"
										placeholder="Amount" autocomplete="off" onblur=""
										class="form-control bdrd4"
										onkeypress="return isNumberKey(event)">
								</div>
								<div id="amountErrorMSGdiv" class="errormsg"></div>
							</div>
						</div>
					</div>
					<div class="blog-list-title text-center">OR</div>
					<div class="row">
						<div class="col-md-6 col-sm-6 col-xs-12">
							<div class="mb10">
								<div class="input-group">
									<input type="file" name="choosefile" id="ChooseFile"
										onchange="fileSize(this)" placeholder="Choose File"
										class="form-control bdrd4">
								</div>
								<div id="cfileErrorMSGdiv" class="errormsg"></div>
							</div>
						</div>
					</div>
					<div class="row flex_box align_center select_box">
						<div class="col-md-9 col-sm-9 col-xs-12">
							<small>Select Transaction Receipt To Upload <span
								class="txt_red">(Max Size 4MB)</span></small>
						</div>
						<div class="col-md-3 col-sm-3 col-xs-12">
							<!-- <input type="checkbox" name="checked_btn" checked> -->
							<button type="button" class="btn-warning bdrd4"
								style="width: 85px; height: 30px;" id="btnSubmit"
								onclick="validatePayment(event)">Submit</button>
						</div>
					</div>
				</div>
			</form>
			<h3 class="blog-list-title">Received payments</h3>
			<div class="clearfix menuDv pad_box3 pad05 mb10"
				style="min-height: 145px;">
				<div class="clearfix mb10">
					<div class="clearfix bg_wht link-style12">
						<div class="box-width6 col-xs-1 box-intro-bg">
							<div class="clearfix">
								<p class="news-border">Date</p>
							</div>
						</div>
						<div class="box-width28 col-xs-6 box-intro-bg">
							<div class="clearfix">
								<p class="news-border" title="">Status</p>
							</div>
						</div>
						<div class="box-width10 col-xs-6 box-intro-bg">
							<div class="clearfix">
								<p class="news-border">Amount</p>
							</div>
						</div>
						<div class="box-width18 col-xs-6 box-intro-bg">
							<div class="clearfix">
								<p class="news-border">Action</p>
							</div>
						</div>
					</div>
					<!-- on open payment box show received payment -->
					<div class="clearfix" id="ReceivedPayment"></div>

				</div>
				<div class="clearfix col-md-12">
					<div class="col-md-6 popaction" style="display: none;">
						<div class="row">
							<span class="ActBtn">Delete record</span>
						</div>
						<div class="row mtop10">
							<span class="fntsize10">Are you sure want to delete this
								payment ?</span>
						</div>
						<div class="row mtp4">
							<span class="fntsize10">This Can't be reverse !</span>
						</div>
						<div class="row ActBtn1">
							<span class="fa fa-times pointers" style="margin-right: 7px;"></span>
							<span class="fa fa-check pointers"></span>
						</div>
					</div>
					<div class="col-md-6 popaction1" style="display: none;">
						<div class="row">
							<span class="ActBtn">Cancel payment</span>
						</div>
						<div class="row mtop10">
							<span class="fntsize10">Are you sure want to cancel this
								payment ?</span>
						</div>
						<div class="row mtp4">
							<span class="fntsize10">This Can't be reverse !</span>
						</div>
						<div class="row ActBtn1">
							<span class="fa fa-times pointers" style="margin-right: 7px;"></span>
							<span class="fa fa-check pointers"></span>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="myModal modal fade" id="add_super_user">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">
						<i class="fas fa-user" aria-hidden="true"></i>+ Add Client Admin
					</h4>
					<button type="button" class="close" data-dismiss="modal">&times;</button>
				</div>
				<form onsubmit="return validateSuperUser()"
					action="javascript:void(0)" id="super_user_form">
					<div class="modal-body">
						<div class="row">
							<div class="form-group-payment col-md-12 col-sm-12 col-12">
								<label>Name</label> <input type="text" class="form-control"
									name="super_name" id="super_name" placeholder=""
									required="required">
							</div>
							<div class="form-group-payment col-md-12 col-sm-12 col-12">
								<label>Email</label> <input type="email" class="form-control"
									name="super_email" id="super_email" placeholder=""
									required="required">
							</div>
							<div class="form-group-payment col-md-12 col-sm-12 col-12">
								<label>Mobile</label> <input type="text" class="form-control"
									maxlength="15" name="super_mobile" id="super_mobile"
									placeholder="" required="required">
							</div>
						</div>
					</div>
					<div class="modal-footer pad_box4">
						<div class="mtop10">
							<input type="hidden" id="add_super_user_id">
							<button type="button" class="btn btn-secondary"
								data-dismiss="modal">Cancel</button>
							<button type="submit" class="btn btn-success">Submit</button>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
	<input type="hidden" id="DisplayPrice" value="1" />
	<input type="hidden" id="DisplayPayment" value="1" />
	<input type="hidden" id="ContactDetails" value="innerContact1" />
	<input type="hidden" id="ContactId" value="0" />
	<input type="hidden" id="NewProductId" value="0" />
	<input type="hidden" id="OpenContactId" />
	<input type="hidden" id="OpenContactMobile1" />
	<input type="hidden" id="OpenContactEmail1" />
	<!-- <input type="hidden" id="OpenContactMobile2"/> -->
	<!-- <input type="hidden" id="OpenContactEmail2"/> -->
	<input type="hidden" id="OpenContactSubDivMarginid" />
	<input type="hidden" id="OpenContactSubDiv" />
	<input type="hidden" id="UpdateContactInputRefid" />

	<%@ include file="../staticresources/includes/itswsscripts.jsp"%>

	<script type="text/javascript">

function showTimelineBox(TimelineBoxId){
	if($('#'+TimelineBoxId).css('display') == 'none')
	{
		$("#"+TimelineBoxId).css('display','block');
	}	
}

function addInput(TimelineBoxId,innerId,val,TextBoxId,column,pricegroupid){
	$('#'+innerId).val(val);
	$("#"+TimelineBoxId).hide();
	$("#"+TextBoxId).focus();
	updatePlan(column,pricegroupid,val);
}

function clearMainCompany(closebtn,compid,compaddid){
	document.getElementById(closebtn).style.display="none";
	$("#"+compid).removeAttr('disabled',false);
	$("#"+compid).val('');
	$("#Company_Name").val('NA');
	$("#"+compaddid).val('');
	$("#compuniquecregrefid").val('');
	$("#MainContactCloseBtn").click();	
	$.each([ 1, 2, 3, 4, 5 ], function( index, value ) {
		closeContactBox('contact_box'+value);
		removeAddedContact('AddContact'+value);
	});
}

function updateContactDetails(contactid,colname,colvalueid){
	setTimeout(function(){
		updateContact(contactid,colname,colvalueid);
	},100);	
}
function updateContact(contactid,colname,colvalueid){
	var colvalue=document.getElementById(colvalueid).value.trim();
	if(colvalue!=""){
		var salesid=$("#SalesId").val();
		showLoader();
		$.ajax({
			type : "POST",
			url : "UpdateContactToVirtual111",
			dataType : "HTML",
			data : {				
				contactid : contactid,
				colname : colname,
				colvalue : colvalue,
				salesid : salesid
			},
			success : function(data){
				if(data=="pass"){
					document.getElementById('errorMsg1').innerHTML = 'Updated ..';
					$('.alert-show1').show().delay(1000).fadeOut();
				}else{
					document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try Sometime later !!';
					$('.alert-show').show().delay(4000).fadeOut();
				}
			},
			complete : function(data){
				hideLoader();
			}
		});		
	}
}
function updatePlan(column,groupid,colvalue){
	var key=document.getElementById(groupid).value;
	if(colvalue!=null&&colvalue!=""){
	showLoader();
	$.ajax({
		type : "POST",
		url : "UpdateProductPlan111",
		dataType : "HTML",
		data : {				
			key : key,
			column : column,
			colvalue : colvalue
		},
		success : function(data){
			if(data!="pass"){				
				document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try Sometime later !!';
				$('.alert-show').show().delay(4000).fadeOut();
			}
		},
		complete : function(data){
			hideLoader();
		}
	});}
}

function clearMainContact(AddContact,conEmail1,conMobile1,conEmail2,conMobile2,MainContactCloseBtn,MainSubDivCont,marginid,SecondContact){
	
	document.getElementById(AddContact).value="";
	document.getElementById(conEmail1).value="";
	document.getElementById(conMobile1).value="";
	document.getElementById(conEmail2).value="";
	document.getElementById(conMobile2).value="";
	
	$("#"+marginid).css('margin-bottom','20px');
	$("#"+AddContact).removeAttr('disabled',false);
	$("#"+conEmail1).removeAttr('disabled',false);
	$("#"+conMobile1).removeAttr('disabled',false);
	
	document.getElementById(MainSubDivCont).style.display="none";
	document.getElementById(SecondContact).style.display="none";
	
	document.getElementById(MainContactCloseBtn).style.display="none";
	
	removeAddedContact(AddContact);
}
function removeAddedContact(contactboxid){
	var salesid=$("#SalesId").val();
	showLoader();
	$.ajax({
		type : "POST",
		url : "RemoveContactToVirtual111",
		dataType : "HTML",
		data : {				
			contactboxid : contactboxid,
			salesid : salesid
		},
		success : function(data){
			if(data=="pass"){
				
			}else{
				document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try Sometime later !!';
				$('.alert-show').show().delay(4000).fadeOut();
			}
		},
		complete : function(data){
			hideLoader();
		}
	});
}
function showCloseBtn(closeBtnid){
	if(document.getElementById('AddContact').value==""){
		document.getElementById(closeBtnid).style.display="none";
	}else{
		document.getElementById(closeBtnid).style.display="block";
	}
}

function addContactToCart(contactid,email,mobile,contactkeyid){	
	showLoader();
	setTimeout(function(){
	processRequest(contactid,email,mobile,contactkeyid);	
	}, 1000);
}
function processRequest(contactid,email1,mobile1,contactkeyid){
	var key=$("#"+contactkeyid).val();
	var name=$("#"+contactid).val();
	var email=$("#"+email1).val();
	var mobile=$("#"+mobile1).val();
	var salesid=$("#SalesId").val();
	if(key!=null&&key!='')
	$.ajax({
		type : "POST",
		url : "AddContactToVirtual111",
		dataType : "HTML",
		data : {				
			contactid : contactid,
			name : name,
			email : email,
			mobile : mobile,
			salesid : salesid,
			key : key
		},
		success : function(data){
			if(data!="pass"){				
				document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try Sometime later !!';
				$('.alert-show').show().delay(4000).fadeOut();
			}
		},
		complete : function(msg) {
            hideLoader();
        }
	});
	else hideLoader();
}
function validatePayment(event){
	
	var pymtforrefid=$("#WhichPaymentFor").val().trim();
	var pymtmode=$("#PaymentMode").val().trim();
	var pymtdate=$("#PaymentDate").val().trim();
	var pymttransid=$("#TransactionId").val().trim();
	var pymtamount=$("#Amount").val().trim();
	
	if(pymtmode==""&&pymtdate==""&&pymttransid==""&&pymtamount==""&&$("#ChooseFile").val().trim()==""){
		document.getElementById('errorMsg').innerHTML ="Register payment via one of them methods..";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	
	if(pymtmode!=""||pymtdate!=""||pymttransid!=""||pymtamount!=""){
		
		if(pymtmode==""){
			document.getElementById('errorMsg').innerHTML ="Select Payment Mode.";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if(pymtdate==""){
			document.getElementById('errorMsg').innerHTML ="Select Payment Date.";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if(pymttransid==""){
			document.getElementById('errorMsg').innerHTML ="Enter Transaction Id.";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if(pymtamount==""){
			document.getElementById('errorMsg').innerHTML ="Enter Transaction Amount.";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
	}else{
		if($("#ChooseFile").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="Upload Payment Receipt.";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		
	}
	
       //stop submit the form, we will post it manually.
       event.preventDefault();
      
       // Get form
       var form = $('#UploadFormdata')[0];

	// Create an FormData object
       var data = new FormData(form);
	
	// disabled the submit button
       $("#btnSubmit").prop("disabled", true);
		showLoader();
       $.ajax({
           type: "POST",
           enctype: 'multipart/form-data',
           url: "RegisterPayment111",
           data: data,
           processData: false,
           contentType: false,
           cache: false,
           timeout: 600000,
           success: function (data) {
        	   if(data=="pass"){
	        	   $("#UploadFormdata").trigger('reset');               
	               $("#btnSubmit").prop("disabled", false);
	               document.getElementById('errorMsg1').innerHTML ="Successfully payment added.";
	       		   $('.alert-show1').show().delay(4000).fadeOut();
	       		showAllPayment(document.getElementById('WhichPaymentFor').value);
	       		   
        	   }else{
        		   document.getElementById('errorMsg').innerHTML ="Something Went Wrong, Try-Again later.";
	       		   $('.alert-show').show().delay(4000).fadeOut();
        	   }

           },
           error: function (e) {
               console.log("ERROR : ", e);
               $("#btnSubmit").prop("disabled", false);

           },
			complete : function(data){
				hideLoader();
			}
       });	
}

function validateSuperUser(){
	let super_name=$("#super_name").val();
	let super_email=$("#super_email").val();
	let super_mobile=$("#super_mobile").val();
	if(super_name==null||super_name==""){
		document.getElementById('errorMsg').innerHTML ="Please enter name !!";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(super_email==null||super_email==""){
		document.getElementById('errorMsg').innerHTML ="Please enter email !!";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if(super_mobile==null||super_mobile==""){
		document.getElementById('errorMsg').innerHTML ="Please enter mobile !!";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	
	$.ajax({
		type : "POST",
		url : "SaveClientSuperUser111",
		dataType : "HTML",
		data : {				
			super_name : super_name,
			super_email : super_email,
			super_mobile : super_mobile
		},
		success : function(data){
			if(data=="exist"){
				document.getElementById('errorMsg').innerHTML = 'Either mobile or email already exist !!';
				$('.alert-show').show().delay(4000).fadeOut();
			}else if(data=="pass"){
				let selectId=$("#add_super_user_id").val();
				setClientSuperUser(selectId,"NA"); 
				$("#super_user_form")[0].reset();
				$("#add_super_user").modal("hide");
				document.getElementById('errorMsg1').innerHTML = 'Super User Registered Successfully !!';
				$('.alert-show1').show().delay(4000).fadeOut();
			}else{
				document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try Sometime later !!';
				$('.alert-show').show().delay(4000).fadeOut();
			}
		},
		complete : function(msg) {
            hideLoader();
        }
	});
	
}

function validateSale(){  
	
	let saleType=$("input[name=saleType]:checked").val();
	let superUser=$("#Enq_Super_User").val();
	
	if(superUser==null||superUser==""){
		document.getElementById('errorMsg').innerHTML ="Select Super User.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	
	if($("#Company_Name").val()==null||$("#Company_Name").val().trim()==""){
		$("#Comp_Name").val("....");
	}
	if($("#AddContact").val()==null||$("#AddContact").val().trim()==""){
		document.getElementById('errorMsg').innerHTML ="Minimum One Contact is mandatory.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if($("#conEmail1").val()==null||$("#conEmail1").val().trim()==""){
		document.getElementById('errorMsg').innerHTML ="Contact Person's email is required.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if($("#conMobile1").val()==null||$("#conMobile1").val().trim()==""){
		document.getElementById('errorMsg').innerHTML ="Contact Person's mobile is required.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	
	if(saleType=="1"){	
		if($("#Product_Type").val()==null||$("#Product_Type").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="Select product type.";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if($("#Product_Name").val()==null||$("#Product_Name").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="Select product name.";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if($("#Jurisdiction").val()==null||$("#Jurisdiction").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="Select product jurisdiction.";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		var count=$("#NewProductId").val();
		for(var i=1;i<=Number(count);i++){
			if ($('#Jurisdiction'+i).length&&$('#Jurisdiction'+i).val()==""){
				document.getElementById('errorMsg').innerHTML ="Select product jurisdiction.";
				$('.alert-show').show().delay(4000).fadeOut();
				return false;
				break;
			}
		}
	}else if(saleType=="2"){
		let consultationType=$("input[name=consultationType]:checked").val();
		let consultationFeeType=$("input[name=consultationFeeType]").val();			
		let consultationFee=$("input[name=consultationFee]").val();
		let consultantUaid=$("#consultantUaid").val();
		
		if(consultationType=="Renewal"){
			let consultationRenewalValue=$("input[name=consultationRenewalValue]").val();
			let consultationRenewalType=$("select[name=consultationRenewalType]").val();
			if(consultationRenewalValue==null||consultationRenewalValue==""){
				document.getElementById('errorMsg').innerHTML ="Please enter renewal value..";
				$('.alert-show').show().delay(4000).fadeOut();
				return false;
			}
			if(consultationRenewalType==null||consultationRenewalType==""){
				document.getElementById('errorMsg').innerHTML ="Please select renewal type..";
				$('.alert-show').show().delay(4000).fadeOut();
				return false;
			}			
		}
		
		if(consultantUaid==null||consultantUaid==""){
			document.getElementById('errorMsg').innerHTML ="Please select consultant..";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		
		if(consultationFeeType==null||consultationFeeType==""){
			document.getElementById('errorMsg').innerHTML ="Please enter fee type..";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if(consultationFee==null||consultationFee==""){
			document.getElementById('errorMsg').innerHTML ="Please enter fee..";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
	}
	if($("#Leadsoldby").val()==null||$("#Leadsoldby").val().trim()==""){
		document.getElementById('errorMsg').innerHTML ="Select sales person.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	
	if($("#orderNo").val()==null||$("#orderNo").val().trim()==""){
		document.getElementById('errorMsg').innerHTML ="Enter order number.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	
	if($("#purchaseDate").val()==null||$("#purchaseDate").val().trim()==""){
		document.getElementById('errorMsg').innerHTML ="Please select purchase date.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	
	if($("#Notes").val()==null||$("#Notes").val().trim()==""){
		document.getElementById('errorMsg').innerHTML ="Invoice notes is required.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if($("#Remarks").val()==null||$("#Remarks").val().trim()==""){
		document.getElementById('errorMsg').innerHTML ="Remarks is required.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	$("#Comp_Name").removeAttr('disabled',false);
	showLoader();
	var estimateNo="<%=enquid%>";
	$.ajax({
		type : "GET",
		url : "IsContactCorrect111",
		dataType : "HTML",
		data : {				
			estimateNo:estimateNo
		},
		success : function(data){
			if(data=="pass"){
				document.getElementById('errorMsg').innerHTML ="Please remove contact and again select from contact box !!";
				$('.alert-show').show().delay(8000).fadeOut();
				return false;
			}else{
				$(".bt-loadmore").attr("disabled","disabled");
				$("#addenq").submit();
			}
		}
	});	
	setTimeout(() => {
		hideLoader();
	}, 3000);
}

function makeid(length) {
	   var result           = '';
	   var characters       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
	   var charactersLength = characters.length;
	   for ( var i = 0; i < length; i++ ) {
	      result += characters.charAt(Math.floor(Math.random() * charactersLength));
	   }
	   return result;
	}

function validateUpdateContact(){

	if($("#UpdateContactFirstName").val()==null||$("#UpdateContactFirstName").val().trim()==""){
		document.getElementById('errorMsg').innerHTML ="First name is mandatory.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if($("#UpdateContactLastName").val()==null||$("#UpdateContactLastName").val().trim()==""){
		document.getElementById('errorMsg').innerHTML ="Last name is mandatory";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if($("#UpdateContactEmail_Id").val()==null||$("#UpdateContactEmail_Id").val().trim()==""){
		document.getElementById('errorMsg').innerHTML ="Email is mandatory";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if($("#UpdateContactEmailId2").val()==null||$("#UpdateContactEmailId2").val().trim()==""){
		$("#UpdateContactEmailId2").val("NA");
	}
	if($("#UpdateContPan").val()==null||$("#UpdateContPan").val().trim()==""){
		$("#UpdateContPan").val("NA");
	}
	if($("#UpdateContactWorkPhone").val()==null||$("#UpdateContactWorkPhone").val().trim()==""){
		document.getElementById('errorMsg').innerHTML ="Work phone is mandatory";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if($("#UpdateContactMobilePhone").val()==null||$("#UpdateContactMobilePhone").val().trim()==""){
		$("#UpdateContactMobilePhone").val('NA')
	}
	if($("#UpdateContactWorkPhone").val().length<10){
		document.getElementById('errorMsg').innerHTML ="Please enter valid 10 digit number !!";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if($('#UpdateContactperAddress').prop('checked')){
		if($("#UpdateContCountry").val()==null||$("#UpdateContCountry").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="Country is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if($("#UpdateContCity").val()==null||$("#UpdateContCity").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="City is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if($("#UpdateContState").val()==null||$("#UpdateContState").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="State is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if($("#UpdateContAddress").val()==null||$("#UpdateContAddress").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="Address is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
	}
	var firstname=$("#UpdateContactFirstName").val().trim();
	var lastname=$("#UpdateContactLastName").val().trim();
	var email=$("#UpdateContactEmail_Id").val().trim();
	var email2=$("#UpdateContactEmailId2").val().trim();
	var workphone=$("#UpdateContactWorkPhone").val().trim();
	var mobile=$("#UpdateContactMobilePhone").val().trim();
	var pan=$("#UpdateContPan").val().trim();
	var country="NA";
	var city="NA";
    var state="NA";
    var stateCode="NA";
    var address="NA";
    var companyaddress="NA";
    var addresstype="Personal";
    if($('#UpdateContactperAddress').prop('checked')){
    	country=$("#UpdateContCountry").val();
    	var x=country.split("#");
    	country=x[1];
    	state=$("#UpdateContState").val();
    	x=state.split("#");
    	stateCode=x[1];
    	state=x[2];
    	city=$("#UpdateContCity").val();
    	
    	address=$("#UpdateContAddress").val().trim();    	
    }
    if($('#UpdateContactcomAddress').prop('checked')){
		companyaddress=$("#UpdateEnqCompAddress").val().trim();
		addresstype="Company";
    }
//    var clientKey=$("#compuniquecregrefid").val();
//    if(clientKey==null||clientKey=="")clientKey="NA";
   var contkey=$("#UpdateContactKey").val().trim(); 
   var contid=$("#OpenContactId").val();
   var salesid=$("#SalesId").val();
//         alert(contkey);
showLoader();
$("#ValidateUpdateContact").attr("disabled","disabled");
	$.ajax({
		type : "POST",
		url : "UpdateContactDetails111",
		dataType : "HTML",
		data : {				
			firstname : firstname,
			lastname : lastname,
			email : email,
			email2 : email2,
			workphone : workphone,
			mobile : mobile,
			city : city,
			state : state,
			address : address,
			companyaddress : companyaddress,
			addresstype : addresstype,
			contkey : contkey,
			contid:contid,
			salesid:salesid,
			pan : pan,
			country : country,
			stateCode : stateCode
		},
		success : function(data){
			$("#ValidateUpdateContact").removeAttr("disabled");
			if(data=="pass"){
				document.getElementById('errorMsg1').innerHTML = 'Successfully Updated !!';				  
				 
// 				 alert(contid);
				 $("#"+contid).val(firstname+" "+lastname);
// 				 alert($("#"+contid).val());
				 var emaiid=$("#OpenContactEmail1").val();
				 document.getElementById(emaiid).value=email;
			     var mobileid=$("#OpenContactMobile1").val();
			     document.getElementById(mobileid).value=workphone;	
			     var contactrefkey=$("#UpdateContactInputRefid").val();
			     $("#"+contactrefkey).value=contkey;	
			     
				 $('#FormUpdateContactBox').trigger("reset");
				$('.fixed_right_box').removeClass('active');
				$('.addnew').show();
								
				$('.alert-show1').show().delay(4000).fadeOut();
				
// 				addContactToCart(contid,emaiid,mobileid,contactrefkey);
								
			}else{
				document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try Sometime later !!';
				$('.alert-show').show().delay(4000).fadeOut();
			}
		},
		complete : function(msg) {
            hideLoader();
        }
	});
}

function validateContact(){

	if($("#Enq_Super_User").val()==null||$("#Enq_Super_User").val().trim()==""){
		document.getElementById('errorMsg').innerHTML ="Please select Client's Admin.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	
	if($("#ContactFirstName").val()==null||$("#ContactFirstName").val().trim()==""){
		document.getElementById('errorMsg').innerHTML ="First name is mandatory.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if($("#ContactLastName").val()==null||$("#ContactLastName").val().trim()==""){
		document.getElementById('errorMsg').innerHTML ="Last name is mandatory";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if($("#ContactEmail_Id").val()==null||$("#ContactEmail_Id").val().trim()==""){
		document.getElementById('errorMsg').innerHTML ="Email is mandatory";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if($("#ContactEmailId2").val()==null||$("#ContactEmailId2").val().trim()==""){
		$("#ContactEmailId2").val("NA");
	}
	if($("#ContactPan").val()==null||$("#ContactPan").val().trim()==""){
		$("#ContactPan").val("NA");
	}
	if($("#ContactWorkPhone").val()==null||$("#ContactWorkPhone").val().trim()==""){
		document.getElementById('errorMsg').innerHTML ="Work phone is mandatory";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if($("#ContactWorkPhone").val().length<10){
		document.getElementById('errorMsg').innerHTML ="Please enter valid 10 digit number !!";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
// 	if($("#ContactMobilePhone").val()==null||$("#ContactMobilePhone").val().trim()==""){
// 		document.getElementById('errorMsg').innerHTML ="Mobile number is mandatory";
// 		$('.alert-show').show().delay(4000).fadeOut();
// 		return false;
// 	}
	
	if($('#ContactperAddress').prop('checked')){
		if($("#ContCity").val()==null||$("#ContCity").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="City is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if($("#ContState").val()==null||$("#ContState").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="State is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
		if($("#ContAddress").val()==null||$("#ContAddress").val().trim()==""){
			document.getElementById('errorMsg').innerHTML ="Address is mandatory";
			$('.alert-show').show().delay(4000).fadeOut();
			return false;
		}
	}
	var firstname=$("#ContactFirstName").val().trim();
	var lastname=$("#ContactLastName").val().trim();
	var email=$("#ContactEmail_Id").val().trim();
	var email2=$("#ContactEmailId2").val().trim();
	var workphone=$("#ContactWorkPhone").val().trim();
	var mobile=$("#ContactMobilePhone").val().trim();
	var pan=$("#ContactPan").val().trim();
	let super_user_id=$("#Enq_Super_User").val();
	
	if(mobile==null||mobile=="")mobile="NA";
	var country="NA";
    var city="NA";
    var state="NA";
    var stateCode="NA";
    var address="NA";
    var companyaddress="NA";
    var addresstype="Personal";
    if($('#ContactperAddress').prop('checked')){
    	country=$("#ContCountry").val(); 
    	var x=country.split("#");
    	country=x[1];
    	state=$("#ContState").val();
    	x=state.split("#");
    	stateCode=x[1];
    	state=x[2];
    	city=$("#ContCity").val();
    	address=$("#ContAddress").val().trim();    	
    }
    if($('#ContactcomAddress').prop('checked')){
		companyaddress=$("#EnqCompAddress").val().trim();
		addresstype="Company";
    }
   
    var compname="....";
    if($("#Company_Name").val()!=null&&$("#Company_Name").val().trim()!=""&&$("#Company_Name").val().trim()!="NA"){
    	compname=$("#Company_Name").val().trim();
    }
    var CompanyRefId=$("#compuniquecregrefid").val();
    if(compname=="....")CompanyRefId="NA";
    
    if($("#Company_Name").val()!=null&&$("#Company_Name").val()!=""&&CompanyRefId=="NA"&&compname!="...."){
    	document.getElementById('errorMsg').innerHTML ="Some data not loaded please reload this page and select client and contact !!";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
    }    
    var salesid=$("#SalesId").val();
    var contid=$("#OpenContactId").val();
    var key=makeid(40);
    showLoader();
	$.ajax({
		type : "POST",
		url : "RegisterNewContact777",
		dataType : "HTML",
		data : {				
			firstname : firstname,
			lastname : lastname,
			email : email,
			email2 : email2,
			workphone : workphone,
			mobile : mobile,
			city : city,
			state : state,
			address : address,
			companyaddress : companyaddress,
			compname : compname,
			addresstype : addresstype,
			key : key,
			CompanyRefId : CompanyRefId,
			salesid:salesid,
			contid:contid,
			pan : pan,
			country : country,
			stateCode : stateCode,
			super_user_id : super_user_id
		},
		success : function(data){
			if(data=="pass"){
				document.getElementById('errorMsg1').innerHTML = 'Successfully Contact Added !!';				  
				 $("#"+contid).val(firstname+" "+lastname);
				 var emaiid=$("#OpenContactEmail1").val();
				 $("#"+emaiid).val(email);
			     var mobileid=$("#OpenContactMobile1").val();
			     $("#"+mobileid).val(workphone);	
			     var contactrefkey=$("#UpdateContactInputRefid").val();
			     $("#"+contactrefkey).val(key);	
			     var marginid=$("#OpenContactSubDivMarginid").val();	
			     var divid=$("#OpenContactSubDiv").val();			     	
			     $("#"+marginid).css('margin-bottom','0px');
			 	$('#'+divid).show();
				 $('#FormContactBox').trigger("reset");
				$('.fixed_right_box').removeClass('active');
				$('.addnew').show();
								
				$('.alert-show1').show().delay(4000).fadeOut();
				$('#AddContactKeyId').val(key);
// 				addContactToCart(contid,emaiid,mobileid,'AddContactKeyId');
				
				$('#'+contid).attr('disabled',true);
            	$('#'+emaiid).attr('disabled',true);
            	$('#'+mobileid).attr('disabled',true);
				showCloseBtn('MainContactCloseBtn')
				
			}else if(data=="invalid"){
				document.getElementById('errorMsg').innerHTML = 'Please enter a valid email !! !!';
				$('.alert-show').show().delay(4000).fadeOut();
			}else{
				document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try Sometime later !!';
				$('.alert-show').show().delay(4000).fadeOut();
			}
		},
		complete : function(msg) {
            hideLoader();
        }
	});
}

function validateUpdateCompany(){	       
	if($("#UpdateCompanyName").val().trim()==""){
		document.getElementById('errorMsg').innerHTML ="Company Name is mandatory.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if($("#UpdateIndustry_Type").val().trim()==""){
		document.getElementById('errorMsg').innerHTML ="Industry type is mandatory";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	
	if($("#Update_Super_User").val()==null||$("#Update_Super_User").val().trim()==""){
		document.getElementById('errorMsg').innerHTML ="Select Super User";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	
	if($("#UpdatePanNumber").val().trim()==""){
		document.getElementById('errorMsg').innerHTML ="Pan Number is mandatory";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if($("#UpdateGSTNumber").val().trim()==""){
		$("#UpdateGSTNumber").val("NA");
	}
	
	if($("#Edit_Company_age").val().trim()==""){
		document.getElementById('errorMsg').innerHTML ="Company age is mandatory !!";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	
	if($("#UpdateCity").val().trim()==""){
		document.getElementById('errorMsg').innerHTML ="City is mandatory";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if($("#UpdateState").val().trim()==""){
		document.getElementById('errorMsg').innerHTML ="State is mandatory";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if($("#UpdateCountry").val().trim()==""){
		document.getElementById('errorMsg').innerHTML ="Country is mandatory";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if($("#UpdateAddress").val().trim()==""){
		document.getElementById('errorMsg').innerHTML ="Address is mandatory";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	
	var industrytype=$("#UpdateIndustry_Type").val();
	let superUser=$("#Update_Super_User").val();
	var pan=$("#UpdatePanNumber").val();
	var gstin=$("#UpdateGSTNumber").val();
	var city=$("#UpdateCity").val();
	var state=$("#UpdateState").val();
	var stateCode="";
	var x=state.split("#");
	state=x[2];
	stateCode=x[1];
	
	var country=$("#UpdateCountry").val();
	var x=country.split("#");
	country=x[1];
	var address=$("#UpdateAddress").val();
	var companyAge=$("#Edit_Company_age").val();
	var companykey=$("#compuniquecregrefid").val();
	showLoader();
	$.ajax({
		type : "POST",
		url : "UpdateNewCompany777",
		dataType : "HTML",
		data : {				
			industrytype : industrytype,
			pan : pan,
			gstin : gstin,
			city : city,
			state : state,
			country : country,
			address : address,
			companykey : companykey,
			companyAge : companyAge,
			stateCode : stateCode,
			superUser : superUser
		},
		success : function(data){
			if(data=="pass"){
				document.getElementById('errorMsg1').innerHTML = 'Successfully Updated !!';
				$("#CompAddress").val(address);	
				$("#compuniquecregrefid").val(companykey);	
				$('#UpdateRegCompany').trigger("reset");
				
				$('.fixed_right_box').removeClass('active');
				$('.addnew').show();
								
				$('.alert-show1').show().delay(4000).fadeOut();
			}else{
				document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try Sometime later !!';
				$('.alert-show').show().delay(4000).fadeOut();
			}
		},
		complete : function(msg) {
            hideLoader();
        }
	});
}

function validateCompany(){	   
		
	if($("#CompanyName").val()==null||$("#CompanyName").val().trim()==""){
		document.getElementById('errorMsg').innerHTML ="Company Name is mandatory.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if($("#Industry_Type").val()==null||$("#Industry_Type").val().trim()==""){
		document.getElementById('errorMsg').innerHTML ="Industry type is mandatory";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	
	if($("#Super_User").val()==null||$("#Super_User").val().trim()==""){
		document.getElementById('errorMsg').innerHTML ="Select Super User";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	
	if($("#GSTNumber").val()==null||$("#GSTNumber").val().trim()==""){
		$("#GSTNumber").val("NA");
	}
	if($("#Company_age").val()==null||$("#Company_age").val().trim()==""){
		document.getElementById('errorMsg').innerHTML ="Company age is mandatory !!";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if($("#City").val()==null||$("#City").val().trim()==""){
		document.getElementById('errorMsg').innerHTML ="City is mandatory";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if($("#State").val()==null||$("#State").val().trim()==""){
		document.getElementById('errorMsg').innerHTML ="State is mandatory";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if($("#Country").val()==null||$("#Country").val().trim()==""){
		document.getElementById('errorMsg').innerHTML ="Country is mandatory";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	if($("#Address").val()==null||$("#Address").val().trim()==""){
		document.getElementById('errorMsg').innerHTML ="Address is mandatory";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	
	var compname=$("#CompanyName").val();
	var industrytype=$("#Industry_Type").val();
	let superUser=$("#Super_User").val();
	var pan=$("#PanNumber").val();
	if(pan==null||pan=="")pan="NA";
	var gstin=$("#GSTNumber").val();
	var city=$("#City").val();
	var state=$("#State").val();
	var x=state.split("#");
	state=x[2];	
	var stateCode=x[1];
	var country=$("#Country").val();
	var y=country.split("#");
	country=y[1];	
	var address=$("#Address").val();
	var compAge=$("#Company_age").val();
	var clientkey=makeid(40);
	showLoader();
	$.ajax({
		type : "POST",
		url : "RegisterNewCompany777",
		dataType : "HTML",
		data : {				
			compname : compname,
			industrytype : industrytype,
			pan : pan,
			gstin : gstin,
			city : city,
			state : state,
			country : country,
			address : address,
			clientkey : clientkey,
			compAge : compAge,
			stateCode : stateCode,
			superUser : superUser
		},
		success : function(data){
			if(data=="pass"){
				document.getElementById('errorMsg1').innerHTML = 'Successfully registered !!';
				$("#Comp_Name").val(compname);
				$("#Company_Name").val(compname);
				$("#CompAddress").val(address);	
				$("#compuniquecregrefid").val(clientkey);	
				$("#Comp_Name").attr("disabled",true);
            	document.getElementById("MainCompanyCloseBtn").style.display="block";
            	
				$('#RegCompany').trigger("reset");
				
				$('.fixed_right_box').removeClass('active');
				$('.addnew').show();
								
				$('.alert-show1').show().delay(4000).fadeOut();
			}else{
				document.getElementById('errorMsg').innerHTML = 'Something went wrong , Try Sometime later !!';
				$('.alert-show').show().delay(4000).fadeOut();
			}
		},
		complete : function(msg) {
            hideLoader();
        }
	});
}

function showHideChangePopUp(id){
	  var div= document.querySelector('#'+id);
	  div.style.display= 'block';
	  div.style.left='0px';
	  div.style.top='40px';
	}
function hideMouseMove(id){
	var div= document.querySelector('#'+id);
	div.style.display= 'none';
}

function updatePayment(){
	if($("#Product_Type").val().trim()==""){
		document.getElementById('errorMsg').innerHTML = 'Select Product to update price !!?';
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}else{
		var product=$("#Product_Type").val().trim();
		document.getElementById("PaymentProduct").innerHTML=product;
		if($("#DisplayPayment").val()=="1"){
			$("#DisplayPayment").val("2");
			document.getElementById("UpdatePaymentBtn").innerHTML="Hide Payment Details";
			$('#Payment').css('display','block');
		}else{
			$("#DisplayPayment").val("1");
			document.getElementById("UpdatePaymentBtn").innerHTML="Add Received Payment";
			$('#Payment').css('display','none');
		}
	}
}

function searchContact(searchId,emailid,mobileid,marginid,divid,contactrefid){
	
let suaid=$("#Enq_Super_User").val();
if(suaid==null||suaid==""||suaid.length<=0){
	document.getElementById('errorMsg').innerHTML = "Please select Client's Admin !!";
	$('.alert-show').show().delay(4000).fadeOut();
	return false;
}
	
$(function() {
	$("#"+searchId).autocomplete({
		source : function(request, response) {
			if(document.getElementById(searchId).value.trim().length>=1)
			$.ajax({
				url : "<%=request.getContextPath()%>/getCompanyDetails.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field: "companynameContact",
					suaid : suaid
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.label,
							value : item.value,
							email : item.email,
							mobile : item.mobile,
							key : item.key
						};
					}));
				},
				error : function(error) {
					alert('error: ' + error.responseText);
				}
			});
		},
		change: function (event, ui) {
            if(!ui.item){     
            	document.getElementById('errorMsg').innerHTML ="Select from list";
            	$('.alert-show').show().delay(2000).fadeOut();
            	$("#"+searchId).val("");  
            	$("#"+emailid).val("");
            	$("#"+mobileid).val("");
            	$("#"+contactrefid).val("");
            }else{
            	$("#"+searchId).val(ui.item.value);
            	$("#"+emailid).val(ui.item.email);
            	$("#"+mobileid).val(ui.item.mobile);
            	$("#"+contactrefid).val(ui.item.key);
            	
            	$('#'+searchId).attr('disabled',true);
            	$('#'+emailid).attr('disabled',true);
            	$('#'+mobileid).attr('disabled',true);
            	$("#Comp_Name").attr("readonly","readonly");
            	
            	$("#"+marginid).css('margin-bottom','0px');
            	$('#'+divid).show();            	
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});
}

$(function() {
	$("#Comp_Name").autocomplete({
		source : function(request, response) {
			let suaid=$("#Enq_Super_User").val();
			if(suaid==null||suaid==""||suaid.length<=0){
				document.getElementById('errorMsg').innerHTML = "Please select Client's Admin !!";
				$('.alert-show').show().delay(4000).fadeOut();
				return false;
			}
			if($("#Comp_Name").val().length>=1)
			$.ajax({
				url : "<%=request.getContextPath()%>/getCompanyDetails.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field: "companyname",
					suaid : suaid
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.label,
							value : item.value,
							address : item.address,
							cregrefid  : item.cregrefid
						};
					}));
				},
				error : function(error) {
					alert('error: ' + error.responseText);
				}
			});
		},
		change: function (event, ui) {
            if(!ui.item){     
            	document.getElementById('errorMsg').innerHTML ="Select from list";
            	$('.alert-show').show().delay(2000).fadeOut();
            	$("#Comp_Name").val("");  
            	$("#CompAddress").val("");
            }
            else{
            	$("#Company_Name").val(ui.item.value);
            	$("#CompAddress").val(ui.item.address);
            	$("#compuniquecregrefid").val(ui.item.cregrefid);
            	$("#Comp_Name").attr("disabled",true);
            	document.getElementById("MainCompanyCloseBtn").style.display="block";
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});

function getProducts(servicetype,productDiv){
	if(servicetype!=""){
	showLoader();
	$.ajax({
		type : "POST",
		url : "GetServiceType111",
		dataType : "HTML",
		data : {				
			servicetype :servicetype,
		},
		success : function(response){
			if(Object.keys(response).length!=0){
			response = JSON.parse(response);			
			 var len = response.length;
			 
			$("#"+productDiv).empty();
		    $("#"+productDiv).append("<option value=''>"+"Product Name"+"</option>");		    
			for(var i=0;i<len;i++){
				var prodrefid = response[i]['prodrefid'];
				var pname = response[i]['pname'];
				$("#"+productDiv).append("<option value='"+pname+"#"+prodrefid+"'>"+pname+"</option>");
			}
			}
		},
		complete : function(data){
			hideLoader();
		}
	});}else{
		$("#"+productDiv).empty();
	    $("#"+productDiv).append("<option value=''>"+"Product Name"+"</option>");	   
	}
}
function getRemarks(value){	
	 if(value!="Customize"&&value!=""){	
		 document.getElementById('Product_Name').value=value;
		showLoader();
		 $.ajax({
			type : "POST",
			url : "GetRemarks111",
			dataType : "HTML",
			data : {				
				"pname":value,
			},
			success : function(data){
				var x=data.split("#");
				document.getElementById('Remarks').value=x[0];
				document.getElementById('pid').value=x[1];
				document.getElementById('Product_Price').value=x[2];
				document.getElementById('PaymentPrice').innerHTML=x[2];
			},
			complete : function(data){
				hideLoader();
			}
		});}else {
			document.getElementById('Remarks').value="";
			document.getElementById('pid').value="";
			ocument.getElementById('Product_Price').value="";
			document.getElementById('PaymentPrice').innerHTML="";
		}
}

function isUpdateDuplicateMobilePhone(phoneid){
	var contkey=$("#UpdateContactKey").val().trim();
	var val=document.getElementById(phoneid).value.trim();
	if(val!=""&&val!="NA")
	$.ajax({
		type : "POST",
		url : "ExistEditValue111",
		dataType : "HTML",
		data : {"val":val,"field":"updatecontactmobilephone","id":contkey},
		success : function(data){
			if(data=="pass"){
			document.getElementById("errorMsg").innerHTML="Duplicate Mobile Phone.";
			document.getElementById(phoneid).value="";
			$('.alert-show').show().delay(4000).fadeOut();
			}
			
		}
	});
	$("#"+phoneid).val(val.replace(/ /g,''));
}
function isUpdateDuplicateEmail(emailid){
	var contkey=$("#UpdateContactKey").val().trim();
	var val=document.getElementById(emailid).value.trim();
	if(val!=""&&val!="NA")
	$.ajax({
		type : "POST",
		url : "ExistEditValue111",
		dataType : "HTML",
		data : {"val":val,"field":"updatecontactemail","id":contkey},
		success : function(data){
			if(data=="pass"){
			document.getElementById("errorMsg").innerHTML="Duplicate Email-Id.";
			document.getElementById(emailid).value="";
			$('.alert-show').show().delay(4000).fadeOut();
			}
			
		}
	});
}

function isDuplicateEmail(emailid){
	var val=document.getElementById(emailid).value.trim();
	if(val!=""&&val!="NA")
	$.ajax({
		type : "POST",
		url : "ExistValue111",
		dataType : "HTML",
		data : {"val":val,"field":"addcontactemail1"},
		success : function(data){
			if(data=="pass"){
			document.getElementById("errorMsg").innerHTML="Duplicate Email-Id.";
			document.getElementById(emailid).value="";
			$('.alert-show').show().delay(4000).fadeOut();
			}
			
		}
	});
}

function isDuplicateMobilePhone(phoneid){
	var val=document.getElementById(phoneid).value.trim();
	if(val!=""&&val!="NA")
	$.ajax({
		type : "POST",
		url : "ExistValue111",
		dataType : "HTML",
		data : {"val":val,"field":"addcontactmobilephone"},
		success : function(data){
			if(data=="pass"){
			document.getElementById("errorMsg").innerHTML="Duplicate Mobile Phone.";
			document.getElementById(phoneid).value="";
			$('.alert-show').show().delay(4000).fadeOut();
			}
			
		}
	});
	$("#"+phoneid).val(val.replace(/ /g,''));
}

function isDuplicate(transid){
	var val=document.getElementById(transid).value.trim();
	if(val!=""&&val!="NA")
	$.ajax({
		type : "POST",
		url : "ExistValue111",
		dataType : "HTML",
		data : {"val":val,"field":"pymttransid"},
		success : function(data){
			if(data=="pass"){
			document.getElementById("errorMsg").innerHTML="Duplicate Transaction Id.";
			document.getElementById(transid).value="";
			$('.alert-show').show().delay(4000).fadeOut();
			}
			
		}
	});
}

function isExistGST(valueid){
	var val=document.getElementById(valueid).value.trim();
	if(val!=""&&val!="NA")
	$.ajax({
		type : "POST",
		url : "ExistValue111",
		dataType : "HTML",
		data : {"val":val,"field":"isGST"},
		success : function(data){
			if(data=="pass"){
			document.getElementById("errorMsg").innerHTML=val +" is already existed.";
			document.getElementById(valueid).value="";
			$('.alert-show').show().delay(4000).fadeOut();
			}
			
		}
	});
}

function isExistEditGST(valueid){
	var val=document.getElementById(valueid).value.trim();
	var key=$("#UpdateCompanyKey").val().trim();
	if(val!=""&&val!="NA"&&key!=""&&key!="NA")
	$.ajax({
		type : "POST",
		url : "ExistEditValue111",
		dataType : "HTML",
		data : {"val":val,"field":"isEditGST","id":key},
		success : function(data){
			if(data=="pass"){
			document.getElementById("errorMsg").innerHTML=val +" is already existed.";
			document.getElementById(valueid).value="";
			$('.alert-show').show().delay(4000).fadeOut();
			}
			
		}
	});
}

function isExistEditPan(valueid){
	var val=document.getElementById(valueid).value.trim();
	var key=$("#UpdateCompanyKey").val().trim();
	if(val!=""&&val!="NA"&&key!=""&&key!="NA")
	$.ajax({
		type : "POST",
		url : "ExistEditValue111",
		dataType : "HTML",
		data : {"val":val,"field":"isEditPan","id":key},
		success : function(data){
			if(data=="pass"){
			document.getElementById("errorMsg").innerHTML=val +" is already existed.";
			document.getElementById(valueid).value="";
			$('.alert-show').show().delay(4000).fadeOut();
			}
			
		}
	});
}

function isExistPan(valueid){
	var val=document.getElementById(valueid).value.trim();
	if(val!=""&&val!="NA")
	$.ajax({
		type : "POST",
		url : "ExistValue111",
		dataType : "HTML",
		data : {"val":val,"field":"isPan"},
		success : function(data){
			if(data=="pass"){
			document.getElementById("errorMsg").innerHTML=val +" is already existed.";
			document.getElementById(valueid).value="";
			$('.alert-show').show().delay(4000).fadeOut();
			}
			
		}
	});
}
function isExistValue(valueid){
	var val=document.getElementById(valueid).value.trim();
	if(val!=""&&val!="NA")
	$.ajax({
		type : "POST",
		url : "ExistValue111",
		dataType : "HTML",
		data : {"val":val,"field":"isCompany"},
		success : function(data){
			if(data=="pass"){
			document.getElementById("errorMsg").innerHTML=val +" is already existed.";
			document.getElementById(valueid).value="";
			$('.alert-show').show().delay(4000).fadeOut();
			}
			
		}
	});
}

 function activeDisplay(prodname,prodtype,crossbtn,productprice,parendpricediv,newproductid,
		 pricedivrefid,PriceProduct,TotalPriceProduct,SaleProdQty){
	 $('#'+prodname).removeAttr('style');
	 $('#'+prodname).removeAttr('disabled');	 
	 $('#'+prodtype).css('display','block');
	 $('#'+newproductid).css('display','none');
	 $('#'+prodname).val('');
	 $('#'+crossbtn).css('display','none');	 
	 $("#"+SaleProdQty).val("1");
	 removeProductPrice(pricedivrefid,productprice,parendpricediv,PriceProduct,TotalPriceProduct);
	 removeCoupon();
 } 
 function removeProductPrice(pricedivid,productprice,parendpricediv,PriceProduct,TotalPriceProduct){
	 var pricedivrefid=document.getElementById(pricedivid).value.trim();
	 showLoader();
	 $.ajax({
			type : "POST",
			url : "RemoveProductPrices777",
			dataType : "HTML",
			data : {				
				pricedivrefid : pricedivrefid,				
			},
			success : function(data){				
					$('#'+productprice).css('display','none');
					$("."+PriceProduct).remove();
					$("."+TotalPriceProduct).remove();			
				
			},
			complete : function(data){
				hideLoader();
			}
		});	 
 }
 function hideRemove(removeid){
	 $('#'+removeid).css('display','none');
 }
 function showRemove(removeid){
	 $('#'+removeid).css('display','block');
 }
 
var zp=0;
 function setProduct(prodid,crossbtn,producttype,productprice,productname,newproductbtn,pricedropbox,pricedropboxsubamount,pricedivid,PriceProduct,TotalPriceProduct,ProdGroupRefid,removeiconid,jurisdiction){
	 var prod=$("#"+prodid).val();
	 var x=prod.split("#");
	 var prodrefid=x[1];
	 let compKey=$("#compuniquecregrefid").val();
	 showLoader();
	 $.ajax({
			type : "POST",
			url : "IsProductInCart111",
			dataType : "HTML",
			data : {				
				prodrefid : prodrefid,				
			},
			success : function(data){	
				if(data=="fail"){
						var salesid=$("#SalesId").val().trim();
						showLoader();
						 $.ajax({
								type : "POST",
								url : "SetProductInVirtual111",
								dataType : "HTML",
								data : {				
									prodrefid : prodrefid,
									salesid : salesid,
									compKey : compKey
								},
								success : function(response){
								if(Object.keys(response).length!=0){
								response = JSON.parse(response);
								 var len = response.length;	
								 if(removeiconid!="NA"){hideRemove(removeiconid);}								 	
									 $("#"+crossbtn).css('display','block');
									 $('#'+producttype).css('display','none');	 
									 $("#"+newproductbtn).css('display','block');
									 $('#'+productname).attr('disabled','disabled');
									 $('#'+productname).css('appearance','none');
								
								 var subamount=0;
								 var gstAmount=0;
								 var key="NA";
								 var central="";
								 var state="";
								 var global="";
								for(var i=0;i<len;i++){
									var gstRs=0;
									zp++;
									var groupkey = response[i]['groupkey'];
									var prodrefid = response[i]['prodrefid'];
									var pricetype = response[i]['pricetype'];
									var price = response[i]['price'];
									var hsn = response[i]['hsn'];
									var igst = response[i]['igst'];
									var total_price = response[i]['total_price'];
									var vrefid = response[i]['vrefid'];
									var prodno=response[i]['prodno'];
									var TaxId="TaxId"+zp;
									var PriceId="PriceId"+zp;
									var TotalPrice="TotalPrice"+zp;
									var HSNCode="HSNCode"+zp;
									if(i==0){
										global = response[i]['global'];
										central = response[i]['central'];
										state = response[i]['state'];
									}
									key=groupkey;
									subamount=Number(subamount)+Number(total_price);
									gstRs=(Number(total_price)*Number(igst))/100;
									
									gstAmount+=Number(gstRs);
									total_price=Math.ceil(Number(total_price)+Number(gstRs));
									$(''+
									'<div class="clearfix bg_wht link-style12 '+PriceProduct+'">'+
					                '<div class="box-width25 col-xs-1 box-intro-background">'+
					                     '<div class="clearfix">'+
					                     '<p class="news-border">'+(i+1)+'</p>'+
					                     '</div>'+
					                 '</div>'+
					                 '<div class="box-width19 col-xs-1 box-intro-background">'+
					                     '<div class="clearfix">'+
					                     '<p class="news-border" title='+pricetype+'>'+pricetype+'</p>'+
					                     '</div>'+
					                 '</div>'+
					                 '<div class="box-width14 col-xs-1 box-intro-background">'+
					                     '<div class="clearfix">'+																																																																																																								
					                     '<p class="news-border"><i class="fa fa-inr" style="position: absolute;margin-left: 5px;margin-top: 5px;"></i><input type="text" class="form-control BrdNone" style="height: 38px;margin-left: 2px;" value="'+price+'" id="'+PriceId+'" onchange="updatePrice(\''+TotalPrice+'\',\''+PriceId+'\',\''+key+'\',\''+vrefid+'\',\''+price+'\',\''+igst+'\')" onkeypress="return isNumberKey(event)"/></p>'+
					                     '</div>'+
					                 '</div>'+    
					                 '<div class="box-width3 col-xs-1 box-intro-background">'+
					                 '<input type="text" name="'+HSNCode+'" id="'+HSNCode+'" value="'+hsn+'" class="form-control bdrnone" autocomplete="off" placeholder="HSN for tax" readonly="readonly">'+
									      '</div>'+
					                 '<div class="box-width14 col-xs-6 box-intro-background">'+
					                     '<div class="clearfix">'+
					                     '<p class="news-border"><input type="text" class="form-control BrdNone" id="'+TaxId+'" style="height: 38px;margin-left: 2px;" value="'+igst+'%'+'" readonly="readonly"/></p>'+
					                     '</div>'+
					                 '</div>'+
					                 '<div class="box-width14 col-xs-6 box-intro-background">'+
					                     '<div class="clearfix">'+
					                     '<p class="news-border"><i class="fa fa-inr" style="position: absolute;margin-left: 5px;margin-top: 5px;"></i><input type="text" class="form-control BrdNone" id="'+TotalPrice+'" value="'+total_price+'" style="height: 38px;margin-left: 2px;" readonly="readonly"/></p>'+
					                     '</div>'+
					                 '</div>'+ 
					              '</div>').insertBefore('#'+pricedropbox);				
								}
								var amountwithgst=Math.ceil(Number(subamount)+Number(gstAmount));
								$(''+
								'<div class="clearfix '+TotalPriceProduct+'">'+					            
								 '<div class="col-xs-6 box-intro-background">'+
					                '<p class="news-border justify_end">Total:</p>'+
					            '</div>'+
					            '<div class="col-xs-2 box-intro-background">'+					               
					                '<p class="news-border"><i class="fa fa-inr" style="position: absolute;margin-left: 5px;margin-top: 5px;"></i><input type="text" class="form-control BrdNone" id="'+key+'" value="'+Math.ceil(Number(subamount))+'" style="height: 38px;margin-left: 2px;" readonly="readonly"/></p>'+
					            '</div>'+ 					         					            
							 '<div class="col-xs-2 box-intro-background">'+
				                '<p class="news-border justify_end">Total + GST :</p>'+
				            '</div>'+
				            '<div class="col-xs-2 box-intro-background">'+					               
				                '<p class="news-border"><i class="fa fa-inr" style="position: absolute;margin-left: 5px;margin-top: 5px;"></i><input type="text" class="form-control BrdNone" id="'+key+'1" value="'+amountwithgst+'" style="height: 38px;margin-left: 2px;" readonly="readonly"/></p>'+
				            '</div>'+ 
				         '</div>').insertBefore('#'+pricedropboxsubamount);
								
								appendJurisdiction(global,central,state,jurisdiction);
								 $("#"+ProdGroupRefid).val(key);
								$("#"+productprice).css('display','block');
								document.getElementById(pricedivid).value=key;			
								 }else{
									 document.getElementById('errorMsg').innerHTML ='Price not Listed , Please set price.';	
									 $("#"+prodid).val('');
							 		    $('.alert-show').show().delay(4000).fadeOut();
								 }
								},
								complete : function(data){
									hideLoader();
								}
							});	
			}else{
				document.getElementById('errorMsg').innerHTML ='Product already in your cart. Increase quantity !!';	
				$("#"+prodid).val('');
				 $('.alert-show').show().delay(4000).fadeOut();
			}},
			complete : function(data){
				hideLoader();
			}
		});	 
 }
 function appendJurisdiction(global,central,state,jurisdiction){
	 $("#"+jurisdiction).empty();
	showLoader();
	 $.ajax({
			type : "GET",
			url : "GetJurisdiction111",
			dataType : "HTML",
			data : {
				global : global,
				central : central,
				state : state
			},
			success : function(data){	
				$("#"+jurisdiction).append(data);	
			},
			complete : function(data){
				hideLoader();
			}
		});		 
 }
 function isExistProduct(prodrefid){
	 setTimeout(function(){
	return true;	 
	 }, 5000);
 }
 function setTaxAndTotal(Select2Id,priceboxid,AppliedTaxId,ProductTotalPriceId,SubtotalId,refkey){
	showLoader();	
	 var price=$("#"+priceboxid).val();
		if(price!=null&&price!=""&&price.length>0){	
		var totaltax=0;		
		var select2val="NA";
		
		var totalamt=Number(price);
		if($('#'+Select2Id).select2('data').length>0){	
			select2val=$("#"+Select2Id).val().toString();
			var x=select2val.split(",");
		for(var i=0;i<x.length;i++){
			var tax=x[i].split("%");
			var gst=tax[0].trim();
			var p=(Number(price)*Number(gst))/100;
			totaltax=Number(totaltax)+Number(p);
		}
		totalamt=Number(totalamt)+Number(totaltax); 
		}
		$("#"+AppliedTaxId).val(totaltax.toFixed(2));
		$("#"+ProductTotalPriceId).val(totalamt.toFixed(2));	
		
		setSubTotalPrice(refkey,totaltax,totalamt,select2val,SubtotalId);
		}else{
			$('#'+Select2Id).val(null).trigger('change');			
		}
		hideLoader();
		return true;
	}
 
 function setSubTotalPrice(refkey,totaltax,totalamt,select2val,pricekey){	
	 showLoader();
		$.ajax({
			type : "POST",
			url : "GetSalesPriceSubTotal111",
			dataType : "HTML",
			data : {
				refkey : refkey,
				totaltax : totaltax,
				totalamt : totalamt,
				select2val : select2val,
				pricekey : pricekey
			},
			success : function(data){	
				var x=data.split("#");
				if(x[0]=="pass"){$("#"+pricekey).val(x[1]);	}else{
					document.getElementById("errorMsg").innerHTML="Something Went Wrong, Try-Again Later.";
					$('.alert-show').show().delay(4000).fadeOut();
				}	
			},
			complete : function(data){
				hideLoader();
			}
		});	
	}
 
</script>
	<script type="text/javascript">

function openCompanyBox(){
	var id = $(".addnewcomp").attr('data-related'); 
	$(id).hide();
	$('.fixed_right_box').addClass('active');
	    $("div.add_inner_box").each(function(){
	        $(this).hide();
	        if($(this).attr('id') == id) {
	            $(this).show();
	        }
	 });	
	    let suid=$("#Enq_Super_User").val();
		setClientSuperUser("Super_User",suid);		
}

function getUpdateCompanyAddress(){
	var compaddress=$("#CompAddress").val().trim();
	$("#UpdateEnqCompAddress").val(compaddress);
}

function getCompanyAddress(){
	var compaddress=$("#CompAddress").val().trim();
	$("#EnqCompAddress").val(compaddress);
}
function UpdateCompanyBox(companyboxid,clientkeyid){
	var textbox=document.getElementById(companyboxid);
	if(textbox.disabled){
		$("#UpdateRegCompany").trigger('reset');
		setClientSuperUser("Update_Super_User","NA");
		fillCompanyDetails(clientkeyid);
		
		var id = $(".updateCompany").attr('data-related'); 
		$(id).hide();
		$('.fixed_right_box').addClass('active');
		    $("div.add_inner_box").each(function(){
		        $(this).hide();
		        if($(this).attr('id') == id) {
		            $(this).show();
		        }
		});	
	}	  
}
function fillCompanyDetails(clientkeyid){
	var clientkey=document.getElementById(clientkeyid).value.trim();
	showLoader();
	$.ajax({
		type : "POST",
		url : "GetCompanyByRefid111",
		dataType : "HTML",
		data : {				
			clientkey : clientkey
		},
		success : function(response){		
		if(Object.keys(response).length!=0){
		response = JSON.parse(response);			
		 var len = response.length;		 
		 if(len>0){ 
		 	var clientkey=response[0]["clientkey"];
			var name=response[0]["name"];
			var industry=response[0]["industry"];
			var pan=response[0]["pan"];
			var gst=response[0]["gst"];
			var city=response[0]["city"];
			var state=response[0]["state"];
			var country=response[0]["country"];
			var address=response[0]["address"];
			var compAge=response[0]["compAge"];
			var stateCode=response[0]["stateCode"];
			var superUserUaid=response[0]["superUserUaid"];			
			       
			$("#UpdateCompanyKey").val(clientkey);$("#UpdateCompanyName").val(name);$("#UpdateIndustry_Type").val(industry);
			$("#UpdatePanNumber").val(pan);$("#Edit_Company_age").val(compAge);$("#Update_Super_User").val(superUserUaid).trigger('change');
			if(gst!=null&&gst.length>0&&gst!=="NA"){
				$("#UpdateGSTNumber").val(gst);
				document.getElementById("CompanyGstDivId").style.display="block";
			}			
			$("#UpdateCity").empty();
			$("#UpdateCity").append("<option value='"+city+"' selected='selected'>"+city+"</option>");
			$("#UpdateState").empty();
			$("#UpdateState").append("<option value='0#"+stateCode+"#"+state+"' selected='selected'>"+state+"</option>");
			$("#UpdateCountry").val(country);
			$("#UpdateAddress").val(address);
			
		 }}
		},
		complete : function(data){
			hideLoader();
		}
	});
}
function reUpdateContact(contactboxid,conEmailid,conMobileid,contactrefid){
	$("#OpenContactId").val(contactboxid);  
	$("#OpenContactEmail1").val(conEmailid);
	$("#OpenContactMobile1").val(conMobileid);
	$("#UpdateContactInputRefid").val(contactrefid);
	var textbox=document.getElementById(contactboxid);
	if(textbox.disabled){
		$('#FormUpdateContactBox').trigger("reset");
		
		fillContactDetails(contactrefid);
		
		var id = $(".updateContact").attr('data-related'); 
		$(id).hide();
		$('.fixed_right_box').addClass('active');
		    $("div.add_inner_box").each(function(){
		        $(this).hide();
		        if($(this).attr('id') == id) {
		            $(this).show();
		        }
		    });	
	}
}
function fillContactDetails(contactrefid){
	var key=document.getElementById(contactrefid).value.trim();

// 	fill update contact form with unique data also fill key into a textbox which will use to update this contact
	if($("#CompAddress").val()==""){
		$("#UpdateContactcomAddress").attr('disabled','disabled');
	}else{
		$("#UpdateContactcomAddress").removeAttr('disabled','disabled');
	}
	showLoader();
	$.ajax({
		type : "POST",
		url : "GetContactByRefid111",
		dataType : "HTML",
		data : {				
			key : key
		},
		success : function(response){		
		if(Object.keys(response).length!=0){
		response = JSON.parse(response);			
		 var len = response.length;		 
		 if(len>0){
		 	var contkey=response[0]["key"];
			var firstname=response[0]["firstname"];
			var lastname=response[0]["lastname"];
			var email1=response[0]["email1"];
			var email2=response[0]["email2"];
			var workphone=response[0]["workphone"];
			var mobilephone=response[0]["mobilephone"];
			var addresstype=response[0]["addresstype"];
			var city=response[0]["city"];
			var state=response[0]["state"];
			var address=response[0]["address"];
			var country=response[0]["country"];
			var pan=response[0]["pan"];
			var stateCode=response[0]["stateCode"];
			
			$("#UpdateContactKey").val(contkey);$("#UpdateContactFirstName").val(firstname);$("#UpdateContactLastName").val(lastname);$("#UpdateContactEmail_Id").val(email1);
			if(email2!=="NA"){
				$("#UpdateContactEmailId2").val(email2);
				document.getElementById("UpdateContactDivId").style.display="block";
			}			
			$("#UpdateContactWorkPhone").val(workphone);$("#UpdateContactMobilePhone").val(mobilephone);
			$("#UpdateContPan").val(pan);
			if(addresstype=="Personal"){
				$("#UpdateContCountry").val(country);
				$("#UpdateContCity").empty();
				$("#UpdateContCity").append("<option value='"+city+"'>"+city+"</option>");
				$("#UpdateContState").empty();
				$("#UpdateContState").append("<option value='0#"+stateCode+"#"+state+"'>"+state+"</option>");
				$("#UpdateContAddress").val(address);	
				$("#UpdateContactperAddress").attr('checked',true);
				$("#UpdateContactcomAddress").attr('checked',false);
				$(".UpdateAddress_box").show();
				$(".UpdateCompany_box").hide();
			}else{
				$("#UpdateContactcomAddress").attr('checked',true);
				$("#UpdateContactperAddress").attr('checked',false);
				$("#UpdateEnqCompAddress").val(address);
				$(".UpdateAddress_box").hide();
				$(".UpdateCompany_box").show();
			}			
			
		 }}
		},
		complete : function(data){
			hideLoader();
		}
	});
	
	
	
}

function openContactBox(boxid,email1,mobile1,marginid,subdivid,contactrefid){
	$("#OpenContactId").val(boxid);  
	$("#OpenContactEmail1").val(email1);
	$("#OpenContactMobile1").val(mobile1);
	$("#UpdateContactInputRefid").val(contactrefid);
	$("#OpenContactSubDivMarginid").val(marginid);
	$("#OpenContactSubDiv").val(subdivid);
	$('.address_box').show();
	if($("#CompAddress").val()==""){
		$("#ContactcomAddress").attr('disabled','disabled');
	}else{
		$("#ContactcomAddress").removeAttr('disabled','disabled');
	}
	$('#FormContactBox').trigger("reset");
	var id = $(".addnew1").attr('data-related'); 
	$(id).hide();
	$('.fixed_right_box').addClass('active');
	    $("div.add_inner_box").each(function(){
	        $(this).hide();
	        if($(this).attr('id') == id) {
	            $(this).show();
	        }
	    });	
}

function fileSize(file){
	const fi=document.getElementById('ChooseFile');
	if (fi.files.length > 0) {
		const fsize = fi.files.item(0).size; 
        const file = Math.round((fsize / 1024)); 
        // The size of the file. 
        if (file >= 4096) {  
            document.getElementById('errorMsg').innerHTML ='File too Big, please select a file less than 4mb';
            $("#ChooseFile").val("");
 		    $('.alert-show').show().delay(4000).fadeOut();
        }		
	}	
}

function openPaymentBox(prodnameid,pricegroupid){
	var x=document.getElementById(prodnameid).value.trim().split("#");
	var prodname=x[0];
	document.getElementById("PymtForAllId").innerHTML="Register Payment of "+prodname;
	var pricegroupval=document.getElementById(pricegroupid).value.trim();
	$("#WhichPaymentFor").val(pricegroupval);
	$('#UploadFormdata').trigger('reset');
	var id = $(".addnew2").attr('data-related'); 
	$('.fixed_right_box').addClass('active');
	    $("div.add_inner_box").each(function(){
	        $(this).hide();
	        if($(this).attr('id') == id) {
	            $(this).show();
	        }
	    });
	    
	showAllPayment(pricegroupval);
}

function showAllPayment(pricegroupval){	
	$('.RegisteredPayment').remove();
	showLoader();
	$.ajax({
		type : "POST",
		url : "ShowAllRegPayment111",
		dataType : "HTML",
		data : {				
			pricegroupval : pricegroupval
		},
		success : function(response){			
		if(Object.keys(response).length!=0){
		response = JSON.parse(response);			
		 var len = response.length;	
		 
		for(var i=0;i<len;i++){			
			var key = response[i]['key'];
			var date = response[i]['date'];
			var amount = response[i]['amount'];
			var docname = response[i]['docname'];
			
			$(''+
					'<div class="clearfix bg_wht link-style12 RegisteredPayment">'+
			   '<div class="box-width6 col-xs-1 box-intro-background">'+
			       '<div class="clearfix">'+
			       '<p class="news-border">'+date+'</p>'+
			       '</div>'+
			   '</div>'+
			   '<div class="box-width28 col-xs-6 box-intro-background">'+
			       '<div class="clearfix">'+
			       '<p class="news-border" title="" style="color:red;">Not Approved</p>'+
			       '</div>'+
			   '</div>'+
			   '<div class="box-width10 col-xs-6 box-intro-background">'+
			       '<div class="clearfix">'+
			       '<p class="news-border"><i class="fa fa-inr"></i>&nbsp; '+amount+'</p>'+
			       '</div>'+
			   '</div>'+
			   '<div class="box-width18 col-xs-6 box-intro-background">'+
			       '<div class="clearfix">'+
			       '<p class="news-border action_div"><a><i class="fa fa-times"></i></a><a><i class="fa fa-trash"></i></a></p>'+
			       '</div>'+
			   '</div>'+ 
			'</div>'
			
          ).insertBefore('#ReceivedPayment');
			
		}}		
		},
		complete : function(data){
			hideLoader();
		}
	});
}

$('.close_box').on( "click", function(e) { 
$('.fixed_right_box').removeClass('active');
$('.addnew').show();	
});
$('.del_icon').on( "click", function(e) {
$('.new_field').hide();	
});
$('.add_new').on( "click", function(e) {
$(this).parent().next().show();	
});
$('#ContactcomAddress').on( "click", function(e) {
$('.address_box').hide();
$('.company_box').show();	
});
$('#UpdateContactcomAddress').on( "click", function(e) {
$('.UpdateAddress_box').hide();
$('.UpdateCompany_box').show();	
});
$('#UpdateContactperAddress').on( "click", function(e) {
$('.UpdateAddress_box').show();
$('.UpdateCompany_box').hide();	
});
$('#ContactperAddress').on( "click", function(e) {
$('.address_box').show();
$('.company_box').hide();	
});

function addNewContact(){
	showLoader();
	var a=$("#ContactId").val().trim();
	var i=Number(a)+1;
	var x="AddNewContact"+i;
	var y="innerContact"+i;
	var z="SecondContact"+i;
	var cbox="contact_box"+i;
	var contactid="AddContact"+i;
	var msgid="divchangeqty"+i;
	var conmobile1="conMobile1"+i;
	var conemail1="conEmail1"+i;
	var conmobile2="conMobile2"+i;
	var conemail2="conEmail2"+i;
	var contactrefid="contactrefid"+i;
	$("#ContactId").val(i);
	
	$(''+
	'<div class="clearfix" id="'+cbox+'">'+ 
	 '<div class="row" id="'+x+'" style="margin-bottom:20px;">'+
	'<div class="col-md-12 col-sm-12 col-xs-12">'+
    '<div class="clearfix relative_box">'+ 
    '<div class="clearfix text-right mb10">'+
    '<button class="addbtn pointers addnew1" type="button" data-related="add_contact"  onclick="openContactBox(\''+contactid+'\',\''+conemail1+'\',\''+conmobile1+'\',\''+x+'\',\''+y+'\',\''+contactrefid+'\')">+ Add New</button>'+
    '</div>'+
    '<div class="input-group">'+
    '<input type="hidden" id="'+contactrefid+'"/>'+
     '<a class="updateContact" data-related="update_contact" onclick="reUpdateContact(\''+contactid+'\',\''+conemail1+'\',\''+conmobile1+'\',\''+contactrefid+'\')"><input type="text" name="contact" id="'+contactid+'" onchange="addContactToCart(\''+contactid+'\',\''+conemail1+'\',\''+conmobile1+'\',\''+contactrefid+'\')" onkeypress="searchContact(\''+contactid+'\',\''+conemail1+'\',\''+conmobile1+'\',\''+x+'\',\''+y+'\',\''+contactrefid+'\')" onclick="showHideChangePopUp(\''+msgid+'\')" onmouseleave="hideMouseMove(\''+msgid+'\')" style="border-radius: 2px;" class="form-control pointers" placeholder="Contact Name"></a>'+
     '<div id="'+msgid+'" style="display:none;width:100%;height:29px;position:absolute;z-index:10;background:rgb(239 239 239);padding-left: 13px;padding-top: 4px;border-radius: 4px;">'+
		  '<span style="color: #4ac4f3;font-size: 14px;">Type to search contact name</span>'+									    
	'</div>'+   
     '</div>'+
     '<div id="contactErrorMSGdiv" class="errormsg"></div>'+ 
	  '<button class="addbtn pointers new_con_add close_icon3" type="button" onclick="closeContactBox(\''+cbox+'\');removeAddedContact(\''+contactid+'\');"><i class="fa fa-times" style="font-size: 21px;"></i></button>'+
    '</div>'+
   '</div>'+
   '</div>'+
   '<div class="clearfix inner_box_bg" id="'+y+'" style="display:none;">'+ 
	 '<div class="row">'+
	 '<div class="col-md-6 col-sm-6 col-xs-12">'+
    '<div class="mb10">'+
     '<div class="input-group">'+     
     '<input type="text" name="'+conemail1+'" id="'+conemail1+'" onchange="updateContactDetails(\''+contactid+'\',\'scvcontactemail1st\',\''+conemail1+'\');" onblur="verifyEmailIdPopup(\''+conemail1+'\')" style="border-radius: 2px;" class="form-control" value="" placeholder="Email">'+
     '</div>'+
     '<div id="connameErrorMSGdiv" class="errormsg"></div>'+
    '</div>'+
   '</div>'+
	'<div class="col-md-6 col-sm-6 col-xs-12">'+
    '<div class="mb10">'+
     '<div class="input-group">'+
     '<input type="text" name="'+conmobile1+'" id="'+conmobile1+'" onchange="updateContactDetails(\''+contactid+'\',\'scvcontactmobile1st\',\''+conmobile1+'\');" onblur="validateMobilePopup(\''+conmobile1+'\')" style="border-radius: 2px;" class="form-control" placeholder="Mobile" onkeypress="return isNumber(event)" maxlength="14">'+
     '</div>'+
     '<div id="connumberErrorMSGdiv" class="errormsg"></div>'+
    '</div>'+
   '</div>'+
   '</div>'+
   '<div class="row" id="'+z+'" style="display: none;">'+
	 '<div class="col-md-6 col-sm-6 col-xs-12">'+
    '<div class="mb10">'+
     '<div class="input-group">'+
     '<input type="text" name="'+conemail2+'" id="'+conemail2+'" onchange="updateContactDetails(\''+contactid+'\',\'scvcontactemail2nd\',\''+conemail2+'\');" onblur="verifyEmailIdPopup(\''+conemail2+'\')" style="border-radius: 2px;" class="form-control" placeholder="Email">'+
     '</div>'+
     '<div id="connameErrorMSGdiv" class="errormsg"></div>'+
    '</div>'+
   '</div>'+
	'<div class="col-md-6 col-sm-6 col-xs-12">'+
    '<div class="mb10">'+
     '<div class="input-group">'+
     '<input type="text" name="'+conmobile2+'" id="'+conmobile2+'" onchange="updateContactDetails(\''+contactid+'\',\'scvcontactmobile2nd\',\''+conmobile2+'\');" onblur="validateMobilePopup(\''+conmobile2+'\')" style="border-radius: 2px;" class="form-control" placeholder="Mobile" onkeypress="return isNumber(event)" maxlength="14">'+
     '</div>'+
     '<button class="addbtn pointers new_con_add2 close_icon2" type="button" onclick="closeContact(\''+z+'\')"><i class="fa fa-times" style="font-size: 21px;"></i></button>'+
     '<div id="connumberErrorMSGdiv" class="errormsg"></div>'+
    '</div>'+
   '</div>'+
   '</div> '+
	'<div class="clearfix text-right">'+ 
    '     <button class="addbtn pointers" type="button" onclick="displayContact(\''+z+'\');">+ Add</button>'+
   '</div>'+
	'</div>'+ 
	'</div>').insertBefore('.NewCompanyContact');
	hideLoader();
}

function addNewProduct(){
	showLoader();
	var a=$("#NewProductId").val().trim();
	var i=Number(a)+1;
	var crossbtn="CloseBtn"+i;
	var producttype="Product_Type"+i;
	var productprice="productPrice"+i;
	var productname="Product_Name"+i;
	var multiprod="MultiProd"+i;
	var onetimeterm="onetime"+i;
	var rentimeterm="renewal"+i;
	var service="timetype"+i;
	var period="ProductPeriod"+i;
	var periodtime="ProductPeriodTime"+i;
	var gstprice="GstPrice"+i;
	var totalprice="TotalPrice"+i;
	var newproductid="NewProductBtn"+i;
	var removeicon="RemoveIcon"+i;
	var PriceDropBox="PriceDropBox"+i;
	var PriceGroupId="PriceGroupId"+i;
	var ProductPriceDiv="ProductPriceDiv"+i;
	var TotalPriceProduct="TotalPriceProduct"+i;
	var PriceProduct="PriceProduct"+i;
	var ProductPlan="ProductPlan"+i;
	var TimelineBox="TimelineBox"+i;
	var SaleProdQty="SaleProdQty"+i;
	var ProdGroupRefid="ProdGroupRefid"+i;
	var PriceDropBoxSubAmount="PriceDropBoxSubAmount"+i;
	$("#NewProductId").val(i);
	
	$(''+
	'<div class="row" id="'+multiprod+'">'+							
	'<div class="col-md-12 col-sm-12 col-xs-12">'+
       '<div class="form-group">'+
       '<div class="clearfix text-right mb10" style="margin-top: 5px;" id="'+removeicon+'">'+
		'<button class="addbtn pointers" type="button" onclick="removeCurrentProduct(\''+multiprod+'\',\''+productprice+'\')">- Remove</button>'+
       '</div>'+
        '<div class="input-group">'+       
        '<select id="'+producttype+'" name="productType" class="form-control" onchange="getProducts(this.value,\''+productname+'\');">'+
            '<option value="">Product Type</option>'+
            '<%for(int i=0;i<servicetype.length;i++){ %>'+
            '<option value="<%=servicetype[i][1]%>"><%=servicetype[i][1]%></option>'+
            '<%}%>'+                                       
       '</select>'+
       '<input type="hidden" name="pid" id="pid">'+
        '</div>'+
        '<div id="productTypeErrorMSGdiv" class="errormsg"></div>'+
       '</div>'+
      '</div>'+
      '<div class="col-md-12 col-sm-12 col-xs-12">'+
       '<div class="form-group relative_box">'+
       '<div class="clearfix text-right">'+
		 '<button class="addbtn pointers " type="button" data-related="add_contact" id="'+newproductid+'" onclick="addNewProduct()" style="display: none;float:right;margin-bottom: 10px;">+ New Product</button>'+
		'</div>'+
        '<div class="input-group">'+     
        '<input type="hidden" id="'+ProdGroupRefid+'" value="NA">'+
        '<select name="product_name" id="'+productname+'" onchange="setProduct(\''+productname+'\',\''+crossbtn+'\',\''+producttype+'\',\''+productprice+'\',\''+productname+'\',\''+newproductid+'\',\''+PriceDropBox+'\',\''+PriceDropBoxSubAmount+'\',\''+PriceGroupId+'\',\''+PriceProduct+'\',\''+TotalPriceProduct+'\',\''+ProdGroupRefid+'\',\''+removeicon+'\',\'Jurisdiction'+i+'\')" class="form-control">'+
          '<option value="">Product Name</option>'+                                  
         '</select>'+
        '</div>'+
        '<div id="product_nameErrorMSGdiv" class="errormsg"></div>'+																	                  
        '<button class="addbtn pointers close_icon3 del_icon" id="'+crossbtn+'" type="button" style="display: none;" onclick="activeDisplay(\''+productname+'\',\''+producttype+'\',\''+crossbtn+'\',\''+productprice+'\',\''+ProductPriceDiv+'\',\''+newproductid+'\',\''+PriceGroupId+'\',\''+PriceProduct+'\',\''+TotalPriceProduct+'\',\''+SaleProdQty+'\');showRemove(\''+removeicon+'\');"><i class="fa fa-times" style="font-size: 21px;"></i></button>'+
       
       '</div>'+
      '</div>'+
	  '</div>'+
	  '<div class="clearfix" id="'+ProductPriceDiv+'">'+
	  '<div class="clearfix inner_box_bg form-group" id="'+productprice+'" style="display: none;">'+
    '<div class="mb10 flex_box align_center relative_box">'+
    '<span class="input_radio bg_wht pad_box2 pad_box3 s_head">'+ 
	'<select class="s_type" name="jurisdiction" id="Jurisdiction'+i+'" onchange="updatePlan(\'spvjurisdiction\',\''+PriceGroupId+'\',this.value);" required="required">'+
	'<option value="">Select Jurisdiction</option>'+									
	'</select>'+								
	'</span>'+
	'<span class="input_radio bg_wht pad_box2 pad_box3">'+
	'<input type="radio" name="'+service+'" id="'+onetimeterm+'" checked="checked" onclick="hideTime(\''+period+'\',\''+TimelineBox+'\',\''+ProductPlan+'\',\''+periodtime+'\');updatePlan(\'spvprodplan\',\''+PriceGroupId+'\',\'OneTime\');">'+
	'<span>One time</span>'+
	'</span>'+
	'<span class="mlft10 input_radio bg_wht pad_box2 pad_box3">'+
	'<input type="radio" name="'+service+'" id="'+rentimeterm+'" onclick="askTime(\''+period+'\');updatePlan(\'spvprodplan\',\''+PriceGroupId+'\',\'Renewal\');">'+
	'<span>Renewal</span>'+
	'</span>'+	
	
	'<span class="mlft10 RenBox1" id="'+period+'" style="width: 129px;">'+
	'<input type="text" name="'+ProductPlan+'" autocomplete="off"  onclick="showTimelineBox(\''+TimelineBox+'\')" onchange="updatePlan(\'spvplantime\',\''+PriceGroupId+'\',this.value);" id="'+ProductPlan+'" class="form-control bdrnone text-right" placeholder="Timeline" style="width: 58%;">'+
    '<input type="text" name="'+periodtime+'" autocomplete="off" id="'+periodtime+'" class="form-control bdrnone pointers" readonly="readonly" style="width: 8%;position: absolute;margin-left: 66px;margin-top: -37px;">'+
	'</span>'+
	'<div class="timelineproduct_box" id="'+TimelineBox+'">'+
	'<div class="timelineproduct_inner">'+
	'<span onclick="addInput(\''+TimelineBox+'\',\''+periodtime+'\',\'Day\',\''+ProductPlan+'\',\'spvplanperiod\',\''+PriceGroupId+'\')">Day</span> <span onclick="addInput(\''+TimelineBox+'\',\''+periodtime+'\',\'Week\',\''+ProductPlan+'\',\'spvplanperiod\',\''+PriceGroupId+'\')">Week</span ><span onclick="addInput(\''+TimelineBox+'\',\''+periodtime+'\',\'Month\',\''+ProductPlan+'\',\'spvplanperiod\',\''+PriceGroupId+'\')">Month</span><span onclick="addInput(\''+TimelineBox+'\',\''+periodtime+'\',\'Year\',\''+ProductPlan+'\',\'spvplanperiod\',\''+PriceGroupId+'\')">Year</span></div>'+
	'</div>'+		
	'<span class="bg_wht pad_box3 qtyBtn">'+
	'<span class="fa fa-minus pointers" onclick="updateProductQty(\''+SaleProdQty+'\',\'minus\',\''+ProdGroupRefid+'\')"></span>'+
	'<input type="text" id="'+SaleProdQty+'" min="1" value="1" onchange="updateProdQty(\''+SaleProdQty+'\',\''+ProdGroupRefid+'\')" onkeypress="return isNumber(event)">'+
	'<span class="fa fa-plus pointers" onclick="updateProductQty(\''+SaleProdQty+'\',\'plus\',\''+ProdGroupRefid+'\')"></span>'+									
	'</span>'+
	'</div>'+
     '<div class="row mb10">'+
       '<div class="col-md-12 col-sm-12 col-xs-12">'+
       
       '<div class="clearfix" id="'+PriceDropBox+'"></div>'+
       '<input type="hidden" name="'+PriceGroupId+'" id="'+PriceGroupId+'"/>'+
       '<div class="clearfix" id="'+PriceDropBoxSubAmount+'"></div>'+    
       
      '</div>'+
      '</div>'+	  
    '</div>'+
    '</div>'+
 '</div>'+
 '</div>'+
 '</div>').insertBefore('.MultipleProduct');
	hideLoader();
}
function updateProdQty(InputBoxId,ProdGroupRefId){
	var prodvirtualid=$("#"+ProdGroupRefId).val();
	var prodqty=$("#"+InputBoxId).val();		
	if(prodvirtualid!="NA"&&prodvirtualid!=""){
		showLoader();
		$.ajax({
		type : "POST",
		url : "UpdateProductsQtyDirect111",
		dataType : "HTML",
		data : {
			prodvirtualid : prodvirtualid,
			prodqty : prodqty
			},
		success : function(data){
			var x=data.split("#");
			if(x[0]=="pass"){				
				document.getElementById("errorMsg1").innerHTML="Updated Successfully.";				
				$("#"+InputBoxId).val(prodqty);		
			$('.alert-show1').show().delay(2000).fadeOut();
			}else if(x[0]=="Not"){	
				document.getElementById("errorMsg").innerHTML="Invalid Input.";		
				$("#"+InputBoxId).val(x[1]);	
			$('.alert-show').show().delay(2000).fadeOut();
			}else{
				document.getElementById("errorMsg").innerHTML="Something Went Wrong, Try After Sometime later.";		
				$("#"+InputBoxId).val(x[1]);	
				$('.alert-show').show().delay(4000).fadeOut();
			}
			
		},
		complete : function(data){
			hideLoader();
		}
	});
	}else{
		document.getElementById("errorMsg").innerHTML="Something Went Wrong, Try After Sometime later.";				
		$('.alert-show').show().delay(4000).fadeOut();
	}
	removeCoupon();
}
		
function updateProductQty(InputBoxId,action,ProdGroupRefid){
	showLoader();
	var prodvirtualid=$("#"+ProdGroupRefid).val();
	var prodqty=$("#"+InputBoxId).val();	
	if(prodvirtualid!="NA"&&prodvirtualid!=""){
	$.ajax({
		type : "POST",
		url : "UpdateProductsQty111",
		dataType : "HTML",
		data : {
			prodvirtualid : prodvirtualid,
			prodqty : prodqty,
			action : action
			},
		success : function(data){
			if(data=="pass"){				
				document.getElementById("errorMsg1").innerHTML="Updated Successfully.";
				if(action=="plus"){prodqty=Number(prodqty)+Number(1);}
				else if(action=="minus"){prodqty=Number(prodqty)-Number(1);}
				$("#"+InputBoxId).val(prodqty);		
			$('.alert-show1').show().delay(2000).fadeOut();
			}else if(data=="Not"){				
				document.getElementById("errorMsg").innerHTML="Invalid Input.";				
			$('.alert-show').show().delay(2000).fadeOut();
			}else{
				document.getElementById("errorMsg").innerHTML="Something Went Wrong, Try After Sometime later.";				
				$('.alert-show').show().delay(4000).fadeOut();
			}
			
		},
		complete : function(msg) {
            hideLoader();
        }
	});
	}else{
		document.getElementById("errorMsg").innerHTML="Something Went Wrong, Try After Sometime later.";				
		$('.alert-show').show().delay(4000).fadeOut();
	}
	removeCoupon();
}

function updatePrice(totalpriceid,priceid,subtotalpriceid,vrefid,minprice,igst){
	var price=$("#"+priceid).val();
	var gstPrice=Math.ceil((Number(price)*Number(igst))/100);
	if(Number(price)>=Number(minprice)){
	showLoader();
	$.ajax({
		type : "POST",
		url : "UpdatePriceOfProduct111",
		dataType : "HTML",
		data : {
			price : price,
			vrefid : vrefid,
			"pricerefid" : subtotalpriceid
			},
		success : function(data){
			var x=data.split("#");
			if(x[0]=="pass"){
				document.getElementById("errorMsg1").innerHTML="Updated.";
				$("#"+totalpriceid).val(Math.ceil(Number(price)+Number(gstPrice)));				
				$("#"+subtotalpriceid).val(Math.ceil(Number(x[1])));	
				$("#"+subtotalpriceid+"1").val(Math.ceil(Number(x[2])));
			$('.alert-show1').show().delay(3000).fadeOut();
			}else{
				document.getElementById("errorMsg").innerHTML="Something Went Wrong, Try After Sometime later.";				
				$('.alert-show').show().delay(4000).fadeOut();
			}
			
		},
		complete : function(data){
			hideLoader();
		}
	});
	}else{
		document.getElementById("errorMsg").innerHTML="Not Permission to reduce price, You may only increase price !!";		
		$("#"+priceid).val(minprice);
		$('.alert-show').show().delay(4000).fadeOut();
	}
}
function hideTime(ProductPeriod,Timelinebox,Timelinevalue,Timelineunit){
	$("#"+ProductPeriod).hide();
	$("#"+Timelinebox).hide();
	$("#"+Timelinevalue).val('');
	$("#"+Timelineunit).val('');
}
function askTime(ProductPeriod){
	$("#"+ProductPeriod).css('display','block');
}

function removeCurrentProduct(ProdBoxId,ProdPriceBox){
	$('#'+ProdBoxId).remove();
	$('#'+ProdPriceBox).remove();
}
function closeContactBox(dispcontactbox){
	$('#'+dispcontactbox).remove();
}
function closeContact(dispcontact){
	$("#"+dispcontact).hide();
}

function displayContact(dispcontact){
	$("#"+dispcontact).show();
}

</script>
	<script type="text/javascript">
$(".select2example").select2({
    placeholder: "Company",
    allowClear: true
});
$(".select2example1").select2({
    placeholder: "Contact",
	//minimumResultsForSearch: Infinity,
    allowClear: true
});
function showRemoveCoupon(data){
	console.log(data);
	if(data==""){
		$(".applyCoupon").hide();	
	}else{
		$(".applyCoupon").show();
	}
}
function removeCoupon(){
	$("#ApplyCoupon").val("");
	$(".discount-value").html("0.0");
	$("#ApplyCoupon").removeAttr("readonly","readonly");
	$(".applyCoupon").show();
	$(".removeCoupon").hide();
}
function applyCoupon(){
	var coupon=$("#ApplyCoupon").val();
	var enquid=$("#enquid").html();
	showLoader();
	$.ajax({
		type : "POST",
		url : "ApplyCouon111",
		dataType : "HTML",
		data : {
			coupon : coupon,
			enquid : enquid
			},
		success : function(data){
			if(data=="invalid"){
				$("#errorMsg").html("Either coupon expired Or Not valid.");
				$("#ApplyCoupon").val("");
				$('.alert-show').show().delay(4000).fadeOut();
			}else if(data=="not"){
				$("#errorMsg").html("Coupon is not applicable for this service.");
				$("#ApplyCoupon").val("");
				$('.alert-show').show().delay(4000).fadeOut();
			}else{
				$("#ApplyCoupon").attr("readonly","readonly");
				$(".applyCoupon").hide();
				$(".removeCoupon").show();
				$(".discount-value").html(data);
			}
		},
		complete : function(data){
			hideLoader();
		}
	});
}
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
function isExistEditPanCon(valueid){
	var val=document.getElementById(valueid).value.trim();
	var key=$("#UpdateContactKey").val();
	if(val!=""&&val!="NA"&&key!=""&&key!="NA")
	$.ajax({
		type : "POST",
		url : "ExistEditValue111",
		dataType : "HTML",
		data : {"val":val,"field":"isEditPanContact","id":key},
		success : function(data){
			if(data=="pass"){
			document.getElementById("errorMsg").innerHTML=val +" is already existed.";
			document.getElementById(valueid).value="";
			$('.alert-show').show().delay(4000).fadeOut();
			}
			
		}
	});
}
$(document).ready(function(){
	$("#purchaseDate").datepicker({
		changeMonth: true,
		changeYear: true,
		yearRange: '-60: -0',
		dateFormat: 'dd-mm-yy'
	});
	$('#Super_User,#Update_Super_User,#Enq_Super_User').select2({
        placeholder: "Select Client's Admin",
        allowClear: true
    });
	$('#consultantUaid').select2({
        placeholder: "Select Consultant",
        allowClear: true
    });
	setClientSuperUser("Enq_Super_User","NA");
	
	$("#useAdminContact").click(function(e){
		e.preventDefault();
		updateExistingContact($("#Enq_Super_User").val());		
	})
	
	$("#Super_User").on("change", function(e) {		
		e.preventDefault();
		$("#Enq_Super_User").val($(this).val()).trigger("change");
	});
	
	$("#Enq_Super_User").on("change", function(e) {		
		e.preventDefault();
		$("#MainCompanyCloseBtn").click();	
		$.each([ 1, 2, 3, 4, 5 ], function( index, value ) {
			closeContactBox('contact_box'+value);
			removeAddedContact('AddContact'+value);
		});
	})
	
	$("input[name=consultationType]").change(function(e){
		e.preventDefault();
		if($(this).val()=="Once"){
			$(".consulting-renewal").hide();
		}else{
			$(".consulting-renewal").show();
		}
	})
	
	$("input[name=saleType]").change(function(e){
		e.preventDefault();
		if($(this).val()=="2"){
			$(".consulting_sale_box").hide();
			$(".consulting-sale").show();
		}else{
			$(".consulting-sale").hide();
			$(".consulting_sale_box").show();
		}
	})	
	
	$("input[name=consultationFee]").change(function(e){
		e.preventDefault();
		$("input[name=consultationHsn]").val("");
    	$("input[name=consultationGst]").val("");
    	$("input[name=consultationFeeTotal]").val($(this).val());		
	})
	
})

function setClientSuperUser(selectId,selectedId){
	$.ajax({
		type : "GET",
		url : "GetClientSuperUser111",
		dataType : "HTML",
		data : {selectedId:selectedId},
		success : function(response){
			$("#"+selectId).empty();
			$("#"+selectId).append(response).trigger('change');
		}
	});
}

function updateExistingContact(uaid){
	if(uaid==null||uaid==""){
		document.getElementById('errorMsg').innerHTML ="Select Client's Admin.";
		$('.alert-show').show().delay(4000).fadeOut();
		return false;
	}
	$.ajax({
		type : "GET",
		url : "GetClientSuperUserByUaid111",
		dataType : "HTML",
		data : {uaid:uaid},
		success : function(response){
			if(Object.keys(response).length!=0){
				response = JSON.parse(response);			
				let firstName = response[0]['firstName'];
				let lastName = response[0]['lastName'];
				let email = response[0]['email'];
				let mobile = response[0]['mobile'];
				$("#ContactFirstName").val(firstName);
				$("#ContactLastName").val(lastName);
				$("#ContactEmail_Id").val(email);
				$("#ContactWorkPhone").val(mobile);
			}
		}
	});
}
function addSuperUser(selectId){
	$("#add_super_user_id").val(selectId);
	$("#add_super_user").modal("show");	
}
$(function() {
	$("input[name=consultationHsn]").autocomplete({
		source : function(request, response) {
			$.ajax({
				url : "<%=request.getContextPath()%>/getnewproduct.html",
				type : "POST",
				dataType : "JSON",
				data : {
					name : request.term,
					field: "salehsntax",
				},
				success : function(data) {
					response($.map(data, function(item) {
						return {  
							label : item.name,
							value : item.value,
							hsn : item.hsn,							
							igst : item.igst
						};
					}));
				},
				error : function(error) {
					alert('error: ' + error.responseText);
				}
			});
		},
		select: function (event, ui) {
            if(!ui.item){     
            	document.getElementById('errorMsg').innerHTML ="Select from tax list";
            	$('.alert-show').show().delay(2000).fadeOut();
            	$("input[name=consultationHsn]").val("");  
            	$("input[name=consultationGst]").val(""); 
            	$("input[name=consultationFeeTotal]").val(""); 
            }
            else{   
            	let gstPercent=Number(ui.item.igst);
            	$("input[name=consultationHsn]").val(ui.item.hsn);
            	$("input[name=consultationGst]").val(gstPercent+" %");
            	let amount=$("input[name=consultationFee]").val();
            	if(Number(amount)>0&&Number(gstPercent)>0){
            		let gstAmount=(Number(amount)*Number(gstPercent))/100;
            		let totalAmount=Math.ceil(Number(amount)+Number(gstAmount));
            		$("input[name=consultationFeeTotal]").val(totalAmount);
            	}else{
            		document.getElementById('errorMsg').innerHTML ="Please enter Consultation Fee !!";
                	$('.alert-show').show().delay(2000).fadeOut();
            	}
            }
        },
        error : function(error){
			alert('error: ' + error.responseText);
		},
	});
});
</script>
</body>
</html>