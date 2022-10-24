<%-- 
    Document   : tripseek
    Created on : 2019/3/13, 下午 04:10:54
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
        <script src="https://maps.googleapis.com/maps/api/js?key=金鑰&libraries=places" async defer></script>
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
                //關閉POI點擊
                map.setClickableIcons(false);
                map.setOptions({styles: styles['hide']});
                infowindow = new google.maps.InfoWindow();
                //放在地圖左上角
                map.controls[google.maps.ControlPosition.LEFT_TOP].push($("#searchformbyname")[0]);
                //放在地圖右上角
                map.controls[google.maps.ControlPosition.TOP_RIGHT].push($("#searchTypeByMap")[0]);
                //發送非同步請求行程
                getSchedule();
                //開關點擊的行程
                $(document).on("click", ".placedays", placedaysHandler);
                //$(document).on("click", ".placedays", dayBoundsHandler);
                //點擊刪除天數
                $(document).on("click", ".deletedate", deletedateHandler);
                //點擊天數的出發時間
                $(document).on("click", ".setstarttime", setStartTimeHandler);
                //切換我的行程與搜尋景點
                $("#right").click(rightHandler);
                $("#left").click(leftHandler);
                //點選行程封面時，發送非同步請求radio_image.jsp頁面
                $(document).on("click", ".tripimages", function () {
                    $.ajax({
                        url: "pop-page/radio_image.jsp",
                        method: 'POST',
                    }).done(radioImagePageHandler);
                });

                $(".searchType").click(searchTypeHandler);
                //按下設定停留時間
                $(document).on("click", "#setStayTime", popStayTime);
                $(document).on("click", ".getroute", getRoute);
            }
            //使用燈箱開啟設定停留時間
            function popStayTime() {
                var time = $("#stay").attr("data-stay");
                $("#setStayTimeInput").val(time);//將目前的停留的值 傳給setStayTimeInput
                $.fancybox.open({
                    src: "#pop-stayTime"
                });
            }
            //更新停留時間
            function updateStartTime() {
                var time = parseInt($("#setStayTimeInput").val());
                var min = parseInt($("#setStayTimeInput").attr("min"));
                if (isNaN(time) || time < min) {
                    alert("請輸入正確的停留時間");
                    return;
                }
                $.ajax({
                    url: "update_stay.do",
                    method: 'POST',
                    data: $("#setStayForm").serialize(),
                }).done(getSchedule);
                $("#stayTime").text(time + "分");
                $("#stay").attr("data-stay", time);
                $.fancybox.close();
            }
            //刪除點擊天數
            function deletedateHandler(e) {
                if (confirm("確定要刪除這一天嗎？")) {
                    var len = $(".places").length;
                    var date = $(this).attr("data-date");
                    if (len > 1) {
                        $.ajax({
                            url: "deletedate.do?date=" + date,
                            method: 'POST',
                        }).done(getSchedule);
                    } else {
                        alert("無法刪除，行程內至少要有一天");
                    }
                }
                e.stopPropagation();
            }
            //使用燈箱開啟點擊天數的設定開始時間
            function setStartTimeHandler(e) {
                var date = $(this).attr("data-date");
                var time = $(this).attr("data-time");
                if (time == "0") {
                    alert("請先加入景點在設定");
                    return;
                }
                $.ajax({
                    url: "pop-page/set_starttime.jsp?date=" + date + "&time=" + time,
                    method: 'POST',
                }).done(popSetStartTime);
                e.stopPropagation();
            }
            function popSetStartTime(result, status, xhr) {
                $("#pop-setStartTime").html(result);//將設定開始時間的頁面放入pop-setStartTime
                $.fancybox.open({
                    src: "#pop-setStartTime"
                });
            }
            //開始時間的頁面-按下確定更新開始時間
            function UpdateStartTime() {
                var time = $("#setStartTime").val();
                if (!time) {
                    alert("請設定開始時間");
                    return;
                }
                $.ajax({
                    url: "update_starttime.do",
                    method: 'POST',
                    data: $("#setStartTimeForm").serialize(),
                }).done(getSchedule);
                $.fancybox.close();
            }

            //依地圖畫面及類型搜尋
            function searchTypeHandler(event) {
                $(".searchType").css("color", "#3b5998");
                $(this).css("color", "red");
                var type = $(this).attr("data-type");
                console.log(map.getBounds());
                //Google Maps 舊版寫法
                //var E = (map.getBounds().ga.l);//東
                //var S = (map.getBounds().ga.j);//西
                //var W = (map.getBounds().na.j);//南
                //var N = (map.getBounds().na.l);//北    
                
                //Google Maps V3 寫法 https://developers.google.com/maps/documentation/javascript/reference/coordinates#LatLng
                var bounds = map.getBounds();
                var E = (map.getBounds().getNorthEast().lng());//東
                var S = (map.getBounds().getSouthWest().lng());//西
                var W = (map.getBounds().getSouthWest().lat());//南
                var N = (map.getBounds().getNorthEast().lat());//北    
                
                rightHandler();
                $("#search").val("");
                $("#searchtype").val("");
                $.ajax({
                    url: "places_list.jsp?maptype=" + type + "&E=" + E + "&S=" + S + "&W=" + W + "&N=" + N,
                    method: 'POST',
                }).done(getPlacesByNameDoneHandler);
            }
            //更換封面
            function radioImagePageHandler(result, status, xhr) {
                $("#popBox").html(result);
                $.fancybox.open({
                    src: "#popBox"
                });
                //取消更改封面
                $(document).on("click", ".button-normal", function () {
                    $.fancybox.close();
                })
                //確定更改封面
                $(document).on("click", ".button-primary", function () {
                    $.ajax({
                        url: "setcover.do",
                        method: 'POST',
                        data: $("#radioImageForm").serialize(),
                    }).done(getSchedule);
                    $.fancybox.close();
                })
            }
            //切換搜尋景點
            function rightHandler() {
                $("#tripslide").animate({"left": -350 + "px"}, 300);
            }
            //切換我的行程
            function leftHandler() {
                $("#tripslide").animate({"left": 0 + "px"}, 300);
            }
            //Toggle行程表
            function placedaysHandler(e) {
                var day = $(this).parent().index();
                var x = $($(".toggleTimeCourse")[day]).slideToggle();
            }
            //景點資訊關閉
            function placecardclose() {
                if (directionsDisplay != null) {
                    directionsDisplay.setMap(null);
                    directionsDisplay = null;
                }
                $("#placecard").hide("slide", 500);
            }
            //景點資訊開啟
            function placecardopen() {
                if (directionsDisplay != null) {
                    directionsDisplay.setMap(null);
                    directionsDisplay = null;
                }
                //$("#placecard").show("800");
                $("#placecard").show("slide", 500);
            }

            //新增天數
            function addDay() {
                $.ajax({
                    url: "add_day.do",
                    method: "POST",
                }).done(getSchedule);
            }

            //當圖片來源失效時
            function getImage(target) {
                $(target).attr("src", "images/logo.png");
            }
            //依景點id搜尋景點
            function getPlace(placeid) {
                //同步請求
                //location.href="WEB-INF/placecard.jsp?placeId="+placeid;
                //非同步
                $.ajax({
                    url: "placecard.jsp?placeId=" + placeid,
                    method: 'POST',
                }).done(getPlaceDoneHandler);
            }
            function getPlaceDoneHandler(result, status, xhr) {
                $("#placecard").html(result);
            }
            //依course.hashCode() 列出資料
            function getCourse(dayHashCode, courseHashCode) {
                //非同步
                $.ajax({
                    url: "coursecard.jsp?dayHashCode=" + dayHashCode + "&courseHashCode=" + courseHashCode,
                    method: 'POST',
                }).done(getPlaceDoneHandler);
            }
            function getCourseHandler(result, status, xhr) {
                $("#placecard").html(result);
            }
            //依名稱搜尋景點
            function getPlacesByName() {
                rightHandler();
                $(".searchType").css("color", "#3b5998");
                //同步請求
                //location.href="tripseek.jsp?search="+$("#search").val();
                //非同步
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
                //將搜尋結果做標記
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

            //發送非同步請求刷新行程頁面
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
            //開啟修改行程名稱及日期
            function scheduleNameDoneHandler() {
                $("#setname").val($("#trip-name").text());
                $("#setdeparture").val($("#departure-date").text());
                $.fancybox.open({
                    src: "#pop-date"
                });
            }
            //更新行程名稱及日期
            function updateNameDateDoneHandler() {
                var name = $("#setname").val();
                var date = $("#setdeparture").val();
                if (name == null || name.length == 0) {
                    alert("請輸入行程名稱");
                    return;
                }
                if (date == null || date.length == 0) {
                    alert("請輸入出發日期");
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
            <!--網頁主要內容-->
            <section id="container" style="height: calc(100vh - 41px);width:100%;display: block;position: relative;float:left;  display:-webkit-flex; display:flex;-webkit-flex-direction:row;flex-direction:row;" >
                <!--我的行程區及搜尋景點區-->
                <article id="articletrip" class="boxitem1">
                    <div id="showBox" style="position: relative;float:left;min-width:350px;width:350px;height:100%;overflow-x: hidden;overflow-y: auto;margin-left:20px;">
                        <div id='tripslide' style="position: relative;width:700px;left: 0px;">
                            <!--我的行程-->
                            <div id="mytrip" style="height:100%;width:50%;position: relative;float: left;">
                                <!--控制項-我的行程與搜尋景點-->
                                <div class="sidebar-title" style="width: 100%; text-align: center;font-size: 14px;height:27px;line-height: 27px;background-color: #3b5998;color: #FFFFFF; position: relative;">
                                    我的行程
                                    <span id="right" title="搜尋景點" style="position: absolute;top: 0;right: 0; width: 27px;height: 27px;background-image: url(images/icons/right.png);background-size: cover;background-repeat: no-repeat;background-position: 50% 50%;cursor: pointer;">
                                    </span>
                                </div>
                                <!--行程-->
                                <div id="schedule">

                                </div>
                            </div>
                            <!--搜尋景點區-->
                            <div id="searchplaces" style="height:100%;width:50%;position: relative;float: left;">
                                <div class="sidebar-title" style="width: 100%; text-align: center;font-size: 14px;height:27px;line-height: 27px;background-color: #3b5998;color: #FFFFFF; position: relative;">
                                    搜尋景點
                                    <span id='left' title="我的行程" style="position: absolute;top: 0;left:0; width: 27px;height: 27px;background-image: url(images/icons/left.png);background-size: cover;background-repeat: no-repeat;background-position: 50% 50%;cursor: pointer;">
                                    </span>
                                </div>
                                <div  id="searchformbyname" style="background-color: white;width: 390px;height: 50px;font-size: 14px;border-radius:3px;box-shadow: 0 2px 2px 0px rgba(0, 0, 0, 0.2);">
                                    <form id="searchNameForm" method="POST" action="javascript:getPlacesByName()" class="scenery-title">
                                        <p>
                                            <label>請輸入景點:</label>
                                            <input id="search" name="search" type="search" placeholder="請輸入景點關鍵字">
                                            <select id="searchtype" name="type">
                                                <option value="">不依類型</option>
                                                <option value="view">景點</option>
                                                <option value="food">美食</option>
                                                <option value="shop">購物</option>
                                                <option value="stay">住宿</option>
                                            </select>
                                            <span style="text-align: center;"><input type='image' src="images/icons/search.png" alt="查詢" title="查詢" value="查詢" style="width: 20px;display:block;float: right;margin-right: 20px;"></span>
                                        </p>
                                    </form>
                                </div>
                                <div  id="searchTypeByMap" style="background-color: white;width: 300px;height: 50px;font-size: 16px;padding: 15px 0;border-radius:3px;box-shadow: 0 0 2px 2px rgba(0, 0, 0, 0.2);">
                                    <!--<span class="searchType" data-type="">推薦</span>-->
                                    <span class="searchType" data-type="view">景點</span>
                                    <span class="searchType" data-type="food">美食</span>
                                    <span class="searchType" data-type="shop">購物</span>
                                    <span class="searchType" data-type="stay">住宿</span>
                                </div>
                                <div id="searchplacebyname_ajax" style="height: calc(100vh - 68px);">
                                    <!--依名稱搜尋景點放置位置-->
                                </div>
                            </div>
                        </div>
                    </div>
                </article>
                <!--景點card及地圖區-->
                <section id="sectionmap" class="boxitem2">
                    <!--景點或路線card-->
                    <div id='placecard' class="placecard" style="height: 90%; width: 300px;top:60px;position: absolute; border-top-right-radius: 5px;border-bottom-right-radius: 5px;z-index: 2;background-color: white;display:none;overflow-y: auto;box-shadow: 2px 0 2px 0px rgba(0, 0, 0, 0.2);border-left:1px solid #afafaf;">
                        <!--景點或路線詳細資料-->
                    </div>
                    <!--地圖-->
                    <div id="map" style="height: 100%; width: 100%;position: absolute;border-left:1px solid #afafaf;">
                    </div>
                </section>    
            </section>
        </div>

        <div id="popBox"></div>
    </body>
</html>
