jQuery(document)
		.ready(
				function($) {

					// Accordions

					if ($('.accordion-box').length > 0) {
						$('.accordion-box').each(
								function() {
									$('.title-accordion').click(
											function() {

												$(this).parent().parent().find(
														'.item-accordion')
														.removeClass('active');
												$(this).parent().addClass(
														'active');
												$(this).parent().parent().find(
														'.desc-accordion')
														.stop(true, true)
														.slideUp();
												$(this).next().slideDown();
											});
								});
					}					
					$('.toggle_btn').click(function(event){
						event.preventDefault();
						event.stopPropagation();
						$(this).toggleClass('toggle');
						$(this).next().toggleClass('toggle');
					});
					$('.toggle_btn1').click(function(event){
						event.preventDefault();
						event.stopPropagation();
						$(this).toggleClass('toggle');
						$(this).next().next().slideToggle();
					});
					$('.toggle_btn2').click(function(event){
						event.preventDefault();
						event.stopPropagation();
						$(this).toggleClass('toggle');
						$(this).next().slideToggle();
					});
					$('.link_btn').click(function(event){
						event.preventDefault();
						event.stopPropagation();
						$(this).next().slideToggle();
					});
					
					$(".attachment_list").click(function(e){
    					e.stopPropagation();
					});

					$(document).click(function(){
    					$('.attachment_list, .menu_list ul').slideUp();
					});

					
					$(document).ready(function () {
              $('.notification').click(function (e) {
               $('.notification_box ').stop(true).slideToggle();
            });
              $(document).click(function (e) {
              if (!$(e.target).closest('.notification, .notification_box ').length) {
             $('.notification_box ').stop(true).slideUp();
            }
          });
          });
				
					$('.hide_btn').click(function(event){
						event.preventDefault();
						event.stopPropagation();
						$('.notification_box').removeClass('show');
					}); 
				  
					$(window).scroll(function() {

						if ($(this).scrollTop() > 100) {

							$('.scrollup').fadeIn();

						} else {

							$('.scrollup').fadeOut();

						}

					});

					$('.scrollup').click(function() {

						$("html, body").animate({
							scrollTop : 0
						}, 600);

						return false;

					});

					// btn Show & Hide

					$("#edit-btn").click(function() {

						$(".profile-box input").show();

						$(".update-box").show();

						$(this).hide();

						$(".profile-box output").hide();

					});

					$("#cancel-btn").click(function() {

						$(".profile-box output").show();

						$("#edit-btn").show();

						$(".update-box").hide();

						$(".profile-box input").hide();

					});

					jQuery(
							"#bg-one, #bg-two, #bg-three, #bg-four, #bg-five, #bg-six, #bg-seven, #bg-eight, #bg-nine, #bg-ten")
							.click(function() {

								jQuery("#wrapper").addClass("boxed-layout");

							});

					jQuery("#wide")
							.click(
									function() {

										jQuery("body")
												.removeClass(
														"bg1 bg2 bg3 bg4 bg5 bg6 bg7 bg8 bg9 bg10");

									});

					jQuery("#light").click(
							function() {

								jQuery("#footer").addClass("light");

								jQuery("#footer").removeClass("dark");

								jQuery("#footer img").attr("src",
										"images/footer-logo.jpg");

							});

					jQuery("#dark").click(
							function() {

								jQuery("#footer").addClass("dark");

								jQuery("#footer").removeClass("light");

								jQuery("#footer img").attr("src",
										"images/footer-logo-dark.jpg");

							});

					jQuery("#header-n").click(function() {

						jQuery("body").removeClass("fixed-header");

					});

					jQuery("#header-f").click(function() {

						jQuery("body").addClass("fixed-header");

					});

					// picker buttton

					jQuery(".picker_close").click(function() {

						jQuery("#choose_color").toggleClass("position");

					});

					// mobile menu toggle
					if($(window).width()<768){

					jQuery(".dropdown-toggle").click(function() {

						jQuery(this).next().slideToggle();

					});
					}

					// header

					// stickey header

					jQuery(window).scroll(function() {

						var scroll = jQuery(window).scrollTop();

						if (scroll >= 60) {

							jQuery(".header").addClass("sticky");

						}

						else {

							jQuery(".header").removeClass("sticky");

						}

					});

					/*
					 * //create the slider
					 * 
					 * $('.cd-testimonials-wrapper').flexslider({
					 * 
					 * selector: ".cd-testimonials > li",
					 * 
					 * animation: "slide",
					 * 
					 * controlNav: false,
					 * 
					 * slideshow: false,
					 * 
					 * smoothHeight: true,
					 * 
					 * start: function(){
					 * 
					 * $('.cd-testimonials').children('li').css({
					 * 
					 * 'opacity': 1,
					 * 
					 * 'position': 'relative'
					 * 
					 * }); }
					 * 
					 * });
					 */

					// open the testimonials modal page
					$('.cd-see-all').on('click', function() {

						$('.cd-testimonials-all').addClass('is-visible');

					});

					// close the testimonials modal page

					$('.cd-testimonials-all .close-btn').on(
							'click',
							function() {
								$('.cd-testimonials-all').removeClass(
										'is-visible');
							});
					$(document).keyup(
							function(event) {
								// check if user has pressed 'Esc'
								if (event.which == '27') {
									$('.cd-testimonials-all').removeClass(
											'is-visible');
								}
							});
					/*
					 * //build the grid for the testimonials modal page
					 * 
					 * $('.cd-testimonials-all-wrapper').children('ul').masonry({
					 * 
					 * itemSelector: '.cd-testimonials-item'
					 * 
					 * });
					 */
				});

