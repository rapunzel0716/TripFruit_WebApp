<%-- 
    Document   : index
    Created on : 2019/3/26, 上午 09:47:43
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>TripFruit</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <%@include file="/WEB-INF/subviews/global.jsp" %>
        <style>
            <%int x = (int) (Math.random() * 5) + 1;%>
            .background{
                min-width: 350px;
                background-image: url("images/background/indexbackground<%=x%>.jpg");
                width:100%;height: 100vh;
                background-repeat: no-repeat;
                background-attachment: fixed;
                background-position: center;
                background-size: cover;
            }
            nav{
                background: #ffffff00;box-shadow:none;border: none;
            }
            nav a{text-decoration: none; height: 40px;}
            nav a:link{color: white; text-shadow: 4px 2px 5px #333333;}
            nav a:visited{color: white; text-shadow: 4px 2px 5px #333333; }
            nav a:hover{
                color: #c17d41;
                text-decoration: underline;
            }
            .member{
                display: none;
            }
            .btn{
                color: #fff;
                background-color: #428bca;
                display: inline-block;
                padding: 6px 12px;
                margin-bottom: 0;
                font-size: 14px;
                font-weight: 400;
                line-height: 1.42857143;
                text-align: center;
                white-space: nowrap;
                vertical-align: middle;
                cursor: pointer;
                border: 1px solid transparent;
                border-color: #357ebd;
                border-radius: 4px;
                text-decoration: none;
            }
            .btn:hover{
                background-color: #3071a9;
                border-color: #285e8e;
            }
        </style>
        <script>

        </script>
    </head>
    <body>
        <div class="background">
            <jsp:include page="/WEB-INF/subviews/header.jsp"/>
            <div class="container" style="position: relative; top: calc(((100%) / 2.5))">
                <div class="row">
                    <div class="col-xs-12" style="text-align: center">
                        <h1 style="color:#ffffff; text-shadow: 0px 1px 2px rgba(0,0,0,0.5); font-size: 63px ;margin: 0px;">TripFruit</h1> 
                        <p style="color:#ffffff; text-shadow: 0px 1px 2px rgba(0,0,0,0.5);font-size: 20px ;">規劃 ‧ 旅遊 ‧ 隨心所欲</p>
                        <div style="padding-bottom: 20px">
                            <!--                            <a href="javascript:mytrip()"><button class="btn btn-primary" >我的旅程</button></a>-->
                            <a href="tripseek.jsp" class="btn">開始規劃</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
