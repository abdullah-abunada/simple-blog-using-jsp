<%--
  Created by IntelliJ IDEA.
  User: abdullah
  Date: 11/30/2016
  Time: 8:37 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
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
    if(request.getParameter("id") != null){

        int id = Integer.parseInt(request.getParameter("id"));

        PostsBean postsBean = new PostsBean(conf);
        postsBean.setId(id);
        postsBean.setAdmin(Boolean.parseBoolean(session.getAttribute("isAdmin").toString()));
        postsBean.setUser_id(Integer.parseInt(session.getAttribute("userID").toString()));
        // check if this post is exist
        if(postsBean.isExist()){
            // check if this post is exist
            postsBean.deletePost();
            //create json responce message
            JSONObject json = new JSONObject();
            json.put("message", "The post has been deleted successfully");
            json.put("status_code", 200);
            out.print(json.toString());
        }else{
             JSONObject json = new JSONObject();
             json.put("message", "This post is not exist!");
             json.put("status_code", 404);
             out.print(json.toString());
        }
    }else {
             JSONObject json = new JSONObject();
             json.put("message", "Please Enter valid post id!");
             json.put("status_code", 400);
             out.print(json.toString());
    }

%>