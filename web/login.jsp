<%-- 
    Document   : login
    Created on : 2019/3/15, 上午 11:59:43
    Author     : Admin
--%>

<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>會員登入</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script>


            function refreshCaptcha() {
                var image = document.getElementById("captchaImage");
                image.src = "<%=request.getContextPath()%>/images/captcha.jpeg?test=" + new Date();//變更網址，才會重新送請求，使用new Date()取的現在時間(秒)來refresh
            }

            function loginSubmit() {
                var email = $("#email").val();
                var pwd = parseInt($("#password").val().length);
                var max = parseInt($("#password").attr("maxlength"));
                var min = parseInt($("#password").attr("minlength"));
                var captcha = $("#captcha").val();
                var message = "請";
                var isCorrect = true;
                if (email == "") {
                    isCorrect = false;
                    message += "輸入email";
                }
                if (isNaN(pwd) || pwd < min || pwd > max) {
                    isCorrect = false;
                    if (message != "請")
                        message += "和";
                    message += "輸入6~20個字的密碼";
                }
                if (captcha == "") {
                    isCorrect = false;
                    if (message != "請")
                        message += "和";
                    message += "輸入驗證碼";
                }
                if (!isCorrect) {
                    alert(message);
                } else {
                    $.ajax({
                        url: "login.do",
                        method: "POST",
                        data: $("#loginSubmitForm").serialize()
                    }).done(loginSubmitDoneHandler);
                }
            }
            
            function loginSubmitDoneHandler(result, status, xhr) {
                try{
                    if(dataObj && dataObj.redirect==true){
                        //alert(dataObj.url);
                        location.href=dataObj.url;
                        return;
                    }
                }catch(err){
                    //alert("登入失敗");
                }
                
                $("#loginBox").html(result);
                $("#loginBox").effect("shake",300);
                        var image = document.getElementById("captchaImage");
                image.src = "<%=request.getContextPath()%>/images/captcha.jpeg?test=" + new Date();        

            }
        </script>
    </head>
    <body>
        <div class="header">
            <h1>
                <a href="<%=request.getContextPath()%>"><img src="<%=request.getContextPath()%>/images/login.png" alt="TripFruit" style="vertical-align: middle;"/></a><br>
            </h1>
        </div>
        <%
            Cookie[] cookies = request.getCookies();
            String email = "";
            String auto = "";
            if (cookies != null && cookies.length > 0) {
                for (int i = 0; i < cookies.length; i++) {
                    Cookie cookie = cookies[i];
                    if (cookie.getName().equals("email")) {
                        email = cookie.getValue();
                    } else if (cookie.getName().equals("auto")) {
                        auto = cookie.getValue();
                    }
                }
            }
        %>
        <div class="article" style="position: relative;width: 360px; background-color: #ededed;">
            <form id="loginSubmitForm" style="padding: 0px 10px" method="post" action="<%=request.getContextPath()%>/login.do">
                <br><p id="errors"><%
                    List<String> errors = (List<String>) request.getAttribute("errors");
                    if (errors != null && errors.size() > 0) {
                        out.print(errors);
                    }
                    %></p>
                <p>
                    <label>帳號:</label>
                    <input id="email" name='email' type='email' placeholder='請輸入e-mail' required
                           value=<%= request.getMethod().equals("GET") ? email : request.getParameter("email")%>>
                    <input type="checkbox" name="auto" value='ON' <%=auto%>/>記住我的帳號
                </p>
                <p>
                    <label>密碼:</label>
                    <input id="password" name='pwd' type='password' placeholder='請輸入6~20個字的密碼' minlength="6" maxlength="20" required>
                </p>
                <div>
                    <label>驗證碼:</label>
                    <input id="captcha" name='captcha' autocomplete="off" type='text' required style='width: 12em' placeholder='請依右圖輸入(不分大小寫)' autocomplete="off">
                    <a href="javascript:refreshCaptcha()" title="點選圖片即可更新">
                        <img id="captchaImage" src='<%=request.getContextPath()%>/images/captcha.jpeg' style="vertical-align: middle">
                    </a>

                </div><br>
                <input style="float: right;background-color: #003057;" type='button' onclick="loginSubmit()" class="button" value="登入"><br><br>
            </form><br>
        </div>
    </body>
</html>
