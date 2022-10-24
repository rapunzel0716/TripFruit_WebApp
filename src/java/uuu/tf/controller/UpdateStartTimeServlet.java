/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package uuu.tf.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.LocalTime;
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

/**
 *
 * @author Rapunzel_PC
 */
@WebServlet(name = "UpdateStartTimeServlet", urlPatterns = {"/update_starttime.do"})
public class UpdateStartTimeServlet extends HttpServlet {

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
        HttpSession session = request.getSession();
        Schedule s = (Schedule)session.getAttribute("schedule");
        String date = request.getParameter("date");
        String time = request.getParameter("time");
        if(s==null){
            errors.add("行程不可為null");
        }
        if(date==null){
            errors.add("日期不可為null");
        }
        if(time==null || time.isEmpty()){
            errors.add("開始時間不可為null");
        }
        if(errors.isEmpty()){
             try {
                 LocalDate setdate = LocalDate.parse(date);
                 LocalTime startTime = LocalTime.parse(time);
                 
                 s.updateStarTime(setdate, startTime);
                 
             } catch (TFException ex) {
                 this.log("設定開始時間發生錯誤",ex);
                errors.add("設定開始時間發生錯誤"+ex);
             }catch (Exception ex) {
                 this.log("設定開始時間發生非預期錯誤",ex);
                errors.add("設定開始時間發生非預期錯誤"+ex);
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
