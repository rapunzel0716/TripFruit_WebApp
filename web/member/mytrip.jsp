<%-- 
    Document   : mytrip
    Created on : 2019/3/26, 下午 11:18:29
    Author     : Rapunzel_PC
--%>

<%@page import="uuu.tf.model.SchedulesService"%>
<%@page import="java.util.List"%>
<%@page import="uuu.tf.entity.Schedule"%>
<%@page import="uuu.tf.entity.Member"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <%@include file="/WEB-INF/subviews/global.jsp" %>
        <title>TripFruit</title>
        <style>
            nav ul:nth-child(1) li:nth-child(3){background-color: #e5e5e5;}
            nav ul:nth-child(1) li:nth-child(3) a:hover{color: black;}
            #container{
                display:-webkit-flex;
                display:flex;
                -webkit-flex-direction:row;
                flex-direction:row;
                width: 100%;
                height: calc(100vh - 41px);
            }
            .boxitem{
                text-align:center;
                width:220px;
                height:100%;
            }
            #myTrip{
                -webkit-flex-grow:1;
                flex-grow:1;
                flex-shrink: 1;
                margin-left: 50px;
            }
            #recommendedTrip{
                -webkit-flex-grow:1;
                flex-grow:2;
                flex-shrink: 2;
            }
            .content{
                height: calc(100% - 35px);
                width: 95%;
                background-color: white;
                border-radius: 2px;
                box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);
                border-top: 3px solid #3b5998;
                overflow-y: auto;
            }
            .main-tabs{
                margin-top: 5px;
            }
            .main-tab {
                background-color: #3b5998;
                color: #FFFFFF;
                width:  132px;
                border: 1px solid #3b5998;
                border-bottom: 0;
                border-top-left-radius: 10px;
                border-top-right-radius: 10px;
                line-height: 25px;
            }
            .newTripButton{
                margin: 10px 0 10px 10px;    cursor: pointer;
                background: #906b4e;box-shadow: 4px 4px 0px 0px #dbcfc5;color: #FFFFFF;font-size: 16px;border-radius: 5px;width: 180px;height: 35px;line-height: 35px;

            }
            .block-content{
                border-radius: 10px;
                width: 190px;
                -webkit-box-shadow: -1px -1px rgba(0, 0, 0, 0.05);
                box-shadow: -1px -1px rgba(0, 0, 0, 0.05);
                margin: 10px 0 0px 10px;
                background-color: white;
                cursor: pointer;
                position: relative;
                border: 0.5px solid #DCDCDD;
                box-shadow: 0 4px 4px 0 rgba(0, 0, 0, 0.2);
                float: left;
            }
            .image{
                width: 100%;
                height: 0;
                padding-bottom: 50%;
                background-size: cover;
                background-repeat: no-repeat;
                background-position: 50% 50%;
                border-bottom-right-radius: 5px;
                border-bottom-left-radius: 5px;
            }
            .action{
                position: absolute;
                right: 10px;
                bottom: 5px;
                clear: both;
            }
            .text{
                position: relative;
                height: 80px;
                padding: 5px 10px;
            }
            .days{
                float: right;
            }
            .tag-member{
                position: absolute;left: 0;
            }
            /*以下為fancybox彈出的  推薦詳細內容*/
            .pop-up-layout{
                width: 900px;height: 580px;
                min-height: 180px;
                max-height: 600px;
                position: relative;
                display: -webkit-box;
                display: -ms-flexbox;
                display: flex;
                -webkit-box-orient: vertical;
                -webkit-box-direction: normal;
                -ms-flex-flow: column;
                flex-flow: column;
            }
            .pop-up-header {
                background-color: #FFFFFF;
                width: 100%;
                height: 60px;
                position: relative;
                border-bottom: 1px solid black;
            }
            .header-title {
                position: absolute;
                top: 20px;
                left: 73px;
                right: 73px;
                height: 25px;
                font-size: 18px;
                text-align: center;
                overflow: hidden;
                white-space: nowrap;
                text-overflow: ellipsis;
            }
            .pop-up-body{
                height: 500px;
                width: 900px;
                padding-left: 33.5px;
                padding-right: 24px;
                overflow-y: auto;
            }
            .travel-preview-item {
                position: relative;
                height: 240px;
                border-bottom: 1px solid #285e8e;
                overflow-x: auto;
            }
            .travel-title{
                position: relative;
                width: 842.5px;
                height: 28px;
                margin-bottom: 12px;
            }
            .day-count{
                position: absolute;
                top: 0;
                left: 10px;
                width: 69px;
                height: 28px;
                background-color: #FFFFFF;
            }
            .date {
                position: absolute;
                top: 0;
                right: 15px;
                width: 74px;
                height: 28px;
                background-color: #FFFFFF;
                font-size: 12px;
                line-height: 28px;
                color: #23B7C1;
                text-align: center;
            }
            .main-item{
                position: relative;
                width: 110px;
                height: 170px;
                display: -webkit-box;
                display: -ms-flexbox;
                display: flex;
                -ms-flex-line-pack: center;
                align-content: center;
                -webkit-box-align: center;
                -ms-flex-align: center;
                align-items: center;
                -webkit-box-orient: vertical;
                -webkit-box-direction: normal;
                -ms-flex-direction: column;
                flex-direction: column;
                float: left;
            }
            .pop-image{
                width: 80px;height: 80px;
                margin-bottom: 5px;background-position: center;
                background-repeat: no-repeat;
                background-size: cover;
            }
            .pop-point{
                background-image: url(../images/icons/point-blue.png);
                position: relative;
                width: 26px;
                height: 40px;
                background-position: center;
                background-repeat: no-repeat;
                background-size: cover;
            }
            .num {
                position: absolute;
                left: 3px;
                top: 3px;
                width: 20px;
                height: 20px;
                font-size: 12px;
                line-height: 22px;
                text-align: center;
                color: #23B7C1;
            }

        </style>
        <script>
            $(document).ready(init);
            function init() {
                //點擊行程時，依id開啟schedule
                $(".myTripContent").on("click", getSchedule);
                //寄送行程
                $(".mailschedule").on("click", mailSchedule);
                //刪除行程
                $(".deleteschedule").on("click", deleteSchedule);
                //複製行程
                $(".copyschedule").on("click", copySchedule);
                //行程詳細
                $(".magnifier").on("click", scheduleDetailHandler);
                //$(".suggest").click(suggestDoneHandler);
                $(".newTripButton").click(newTripButtonDoneHandler);
            }
            function getSchedule() {
                var scheduleId = $(this).attr("data-id");
                $.ajax({
                    url: "getschedule.do?scheduleId=" + scheduleId,
                    method: 'POST',
                }).done(getScheduleDoneHandler);
            }
            function getScheduleDoneHandler() {
                location.href = "../tripseek.jsp";
            }
            //寄送行程
            function mailSchedule(e) {
                var id = $(this).attr("data-id");
                $.ajax({
                    url: "mail_schedule.do?scheduleId=" + id,
                    method: 'POST',
                }).done();
                alert("信件已發送");
                e.stopPropagation();
            }
            //刪除行程
            function deleteSchedule(e) {
                if (confirm("確定要刪除此行程嗎？")) {
                    var id = $(this).attr("data-id");
                    location.href = "delete_schedule.do?scheduleId=" + id;
                }
                e.stopPropagation();
            }
            //複製行程
            function copySchedule(e) {
                var id = $(this).attr("data-id");
                location.href = "copy_schedule.do?scheduleId=" + id;
                e.stopPropagation();
            }
            //獲得行程詳細
            function scheduleDetailHandler(e) {
                var id = $(this).attr("data-id");
                $.ajax({
                    url: "schedule_detail.jsp?scheduleId=" + id,
                    method: 'POST',
                }).done(scheduleDetailDoneHandler);

                e.stopPropagation();
            }
            function scheduleDetailDoneHandler(result, status, xh) {
                $("#fancybox-trip").html(result);
                $.fancybox.open({
                    src: "#fancybox-trip",
                });

            }


            function newTripButtonDoneHandler() {
                //location.href = "../tripseek.jsp";
                $.ajax({
                    url: "../pop-page/newtrip.jsp",
                    method: 'POST',
                }).done(getNewTripHandler);
            }
            function getNewTripHandler(result, status, xh) {
                $("#pop-date").html(result);
                $.fancybox.open({
                    src: "#pop-date"
                });
            }

            function suggestDoneHandler() {
                //TODO
                $.fancybox.open({
                    src: "#fancybox-trip"
                });
            }
        </script>
    </head>
    <body>
        <div style="min-width: 400px;">
            <jsp:include page="/WEB-INF/subviews/header.jsp"/>
            <div id="container" >
                <!--我的行程-->
                <div id="myTrip" class="boxitem">
                    <div class="main-tabs">
                        <div class="main-tab">我的行程</div>
                    </div>
                    <div class="sidebar-content content">
                        <div>
                            <div class="newTripButton" style=""> 建立新行程</div>
                        </div>

                        <%
                            Member member = (Member) session.getAttribute("member");
                            List<Schedule> list = null;

                            if (member != null) {
                                SchedulesService service = new SchedulesService();
                                list = service.searchSchedulesByMemberUid(member.getUid());
                            }

                            if (list != null && !(list.isEmpty())) {
                                for (Schedule schedule : list) {
                                    if (!(schedule.isEmpty())) {
                        %> 

                        <div class="block-content myTripContent" data-id="<%=schedule.getId()%>">
                            <div class="text">
                                <div class="ellipsis-container">
                                    <div class="ellipsis-content"><%= schedule.getTripName()%></div>
                                </div>
                                <div class="schedule" style="font-size: 14px;"><%= schedule.getFirstDay()%>~<%=schedule.getLastDay()%></div>
                                <div class="action">
                                    <img class="mailschedule" data-id="<%=schedule.getId()%>" title="寄送行程到我的信箱" src="../images/icons/mail.png" style='width: 20px;height: 20px;'>
                                    <img class="deleteschedule" data-id="<%=schedule.getId()%>" title="刪除行程" src="../images/icons/delete.png" style='width: 20px;height: 20px;'>
                                    <img class="copyschedule" data-id="<%=schedule.getId()%>" title="複製行程" src="../images/icons/copy.png" style='width: 20px;height: 20px;'>
                                    <img class="magnifier" data-id="<%=schedule.getId()%>" title="檢視行程" src="../images/icons/magnifier.png" style='width: 20px;height: 20px;'>
                                </div>
                            </div>
                            <div class="image" style="background-image:url('../images/cover/<%=schedule.getCover()%>')">
                            </div>
                        </div>

                        <%}%>
                        <%}%>
                        <%}%>
                    </div>
                </div>
                <!--參考行程-->
                <!--                <div id="recommendedTrip" class="boxitem">
                                    <div class="main-tabs">
                                        <div class="main-tab">推薦行程</div>
                                    </div>
                                    <div class="reference-content content">
                                        推薦範例行程
                                        <div class="block-content suggest">
                                            <div class="text">
                                                <div class="" title="台北一日遊">
                                                    <div class="ellipsis-content">台北一日遊</div>
                                                </div>
                                                <div class="feature">
                                                    <div class="tag-member">用戶:張三豐</div>
                                                    <div class="days">1天</div>
                                                </div>
                                                <div class="action">
                                                    <img src="../images/icons/copy.png" style='width: 20px;height: 20px;'>
                                                </div>
                                            </div>
                                            <div class="image" style="background-image: url(&quot;https://www.foru-tek.com/Image/Cover/Cover_239.png&quot;);"></div>
                                        </div>
                                        推薦範例行程
                                        <div class="block-content suggest">
                                            <div class="text">
                                                <div class="" title="台北二日遊">
                                                    <div class="ellipsis-content">台北二日遊</div>
                                                </div>
                                                <div class="feature">
                                                    <div class="tag-member">用戶:李四方</div>
                                                    <div class="days">2天</div>
                                                </div>
                                                <div class="action">
                                                    <img src="../images/icons/copy.png" style='width: 20px;height: 20px;'>
                                                </div>
                                            </div>
                                            <div class="image" style="background-image: url(&quot;https://www.foru-tek.com/Image/Cover/Cover_12.png&quot;)"></div>
                                        </div>
                                    </div>
                                </div>-->
            </div>
        </div>
        <div id="fancybox-trip" style="display: none;">

        </div>
        <div id="pop-date"></div>
    </body>
</html>
