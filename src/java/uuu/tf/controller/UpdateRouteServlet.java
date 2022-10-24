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
import uuu.tf.entity.Place;
import uuu.tf.entity.Schedule;
import uuu.tf.entity.TFException;
import uuu.tf.model.PlaceService;

/**
 *
 * @author Admin
 */
@WebServlet(name = "UpdateRouteServlet", urlPatterns = {"/update_route.do"})
public class UpdateRouteServlet extends HttpServlet {

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
        Schedule s = (Schedule)session.getAttribute("schedule");
        String date = request.getParameter("date");
        String placeId = request.getParameter("placeId");
        String startTime = request.getParameter("startTime");
        String route_type = request.getParameter("route_type");
        String route_hour = request.getParameter("route_hour");
        String route_minute = request.getParameter("route_minute");
        if(s==null){
            errors.add("行程不可為null");
        }
        if(date==null){
            errors.add("日期不可為null");
        }
        if(placeId==null){
            errors.add("placeId不可為null");
        }
        if(startTime==null){
            errors.add("startTime不可為null");
        }
        if(route_type==null){
            errors.add("route_type不可為null");
        }
        if(route_hour==null || !(route_hour.matches("\\d+"))){
            route_hour = "0";
        }
        if(route_minute==null || !(route_minute.matches("\\d+"))){
            route_minute = "0";
        }
        //3.如為errors空值
        if(errors.isEmpty()){
            PlaceService service = new PlaceService();
            try {
                Place p = service.getPlaceById(placeId);
                int hour = Integer.parseInt(route_hour);
                int minute = Integer.parseInt(route_minute);
                
                int second = (hour*60*60)+(minute*60);
                s.updateRouteTime(LocalDate.parse(date), p, LocalTime.parse(startTime), second, route_type);
                return;
            } catch (TFException ex) {
                this.log("設定路線發生錯誤",ex);
                errors.add("設定路線發生錯誤"+ex);
            }catch (Exception ex) {
                this.log("設定路線發生非預期錯誤",ex);
                errors.add("設定路線發生非預期錯誤"+ex);
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
