<%-- 
    Document   : searchAttractions
    Created on : 2019/3/22, 下午 11:33:08
    Author     : Rapunzel_PC
--%>

<%@page import="uuu.tf.entity.Place"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<!--
To change this license header, choose License Headers in Project Properties.
To change this template file, choose Tools | Templates
and open the template in the editor.
-->
<html>
    <head>
        <title>Simple Map</title>
        <meta name="viewport" content="initial-scale=1.0">
        <meta charset="utf-8">
        <style>
            /* 始終明確設置地圖高度以定義div的大小
              *包含地圖的元素。*/
            #map {
                height: 100%;
            }
            /* Optional: 使示例頁面填滿窗口. */
            html, body {
                height: 100%;
                margin: 0;
                padding: 0;
            }
            #name {
                /*position: absolute;*/
                height: 100%;
                top: 10px;
                left: 110px;
                font-family: "Roboto", "Arial", sans-serif;
                font-size: 13px;
                z-index: 5;
                box-shadow: 0 4px 6px -4px #333;
                padding: 5px 10px;
                background: rgb(255,255,255);
                background: linear-gradient(to bottom,rgba(255,255,255,1) 0%,rgba(245,245,245,1) 100%);
                border: rgb(229, 229, 229) 1px solid;
            }
            #button {
                /*position: absolute;*/
                top: 10px;
                left: 300px;
                font-family: "Roboto", "Arial", sans-serif;
                font-size: 13px;
                z-index: 5;
                padding: 5px 10px;
            }
            #content{
                height:250px;
                overflow: auto;
            }
            table, th, td {
                border: 1px solid black;
            }
        </style>
        <script src="files/jquery.js"></script>
        <script>
            var map;
            var service;
            var infowindow;
            var inputplace;
            var marker;
            var markers = [];
            var openhour = [];
            var data;
            function initMap() {
                var sydney = new google.maps.LatLng(25.0440688, 121.5315383);
                infowindow = new google.maps.InfoWindow();
                map = new google.maps.Map(
                        document.getElementById('map'), {center: sydney, zoom: 15});
                $("#button").click(buttonclik);
                //監控map  在map點下click事件時，傳送此事件的經緯度至inputplace 執行PlaceIdMark()
                map.addListener('click', function (event) {
                    event.stop();
                    //inputplace = (String(event.placeId));
                    PlaceIdMark(event.placeId);
                });
            }

            //將傳入的placeid標記在地圖，
            function PlaceIdMark(placeId) {
                if (marker != null)
                    deleteMarkers();
                //設定request
                var request = {
                    placeId: placeId,
                    fields: ['name', 'formatted_address', 'place_id', 'geometry', 'formatted_phone_number', 'website', 'rating', 'opening_hours']
                };
                service = new google.maps.places.PlacesService(map);
                //檢索有關給定標識的位置的詳細信息placeId。
                //getDetails(request, callback)     request：PlaceDetailsRequest    callback：function(PlaceResult, PlacesServiceStatus)
                service.getDetails(request, function (place, status) {
                    if (status === google.maps.places.PlacesServiceStatus.OK) {
                        marker = new google.maps.Marker({
                            map: map,
                            position: place.geometry.location
                        });
                        markers.push(marker);
                        google.maps.event.addListener(marker, 'click', function () {
                            var businesshours = [];
                            try {
                                businesshours = place.opening_hours.periods;
                            } catch (e) {
                                businesshours = e;
                            }

                            for (var x = 0; businesshours.length > x; x++) {
                                var day = "";
                                switch (businesshours[x].open.day) {
                                    case 1:
                                        day = "星期一";
                                        break;
                                    case 2:
                                        day = "星期二";
                                        break;
                                    case 3:
                                        day = "星期三";
                                        break;
                                    case 4:
                                        day = "星期四";
                                        break;
                                    case 5:
                                        day = "星期五";
                                        break;
                                    case 6:
                                        day = "星期六";
                                        break;
                                    case 0:
                                        day = "星期日";
                                        break;
                                }
                                var opentime = businesshours[x].open != null ? businesshours[x].open.time : "";
                                var closetime = businesshours[x].close != null ? businesshours[x].close.time : "";
                                var alltime;
                                if ((opentime + closetime) == "0000") {
                                    alltime = "24小時營業"
                                } else {
                                    opentime = opentime.substring(0, 2) + ":" + opentime.substring(2, 4);
                                    closetime = closetime.substring(0, 2) + ":" + closetime.substring(2, 4);
                                    alltime = opentime + "~" + closetime;
                                }
                                openhour[x] = day + alltime;
                            }
                            if (openhour[0] == "星期日24小時營業")
                                openhour[0] = "24小時營業";
                            data = {
                                lat: place.geometry.location.lat(),
                                lng: place.geometry.location.lng(),
                                name: place.name,
                                address: place.formatted_address,
                                phone: (place.formatted_phone_number) ? place.formatted_phone_number : "",
                                website: (place.Website) ? place.Website : "",
                                rating: place.rating,
                                open_hour: openhour,
                            };
                            openhour = [];
                            addtable();
                            infowindow.setContent('lat: ' + place.geometry.location.lat() + '<br>' +
                                    'lng: ' + place.geometry.location.lng() + '<br>' +
                                    '名稱:' + place.name + '<br>'/* +
                                     'Place ID: ' + place.place_id + '<br>' +
                                     '地址: ' + place.formatted_address + '<br>' +
                                     '電話: ' + place.formatted_phone_number + '<br>' +
                                     '網址: ' + place.Website + '<br>' +
                                     '評分: ' + place.rating + '<br>'*/
                                    );
                            infowindow.open(map, this);
                        });
                    } else {
                        alert('此位置無法定址' + status);
                    }
                }
                );
            }
            //
            function addtable() {

                $("table ").append("<tr><td>" + data.lat + "</td><td>" + data.lng + "</td><td>" + data.name + "</td><td></td><td>" + data.address +
                        "</td><td>" + data.phone + "</td><td>" + data.website + "</td><td>" + data.rating + "</td><td>" + data.open_hour + "</td></tr>");
            }

            //刪除所有標記
            function deleteMarkers() {
                for (var i = 0; i < markers.length; i++) {
                    markers[i].setMap(null);
                }
                markers = [];
            }

            function serviceAddMark() {
                var request = {
                    query: inputplace,
                    fields: ['name', 'geometry', 'formatted_address', 'place_id', 'types'],
                };
                service = new google.maps.places.PlacesService(map);
                service.findPlaceFromQuery(request, function (results, status) {
                    if (status === google.maps.places.PlacesServiceStatus.OK) {
                        for (var i = 0; i < results.length; i++) {
                            createMarker(results[i]);
                        }
                        map.setCenter(results[0].geometry.location);
                    } else {
                        alert('此位置無法定址');
                    }
                });
            }
            function buttonclik() {
                if (marker != null)
                    deleteMarkers();
                inputplace = $("#name").val();
                serviceAddMark();
            }

            //傳入place製造此位置的maker
            function createMarker(place) {
                marker = new google.maps.Marker({
                    map: map,
                    position: place.geometry.location
                });
                markers.push(marker);
                google.maps.event.addListener(marker, 'click', function () {
                    infowindow.setContent(place.name + "<br>" + place.formatted_address + "<br>" + place.place_id);
                    infowindow.open(map, this);
                });

            }
            //增加表格欄位
            var n = 1;
            function myFunction() {
                var x = document.createElement("TR");
                x.setAttribute("id", "myTr" + n);
                document.getElementById("myTable").appendChild(x);
                addTD("placeID");
                n++;
            }
            function addTD(value) {
                var y = document.createElement("TD");
                var t = document.createTextNode(value);
                y.appendChild(t);
                document.getElementById("myTr" + n).appendChild(y);
            }
        </script>

    </head>
    <body>
        <div id = header>
            <input type="text" name="name" id="name" autofocus>
            <button id="button">Enter</button>
            <input onclick="deleteMarkers();" type=button value="Delete Markers">
        </div>
        <div id="content">
            <table style="width:100%">
                <tr>
                    <th>Lat</th> 
                    <th>Lng</th>
                    <th>name</th>
                    <th>type</th>
                    <th>formatted_address(地址)</th>
                    <th>phone</th>
                    <th>website </th>
                    <th>rating(評分)</th>
                    <th> opening_hours(營業時間)</th>
                    <th>photo</th>
                </tr>
            </table>
        </div>
        <div id="map"></div>
        <script src="https://maps.googleapis.com/maps/api/js?key=金鑰=places&callback=initMap"
        async defer></script>

    </body>
</html>
