<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/jquery-1.12.4.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/bootstrap.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/jquery.fancybox.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/jquery-ui.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/nicEdit.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/globalscript.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/select2.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/moment.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/daterangepicker.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/mdtimepicker.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/fontawsome.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/theme.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/staticresources/js/custom.js"></script>

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

$(document).ready( function () {
	var role="<%=session.getAttribute("emproleid")%>";
	$(".checked").click(function(){
		 if ($(".checked").is(":checked")){
			 $(".hashico").hide()
			 $("#CheckAll").show();
			 $("#SearchOptions").hide();
			 $("#SearchOptions1").show();
	}else{
		 $("#CheckAll").hide();
		 $(".hashico").show()
		 $("#SearchOptions").show();
		 $("#SearchOptions1").hide();
	}
		
		});
	$("#CheckAll").click(function(){
	$('.checked').prop('checked', this.checked);
	if ($(".checked").is(":checked")){
		 	 $(".hashico").hide()
			 $("#CheckAll").show();
			 $("#SearchOptions").hide();
			 $("#SearchOptions1").show();
	}else{
		 $(".hashico").show()
		 $("#CheckAll").hide();
		 $("#SearchOptions").show();
		 $("#SearchOptions1").hide();
	}
		    
	});
} );

 $(window).load(function() {
  $(".processing_loader").fadeOut();
}); 
</script>
<script type="text/javascript">
 function showLoader(){
   $(".processing_loader").fadeIn(); 
} 
function hideLoader(){
   $(".processing_loader").fadeOut();  
}  
</script>
<script type="text/javascript">
$('.timepicker').mdtimepicker();
function openClock(id){
$('#'+id).mdtimepicker();
}
function openCalendar(id){
	$("#"+id).datepicker({changeMonth:true,changeYear:true,dateFormat:'yy-mm-dd'});
}
</script>
<script type="text/javascript">
$('.has-clear input[type="text"]').on('input propertychange', function() {
  var $this = $(this);
  var visible = Boolean($this.val());
  $this.siblings('.form-control-clear').toggleClass('hidden', !visible);
}).trigger('propertychange');

$('.form-control-clear').click(function() {
  $(this).siblings('input[type="text"]').val('')
    .trigger('propertychange').focus();
});
</script>
<script type="text/javascript">
function goBack() {
  window.history.back();
}
</script>
