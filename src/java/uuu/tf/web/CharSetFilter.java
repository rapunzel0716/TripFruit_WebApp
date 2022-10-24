/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package uuu.tf.web;

import java.io.IOException;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.annotation.WebInitParam;

/**
 *
 * @author Admin
 */
//@WebFilter(filterName = "CharSetFilter", urlPatterns = {"*.do", "*.jsp"}, initParams = {
//    @WebInitParam(name = "charset", value = "UTF-8")})
public class CharSetFilter implements Filter {
    private FilterConfig filterConfig;
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        this.filterConfig = filterConfig;//將設定檔的參數指派給屬性this.filterConfig 
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        String charset = filterConfig.getInitParameter("charset");
        if(charset==null) charset="UTF-8";
        //前置處理
        //處理請求及回應的編碼
        request.setCharacterEncoding(charset);
        request.getParameterNames();//鎖住編碼(使用此方法只為了鎖住編碼)
        
        response.setCharacterEncoding(charset);
        response.getWriter();//鎖住編碼(使用此方法只為了鎖住編碼)
        
        //交給下一棒
        chain.doFilter(request, response);
        
        //後續處理
        
        
    }

    @Override
    public void destroy() {
        this.filterConfig = null;//把所有屬性還原成初值        
    }
    
}
