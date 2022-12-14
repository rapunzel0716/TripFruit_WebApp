<%-- 
    Document   : tripseek
    Created on : 2019/3/13, δΈε 04:10:54
    Author     : Rapunzel_PC
--%>

<%@page import="java.time.LocalDate"%>
<%@page import="uuu.tf.entity.Place"%>
<%@page import="java.util.List"%>
<%@page import="uuu.tf.model.PlaceService"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>TripFruit</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script src="https://maps.googleapis.com/maps/api/js?key=ιι°&libraries=places" async defer></script>
        <!--global-->
        <%@include file="/WEB-INF/subviews/global.jsp" %>
        <style type="text/css">
            html, body {height: 100%;}
            nav ul:nth-child(1) li:nth-child(2){background-color: #e5e5e5;}
            nav ul:nth-child(1) li:nth-child(2) a:hover{color: black;}
            .toggleTimeCourse{
                float:left;padding: 0;margin: 0;width: 100%;
            }
            .timeCourse{
                height: 140px;width: 95%;
            }
            .place{
                background-color: white;border:1px solid #afafaf;padding: 10px 0 ;border-radius:2px;margin: 5px 0px 0px 0px; width: 90%;float:left;margin-left:20px;
            }
            .route{
                background-color: white;border:1px solid #afafaf;border-top-width:0px;padding: 10px 0;border-radius:2px;width: 90%;float:left;margin-left:20px;position: relative;
            }
            .toggleTimeCourse li {
                list-style: none;
            }
            .ui-state-highlight{
                border:  0;
                background-color: #e0dcd9;
            }
            .placedays{
                width: 100%;height: 30px;padding: 5px 0;border-radius:2px;position: relative;color: #3b5998;cursor: pointer;
            }
            .places{
                width:95%;position: relative;float:left;background-color: white;margin: 2px 0px;
            }
            .days{
                width: 42px;padding: 10px 0;border: 1px solid #afafaf;text-align: center;border-radius:2px;
            }
            .controlday{
                float: left;margin-right: 20px;
            }
            .boxitem1{
                width:25%;height:100%;float:left;position: relative;  width:400px;-webkit-flex-grow:0;flex-grow:0;flex-shrink: 0; 
            }
            .boxitem2{
                display: none;width:75%;height:100%; float: right;position: relative;   width:400px;min-width: 900px; -webkit-flex-grow:1;flex-grow:1;flex-shrink: 1;
            }
            @media only screen and (min-width:700px) {
                #sectionmap { display: block; }
            }
            @media only screen and (max-width:700px) {
                #articletrip { flex-grow:1;width:100%}
            }
            .tripimages{
                width: 300px;height: 150px;background-repeat: no-repeat;
                background-position: center;background-size: cover;cursor: pointer;
                position: relative;float: left;border-radius:3px;
            }
            .setstarttime{
                width: 20px;height: 20px;float: left; margin-left: 12px;background-image: url('images/icons/time.png');background-repeat: no-repeat;background-position: center;background-size: cover;
            }
            .deletedate{
                width: 20px;height: 20px;float: left; margin-left: 8px;background-image: url('images/icons/x.png');background-repeat: no-repeat;background-position: center;background-size: cover;
            }
            .courseTime{
                height: 27px;line-height: 27px;width: 45px; position: relative;
            }
            .courseTimeType{
                float: left;position: relative; width:45px
            }
            .coursePlaceName{
                padding:3px 6px 0px 6px;width: 100%;border-bottom: 1px solid;position: relative;
            }
            .courseStay{
                padding:3px 0px 0px 6px;font-size: 12px;height: 27px;width: 100%;position: relative;
            }
            .coursePlace{
                float: left;position: relative;width:80%;border-left: 2px solid;
            }
            .searchType{
                margin-left: 30px;cursor: pointer;color: #3b5998;
            }
            
        </style>

        <script>
            //$(document).ready(init);
            var map;
            var infowindow;
            var marker;
            var markers = [];
            var schedule_markers = [];
            var directionsService;
            var directionsDisplay;
            var bounds;
            var styles = {
                default: null,
                hide: [
                    {
                        featureType: 'poi.business',
                        stylers: [{visibility: 'off'}]
                    },
                    {
                        featureType: 'transit',
                        elementType: 'labels.icon',
                        stylers: [{visibility: 'off'}]
                    }
                ]
            };
            function init() {
                var uluru = {lat: 25.0482231, lng: 121.5336551};
                var sydney = new google.maps.LatLng(25.0440688, 121.5315383);
                map = new google.maps.Map(document.getElementById('map'), {
                    center: uluru,
                    zoom: 15,
                    mapTypeControl: false,
                });
                //ιιPOIι»ζ
                map.setClickableIcons(false);
                map.setOptions({styles: styles['hide']});
                infowindow = new google.maps.InfoWindow();
                //ζΎε¨ε°εε·¦δΈθ§
                map.controls[google.maps.ControlPosition.LEFT_TOP].push($("#searchformbyname")[0]);
                //ζΎε¨ε°εε³δΈθ§
                map.controls[google.maps.ControlPosition.TOP_RIGHT].push($("#searchTypeByMap")[0]);
                //ηΌιιεζ­₯θ«ζ±θ‘η¨
                getSchedule();
                //ιιι»ζηθ‘η¨
                $(document).on("click", ".placedays", placedaysHandler);
                //$(document).on("click", ".placedays", dayBoundsHandler);
                //ι»ζεͺι€ε€©ζΈ
                $(document).on("click", ".deletedate", deletedateHandler);
                //ι»ζε€©ζΈηεΊηΌζι
                $(document).on("click", ".setstarttime", setStartTimeHandler);
                //εζζηθ‘η¨θζε°ζ―ι»
                $("#right").click(rightHandler);
                $("#left").click(leftHandler);
                //ι»ιΈθ‘η¨ε°ι’ζοΌηΌιιεζ­₯θ«ζ±radio_image.jspι ι’
                $(document).on("click", ".tripimages", function () {
                    $.ajax({
                        url: "pop-page/radio_image.jsp",
                        method: 'POST',
                    }).done(radioImagePageHandler);
                });

                $(".searchType").click(searchTypeHandler);
                //ζδΈθ¨­ε?εηζι
                $(document).on("click", "#setStayTime", popStayTime);
                $(document).on("click", ".getroute", getRoute);
            }
            //δ½Ώη¨ηη?±ιεθ¨­ε?εηζι
            function popStayTime() {
                var time = $("#stay").attr("data-stay");
                $("#setStayTimeInput").val(time);//ε°η?εηεηηεΌ ε³η΅¦setStayTimeInput
                $.fancybox.open({
                    src: "#pop-stayTime"
                });
            }
            //ζ΄ζ°εηζι
            function updateStartTime() {
                var time = parseInt($("#setStayTimeInput").val());
                var min = parseInt($("#setStayTimeInput").attr("min"));
                if (isNaN(time) || time < min) {
                    alert("θ«θΌΈε₯ζ­£η’Ίηεηζι");
                    return;
                }
                $.ajax({
                    url: "update_stay.do",
                    method: 'POST',
                    data: $("#setStayForm").serialize(),
                }).done(getSchedule);
                $("#stayTime").text(time + "ε");
                $("#stay").attr("data-stay", time);
                $.fancybox.close();
            }
            //εͺι€ι»ζε€©ζΈ
            function deletedateHandler(e) {
                if (confirm("η’Ίε?θ¦εͺι€ιδΈε€©εοΌ")) {
                    var len = $(".places").length;
                    var date = $(this).attr("data-date");
                    if (len > 1) {
                        $.ajax({
                            url: "deletedate.do?date=" + date,
                            method: 'POST',
                        }).done(getSchedule);
                    } else {
                        alert("η‘ζ³εͺι€οΌθ‘η¨ε§θ³ε°θ¦ζδΈε€©");
                    }
                }
                e.stopPropagation();
            }
            //δ½Ώη¨ηη?±ιει»ζε€©ζΈηθ¨­ε?ιε§ζι
            function setStartTimeHandler(e) {
                var date = $(this).attr("data-date");
                var time = $(this).attr("data-time");
                if (time == "0") {
                    alert("θ«εε ε₯ζ―ι»ε¨θ¨­ε?");
                    return;
                }
                $.ajax({
                    url: "pop-page/set_starttime.jsp?date=" + date + "&time=" + time,
                    method: 'POST',
                }).done(popSetStartTime);
                e.stopPropagation();
            }
            function popSetStartTime(result, status, xhr) {
                $("#pop-setStartTime").html(result);//ε°θ¨­ε?ιε§ζιηι ι’ζΎε₯pop-setStartTime
                $.fancybox.open({
                    src: "#pop-setStartTime"
                });
            }
            //ιε§ζιηι ι’-ζδΈη’Ίε?ζ΄ζ°ιε§ζι
            function UpdateStartTime() {
                var time = $("#setStartTime").val();
                if (!time) {
                    alert("θ«θ¨­ε?ιε§ζι");
                    return;
                }
                $.ajax({
                    url: "update_starttime.do",
                    method: 'POST',
                    data: $("#setStartTimeForm").serialize(),
                }).done(getSchedule);
                $.fancybox.close();
            }

            //δΎε°εη«ι’ει‘εζε°
            function searchTypeHandler(event) {
                $(".searchType").css("color", "#3b5998");
                $(this).css("color", "red");
                var type = $(this).attr("data-type");
                console.log(map.getBounds());
                //Google Maps θηε―«ζ³
                //var E = (map.getBounds().ga.l);//ζ±
                //var S = (map.getBounds().ga.j);//θ₯Ώ
                //var W = (map.getBounds().na.j);//ε
                //var N = (map.getBounds().na.l);//ε    
                
                //Google Maps V3 ε―«ζ³ https://developers.google.com/maps/documentation/javascript/reference/coordinates#LatLng
                var bounds = map.getBounds();
                var E = (map.getBounds().getNorthEast().lng());//ζ±
                var S = (map.getBounds().getSouthWest().lng());//θ₯Ώ
                var W = (map.getBounds().getSouthWest().lat());//ε
                var N = (map.getBounds().getNorthEast().lat());//ε    
                
                rightHandler();
                $("#search").val("");
                $("#searchtype").val("");
                $.ajax({
                    url: "places_list.jsp?maptype=" + type + "&E=" + E + "&S=" + S + "&W=" + W + "&N=" + N,
                    method: 'POST',
                }).done(getPlacesByNameDoneHandler);
            }
            //ζ΄ζε°ι’
            function radioImagePageHandler(result, status, xhr) {
                $("#popBox").html(result);
                $.fancybox.open({
                    src: "#popBox"
                });
                //εζΆζ΄ζΉε°ι’
                $(document).on("click", ".button-normal", function () {
                    $.fancybox.close();
                })
                //η’Ίε?ζ΄ζΉε°ι’
                $(document).on("click", ".button-primary", function () {
                    $.ajax({
                        url: "setcover.do",
                        method: 'POST',
                        data: $("#radioImageForm").serialize(),
                    }).done(getSchedule);
                    $.fancybox.close();
                })
            }
            //εζζε°ζ―ι»
            function rightHandler() {
                $("#tripslide").animate({"left": -350 + "px"}, 300);
            }
            //εζζηθ‘η¨
            function leftHandler() {
                $("#tripslide").animate({"left": 0 + "px"}, 300);
            }
            //Toggleθ‘η¨θ‘¨
            function placedaysHandler(e) {
                var day = $(this).parent().index();
                var x = $($(".toggleTimeCourse")[day]).slideToggle();
            }
            //ζ―ι»θ³θ¨ιι
            function placecardclose() {
                if (directionsDisplay != null) {
                    directionsDisplay.setMap(null);
                    directionsDisplay = null;
                }
                $("#placecard").hide("slide", 500);
            }
            //ζ―ι»θ³θ¨ιε
            function placecardopen() {
                if (directionsDisplay != null) {
                    directionsDisplay.setMap(null);
                    directionsDisplay = null;
                }
                //$("#placecard").show("800");
                $("#placecard").show("slide", 500);
            }

            //ζ°ε’ε€©ζΈ
            function addDay() {
                $.ajax({
                    url: "add_day.do",
                    method: "POST",
                }).done(getSchedule);
            }

            //ηΆεηδΎζΊε€±ζζ
            function getImage(target) {
                $(target).attr("src", "images/logo.png");
            }
            //δΎζ―ι»idζε°ζ―ι»
            function getPlace(placeid) {
                //εζ­₯θ«ζ±
                //location.href="WEB-INF/placecard.jsp?placeId="+placeid;
                //ιεζ­₯
                $.ajax({
                    url: "placecard.jsp?placeId=" + placeid,
                    method: 'POST',
                }).done(getPlaceDoneHandler);
            }
            function getPlaceDoneHandler(result, status, xhr) {
                $("#placecard").html(result);
            }
            //δΎcourse.hashCode() εεΊθ³ζ
            function getCourse(dayHashCode, courseHashCode) {
                //ιεζ­₯
                $.ajax({
                    url: "coursecard.jsp?dayHashCode=" + dayHashCode + "&courseHashCode=" + courseHashCode,
                    method: 'POST',
                }).done(getPlaceDoneHandler);
            }
            function getCourseHandler(result, status, xhr) {
                $("#placecard").html(result);
            }
            //δΎεη¨±ζε°ζ―ι»
            function getPlacesByName() {
                rightHandler();
                $(".searchType").css("color", "#3b5998");
                //εζ­₯θ«ζ±
                //location.href="tripseek.jsp?search="+$("#search").val();
                //ιεζ­₯
                $.ajax({
                    url: "places_list.jsp",
                    method: 'POST',
                    data: $("#searchNameForm").serialize(),
                }).done(getPlacesByNameDoneHandler);
            }
            function getPlacesByNameDoneHandler(result, status, xhr) {
                if (markers != null)
                    for (var x = 0; x < markers.length; x++) {
                        markers[x].setMap(null);
                    }
                markers = [];
                $("#searchplacebyname_ajax").html(result);
                //ε°ζε°η΅ζεζ¨θ¨
                searchPlaceMarker();
            }

            function getRoute(e) {
                var date = $(this).attr("data-date");
                var courseIndex = $(this).attr("data-courseindex");

                $.ajax({
                    url: "route_card.jsp?date=" + date + "&courseIndex=" + courseIndex,
                    method: 'POST',
                }).done(getRouteDoneHandler);
            }
            function getRouteDoneHandler(result, status, xhr) {
                $("#placecard").html(result);
                placecardopen();
            }

            //ηΌιιεζ­₯θ«ζ±ε·ζ°θ‘η¨ι ι’
            var coursetoggle = [];
            function getSchedule() {
                var obj = $(".toggleTimeCourse");
                if (obj.length > 0) {
                    var len = obj.length;
                    for (i = 0; i < len; i++) {
                        coursetoggle[i] = $(obj[i]).css("display");
                    }
                }
                $.ajax({
                    url: "schedule.jsp",
                    method: 'POST',
                }).done(getScheduleDoneHandler);
            }
            function getScheduleDoneHandler(result, status, xhr) {
                $("#schedule").html(result);
                var obj = $(".toggleTimeCourse");
                if (obj.length > 0) {
                    var len = obj.length;
                    for (i = 0; i < len; i++) {
                        $(obj[i]).css("display", coursetoggle[i]);
                    }
                }
                coursetoggle = [];
            }
            //ιεδΏ?ζΉθ‘η¨εη¨±εζ₯ζ
            function scheduleNameDoneHandler() {
                $("#setname").val($("#trip-name").text());
                $("#setdeparture").val($("#departure-date").text());
                $.fancybox.open({
                    src: "#pop-date"
                });
            }
            //ζ΄ζ°θ‘η¨εη¨±εζ₯ζ
            function updateNameDateDoneHandler() {
                var name = $("#setname").val();
                var date = $("#setdeparture").val();
                if (name == null || name.length == 0) {
                    alert("θ«θΌΈε₯θ‘η¨εη¨±");
                    return;
                }
                if (date == null || date.length == 0) {
                    alert("θ«θΌΈε₯εΊηΌζ₯ζ");
                    return;
                }
                $.ajax({
                    url: "update_tripname_departure.do",
                    method: 'GET',
                    data: $("#updateNameDepartureForm").serialize(),
                }).done(getSchedule);
                $.fancybox.close();
            }

        </script>
    </head>
    <body style="height: 100%; min-width: 400px;" onload="init()" >
        <div style="height: 100%;position: relative;">
            <!--header-->
            <jsp:include page="/WEB-INF/subviews/header.jsp"/>
            <!--ηΆ²ι δΈ»θ¦ε§ε?Ή-->
            <section id="container" style="height: calc(100vh - 41px);width:100%;display: block;position: relative;float:left;  display:-webkit-flex; display:flex;-webkit-flex-direction:row;flex-direction:row;" >
                <!--ζηθ‘η¨εεζε°ζ―ι»ε-->
                <article id="articletrip" class="boxitem1">
                    <div id="showBox" style="position: relative;float:left;min-width:350px;width:350px;height:100%;overflow-x: hidden;overflow-y: auto;margin-left:20px;">
                        <div id='tripslide' style="position: relative;width:700px;left: 0px;">
                            <!--ζηθ‘η¨-->
                            <div id="mytrip" style="height:100%;width:50%;position: relative;float: left;">
                                <!--ζ§εΆι -ζηθ‘η¨θζε°ζ―ι»-->
                                <div class="sidebar-title" style="width: 100%; text-align: center;font-size: 14px;height:27px;line-height: 27px;background-color: #3b5998;color: #FFFFFF; position: relative;">
                                    ζηθ‘η¨
                                    <span id="right" title="ζε°ζ―ι»" style="position: absolute;top: 0;right: 0; width: 27px;height: 27px;background-image: url(images/icons/right.png);background-size: cover;background-repeat: no-repeat;background-position: 50% 50%;cursor: pointer;">
                                    </span>
                                </div>
                                <!--θ‘η¨-->
                                <div id="schedule">

                                </div>
                            </div>
                            <!--ζε°ζ―ι»ε-->
                            <div id="searchplaces" style="height:100%;width:50%;position: relative;float: left;">
                                <div class="sidebar-title" style="width: 100%; text-align: center;font-size: 14px;height:27px;line-height: 27px;background-color: #3b5998;color: #FFFFFF; position: relative;">
                                    ζε°ζ―ι»
                                    <span id='left' title="ζηθ‘η¨" style="position: absolute;top: 0;left:0; width: 27px;height: 27px;background-image: url(images/icons/left.png);background-size: cover;background-repeat: no-repeat;background-position: 50% 50%;cursor: pointer;">
                                    </span>
                                </div>
                                <div  id="searchformbyname" style="background-color: white;width: 390px;height: 50px;font-size: 14px;border-radius:3px;box-shadow: 0 2px 2px 0px rgba(0, 0, 0, 0.2);">
                                    <form id="searchNameForm" method="POST" action="javascript:getPlacesByName()" class="scenery-title">
                                        <p>
                                            <label>θ«θΌΈε₯ζ―ι»:</label>
                                            <input id="search" name="search" type="search" placeholder="θ«θΌΈε₯ζ―ι»ιι΅ε­">
                                            <select id="searchtype" name="type">
                                                <option value="">δΈδΎι‘ε</option>
                                                <option value="view">ζ―ι»</option>
                                                <option value="food">ηΎι£</option>
                                                <option value="shop">θ³Όη©</option>
                                                <option value="stay">δ½ε?Ώ</option>
                                            </select>
                                            <span style="text-align: center;"><input type='image' src="images/icons/search.png" alt="ζ₯θ©’" title="ζ₯θ©’" value="ζ₯θ©’" style="width: 20px;display:block;float: right;margin-right: 20px;"></span>
                                        </p>
                                    </form>
                                </div>
                                <div  id="searchTypeByMap" style="background-color: white;width: 300px;height: 50px;font-size: 16px;padding: 15px 0;border-radius:3px;box-shadow: 0 0 2px 2px rgba(0, 0, 0, 0.2);">
                                    <!--<span class="searchType" data-type="">ζ¨θ¦</span>-->
                                    <span class="searchType" data-type="view">ζ―ι»</span>
                                    <span class="searchType" data-type="food">ηΎι£</span>
                                    <span class="searchType" data-type="shop">θ³Όη©</span>
                                    <span class="searchType" data-type="stay">δ½ε?Ώ</span>
                                </div>
                                <div id="searchplacebyname_ajax" style="height: calc(100vh - 68px);">
                                    <!--δΎεη¨±ζε°ζ―ι»ζΎη½?δ½η½?-->
                                </div>
                            </div>
                        </div>
                    </div>
                </article>
                <!--ζ―ι»cardεε°εε-->
                <section id="sectionmap" class="boxitem2">
                    <!--ζ―ι»ζθ·―η·card-->
                    <div id='placecard' class="placecard" style="height: 90%; width: 300px;top:60px;position: absolute; border-top-right-radius: 5px;border-bottom-right-radius: 5px;z-index: 2;background-color: white;display:none;overflow-y: auto;box-shadow: 2px 0 2px 0px rgba(0, 0, 0, 0.2);border-left:1px solid #afafaf;">
                        <!--ζ―ι»ζθ·―η·θ©³η΄°θ³ζ-->
                    </div>
                    <!--ε°ε-->
                    <div id="map" style="height: 100%; width: 100%;position: absolute;border-left:1px solid #afafaf;">
                    </div>
                </section>    
            </section>
        </div>

        <div id="popBox"></div>
    </body>
</html>
