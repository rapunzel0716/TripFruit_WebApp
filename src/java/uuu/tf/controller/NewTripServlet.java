/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package uuu.tf.controller;

import java.io.IOException;
import java.io.PrintWriter;
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
 * @author Admin
 */
@WebServlet(name = "NewTripServlet", urlPatterns = {"/member/newtrip.do"})
public class NewTripServlet extends HttpServlet {

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
        String name = request.getParameter("name");
        String date = request.getParameter("date");
        String days = request.getParameter("days");
        if (name == null || name.length() == 0) {
            return;
        }
        if (date == null || date.length() == 0) {
            return;
        }
        if (days == null || days.length() == 0 || !(days.matches("\\d+"))) {
            days = "1";
        }
        try {
            Schedule s = new Schedule();
            s.setTripName(name);
            s.addTripDay(date);
            int intdays = Integer.parseInt(days);
            for (int n = 1; n < intdays; n++) {
                s.addTripDay();
            }
            HttpSession session = request.getSession();
            //刪除舊的
            session.removeAttribute("schedule");
            //將查出的行程放入session
            session.setAttribute("schedule", s);

        } catch (TFException ex) {
            Logger.getLogger(NewTripServlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (Exception ex) {
            Logger.getLogger(NewTripServlet.class.getName()).log(Level.SEVERE, null, ex);
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
