<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>


<%
getConnection();

String idStr = request.getParameter("id");
String name = request.getParameter("name");
String price = request.getParameter("price");
String productDesc = request.getParameter("productDesc");
String category = request.getParameter("category");
con.createStatement().execute("USE orders");
PreparedStatement pstmt6 = con.prepareStatement("UPDATE product SET productName=?, productPrice=?, productDesc=?, categoryId=? WHERE productId = ?");
pstmt6.setString(5,idStr);
pstmt6.setString(1, name);
pstmt6.setString(2, price);
pstmt6.setString(3, productDesc);
pstmt6.setString(4, category);
pstmt6.executeUpdate();


closeConnection();
%>

<meta http-equiv="refresh" content="0; url=admin.jsp" />

<p><a href="admin.jsp">Redirect</a></p>