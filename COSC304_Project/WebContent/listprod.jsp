<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Titan Tech Store</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%@ include file="header.jsp" %>

<h2>Browse Products By Category and Search by Product Name:</h2>

<form method="get" action="listprod.jsp">
  <p align="left">
  <select size="1" name="categoryName">
  <option>All</option>

<%

// Could create category list dynamically - more adaptable, but a little more costly
try               
{
	String name = request.getParameter("categoryName");
	
	getConnection();
	Statement stmt2 = con.createStatement(); 			
	stmt2.execute("USE orders");
	Statement stmt = con.createStatement();
 	ResultSet rst = stmt.executeQuery("SELECT DISTINCT categoryName FROM category JOIN product ON category.categoryId=product.categoryId");
    while (rst.next()){
		String category = rst.getString(1);
		String outStr;
		if(name!=null && name.equals(category)){
			outStr = "<option value=\""+category+"\" selected=\"selected\">" + category + "</option>";
		}else{
			outStr="<option value=\""+category+"\">"+category + "</option>";
		}
		
		out.println(outStr);
	}
			
	closeConnection();
}
catch (SQLException ex)
{       out.println(ex);
}

%>
<!--
  <option>Beverages</option>
  <option>Condiments</option>
  <option>Confections</option>
  <option>Dairy Products</option>
  <option>Grains/Cereals</option>
  <option>Meat/Poultry</option>
  <option>Produce</option>
  <option>Seafood</option>    
-->   
  </select>
  <input type="text" name="productName" size="50">
  <input type="submit" value="Submit"><input type="reset" value="Reset"></p>
</form>

<%
// Colors for different item categories
HashMap<String,String> colors = new HashMap<String,String>();		// This may be done dynamically as well, a little tricky...
	colors.put("Pre-Builts", "#3366FF");         // Light Blue
	colors.put("Graphic Cards", "#FF3333");      // Bright Red
	colors.put("Motherboards", "#333333");       // Dark Gray
	colors.put("Ram Kits", "#9933CC");           // Medium Purple
	colors.put("Power Supply Units", "#33A3B3"); // Teal Blue
	colors.put("CPUs", "#FF6600");              // Bright Orange
	colors.put("Cooling", "#33CC33");           // Fresh Green
	colors.put("Cases", "#FF66B3");             // Light Pink
	colors.put("Peripherals", "#FFCC00");       // Yellow
	colors.put("Storage", "#9966FF");           // Light Purple
	colors.put("Monitors", "#00CC99");          // Turquoise
%>

<%
// Get product name to search for
String name = request.getParameter("productName");
String category = request.getParameter("categoryName");

boolean hasNameParam = name != null && !name.equals("");
boolean hasCategoryParam = category != null && !category.equals("") && !category.equals("All");
String filter = "", sql = "";

if (hasNameParam && hasCategoryParam)
{
	filter = "<h3>Products containing '"+name+"' in category: '"+category+"'</h3>";
	name = '%'+name+'%';
	sql = "SELECT P.productId, productName, productPrice, categoryName FROM Product P JOIN Category C ON P.categoryId = C.categoryId LEFT JOIN orderproduct OP ON OP.productId = P.productId WHERE productName LIKE ? AND categoryName = ? GROUP BY P.productId,P.productName,P.productPrice,C.categoryName ORDER BY SUM(OP.quantity)";
}
else if (hasNameParam)
{
	filter = "<h3>Products containing '"+name+"'</h3>";
	name = '%'+name+'%';
	sql = "SELECT P.productId, productName, productPrice, categoryName FROM Product P JOIN Category C ON P.categoryId = C.categoryId LEFT JOIN orderproduct OP ON OP.productId = P.productId WHERE productName LIKE ? GROUP BY P.productId,P.productName,P.productPrice,C.categoryName ORDER BY SUM(OP.quantity)";
}
else if (hasCategoryParam)
{
	filter = "<h3>Products in category: '"+category+"'</h3>";
	sql = "SELECT P.productId, productName, productPrice, categoryName FROM Product P JOIN Category C ON P.categoryId = C.categoryId LEFT JOIN orderproduct OP ON OP.productId = P.productId WHERE categoryName = ? GROUP BY P.productId,P.productName,P.productPrice,C.categoryName ORDER BY SUM(OP.quantity)";
}
else
{
	filter = "<h3>All Products</h3>";
	sql = "SELECT P.productId, productName, productPrice, categoryName FROM Product P JOIN Category C ON P.categoryId = C.categoryId LEFT JOIN orderproduct OP ON OP.productId = P.productId GROUP BY P.productId,P.productName,P.productPrice,C.categoryName ORDER BY SUM(OP.quantity)";
}

out.println(filter);

NumberFormat currFormat = NumberFormat.getCurrencyInstance();

try 
{
	getConnection();
	Statement stmt = con.createStatement(); 			
	stmt.execute("USE orders");
	
	PreparedStatement pstmt = con.prepareStatement(sql);
	if (hasNameParam)
	{
		pstmt.setString(1, name);	
		if (hasCategoryParam)
		{
			pstmt.setString(2, category);
		}
	}
	else if (hasCategoryParam)
	{
		pstmt.setString(1, category);
	}
	
	ResultSet rst = pstmt.executeQuery();
	
	out.print("<font face=\"Century Gothic\" size=\"2\"><table class=\"table\" border=\"1\"><tr><th class=\"col-md-1\"></th><th>Product Name</th>");
	out.println("<th>Category</th><th>Price</th></tr>");
	while (rst.next()) 
	{
		int id = rst.getInt(1);
		out.print("<td class=\"col-md-1\"><a href=\"addcart.jsp?id=" + id + "&name=" + rst.getString(2)
				+ "&price=" + rst.getDouble(3) + "\">Add to Cart</a></td>");

		String itemCategory = rst.getString(4);
		String color = (String) colors.get(itemCategory);
		if (color == null)
			color = "#FFFFFF";

		out.println("<td><a href=\"product.jsp?id="+id+"\"<font color=\"" + color + "\">" + rst.getString(2) + "</font></td>"
				+ "<td><font color=\"" + color + "\">" + itemCategory + "</font></td>"
				+ "<td><font color=\"" + color + "\">" + currFormat.format(rst.getDouble(3))
				+ "</font></td></tr>");
	}
	out.println("</table></font>");
	closeConnection();
} catch (SQLException ex) {
	out.println(ex);
}
%>

</body>
</html>

