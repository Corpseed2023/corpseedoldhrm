<!doctype html>

<%@page import="commons.CommonHelper"%>
<%@page import="hcustbackend.ClientACT"%> 
<html lang="en">
<head>  
  <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<!-- for fakeloading -->
    <%@ include file="includes/client-header-css.jsp" %>   
        
    <title>CorpSeed-dashboard</title>
</head>
<body id="mySite">

  <div class="fakeLoader"></div>
<!-- main content starts -->
<%@ include file="includes/checkvalid_client.jsp" %>
<%
//get token no from session 
String token=(String)session.getAttribute("uavalidtokenno");
String uaempid=(String)session.getAttribute("uaempid");
// get client number from session
String client[][]=ClientACT.getClientByNo(uaempid,token);
%>
<section class="main  clearfix">
  <%@ include file="includes/client_header_menu.jsp" %>  

  <section class="main-order dash clearfix">
  <div class="container-fluid">
    <div class="container">
      <div class="row">
        <div class="col-12 p-0">
          <div class="box-dashboard">
            
			<!-- searchboxes starts -->
            <div class="clearfix">
			<div class="clearfix" id="dashboard_box1">
			  <div class="box_width80 center_box">
			  <div class="searchbox-dashboard"> 
			  <div class="searchbox_feature pre_feature_box wow flipInX"> 
			  <div class="clearfix">
			  <h1 class="text-center wow fadeIn">Setup your business <strong>easily</strong></h1>
              <div class="form-group-dashboard pt-3">
                <!--
				<div class="form-group-input">
                <select class="form-control-search" id="searchCountry">
                <option>India</option>
                </select>
                </div>
				-->
                <div class="form-group-input"> 
				<input class="form-control-search" autocomplete="off" type="search" onkeyup="getServices(this.value)" onsearch="getServices('')" id="searchService" aria-label="Search" placeholder="Try FSSAI">
				<i><svg focusable="false" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M15.5 14h-.79l-.28-.27A6.471 6.471 0 0 0 16 9.5 6.5 6.5 0 1 0 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"></path></svg></i>
				<div class="clearfix" id="AppendService" style="display:none">
				    <ul id="appendServices">
					
					</ul>
				</div>
				</div>
                <!--<button class="btn default bg" id="search" type="submit" onClick="">Book Now</button>-->
              </div>
			  </div> 
			  
			  <div class="row mtop50">  
                <div class="col-sm-4 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0">
                  <div class="step-content-block" onClick="openBox('1')">
                  <div class="feature_content_block">
                    <div class="content_block_title">
                    <h3>Start Company</h3>
                    <div class="button_block">
                    <i class="fas fa-angle-down arwicon"></i>
                    <i class="fas fa-check arwicon1"></i>
                    <a class="add_btn1 pointers" href="javascript:void(0)">Apply</a>
                    </div>
                    </div>
					<div class="content_block_img"> 
					<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/db_img1.svg" alt=""> 
					</div>
                    <div class="content_block_txt">
                    Corporations are structured on the idea that control and ownership can be separate. Owners are called shareholders and they may or may not be involved in the day-to-day operations of the company.
                    </div>
                  </div>
                  </div>
                </div>
                <div class="col-sm-4 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0"> 
                  <div class="step-content-block" onClick="openBox('2')">
                  <div class="feature_content_block">
                    <div class="content_block_title">
                    <h3>Financial Services</h3>
                    <div class="button_block">
                    <i class="fas fa-angle-down arwicon"></i>
                    <i class="fas fa-check arwicon1"></i>
                    <a class="add_btn1 pointers" href="javascript:void(0)">Apply</a>
                    </div>
                    </div>
					<div class="content_block_img">
					<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/db_img2.svg" alt=""> 
					</div>
                    <div class="content_block_txt">
                    Corporations are structured on the idea that control and ownership can be separate. Owners are called shareholders and they may or may not be involved in the day-to-day operations of the company.
                    </div>
                  </div>
                  </div>
                </div>
                <div class="col-sm-4 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0"> 
                  <div class="step-content-block" onClick="openBox('3')">
                  <div class="feature_content_block">
                    <div class="content_block_title">
                    <h3>Pollution Advisory</h3>
                    <div class="button_block">
                    <i class="fas fa-angle-down arwicon"></i>
                    <i class="fas fa-check arwicon1"></i>
                    <a class="add_btn1 pointers" href="javascript:void(0)">Apply</a>
                    </div>
                    </div>
					<div class="content_block_img">
					<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/db_img3.svg" alt=""> 
					</div>
                    <div class="content_block_txt">
                    Corporations are structured on the idea that control and ownership can be separate. Owners are called shareholders and they may or may not be involved in the day-to-day operations of the company.
                    </div>
                  </div>
                  </div>
                </div>
                <div class="col-sm-4 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0"> 
                  <div class="step-content-block" onClick="openBox('4')">
                  <div class="feature_content_block">
                    <div class="content_block_title">
                    <h3>License & Certification</h3>
                    <div class="button_block">
                    <i class="fas fa-angle-down arwicon"></i>
                    <i class="fas fa-check arwicon1"></i>
                    <a class="add_btn1 pointers" href="javascript:void(0)">Apply</a>
                    </div>
                    </div>
					<div class="content_block_img">
					<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/db_img4.svg" alt=""> 
					</div>
                    <div class="content_block_txt">
                    Corporations are structured on the idea that control and ownership can be separate. Owners are called shareholders and they may or may not be involved in the day-to-day operations of the company.
                    </div>
                  </div>
                  </div>
                </div>
                <div class="col-sm-4 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0">
                  <div class="step-content-block" onClick="openBox('5')">
                  <div class="feature_content_block">
                    <div class="content_block_title">
                    <h3>Changes In Business</h3>
                    <div class="button_block">
                    <i class="fas fa-angle-down arwicon"></i>
                    <i class="fas fa-check arwicon1"></i>
                    <a class="add_btn1 pointers" href="javascript:void(0)">Apply</a>
                    </div>
                    </div>
					<div class="content_block_img">
					<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/db_img5.svg" alt=""> 
					</div>
                    <div class="content_block_txt">
                    Corporations are structured on the idea that control and ownership can be separate. Owners are called shareholders and they may or may not be involved in the day-to-day operations of the company.
                    </div>
                  </div>
                  </div>
                </div>
                <div class="col-sm-4 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0"> 
                  <div class="step-content-block" onClick="openBox('6')">
                  <div class="feature_content_block">
                    <div class="content_block_title">
                    <h3>Business Compliance</h3> 
                    <div class="button_block" id="bg-color32">
                    <i class="fas fa-angle-down arwicon"></i>
                    <i class="fas fa-check arwicon1"></i>
                    <a class="add_btn1 pointers" href="javascript:void(0)">Apply</a>
                    </div>
                    </div>
					<div class="content_block_img">
					<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/db_img6.svg" alt="">
					</div>
                    <div class="content_block_txt">
                    Corporations are structured on the idea that control and ownership can be separate. Owners are called shareholders and they may or may not be involved in the day-to-day operations of the company.
                    </div>
                  </div>
                  </div>
                </div>
              </div>
			  
			  <div class="coupon_box text-left mt-5 d-none"> 
			  <div class="row"> 
			    <div class="col-md-8 col-sm-8 col-12">
				  <div class="feature_info">
				    <a class="pointers">  
				    <h3>Apply coupon for <label>50% OFF</label></h3>
					<h3><span>CORP50</span> on new business registration</h3>
					</a>
				  </div>
				</div>
				<div class="col-md-4 col-sm-4 col-12">
				  <div class="feature_thumb">
				    <img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/coupon_img.jpg" alt="">
				  </div>
				</div>
			  </div>
			  </div>
			  
			  </div>
			  
			  <div class="searchbox_feature next_feature_box nft_box1 wow flipInX"> 
			  <div class="clearfix">
			  <h1 class="text-center wow fadeIn">Setup your business <strong>easily</strong></h1>
			  </div>
			  <div class="row mtop50">  
                <div class="col-sm-4 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0">
                  <div class="step-content-block">
                  <div class="feature_content_block">
                    <div class="content_block_title">
                    <h3>Start Business In India</h3>
                    <div class="button_block" id="bg-color1">
                    <i class="fas fa-angle-down arwicon"></i>
                    <i class="fas fa-check arwicon1"></i>
                    <a class="add_btn1 pointers" href="javascript:void(0)" id="Applied1" onclick="applyService('Applied1','bg-color1','Start Business In India')">Apply</a>
                    </div>
                    </div>
					<div class="content_block_img">
					<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/db_img1.svg" alt=""> 
					</div>
                    <div class="content_block_txt">
                    Corporations are structured on the idea that control and ownership can be separate. Owners are called shareholders and they may or may not be involved in the day-to-day operations of the company.
                    </div>
                  </div>
                  </div>
                </div>
                <div class="col-sm-4 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0"> 
                  <div class="step-content-block">
                  <div class="feature_content_block">
                    <div class="content_block_title">
                    <h3>Start Finance Business</h3>
                    <div class="button_block" id="bg-color2">
                    <i class="fas fa-angle-down arwicon"></i>
                    <i class="fas fa-check arwicon1"></i>
                    <a class="add_btn1 pointers" href="javascript:void(0)" id="Applied2" onclick="applyService('Applied2','bg-color2','Start Finance Business')">Apply</a>
                    </div>
                    </div>
					<div class="content_block_img">
					<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/db_img2.svg" alt=""> 
					</div>
                    <div class="content_block_txt">
                    Corporations are structured on the idea that control and ownership can be separate. Owners are called shareholders and they may or may not be involved in the day-to-day operations of the company.
                    </div>
                  </div>
                  </div>
                </div>
                <div class="col-sm-4 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0"> 
                  <div class="step-content-block">
                  <div class="feature_content_block">
                    <div class="content_block_title">
                    <h3>Global Business Set Up</h3>
                    <div class="button_block" id="bg-color3">
                    <i class="fas fa-angle-down arwicon"></i>
                    <i class="fas fa-check arwicon1"></i>
                    <a class="add_btn1 pointers" href="javascript:void(0)" id="Applied3" onclick="applyService('Applied3','bg-color3','Global Business Set Up')">Apply</a>
                    </div>
                    </div>
					<div class="content_block_img">
					<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/db_img3.svg" alt=""> 
					</div>
                    <div class="content_block_txt">
                    Corporations are structured on the idea that control and ownership can be separate. Owners are called shareholders and they may or may not be involved in the day-to-day operations of the company.
                    </div>
                  </div>
                  </div>
                </div>
                <div class="col-sm-4 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0"> 
                  <div class="step-content-block">
                  <div class="feature_content_block">
                    <div class="content_block_title">
                    <h3>NGO</h3>
                    <div class="button_block" id="bg-color4">
                    <i class="fas fa-angle-down arwicon"></i>
                    <i class="fas fa-check arwicon1"></i>
                    <a class="add_btn1 pointers" href="javascript:void(0)" id="Applied4" onclick="applyService('Applied4','bg-color4','NGO')">Apply</a>
                    </div>
                    </div>
					<div class="content_block_img">
					<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/db_img4.svg" alt=""> 
					</div>
                    <div class="content_block_txt">
                    Corporations are structured on the idea that control and ownership can be separate. Owners are called shareholders and they may or may not be involved in the day-to-day operations of the company.
                    </div>
                  </div>
                  </div>
                </div>
                <div class="col-sm-4 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0">
                  <div class="step-content-block">
                  <div class="feature_content_block">
                    <div class="content_block_title">
                    <h3>Insurance Business</h3>
                    <div class="button_block" id="bg-color5">
                    <i class="fas fa-angle-down arwicon"></i>
                    <i class="fas fa-check arwicon1"></i>
                    <a class="add_btn1 pointers" href="javascript:void(0)" id="Applied5" onclick="applyService('Applied5','bg-color5','Insurance Business')">Apply</a>
                    </div>
                    </div>
					<div class="content_block_img">
					<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/db_img5.svg" alt=""> 
					</div>
                    <div class="content_block_txt">
                    Corporations are structured on the idea that control and ownership can be separate. Owners are called shareholders and they may or may not be involved in the day-to-day operations of the company.
                    </div>
                  </div>
                  </div>
                </div>
                <div class="col-sm-4 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0"> 
                  <div class="step-content-block">
                  <div class="feature_content_block">
                    <div class="content_block_title">
                    <h3>Stock  Business</h3>
                    <div class="button_block" id="bg-color6">
                    <i class="fas fa-angle-down arwicon"></i>
                    <i class="fas fa-check arwicon1"></i>
                    <a class="add_btn1 pointers" href="javascript:void(0)" id="Applied6" onclick="applyService('Applied6','bg-color6','Stock  Business')">Apply</a>
                    </div>
                    </div>
					<div class="content_block_img">
					<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/db_img6.svg" alt="">
					</div>
                    <div class="content_block_txt">
                    Corporations are structured on the idea that control and ownership can be separate. Owners are called shareholders and they may or may not be involved in the day-to-day operations of the company.
                    </div>
                  </div>
                  </div>
                </div>
				<div class="col-sm-12 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0"> 
				<div class="row search-center">
				<div class="col-sm-12 col-12">  
				<a href="#" class="bg_gray btn default-search"><i class="bg_circle fa fa-check"></i> Setup your business</a> 
				<button type="button" class="btn default-search fback_btn" onClick="reverseBox()"><i class="fas fa-angle-left"></i> &nbsp Back</button> 
				</div>
				
				</div>
				</div>   
              </div>
			  </div>
			  
			  <div class="searchbox_feature next_feature_box nft_box2 wow flipInX"> 
			  <div class="clearfix">
			  <h1 class="text-center wow fadeIn">Operate your Financial Service with <strong>ease!</strong></h1> 
			  </div>
			  <div class="row mtop50">  
                <div class="col-sm-4 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0">
                  <div class="step-content-block">
                  <div class="feature_content_block">
                    <div class="content_block_title">
                    <h3>Finance Consulting</h3>
                    <div class="button_block" id="bg-color7">
                    <i class="fas fa-angle-down arwicon"></i>
                    <i class="fas fa-check arwicon1"></i>
                    <a class="add_btn1 pointers" href="javascript:void(0)" id="Applied7" onclick="applyService('Applied7','bg-color7','Finance Consulting')">Apply</a>
                    </div>
                    </div>
					<div class="content_block_img">
					<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/db_img1.svg" alt=""> 
					</div>
                    <div class="content_block_txt">
                    Corporations are structured on the idea that control and ownership can be separate. Owners are called shareholders and they may or may not be involved in the day-to-day operations of the company.
                    </div>
                  </div>
                  </div>
                </div>
                <div class="col-sm-4 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0"> 
                  <div class="step-content-block">
                  <div class="feature_content_block">
                    <div class="content_block_title">
                    <h3>Business Audit & Litigation</h3>
                    <div class="button_block" id="bg-color8">
                    <i class="fas fa-angle-down arwicon"></i>
                    <i class="fas fa-check arwicon1"></i>
                    <a class="add_btn1 pointers" href="javascript:void(0)" id="Applied8" onclick="applyService('Applied8','bg-color8','Business Audit & Litigation')">Apply</a>
                    </div>
                    </div>
					<div class="content_block_img">
					<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/db_img2.svg" alt=""> 
					</div>
                    <div class="content_block_txt">
                    Corporations are structured on the idea that control and ownership can be separate. Owners are called shareholders and they may or may not be involved in the day-to-day operations of the company.
                    </div>
                  </div>
                  </div>
                </div>
                <div class="col-sm-4 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0"> 
                  <div class="step-content-block">
                  <div class="feature_content_block">
                    <div class="content_block_title">
                    <h3>Finance Business Compliance</h3>
                    <div class="button_block" id="bg-color9">
                    <i class="fas fa-angle-down arwicon"></i>
                    <i class="fas fa-check arwicon1"></i>
                    <a class="add_btn1 pointers" href="javascript:void(0)" id="Applied9" onclick="applyService('Applied9','bg-color9','Finance Business Compliance')">Apply</a>
                    </div>
                    </div>
					<div class="content_block_img">
					<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/db_img3.svg" alt=""> 
					</div>
                    <div class="content_block_txt">
                    Corporations are structured on the idea that control and ownership can be separate. Owners are called shareholders and they may or may not be involved in the day-to-day operations of the company.
                    </div>
                  </div>
                  </div>
                </div>
                <div class="col-sm-4 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0"> 
                  <div class="step-content-block">
                  <div class="feature_content_block">
                    <div class="content_block_title">
                    <h3>Stock Business Compliance</h3>
                    <div class="button_block" id="bg-color10">
                    <i class="fas fa-angle-down arwicon"></i>
                    <i class="fas fa-check arwicon1"></i>
                    <a class="add_btn1 pointers" href="javascript:void(0)" id="Applied10" onclick="applyService('Applied10','bg-color10','Stock Business Compliance')">Apply</a>
                    </div>
                    </div>
					<div class="content_block_img">
					<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/db_img4.svg" alt=""> 
					</div>
                    <div class="content_block_txt">
                    Corporations are structured on the idea that control and ownership can be separate. Owners are called shareholders and they may or may not be involved in the day-to-day operations of the company.
                    </div>
                  </div>
                  </div>
                </div>                
				<div class="col-sm-12 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0"> 
				<div class="row search-center">
				<div class="col-sm-12 col-12"> 
				<a href="#" class="bg_gray btn default-search"><i class="bg_circle fa fa-check"></i> LLC vs Corporation - <br>Which one best for me?</a> 
				<button type="button" class="btn default-search fback_btn" onClick="reverseBox()"><i class="fas fa-angle-left"></i> &nbsp Back</button> 
				</div>
				
				</div>
				</div>   
              </div>
			  </div>
			  
			  <div class="searchbox_feature next_feature_box nft_box3 wow flipInX"> 
			  <div class="clearfix">
			  <h1 class="text-center wow fadeIn">Get your compliances done <strong>today!</strong></h1>
			  </div>
			  <div class="row mtop50">  
                <div class="col-sm-4 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0">
                  <div class="step-content-block">
                  <div class="feature_content_block">
                    <div class="content_block_title">
                    <h3>Pollution Authorization</h3>
                    <div class="button_block" id="bg-color11">
                    <i class="fas fa-angle-down arwicon"></i>
                    <i class="fas fa-check arwicon1"></i>
                    <a class="add_btn1 pointers" href="javascript:void(0)" id="Applied11" onclick="applyService('Applied11','bg-color11','Pollution Authorization')">Apply</a>
                    </div>
                    </div>
					<div class="content_block_img">
					<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/db_img1.svg" alt=""> 
					</div>
                    <div class="content_block_txt">
                    Corporations are structured on the idea that control and ownership can be separate. Owners are called shareholders and they may or may not be involved in the day-to-day operations of the company.
                    </div>
                  </div>
                  </div>
                </div>
                <div class="col-sm-4 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0"> 
                  <div class="step-content-block">
                  <div class="feature_content_block">
                    <div class="content_block_title">
                    <h3>Recycling Plant</h3>
                    <div class="button_block" id="bg-color12">
                    <i class="fas fa-angle-down arwicon"></i>
                    <i class="fas fa-check arwicon1"></i>
                    <a class="add_btn1 pointers" href="javascript:void(0)" id="Applied12" onclick="applyService('Applied12','bg-color12','Recycling Plant')">Apply</a>
                    </div>
                    </div>
					<div class="content_block_img">
					<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/db_img2.svg" alt=""> 
					</div>
                    <div class="content_block_txt">
                    Corporations are structured on the idea that control and ownership can be separate. Owners are called shareholders and they may or may not be involved in the day-to-day operations of the company.
                    </div>
                  </div>
                  </div>
                </div>
                <div class="col-sm-4 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0"> 
                  <div class="step-content-block">
                  <div class="feature_content_block">
                    <div class="content_block_title">
                    <h3>Waste Management</h3>
                    <div class="button_block" id="bg-color13">
                    <i class="fas fa-angle-down arwicon"></i>
                    <i class="fas fa-check arwicon1"></i>
                    <a class="add_btn1 pointers" href="javascript:void(0)" id="Applied13" onclick="applyService('Applied13','bg-color13','Waste Management')">Apply</a>
                    </div>
                    </div>
					<div class="content_block_img">
					<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/db_img3.svg" alt=""> 
					</div>
                    <div class="content_block_txt">
                    Corporations are structured on the idea that control and ownership can be separate. Owners are called shareholders and they may or may not be involved in the day-to-day operations of the company.
                    </div>
                  </div>
                  </div>
                </div>  
                <div class="col-sm-4 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0"> 
                  <div class="step-content-block">
                  <div class="feature_content_block">
                    <div class="content_block_title">
                    <h3>Others Services</h3>
                    <div class="button_block" id="bg-color14">
                    <i class="fas fa-angle-down arwicon"></i>
                    <i class="fas fa-check arwicon1"></i>
                    <a class="add_btn1 pointers" href="javascript:void(0)" id="Applied14" onclick="applyService('Applied14','bg-color14','Others Services')">Apply</a>
                    </div>
                    </div>
					<div class="content_block_img">
					<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/db_img4.svg" alt=""> 
					</div>
                    <div class="content_block_txt">
                    Corporations are structured on the idea that control and ownership can be separate. Owners are called shareholders and they may or may not be involved in the day-to-day operations of the company.
                    </div>
                  </div>
                  </div>
                </div>
				<div class="col-sm-12 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0"> 
				<div class="row search-center">
				<div class="col-sm-12 col-12">
				<a href="#" class="bg_gray btn default-search"><i class="bg_circle fa fa-check"></i> Know your regulatory compliances</a> 
			<button type="button" class="btn default-search fback_btn" onClick="reverseBox()"><i class="fas fa-angle-left"></i> &nbsp Back</button> 
				</div> 
				
				</div>
				</div>   
              </div>
			  </div>
			  
			  <div class="searchbox_feature next_feature_box nft_box4 wow flipInX"> 
			  <div class="clearfix">
			  <h1 class="text-center wow fadeIn">Get Your <strong>IEC Code Today!</strong></h1>
			  </div>
			  <div class="row mtop50">  
                <div class="col-sm-4 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0">
                  <div class="step-content-block">
                  <div class="feature_content_block">
                    <div class="content_block_title">
                    <h3>Business License</h3>
                    <div class="button_block" id="bg-color15">
                    <i class="fas fa-angle-down arwicon"></i>
                    <i class="fas fa-check arwicon1"></i>
                    <a class="add_btn1 pointers" href="javascript:void(0)" id="Applied15" onclick="applyService('Applied15','bg-color15','Business License')">Apply</a>
                    </div>
                    </div>
					<div class="content_block_img">
					<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/db_img1.svg" alt=""> 
					</div>
                    <div class="content_block_txt">
                    Corporations are structured on the idea that control and ownership can be separate. Owners are called shareholders and they may or may not be involved in the day-to-day operations of the company.
                    </div>
                  </div>
                  </div>
                </div>
                <div class="col-sm-4 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0"> 
                  <div class="step-content-block">
                  <div class="feature_content_block">
                    <div class="content_block_title">
                    <h3>Business Certifications</h3>
                    <div class="button_block" id="bg-color16">
                    <i class="fas fa-angle-down arwicon"></i>
                    <i class="fas fa-check arwicon1"></i>
                    <a class="add_btn1 pointers" href="javascript:void(0)" id="Applied16" onclick="applyService('Applied16','bg-color16','Business Certifications')">Apply</a>
                    </div>
                    </div>
					<div class="content_block_img">
					<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/db_img2.svg" alt=""> 
					</div>
                    <div class="content_block_txt">
                    Corporations are structured on the idea that control and ownership can be separate. Owners are called shareholders and they may or may not be involved in the day-to-day operations of the company.
                    </div>
                  </div>
                  </div>
                </div>
                <div class="col-sm-4 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0"> 
                  <div class="step-content-block">
                  <div class="feature_content_block">
                    <div class="content_block_title">
                    <h3>Quality Certification</h3>
                    <div class="button_block" id="bg-color17">
                    <i class="fas fa-angle-down arwicon"></i>
                    <i class="fas fa-check arwicon1"></i>
                    <a class="add_btn1 pointers" href="javascript:void(0)" id="Applied17" onclick="applyService('Applied17','bg-color17','Quality Certification')">Apply</a>
                    </div>
                    </div>
					<div class="content_block_img">
					<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/db_img3.svg" alt=""> 
					</div>
                    <div class="content_block_txt">
                    Corporations are structured on the idea that control and ownership can be separate. Owners are called shareholders and they may or may not be involved in the day-to-day operations of the company.
                    </div>
                  </div>
                  </div>
                </div>
                <div class="col-sm-4 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0"> 
                  <div class="step-content-block">
                  <div class="feature_content_block">
                    <div class="content_block_title">
                    <h3>Intellectual Property</h3>
                    <div class="button_block" id="bg-color18">
                    <i class="fas fa-angle-down arwicon"></i>
                    <i class="fas fa-check arwicon1"></i>
                    <a class="add_btn1 pointers" href="javascript:void(0)" id="Applied18" onclick="applyService('Applied18','bg-color18','Intellectual Property')">Apply</a>
                    </div>
                    </div>
					<div class="content_block_img">
					<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/db_img4.svg" alt=""> 
					</div>
                    <div class="content_block_txt">
                    Corporations are structured on the idea that control and ownership can be separate. Owners are called shareholders and they may or may not be involved in the day-to-day operations of the company.
                    </div>
                  </div>
                  </div>
                </div>               
				<div class="col-sm-12 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0"> 
				<div class="row search-center">
				<div class="col-sm-12 col-12">
				<a href="#" class="bg_gray btn default-search"><i class="bg_circle fa fa-check"></i> Import Export - <br>Why to have IEC Code</a> 
				<button type="button" class="btn default-search fback_btn" onClick="reverseBox()"><i class="fas fa-angle-left"></i> &nbsp Back</button> 
				
				</div> 
				
				</div>
				</div>   
              </div>
			  </div>
			  
			  <div class="searchbox_feature next_feature_box nft_box5 wow flipInX"> 
			  <div class="clearfix">
			  <h1 class="text-center wow fadeIn">Setup your business <strong>easily</strong></h1>
			  </div>
			  <div class="row mtop50">  
                <div class="col-sm-4 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0">
                  <div class="step-content-block">
                  <div class="feature_content_block">
                    <div class="content_block_title">
                    <h3>Close a company</h3>
                    <div class="button_block" id="bg-color19">
                    <i class="fas fa-angle-down arwicon"></i>
                    <i class="fas fa-check arwicon1"></i>
                    <a class="add_btn1 pointers" href="javascript:void(0)" id="Applied19" onclick="applyService('Applied19','bg-color19','Close a company')">Apply</a>
                    </div>
                    </div>
					<div class="content_block_img">
					<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/db_img1.svg" alt=""> 
					</div>
                    <div class="content_block_txt">
                    Corporations are structured on the idea that control and ownership can be separate. Owners are called shareholders and they may or may not be involved in the day-to-day operations of the company.
                    </div>
                  </div>
                  </div>
                </div>
                <div class="col-sm-4 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0"> 
                  <div class="step-content-block">
                  <div class="feature_content_block">
                    <div class="content_block_title">
                    <h3>Merger & Acquisition</h3>
                    <div class="button_block" id="bg-color20">
                    <i class="fas fa-angle-down arwicon"></i>
                    <i class="fas fa-check arwicon1"></i>
                    <a class="add_btn1 pointers" href="javascript:void(0)" id="Applied20" onclick="applyService('Applied20','bg-color20','Merger & Acquisition')">Apply</a>
                    </div>
                    </div>
					<div class="content_block_img">
					<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/db_img2.svg" alt=""> 
					</div>
                    <div class="content_block_txt">
                    Corporations are structured on the idea that control and ownership can be separate. Owners are called shareholders and they may or may not be involved in the day-to-day operations of the company.
                    </div>
                  </div>
                  </div>
                </div>
                <div class="col-sm-4 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0"> 
                  <div class="step-content-block">
                  <div class="feature_content_block">
                    <div class="content_block_title">
                    <h3>Convert a company</h3>
                    <div class="button_block" id="bg-color21">
                    <i class="fas fa-angle-down arwicon"></i>
                    <i class="fas fa-check arwicon1"></i>
                    <a class="add_btn1 pointers" href="javascript:void(0)" id="Applied21" onclick="applyService('Applied21','bg-color21','Convert a company')">Apply</a>
                    </div>
                    </div>
					<div class="content_block_img">
					<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/db_img3.svg" alt=""> 
					</div>
                    <div class="content_block_txt">
                    Corporations are structured on the idea that control and ownership can be separate. Owners are called shareholders and they may or may not be involved in the day-to-day operations of the company.
                    </div>
                  </div>
                  </div>
                </div>
                <div class="col-sm-4 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0"> 
                  <div class="step-content-block">
                  <div class="feature_content_block">
                    <div class="content_block_title">
                    <h3>Change In Company</h3>
                    <div class="button_block" id="bg-color22">
                    <i class="fas fa-angle-down arwicon"></i>
                    <i class="fas fa-check arwicon1"></i>
                    <a class="add_btn1 pointers" href="javascript:void(0)" id="Applied22" onclick="applyService('Applied22','bg-color22','Change In Company')">Apply</a>
                    </div>
                    </div>
					<div class="content_block_img">
					<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/db_img4.svg" alt=""> 
					</div>
                    <div class="content_block_txt">
                    Corporations are structured on the idea that control and ownership can be separate. Owners are called shareholders and they may or may not be involved in the day-to-day operations of the company.
                    </div>
                  </div>
                  </div>
                </div>                
				<div class="col-sm-12 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0"> 
				<div class="row search-center">
				<div class="col-sm-12 col-12 ">
				<a href="#" class="bg_gray btn default-search"><i class="bg_circle fa fa-check"></i> Setup your business</a> 
				<button type="button" class="btn default-search fback_btn" onClick="reverseBox()"><i class="fas fa-angle-left"></i> &nbsp Back</button> 
				
				</div>
				
				</div>
				</div>   
              </div>
			  </div>
			  
			  <div class="searchbox_feature next_feature_box nft_box6 wow flipInX"> 
			  <div class="clearfix">
			  <h1 class="text-center wow fadeIn">Secure your business with <strong>ease</strong></h1>
			  </div>
			  <div class="row mtop50">  
                <div class="col-sm-4 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0">
                  <div class="step-content-block">
                  <div class="feature_content_block">
                    <div class="content_block_title">
                    <h3>CA Services</h3>
                    <div class="button_block" id="bg-color23">
                    <i class="fas fa-angle-down arwicon"></i>
                    <i class="fas fa-check arwicon1"></i>
                    <a class="add_btn1 pointers" href="javascript:void(0)" id="Applied23" onclick="applyService('Applied23','bg-color23','CA Services')">Apply</a>
                    </div>
                    </div>
					<div class="content_block_img">
					<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/db_img1.svg" alt=""> 
					</div>
                    <div class="content_block_txt">
                    Corporations are structured on the idea that control and ownership can be separate. Owners are called shareholders and they may or may not be involved in the day-to-day operations of the company.
                    </div>
                  </div>
                  </div>
                </div>
                <div class="col-sm-4 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0"> 
                  <div class="step-content-block">
                  <div class="feature_content_block">
                    <div class="content_block_title">
                    <h3>Company Compliance</h3>
                    <div class="button_block" id="bg-color24">
                    <i class="fas fa-angle-down arwicon"></i>
                    <i class="fas fa-check arwicon1"></i>
                    <a class="add_btn1 pointers" href="javascript:void(0)" id="Applied24" onclick="applyService('Applied24','bg-color24','Company Compliance')">Apply</a>
                    </div>
                    </div>
					<div class="content_block_img">
					<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/db_img2.svg" alt=""> 
					</div>
                    <div class="content_block_txt">
                    Corporations are structured on the idea that control and ownership can be separate. Owners are called shareholders and they may or may not be involved in the day-to-day operations of the company.
                    </div>
                  </div>
                  </div>
                </div>
                <div class="col-sm-4 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0"> 
                  <div class="step-content-block">
                  <div class="feature_content_block">
                    <div class="content_block_title">
                    <h3>Annual filings</h3>
                    <div class="button_block" id="bg-color25">
                    <i class="fas fa-angle-down arwicon"></i>
                    <i class="fas fa-check arwicon1"></i>
                    <a class="add_btn1 pointers" href="javascript:void(0)" id="Applied25" onclick="applyService('Applied25','bg-color25','Annual filings')">Apply</a>
                    </div>
                    </div>
					<div class="content_block_img">
					<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/db_img3.svg" alt=""> 
					</div>
                    <div class="content_block_txt">
                    Corporations are structured on the idea that control and ownership can be separate. Owners are called shareholders and they may or may not be involved in the day-to-day operations of the company.
                    </div>
                  </div>
                  </div>
                </div> 
                <div class="col-sm-4 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0"> 
                  <div class="step-content-block">
                  <div class="feature_content_block">
                    <div class="content_block_title">
                    <h3>Legal Agreement</h3>
                    <div class="button_block" id="bg-color26">
                    <i class="fas fa-angle-down arwicon"></i>
                    <i class="fas fa-check arwicon1"></i>
                    <a class="add_btn1 pointers" href="javascript:void(0)" id="Applied26" onclick="applyService('Applied26','bg-color26','Legal Agreement')">Apply</a>
                    </div>
                    </div>
					<div class="content_block_img">
					<img src="<%=request.getContextPath() %>/hcustfrontend/fntdimages/db_img3.svg" alt=""> 
					</div>
                    <div class="content_block_txt">
                    Corporations are structured on the idea that control and ownership can be separate. Owners are called shareholders and they may or may not be involved in the day-to-day operations of the company.
                    </div>
                  </div>
                  </div>
                </div> 
				<div class="col-sm-12 col-12 pr-xl-3 pl-xl-3 p-lg-0 p-md-0 pl-sm-0 pr-sm-0 pl-0 pr-0"> 
				<div class="row search-center">
				<div class="col-sm-12 col-12">
				<a href="#" class="bg_gray btn default-search"><i class="bg_circle fa fa-check"></i> LLC vs Corporation - <br>Which one best for me?</a> 
				<button type="button" class="btn default-search fback_btn" onClick="reverseBox()"><i class="fas fa-angle-left"></i> &nbsp Back</button> 
				
				</div>
				
				</div>
				</div>   
              </div>
			  </div>
			  
              </div>
			</div>
			</div> 
            
            <div class="faq-dashboard text-left order_box hidden">
              <h1>Your Orders</h1>
              <div class="row"> 
                <div class="col-md-8 col-sm-8 col-12"> 
                  <div class="clearfix"> 
                  <p>1. Dealer Name</p>
                  </div>
                </div>
                <div class="col-md-4 col-sm-4 col-12">
                  <div class="clearfix"> 
                   <div class="progress">
                      <div class="progress-bar progress-bar-striped active" role="progressbar" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100" style="width:40%">
                        40%
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="row"> 
                <div class="col-md-8 col-sm-8 col-12"> 
                  <div class="clearfix"> 
                  <p>1. Dealer Name</p>
                  </div>
                </div>
                <div class="col-md-4 col-sm-4 col-12">
                  <div class="clearfix"> 
                   <div class="progress">
                      <div class="progress-bar progress-bar-striped active" role="progressbar" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100" style="width:40%">
                        40%
                      </div>
                    </div>
                  </div>
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
<!-- top scroll ends -->
<script src="<%=request.getContextPath() %>/hcustfrontend/fntdjs/typewriter.js"></script>
<script>
  new TypeWriter('#searchService', ['Try FSSAI', 'Try FSSAI', 'Try FSSAI'], { writeDelay: 100 });
