/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package uuu.tf.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalTime;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import uuu.tf.entity.Place;
import uuu.tf.entity.Schedule;
import uuu.tf.entity.TFException;
import uuu.tf.model.PlaceService;

/**
 *
 * @author Rapunzel_PC
 */
@WebServlet(name = "AddPlaceToScheduleServlet", urlPatterns = {"/add_course.do"})
public class AddPlaceToScheduleServlet extends HttpServlet {

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
        HttpSession session = request.getSession();
        Schedule schedule = (Schedule) session.getAttribute("schedule");
        String placeId = request.getParameter("coursePlaceid");
        String[] days= request.getParameterValues("selectday");
        String hours = request.getParameter("stayHour");
        String minute = request.getParameter("stayMinute");

        if (hours == null || minute == null) {
            this.log("行程新增景點失敗 hours minute 為null");
            return;
        }
        if (!(hours.matches("\\d+") && minute.matches("\\d+"))) {
            this.log("行程新增景點失敗 hours minute 不是數字"+hours+minute);
            return;
        }
        if (days == null || days.length == 0) {
            this.log("行程新增景點失敗 days沒有值"+days);
            return;
        }
        //2.若無誤，呼叫商業邏輯
        PlaceService pservice = new PlaceService();
        try {
            Place p = pservice.getPlaceById(placeId);

            if (schedule != null && p != null) {
                for (String day : days) {
                    int x = Integer.parseInt(day);
                    int y = Integer.parseInt(hours)*60;
                    int z = Integer.parseInt(minute) + y;
                    schedule.addPlaceToDate(x, p, LocalTime.parse("08:00"), z, 0,null);
                }
            }
        } catch (TFException ex) {
            this.log("行程新增景點發生錯誤" + ex);
            return;
        }catch (Exception ex) {
            this.log("行程新增景點發生非預期錯誤" + ex);
            return;
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
