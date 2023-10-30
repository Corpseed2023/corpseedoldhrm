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
					
				});

$(window).load(function() {
	$("#loader").fadeOut("slow");
});

$(window).load(function() {
	$('#loading').fadeOut("slow");
});

// Quick View
$('.quick-view1').each(function() {
	$(this).fancybox();
	
});

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
    var data=x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    if(!data.includes("."))
    data+=".00";
    return data;
}
function numberToWords(RupeesId,number) {  
    var digit = ['zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine'];  
    var elevenSeries = ['ten', 'eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen'];  
    var countingByTens = ['twenty', 'thirty', 'forty', 'fifty', 'sixty', 'seventy', 'eighty', 'ninety'];  
    var shortScale = ['', 'thousand', 'million', 'billion', 'trillion'];  

    number = number.toString();
    number = number.replace(/[\, ]/g, '');
    if (number != parseFloat(number)) return 'not a number';
    var x = number.indexOf('.');
    if (x == -1) x = number.length; if (x > 15) return 'too big';
    var n = number.split(''); 
    var str = ''; 
    var sk = 0;
    for (var i = 0; i < x; i++) { 
    	if ((x - i) % 3 == 2) { 
    		if (n[i] == '1') { 
    			str += elevenSeries[Number(n[i + 1])] + ' '; 
    			i++; sk = 1; 
    			} else if (n[i] != 0) { 
    				str += countingByTens[n[i] - 2] + ' ';
    				sk = 1;
    				} } else if (n[i] != 0) { 
    					str += digit[n[i]] + ' ';
    					if ((x - i) % 3 == 0) str += 'hundred ';
    					sk = 1; 
    					} if ((x - i) % 3 == 1) { 
    						if (sk) str += shortScale[(x - i - 1) / 3] + ' ';
    						sk = 0; 
    						} 
    					} if (x != number.length) {
    							var y = number.length;
    							var str1='point ';
    							var z=0;
    							for (var i = x + 1; i < y; i++) {
    								z=Number(z)+Number(n[i]);
    								str1 += digit[n[i]] + ' '; 
    							}
    							if(z>0){
    								str+=str1;
    							}
    							} 
    						str = str.replace(/\number+/g, ' ');    						 
 document.getElementById(RupeesId).innerHTML="INR "+str.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();})+" only.";
}
function changeRows(rows,page,domain){
	window.location.replace(domain+page+"&rows="+rows);
}
function sortBy(url,sortBy,order){
	var url1=url+"&sort="+sortBy+"&ord="+order;
	window.location.replace(url1);
}
function saveToSession(data,name,data1,name1){
	$.ajax({
	    type: "GET",
	    url: "SetSortingData111",
	    data:  { 
	    	data : data,
	    	name : name,
			data1 : data1,
			name1 : name1
	    },
	    success: function (response) {	    
        },
	});
}
jQuery(".doticon").click(function() {
	jQuery(".filtermmenu").slideToggle("fast");
});
  function validateFileSize(fileId){	  
		const fi=document.getElementById(fileId);
		if (fi.files.length > 0) {
			const fsize = fi.files.item(0).size; 
	        const file = Math.round((fsize / 1024)); 
	        
	        // The size of the file. 
	        if (file >= 49152) {  
	            document.getElementById('errorMsg').innerHTML ='File too Big, Max File Size 48 MB !!';
	            document.getElementById(fileId).value="";
	 		    $('.alert-show').show().delay(4000).fadeOut();
	        }	
		}	
 }
$(window).on('load', function(){
		  setTimeout(removeLoader, 100); //wait for page load PLUS two seconds.
		});
		 function removeLoader(){
			
		    $( ".tg,.post,.card-skeleton" ).fadeOut(100, function() {
		      // fadeOut complete. Remove the loading div
		      $( ".tg,.post,.card-skeleton" ).remove(); //makes page more lightweight 
		  });  
		}
/*$(document).ready(function(){
    $(window).bind('unload', function () {
        if (/Firefox[\/\s](\d+)/.test(navigator.userAgent) && new Number(RegExp.$1) >= 4) {
           updateCloseStatus();
            return null;
        }
        else {
		updateCloseStatus();
            return null;
        }
    });
function updateCloseStatus(){
	$.ajax({
			type : "GET",
			url : "UpdateUserActiveStatus999",
			dataType : "HTML",
			data : {},
			success : function(data){
				
			}
		});
}*/
/*window.addEventListener("onunload", () => {
	console.log(rDown);
    if (!rDown) {
	$.ajax({
			type : "GET",
			url : "UpdateUserActiveStatus999",
			dataType : "HTML",
			data : {
			},
			success : function(data){
				
			}
		});
    }else console.log("not close tab...")
});
})*/
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