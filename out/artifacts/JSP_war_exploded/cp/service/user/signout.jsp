<%--
  Created by IntelliJ IDEA.
  User: abdullah
  Date: 12/3/2016
  Time: 12:15 PM
  To change this template use File | Settings | File Templates.
--%>
<%
    session.invalidate();
    String url = "http://" + request.getServerName() + ":" + request.getServerPort() + "/cp/index.jsp";
    response.setStatus(response.SC_MOVED_TEMPORARILY);
    response.setHeader("Location", url);

%>
