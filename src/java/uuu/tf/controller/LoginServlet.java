/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package uuu.tf.controller;

import java.awt.List;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import uuu.tf.entity.Member;
import uuu.tf.entity.TFException;
import uuu.tf.model.MemberService;

/**
 *
 * @author Rapunzel_PC
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login.do"}, loadOnStartup = 1)//loadOnStartup = 1 在server開啟時 此servlet就建立，順序為1
public class LoginServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        java.util.List<String> errors = new ArrayList<>();
        //1.取得request中的parameter並檢查之
        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");
        String pwd = request.getParameter("pwd");
        String captcha = request.getParameter("captcha");
        String auto = request.getParameter("auto");//自動記住帳號
        //檢查 email, pwd, captcha為必要欄位
        if ((email == null) || email.length() == 0) {
            errors.add("必須輸入E-MAIL");
        }
        if ((pwd == null) || pwd.length() == 0) {
            errors.add("必須輸入密碼");
        }
        if (captcha == null || captcha.length() == 0) {
            errors.add("必須輸入驗證碼");
        } else {
            String oldCaptcha = (String) session.getAttribute("captcha");
            if (!captcha.equalsIgnoreCase(oldCaptcha)) {
                errors.add("驗證碼不正確");
            }
        }
        session.removeAttribute("captcha");

        if (errors.isEmpty()) {
            //2.呼叫MemberService的login
            MemberService service = new MemberService();

            try {
                Member m = service.login(email, pwd);
                Cookie idCookie = new Cookie("email", email);
                Cookie autoCookie = new Cookie("auto", "checked");
                if (auto == null) {//使用者選擇不要記住
                    //setMaxAge設定cookie保存時間,時間為秒數
                    idCookie.setMaxAge(0);
                    autoCookie.setMaxAge(0);
                } else {//使用者選擇要記住                    
                    idCookie.setMaxAge(7 * 24 * 60 * 60);
                    autoCookie.setMaxAge(7 * 24 * 60 * 60);
                }
                response.addCookie(idCookie);
                response.addCookie(autoCookie);

                //將m命名為member 存在session裡 
                session.setAttribute("member", m);
                //3.1 redirect 首頁 sendRedirect外部呼叫
                //response.sendRedirect(request.getContextPath());

                String url = (String) session.getAttribute("provide_url");
                session.removeAttribute("provide_url");
                if (url != null && url.length() > 0) {
                    //response.sendRedirect(url);
                } else {
                    //response.sendRedirect(request.getContextPath());
                    url=request.getContextPath();
                }
                request.setAttribute("redirect_url", url);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/redirect.jsp");
                dispatcher.forward(request, response);
                return;
                
            } catch (TFException ex) {
                this.log("登入發生錯誤:", ex);
                if (ex.getCause() != null) {
                    errors.add(ex.getMessage() + "請聯絡系統管理人員");
                } else {
                    errors.add(ex.getMessage());
                }
            } catch (Exception ex) {
                this.log("登入發生非預期錯誤:", ex);
                errors.add("登入發生非預期錯誤:" + ex.toString());
            }

        }
        //3.2.將errors的錯誤傳去login.jsp  forward到網頁login.jsp
        request.setAttribute("errors", errors);
        RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
        dispatcher.forward(request, response);
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
