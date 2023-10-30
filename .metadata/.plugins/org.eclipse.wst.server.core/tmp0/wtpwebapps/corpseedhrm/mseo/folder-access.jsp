<%@page import="admin.task.TaskMaster_ACT"%>
<%@ include file="../../madministrator/checkvalid_user.jsp" %>
<%@page import="admin.enquiry.Enquiry_ACT"%>

<!DOCTYPE HTML>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/>
	<title>Grant/Deny Access Folder Permission</title>
	<%@ include file="../staticresources/includes/itswsstyles.jsp" %>
</head>
<body>
<div class="wrap">
    <%
    String refid=request.getParameter("refid");
    %>
    <div class="row">
            <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="menuDv marg10">
                    <div class="box-intro">
                      <h2><span class="title">Grant/Deny Access Folder Permission</span></h2>
                    </div>
                <div class="clearfix pad_box2">
                       <form onsubmit="return false;"  name="follow-up-form"> 
                       <input type="hidden" id="FolderId" value="<%=refid%>"/>                           
                            <div class="clearfix form-group mtop10">
                            <label>User Name :<span style="color: red;">*</span></label>
                            <div class="clearfix relative_box">
                            <input type="text" id="User_Id" autocomplete="off" name="userid"  class="form-control"  placeholder="Enter User Name Minimum 2 Characters"/>
                            <input type="hidden" name="uid" id="Uid"/>
                            <div id="useridErr" class="popup_error"></div>
                            </div>
                            </div>                           
                            <div class="clearfix item-product-info form-group">
                                  <button class="bt-link bt-radius bt-loadmore" type="submit" onclick="return validateUser();">Submit</button>
                            </div>
                         
                            <div class="menuDv clearfix mb10  footer-bottom2">
                            <div class="row">
                           <div class="col-md-12 col-sm-12 col-xs-12">
                           <div class="clearfix ">
                           <div class="col-xs-1 box-intro-bg">
                            <div class="box-intro-border">
                            <p class="news-border">SN</p>
                            </div>
                           </div>
                           <div class="col-xs-9 box-intro-bg">
                            <div class="box-intro-border">
                            <p class="news-border">User Name</p>
                            </div>
                           </div>
                           <div class="col-xs-2 box-intro-bg ">
                            <div class="box-intro-border">
                            <p class="">Action</p>
                            </div>
                           </div>
                           </div>
                           </div>
                           </div>
                              <%
                            String token = (String) session.getAttribute("uavalidtokenno");
                            String[][] upermission=TaskMaster_ACT.getAllPermissions(refid,token,"folder");
                            for(int i=0;i<upermission.length;i++){
                            %>
                          <div class="row">
                          <div class="col-md-12 col-sm-12 col-xs-12">
                          <div class="clearfix">
                          <div class="col-xs-1 box-intro-background">
                            <div class="link-style12">
                            <p class="news-border" title=""><%=upermission.length-i %></p>
                            </div>
                          </div>  
                          <div class="col-xs-9 box-intro-background">
                            <div class="link-style12">
                            <p class="news-border" title="<%=upermission[i][1]%>"><%=upermission[i][1]%></p>
                            </div>
                          </div> 
                          <div class="col-xs-2 box-intro-background">
                            <div class="link-style12">
                            <p class="" title=""><a href="" onclick="deletePermission(<%=upermission[i][0]%>)"><i class="fa fa-trash" title="delete"></i></a></p>
                            </div>
                          </div> 
                          </div>
                           </div>
                           </div>
                           <%} %>
                           </div>
                            
                     </form>
                   </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../staticresources/includes/itswsscripts.jsp" %>
<script type="text/javascript">
	function deletePermission(id){
		var xhttp;
		xhttp = new XMLHttpRequest();
		xhttp.onreadystatechange = function() {
		if (this.readyState == 4 && this.status == 200) {
		location.reload();
		}
		};
		xhttp.open("GET", "<%=request.getContextPath()%>/DeletePermission111?info="+id, true);
		xhttp.send();
	}

	function validateUser() {		
	if(document.getElementById("User_Id").value.trim()=="" ) {
		useridErr.innerHTML="User Name required.";
		useridErr.style.color="red";
	return false;
	}else
		useridErr.innerHTML="";
	
	var userId=document.getElementById("Uid").value.trim();	
	var frefid=document.getElementById("FolderId").value.trim();	
	var fcategory="folder";
	$.ajax({
		type: "POST",
		dataType: "html",
		url: "addFolderPermission111",
		data:  {
			userId: userId,
			frefid: frefid,
			fcategory: fcategory
		},
		success: function (data) {
		location.reload();
		},
		error: function (error) {
		alert("error in addPermissions() " + error.responseText);
		}
		});
}
</script>
<script type="text/javascript">
function isExist(value,err){
	var val=document.getElementById(value).value.trim();
	$.ajax({
		type : "POST",
		url : "ExistValue111",
		dataType : "HTML",
		data : {
			"val" : val,
			"field":"servicetype",
		},
		success : function(data){
			if(data=="pass"){
			document.getElementById(err).innerHTML="'"+val +"'  already existed.";
			document.getElementById(err).style.color="red";
			document.getElementById(value).value="";
			}
			
		}
	});
}


</script>
</body>
</html>