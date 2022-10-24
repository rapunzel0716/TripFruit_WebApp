<%-- 
    Document   : newtrip
    Created on : 2019/4/10, 下午 05:19:28
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<script>
    function newTripDoneHandler() {
        var min = parseInt($("#setdays").attr("min"));
        var max = parseInt($("#setdays").attr("max"));
        var name = $("#setname").val();
        var date = $("#setdeparture").val();
        var days = parseInt($("#setdays").val());
        if (name == null || name.length == 0) {
            alert("請輸入行程名稱");
            return;
        }
        if (date == null || date.length == 0) {
            alert("請輸入出發日期");
            return;
        }
        if (isNaN(days) || days < min || days > max) {
            alert("請輸入正確的天數");
            return;
        }

        $.fancybox.close();
        $.ajax({
            url: "newtrip.do",
            method: 'POST',
            data: $("#newTripForm").serialize(),
        }).done(gotripseek);
    }
    function gotripseek(){
        location.href = "<%=request.getContextPath()%>/tripseek.jsp";
    }
    
</script>
<form id="newTripForm" method="POST">
    <label>行程名稱</label>
    <input id="setname" type="text" name="name"><br><br>
    <label>出發日期</label>
    <input id="setdeparture" type="date" name="date"><br><br>
    <label>天數</label>
    <input id="setdays" type="number" max="20" min="1" name="days"><br><br>
    <input type="button" onclick="newTripDoneHandler()" style="float: right;" class="button" value="確定">
</form>
