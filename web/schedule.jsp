<%-- 
    Document   : Schedule
    Created on : 2019/4/1, 下午 04:59:23
    Author     : Admin
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.List"%>
<%@page import="uuu.tf.entity.Place"%>
<%@page import="uuu.tf.model.PlaceService"%>
<%@page import="uuu.tf.entity.Course"%>
<%@page import="uuu.tf.entity.TripDay"%>
<%@page import="uuu.tf.entity.Schedule"%>
<%@page import="java.time.LocalDate"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Schedule schedule = (Schedule) session.getAttribute("schedule");
    if (schedule == null || schedule.isEmpty()) {
        schedule = new Schedule();
        schedule.addTripDay(LocalDate.now());
        session.setAttribute("schedule", schedule);
    }
%>
<script>
    $(document).ready(initSchedule);

    function initSchedule() {
        //將schedule內的景點的地圖標記全部清空
        if (schedule_markers != null)
            for (var x = 0; x < schedule_markers.length; x++) {
                for (var y = 0; y < schedule_markers[x].length; y++) {
                    schedule_markers[x][y].setMap(null);
                }
            }
        schedule_markers = [];

        //$(".placedays").click(tripDayClickHandler);
        //將schedule內的景點一一取出在地圖標記
    <%if (!(schedule == null && schedule.isEmpty())) {%>
        bounds = new google.maps.LatLngBounds();
        var day = 1;
    <%for (TripDay day : schedule.getTripDayList()) {%>
        var x = 0;
        var day_markers = [];
    <%
        for (Course course : day.getTripCourse()) {
            Place p = course.getPlace();
    %>

        var latlng = {lat: <%=p.getLat()%>, lng: <%=p.getLng()%>};
        var image = {
            url: 'images/icons/point-blue.png',
            //縮放後的大小
            scaledSize: new google.maps.Size(26, 40),
        };
        //將景點放入schedule_markers陣列內
        day_markers[x] = new google.maps.Marker({
            map: map,
            position: latlng,
            zIndex:3,
            label: {text: (x + 1) + '', color: "white"},
            'margin-top': "-2px",
        });
        //當滑鼠進入標記 開啟景點資訊頁面
        day_markers[x].addListener('mouseover', function () {
            infowindow.setContent("<div><img style='width: 100px' src='<%=p.getPhoto()%>' onerror='getImage(this)' ></div><div><%=p.getName()%></div>");
            infowindow.open(map, this);
        });
        //當滑鼠離開標記，關閉景點資訊
        day_markers[x].addListener('mouseout', function () {
            infowindow.close();
        });
        //當標記按下 開啟 景點資訊卡
        day_markers[x].addListener('click', function () {
            placecardopen();
            getCourse('<%=day.hashCode()%>', '<%=course.hashCode()%>');
        });
        courseClickDoneHandler(day, x);
        x++;
    <%}%>
        schedule_markers.push(day_markers);
        day++;
    <%}%>
    <%}%>
        $(".toggleTimeCourse .timeCourse:last-child .route").css("display", "none");
        $(".toggleTimeCourse .timeCourse:last-child").css("height", "100px");
    }
    function courseClickDoneHandler(day, x) {
        $(document).on("click", "#place" + day + "-" + x, function () {
            placecardopen();
            google.maps.event.trigger(schedule_markers[day - 1][x], 'mouseover');
            map.panTo(schedule_markers[day - 1][x].getPosition());
        });
    }

    //行程產生排序時
    $(function () {
        var start_arr;
        var sort = $(".toggleTimeCourse").sortable({
            delay: 150,
            cursor: 'move',
            placeholder: "ui-state-highlight",
            forcePlaceholderSize: true,
            start: function () {
                //記錄sort前的id順序陣列
                start_arr = $(this).sortable('toArray');
            },
            stop: function () {
                //記錄sort後的id順序陣列
                var arr = $(this).sortable('toArray');
                var date = $('#' + arr[0]).attr('data-tripdate');
                var list = $(this).sortable('toArray', {attribute: "data-list"});
                //順序改變才發送請求
                if (start_arr.toString() !== arr.toString()) {
                    $.ajax({
                        url: "sortable_schedule.do?date=" + date + "&list=" + list,
                        method: 'POST',
                    }).done(getSchedule);
                }
            }
        });
    });
    function savetrip() {
        $.ajax({
            url: "savetrip.do",
            method: 'POST',
        }).done(savetripDoneHandler);
    }
    function savetripDoneHandler(result, status, xhr) {
        $("#schedule").html(result).promise().done(function () {
            $.fancybox.open({
                src: "#pop-save"
            });
            setTimeout(function () {
                $.fancybox.close();
            }, 850);
        });
    }
</script>
<div id="pop-save" style="width: 200px;height: 80px;display: none;">
    <%
        List<String> errors = (List<String>) request.getAttribute("errors");
        String success = (String) request.getAttribute("success");
        if (errors != null && errors.size() > 0) {
            out.print(errors);
        }
        if (success != null) {
            out.print(success);
        }
    %>
