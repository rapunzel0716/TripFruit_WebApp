<%-- 
    Document   : header
    Created on : 2019/3/17, 下午 09:11:51
    Author     : Rapunzel_PC
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="uuu.tf.entity.Member"%>
<%
    Member member = (Member) session.getAttribute("member");
%>
<!--menu-->
<header style="width: 100%;position: relative;float:left;z-index: 5;">
    <nav class="navdiv">
        <ul>
            <li><a href="<%=request.getContextPath()%>"><img style="height: 40px;" src="<%=request.getContextPath()%>/images/logo3.png"></a></li>
            <li><a href="<%=request.getContextPath()%>/tripseek.jsp"><span>規劃行程</span></a></li>
                <%if (member != null) {%>            
            <li><a href="<%=request.getContextPath()%>/member/mytrip.jsp"><span>我的旅程</span></a></li><%}%>
        </ul>
        <ul class="navul2">
            <%if (member == null) {%>            
            <li><a class="login" href="javascript:login()"><span>登入</span></li>
            <li id="register"><a href="<%=request.getContextPath()%>/register.jsp"><span>註冊</span></a></li>
                <%} else {%>
            <li><a href="<%=request.getContextPath()%>/logout.do"><span>登出</span></a></li>
            <li><a href="<%=request.getContextPath()%>/member/update.jsp"><span>會員資料</span></a></li>
                <%}%>
        </ul>
    </nav>
        
</header>
                <div id="loginBox"></div>
<%session.setAttribute("provide_url", request.getRequestURI());%>
