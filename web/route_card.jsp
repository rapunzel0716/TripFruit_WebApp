<%-- 
    Document   : route_card
    Created on : 2019/3/31, 下午 10:03:16
    Author     : Rapunzel_PC
--%>

<%@page import="uuu.tf.entity.RouteType"%>
<%@page import="uuu.tf.entity.Course"%>
<%@page import="java.time.LocalDate"%>
<%@page import="uuu.tf.entity.Schedule"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Schedule route_schedule = (Schedule) session.getAttribute("schedule");
    LocalDate date = LocalDate.parse(request.getParameter("date"));
    int courseIndex = Integer.parseInt(request.getParameter("courseIndex"));
    Course route_course = route_schedule.getCourse(date, courseIndex);
    Course route_courseNext = route_schedule.getCourse(date, courseIndex + 1);
    int routeTime = route_course.getRouteTime();
    int hour = (routeTime / 60) / 60;
    int minute = (routeTime / 60) % 60;
%>
<style>
    .placecardimgdiv{
       width: 100%;/*border-bottom:1px solid lightgrey;*/
    }

    .placecardimg{
        border-radius: 6px;width: 250px;
    }
</style>
<script>
    $(document).ready(initRoute);
    var rendererOptions = {
        suppressMarkers: true,
    };
    function initRoute() {
        $("#route_select option[value=<%=route_course.getRouteType()%>]").attr('selected', true);
        $("#route_select").on('change', onChangeHandler);
        selectControl();
        directionsService = new google.maps.DirectionsService;
        directionsDisplay = new google.maps.DirectionsRenderer(rendererOptions);
        directionsDisplay.setMap(map);

    }
    function selectControl() {
        var route_select_type = $("#route_select").val();
        if (route_select_type == "CUSTOM") {
            $("#route_hour").attr("readonly", false);
            $("#route_minute").attr("readonly", false);
        } else {
            $("#route_hour").attr("readonly", true);
            $("#route_minute").attr("readonly", true);
        }
    }

    function onChangeHandler() {
        selectControl();
        var origin_latlng = {
            lat: <%=route_course.getPlace().getLat()%>,
            lng: <%=route_course.getPlace().getLng()%>
        };
        var destination_latlng = {
            lat: <%=route_courseNext.getPlace().getLat()%>,
            lng: <%=route_courseNext.getPlace().getLng()%>
        };
        var route_select_type = $("#route_select").val();
        if (route_select_type != "CUSTOM") {
            directionsService.route({
                origin: origin_latlng,
                destination: destination_latlng,
                travelMode: route_select_type
            }, function (response, status) {
                if (status == 'OK') {
                    directionsDisplay.setDirections(response);
                    var route = response.routes[0];
                    var Duration = route.legs[0].duration.value;
                    console.log(Duration);
                    $("#route_hour").val(Math.floor((Duration / 60) / 60));
                    $("#route_minute").val(Math.ceil((Duration / 60) % 60));
                } else if(status == 'ZERO_RESULTS') {
                    alert("在起點和終點之間找不到路線。");
                } else {
                    console.log(status);
                }
            });
        } else {
            directionsDisplay.setMap(null);
            directionsDisplay = null;
            directionsDisplay = new google.maps.DirectionsRenderer(rendererOptions);
            directionsDisplay.setMap(map);
            $("#route_hour").val(0);
            $("#route_minute").val(0);
        }
    }

    function update_route() {
        var hour = parseInt($("#route_hour").val());
        var hour_min = parseInt($("#route_hour").attr("min"));
        var minute = parseInt($("#route_minute").val());
        var minute_min = parseInt($("#route_minute").attr("min"));
        if (isNaN(hour) || hour < hour_min || isNaN(minute) || minute < minute_min) {
            alert("請輸入正確的路線時間");
            return;
        }

        placecardclose();
        $.ajax({
            url: "update_route.do",
            method: "GET",
            data: $("#route_selectForm").serialize(),
        }).done(getSchedule);
    }

</script>
<div style="font-size: 18px;line-height: 40px;text-align: center;">路線資訊<div id='routecardbutton' onclick="placecardclose()" class="close"></div></div>
<div style="margin: 20px;">
    <%if (route_courseNext != null) {%>
    <!--路線card-->
    <div style="line-height: 25px;text-align: left;">
        <div class="placecardimgdiv"><img class="placecardimg" src="<%=route_course.getPlace().getPhoto()%>" onerror="getImage(this)">
        </div>
        <span id="route_course" data-lat="<%=route_course.getPlace().getLat()%>" data-lng="<%=route_course.getPlace().getLng()%>">
            <%=route_course.getPlace().getName()%>
        </span> 到<br> 
        <div class="placecardimgdiv"><img class="placecardimg" src="<%=route_courseNext.getPlace().getPhoto()%>" onerror="getImage(this)">
        </div>
        <span id="route_courseNext" data-lat="<%=route_courseNext.getPlace().getLat()%>" data-lng="<%=route_courseNext.getPlace().getLng()%>">
            <%=route_courseNext.getPlace().getName()%>
        </span>
    </div >
    <div style="line-height: 40px;text-align: right;">
        <a style="color: blue;"  target="_blank" href="https://www.google.com/maps?q=<%=route_course.getPlace().getName()%>到<%=route_courseNext.getPlace().getName()%>">
            在Google Map上查看
        </a>
    </div>  
    <form id="route_selectForm" action="update_route.do" method="POST">
        <input type="hidden" name="date" value="<%=date%>">
        <input type="hidden" name="placeId" value="<%=route_course.getPlace().getId()%>">
        <input type="hidden" name="startTime" value="<%=route_course.getStarttime()%>">
        <p>
            <select id="route_select" name="route_type">
                <option value="<%=RouteType.DRIVING%>"><%=RouteType.DRIVING.getDescription()%></option>
                <option value="<%=RouteType.TRANSIT%>"><%=RouteType.TRANSIT.getDescription()%></option>
                <option value="<%=RouteType.WALKING%>"><%=RouteType.WALKING.getDescription()%></option>
                <option value="<%=RouteType.CUSTOM%>" ><%=RouteType.CUSTOM.getDescription()%></option>
            </select><br>
        </p>
        <p>
            <input name="route_hour" id="route_hour" type="number" min="0" value="<%=hour%>" style="width: 50px;">時
            <input name="route_minute" id="route_minute" type="number" min="0"  value="<%=minute%>" style="width: 50px;">分<br>
        </p><br><br>
        <input type="button" onclick="update_route()" class="button" style="float: right;" value="設定路線">
    </form>
    <%}%>
    <br><br><br><br>
    
</div>