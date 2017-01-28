<%@ page import="up.project.jsp.UsersBean" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Vector" %><%--
  Created by IntelliJ IDEA.
  User: abdullah
  Date: 12/3/2016
  Time: 8:20 AM
  To change this template use File | Settings | File Templates.
--%>
<%
    String conf = pageContext.getServletContext().getRealPath("/WEB-INF/config.txt");
    if(!request.getParameter("email").isEmpty() && !request.getParameter("password").isEmpty()){
        //create userBean object
        UsersBean usersBean= new UsersBean(conf);
        //set required data and call login function
        usersBean.setEmail(request.getParameter("email"));
        usersBean.setPassword(request.getParameter("password"));
        if(usersBean.logIn()){
            //create json responce message
            JSONObject json = new JSONObject();
            json.put("message", "You are registered successfully");
            json.put("status_code", 201);
            out.print(json.toString());
            //set session data

            Vector userData = usersBean.getUserByEmail();
            session.setAttribute("fullName",userData.elementAt(3)+" "+userData.elementAt(4));
            //convert int to boolean
            int admin = Integer.parseInt(userData.elementAt(6).toString());
            if(admin == 1){
                session.setAttribute("isAdmin", "true");
            }else{
                session.setAttribute("isAdmin", "false");
            }
            session.setAttribute("userID", userData.elementAt(0));
            session.setAttribute("avatar", userData.elementAt(5));
            session.setAttribute("hasAccess", "1");
            /* Redirect with jsp code
            String url = "http://"+request.getServerName()+":"+request.getServerPort()+"/cp/posts.jsp";
            response.setStatus(response.SC_MOVED_TEMPORARILY);
            response.setHeader("Location", url);
            */
        }else{
            //if email and password are not match
            ArrayList errors = new ArrayList();
            errors.add("Please Enter Correct UserName Or Password");
            JSONObject json = new JSONObject();
            json.put("error", errors);
            json.put("status_code", 400);
            out.print(json.toString());
        }
    }else{
        //validate the required fields
        ArrayList errors = new ArrayList();
        if(request.getParameter("email").isEmpty()){
            errors.add("Email field is required");
        }
        if(request.getParameter("password").isEmpty()){
            errors.add("Password field is required");
        }
        JSONObject json = new JSONObject();
        json.put("error", errors);
        json.put("status_code", 400);
        out.print(json.toString());
    }

%>