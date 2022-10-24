<%-- 
    Document   : global
    Created on : 2019/3/17, 下午 09:16:14
    Author     : Rapunzel_PC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<link rel="shortcut icon" href="favicon.ico">
<link href="<%=request.getContextPath()%>/fancybox/jquery.fancybox.css" rel="stylesheet" type="text/css"/>
<script src="<%=request.getContextPath()%>/files/jquery.js"></script>
<script src="<%=request.getContextPath()%>/fancybox/jquery.fancybox.js"></script>

<link href="<%=request.getContextPath()%>/files/jquery-ui.css" rel="stylesheet" type="text/css"/>
<script src="<%=request.getContextPath()%>/files/jquery-ui.js" type="text/javascript"></script>

<script>
    function login() {
        //同步GET請求
        //location.href = "login.jsp";
        //非同步GET請求

        var xhr = $.ajax({
            url: '<%=request.getContextPath()%>/login.jsp',
            method: 'GET',
        }).done(loginDoneHandler);

    }
    function loginDoneHandler(result, status, xhr) {
        $("#loginBox").html(result);
        $.fancybox.open({
            src: "#loginBox"
        });
    }
</script>
<style type="text/css">
    @import url(https://fonts.googleapis.com/earlyaccess/notosanstc.css);
    *{-webkit-box-sizing: border-box;-moz-box-sizing: border-box;box-sizing: border-box;    font-family: Microsoft JhengHei,"Microsoft JhengHei", "PT Sans", Helvetica, Arial, sans-serif;
    }
    body{margin: 0px;}
    div{display: block;}
    nav{
        /*box-shadow:0px 0px 5px black;*/border-bottom: 1px solid #afafaf;border-radius:3px;background: #f7f7f7;min-width: 400px;float: left;width: 100%;
    }
    nav ul{
        margin: 0px 0px 0px -20px;list-style: none;height: 40px;float: left;
    }
    .navul2{               
        float: right;margin: 0px 10px 0px 0px;padding: 0;
    }
    nav ul li{
        float: left;padding: 0px 10px;
    }
    nav ul li span{
        float: left;padding: 10px 5px;height: 40px;
    }
    nav a{text-decoration: none; height: 40px;}
    nav a:link{color: black;}
    nav a:visited{color: black;}
    nav a:hover{
        color: #c17d41;
        text-decoration: underline;
    }
    a {
        text-decoration: none;
        color: black;
    }
    .member{
        display: none;
    }
    .button {
        background-color: #3b5998; 
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
    .button:active {
        transform: translateY(4px);
    }
    
    .close{
        height: 35px;
        width: 30px;
        background-image: url(<%=request.getContextPath()%>/images/icons/close.png);
        background-size: cover;
        cursor: pointer;
        float: right;
    }
</style>
