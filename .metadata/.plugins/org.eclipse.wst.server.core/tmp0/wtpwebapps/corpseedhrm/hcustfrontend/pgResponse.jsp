<%@page import="java.util.Map"%>
<%@page import="java.util.TreeMap"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Payment invoice</title>
<link href="//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css"/>
<script src="//netdna.bootstrapcdn.com/bootstrap/3.0.0/js/bootstrap.min.js"></script>
<script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
</head>
<body>
<div class="container">
<%String paymentStatus=(String)request.getAttribute("paymentStatus"); 
if(paymentStatus.equalsIgnoreCase("Payment Success")){%>
            <div class="row mt-5">
                <div class="col-xl-6 col-lg-7 col-md-9 col-sm-11 mx-auto mt-4">
                    <div class="error-404 text-center">
                        <h1 class="display-4 mb-5 font-weight-bold text-dark">Thank You</h1>

                        <div class="alert alert-info mx-auto py-5 rounded">
                            <div class="icon d-flex justify-content-center my-4">
                                <svg xmlns="http://www.w3.org/2000/svg" width="75" height="75"
                                    xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" id="Capa_1" x="0px" y="0px"
                                    viewBox="0 0 512 512" style="  fill: #13b955 ;" xml:space="preserve">
                                    <g>
                                        <path
                                            d="M497.36,69.995c-7.532-7.545-19.753-7.558-27.285-0.032L238.582,300.845l-83.522-90.713    c-7.217-7.834-19.419-8.342-27.266-1.126c-7.841,7.217-8.343,19.425-1.126,27.266l97.126,105.481    c3.557,3.866,8.535,6.111,13.784,6.22c0.141,0.006,0.277,0.006,0.412,0.006c5.101,0,10.008-2.026,13.623-5.628L497.322,97.286    C504.873,89.761,504.886,77.54,497.36,69.995z" />
                                    </g>
                                    <g>
                                        <g>
                                            <path
                                                d="M492.703,236.703c-10.658,0-19.296,8.638-19.296,19.297c0,119.883-97.524,217.407-217.407,217.407    c-119.876,0-217.407-97.524-217.407-217.407c0-119.876,97.531-217.407,217.407-217.407c10.658,0,19.297-8.638,19.297-19.296    C275.297,8.638,266.658,0,256,0C114.84,0,0,114.84,0,256c0,141.154,114.84,256,256,256c141.154,0,256-114.846,256-256    C512,245.342,503.362,236.703,492.703,236.703z" />
                                        </g>
                                    </g>
                                </svg>
                            </div>
                            <p class="mb-3 lead">
                            <h5 class="  text-capitalise mb-3">Your order payment submitted successfully. </h5>

                            Please wait, After verification it will show in payment section !
                            </p>
                            <div class="d-flex px-3 px-md-5 justify-content-center">
                                <a href="invoice-<%=request.getAttribute("SalesKey")%>.html"  class="shadow btn btn-primary mt-4 btn-lg rounded-lg mx-auto btn-block  ">Show Invoice</a>
                            </div>
                        </div>


                    </div>
                </div>
            </div>
<%}else{ %>

    <div class="row">
    <a href="/corpseedhrm/client_dashboard.html" style="float: left;">HOME</a>
        <div class="well col-xs-10 col-sm-10 col-md-6 col-xs-offset-1 col-sm-offset-1 col-md-offset-3">
            <div class="row">
                <div class="col-xs-6 col-sm-6 col-md-6">
                    <strong><b><%=paymentStatus%></b></strong>
                    <br>
                </div>
                <div class="col-xs-6 col-sm-6 col-md-6 text-right">
                    <p>
                        <em>Receipt #: <span>Recipt0001</span></em>
                    </p>
                </div>
            </div>
            <div class="row">
                <div class="text-center">
                    <h1>Receipt</h1>
                </div>
               
                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th>Components</th>
                    </tr>
                    </thead>
                    <tbody>                    
					<%
					TreeMap<String,String> parameters=(TreeMap<String,String>)request.getAttribute("parameters");
					  for (Map.Entry<String, String>  entry : parameters.entrySet()){%>
                       <tr>
                        <td><%=entry.getKey() %> : <%=entry.getValue() %></td>
                        </tr>
                     <%} %> 
                    
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <%} %>
</div>
</body>
</html>