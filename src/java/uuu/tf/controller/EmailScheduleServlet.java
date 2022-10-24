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
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import uuu.tf.entity.Member;
import uuu.tf.entity.TFException;
import uuu.tf.model.MailService;

/**
 *
 * @author Admin
 */
@WebServlet(name = "EmailScheduleServlet", urlPatterns = {"/member/mail_schedule.do"})
public class EmailScheduleServlet extends HttpServlet {

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
        //1.取得request中的parameter並檢查之
        List<String> errors = new ArrayList<>();
        HttpSession session = request.getSession();
        Member member = (Member) session.getAttribute("member");
        String scheduleId = request.getParameter("scheduleId");
        if(scheduleId == null){
            errors.add("scheduleId不得為空值");
        }
        if(!scheduleId.matches("\\d+")){
            errors.add("scheduleId不符合規定");
        }
        //2.若無誤，執行商業邏輯
        if(errors.isEmpty()){
            try {
                MailService.sendHelloMailWithLogo(member.getEmail(),scheduleId);
                
            } catch (TFException ex) {
                this.log("寄送行程發生錯誤",ex);
                errors.add("寄送行程發生錯誤");
            }catch (Exception ex) {
                this.log("寄送行程發生非預期錯誤",ex);
                errors.add("寄送行程發生非預期錯誤");
            }
        }
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
