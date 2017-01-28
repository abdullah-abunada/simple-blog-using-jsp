<%--
  Created by IntelliJ IDEA.
  User: abdullah
  Date: 11/30/2016
  Time: 10:25 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="up.project.jsp.PostsBean" %>
<%@ page import="org.json.JSONObject" %>
<%
    if(session.getAttribute("hasAccess") == null || !session.getAttribute("hasAccess").equals("1")){
       JSONObject json = new JSONObject();
       json.put("message", "You don't have access");
       json.put("status_code", 404);
       out.print(json.toString());
       return;
    }

    String conf = pageContext.getServletContext().getRealPath("/WEB-INF/config.txt");
    //check if required parameters were passed
    if(!request.getParameter("title").isEmpty() && !request.getParameter("body").isEmpty()){
         //create postBean object
         PostsBean postsBean = new PostsBean(conf);
         //set required data and call addPost function
         postsBean.setTitle(request.getParameter("title"));
         postsBean.setBody(request.getParameter("body"));
         postsBean.setUser_id(Integer.parseInt(session.getAttribute("userID").toString()));
         postsBean.addPost();
         //create json responce message
         JSONObject json = new JSONObject();
         json.put("message", "The post has been added successfully");
         json.put("status_code", 201);
         out.print(json.toString());

    }else{
        //validate the required fields
        ArrayList errors = new ArrayList();
        if(request.getParameter("title").isEmpty()){
            errors.add("Title field is required");
        }
        if(request.getParameter("body").isEmpty()){
            errors.add("Body field is required");
        }
        JSONObject json = new JSONObject();
        json.put("error", errors);
        json.put("status_code", 400);
        out.print(json.toString());
    }
%>
