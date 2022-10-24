<%-- 
    Document   : register
    Created on : 2019/3/17, 下午 09:55:05
    Author     : Rapunzel_PC
--%>


<%@page import="java.util.List"%>
<%@page import="uuu.tf.entity.Member"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%@include file="WEB-INF/subviews/global.jsp" %>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>TripFruit</title>
        <style >
            html, body {height: 100%;}
            .registerbg{
                background-image: url("images/registerbg.jpg");
                width:100vw;height: 100vh;
                min-width: 450px;
            }
            #register{background-color: #e5e5e5;}
            #register a:hover{color: black;}
            .btn{
                float: right;
                background-color: #515e69; 
                border: none;
                color: white;
                padding: 10px 18px;
                text-align: center;
                text-decoration: none;
                display: inline-block;
                font-size: 14px;
                margin: 4px 2px;
                cursor: pointer;
                -webkit-transition-duration: 0.4s; /* Safari */
                transition-duration: 0.4s;
            }
            .btn:hover{
                background-color: #91969a;
                border-color: #285e8e;
            }
            .login{
                display: none;
            }
        </style>
        <script>
            function refreshCaptcha() {
                $("#captchaImage").attr("src", "images/register_captcha.jpeg?test=" + new Date());//變更網址，才會重新送請求，使用new Date()取的現在時間(秒)來refresh
            }
        </script>
    </head>
    <body>
        <div class="registerbg">
            <jsp:include page="/WEB-INF/subviews/header.jsp"/>
            <div style="min-height: 600px;width: 460px;height:600px;position: absolute;left: 50%;top: 100px;margin-left:-250px;background-color:rgba(255, 255, 255, 0.9);padding:20px 20px;border-radius: 6px;" >
                <div class="header" >
                    <div>
                        <a href="<%=request.getContextPath()%>"><img src="images/register.png" alt="TripFruit" style="vertical-align: middle;"/></a><br>
                    </div>
                </div><br>
                <form method="POST" action='register.do' style="width: 400px;">
                    <label style="color: red;">
                    <%
                        List<String> errors = (List<String>) request.getAttribute("errors");
                        if (errors != null && errors.size() > 0) {
                            out.print(errors);
                        }
                    %>
                    </label>
                    <p>
                        <label>帳號:</label>
                        <input name='email' type='email' style="width: 300px;" required placeholder='請輸入Email' value='<%=request.getMethod().equals("GET") ? "" : request.getParameter("email")%>'>
                    </p> 
                    <p>
                        <label>姓名:</label>
                        <input name='name' type='text' required placeholder='請輸入姓名' value='<%=request.getMethod().equals("GET") ? "" : request.getParameter("name")%>'>
                    </p>
                    <p>
                        <label>密碼:</label>
                        <input name='pwd1' type='password' placeholder='請輸入密碼(6~20個字)' minlength="6" maxlength="20" required><br>
                    </p>
                    <p><label>確認:</label>
                        <input name='pwd2' type='password' placeholder='請再確認密碼(6~20個字)' minlength="6" maxlength="20" required>
                    </p>
                    <p>
                        <label>性別:</label>
                        <input type='radio' name='gender' id='male' value=<%=Member.MALE%> required 
                               <%= String.valueOf(Member.MALE).equals(request.getParameter("gender")) ? "checked" : ""%>><label for='male'>男</label>
                        <input type='radio' name='gender' id='female' value=<%=Member.FEMALE%> required 
                               <%= String.valueOf(Member.FEMALE).equals(request.getParameter("gender")) ? "checked" : ""%>><label for='female'>女</label>
                    </p>             
                    <p>
                        <label>生日:</label>
                        <input name='birthday' type='date' value='<%=request.getMethod().equals("GET") ? "" : request.getParameter("birthday")%>' required>
                    </p>         
                    <p>
                        <label>驗證碼:</label>
                        <input name='captcha' autocomplete="off" type='text' required style='width: 12em' placeholder='請依右圖輸入(不分大小寫)'>
                        <a href="javascript:refreshCaptcha()" title="點選圖片即可更新">
                            <img id="captchaImage" src='images/register_captcha.jpeg' style="vertical-align: middle">
                        </a>
                        <br><br><br>
                    </p>
                    <input class="btn" type='submit' value="確定"><br><br><br>
                </form>
            </div>
        </div>
        <div id="loginBox"></div>
    </body>
</html>
