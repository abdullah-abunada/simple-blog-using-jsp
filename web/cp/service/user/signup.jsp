<%--
  Created by IntelliJ IDEA.
  User: abdullah
  Date: 11/30/2016
  Time: 10:25 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="org.json.JSONObject" %>
<%@ page import="up.project.jsp.UsersBean"%>
<%
    String conf = pageContext.getServletContext().getRealPath("/WEB-INF/config.txt");
    //check if required parameters were passed
    if(!request.getParameter("email").isEmpty() && !request.getParameter("password").isEmpty()
    && !request.getParameter("first_name").isEmpty() && !request.getParameter("last_name").isEmpty()){
         //create userBean object
         UsersBean usersBean= new UsersBean(conf);
         //set required data and call addUser function
         usersBean.setEmail(request.getParameter("email"));
         usersBean.setPassword(request.getParameter("password"));
         usersBean.setFirstName(request.getParameter("first_name"));
         usersBean.setLastName(request.getParameter("last_name"));
         usersBean.addUser();
         //create json responce message
         JSONObject json = new JSONObject();
         json.put("message", "You are registered successfully");
         json.put("status_code", 201);
         out.print(json.toString());

    }else{
        //validate the required fields
        ArrayList errors = new ArrayList();
        if(request.getParameter("email").isEmpty()){
            errors.add("Email field is required");
        }
        if(request.getParameter("password").isEmpty()){
            errors.add("Password field is required");
        }
        if(request.getParameter("first_name").isEmpty()){
            errors.add("First name field is required");
        }
        if(request.getParameter("password").isEmpty()){
            errors.add("Last name field is required");
        }

        JSONObject json = new JSONObject();
        json.put("error", errors);
        json.put("status_code", 400);
        out.print(json.toString());
    }
%>
