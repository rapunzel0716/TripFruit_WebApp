<%-- 
    Document   : update
    Created on : 2019/3/18, 上午 10:01:36
    Author     : Admin
--%>

<%@page import="uuu.tf.entity.Member"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<!DOCTYPE html>
<html>
    <head>
        <%@include file="/WEB-INF/subviews/global.jsp" %>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>TripFruit</title>
        <style >
            html, body {height: 100%;}
            nav ul:nth-child(2) li:nth-child(2){background-color: #e5e5e5;}
            nav ul:nth-child(2) li:nth-child(2) a:hover{color: black;}
            .registerbg{
                background-image: url("<%=request.getContextPath()%>/images/registerbg.jpg");
                width:100vw;height: 100vh;
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
        </style>
        <script>
            function refreshCaptcha() {
                $("#captchaImage").attr("src", "<%=request.getContextPath()%>/images/captcha.jpeg?test=" + new Date());//變更網址，才會重新送請求，使用new Date()取的現在時間(秒)來refresh
            }
            function changePwdHandler(theCheckBox) {
                if ($(theCheckBox).prop("checked")) {
                    $("#changePwdFieldSet").removeClass("disabled");
                    $("#changePwdFieldSet>input").prop("disabled", false);
                } else {
                    $("#changePwdFieldSet").addClass("disabled");
                    $("#changePwdFieldSet>input").prop("disabled", true);
                    $("#changePwdFieldSet>input").val("");
                }
            }
            $(function () {
                changePwdHandler(${"changePwd"});
            });
        </script>
    </head>
    <body>
        <div class="registerbg">
            <jsp:include page="/WEB-INF/subviews/header.jsp"/>
            <div style="min-height: 700px;width: 500px;height:700px;min-width: 500px;position: absolute;left: 50%;top: 100px;margin-left:-250px;background-color:rgba(255, 255, 255, 0.9);;padding:0 20px" >
                <div class="header" >
                    <h1>
                        <a href="<%=request.getContextPath()%>"><img src="<%=request.getContextPath()%>/images/member.png" alt="TripFruit" style="vertical-align: middle;"/></a><br>
                    </h1>
                </div><br>
                <form method="POST" action='update.do' style="width: 400px;">
                    <label style="color: red;">
                    <%
                        Member member = (Member) session.getAttribute("member");
                        List<String> errors = (List<String>) request.getAttribute("errors");
                        if (errors != null && errors.size() > 0) {
                            out.print(errors);
                        }
                    %></label>
                    <p>
                        <label>帳號:</label>
                        <input type='email' required disabled style="width: 300px;"  placeholder='請輸入Email' value='<%=member.getEmail()%>'>
                    </p> 
                    <p>
                        <label>姓名:</label>
                        <input name='name' type='text' required placeholder='請輸入姓名' value='<%=request.getMethod().equals("GET") ? member.getName() : request.getParameter("name")%>'>
                    </p>
                    <p>
                        <label>密碼:</label>
                        <input type='password' name='pwd' placeholder='輸入原來的密碼完成修改' minlength="6" maxlength="20" ><br>                    
                    </p>
                    <fieldset style='margin-left: -1ex;width:35ex' class='disabled' id="changePwdFieldSet">
                        <legend><input type="checkbox" name="changePwd" id="changePwd" onchange="changePwdHandler(this)" ${empty param.changePwd?"":"checked"}>
                            <label for='changePwd'>我要改密碼</label></legend>
                        <label>新密碼:</label>
                        <input type='password' name='pwd1' placeholder='請輸入新的密碼' minlength="6" maxlength="20" style='width:27ex'><br>
                        <label>再確認:</label>
                        <input type='password' name='pwd2' placeholder='請再確認新的密碼' minlength="6" maxlength="20" style='width:27ex' disabled>
                    </fieldset>
                    <p>
                        <label>性別:</label>
                        <input type='radio' name='gender' id='male' value=<%=Member.MALE%> required 
                               <%= String.valueOf(Member.MALE).equals(request.getParameter("gender")) ? "checked" : (String.valueOf(Member.MALE).equals(String.valueOf(member.getGender())) ? "checked" : "")%>><label for='male'>男</label>
                        <input type='radio' name='gender' id='female' value=<%=Member.FEMALE%> required 
                               <%= String.valueOf(Member.FEMALE).equals(request.getParameter("gender")) ? "checked" : (String.valueOf(Member.FEMALE).equals(String.valueOf(member.getGender())) ? "checked" : "")%>><label for='female'>女</label>
                    </p>             
                    <p>
                        <label>生日:</label>
                        <input name='birthday' type='date' value='<%=request.getMethod().equals("GET") ? member.getBirthday() : request.getParameter("birthday")%>' required>
                    </p>         
                    <p>
                        <label>驗證碼:</label>
                        <input name='captcha' type='text' required style='width: 12em' placeholder='請依右圖輸入(不分大小寫)' autocomplete="off">
                        <a href="javascript:refreshCaptcha()" title="點選圖片即可更新">
                            <img id="captchaImage" src='<%=request.getContextPath()%>/images/captcha.jpeg' style="vertical-align: middle">
                        </a>
                        <br><br><br>
                    </p>
                    <input style="float: right" class="btn" type='submit' value="修改會員資料"><br><br><br>
                </form>
            </div>
        </div>
        <div id="loginBox"></div>
    </body>
</html>
