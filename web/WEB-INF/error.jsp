<%-- 
    Document   : error
    Created on : 2019/3/12, 下午 06:06:32
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>錯誤訊息</title>
        <%@include file="/WEB-INF/subviews/global.jsp" %>
        <style>
            html, body {height: 100%;}
            
        </style>
        <script>
            var s1 = "block";
            var s2 = "width:80%;display:blocked;font-size:60%;color:blue";
            function show_details() {
                var d = document.getElementById("details");
                try {
                    d.style.setAttribute("display", s1);
                    if (s1 == "none") {
                        s1 = "block";
                    } else {
                        s1 = "none";
                    }
                } catch (err) {
                    d.setAttribute("style", (s2 == null ? "width:80%;display:none;" : s2));
                    if (s2 == null) {
                        s2 = "width:80%;display:blocked;font-size:60%;color:blue";
                    } else {
                        s2 = null;
                    }
                }
            }
        </script>
    </head>
    <body>
        <div style="width:100vw;height: 100vh;">
            <jsp:include page="/WEB-INF/subviews/header.jsp"/>
            <div>            
                <div style="font-size: 26px;">
                    執行<span style='color:darkred'><%= request.getAttribute("javax.servlet.error.request_uri")%></span>時發生下列錯誤：                
                </div>
                <p style='font-size:80%'>
                    <% if (exception != null) {
                        out.println(exception.getClass().getName() + ":\t" + exception.getMessage());%>
                    <a href="javascript:show_details()">details...</a><br/>
                    <span id='details' style="width:60%;display:none;color:blue">
                        <%
                            exception.printStackTrace(new java.io.PrintWriter(out));
                        %>
                    </span>
                    <% } else {%>          
                    <img style='width:500px;margin: auto;display:block' 
                         src='<%= request.getContextPath()%>/images/<%= request.getAttribute("javax.servlet.error.status_code")%>.png'>                
                    <%}%>
                </p>
            </div>
        </div>
    </body>
</html>
