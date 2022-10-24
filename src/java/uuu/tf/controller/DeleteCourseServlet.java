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
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import uuu.tf.entity.Course;
import uuu.tf.entity.Schedule;
import uuu.tf.entity.TFException;
import uuu.tf.entity.TripDay;

/**
 *
 * @author Rapunzel_PC
 */
@WebServlet(name = "DeleteCourseServlet", urlPatterns = {"/delete_course.do"})
public class DeleteCourseServlet extends HttpServlet {

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
        //1.取得request中的parameter並檢查之
        HttpSession session = request.getSession();
        Schedule schedule = (Schedule) session.getAttribute("schedule");
        String date = request.getParameter("date");
        String courseHashCode = request.getParameter("course");
        if (schedule == null || schedule.isEmpty()) {
            errors.add("行程為空值");
        }
        if (date == null || date.length() == 0) {
            errors.add("日期為空值");
        }
        if (courseHashCode == null || !courseHashCode.matches("-?\\d+")) {
            errors.add("course不正確");
        }
        if (errors.isEmpty()) {
            Course course = null;
            for (TripDay day : schedule.getTripDayList()) {
                for (Course c : day.getTripCourse()) {
                    if (c.hashCode() == Integer.parseInt(courseHashCode)) {
                        course = c;
                    }
                }
            }
            try {
                schedule.removePlace(LocalDate.parse(date), course);
            } catch (TFException ex) {
                errors.add("刪除行程發生錯誤");
                this.log("刪除行程發生錯誤",ex);
            }catch (Exception ex) {
                errors.add("刪除行程發生非預期錯誤");
                this.log("刪除行程發生非預期錯誤",ex);
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