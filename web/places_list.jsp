<%-- 
    Document   : searchplace
    Created on : 2019/3/21, 下午 10:43:23
    Author     : Rapunzel_PC
--%>
<%@page import="uuu.tf.entity.Place"%>
<%@page import="java.util.List"%>
<%@page import="uuu.tf.model.PlaceService"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String search = request.getParameter("search");
    String type = request.getParameter("type");
    String maptype = request.getParameter("maptype");
    String E = request.getParameter("E");
    String S = request.getParameter("S");
    String W = request.getParameter("W");
    String N = request.getParameter("N");
    String[] maplatlng = {E,S,W,N};
    
    PlaceService service = new PlaceService();
    List<Place> list = null;
    if ((search != null) && search.length() > 0) {
        if((type != null) && type.length() > 0){
            list=service.selectPlacesByNameAndType(search, type);
        }else{
            list = service.searchPlacesByName(search);
        }
    }
    
    if(maptype!=null  && maptype.length() > 0){
        list=service.searchPlacesByTypeAndLatLng(maptype, maplatlng);
    }
%>
<script>
    function searchPlaceMarker() {
    <% if (list != null && list.size() > 0) {%>
        //重置地圖綁定
        bounds = new google.maps.LatLngBounds();
        var x = 0;
    <% for (int i = 0; i < list.size(); i++) {
            Place p = list.get(i);//宣告Place 存放list第i筆資料
    %>
        var latlng = {lat: <%=p.getLat()%>, lng: <%=p.getLng()%>};
        //將景點的latlng做google marker，並依list的順序存入markers陣列
        var image = {
            url: 'images/icons/<%=p.getType()%>.png',
            //縮放後的大小
            scaledSize: new google.maps.Size(34, 34),
        };
        markers[x] = new google.maps.Marker({
            map: map,
            position: latlng,
            animation: google.maps.Animation.DROP,
            icon: image,
        });
        bounds.extend(latlng);
        //當滑鼠進入標記 開啟景點資訊頁面
        markers[x].addListener('mouseover', function () {
            infowindow.setContent("<div><img style='width: 100px' src=<%=p.getPhoto()%> onerror='getImage(this)' ></div><div><%=p.getName()%></div>");
            infowindow.open(map, this);
        });
        //當滑鼠離開標記，關閉景點資訊
        markers[x].addListener('mouseout', function () {
            infowindow.close();
        });
        //當標記按下 開啟 景點資訊卡
        markers[x].addListener('click', function () {
            placecardopen();
            getPlace(<%=p.getId()%>);
        });
        placeClickDoneHandler(x);
        x++;
    <%}%>
        <%if(maptype==null){%>
        map.fitBounds(bounds);
        <%}%>
    <%}%>
        bounds=null;
    }
    //此function參考 https://developers.google.com/maps/documentation/javascript/examples/places-autocomplete-hotelsearch
    function placeClickDoneHandler(x) {
        //當搜尋的景點被點下時開啟 景點資訊卡 及 將地圖滑向此景點標記
        $(document).on("click", "#searchplace" + x, function () {
            placecardopen();
            google.maps.event.trigger(markers[x], 'mouseover');
            map.panTo(markers[x].getPosition());
        });
    }
</script>
<div style="overflow-y:scroll;height:100%;">
    <div style="float: left;width: 150px;margin: 3px;">
        <% if (list != null && list.size() > 0) {%>
        <% for (int i = 0; i < list.size(); i++) {
                Place p = list.get(i);//宣告Place 存放list第i筆資料
        %>
        <%if (i % 2 == 0) {%><a href="javascript:getPlace(<%=p.getId()%>)" id="searchplace<%=i%>" class="searchplace" style='position: relative;float: left;width: 100%;margin: 3px;'>
            <div><img style="width: 100%;border-radius:6px;" src="<%=p.getPhoto()%>" onerror="getImage(this)"></div>
            <div><%=p.getName()%></div>
        </a><%}%>
        <%}%>
        <%}%>
    </div>
    <div style="float: left;width: 150px;margin: 3px;">
        <% if (list != null && list.size() > 0) {%>
        <% for (int i = 0; i < list.size(); i++) {
                Place p = list.get(i);//宣告Place 存放list第i筆資料
        %>
        <%if (i % 2 == 1) {%><a href="javascript:getPlace(<%=p.getId()%>)" id="searchplace<%=i%>" class="searchplace" style='position: relative;float: left;width: 100%;'>
            <div><img style="width: 100%;border-radius:6px;" src="<%=p.getPhoto()%>" onerror="getImage(this)"></div>
            <div><%=p.getName()%></div>
        </a><%}%>
        <%}%>
        <%}%>
    </div>
    <div style="clear: both;">
    <% if (list != null && list.size() == 0 && search != null) {
            out.print("查無符合" + search + "資料");
        }%>
    </div>
</div>