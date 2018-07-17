/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import "../src/application.scss";
import "bootstrap/dist/css/bootstrap.css";
import 'bootstrap/dist/js/bootstrap';
global.jQuery = require('jquery');

console.log('Hello World from Webpacker')

// $('.carousel').on('mouseenter',function(){ $( this ).carousel();})

// $(document).ready(function(e) {
//     $('#menu_icon').click(function(){
//         if($("#content_details").hasClass('drop_menu'))
// 		{
//         $("#content_details").addClass('drop_menu1').removeClass('drop_menu');
//     }
// 		else{
// 			$("#content_details").addClass('drop_menu').removeClass('drop_menu1');
// 			}
	
	
// 	});
	
// });// Support component names relative to this directory:
var componentRequireContext = require.context("components", true)
var ReactRailsUJS = require("react_ujs")
ReactRailsUJS.useContext(componentRequireContext)

$ = jQuery;
$(".alert" ).fadeOut(5000);
$('.carousel').carousel({
  interval: 10000
})
// !function(o){"use strict";o('a.js-scroll-trigger[href*="#"]:not([href="#"])').click(function(){
//   if(location.pathname.replace(/^\//,"")==this.pathname.replace(/^\//,"")&&location.hostname==this.hostname){
//     var t=o(this.hash);
//     if((t=t.length?t:o("[name="+this.hash.slice(1)+"]")).length)return o("html, body").animate({
//       scrollTop:t.offset().top-70},1e3,"easeInOutExpo"),!1}
//   }),
// o(document).scroll(function(){
//   o(this).scrollTop()>100?o(".scroll-to-top").fadeIn():o(".scroll-to-top").fadeOut()}),o(".js-scroll-trigger").click(function(){
//     o(".navbar-collapse").collapse("hide")
//   }),
//   o("body").scrollspy({
//     target:"#mainNav",offset:80
//   });
//   var t=function(){o("#mainNav").offset().top>100?o("#mainNav").addClass("navbar-shrink"):o("#mainNav").removeClass("navbar-shrink")};t(),o(window).scroll(t),o(".portfolio-item").magnificPopup({
//     type:"inline",preloader:!1,focus:"#username",modal:!0
//   }),
//   o(document).on("click",".portfolio-modal-dismiss",function(t){
//     t.preventDefault(),o.magnificPopup.close()
//   }),o(function(){
//     o("body").on("input propertychange",".floating-label-form-group",
//       function(t){
//         o(this).toggleClass("floating-label-form-group-with-value",!!o(t.target).val())
//       }).on("focus",".floating-label-form-group",function(){
//         o(this).addClass("floating-label-form-group-with-focus")
//       }).on("blur",".floating-label-form-group",function(){
//         o(this).removeClass("floating-label-form-group-with-focus")
//       })
//     })
// }(jQuery);