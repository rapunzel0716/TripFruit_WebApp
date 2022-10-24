<%-- 
    Document   : placecard
    Created on : 2019/3/21, 下午 01:45:44
    Author     : Admin
--%>
<%@page import="uuu.tf.entity.Course"%>
<%@page import="uuu.tf.entity.TripDay"%>
<%@page import="uuu.tf.entity.Schedule"%>
<%@page import="uuu.tf.entity.Place"%>
<%@page import="uuu.tf.model.PlaceService"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<style>
    .placecardname{
        font-size: 18px;line-height: 40px;text-align: center;
    }
    .placecardimgdiv{
        padding: 0 14px;width: 100%;border-bottom:1px solid lightgrey;
    }

    .placecardimg{
        border-radius: 6px;width: 250px;
    }
    .item-links{
        margin: 0px 14px;width: calc(100% - 28px);height: 24px;
    }
    .related-article{
        text-align: left;
    }
    .more-images{
        text-align: right;
    }
    .item-links div{
        width: 48%;height: 24px;line-height: 24px;color: #6Bc4c7;float: left;
    }
    .coursecard{
        clear:both;
        border-bottom: 1px solid lightgrey;
        padding: 10px 11px;
        width: 100%;
    }
    .placecardtype{
        clear:both;
        border-bottom: 1px solid lightgrey;
        padding: 10px 11px;
        width: 100%;
    }
    .placecardwebsite{
        border-bottom: 1px solid lightgrey;
        padding: 10px 11px;
        width: 100%;
    }
    .placecardphone{
        border-bottom: 1px solid lightgrey;
        padding: 10px 11px;
        width: 100%; 
    }
    .placecardaddress{
        border-bottom: 1px solid lightgrey;
        padding: 10px 11px;
        width: 100%;
    }
    .placecardOpenTime{
        border-bottom: 1px solid lightgrey;
        padding: 10px 11px;
        width: 100%; 
    }
</style>
<script>
    function popAddPlace(placeId, placeName) {
        $.ajax({
            url: "pop-page/addplace_select.jsp?placeId=" + placeId + "&placeName=" + placeName,
            method: "POST",
        }).done(popAddPlaceDoneHandler);
    }
    function popAddPlaceDoneHandler(result, status, xhr) {
        $("#addPlaceSelect").html(result);
        $.fancybox.open({
            src: "#addPlaceSelect"
        });
    }
    //刪除景點
    function delectCourse(date, course) {
        if (confirm("確定要刪除嗎？")) {
            $.ajax({
                url: "delete_course.do?date=" + date + "&course=" + course,
                method: "POST",
            }).done(getSchedule);
            placecardclose();
        }
    }

</script>
<%
    String courseHashCode = request.getParameter("courseHashCode");
    String dayHashCode = request.getParameter("dayHashCode");
    TripDay d = null;
    Course c = null;

    if (courseHashCode != null && courseHashCode.matches("-?\\d+") && dayHashCode != null && dayHashCode.matches("-?\\d+")) {
        int d_hashCoode = Integer.parseInt(dayHashCode);
        int c_hashCoode = Integer.parseInt(courseHashCode);

        Schedule schedule = (Schedule) session.getAttribute("schedule");
        for (TripDay day : schedule.getTripDayList()) {
            if (day.hashCode() == d_hashCoode) {
                d = day;
                for (Course course : day.getTripCourse()) {
                    if (course.hashCode() == c_hashCoode) {
                        c = course;
                    }
                }
            }
        }
    }
%>
<%if (c != null) {%>
<div id='placeid<%=c.getPlace().getId()%>' >
    <div class="placecarddate">
        <div class="placecardname"><%=c.getPlace().getName()%><div id='placecardbutton' onclick="placecardclose()" class="close"></div></div>
        <div class="placecardimgdiv"><img class="placecardimg" src="<%=c.getPlace().getPhoto()%>" onerror="getImage(this)">
            <div class="item-links">
                <div class="related-article">
                    <a target="_blank" href='https://www.google.com.tw/search?q=<%=c.getPlace().getName()%>' style="color:blue;">
                        相關文章
                    </a>
                </div>
                <div class="more-images">
                    <a target="_blank" href='https://www.google.com.tw/search?q=<%=c.getPlace().getName()%>&tbm=isch' style="color:blue;">
                        更多照片
                    </a>
                </div>
            </div>
        </div>
        <div class="coursecard">日期:<br>
            <span style="margin-left: 20px;"><%=d.getTripdate()%></span>
        </div>
        <div class="coursecard">開始時間:<br>
            <span style="margin-left: 20px;"><%=c.getStarttime()%></span>
        </div>
        <div id="stay" data-stay="<%=c.getStay()%>" class="coursecard">停留時間:<br>
            <span id="stayTime" style="margin-left: 20px;"><%=c.getStay()%>分</span><span id="setStayTime" style="margin-left:30px;cursor: pointer;color: blue;">設定</span>
            <div id="pop-stayTime" style="display: none;width: 300px;">
                <form id="setStayForm" action="">
                    <br>
                    <input type="hidden" name="date" value="<%=d.getTripdate()%>">
                    <input type="hidden" name="placeId" value="<%=c.getPlace().getId()%>">
                    <input type="hidden" name="startTime" value="<%=c.getStarttime()%>">
                    設定停留時間: <input id="setStayTimeInput" type="number" name="time" min="0" value="" style="width: 65px;">分<br><br>
                    <input type="button" value="確定" onclick="updateStartTime()" style="float: right;" class="button">
                </form>
            </div>
        </div>
        <div class="placecardtype">景點類別: <%=c.getPlace().getType().getDescription()%></div>
        <div class="placecardtype">星評: <%=c.getPlace().getRating()%></div>
        <%=c.getPlace().getWebsite() != null ? ("<div style='text-overflow:ellipsis;overflow:hidden;' class='placecardwebsite'>官網:<br>" + "<a target='_blank' style='color:blue;' href='" + c.getPlace().getWebsite() + "'>" + c.getPlace().getWebsite() + "</a>" + "</div>") : ""%>
        <div class="placecardaddress">地址: <br><%=c.getPlace().getAddress()%></div>
        <%=c.getPlace().getPhone() != null ? ("<div class='placecardphone'>電話:" + c.getPlace().getPhone() + "</div>") : ""%>
        <%if (c.getPlace().getOpening_hours() != null && c.getPlace().getOpening_hours().length > 0) {
                out.print("<div class='placecardOpenTime''>營業時間:<br><div style='margin-right:100px;text-align: right;'>");
                for (String day : c.getPlace().getOpening_hours()) {
                    out.print(day.replace("\\n", "<br>") + "<br>");
                }
                out.print("</div></div>");
            }
        %>
        <div style="margin:10px 11px;">
            <button id='addplace' onclick="popAddPlace('<%=c.getPlace().getId()%>', '<%=c.getPlace().getName()%>')" class="button" style="width: 120px;">加入行程</button>
        
        <button id='delectCourse' onclick="delectCourse('<%=d.getTripdate()%>', '<%=c.hashCode()%>')" class="button" style="width: 120px;">刪除</button>
        </div>
    </div>
</div>
<%}%>
<div id="addPlaceSelect" style="display: none; width: 300px;">

</div>
