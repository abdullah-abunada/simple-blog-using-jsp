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
<%@ page import="java.util.Vector"%>

<%

    if(session.getAttribute("hasAccess") == null || !session.getAttribute("hasAccess").equals("1")){
       JSONObject json = new JSONObject();
       json.put("message", "You don't have access");
       json.put("status_code", 404);
       out.print(json.toString());
       return;
    }

    String conf = pageContext.getServletContext().getRealPath("/WEB-INF/config.txt");
    if(request.getParameter("id") != null && !request.getParameter("id").isEmpty()){

        int id = Integer.parseInt(request.getParameter("id"));

        PostsBean postsBean = new PostsBean(conf);
        postsBean.setAdmin(true);
        postsBean.setId(id);

        // check if this post is exist
        if(postsBean.isExist()){
            // check if this post is exist
            Vector v  =postsBean.getPost();
            //convert post vector to json object
            JSONObject data = new JSONObject();
            data.put("id", v.elementAt(0));
            data.put("title", v.elementAt(1));
            data.put("body", v.elementAt(2));
            //create json responce message
            JSONObject json = new JSONObject();
            json.put("post", data);
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
             json.put("message", "Pleas pass correct post value");
             json.put("status_code", 400);
             out.print(json.toString());
    }

%>