$(window).load(function() {
	$("#loader").fadeOut("slow");
});

$(window).load(function() {
	$('#loading').fadeOut("slow");
});

// Quick View
//$('.quick-view').each(function() {
	//$(this).fancybox();
//});

// Datepicker
$('[data-toggle="datepicker"]').datepicker();

// Validation Regex
/*var nameregex = /^[a-zA-Z ]*$/;*/
var nameregex = /^[a-zA-Z0-9 .]*$/;
var mobileregex = /^(6|7|8|9)\d{9}$/;
var emailregex = /\S+@\S+\.\S+/;
var panregex = /^[a-zA-Z0-9]{10}$/;
var aadharregex = /^[0-9]{12}$/;
var numberregex = /^\d+$/;
var charnumregex = /^[a-zA-Z0-9_ ]*$/;

// Loader for all AJAX
$(document).ajaxStart(function() {
    $("#loading").fadeIn();
});

$(document).ajaxStop(function() {
    $("#loading").fadeOut("slow");
});
function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

 $(".mtoggle").click(function() {
                $(".sidebar ").show('fast');
                $(this).addClass('active');

            });
$(".backbtnn").click(function() {
	 $(".sidebar").hide('fast');
 $(".mtoggle").removeClass('active');

	
       });
$(".mobilesearchico").click(function() {
		$(".mobilesearchico").hide('fast');
	 $("#backico").show('fast');
	 $(".inbox_input ").show('fast');
	

       });
$("#backico").click(function() {
	 $("#backico").hide('fast');
	 $(".inbox_input").hide('fast');
	$(".mobilesearchico").show('fast');
	 $(".doticon").show('fast');
       });

$(".doticon").click(function() {
                $(".filter_menu ").slideToggle('fast');
                $(this).toggleClass('active');

            });
if($(window).width() < 768) {
jQuery(".icoo").click(function () {
  var display = jQuery(this).next(".dropdown_list").css("display");
  if (display == "none") {
	jQuery(".fa-angle-up ").css("display","none");
    jQuery(".dropdown_list").removeClass("active");
    jQuery(".dropdown_list").slideUp("fast");
    jQuery(this).next(".dropdown_list").slideDown("fast");
    jQuery(this).addClass("active");
 jQuery(".fa-angle-down ").css("display","block");

  } else {
	 jQuery(".fa-angle-up ").css("display","none");
    jQuery(this).next(".dropdown_list").slideUp("fast");
    jQuery(this).removeClass("active");
jQuery(".fa-angle-down ").css("display","block");


  }
});
}
$(".mobilesearchico").click(function(){
	$("#SearchOrder").focus();
})
function applyService(applied,color,category){
	showLoader();
	$("#"+applied).prop("disabled",true);
		$.ajax({
		url : "ClientServiceRequest999",
		type : "GET",
		dataType : "HTML",
		data : {category:category},
		success : function(response) {	
			hideLoader();		
			if(response=="pass"){
				$("#"+applied).html("Applied");
				$("#"+color).addClass("bg-success");
			}else{
				 document.getElementById('errorMsg').innerHTML ='Something Went Wrong, Please try again later !!';					
		 		 $('.alert-show').show().delay(4000).fadeOut();
			}
		},
		error : function(error) {
			alert('error: '+error);
		}
	});	
}
/* $(window).unload(function() {
		$.ajax({
			type : "GET",
			url : "UpdateUserActiveStatus999",
			dataType : "HTML",
			data : {
			},
			success : function(data){	
			}
		});
	});*/
$(document).ready(function (){
          $('#middle-search-message').click(function (e) {
           $('.user_list ').stop(true).slideToggle();
        });

          $(document).click(function (e) {
          if (!$(e.target).closest('#middle-search-message, .user_list ').length) {
         $('.user_list ').stop(true).slideUp();
        }
      });

if ($(window).width() < 767){
	$.ajax({
		type : "GET",
		url : "GetMenuNotification999",
		dataType : "HTML",
		data : {
		},
		success : function(data){
			var x=data.split("#");
			var order=x[0];
			var chat=x[1];
			var document=x[2];
			var profile=x[3];
			if(order=="true")$("#client_orders").children().show();
			if(chat=="true")$("#client_inbox").children().show();
			if(document=="true")$("#client_documents").children().show();
			if(profile=="true"){
				$("#client_payments").children().show();
				$("#my_profile").children().show();
			}
		}
	});
$("#client_orders,#client_inbox,#client_documents,#client_payments").click(function(){
		var name=$(this).attr("id");
		$.ajax({
			type : "GET",
			url : "UpdateMenuNotification999",
			dataType : "HTML",
			data : {name : name},
		success : function(data){			
		}
	});
		
	})
}
	
 });
