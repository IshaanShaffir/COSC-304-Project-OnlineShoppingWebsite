<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>


<%
getConnection();

String idStr = request.getParameter("id");
int id = Integer.parseInt(idStr);
con.createStatement().execute("USE orders");
PreparedStatement pstmt6 = con.prepareStatement("DELETE FROM product WHERE productId = ?");
pstmt6.setString(1,idStr);
pstmt6.executeUpdate();


closeConnection();
%>

<meta http-equiv="refresh" content="0; url=admin.jsp" />

<p><a href="admin.jsp">Redirect</a></p>

