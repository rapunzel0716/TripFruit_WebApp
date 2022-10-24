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
import java.util.LinkedList;
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
@WebServlet(name = "SortableScheduleServlet", urlPatterns = {"/sortable_schedule.do"})
public class SortableScheduleServlet extends HttpServlet {

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
        LocalDate data = LocalDate.parse(request.getParameter("date"));//排序的日期
        String list[] = request.getParameter("list").split(",");//排序後的順序
        List<Course> courseList = new LinkedList<>();
        HttpSession session = request.getSession();
        Schedule schedule = (Schedule) session.getAttribute("schedule");
        if (schedule == null || schedule.isEmpty()) {
            return;
        }
        for (int i = 0; i < list.length; i++) {
            try {
                courseList.add(schedule.getCourse(data, Integer.parseInt(list[i])));//將行程依排序後的順序，拿出來放在courseList
            } catch (TFException ex) {
                this.log("取得時程錯誤", ex);
            } catch (Exception ex) {
                this.log("取得時程發生非預期錯誤", ex);
            }
        }

        if (courseList.size() > 0) {
            try {
                LocalTime startTime = schedule.getDayStartTime(data);
                schedule.clearCourse(data);
                for (Course course : courseList) {
                    schedule.addPlaceToDate(data, course.getPlace(), startTime, course.getStay(), 0, course.getRouteType().toString());
                }
            } catch (TFException ex) {
                this.log("重新排程發生錯誤", ex);
            } catch (Exception ex) {
                this.log("重新排程發生非預期錯誤", ex);
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
