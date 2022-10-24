<%-- 
    Document   : schedule_detail
    Created on : 2019/4/20, 下午 05:24:39
    Author     : Rapunzel_PC
--%>

<%@page import="uuu.tf.entity.Course"%>
<%@page import="uuu.tf.entity.TripDay"%>
<%@page import="uuu.tf.entity.Schedule"%>
<%@page import="uuu.tf.model.SchedulesService"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String id = (String) request.getParameter("scheduleId");
    SchedulesService service = new SchedulesService();
    Schedule s = service.getScheduleById(Integer.parseInt(id));
%>
<%if (s != null) {%>
<div class="pop-up-layout">
    <div class="pop-up-header">
        <div class="header-title">檢視行程</div>
    </div>
    <div class="pop-up-body">
        <%for (TripDay day : s.getTripDayList()) {
                int days = s.getDayIndex(day) + 1;
        %>
        <div class="travel-preview-item" style="overflow-x: auto;">
            <div class="travel-title">
                <div class="day-count">Day <%=days%></div>
                <div class="date"><%=day.getTripdate()%></div>
            </div>
            <div class="swiper-wrapper" style="position: relative;overflow: auto;width:<%=110 * day.size() + "px"%>">
                <%
                    int x = 1;
                    for (Course course : day.getTripCourse()) {
                %>
                <div class="main-item" title="<%=course.getPlace().getName() %>">
                    <div class="pop-image" style="width: 80px;height: 80px; background-image: url(<%=course.getPlace().getPhoto() %>);"></div>
                    <div class="pop-point">
                        <div class="num"><%=x%></div>
                    </div>
                        <div class="name" style="font-size: 14px;text-overflow:ellipsis;overflow:hidden;"><%=course.getPlace().getName() %></div>
                </div>
                <%
                    x++;
                            }%>
            </div>
        </div>
        <%}%>
<!--                <div class="travel-preview-item">
                    <div class="travel-title">
                        <div class="day-count">Day 2</div>
                        <div class="date">08/27 . 週日</div>
                    </div>
                    <div class="swiper-wrapper">
                        <div class="main-item">
                            <div class="pop-image" style="background-image: url(http://52.192.6.27/image/common/bg_without_image_logo.png);"></div>
                            <div class="pop-point">
                                <div class="num">1</div>
                            </div>
                            <div class="name">地熱谷</div>
                        </div>
                        <div class="main-item">
                            <div class="pop-image" style="background-image: url(http://52.192.6.27/image/common/bg_without_image_logo.png);"></div>
                            <div class="pop-point">
                                <div class="num">2</div>
                            </div>
                            <div class="name">北投溫泉博...</div>
                        </div>
                        <div class="main-item">
                            <div class="pop-image" style="background-image: url(http://52.192.6.27/image/common/bg_without_image_logo.png);"></div>
                            <div class="pop-point">
                                <div class="num">3</div>
                            </div>
                            <div class="name">北投公園</div>
                        </div>
                        <div class="main-item">
                            <div class="pop-image" style="background-image: url(http://52.192.6.27/image/common/bg_without_image_logo.png);"></div>
                            <div class="pop-point">
                                <div class="num">4</div>
                            </div>
                            <div class="name">满来温泉拉...</div>
                        </div>
                    </div>
                </div>-->
    </div>
</div>
<%}%>