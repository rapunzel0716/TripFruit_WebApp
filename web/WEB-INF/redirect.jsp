<%-- 
    Document   : redirect
    Created on : 2019/4/12, 下午 05:03:05
    Author     : Admin
--%>

<%@page contentType="application/javascript" pageEncoding="UTF-8"%>
var dataObj={
    redirect: true,
    url: "<%= request.getAttribute("redirect_url") %>"
}
