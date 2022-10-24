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
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import uuu.tf.entity.Member;

/**
 *
 * @author Admin
 */
@WebFilter(filterName = "LoginCheckFilter", urlPatterns = {"/member/*"})
public class LoginCheckFilter implements Filter {
    private FilterConfig filterConfig;
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        this.filterConfig=filterConfig;
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest)request;//轉型為HttpServletRequest
        HttpServletResponse httpRespones = (HttpServletResponse)response;//轉型HttpServletResponse
        
        HttpSession session = httpRequest.getSession();
        Member member = (Member)session.getAttribute("member");
        if(member!=null)
            chain.doFilter(request, response);
        else{
            httpRespones.sendRedirect(httpRequest.getContextPath());
        }
    }

    @Override
    public void destroy() {
       this.filterConfig=null;
    }
    
    
}
