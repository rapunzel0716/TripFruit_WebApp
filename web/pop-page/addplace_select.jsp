<%-- 
    Document   : addplace_select
    Created on : 2019/4/3, 上午 10:03:53
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<script>
    $(document).ready(init);
    function init() {
        var dayLength = $(".places").length;
        var x = $(".selectday").length + 1;
        for (x; x <= dayLength; x++) {
            $("#selectDays").append("<input type='checkbox' class='selectday' style='width:17px;height:17px;' name='selectday' value='" + x + "'> 第" + x + "天 ");
        }
        
    }
    function validate() {
        var obj = $(".selectday");
        var len = obj.length;
        var checked = false;

        for (i = 0; i < len; i++){
            if (obj[i].checked == true){
                checked = true;
                break;
            }
        }
        if(!checked){
            alert("請選擇天數");
            return false;
        }
        var hour = parseInt($("#stayHour").val());
        var minute = parseInt($("#stayMinute").val());
        if(!hour)  $("#stayHour").val(0);
        if(!minute) $("#stayMinute").val(0);
        return true;
    }
    function addPlace() {
        if (validate()) {
            var url = $("#courseForm").attr("action");
            var method = $("#courseForm").attr("method");
            $.ajax({
                url: url,
                method: method,
                data: $("#courseForm").serialize(),
            }).done(getSchedule);
            $.fancybox.close();
        }
    }
</script>
<%
%>

<form id='courseForm' method="POST" action="add_course.do" onsubmit="return validate()">
        <input type="hidden" name='coursePlaceid' value='${param.placeId}'>
        <p>
            <label>${param.placeName}</label>
        <p>
        <p id='selectDays'>
            <label>請選擇加入天數</label><br>
        </p>
        <p>
            <label>停留時間</label><br>
            <input type="number" name="stayHour" id="stayHour" min="0" max="23">時
            <input type="number" name="stayMinute" id='stayMinute' min="0" max="59">分
        </p>
        <a href="javascript:addPlace()"  title="加入行程">
            <div style="float: right;" class="button">
                    確定
                </div></a>
        
    </form>
