<%-- 
    Document   : placecard
    Created on : 2019/3/21, 下午 01:45:44
    Author     : Admin
--%>
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
    .placecardtype{
        clear:both;
        border-bottom: 1px solid lightgrey;
        padding: 10px 11px;
        width: 100%;
    }
    .placecard_detail{
        border-bottom: 1px solid lightgrey;
        padding: 10px 11px;
        width: 100%;
        text-overflow:ellipsis;overflow:hidden;
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
    function popAddPlaceDoneHandler(result, status, xhr) {
        $("#addPlaceSelect").html(result);
        $.fancybox.open({
            src: "#addPlaceSelect"
        });
    }

    function popAddPlace(placeId, placeName) {
        $.ajax({
            url: "pop-page/addplace_select.jsp?placeId=" + placeId + "&placeName=" + placeName,
            method: "POST",
        }).done(popAddPlaceDoneHandler);
    }
</script>
<%
    String placeId = request.getParameter("placeId");

    PlaceService service = new PlaceService();
    Place p = null;
    if (placeId != null) {
        p = service.getPlaceById(placeId);
    }
%>
<%if (p != null) {%>
<div id='placeid<%=p.getId()%>' >
    <div class="placecarddate">
        <div class="placecardname"><%=p.getName()%><div id='placecardbutton' onclick="placecardclose()" class="close" ></div></div>
        <div class="placecardimgdiv"><img class="placecardimg" src="<%=p.getPhoto()%>" onerror="getImage(this)">
            <div class="item-links">
                <div class="related-article">
                    <a target="_blank" href='https://www.google.com.tw/search?q=<%=p.getName()%>' style="color:blue;">
                        相關文章
                    </a>
                </div>
                <div class="more-images">
                    <a target="_blank" href='https://www.google.com.tw/search?q=<%=p.getName()%>&tbm=isch' style="color:blue;">
                        更多照片
                    </a>
                </div>
            </div>
                  
        </div>
        <div class="placecardtype">景點類別:  <%=p.getType().getDescription()%></div>
        <div class="placecard_detail">星評:  <%=p.getRating()%></div>
        <%=p.getWebsite() != null ? ("<div style='' class='placecard_detail'>官網:<br>" + "<a target='_blank' style='color:blue;' href='" + p.getWebsite() + "'>" + p.getWebsite() + "</a>" + "</div>") : ""%>
        <div class="placecardaddress">地址: <br><%=p.getAddress()%></div>
        <%=p.getPhone() != null ? ("<div class='placecardphone'>電話: " + p.getPhone() + "</div>") : ""%>
        <%if (p.getOpening_hours() != null && p.getOpening_hours().length > 0) {
                out.print("<div class='placecardOpenTime''>營業時間:<br><div style='margin-right:100px;text-align: right;'>");
                for (String day : p.getOpening_hours()) {
                    out.print(day.replace("\\n", "<br>") + "<br>");
                }
                out.print("</div></div>");
            }
        %>

        <button id='addplace' onclick="popAddPlace('<%=p.getId()%>', '<%=p.getName()%>')" class="button" style="width: 260px;margin: 10px 11px;">加入行程</button>     
    </div>
</div>
<%}%>
<div id="addPlaceSelect" style="display: none; width: 300px;">
    <!--    <form id='courseForm' method="POST" action="add_course.do" onsubmit="return validate()">
            <input type="hidden" name='coursePlaceid' value='<=p.getId()>'>
            <p>
                <label><=p.getName()></label>
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
                    <div style="background-color: #F7B66C;width: 60px;height: 27px;text-align: center;color: #FFFFFF;border-radius: 5px;cursor: pointer;display: block;position: relative;float: right;">
                        確定
                    </div></a>
            
        </form>-->
</div>
