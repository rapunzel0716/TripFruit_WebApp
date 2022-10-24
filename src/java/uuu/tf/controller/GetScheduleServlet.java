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
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import uuu.tf.entity.Schedule;
import uuu.tf.entity.TFException;
import uuu.tf.model.SchedulesService;

/**
 *
 * @author Admin
 */
@WebServlet(name = "GetScheduleServlet", urlPatterns = {"/member/getschedule.do"})
public class GetScheduleServlet extends HttpServlet {

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
        List<String> errors = new ArrayList<>();
        //1.讀取request  scheduleId 並檢查
        HttpSession session = request.getSession();
        String scheduleId = (String) request.getParameter("scheduleId");
        //檢查scheduleId
        if (scheduleId == null) {
            errors.add("行程id不能為空值");
        }
        if (!scheduleId.matches("\\d+")) {
            errors.add("行程id必須是數字");
        }

        if (errors.isEmpty()) {
            try {
                SchedulesService service = new SchedulesService();
                Schedule s = service.getScheduleById(Integer.parseInt(scheduleId));
                //刪除舊的
                session.removeAttribute("schedule");
                //將查出的行程放入session
                session.setAttribute("schedule", s);
            } catch (TFException ex) {
                this.log("會員使用行程id查詢行程發生錯誤", ex);
                errors.add("查詢行程發生錯誤" + ex.getMessage());
            }catch (Exception ex) {
                this.log("會員使用行程id查詢行程發生非預期錯誤", ex);
                errors.add("查詢行程發生非預期錯誤" + ex.getMessage());
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
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        processRequest(request, response);
//    }

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
