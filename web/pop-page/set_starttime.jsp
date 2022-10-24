<%-- 
    Document   : setstart_time
    Created on : 2019/4/15, 上午 11:09:58
    Author     : Rapunzel_PC
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String date = request.getParameter("date");
    String time = request.getParameter("time");
%>
<script>
    
</script>
<%if (date != null && time != null) {%>
<form id="setStartTimeForm" action="">
    <br>
    <input type="hidden" name="date" value="<%=date%>">
    <%=date%><br>
    設定開始時間:
    <input id="setStartTime" type="time" name="time" value="<%=time%>" style="width: 150px;"><br><br>
    <input type="button" class="button" value="確定" onclick="UpdateStartTime()" style="float: right;">
</form>
<%}%>