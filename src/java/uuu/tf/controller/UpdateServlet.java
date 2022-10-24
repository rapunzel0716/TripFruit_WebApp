/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package uuu.tf.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
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
@WebServlet(name = "UpdateServlet", urlPatterns = {"/member/update.do"})
public class UpdateServlet extends HttpServlet {

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
        Member member = (Member) session.getAttribute("member");        
        List<String> errors = new ArrayList<>();
        //1.取得request中的parameter並檢查之
        request.setCharacterEncoding("UTF-8");
        String name = request.getParameter("name");
        String pwd = request.getParameter("pwd");
        String changePwd = request.getParameter("changePwd");
        String pwd1 = request.getParameter("pwd1");
        String pwd2 = request.getParameter("pwd2");
        String gender = request.getParameter("gender");
        String birthday = request.getParameter("birthday");
        String captcha = request.getParameter("captcha");
        //檢查 email, pwd, captcha為必要欄位
        
        
        if ((name == null) || name.length() == 0) {
            errors.add("必須輸入名字");
        }
        if (pwd == null || (!pwd.equals(member.getPassword()))) {
            errors.add("會員密碼不正確");
        }
        if(changePwd!=null){
            if (pwd1 == null || pwd1.length() < 6 || pwd1.length() > 20) {
                errors.add("必須輸入6~20字元密碼");
            } else if (!pwd1.equals(pwd2)) {
                errors.add("必須輸入6~20字元且一致的密碼與確認密碼");
            }
        }
//        if ((pwd1 == null) || pwd1.length() < 6 || pwd1.length() > 20) {
//            errors.add("必須輸入6~20個密碼");
//        }
//        if ((pwd2 == null) || !(pwd1.equals(pwd2))) {
//            errors.add("確認密碼與密碼不相符");
//        }
        if ((gender == null) || gender.length() != 1) {
            errors.add("必須選擇性別");
        }
        if ((birthday == null) || birthday.length() == 0) {
            errors.add("必須輸入生日");
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
        
        //設定回傳為html及設定編碼
        if (errors.isEmpty()) {
            try {
                //依會員資料 建立物件Member
                Member m = new Member();
                m.setUid(member.getUid());
                m.setName(name);
                m.setPassword(changePwd!=null?pwd1:member.getPassword());
                if (gender.equals("F")) {
                    m.setGender(Member.FEMALE);
                } else {
                    m.setGender(Member.MALE);
                }
                m.setEmail(member.getEmail());
                m.setBirthday(birthday);
                //2.呼叫MemberService的update
                MemberService service = new MemberService();
                service.update(m);
                
                //3.產生更新成功畫面
                //3.1.forward登入成功網頁update.jsp
//                request.setAttribute("member", m);//將c命名為member 存在request裡 
//                RequestDispatcher dispatcher = request.getRequestDispatcher("update.jsp");//找到派遣器 去update.jsp
//                dispatcher.forward(request, response);//執行派遣器,c藏在request一起傳去update.jsp
                //3.1 redirect tripseek.jsp sendRedirect外部呼叫
                session.setAttribute("member", m);
                response.sendRedirect(request.getContextPath()+"/member/update.jsp");
                return;
            } catch (TFException ex) {
                this.log("更新會員發生錯誤:", ex);
                errors.add(ex.getMessage());
            } catch (Exception ex) {
                this.log("更新會員發生非預期錯誤:", ex);
                errors.add("更新會員發生非預期錯誤:" + ex.toString());
            }
        }
        
        //3.2.將errors的錯誤傳去update.jsp  forward到網頁update.jsp
        request.setAttribute("errors", errors);
        request.getRequestDispatcher("update.jsp").forward(request, response);
//        RequestDispatcher dispatcher = request.getRequestDispatcher(request.getContextPath()+"/member/update.jsp");
//        dispatcher.forward(request, response);
//        response.sendRedirect(request.getContextPath()+"/member/update.jsp");
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