</script>
<!-- for activate wow -->
<script>
new WOW().init();
</script> 
<script>
document.getElementById("mySite").style.display = "block";
$(document).ready(function(){
// preloader starts
  $.fakeLoader({
	timeToHide:200, 
	zIndex:999,
	spinner:"spinner4", 
	bgColor:"#4ac4f3", 
  });
  });
</script>
<!-- for activate wow -->
    
<!-- script ends -->
<script>
function getServices(name){
	if(name!=""){
		$("#AppendService").show();
		var home="https://www.corpseed.com/service/";
		var result="";
	$.ajax({
		url : "searchService111",
		type : "GET",
		dataType : "HTML",
		data : {
			name : name
		},
		success : function(response) {			
			if(Object.keys(response).length!=0){	
				response = JSON.parse(response);			
				 var len = response.length;			 
				 if(Number(len)>0){
					for(var i=0;i<len;i++){		   
						var name = response[i]['name'];
						var url = response[i]['url'];	
						var path=home+url;
						result+="<li><a href='"+path+"' target='_blank'>"+name+"</a></li>";
					}
					$("#appendServices").html(result);
				}
				 }else{
					 $("#appendServices").html("");
				 }
		},
		error : function(error) {
			alert('error: ');
		}
	});}else{
		$("#AppendService").hide();
	}
		
	}

function openBox(i) {
	$('.pre_feature_box').addClass('hide'); 
	$('.pre_feature_box').removeClass('animated');
	$('.next_feature_box.nft_box'+i).addClass('show animated'); 
}
</script>
<script>
function reverseBox() {  
	$('.next_feature_box').removeClass('show animated');	
	$('.pre_feature_box').removeClass('hide');
	$('.pre_feature_box').addClass('animated');  
	
}
</script>

</body>
<!-- body ends -->
</html>