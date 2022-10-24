<%-- 
    Document   : radio_image.jsp
    Created on : 2019/4/2, 下午 11:01:59
    Author     : Rapunzel_PC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>radio_image</title>
        <style>
            
            .pop-up-layout {
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
                height: 580px;
                width: 900px;
            }
            .pop-up-header {
                border-bottom: 1px solid #FFFFFF;
                border-right: 1px solid #FFFFFF;
                border-top-left-radius: 10px;
                border-top-right-radius: 10px;
                background-color: #FFFFFF;
                height: 102px;
                position: relative;
                height: 107px;
            }
            .title {
                position: absolute;
                top: 45px;
                left: 73px;
                right: 73px;
                height: 25px;
                line-height: 25px;
                font-size: 18px;
                text-align: center;
                color: #6BC4C7;
                overflow: hidden;
                white-space: nowrap;
                text-overflow: ellipsis;
            }
            .pop-up-body {
                background-color: #FFFFFF;
                -webkit-box-flex: 1;
                -ms-flex: 1;
                flex: 1;
                overflow: auto;
                max-height: 414px;
                height: 391px;
                width: 900px;
                padding: 0 43px;
            }
            .travel-cover-images {
                width: 814px;
            }
            .cover-image:nth-child(-n+5) {
                margin-top: 0;
            }
            .cover-image:nth-child(5n+1) {
                margin-left: 0;
            }
            .cover-image {
                float: left;
                width: 157px;
                height: 80px;
                margin-left: 7px;
                margin-top: 17px;
                background-position: center;
                background-repeat: no-repeat;
                background-size: cover;
            }
            .pop-up-footer {
                background-color: #FFFFFF;
                border-right: 1px solid #FFFFFF;
                border-bottom-left-radius: 10px;
                border-bottom-right-radius: 10px;
                height: 82px;
                position: relative;
            }
            .pop-up-footer-buttons {
                margin-top: 25px;
                margin-bottom: 30px;
                display: -webkit-box;
                display: -ms-flexbox;
                display: flex;
                -webkit-box-pack: center;
                -ms-flex-pack: center;
                justify-content: center;
            }
            .pop-button {
                margin: 0px 20px;
                width: 108px;
                height: 27px;
                text-align: center;
                color: #FFFFFF;
                font-size: 14px;
                line-height: 27px;
                border-radius: 20px;
                cursor: pointer;

            }
            .button-normal {
                background-color: #6BC4C7;
            }
            .button-primary {
                background-color: #F7B66C;
            }
            label {
                display: inline-block;
                max-width: 100%;
                margin-bottom: 5px;
                font-weight: 700;
            }
            input[type=radio] ~ label {
                width: 157px;
                height: 80px;
                margin: 0;
            }
        </style>
       
    </head>
    <body>
        <div class="pop-up-layout">
            <div class="pop-up-header">
                <div class="title">
                    請選擇行程封面圖
                </div>
            </div>
            <div class="pop-up-body">
                <div class="travel-cover-images">
                    <form id="radioImageForm" action="" method="POST">
                        <%for (int x = 1; x <= 20; x++) {%>
                        <div class="cover-image" style="background-image: url(<%=request.getContextPath()%>/images/cover/cover<%=x%>.jpg);">
                            <input id="cover-image<%=x%>" type="radio" name="cover-image" value="cover<%=x%>.jpg" checked="">
                            <label class="checkstatus" for="cover-image<%=x%>"></label>
                        </div>
                        <%}%>
                    </form>
                </div>
            </div>
            <div class="pop-up-footer">
                <div class="pop-up-footer-buttons">
                    <div class="pop-button button-normal">
                        取消
                    </div>
                    <div class="pop-button button-primary">
                        確定
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