</div>
<div style="overflow-y: auto;height: calc(100vh - 140px);">
    <!--行程名稱及日期-->
    <div style="position: relative;float: left;width: 100%;padding: 5px;">
        <div class="scheduleName" style="position: relative;float: left; width: 200px; ">
            <div class="ellipsis-content" id="trip-name"><%=schedule.getTripName()%></div>
            <div class="date"><span id="departure-date"><%=schedule.getFirstDay()%></span> ~ <span id="last-date"><%=schedule.getLastDay()%></span></div>
        </div>
        <div style="position: relative;float: left; width: 100px;height: 40px;">
            <img src="images/icons/calendar.png" style="width: 35px;float: right;cursor: pointer;" title="更改名稱及出發日期"  onclick="scheduleNameDoneHandler()">
        </div>
        <div class="tripimages" style="background-image: url(images/cover/<%=schedule.getCover()%>);">
        </div>
        <!--更改名稱或出發日期-->
        <div id="pop-date" style="display: none;width: 300px;">
            <form id="updateNameDepartureForm" method="POST">
                <label>行程名稱</label>
                <input id="setname" type="text" name="name"><br><br>
                <label>出發日期</label>
                <input id="setdeparture" type="date" name="date"><br><br><br>
                <input type="button" class="button" style="float: right;" onclick="updateNameDateDoneHandler()" value="確定">
            </form>
        </div>
    </div>
    <!--行程完整內容-->
    <div id="trip">
        <!--行程天數1-->
        <%for (TripDay day : schedule.getTripDayList()) {
                int days = schedule.getDayIndex(day) + 1;
        %>
        <div id='day<%=days%>' class="places">
            <div id='placesdate<%=days%>' class='placedays' data-date="<%=day.getTripdate()%>">
                <span style="float: left;">Day<span id="day<%=days%>"> <%=days%> </span> ----------------- <span id='date<%=days%>'><%=day.getTripdate()%></span></span>
                <div id='setstarttime<%=day.getTripdate()%>' class="setstarttime" data-date="<%=day.getTripdate()%>" data-time="<%=day.isEmpty() ? "0" : day.getCourse(0).getStarttime()%>" title="設定出發時間" ></div>
                <div id='deletedate<%=day.getTripdate()%>' class="deletedate" data-date="<%=day.getTripdate()%>" title="刪除天數" ></div>

            </div>
            <ul id="toggleTimeCourse<%=days%>" class="toggleTimeCourse" style="display:none">
                <%
                    int x = 0;
                    for (Course course : day.getTripCourse()) {
                %>
                <li id="timeCourse<%=(days + "-" + x)%>" class="timeCourse" data-list="<%=x%>" data-tripdate="<%=day.getTripdate()%>" data-placeId="<%=course.getPlace().getId()%>" data-stay="<%=course.getStay()%>" data-route="<%=course.getRouteTime()%>">                    
                    <a href="javascript:getCourse(<%=day.hashCode()%>,<%=course.hashCode()%>)" data-hashcode="<%=course.hashCode()%>">
                        <div id="place<%=(days + "-" + x)%>" class='place'>
                            <div class="courseTimeType">
                                <div class="courseTime">
                                    <div class="time-string"><%=course.getStarttime()%></div>
                                </div>
                                <div class="typeScenery">
                                    <img alt="<%=course.getPlace().getType().getDescription()%>" title="<%=course.getPlace().getType().getDescription()%>" src="<%=request.getContextPath()%>/images/icons/gray-<%=course.getPlace().getType()%>.png" style="width: 40px;">
                                </div>
                            </div>
                            <div class="coursePlace">
                                <div class="coursePlaceName">
                                    <span class="nameTitle"><%=course.getPlace().getName()%></span>
                                </div>
                                <div class="courseStay">停留時間 : <%=course.getStay()%> 分</div>
                            </div>
                        </div>
                    </a>
                    <div class='route'> <%=course.getLeaveTime()%> ~ <%=course.getArrivalTime()%> <span style="font-size: 12px;">共花費<%=course.getRouteTimeString()%></span>
                        <div class="getroute" data-date="<%=day.getTripdate()%>" data-courseindex="<%=x%>" style="float: right; font-size: 14px;margin-right: 10px;color: blue;cursor: pointer;">
                            <%=course.getRouteType().getDescription()%>
                        </div>
                    </div>
                </li>
                <%  x++;
                    }%>
            </ul>
        </div>
        <%}%>
    </div>
</div>
<!--增加天數-->
<div id="days" style="margin-right: 1px;">
    <div id="addDay" class="controlday button" onclick="addDay('<%=schedule.getLastDay()%>')">新增天數</div>
    <div id="savetrip" class="controlday button" onclick="savetrip()" >存檔</div>
</div>
<!--設定開始時間-->
<div id="pop-setStartTime" style="display: none"></div>
