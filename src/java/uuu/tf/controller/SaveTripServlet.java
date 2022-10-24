/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package uuu.tf.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import uuu.tf.entity.Member;
import uuu.tf.entity.Schedule;
import uuu.tf.entity.TFException;
import uuu.tf.model.SchedulesService;

/**
 *
 * @author Admin
 */
@WebServlet(name = "SaveTripServlet", urlPatterns = {"/savetrip.do"})
public class SaveTripServlet extends HttpServlet {

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
        Schedule schedule = (Schedule) session.getAttribute("schedule");
        Member member = (Member) session.getAttribute("member");
        java.util.List<String> errors = new ArrayList<>();
        if (schedule==null || schedule.isEmpty()) {
            errors.add("行程為空值");
        }
        if (member == null) {
            errors.add("請先登入會員");
        }
        if (errors.isEmpty()) {
            schedule.setMember(member);
            SchedulesService service = new SchedulesService();
            try {
                if(schedule.getId()==0){
                    if(schedule.size()==0) schedule.addTripDay(LocalDate.now());
                    service.insert(schedule);
                }else{
                    if(schedule.size()==0) schedule.addTripDay(LocalDate.now());
                    service.updateSchedule(schedule);
                }
                int id=schedule.getId();
                request.setAttribute("success", "存檔成功");
                RequestDispatcher dispatcher = request.getRequestDispatcher("schedule.jsp");
                dispatcher.forward(request, response);
                return;
            } catch (TFException ex) {
                this.log("存入行程發生錯誤", ex);
                errors.add(ex.getMessage() + "請聯絡系統管理人員");
            } catch (Exception ex) {
                this.log("存入行程發生非預期錯誤:", ex);
                errors.add("存入行程發生非預期錯誤:" + ex.toString());
            }
        }

        request.setAttribute("errors", errors);
        RequestDispatcher dispatcher = request.getRequestDispatcher("schedule.jsp");
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
